# 🍜 Case Study #1: Danny's Diner 
<img src="https://user-images.githubusercontent.com/81607668/127727503-9d9e7a25-93cb-4f95-8bd0-20b87cb4b459.png" alt="Image" width="500" height="520">

## 📖 Table of Contents
- [Situation](#Situation)
- [Task](#Task)
- [Actions](#Actions)

***

## ‼️ Situation
Danny's Diner needs help to stay in business.  The resturant has collected some basic data over a few months of operation but is unsure how to use it to improve business performance.   

***

## 📋 Task
Danny wants to analyze the data to answer some key questions about his customers, regarding their visit frequencies, spending habits, and favorite menu items.

### Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/81607668/127271130-dca9aedd-4ca9-4ed8-b6ec-1e1920dca4a8.png)


***

## Action 

[Source Code](https://github.com/lengvangz/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's%20Diner/Case%20Study%20%231.sql)

**1. What is the total amount each customer spent at the restaurant?**

````sql
SELECT 
	s.customer_id,
	SUM(m.price) AS total_amount_spent
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
GROUP BY 
	s.customer_id
ORDER BY 
	s.customer_id;
````

#### Answer:
| customer_id | total_sales |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

- Customer A spent $76.
- Customer B spent $74.
- Customer C spent $36.

***

**2. How many days has each customer visited the restaurant?**

````sql
SELECT 
	customer_id,
	COUNT(DISTINCT order_date) AS num_visited
FROM 
	sales
GROUP BY
	customer_id;
````

#### Answer:
| customer_id | visit_count |
| ----------- | ----------- |
| A           | 4           |
| B           | 6           |
| C           | 2           |

- Customer A vistied 4 times.
- Customer B visited 6 times.
- Customer C visited 2 times.

***

**3. What was the first item from the menu purchased by each customer?**

````sql
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
````

#### Answer:
| customer_id | order_date  | product_name | 
| ----------- | ----------- | ------------ |
| A           | 2021-01-01  | sushi        |
| A           | 2021-01-01  | curry        |
| B           | 2021-01-01  | curry        |
| C	      | 2021-01-01  | ramen	   |
| C	      | 2021-01-01  | ramen	   |

- Customer A first order was sushi and curry.
- Customer B first order was curry.
- Customer C first order was ramen.

***

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

````sql
SELECT 
	m.product_name,
	COUNT(s.product_id) AS num_purchased
FROM 
	menu m 
INNER JOIN sales s 
	ON m.product_id = s.product_id
GROUP BY 
	m.product_name
ORDER BY 
	num_purchased DESC
LIMIT 1;
````

#### Answer:
| product_name | num_purchased |
| ------------ | ------------- | 
| ramen        | 8             | 


- The most popular item on the menu is ramen, which was ordered 8 times.

***

**5. Which item was the most popular for each customer?**

````sql
SELECT
	s.customer_id,
	m.product_name,
	COUNT(s.product_id) AS num_purchase
FROM 
	sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
GROUP BY
	s.customer_id, m.product_name
ORDER BY
	s.customer_id ASC, num_purchase DESC;
````

#### Answer:
| customer_id | product_name  | num_purchase | 
| ----------- | ------------- | ------------ |
| A           | ramen  	      | 3            |
| A           | curry         | 2            |
| A           | sushi         | 1            |
| B	      | sushi         | 2	     |
| B	      | curry         | 2	     |
| B	      | ramen         | 2	     |
| C	      | ramen         | 3	     |

- Customer A most popular item was ramen.
- Customer B most popular item was both sushi and curry.
- Customer C most popular item was ramen.

***

**6. Which item was purchased first by the customer after they became a member?**

````sql
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
	s.order_date > join_date
ORDER BY
	s.customer_id , order_date;
````

#### Answer:
| customer_id | order_date  | product_name | 
| ----------- | ----------- | ------------ |
| A           | 2021-01-10  | ramen        |
| A           | 2021-01-11  | ramen        |
| A	      | 2021-01-11  | ramen	   |
| B	      | 2021-01-11  | sushi	   |
| B	      | 2021-01-16  | ramen	   |
| B	      | 2021-02-01  | ramen	   |

- The first item Customer A purchased after becoming a member was ramen.
- The first item Customer B purchased after becoming a member was sushi.

***

**7. Which item was purchased just before the customer became a member?**

````sql
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
````

#### Answer:
| customer_id | order_date  | product_name | 
| ----------- | ----------- | ------------ |
| A           | 2021-01-01  | sushi        |
| A           | 2021-01-01  | curry        |
| B	      | 2021-01-04  | sushi	   |
| B	      | 2021-01-02  | curry	   |
| B	      | 2021-02-01  | curry	   |

- The item Customer A purchased before becoming a member was sushi and curry.
- The item Customer B purchased before becoming a member was sushi.

***

**8. What is the total items and amount spent for each member before they became a member**

````sql
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
````

#### Answer:
| customer_id | num_items | total_amount_spent | 
| ----------- | --------- | ------------------ |
| A           | 2         | 25                 |
| B           | 3         | 40                 |


- Customer A purchased a total of 2 items, spending $25 in total.
- Customer B purchased a total of 3 items, spending $40 in total.

***

**9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**

````sql
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
````

#### Answer:
| customer_id | total_point |  
| ----------- | ----------- | 
| A           | 860         | 
| B           | 940         |
| C           | 360         | 


- Customer A would have 860 points.
- Customer B would have 941 points.
- Customer C would have 360 points.

***
