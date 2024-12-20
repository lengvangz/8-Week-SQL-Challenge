# 🍜 Case Study #1: Danny's Diner 
<img src="https://user-images.githubusercontent.com/81607668/127727503-9d9e7a25-93cb-4f95-8bd0-20b87cb4b459.png" alt="Image" width="500" height="520">

## 📚 Table of Contents
- [Situation](#Situation)
- [Task](#Task)
- [Actions](#Actions)

Please note that all the information regarding the case study has been sourced from the following link: [here](https://8weeksqlchallenge.com/case-study-1/). 

***

## Situation
Danny's Diner needs help to stay in business.  The resturant has collected some basic data over a few months of operation but is unsure how to use it to improve business performance.   

***

## Task
Danny wants to analyze the data to answer some key questions about his customers, regarding their visit frequencies, spending habits, and favorite menu items.

### Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/81607668/127271130-dca9aedd-4ca9-4ed8-b6ec-1e1920dca4a8.png)


***

## Action 

[Sourcecode](https://github.com/lengvangz/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's%20Diner/Case%20Study%20%231.sql)

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



