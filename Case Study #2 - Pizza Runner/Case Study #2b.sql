/* --------------------
   Runner and Customer Experience 
   --------------------*/

-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT 
	EXTRACT(week FROM registration_date + 3) AS week_period,
	COUNT(*) AS num_runner
FROM 
	runners
GROUP BY 
	week_period
ORDER BY
	week_period 

-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT 
	DATE_TRUNC('minute', AVG(pickup_time - order_time)) AS avg_time
FROM 
	runner_orders_temp r
INNER JOIN customer_orders_temp c
	ON r.order_id = c.order_id
WHERE 
	distance IS NOT NULL;

-- 4. What was the average distance travelled for each customer?

SELECT 
	c.customer_id,
	ROUND(AVG(r.distance), 2) AS avg_distance
FROM 
	customer_orders_temp c
INNER JOIN runner_orders_temp r
	on c.order_id = r.order_id
WHERE 
	distance IS NOT NULL
GROUP BY
	c.customer_id
ORDER BY
	c.customer_id;


-- 5. What was the difference between the longest and shortest delivery times for all orders?

SELECT
	MAX(duration) - MIN(duration) AS diff_delivery_times
FROM 
	runner_orders_temp 

-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

--average speed is in km/h
SELECT 
	order_id,
	runner_id,
	ROUND((distance/duration) * 60, 2) AS avg_speed
FROM
	runner_orders_temp
WHERE
	distance IS NOT NULL
GROUP BY
	order_id,
	runner_id,
	avg_speed
ORDER BY
	order_id;

-- 7. What is the successful delivery percentage for each runner?

SELECT
	runner_id,
	100 * SUM(
			CASE
				WHEN distance IS NULL THEN 0
				ELSE 1 
			END) / COUNT(*) AS delivery_percentage
FROM 
	runner_orders_temp
GROUP BY 
	runner_id
ORDER BY
	runner_id

