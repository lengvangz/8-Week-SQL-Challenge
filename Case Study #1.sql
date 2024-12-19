/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT 
	s.customer_id,
	SUM(m.price) AS total_amount_spent
FROM sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?

SELECT 
	customer_id,
	COUNT(DISTINCT order_date) AS num_visited
FROM 
	sales
GROUP BY
	customer_id;
	
-- 3. What was the first item from the menu purchased by each customer?

SELECT 
	s.customer_id,
	s.order_date,
	m.product_name
FROM
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
WHERE 
	s.order_date = '2021-01-01'
ORDER BY
	s.customer_id;
	
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
	m.product_name,
	count(s.product_id) as num_purchased
FROM menu m 
INNER JOIN sales s 
	ON m.product_id = s.product_id
GROUP BY 
	m.product_name
ORDER BY 
	num_purchased desc
LIMIT 1;

-- 5. Which item was the most popular for each customer?

SELECT
	s.customer_id,
	m.product_name,
	COUNT(s.product_id) as num_purchase
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
GROUP BY
	s.customer_id, m.product_name
ORDER BY
	s.customer_id asc, num_purchase desc;

-- 6. Which item was purchased first by the customer after they became a member?

SELECT 
	s.customer_id,
	s.order_date,
	m.product_name
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
INNER JOIN members mem
	ON s.customer_id = mem.customer_id
WHERE 
	s.order_date >= join_date
ORDER BY
	s.customer_id , order_date;
	
-- 7. Which item was purchased just before the customer became a member?

SELECT 
	s.customer_id,
	s.order_date,
	m.product_name
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
INNER JOIN members mem
	ON s.customer_id = mem.customer_id
WHERE 
	s.order_date < join_date
ORDER BY
	s.customer_id , order_date desc;
	
-- 8. What is the total items and amount spent for each member before they became a member?

SELECT
	s.customer_id,
	COUNT(s.product_id) AS num_items,
	SUM(m.price) AS total_amount_spent
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
INNER JOIN members mem
	ON s.customer_id = mem.customer_id
WHERE 
	order_date < join_date
GROUP BY
	s.customer_id
ORDER BY
	s.customer_id;
	
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT
	s.customer_id,
	SUM(CASE
			WHEN m.product_name = 'sushi' THEN price*20
			ELSE mprice*10
		END) AS total_points
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
GROUP BY 
	s.customer_id
ORDER BY
	s.customer_id;

