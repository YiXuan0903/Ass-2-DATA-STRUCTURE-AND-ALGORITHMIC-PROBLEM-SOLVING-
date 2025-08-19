
-- The Foodie POS System
ALTER SESSION SET "_oracle_script" = true;

DROP TABLE Service CASCADE CONSTRAINTS;
DROP TABLE Delivery CASCADE CONSTRAINTS;
DROP TABLE Payment CASCADE CONSTRAINTS; 
DROP TABLE Order_Items CASCADE CONSTRAINTS; 
DROP TABLE Order_Detail CASCADE CONSTRAINTS; 
DROP TABLE Orders CASCADE CONSTRAINTS; 
DROP TABLE Supplier_Product CASCADE CONSTRAINTS; 
DROP TABLE Supplier CASCADE CONSTRAINTS; 
DROP TABLE Discount CASCADE CONSTRAINTS; 
DROP TABLE Product CASCADE CONSTRAINTS; 
DROP TABLE Employee CASCADE CONSTRAINTS; 
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Receipt CASCADE CONSTRAINTS;

-----------drop sequence
DROP SEQUENCE customer_seq;
DROP SEQUENCE employee_seq; 
DROP SEQUENCE order_seq; 
DROP SEQUENCE order_detail_seq;
DROP SEQUENCE payment_seq; 
DROP SEQUENCE product_seq; 
DROP SEQUENCE receipt_seq;
DROP SEQUENCE supplier_seq; 
DROP SEQUENCE delivery_seq; 
DROP SEQUENCE discount_seq;

-- Drop users if exist
DROP USER customer_user CASCADE;
DROP USER employee_user CASCADE;
DROP USER supplier_user CASCADE;

---------Drop role
DROP ROLE customer_role;
DROP ROLE employee_role;
DROP ROLE supplier_role;

-- Create users and assign roles
CREATE USER customer_user IDENTIFIED BY Customer123;

CREATE USER employee_user IDENTIFIED BY Employee123;

CREATE USER supplier_user IDENTIFIED BY Supplier123;

-- Create roles
CREATE ROLE customer_role;
CREATE ROLE employee_role;
CREATE ROLE supplier_role;

-- Create Tables
-- ========================

-- Customer Table
CREATE TABLE Customer (
    customer_id NUMBER PRIMARY KEY,
    cusName VARCHAR2(100) NOT NULL,
    cusPhoneNumber VARCHAR2(20),
    email VARCHAR2(100) UNIQUE
);

-- Employee Table
CREATE TABLE Employee (
    employee_id NUMBER PRIMARY KEY,
    supervisor_id NUMBER,
    empName VARCHAR2(100) NOT NULL,
    role VARCHAR2(50),
    FOREIGN KEY (supervisor_id) REFERENCES Employee(employee_id)
);

-- Product Table
CREATE TABLE Product (
    product_id NUMBER PRIMARY KEY,
    productName VARCHAR2(100) NOT NULL,
    stockQuantity NUMBER DEFAULT 0,
    price NUMBER(10,2) NOT NULL
);

-- Orders Table
CREATE TABLE Orders (
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    employee_id NUMBER NOT NULL,
    orderType VARCHAR2(50),
    order_DateTime TIMESTAMP,
    orderStatus VARCHAR2(50),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- Order_Detail Table
CREATE TABLE Order_Detail (
    orderDetail_id NUMBER PRIMARY KEY,
    order_id NUMBER NOT NULL,
    product_id NUMBER NOT NULL,
    productName VARCHAR2(100),
    price NUMBER(10,2),
    quantity NUMBER,
    subtotal NUMBER(10,2),
    pickupTime TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- Payment Table
CREATE TABLE Payment (
    payment_id NUMBER PRIMARY KEY,
    order_id NUMBER NOT NULL,
    discount_id NUMBER,
    paymentMethod VARCHAR2(50),
    paymentStatus VARCHAR2(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
    -- discount_id FK will be added after Discount table
);

-- Delivery Table
CREATE TABLE Delivery (
    delivery_id NUMBER PRIMARY KEY,
    order_id NUMBER NOT NULL,
    employee_id NUMBER NOT NULL,
    address VARCHAR2(255),
    delivery_DateTime TIMESTAMP,
    cusPhoneNum VARCHAR2(20),
    deliveryFee NUMBER(10,2),
    deliveryStatus VARCHAR2(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- Service Table
CREATE TABLE Service (
    employee_id NUMBER NOT NULL,
    customer_id NUMBER NOT NULL,
    service_status VARCHAR2(50),
    PRIMARY KEY (employee_id, customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Order_Items Table
CREATE TABLE Order_Items (
    product_id NUMBER NOT NULL,
    orderDetail_id NUMBER NOT NULL,
    orderQuantity NUMBER,
    PRIMARY KEY (product_id, orderDetail_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id),
    FOREIGN KEY (orderDetail_id) REFERENCES Order_Detail(orderDetail_id)
);

-- Discount Table
CREATE TABLE Discount (
    discount_id NUMBER PRIMARY KEY,
    discountName VARCHAR2(100) NOT NULL,
    discountType VARCHAR2(50),
    discountValue VARCHAR2(20),
    startDate DATE,
    endDate DATE
);

-- Receipt Table
CREATE TABLE Receipt (
    receipt_id NUMBER PRIMARY KEY,
    order_id NUMBER NOT NULL,
    payment_id NUMBER NOT NULL,
    discount_id NUMBER,
    employee_id NUMBER NOT NULL,
    issueDate DATE,
    totalAmount NUMBER(10,2),
    discountApplied VARCHAR2(20),
    finalAmount NUMBER(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (payment_id) REFERENCES Payment(payment_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    FOREIGN KEY (discount_id) REFERENCES Discount(discount_id)
);

-- Supplier Table
CREATE TABLE Supplier (
    supplier_id NUMBER PRIMARY KEY,
    supplierName VARCHAR2(100) NOT NULL,
    telephoneNum VARCHAR2(20)
);

-- Supplier_Product Table
CREATE TABLE Supplier_Product (
    supplier_id NUMBER NOT NULL,
    product_id NUMBER NOT NULL,
    supply_price NUMBER(10,2),
    supply_date DATE,
    supply_quantity NUMBER,
    PRIMARY KEY (supplier_id, product_id, supply_date),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- Add Discount Foreign Key in Payment (after Discount is created)
ALTER TABLE Payment ADD (
    FOREIGN KEY (discount_id) REFERENCES Discount(discount_id)
);

-- Create sequences for primary keys

CREATE SEQUENCE customer_seq
START WITH 11
INCREMENT BY 1
CACHE 10
NOCYCLE;

CREATE SEQUENCE employee_seq
START WITH 9
INCREMENT BY 1
CACHE 10
NOCYCLE;

CREATE SEQUENCE product_seq
START WITH 10
INCREMENT BY 1
CACHE 10
NOCYCLE;

CREATE SEQUENCE order_seq
START WITH 11
INCREMENT BY 1
CACHE 10
NOCYCLE;

CREATE SEQUENCE order_detail_seq
START WITH 11
INCREMENT BY 1
CACHE 10
NOCYCLE;

CREATE SEQUENCE payment_seq
START WITH 11
INCREMENT BY 1
CACHE 10
NOCYCLE;

CREATE SEQUENCE delivery_seq
START WITH 6
INCREMENT BY 1
CACHE 10
NOCYCLE;

CREATE SEQUENCE discount_seq
START WITH 6
INCREMENT BY 1
CACHE 10
NOCYCLE;

CREATE SEQUENCE receipt_seq
START WITH 11
INCREMENT BY 1
CACHE 10
NOCYCLE;

CREATE SEQUENCE supplier_seq
START WITH 6
INCREMENT BY 1
CACHE 10
NOCYCLE;

-- ============================
-- Insert Data into Customer
-- ============================
INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email) VALUES (1, 'Anthony Davis', '011-11110000', 'davis@gmail.com');
INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email) VALUES (2, 'Lebron James', '012-22220000', 'james@gmail.com');
INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email) VALUES (3, 'Kobe Bryant', '012-33330000', 'bryant@gmail.com');
INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email) VALUES (4, 'Paul George', '013-44440000', 'george@gmail.com');
INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email) VALUES (5, 'Stephen Curry', '016-55550000', 'curry@gmail.com');
INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email) VALUES (6, 'Ja Morant', '016-66660000', 'morant@gmail.com');
INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email) VALUES (7, 'Micheal Jordan', '013-77770000', 'jordan@gmail.com');
INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email) VALUES (8, 'Klay Thompson', '012-88880000', 'thompson@gmail.com');
INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email) VALUES (9, 'Kevin Durant', '012-99990000', 'durant@gmail.com');
INSERT INTO Customer (customer_id, cusName, cusPhoneNumber, email) VALUES (10, 'Allen Iverson', '011-00001111', 'iverson@gmail.com');

-- ============================
-- Insert Data into Employee
-- ============================
-- Insert Supervisor (employee_id = 4)
INSERT INTO Employee (employee_id, supervisor_id, empName, role) VALUES (4, NULL, 'Adams', 'Supervisor');

-- Insert other Employees that refer to supervisor_id = 4
INSERT INTO Employee (employee_id, supervisor_id, empName, role) VALUES (1, 4, 'Magic Johnson', 'Cashier');
INSERT INTO Employee (employee_id, supervisor_id, empName, role) VALUES (2, 4, 'Cameron Anthony', 'Manager');
INSERT INTO Employee (employee_id, supervisor_id, empName, role) VALUES (3, 4, 'Shaque Oneal', 'Service');
INSERT INTO Employee (employee_id, supervisor_id, empName, role) VALUES (5, 4, 'Dwyane Wade', 'Delivery');
INSERT INTO Employee (employee_id, supervisor_id, empName, role) VALUES (6, 4, 'Peter Black', 'Chef');
INSERT INTO Employee (employee_id, supervisor_id, empName, role) VALUES (7, 4, 'Sarah Lee', 'Chef');
INSERT INTO Employee (employee_id, supervisor_id, empName, role) VALUES (8, 4, 'John Hill', 'Delivery');

-- ============================
-- Insert Data into Product
-- ============================
INSERT INTO Product (product_id, productName, stockQuantity, price) VALUES (1, 'Cheeseburger', 100, 10);
INSERT INTO Product (product_id, productName, stockQuantity, price) VALUES (2, 'Fried Chicken', 80, 4);
INSERT INTO Product (product_id, productName, stockQuantity, price) VALUES (3, 'French Fries', 150, 6.5);
INSERT INTO Product (product_id, productName, stockQuantity, price) VALUES (4, 'Soft Drink', 200, 3.5);
INSERT INTO Product (product_id, productName, stockQuantity, price) VALUES (5, 'Ice Cream', 60, 2);
INSERT INTO Product (product_id, productName, stockQuantity, price) VALUES (6, 'Chicken Nuggets', 70, 6);
INSERT INTO Product (product_id, productName, stockQuantity, price) VALUES (7, 'Fish Burger', 80, 7.5);
INSERT INTO Product (product_id, productName, stockQuantity, price) VALUES (8, 'Beef Burger', 40, 8);
INSERT INTO Product (product_id, productName, stockQuantity, price) VALUES (9, 'Onion Rings', 120, 2.5);

-- ============================
-- Insert Data into Discount
-- ============================
INSERT INTO Discount (discount_id, discountName, discountType, discountValue, startDate, endDate) 
VALUES (1, 'New Year Promo', 'Percentage', '15%', TO_DATE('2025-01-10', 'YYYY-MM-DD'), TO_DATE('2025-02-10', 'YYYY-MM-DD'));

INSERT INTO Discount (discount_id, discountName, discountType, discountValue, startDate, endDate) 
VALUES (2, 'Member Special Offer', 'Percentage', '10%', TO_DATE('2025-06-30', 'YYYY-MM-DD'), TO_DATE('2025-08-20', 'YYYY-MM-DD'));

INSERT INTO Discount (discount_id, discountName, discountType, discountValue, startDate, endDate) 
VALUES (3, 'Flash Sale', 'Percentage', '20%', TO_DATE('2025-04-30', 'YYYY-MM-DD'), TO_DATE('2025-05-05', 'YYYY-MM-DD'));

INSERT INTO Discount (discount_id, discountName, discountType, discountValue, startDate, endDate) 
VALUES (4, 'Bulk Purchase Discount', 'Fixed Amount', 'RM5', TO_DATE('2025-04-04', 'YYYY-MM-DD'), TO_DATE('2026-04-06', 'YYYY-MM-DD'));

INSERT INTO Discount (discount_id, discountName, discountType, discountValue, startDate, endDate) 
VALUES (5, 'Student Discount', 'Percentage', '8%', TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-11-01', 'YYYY-MM-DD'));

-- ============================
-- Insert Data into Supplier
-- ============================
INSERT INTO Supplier (supplier_id, supplierName, telephoneNum) VALUES (1, 'Alice Tan', '014-1234567');
INSERT INTO Supplier (supplier_id, supplierName, telephoneNum) VALUES (2, 'Liew June', '014-2345678');
INSERT INTO Supplier (supplier_id, supplierName, telephoneNum) VALUES (3, 'Xian Lee', '014-3456789');
INSERT INTO Supplier (supplier_id, supplierName, telephoneNum) VALUES (4, 'Jun You', '014-4567890');
INSERT INTO Supplier (supplier_id, supplierName, telephoneNum) VALUES (5, 'Jun Xian', '014-5678901');

-- ============================
-- Insert Data into Orders
-- ============================
INSERT INTO Orders (order_id, customer_id, employee_id, orderType, order_DateTime, orderStatus)
VALUES (1, 2, 3, 'Dine-In', TO_TIMESTAMP('2025-04-05 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');

INSERT INTO Orders (order_id, customer_id, employee_id, orderType, order_DateTime, orderStatus)
VALUES (2, 3, 1, 'Takeaway', TO_TIMESTAMP('2025-04-05 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');

INSERT INTO Orders (order_id, customer_id, employee_id, orderType, order_DateTime, orderStatus)
VALUES (3, 5, 5, 'Delivery', TO_TIMESTAMP('2025-04-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered');

INSERT INTO Orders (order_id, customer_id, employee_id, orderType, order_DateTime, orderStatus)
VALUES (4, 7, 8, 'Delivery', TO_TIMESTAMP('2025-04-05 12:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered');

INSERT INTO Orders (order_id, customer_id, employee_id, orderType, order_DateTime, orderStatus)
VALUES (5, 1, 3, 'Dine-In', TO_TIMESTAMP('2025-04-05 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');

INSERT INTO Orders (order_id, customer_id, employee_id, orderType, order_DateTime, orderStatus)
VALUES (6, 4, 1, 'Pickup', TO_TIMESTAMP('2025-04-05 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');

INSERT INTO Orders (order_id, customer_id, employee_id, orderType, order_DateTime, orderStatus)
VALUES (7, 9, 5, 'Delivery', TO_TIMESTAMP('2025-04-05 13:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Pending');

INSERT INTO Orders (order_id, customer_id, employee_id, orderType, order_DateTime, orderStatus)
VALUES (8, 10, 5, 'Delivery', TO_TIMESTAMP('2025-04-05 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Delivered');

INSERT INTO Orders (order_id, customer_id, employee_id, orderType, order_DateTime, orderStatus)
VALUES (9, 8, 2, 'Takeaway', TO_TIMESTAMP('2025-04-05 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed');

INSERT INTO Orders (order_id, customer_id, employee_id, orderType, order_DateTime, orderStatus)
VALUES (10, 6, 8, 'Delivery', TO_TIMESTAMP('2025-04-05 14:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Pending');

-- ============================
-- Insert Data into Order_Detail
-- ============================
INSERT INTO Order_Detail (orderDetail_id, order_id, product_id, productName, price, quantity, subtotal, pickupTime)
VALUES (1, 1, 1, 'Cheeseburger', 10, 2, 20, NULL);

INSERT INTO Order_Detail (orderDetail_id, order_id, product_id, productName, price, quantity, subtotal, pickupTime)
VALUES (2, 2, 1, 'Cheeseburger', 10, 1, 10, TO_TIMESTAMP('2025-04-05 11:39:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Order_Detail (orderDetail_id, order_id, product_id, productName, price, quantity, subtotal, pickupTime)
VALUES (3, 3, 3, 'French Fries', 6.5, 3, 19.5, NULL);

INSERT INTO Order_Detail (orderDetail_id, order_id, product_id, productName, price, quantity, subtotal, pickupTime)
VALUES (4, 4, 5, 'Ice Cream', 2, 2, 4, NULL);

INSERT INTO Order_Detail (orderDetail_id, order_id, product_id, productName, price, quantity, subtotal, pickupTime)
VALUES (5, 5, 6, 'Chicken Nuggets', 6, 3, 18, NULL);

INSERT INTO Order_Detail (orderDetail_id, order_id, product_id, productName, price, quantity, subtotal, pickupTime)
VALUES (6, 6, 6, 'Chicken Nuggets', 6, 4, 24, TO_TIMESTAMP('2025-04-05 13:05:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Order_Detail (orderDetail_id, order_id, product_id, productName, price, quantity, subtotal, pickupTime)
VALUES (7, 7, 7, 'Fish Burger', 7.5, 2, 15, NULL);

INSERT INTO Order_Detail (orderDetail_id, order_id, product_id, productName, price, quantity, subtotal, pickupTime)
VALUES (8, 8, 8, 'Beef Burger', 8, 1, 8, NULL);

INSERT INTO Order_Detail (orderDetail_id, order_id, product_id, productName, price, quantity, subtotal, pickupTime)
VALUES (9, 9, 2, 'Fried Chicken', 4, 3, 12, TO_TIMESTAMP('2025-04-05 14:10:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO Order_Detail (orderDetail_id, order_id, product_id, productName, price, quantity, subtotal, pickupTime)
VALUES (10, 10, 2, 'Fried Chicken', 4, 4, 16, NULL);

-- ============================
-- Insert Data into Payment
-- ============================
INSERT INTO Payment (payment_id, order_id, discount_id, paymentMethod, paymentStatus) 
VALUES (1, 1, 5, 'Credit Card', 'Paid');

INSERT INTO Payment (payment_id, order_id, discount_id, paymentMethod, paymentStatus) 
VALUES (2, 2, NULL, 'Cash', 'Paid');

INSERT INTO Payment (payment_id, order_id, discount_id, paymentMethod, paymentStatus) 
VALUES (3, 3, 5, 'Online Payment', 'Paid');

INSERT INTO Payment (payment_id, order_id, discount_id, paymentMethod, paymentStatus) 
VALUES (4, 4, NULL, 'Debit Card', 'Pending');

INSERT INTO Payment (payment_id, order_id, discount_id, paymentMethod, paymentStatus) 
VALUES (5, 5, 5, 'Cash', 'Paid');

INSERT INTO Payment (payment_id, order_id, discount_id, paymentMethod, paymentStatus) 
VALUES (6, 6, 5, 'Credit Card', 'Paid');

INSERT INTO Payment (payment_id, order_id, discount_id, paymentMethod, paymentStatus) 
VALUES (7, 7, NULL, 'Online Payment', 'Paid');

INSERT INTO Payment (payment_id, order_id, discount_id, paymentMethod, paymentStatus) 
VALUES (8, 8, NULL, 'Debit Card', 'Paid');

INSERT INTO Payment (payment_id, order_id, discount_id, paymentMethod, paymentStatus) 
VALUES (9, 9, 5, 'Cash', 'Pending');

INSERT INTO Payment (payment_id, order_id, discount_id, paymentMethod, paymentStatus) 
VALUES (10, 10, 4, 'Credit Card', 'Paid');

-- ============================
-- Insert Data into Delivery
-- ============================
INSERT INTO Delivery (delivery_id, order_id, employee_id, address, delivery_DateTime, cusPhoneNum, deliveryFee, deliveryStatus)
VALUES (1, 3, 5, '23 Main Street', TO_TIMESTAMP('2025-04-05 12:30:00', 'YYYY-MM-DD HH24:MI:SS'), '016-55550000', 5, 'Delivered');

INSERT INTO Delivery (delivery_id, order_id, employee_id, address, delivery_DateTime, cusPhoneNum, deliveryFee, deliveryStatus)
VALUES (2, 4, 8, '456 Park Avenue', TO_TIMESTAMP('2025-04-05 13:45:00', 'YYYY-MM-DD HH24:MI:SS'), '013-77770000', 6, 'Pending');

INSERT INTO Delivery (delivery_id, order_id, employee_id, address, delivery_DateTime, cusPhoneNum, deliveryFee, deliveryStatus)
VALUES (3, 7, 5, '789 Oak Lane', TO_TIMESTAMP('2025-04-05 14:35:00', 'YYYY-MM-DD HH24:MI:SS'), '012-99990000', 7, 'Pending');

INSERT INTO Delivery (delivery_id, order_id, employee_id, address, delivery_DateTime, cusPhoneNum, deliveryFee, deliveryStatus)
VALUES (4, 8, 5, '87 Elme Street', TO_TIMESTAMP('2025-04-05 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), '011-00001111', 5, 'Delivered');

INSERT INTO Delivery (delivery_id, order_id, employee_id, address, delivery_DateTime, cusPhoneNum, deliveryFee, deliveryStatus)
VALUES (5, 10, 8, '54 Apple Drive', TO_TIMESTAMP('2025-04-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '016-66660000', 5, 'Pending');

-- ============================
-- Insert Data into Service
-- ============================
INSERT INTO Service (employee_id, customer_id, service_status) VALUES (1, 3, 'Completed');
INSERT INTO Service (employee_id, customer_id, service_status) VALUES (1, 4, 'Completed');
INSERT INTO Service (employee_id, customer_id, service_status) VALUES (2, 8, 'Completed');
INSERT INTO Service (employee_id, customer_id, service_status) VALUES (3, 2, 'Completed');
INSERT INTO Service (employee_id, customer_id, service_status) VALUES (3, 1, 'Completed');
INSERT INTO Service (employee_id, customer_id, service_status) VALUES (5, 5, 'Delivered');
INSERT INTO Service (employee_id, customer_id, service_status) VALUES (5, 9, 'Pending');
INSERT INTO Service (employee_id, customer_id, service_status) VALUES (5, 10, 'Delivered');
INSERT INTO Service (employee_id, customer_id, service_status) VALUES (8, 7, 'Completed');
INSERT INTO Service (employee_id, customer_id, service_status) VALUES (8, 6, 'Pending');

-- ============================
-- Insert Data into Order_Items
-- ============================
INSERT INTO Order_Items (product_id, orderDetail_id, orderQuantity) VALUES (1, 1, 2);
INSERT INTO Order_Items (product_id, orderDetail_id, orderQuantity) VALUES (1, 2, 1);
INSERT INTO Order_Items (product_id, orderDetail_id, orderQuantity) VALUES (2, 9, 3);
INSERT INTO Order_Items (product_id, orderDetail_id, orderQuantity) VALUES (2, 10, 4);
INSERT INTO Order_Items (product_id, orderDetail_id, orderQuantity) VALUES (3, 3, 3);
INSERT INTO Order_Items (product_id, orderDetail_id, orderQuantity) VALUES (5, 4, 2);
INSERT INTO Order_Items (product_id, orderDetail_id, orderQuantity) VALUES (6, 5, 3);
INSERT INTO Order_Items (product_id, orderDetail_id, orderQuantity) VALUES (6, 6, 4);
INSERT INTO Order_Items (product_id, orderDetail_id, orderQuantity) VALUES (7, 7, 2);
INSERT INTO Order_Items (product_id, orderDetail_id, orderQuantity) VALUES (8, 8, 1);

-- ============================
-- Insert Data into Receipt
-- ============================
INSERT INTO Receipt (receipt_id, order_id, payment_id, discount_id, employee_id, issueDate, totalAmount, discountApplied, finalAmount)
VALUES (1, 1, 1, 5, 3, NULL, 20, '8%', 18.4);

INSERT INTO Receipt (receipt_id, order_id, payment_id, discount_id, employee_id, issueDate, totalAmount, discountApplied, finalAmount)
VALUES (2, 2, 2, NULL, 1, NULL, 10, NULL, 10);

INSERT INTO Receipt (receipt_id, order_id, payment_id, discount_id, employee_id, issueDate, totalAmount, discountApplied, finalAmount)
VALUES (3, 3, 3, 5, 5, NULL, 19.5, '8%', 17.94);

INSERT INTO Receipt (receipt_id, order_id, payment_id, discount_id, employee_id, issueDate, totalAmount, discountApplied, finalAmount)
VALUES (4, 4, 4, NULL, 8, NULL, 4, NULL, 4);

INSERT INTO Receipt (receipt_id, order_id, payment_id, discount_id, employee_id, issueDate, totalAmount, discountApplied, finalAmount)
VALUES (5, 5, 5, 5, 3, NULL, 18, '8%', 16.56);

INSERT INTO Receipt (receipt_id, order_id, payment_id, discount_id, employee_id, issueDate, totalAmount, discountApplied, finalAmount)
VALUES (6, 6, 6, 5, 1, NULL, 24, '8%', 22.08);

INSERT INTO Receipt (receipt_id, order_id, payment_id, discount_id, employee_id, issueDate, totalAmount, discountApplied, finalAmount)
VALUES (7, 7, 7, NULL, 5, NULL, 15, NULL, 15);

INSERT INTO Receipt (receipt_id, order_id, payment_id, discount_id, employee_id, issueDate, totalAmount, discountApplied, finalAmount)
VALUES (8, 8, 8, NULL, 5, NULL, 8, NULL, 8);

INSERT INTO Receipt (receipt_id, order_id, payment_id, discount_id, employee_id, issueDate, totalAmount, discountApplied, finalAmount)
VALUES (9, 9, 9, 5, 2, NULL, 12, '8%', 11.04);

INSERT INTO Receipt (receipt_id, order_id, payment_id, discount_id, employee_id, issueDate, totalAmount, discountApplied, finalAmount)
VALUES (10, 10, 10, 4, 8, NULL, 16, NULL, 11);

-- ============================
-- Insert Data into Supplier_Product
-- ============================
INSERT INTO Supplier_Product (supplier_id, product_id, supply_price, supply_date, supply_quantity)
VALUES (1, 4, 1.7, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 700);

INSERT INTO Supplier_Product (supplier_id, product_id, supply_price, supply_date, supply_quantity)
VALUES (2, 1, 5, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 500);

INSERT INTO Supplier_Product (supplier_id, product_id, supply_price, supply_date, supply_quantity)
VALUES (2, 7, 4, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 450);

INSERT INTO Supplier_Product (supplier_id, product_id, supply_price, supply_date, supply_quantity)
VALUES (2, 8, 4.5, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 600);

INSERT INTO Supplier_Product (supplier_id, product_id, supply_price, supply_date, supply_quantity)
VALUES (3, 2, 1.5, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 1000);

INSERT INTO Supplier_Product (supplier_id, product_id, supply_price, supply_date, supply_quantity)
VALUES (3, 6, 3, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 700);

INSERT INTO Supplier_Product (supplier_id, product_id, supply_price, supply_date, supply_quantity)
VALUES (4, 3, 2.5, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 2500);

INSERT INTO Supplier_Product (supplier_id, product_id, supply_price, supply_date, supply_quantity)
VALUES (4, 9, 0.9, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 2500);

INSERT INTO Supplier_Product (supplier_id, product_id, supply_price, supply_date, supply_quantity)
VALUES (5, 5, 0.7, TO_DATE('2024-04-01', 'YYYY-MM-DD'), 3000);

----------Grant Privilege
-- CustomerRole: customers usually view products and their own orders
GRANT SELECT ON Product TO customer_role;
GRANT SELECT, INSERT ON Customer TO customer_role;
GRANT SELECT, INSERT ON Orders TO customer_role;
GRANT SELECT ON Order_Items TO customer_role;
GRANT SELECT ON Receipt TO customer_role;
GRANT SELECT ON Payment TO customer_role;
GRANT SELECT ON Delivery TO customer_role;
GRANT SELECT ON Discount TO customer_role;

-- EmployeeRole: employees manage products, orders, and services
GRANT SELECT, INSERT, UPDATE, DELETE ON Product TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Orders TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Order_Detail TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Order_Items TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Payment TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Delivery TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Service TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Receipt TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Discount TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Customer TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Supplier TO employee_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Supplier_Product TO employee_role;

-- SupplierRole: suppliers manage their products
GRANT SELECT, INSERT, UPDATE, DELETE ON Supplier TO supplier_role;
GRANT SELECT, INSERT, UPDATE, DELETE ON Supplier_Product TO supplier_role;
GRANT SELECT ON Product TO supplier_role;

----------Grant Roles to Users
GRANT customer_role TO customer_user;

GRANT employee_role TO employee_user;

GRANT supplier_role TO supplier_user;

-------------Commit
COMMIT;
