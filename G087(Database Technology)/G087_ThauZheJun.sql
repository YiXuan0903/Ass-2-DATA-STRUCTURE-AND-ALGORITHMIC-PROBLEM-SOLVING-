/*
Format: G087_ThauZheJun.sql

INDIVIDUAL ASSIGNMENT SUBMISSION

STUDENT NAME : THAU ZHE JUN
STUDENT ID : 22ACB06252
GROUP NUMBER : G087
PROGRAMME : IA
Submission date and time: 29-04-25

*/
-- This script contains 2 Queries, 2 Procedures, and 2 Functions

Query 1 
// The query is to search specify products with specify product name and details about the product
SELECT product_id, productName, price, stockQuantity
FROM Product
WHERE productName LIKE '%Burger%' OR productName LIKE '%Drink%' OR productName LIKE '%Fries%' OR productName LIKE '%Ring%'
ORDER BY productName;

Query 2
// This query is to view all pending deliveries with the rider assigned
SELECT d.delivery_id, d.order_id, e.empName AS rider_name, d.address, d.delivery_DateTime, d.deliveryFee, d.deliveryStatus
FROM Delivery d
JOIN Employee e ON d.employee_id = e.employee_id
WHERE d.deliveryStatus = 'Pending'
ORDER BY d.delivery_DateTime;

Procedure 1
// This procedure is to add in new customer account
CREATE OR REPLACE PROCEDURE create_customer(
    p_cusName VARCHAR2,
    p_cusPhone VARCHAR2,
    p_email VARCHAR2
)
IS
BEGIN

    INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email)
    VALUES (customer_seq.NEXTVAL, p_cusName, p_cusPhone, p_email);

    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20001, 'Data already exists.');
END;
/

// to create a new customer:
BEGIN
create_customer('Alex','0124223322','alex88@gmail.com');
END;
/

Procedure 2
// The procedure is to create a new delivery order and assign to rider
CREATE OR REPLACE PROCEDURE create_delivery_order(
    p_order_id INT,
    p_employee_id INT,
    p_address VARCHAR2,
    p_delivery_datetime DATE,
    p_cusPhoneNum VARCHAR2,
    p_deliveryFee NUMBER
)
IS
BEGIN
    INSERT INTO Delivery (
        delivery_id,
        order_id,
        employee_id,
        address,
        delivery_DateTime,
        cusPhoneNum,
        deliveryFee,
        deliveryStatus
    ) VALUES (
        delivery_seq.NEXTVAL,
        p_order_id,
        p_employee_id,
        p_address,
        p_delivery_datetime,
        p_cusPhoneNum,
        p_deliveryFee,
        'Pending'
    );

    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20040, 'Duplicate Delivery ID.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20041, 'Unexpected error occurred while creating delivery order.');
END;
/

//to create new order and assign to rider
 BEGIN
 create_delivery_order(6, 5, '101 Sunway Avenue', TO_DATE('29-APR-2025 10:30','DD-MM-YYYY HH24:MI'),'012-4320000', 5.00);
 END;
 /

Function 1
// This function is to calculate the total sales till now
CREATE OR REPLACE FUNCTION get_total_sales_till_now
RETURN NUMBER
IS
    v_total NUMBER := 0;
BEGIN
    SELECT COALESCE(SUM(finalAmount), 0)
    INTO v_total
    FROM Receipt;  -- No WHERE clause

    RETURN v_total;
END;
/

//to view the total sales until now
DECLARE
    v_total_sales NUMBER;
BEGIN
    v_total_sales := get_total_sales_till_now;
    DBMS_OUTPUT.PUT_LINE('Total sales till now: RM' || v_total_sales);
END;
/


Function 2
// This function is to check rider's total deliveries today
CREATE OR REPLACE FUNCTION rider_deliveries_today(p_employee_id INT)
RETURN NUMBER
IS
    v_total_deliveries NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total_deliveries
    FROM Delivery
    WHERE employee_id = p_employee_id
      AND TRUNC(delivery_DateTime) = TRUNC(SYSDATE)
      AND deliveryStatus = 'Delivered';

    RETURN v_total_deliveries;
END;
/

// to view the rider's total deliveries today
DECLARE
    v_count NUMBER;
BEGIN
    v_count := rider_deliveries_today(5);
    DBMS_OUTPUT.PUT_LINE('Total deliveries today by rider 5: '|| v_count);
END;
/


