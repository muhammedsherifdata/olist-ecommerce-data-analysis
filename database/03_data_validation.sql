
/* =========================================================
   OLIST BRAZILIAN E-COMMERCE DATABASE
   DATA VALIDATION SCRIPT
   ========================================================= */


/* =========================================================
   1. PRIMARY KEY VALIDATION
   ========================================================= */

SELECT
    TABLE_NAME,
    CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY TABLE_NAME;


/* =========================================================
   2. FOREIGN KEY VALIDATION
   ========================================================= */

SELECT
    fk.name AS Foreign_Key,
    OBJECT_NAME(fk.parent_object_id) AS Child_Table,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS Child_Column,
    OBJECT_NAME(fk.referenced_object_id) AS Parent_Table,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS Parent_Column
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
ORDER BY Child_Table, Foreign_Key;


/* =========================================================
   3. CHECK CONSTRAINT VALIDATION
   ========================================================= */

SELECT
    OBJECT_NAME(parent_object_id) AS Table_Name,
    name AS Constraint_Name,
    definition,
    is_disabled,
    is_not_trusted
FROM sys.check_constraints
ORDER BY Table_Name, Constraint_Name;


/* =========================================================
   4. ORPHAN RECORD VALIDATION
   ========================================================= */

-- Orders without Customers
SELECT COUNT(*) AS Orphan_Orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- Order Items without Orders
SELECT COUNT(*) AS Orphan_OrderItems
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Order Items without Products
SELECT COUNT(*) AS Orphan_ProductItems
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- Order Items without Sellers
SELECT COUNT(*) AS Orphan_SellerItems
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


-- Payments without Orders
SELECT COUNT(*) AS Orphan_Payments
FROM order_payments op
LEFT JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Reviews without Orders
SELECT COUNT(*) AS Orphan_Reviews
FROM order_reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Products without Categories
-- NULL categories are excluded because they exist in the source data.
SELECT COUNT(*) AS Orphan_Products
FROM products p
LEFT JOIN product_category pc
    ON p.product_category_name = pc.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND pc.product_category_name IS NULL;


/* =========================================================
   5. DATA QUALITY VALIDATION
   ========================================================= */

-- Duplicate Customer IDs
SELECT
    customer_id,
    COUNT(*) AS Duplicate_Count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Duplicate Order IDs
SELECT
    order_id,
    COUNT(*) AS Duplicate_Count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


-- Invalid Review Scores
SELECT COUNT(*) AS Invalid_Review_Scores
FROM order_reviews
WHERE review_score IS NOT NULL
  AND review_score NOT BETWEEN 1 AND 5;


-- Negative Prices
SELECT COUNT(*) AS Negative_Prices
FROM order_items
WHERE price < 0;


-- Negative Freight Values
SELECT COUNT(*) AS Negative_Freight
FROM order_items
WHERE freight_value < 0;


-- Negative Payment Values
SELECT COUNT(*) AS Negative_Payment_Values
FROM order_payments
WHERE payment_value < 0;


-- Invalid Payment Installments
SELECT COUNT(*) AS Invalid_Installments
FROM order_payments
WHERE payment_installments <= 0;


/* =========================================================
   6. ROW COUNT VALIDATION
   ========================================================= */

SELECT 'customers' AS Table_Name, COUNT(*) AS Row_Count
FROM customers

UNION ALL

SELECT 'geolocation', COUNT(*)
FROM geolocation

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'order_payments', COUNT(*)
FROM order_payments

UNION ALL

SELECT 'order_reviews', COUNT(*)
FROM order_reviews

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'product_category', COUNT(*)
FROM product_category

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'sellers', COUNT(*)
FROM sellers;


/* =========================================================
   END OF DATA VALIDATION
   ========================================================= */
