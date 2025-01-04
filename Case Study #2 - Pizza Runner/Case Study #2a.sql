/* --------------------
   Pizza Metrics 
   --------------------*/

-- 1. How many pizzas were ordered?

SELECT 
	COUNT(order_id) AS num_pizza_ordered
FROM 
	customer_orders_temp;
	
-- 2. How many unique customer orders were made?

SELECT
	COUNT(DISTINCT order_id) AS unique_order
FROM 
	customer_orders_temp;
	
-- 3. How many successful orders were delievered by each runner?

SELECT 
	runner_id,
	COUNT(order_id) as successful_order
FROM 
	runner_orders_temp
WHERE
	distance IS NOT NULL
GROUP BY 
	runner_id
ORDER BY
	runner_id asc;
	
-- 4. How many of each type of pizza was delivered?

SELECT 
	p.pizza_name,
	COUNT(c.pizza_id) as pizza_delivered
FROM
	customer_orders_temp c
INNER JOIN runner_orders_temp r
	ON c.order_id = r.order_id
INNER JOIN pizza_names p
	ON c.pizza_id = p.pizza_id
WHERE
	distance IS NOT NULL
GROUP BY 
	p.pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT
	c.customer_id,
	p.pizza_name,
	count(c.pizza_id) as num_ordered
FROM 
	pizza_names p
INNER JOIN customer_orders_temp c
	ON p.pizza_id = c.pizza_id
GROUP BY 
	c.customer_id,
	p.pizza_name
ORDER BY 
	c.customer_id;

-- 6. What was the maximum number of pizzas delivered in a single order?

SELECT
	c.order_id,
	COUNT(c.pizza_id) as num_pizza
FROM 
	customer_orders_temp c
INNER JOIN runner_orders_temp r
	ON c.order_id = r.order_id
WHERE 
	distance IS NOT NULL
GROUP BY
	c.order_id
ORDER BY
	num_pizza desc
LIMIT 1;
	
-- 7. For each customer, how many delievered pizzas had at least 1 change and how many had no changes?

SELECT
	c.customer_id,
	COUNT(
		CASE
			WHEN c.exclusions != '' OR c.extras != '' THEN 1
		END
	) AS custom,
	COUNT(
		CASE
			WHEN c.exclusions = '' AND c.extras = '' THEN 1
		END
	) AS regular
FROM 
	customer_orders_temp c
INNER JOIN runner_orders_temp r
	ON c.order_id = r.order_id
WHERE 
	distance IS NOT NULL
GROUP BY
	c.customer_id
ORDER BY
	c.customer_id;

-- 8. How many pizzas were delievered that had both exclusions and extras?

SELECT
	COUNT(
		CASE
			WHEN c.exclusions != '' AND c.extras !='' THEN 1
		END
	) AS both_exlusions_and_extras
FROM
	customer_orders_temp c
INNER JOIN runner_orders_temp r
	ON c.order_id = r.order_id
WHERE
	distance IS NOT NULL

	


-- 9. What was the total volume of pizzas ordered for each hour of the day?

SELECT
	EXTRACT(HOUR FROM order_time) AS order_hour, 
	COUNT(*) AS num_pizzas
FROM 
	customer_orders_temp 
GROUP BY 
	order_hour
ORDER BY 
	order_hour; 

-- 10. What was the volume of orders for each day of the week?

SELECT
	TO_CHAR(order_time, 'day') AS day_of_week,
	COUNT(pizza_id) AS num_pizza
FROM 
	customer_orders_temp
GROUP BY 
	day_of_week;



	

