# 🍕 Case Study #2 Pizza Runner

<img src="https://user-images.githubusercontent.com/81607668/127271856-3c0d5b4a-baab-472c-9e24-3c1e3c3359b2.png" alt="Image" width="500" height="520">

## 📖 Table of Contents
- [Situation](#Situation)
- [Task](#Task)
- [Actions](#Actions)
  - [Data Cleaning and Transformation](#Data-cleaning--transformation)
  - [Answers](#Answers)
  	- [A) Pizza Metrics](#A-pizza-metrics)
  	- [B) Runner and Customer Experience](#B-runner-and-customer-experience)
  	- [C) Ingredient Optimisation](#C-Ingredient-Optimisation)
  	- [D) Pricing and Ratings](#D-pricing-and-ratings)

## Situation
Danny was sold on the idea of "80s Retro Styling and Pizza Is The Future!" and wanted to Uberize it as well.  Combining these two concepts, Pizza Runner was launched. 

Danny started recruiting "runners" to deliver pizza from Pizza Runner HQ and also maxed out his credit card to pay freelancers to develop a mobile app to accept orders.

## Task

Danny created an entity-relationship diagram of his database design but requires help with data cleaning and performing basic calculations to improve the direction of his runners and streamline Runner Pizza's operations.

###  Entity Relationship Diagram
![image](https://github.com/katiehuangx/8-Week-SQL-Challenge/assets/81607668/78099a4e-4d0e-421f-a560-b72e4321f530)

## Actions

### Data Cleaning & Transformation

#### 🪛 Table: customer_orders

On the `customer_orders` table below, there are:
- Blank spaces, null values, and 'null' values (as a string) in the `exclusions` column.
- Blank spaces, null values, and 'null' values (as a string) in the `extras` column.

<img width="1063" alt="image" src="https://github.com/lengvangz/images/blob/main/customer_orders%20table.png">

Steps taken to clean table:
- Created a temporary table and be the copy of the original table.
- Changed the null values and 'null' values into blank spaces.

````sql
DROP TABLE IF EXISTS customer_orders_temp;

CREATE TEMP TABLE customer_orders_temp AS
SELECT
  order_id,
  customer_id,
	pizza_id,
	CASE
		WHEN exclusions IS NULL OR exclusions LIKE 'null'  THEN ''
		ELSE exclusions
	END as exclusions, 
	CASE
		WHEN extras IS NULL OR extras LIKE 'null' THEN ''
		ELSE extras
	END as extras,
	order_time
FROM pizza_runner.customer_orders;
````

Result:
- all null values and 'null' values in both columns are now blank spaces.

<img width="1063" alt="image" src="https://github.com/lengvangz/images/blob/main/customer_orders_temp%20table.png">

#### 🪛 Table: runner_orders

On the `customer_orders` table below, there are:
- Blank spaces, null values, and 'null' values (as a string) in the `exclusions` column.
- Blank spaces, null values, and 'null' values (as a string) in the `extras` column.

<img width="1037" alt="image" src="https://github.com/lengvangz/images/blob/main/runner_order%20table.png">

Steps taken to clean `runner_order` table:
- Created a temporary table and be the copy of the original table.
- Replaced all 'null' values (as a string) into null values.
- Removed 'km', 'mins', 'minute', and 'minutes' from `distance` and `duration`.
- Replaced null values and 'null' values into blank spaces in the `cancellation` column.
- Altered data types in certain columns.

````sql
DROP TABLE IF EXISTS runner_orders_temp;
CREATE TEMP TABLE runner_orders_temp AS
SELECT
	order_id,
	runner_id,
	CASE
		WHEN pickup_time LIKE 'null' THEN NULL
		ELSE pickup_time
	END AS pickup_time,
	CASE 
		WHEN distance LIKE 'null' THEN NULL
		WHEN distance LIKE '%km' THEN TRIM('km' FROM distance)
		ELSE distance
	END as distance,
	CASE 
		WHEN duration LIKE 'null' THEN NULL
		WHEN duration LIKE '%mins' THEN TRIM('mins' FROM duration)
		WHEN duration LIKE '%minute' THEN TRIM('minute' FROM duration)
		WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration)
		ELSE duration
	END as duration,
	CASE
		WHEN cancellation IS NULL OR cancellation LIKE 'null' THEN ''
		ELSE cancellation
	END as cancellation 
FROM pizza_runner.runner_orders;

ALTER TABLE runner_orders_temp 
ALTER COLUMN pickup_time TYPE timestamp USING pickup_time::timestamp without time zone,
ALTER COLUMN distance TYPE numeric USING distance::numeric,
ALTER COLUMN duration TYPE integer USING duration::integer;
````

Result of the `runner_order_temp` table:

<img widt= "915" alt="image" src="https://github.com/lengvangz/images/blob/main/runner_order_temp%20table.png">

***

## Answers

### A) Pizza Metrics

#### 1. How many pizzas were ordered?

````sql
SELECT 
	COUNT(order_id) AS num_pizza_ordered
FROM 
	customer_orders;
````

#### Answer:
| num_pizza |
| --------- |
| 14        |

- 14 pizzas were ordered.

***
  
#### 2. How many unique customer orders were made?

````sql
SELECT
	COUNT(DISTINCT order_id) AS unique_order
FROM 
	customer_orders_temp;
````

#### Answer:
 | unique_order |
 | --------- |
 | 10        |

- 10 unique customer orders were made.

***

#### 3. How many successful orders were delievered by each runner?

````sql
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
````

#### Answer:
| runner_id  | succesful_order |
| - | --------- |
| 1 | 4        |
| 2 | 3        |
| 3 | 2        |

- runner 1 had 4 succesful orders.  
- runner 2 had 3 succesful orders.
- runner 3 had 2 succesful orders.   

***

#### 4. How many of each type of pizza was delivered?

````sql
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
````

#### Answer:
| pizza_name | pizza_delivred |
| - | --------- |
| Meatlovers | 9        |
| Vegetarian | 3        |

- 9 Meatlovers pizza were delivered.
- 3 Vegetarian pizzas were delivered.

***

#### 5. How many Vegetarian and Meatlovers were ordered by each customer?

````sql
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
````

#### Answer:
| customer_id | pizza_name | num_ordered |
| - | --------- | --------- | 
| 101 | Meatlovers        | 2        |
| 101 | Vegetarian        | 1 	     |
| 102 | Meatlovers        | 2        |
| 102 | Vegetarian        | 1 	     |
| 103 | Meatlovers        | 3        |
| 103 | Vegetarian        | 1 	     |
| 104 | Meatlovers        | 3        |
| 105 | Vegetarian        | 1 	     |

- customer 101 ordered 2 Meatlovers and 1 Vegetarian.
- customer 102 ordered 2 Meatlovers and 1 Vegetarian.
- customer 103 ordered 3 Meatlovers and 1 Vegetarian.
- customer 104 ordered 3 Meatlovers.
- customer 105 ordered 1 Vegetarian.

***

#### 6. What was the maximum number of pizzas delivered in a single order?

````sql
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
````

#### Answer:
| order_id | num_pizza |
| - | --------- |
| 4 | 3        |

- The maximum number of pizzas delievered in a single order was 3.

***

#### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

````sql
SELECT
	c.customer_id,
	COUNT(
		CASE
			WHEN c.exclusions != '' OR c.extras != '' THEN 1
		END) AS custom,
	COUNT(
		CASE
			WHEN c.exclusions = '' AND c.extras = '' THEN 1
		END) AS regular
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
````

#### Answer:
| customer_id | custom | regular |
| - | --------- | --------- |
| 101 | 0        | 2 |
| 102 | 0        | 3 |
| 103 | 3        | 0 |
| 104 | 2        | 1 |
| 105 | 1        | 0 |

- customer 101 had 0 custom order and 2 regular order.
- customer 102 had 0 custom order and 3 regular order.
- customer 103 had 3 custom order and 0 regular order.
- customer 104 had 2 custom order and 1 regular order.
- customer 105 had 1 custom order and 0 regular order.

***

#### 8. How many pizzas were delivered that had both exclusions and extras?

````sql
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
````
#### Answer:
 | both_exclusions_and_extras |
 | --------- |
 | 1        | 


- 1 pizzas was delivered that had both exclusions and extras.

***

#### 9. What was the total volume of pizzas ordered for each hour of the day?

````sql
SELECT
	EXTRACT(HOUR FROM order_time) AS order_hour, 
	COUNT(*) AS num_pizzas
FROM 
	customer_orders
GROUP BY 
	order_hour
ORDER BY 
	order_hour;
````
#### Answer:
| order_hour | num_pizzas |
| --------- | --------- |
| 11        | 1 |
| 13        | 3 |
| 18        | 3 |
| 19        | 1 |
| 21        | 3 |
| 23        | 3 |


- on the 11th hour, 1 pizza was ordered.
- on the 13rd hour, 3 pizzas was ordered.
- on the 18th hour, 3 pizzas was ordered.
- on the 19th hour, 1 pizzas was ordered.
- on the 21st hour, 3 pizzas was ordered.
- on the 23rd hour, 3 pizzas was ordered.

***

#### 10. What was the volume of orders for each day of the week?

````sql
SELECT
	TO_CHAR(order_time, 'day') AS day_of_week,
	COUNT(pizza_id) AS num_pizza
FROM 
	customer_orders_temp
GROUP BY 
	day_of_week;
````
#### Answer:
| day_of_week | both_exclusions_and_extras |
| - | --------- |
| wednesday | 5        |
| thursday | 3        | 
| friday | 1        | 
| saturday | 5        | 


- Wednesday had 5 orders of pizzas.
- Thursday had 3 orders of pizzas.
- Friday had 1 order of pizzas.
- Saturday had 5 orders of pizzas.

***

### B) Runner and Customer Experience

#### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

````sql
-- offset dates by three days to ensure EXTRACT() starts 01/01/2021
SELECT 
	EXTRACT(week FROM registration_date + 3) AS week_period,
	COUNT(*) AS num_runner
FROM 
	runners
GROUP BY 
	week_period
ORDER BY
	week_period 
````

#### Answer:
| week_period | num_runner |
| --------- | --------- |
| 1        | 2        |
| 2        | 1       |
| 3        | 1        |

- Starting 2021-01-01, week 1 had 2 runners signed up.
- Starting 2021-01-01, week 2 had 1 runners signed up.
- Starting 2021-01-01, week 3 had 1 runners signed up.

***

#### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?


````sql
SELECT 
	DATE_TRUNC('minute',AVG(pickup_time - order_time))
FROM 
	runner_orders_temp r
INNER JOIN customer_orders_temp c
	ON r.order_id = c.order_id
WHERE
	distance IS NOT NULL;
````

#### Answer:
| avg_time |
| --------- |
| 00:18:00        |

- 18 minutes was the average time for each runner to arrive from Pizza Runner HQ to order pickup.

***

#### 4. What was the average distance travelled for each customer?

````sql
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
````

#### Answer:
| customer_id | avg_distance |
| --------- | --------- |
| 101        | 20.00        |
| 102        | 16.73        |
| 103        | 23.40        |
| 104        | 10.00        |
| 105        | 25.00        |

- For customer 101, the average distance traveled was 20km.
- For customer 102, the average distance traveled was 16.73km.
- For customer 103, the average distance traveled was 23.40km.
- For customer 104, the average distance traveled was 10km.
- For customer 105, the average distance traveled was 25km.
  
***

#### 5. What was the difference between the longest and shortest delivery times for all orders?

````sql
SELECT
	MAX(duration) - MIN(duration) AS diff_delivery_times
FROM 
	runner_orders_temp
````

#### Answer:
| diff_delivery_times |
| --------- |
| 30        |

- 30 minutes is the difference between the longest and shortest delivery times.

***

#### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

````sql
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
````

#### Answer:
| order_id | runner_id | avg_speed |
| --------- | --------- | --------- |
| 1        | 1        | 37.50        |
| 2        | 1        | 44.44        |
| 3        | 1        | 40.20        |
| 4        | 2        | 35.10        |
| 5        | 3        | 40.00        |
| 7        | 2        | 60.00        |
| 8        | 2        | 93.60        |
| 10        | 1        | 60.00        |

- Runner 1's average speed was 37.50, 44.44, and 35.10 in kmph for order 1, 2, and 3.
- Runner 2's average speed was  35.10, 60.00, and 93.60 in pmph for order 4, 7, and 8.
- Runner 3's average speed was 40.00 in kmph for order 5.
- Runner 2's 93.60 is high compare to others.  Could be an error.

***

#### 7. What is the successful delivery percentage for each runner?

````sql
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
````

#### Answer:
| runner_id | delivery_percentage |
| --------- | --------- |
| 1        | 100        |
| 2        | 75        |
| 2        | 50        |

- Runner 1 has a 100% delivery success rate.
- Runner 2 has a 75% delivery success rate.
- Runner 3 has a 50% delivery success rate

***

### C) Ingredient Optimisation

#### 1. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***

#### 2. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***

#### 3. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***

#### 4. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***

#### 5. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***

#### 6. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***

### D) Pricing and Ratings

#### 1. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***

#### 2. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***

#### 3. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***

#### 4. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***

#### 5. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***

#### 6. question

````sql
--Code
````

#### Answer:
| name | name |
| --------- | --------- |
| data        | data        |

- answer.

***
