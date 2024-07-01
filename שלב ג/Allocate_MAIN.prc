DECLARE
    TYPE unit_info_rec IS RECORD (
        unitID Unit.unitID%TYPE,
        unitName Unit.unitName%TYPE,
        projectCount NUMBER
    );
    
    v_unit_info unit_info_rec;
    v_unit_cursor SYS_REFCURSOR;
    v_resource_type Resources.resourcesType%TYPE := 'low level';
    v_total_units NUMBER := 0;
    v_processed_units NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting resource allocation process' || CHR(10));
    
    -- Get the list of units
    v_unit_cursor := GetUnitList();
    
    -- Count total units
    SELECT COUNT(*) INTO v_total_units FROM Unit;
    
    -- Process each unit
    LOOP
        FETCH v_unit_cursor INTO v_unit_info;
        EXIT WHEN v_unit_cursor%NOTFOUND;
        
        v_processed_units := v_processed_units + 1;
        
        DBMS_OUTPUT.PUT_LINE('Processing Unit ' || v_unit_info.unitID || ' - ' || v_unit_info.unitName);
        DBMS_OUTPUT.PUT_LINE('Projects: ' || v_unit_info.projectCount);
        
        -- Allocate resources for the unit
        AllocateResourcesForUnit(v_unit_info.unitID, v_resource_type);
        
        -- Progress update
        DBMS_OUTPUT.PUT_LINE('Progress: ' || v_processed_units || ' out of ' || v_total_units || ' units processed');
        DBMS_OUTPUT.PUT_LINE('--------------------' || CHR(10));
    END LOOP;
    
    CLOSE v_unit_cursor;
    
    DBMS_OUTPUT.PUT_LINE('Resource allocation process completed');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in MainProgram: ' || SQLERRM);
        RAISE;
END;
/
