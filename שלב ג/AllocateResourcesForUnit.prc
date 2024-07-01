CREATE OR REPLACE PROCEDURE AllocateResourcesForUnit(
    p_unitID IN Unit.unitID%TYPE,
    p_resourcesType IN Resources.resourcesType%TYPE
) IS
    TYPE unit_info_rec IS RECORD (
        unitID Unit.unitID%TYPE,
        projectCount NUMBER,
        isExcellent CHAR(1)
    );
    
    v_unit_info unit_info_rec;
    v_allocation_amount NUMBER;
    v_current_quantity NUMBER;
    v_update_amount NUMBER;
    
    CURSOR c_resources IS
        SELECT resourceID, quantity
        FROM Resources
        WHERE unitID = p_unitID AND resourcesType = p_resourcesType
        FOR UPDATE;
    
    insufficient_resources EXCEPTION;
BEGIN
    -- Get unit information
    SELECT u.unitID, COUNT(DISTINCT ip.projectID), NVL(MAX(e.have_money), 'F')
    INTO v_unit_info
    FROM Unit u
    LEFT JOIN Person p ON u.unitID = p.unitID
    LEFT JOIN inProject ip ON p.personID = ip.personID
    LEFT JOIN Excellence e ON u.unitID = e.unitID AND e.excellenceYear = EXTRACT(YEAR FROM SYSDATE)
    WHERE u.unitID = p_unitID
    GROUP BY u.unitID;

    -- Calculate allocation amount
    v_allocation_amount := FLOOR(v_unit_info.projectCount * 5);
    
    -- Add 10% if the unit is excellent
    IF v_unit_info.isExcellent = 'T' THEN
        v_allocation_amount := v_allocation_amount * 1.1;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Allocating ' || v_allocation_amount || ' resources to Unit ' || p_unitID);

    -- Allocate resources
    FOR r_resource IN c_resources LOOP
        v_current_quantity := r_resource.quantity;
        
        UPDATE Resources
        SET quantity = quantity + v_update_amount
        WHERE CURRENT OF c_resources;
        
        v_allocation_amount := v_allocation_amount - v_update_amount;
        
        EXIT WHEN v_allocation_amount <= 0;
    END LOOP;
    
    IF v_allocation_amount > 0 THEN
        RAISE insufficient_resources;
    END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Resource allocation completed for Unit ' || p_unitID);

EXCEPTION
    WHEN insufficient_resources THEN
        DBMS_OUTPUT.PUT_LINE('Error: Insufficient resources for Unit ' || p_unitID);
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in AllocateResourcesForUnit: ' || SQLERRM);
        ROLLBACK;
END;
/
