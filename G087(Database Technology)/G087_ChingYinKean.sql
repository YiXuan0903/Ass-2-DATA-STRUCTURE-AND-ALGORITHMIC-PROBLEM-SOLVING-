/*
Format: G087_ChingYinKean.sql

INDIVIDUAL ASSIGNMENT SUBMISSION

STUDENT NAME : Ching Yin Kean
STUDENT ID : 2207267
GROUP NUMBER : G087
PROGRAMME : IA
Submission date and time: 29-4-25
*/

/* Query 1: Show all orders with customer info and total price */
SELECT o.order_id, c.cusName AS "Customer Name", o.orderType, o.orderStatus, 'RM'||TO_CHAR(SUM(od.subtotal),'999.99') AS "Total Price"
FROM Orders o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN Order_Detail od ON o.order_id = od.order_id
GROUP BY o.order_id, c.cusName, o.orderType, o.orderStatus;

/* Query 2: Show all products with stock quantity and price */
SELECT productName, stockQuantity, '  RM'||TO_CHAR(price,'999.99') AS "Price"
FROM Product;

/* Stored Procedure 1: Add a new customer after checking email and phone uniqueness */
CREATE OR REPLACE PROCEDURE add_new_customer(
    p_customer_name VARCHAR2,
    p_phone_number VARCHAR2,
    p_email VARCHAR2)
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Customer
    WHERE email = p_email;
    
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Email already exists.');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM Customer
    WHERE cusPhoneNumber = p_phone_number;
    
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Phone number already exists.');
    END IF;

    INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email)
    VALUES (customer_seq.NEXTVAL, p_customer_name, p_phone_number, p_email);
END add_new_customer;
/

/* Stored Procedure 2: Update the status of an order */
CREATE OR REPLACE PROCEDURE update_order_status(
    p_order_id NUMBER,
    p_new_status VARCHAR2)
IS
BEGIN
    UPDATE Orders
    SET orderStatus = p_new_status
    WHERE order_id = p_order_id;
    
    COMMIT;
END update_order_status;
/

/* Function 1: Calculate total amount spent by a customer */
CREATE OR REPLACE FUNCTION calculate_total_spent(
    p_customer_id NUMBER)
RETURN NUMBER
IS
    v_total_spent NUMBER(10,2);
BEGIN
    SELECT SUM(od.subtotal)
    INTO v_total_spent
    FROM Order_Detail od
    JOIN Orders o ON od.order_id = o.order_id
    WHERE o.customer_id = p_customer_id;
    
    RETURN NVL(v_total_spent, 0);
END calculate_total_spent;
/

/* Function 2: Check if a product is in stock */
CREATE OR REPLACE FUNCTION is_product_available(
    p_product_id NUMBER)
RETURN VARCHAR2
IS
    v_stock_quantity NUMBER;
BEGIN
    SELECT stockQuantity
    INTO v_stock_quantity
    FROM Product
    WHERE product_id = p_product_id;
    
    IF v_stock_quantity > 0 THEN
        RETURN 'In Stock';
    ELSE
        RETURN 'Out of Stock';
    END IF;
END is_product_available;
/


--------------------------------------------------------------------------------
-- DEMONSTRATION SECTION (Run Procedures / Functions)
--------------------------------------------------------------------------------

/* Example Usage for add_new_customer */
EXEC add_new_customer('Jason Lee', '018-77778888', 'jasonlee@gmail.com');

/* Check if customer was added */
SELECT * FROM Customer;

/* Example Usage for update_order_status */
EXEC update_order_status(2, 'Completed');

/* Check if order status was updated */
SELECT order_id, orderStatus
FROM Orders;

/* Example Usage for calculate_total_spent function */
SELECT customer_id, 'RM' || TO_CHAR(calculate_total_spent(customer_id), '999.99') AS "Total Spent"
FROM Customer;

/* Example Usage for is_product_available function */
SELECT product_id, productName, is_product_available(product_id) AS "Availability"
FROM Product;