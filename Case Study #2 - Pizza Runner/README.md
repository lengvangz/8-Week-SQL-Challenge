# 🍕 Case Study #2 Pizza Runner

<img src="https://user-images.githubusercontent.com/81607668/127271856-3c0d5b4a-baab-472c-9e24-3c1e3c3359b2.png" alt="Image" width="500" height="520">

## 📖 Table of Contents
- [Situation](#Situation)
- [Task](#Task)
- [Actions](#Actions)
  - [Data Cleaning and Transformation](#-data-cleaning--transformation)
  - [A. Pizza Metrics](#a-pizza-metrics)
  - [B. Runner and Customer Experience](#b-runner-and-customer-experience)
  - [C. Ingredient Optimisation](#c-ingredient-optimisation)
  - [D. Pricing and Ratings](#d-pricing-and-ratings)

## ‼️ Situation
Danny was sold on the idea of "80s Retro Styling and Pizza Is The Future!" and wanted to Uberize it as well.  Combining these two concepts, Pizza Runner was launched. 

Danny started recruiting "runners" to deliver pizza from Pizza Runner HQ and also maxed out his credit card to pay freelancers to develop a mobile app to accept orders.

## 📋 Task

Danny created an entity-relationship diagram of his database design but requires help with data cleaning and performing basic calculations to improve the direction of his runners and streamline Runner Pizza's operations.

###  Entity Relationship Diagram
![image](https://github.com/katiehuangx/8-Week-SQL-Challenge/assets/81607668/78099a4e-4d0e-421f-a560-b72e4321f530)

## 🏃 Actions

### Data Cleaning & Transformation

#### 🪛 Table: customer_orders

On the `customer_orders` table below, there are:
- Blank spaces, null values, and 'null' values (as a string) in the `exclusions` column.
- Blank spaces, null values, and 'null' values (as a string) in the `extras` column.

<img width="1063" alt="image" src="https://github.com/lengvangz/images/blob/main/customer_orders%20table.png">

Steps taken to clean table:
- Create a temporary table and be the copy of the original table.
- Change the null values and 'null' values into blank spaces.

````sql
DROP TABLE IF EXISTS customer_orders_temp;

CREATE TEMP TABLE customer_orders_temp AS
SELECT
  order_id,
  customer_id,
	pizza_id,
	CASE
		WHEN exclusions IS NULL OR exclusions LIKE 'null'  THEN ' '
		ELSE exclusions
	END as exclusions, 
	CASE
		WHEN extras IS NULL OR extras LIKE 'null' THEN ' '
		ELSE extras
	END as extras,
	order_time
FROM pizza_runner.customer_orders;
````

Result:
- all null values and 'null' values in both columns are now blank spaces

<img width="1063" alt="image" src="https://github.com/lengvangz/images/blob/main/customer_orders_temp%20table.png">

