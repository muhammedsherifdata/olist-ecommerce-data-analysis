
/* =========================================================
   OLIST BRAZILIAN E-COMMERCE DATABASE
   CONSTRAINT DEFINITION SCRIPT

   Current Database Constraints:
   - 8 Primary Keys
   - 2 Composite Primary Keys
   - 7 Foreign Keys
   - 6 Check Constraints
   ========================================================= */


/* =========================================================
   1. PRIMARY KEYS
   ========================================================= */

-- Customers
ALTER TABLE customers
ALTER COLUMN customer_id NVARCHAR(50) NOT NULL;
GO

ALTER TABLE customers
ADD CONSTRAINT PK_customers
PRIMARY KEY (customer_id);
GO


-- Orders
ALTER TABLE orders
ALTER COLUMN order_id NVARCHAR(50) NOT NULL;
GO

ALTER TABLE orders
ADD CONSTRAINT PK_orders
PRIMARY KEY (order_id);
GO


-- Order Items
ALTER TABLE order_items
ALTER COLUMN order_id NVARCHAR(50) NOT NULL;
GO

ALTER TABLE order_items
ALTER COLUMN order_item_id INT NOT NULL;
GO

ALTER TABLE order_items
ADD CONSTRAINT PK_order_items
PRIMARY KEY (order_id, order_item_id);
GO


-- Order Payments
ALTER TABLE order_payments
ALTER COLUMN order_id NVARCHAR(50) NOT NULL;
GO

ALTER TABLE order_payments
ALTER COLUMN payment_sequential MONEY NOT NULL;
GO

ALTER TABLE order_payments
ADD CONSTRAINT PK_order_payments
PRIMARY KEY (order_id, payment_sequential);
GO


-- Order Reviews
-- review_id contains duplicate values in the source data.
-- A surrogate key is used as the primary key.

ALTER TABLE order_reviews
ADD order_review_key INT IDENTITY(1,1) NOT NULL;
GO

ALTER TABLE order_reviews
ADD CONSTRAINT PK_order_reviews
PRIMARY KEY (order_review_key);
GO


-- Products
ALTER TABLE products
ALTER COLUMN product_id NVARCHAR(50) NOT NULL;
GO

ALTER TABLE products
ADD CONSTRAINT PK_products
PRIMARY KEY (product_id);
GO


-- Sellers
ALTER TABLE sellers
ALTER COLUMN seller_id NVARCHAR(50) NOT NULL;
GO

ALTER TABLE sellers
ADD CONSTRAINT PK_sellers
PRIMARY KEY (seller_id);
GO


-- Product Category
ALTER TABLE product_category
ALTER COLUMN product_category_name NVARCHAR(50) NOT NULL;
GO

ALTER TABLE product_category
ADD CONSTRAINT PK_product_category
PRIMARY KEY (product_category_name);
GO


/* =========================================================
   2. FOREIGN KEYS
   ========================================================= */

-- Orders → Customers
ALTER TABLE orders
ADD CONSTRAINT FK_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);
GO


-- Order Items → Orders
ALTER TABLE order_items
ADD CONSTRAINT FK_order_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);
GO


-- Order Items → Products
ALTER TABLE order_items
ADD CONSTRAINT FK_order_items_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);
GO


-- Order Items → Sellers
ALTER TABLE order_items
ADD CONSTRAINT FK_order_items_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);
GO


-- Order Payments → Orders
ALTER TABLE order_payments
ADD CONSTRAINT FK_order_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);
GO


-- Order Reviews → Orders
ALTER TABLE order_reviews
ADD CONSTRAINT FK_order_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);
GO


-- Products → Product Category
ALTER TABLE products
ADD CONSTRAINT FK_products_product_category
FOREIGN KEY (product_category_name)
REFERENCES product_category(product_category_name);
GO


/* =========================================================
   3. CHECK CONSTRAINTS
   ========================================================= */

-- Order item price cannot be negative
ALTER TABLE order_items
ADD CONSTRAINT CK_order_items_price
CHECK (price >= 0);
GO


-- Freight value cannot be negative
ALTER TABLE order_items
ADD CONSTRAINT CK_order_items_freight
CHECK (freight_value >= 0);
GO


-- Payment value cannot be negative
ALTER TABLE order_payments
ADD CONSTRAINT CK_order_payments_value
CHECK (payment_value >= 0);
GO


-- Payment installments should be greater than zero.
-- The source data contains two records with zero installments.
-- WITH NOCHECK preserves those existing source records.

ALTER TABLE order_payments
WITH NOCHECK
ADD CONSTRAINT CK_order_payments_installments
CHECK (payment_installments > 0);
GO


-- Review score must be between 1 and 5.
-- NULL values are allowed.

ALTER TABLE order_reviews
ADD CONSTRAINT CK_order_reviews_score
CHECK (
    review_score IS NULL
    OR review_score BETWEEN 1 AND 5
);
GO


-- Allowed order statuses
ALTER TABLE orders
ADD CONSTRAINT CK_orders_status
CHECK (
    order_status IN (
        'unavailable',
        'created',
        'approved',
        'processing',
        'invoiced',
        'canceled',
        'shipped',
        'delivered'
    )
);
GO


/* =========================================================
   END OF CONSTRAINT DEFINITION
   ========================================================= */
