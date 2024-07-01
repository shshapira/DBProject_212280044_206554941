CREATE OR REPLACE PROCEDURE CreateNewProjectAndAddPersons(
  cur IN SYS_REFCURSOR,
  v_projectName IN VARCHAR2
) AS
  v_projectID NUMBER;
  v_personID Person.personID%TYPE;
  v_personName Person.personName%TYPE;
  v_personRole Person.personRole%TYPE;
  v_personRank Person.personRank%TYPE;
  v_unitID Person.unitID%TYPE;
BEGIN
  -- Calculate the new project ID
  SELECT NVL(MAX(projectID), 0) + 1 INTO v_projectID FROM Projects;
  
  -- Insert new project record
  INSERT INTO Projects (projectID, projectName, beginDate, endDate, status, budget)
  VALUES (v_projectID, v_projectName, SYSDATE, ADD_MONTHS(SYSDATE, 18), 'start', 0);
  
  -- Insert persons into the new project
  LOOP
    FETCH cur INTO v_personID, v_personName, v_personRole, v_personRank, v_unitID;
    EXIT WHEN cur%NOTFOUND;
    
    INSERT INTO inProject (projectID, personID) VALUES (v_projectID, v_personID);
    
    DBMS_OUTPUT.PUT_LINE('Person ID: ' || v_personID || ', Name: ' || v_personName || 
                         ', Role: ' || v_personRole || ', Rank: ' || v_personRank);
  END LOOP;
  
  -- Print confirmation
  DBMS_OUTPUT.PUT_LINE('New project created with ID ' || v_projectID || ' and name ' || v_projectName);
  
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
    RAISE;  -- Re-raise the exception for further handling
END;
/
