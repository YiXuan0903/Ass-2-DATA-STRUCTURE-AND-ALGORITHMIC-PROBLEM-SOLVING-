/*
Format: G999_MemberName.sql

INDIVIDUAL ASSIGNMENT SUBMISSION

STUDENT NAME : TAN YI XUAN
STUDENT ID : 22ACB04266
GROUP NUMBER : G087
PROGRAMME : IA
Submission date and time: 29-04-25

SQL script to be submtted by each member, click save as "G999_MemberName.sql" e.g. G001_SmithWhite.sql

*/
-- This script contains 2 Queries, 2 Procedures, and 2 Functions

---------------------------------------------------------------------------Pre-Setup---------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON
-- ===================================================================================================================================================================================
--
-- 									   1. Queries
--
-- ===================================================================================================================================================================================
-----------------------------------------------------------------------------Query 1---------------------------------------------------------------------------------------------------
The query retrieves receipt details for orders placed by customers on a specific date, along with the customer name, order ID, receipt ID, order date time, total amount, discount applied, and the final amount after the discount.

SELECT
    r.receipt_id,
    r.order_id,
    c.cusName AS customer_name,
    o.order_DateTime,
    r.totalAmount,
    r.discountApplied,
    r.finalAmount
FROM Receipt r
JOIN orders o ON r.order_id = o.order_id
JOIN Customer c ON o.customer_id = c.customer_id
WHERE o.order_DateTime >= TO_DATE('05-04-25', 'DD-MM-YY')
  AND o.order_DateTime < TO_DATE('06-04-25', 'DD-MM-YY')
ORDER BY r.receipt_id;

------------------------------------------------------------------------------------Query 2-----------------------------------------------------------------------------------------------
This query retrieves a list of employees who are directly supervised by a specific supervisor, along with their employee details (employee ID, name, role, and supervisor ID). Display the employee who supervisor name is Adams.

SELECT 
    e.employee_id,
    e.empName,
    e.role,
    e.supervisor_id
FROM Employee e
JOIN Employee s ON e.supervisor_id = s.employee_id
WHERE UPPER(s.empName) = UPPER('Adams')
ORDER BY e.empName;

-- ========================================================================================================================================================================================
--
--								       2. PROCEDURES
-- ===========================================================================================================================================================================================
------------------------------------------------------------------------Procedure 1---------------------------------------------------------------------------------------------------------
This procedure allows employees to insert a new discount into the Discount table. Before inserting, the system checks whether a discount with the same name already exists. If no existing discount with the same name is found, the new discount is inserted; otherwise, a message is displayed indicating that the discount name already exists.

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE insert_discount(
    p_discountName VARCHAR2,
    p_discountType VARCHAR2,
    p_discountValue VARCHAR2,
    p_startDate DATE,
    p_endDate DATE
)
IS
    v_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Discount
    WHERE discountName = p_discountName;

    COMMIT;

    IF v_count = 0 THEN
        INSERT INTO Discount (discount_id, discountName, discountType, discountValue, startDate, endDate)
        VALUES (discount_seq.NEXTVAL, p_discountName, p_discountType, p_discountValue, p_startDate, p_endDate);

        DBMS_OUTPUT.PUT_LINE('Discount inserted successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Discount with this name already exists.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting discount promo.');
END;
/


---------------------------------------------------------Demo command to insert a new discount into the discount table--------------------------------------------------------------------

EXECUTE insert_discount('Hari Raya Promotion', 'Fixed Amount', 'RM10', TO_DATE('2025-03-10', 'YYYY-MM-DD'), TO_DATE('2025-06-10', 'YYYY-MM-DD'));
SELECT * FROM discount;

------------------------------------------Demo command to show an error when insert an existing discount into the discount table---------------------------------------------------------

EXECUTE insert_discount('New Year Promo', 'Fixed Amount', 'RM10', TO_DATE('2025-03-10', 'YYYY-MM-DD'), TO_DATE('2025-06-10', 'YYYY-MM-DD'));
SELECT * FROM discount;

----------------------------------------------------------------------------------Procedure 2-------------------------------------------------------------------------------------------
This procedure designed to update the endDate of a specific discount in the Discount table. So employee can modify the end date if the end date involve any error.

CREATE OR REPLACE PROCEDURE update_discount_enddate(
    p_discount_id INT,
    p_new_endDate DATE
)
IS
    -- Variable to store the current end date of the discount.
    v_current_endDate DATE;
BEGIN
    -- Validate if the new end date is valid (cannot be in the past).
    IF p_new_endDate < SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('Error: The new end date cannot be in the past.');
        RETURN; 
    END IF;

    BEGIN
        -- Fetch the current end date.
        SELECT endDate INTO v_current_endDate
        FROM Discount
        WHERE discount_id = p_discount_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Error: Discount ID not found.');
            RETURN;
    END;

    -- Update the discount's end date.
    BEGIN
        UPDATE Discount
        SET endDate = p_new_endDate
        WHERE discount_id = p_discount_id;

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Success: Discount end date updated successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error during update: ' || SQLERRM);
    END;
END;
/

------------------------------------------------- Demo command to update a new discount end date into the discount table ---------------------------------------------------------------

EXECUTE update_discount_enddate(5, TO_DATE('2025-12-31', 'YYYY-MM-DD'));
SELECT * FROM discount;

------------------------------------- Demo command for error when employee update a new discount end date that has passed ---------------------------------------------------------------

EXECUTE update_discount_enddate(5, TO_DATE('2025-3-31', 'YYYY-MM-DD'));
SELECT * FROM discount;

-- =======================================================================================================================================================================================
--
-- 										3. FUNCTIONS
--
-- =======================================================================================================================================================================================
-------------------------------------------------------------------------------------Function 1--------------------------------------------------------------------------------------------

This function is designed to compute the discount amount for a specific order, identified by its order_id. It retrieves the discount type and value associated with the order and calculates the discount accordingly.​

CREATE OR REPLACE FUNCTION calculate_discount_amount(p_order_id INT)
RETURN NUMBER
IS
    v_discount_type Discount.discountType%TYPE;
    v_discount_value Discount.discountValue%TYPE;
    v_total_amount NUMBER;
    v_discount_amount NUMBER := 0;
BEGIN
    SELECT d.discountType, d.discountValue, r.totalAmount
    INTO v_discount_type, v_discount_value, v_total_amount
    FROM Receipt r
    LEFT JOIN Discount d ON r.discount_id = d.discount_id
    WHERE r.order_id = p_order_id;

    IF v_discount_type IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('No Discount was Used for Order ' || p_order_id || '.');
        RETURN 0;
    ELSIF v_discount_type = 'Percentage' THEN
        v_discount_amount := v_total_amount * TO_NUMBER(REPLACE(v_discount_value, '%', '')) / 100;
    ELSE
        v_discount_amount := TO_NUMBER(REPLACE(v_discount_value, 'RM', ''));
    END IF;

    DBMS_OUTPUT.PUT_LINE('The Discount Amount for Order ' || p_order_id || ' is RM' || v_discount_amount);

    RETURN v_discount_amount;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Please Enter A Valid Order ID. Order ID ' || p_order_id || ' is invalid.');
        RETURN 0;
END;
/

---------------------------------------Demo for calculate the discount amount that using the percentage as its discount type---------------------------------------------------------

SELECT calculate_discount_amount(1) AS discount_amount FROM dual;

----------------------------------------Demo for calculate the discount amount that use fixed amount as its discount type--------------------------------------------------------------

SELECT calculate_discount_amount(10) AS discount_amount FROM dual;

------------------------------------------------------Demo for display if the order do not used any discount--------------------------------------------------------------------------

SELECT calculate_discount_amount(2) AS discount_amount FROM dual;

---------------------------------------Demo command for calculate the discount amount when enter an invalid order id-------------------------------------------------------------------

SELECT calculate_discount_amount(15) AS discount_amount FROM dual；

---------------------------------------------------------------------Function 2--------------------------------------------------------------------------------------------------------

This function is to list out all the discount based on the categories active, expired and upcoming promotions according the  current date time. The promotion name and the total promotion of that category will be display after run the following command, so it do not in the enter other command to get the output.

SET SERVEROUTPUT ON;

DECLARE
    -- Cursor for active promotions
    CURSOR active_promotions_cursor IS
        SELECT discountName
        FROM Discount
        WHERE SYSDATE BETWEEN startDate AND endDate;

    -- Cursor for expired promotions
    CURSOR expired_promotions_cursor IS
        SELECT discountName
        FROM Discount
        WHERE SYSDATE > endDate;

    -- Cursor for upcoming promotions
    CURSOR upcoming_promotions_cursor IS
        SELECT discountName
        FROM Discount
        WHERE SYSDATE < startDate;

    -- Variables to hold promotion names
    v_discountName Discount.discountName%TYPE;

    -- Counters for each category
    v_active_count   NUMBER := 0;
    v_expired_count  NUMBER := 0;
    v_upcoming_count NUMBER := 0;
BEGIN
    -- Process active promotions
    DBMS_OUTPUT.PUT_LINE('--- Active Promotions ---');
    OPEN active_promotions_cursor;
    LOOP
        FETCH active_promotions_cursor INTO v_discountName;
        EXIT WHEN active_promotions_cursor%NOTFOUND;
        v_active_count := v_active_count + 1;
        DBMS_OUTPUT.PUT_LINE('Promotion Name: ' || v_discountName);
    END LOOP;
    CLOSE active_promotions_cursor;
    DBMS_OUTPUT.PUT_LINE('Total Active Promotions: ' || v_active_count);
    DBMS_OUTPUT.PUT_LINE(''); -- Blank line for separation

    -- Process expired promotions
    DBMS_OUTPUT.PUT_LINE('--- Expired Promotions ---');
    OPEN expired_promotions_cursor;
    LOOP
        FETCH expired_promotions_cursor INTO v_discountName;
        EXIT WHEN expired_promotions_cursor%NOTFOUND;
        v_expired_count := v_expired_count + 1;
        DBMS_OUTPUT.PUT_LINE('Promotion Name: ' || v_discountName);
    END LOOP;
    CLOSE expired_promotions_cursor;
    DBMS_OUTPUT.PUT_LINE('Total Expired Promotions: ' || v_expired_count);
    DBMS_OUTPUT.PUT_LINE(''); -- Blank line for separation

    -- Process upcoming promotions
    DBMS_OUTPUT.PUT_LINE('--- Upcoming Promotions ---');
    OPEN upcoming_promotions_cursor;
    LOOP
        FETCH upcoming_promotions_cursor INTO v_discountName;
        EXIT WHEN upcoming_promotions_cursor%NOTFOUND;
        v_upcoming_count := v_upcoming_count + 1;
        DBMS_OUTPUT.PUT_LINE('Promotion Name: ' || v_discountName);
    END LOOP;
    CLOSE upcoming_promotions_cursor;
    DBMS_OUTPUT.PUT_LINE('Total Upcoming Promotions: ' || v_upcoming_count);
END;
/
