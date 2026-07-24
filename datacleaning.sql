USE zomato;
SET SQL_SAFE_UPDATES = 0; -- turns off safe update mode --

-- ---------- 1. Standardize currency: convert all USD amounts to INR ----------
-- (use a fixed approximate rate, document the rate and date used in README)
UPDATE orders
SET sales_amount = sales_amount * 83.0,
    currency = 'INR'
WHERE currency = 'USD';

-- ---------- 2. Check for and remove orphan orders ----------
-- (orders referencing a restaurant_id or user_id that doesn't exist)
SELECT COUNT(*) AS orphan_orders
FROM orders o
LEFT JOIN restaurant r
    ON o.r_id = r.id
WHERE r.id IS NULL;

-- ---------- 3. Handle missing/placeholder restaurant ratings ----------
-- Identify placeholder values (e.g. 0, -1, or NULL) before fixing
SELECT DISTINCT rating FROM restaurant ORDER BY rating;

-- Replace placeholder ratings with NULL so they don't skew averages
UPDATE restaurant
SET rating = NULL
WHERE rating <= 0;

-- ---------- 4. Remove duplicate order records, if any ----------
SELECT
    order_date,
    sales_qty,
    sales_amount,
    currency,
    user_id,
    r_id,
    COUNT(*) AS cnt
FROM orders
GROUP BY
    order_date,
    sales_qty,
    sales_amount,
    currency,
    user_id,
    r_id
HAVING COUNT(*) > 1;


-- ---------- 5. Trim whitespace / standardize text casing ----------
UPDATE restaurant SET city = TRIM(city);
UPDATE menu SET cuisine = TRIM(cuisine);


-- ---------- 6. Sanity check: negative or zero quantities/amounts ----------
SELECT *
FROM orders
WHERE sales_qty <= 0
   OR sales_amount <= 0;
   

-- 7. Identify orders with invalid quantity or sales amount --   
SELECT *
FROM orders
WHERE sales_qty <= 0
   OR sales_amount <= 0;
DELETE FROM orders
WHERE sales_qty <= 0
   OR sales_amount <= 0;
   

-- 8. Check for inconsistent city name formatting --
SELECT
    LOWER(TRIM(city)) AS standardized_city,
    COUNT(*) AS cnt
FROM restaurant
GROUP BY LOWER(TRIM(city))
ORDER BY cnt DESC;
UPDATE restaurant
SET city = LOWER(TRIM(city));
