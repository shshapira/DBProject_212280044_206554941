DECLARE
  v_projectName VARCHAR2(100) := 'projectA';
  v_personCountNum NUMBER := 20;
  v_cur SYS_REFCURSOR;
BEGIN  
  -- Call function to get top N persons
  v_cur := GetTopNPersons(v_personCountNum);
  IF v_cur IS NOT NULL THEN
    CreateNewProjectAndAddPersons(v_cur, v_projectName);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
