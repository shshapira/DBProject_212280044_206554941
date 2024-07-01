CREATE OR REPLACE FUNCTION GetUnitList
RETURN SYS_REFCURSOR IS
    v_result_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_result_cursor FOR
        SELECT u.unitID, u.unitName, COUNT(DISTINCT ip.projectID) as projectCount
        FROM Unit u
        LEFT JOIN Person p ON u.unitID = p.unitID
        LEFT JOIN inProject ip ON p.personID = ip.personID
        GROUP BY u.unitID, u.unitName
        ORDER BY u.unitID;
    
    RETURN v_result_cursor;
END;
/
