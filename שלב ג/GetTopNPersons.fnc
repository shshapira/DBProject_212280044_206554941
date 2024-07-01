CREATE OR REPLACE FUNCTION GetTopNPersons(N IN NUMBER) 
RETURN SYS_REFCURSOR IS
  cur SYS_REFCURSOR;
  total_count INTEGER;
BEGIN
  SELECT COUNT(*)
  INTO total_count
  FROM 
    Person p
  WHERE 
    (NOT EXISTS (
      SELECT 1
      FROM inProject ip
      JOIN Projects pr ON ip.projectID = pr.projectID
      WHERE 
        ip.personID = p.personID
        AND pr.status != 'end'
    )
    OR NOT EXISTS (
      SELECT 1 
      FROM inProject ip
      WHERE 
        ip.personID = p.personID
    ))
    AND p.unitID IN (
      SELECT unitID
      FROM (
        SELECT 
          unitID,
          COUNT(*) AS excellenceCount
        FROM 
          Excellence
        GROUP BY 
          unitID
        ORDER BY 
          excellenceCount DESC, 
          unitID ASC
      )
    );

  IF total_count < CEIL(N * 0.75) THEN
    DBMS_OUTPUT.PUT_LINE('Not enough persons to create a new project - there are ' || total_count || ' from ' || N);
    RETURN NULL;
  ELSE
    OPEN cur FOR
    SELECT 
      p.personID, 
      p.personName, 
      p.personRole, 
      p.personRank, 
      p.unitID
    FROM 
      Person p
    WHERE 
      (NOT EXISTS (
        SELECT 1 
        FROM inProject ip
        JOIN Projects pr ON ip.projectID = pr.projectID
        WHERE 
          ip.personID = p.personID
          AND pr.status != 'end'
      )
      OR NOT EXISTS (
        SELECT 1 
        FROM inProject ip
        WHERE 
          ip.personID = p.personID
      ))
      AND p.unitID IN (
        SELECT unitID
        FROM (
          SELECT 
            unitID,
            COUNT(*) AS excellenceCount
          FROM 
            Excellence
          GROUP BY 
            unitID
          ORDER BY 
            excellenceCount DESC, 
            unitID ASC
        )
      )
    ORDER BY 
      (SELECT COUNT(*) 
       FROM Excellence e 
       WHERE e.unitID = p.unitID) DESC,
      p.unitID ASC
    FETCH FIRST N ROWS ONLY;
    
    IF total_count >= N THEN
      DBMS_OUTPUT.PUT_LINE('Found ' || total_count || ' persons, but the top ' || N || ' requested.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Found ' || total_count || ' persons out of ' || N || ' were selected.');
    END IF;

    RETURN cur;
  END IF;
END;
/
