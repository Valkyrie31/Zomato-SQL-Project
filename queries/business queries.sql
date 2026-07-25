-- 1. Which restaurants generate the most revenue? --

SELECT r.name, r.city, SUM(o.sales_amount) AS total_revenue, COUNT(*) AS total_orders
FROM Orders o
JOIN Restaurant r ON o.r_id = r.id
GROUP BY r.name, r.city
ORDER BY total_revenue DESC
LIMIT 10;

-- 2. Which customer segment (by occupation) spends the most? --

SELECT u.Occupation,
       COUNT(DISTINCT u.user_id) AS num_users,
       SUM(o.sales_amount) AS total_spent,
       ROUND(AVG(o.sales_amount), 2) AS avg_order_value
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.Occupation
ORDER BY total_spent DESC;

-- 3. Monthly revenue trend--

SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(sales_amount) AS revenue,
       COUNT(*) AS total_orders
FROM Orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- 4. Which cuisines are most popular (by order volume), and are they also the most profitable? --

SELECT m.cuisine,
       COUNT(*) AS total_orders,
       SUM(o.sales_amount) AS total_revenue,
       ROUND(AVG(o.sales_amount), 2) AS avg_order_value
FROM Orders o
JOIN Menu m ON o.r_id = m.r_id
GROUP BY m.cuisine
ORDER BY total_orders DESC;

-- 5. Which cuisines are most popular (by order volume), and are they also the most profitable? --

SELECT u.user_id, u.name, u.Occupation, u.`Family size`,
       COUNT(*) AS total_orders,
       SUM(o.sales_amount) AS total_spent
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.name, u.Occupation, u.`Family size`
ORDER BY total_spent DESC
LIMIT 10;

-- 6. Who are the top 10 highest-value customers (for a loyalty/VIP program)? --

SELECT u.`Family size`, u.`Marital Status`,
       COUNT(*) AS total_orders,
       ROUND(AVG(o.sales_amount), 2) AS avg_order_value
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.`Family size`, u.`Marital Status`
ORDER BY u.`Family size`, avg_order_value DESC;

-- 7. Veg vs Non-Veg preference by income level --

SELECT f.veg_or_non_veg,
       ROUND(AVG(u.`Monthly Income`), 2) AS avg_income_of_buyers,
       COUNT(*) AS total_orders
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN Menu m ON o.r_id = m.r_id
JOIN Food f ON m.f_id = f.f_id
GROUP BY f.veg_or_non_veg;
