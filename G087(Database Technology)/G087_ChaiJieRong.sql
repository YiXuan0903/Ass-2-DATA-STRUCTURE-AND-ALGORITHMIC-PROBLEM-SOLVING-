-- Format columns 
SET LINESIZE 300
SET PAGESIZE 1000
SET FEEDBACK OFF
SET WRAP OFF
SET HEADING ON
SET NULL '-'


COLUMN supplierName     HEADING 'Supplier Name'    FORMAT A30
COLUMN productName      HEADING 'Product Name'     FORMAT A40
COLUMN supply_quantity  HEADING 'Supply Qty'       FORMAT 9999
COLUMN supply_date      HEADING 'Supply Date'      FORMAT A15

/*
INDIVIDUAL ASSIGNMENT SUBMISSION

STUDENT NAME : Chai Jie Rong
STUDENT ID : 2207093
GROUP NUMBER : G087
PROGRAMME : IA
Submission date and time: 29-04-25
*/

--Query1
SELECT 
    sp.supplier_id,
    s.supplierName,
    sp.product_id,
    p.productName,
    sp.supply_price,
    sp.supply_quantity,
    sp.supply_date
FROM Supplier_Product sp
JOIN Supplier s ON sp.supplier_id = s.supplier_id
JOIN Product p ON sp.product_id = p.product_id
ORDER BY sp.supply_date DESC;


--Query2
SELECT 
    s.supplierName,
    p.productName,
    sp.supply_quantity,
    sp.supply_date
FROM Supplier_Product sp
JOIN Supplier s ON sp.supplier_id = s.supplier_id
JOIN Product p ON sp.product_id = p.product_id
WHERE s.supplierName = 'Alice Tan'
ORDER BY sp.supply_date DESC;




--Procedure1
SET SERVEROUTPUT ON

-- add
BEGIN
    add_supplier_with_product(
        'Zhe Jun',
        '012-3456789',
        1,
        5.00,
        TO_DATE('2025-05-01', 'YYYY-MM-DD'),
        100
    );
END;
/

--check procedure 1
SELECT * FROM Supplier ORDER BY supplier_id DESC;
SELECT * FROM Supplier_Product ORDER BY supply_date DESC;




--Procedure2
--add 
BEGIN
    update_supplier_contact(
        1,
        '018-7654321'
    );
END;
/


--check procedure 2
SELECT * FROM Supplier WHERE supplier_id = 1;



--Function1
CREATE OR REPLACE FUNCTION get_product_stock(p_product_id INT)
RETURN INT
IS
    v_stock INT;
BEGIN
    SELECT stockQuantity
    INTO v_stock
    FROM Product
    WHERE product_id = p_product_id;

    RETURN v_stock;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

--test fucntion 1
SELECT get_product_stock(1) FROM dual;




--Function2
CREATE OR REPLACE FUNCTION get_total_supplied_quantity(p_product_id INT)
RETURN NUMBER
IS
    v_total_supplied NUMBER;
BEGIN
    SELECT COALESCE(SUM(supply_quantity), 0)
    INTO v_total_supplied
    FROM Supplier_Product
    WHERE product_id = p_product_id;

    RETURN v_total_supplied;
END;
/


--test function 2
SELECT get_total_supplied_quantity(1) FROM dual;

