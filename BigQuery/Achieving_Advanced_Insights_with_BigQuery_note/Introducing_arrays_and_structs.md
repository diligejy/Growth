## 1. Arrays are supported natively in BigQuery

- Arrays are ordered lists of zero or more data values that must have the same data type

## 2. Working with SQL arrays

- Create an array with brackets []

```SQL
SELECT
    ['raspberry', 'blackberry', 'strawberry', 'cherry'] AS fruit_array
```

## 3. Aggregate into an array with ARRAY_AGG

```SQL
WITH fruits AS 
    (SELECT "apple" AS fruit
    UNION ALL
    SELECT "pear" AS fruit
    UNION ALL
    SELECT "banana" AS fruit)

SELECT ARRAY_AGG(fruit) AS fruit_basket
FROM fruits;
```

## 4. Sort array output with ORDER BY

```SQL
WITH fruits AS 
    (SELECT "apple" AS fruit
    UNION ALL
    SELECT "pear" AS fruit
    UNION ALL
    SELECT "banana" AS fruit)

SELECT ARRAY_AGG(fruit ORDER BY fruit) AS fruit_basket
FROM fruits;
```

## 5. Filter arrays using WHERE IN 

```SQL
WITH groceries AS
    (
        SELECT ['apple', 'pear', 'banana'] AS list
        UNION ALL 
        SELECT ['carrot', 'apple'] AS list
        UNION ALL
        SELECT ['water', 'wine'] AS list
    )

SELECT
    ARRAY(
        SELECT items FROM UNNEST(list) AS items
        WHERE 'apple' IN UNNEST(list)
    ) AS contains_apple
FROM groceries
```

## 6. STRUCTs are flexible containers

STRUCT are a container of ordered fields each with a type (required) and field name (optional).

You can store multiple data types in a STRUCT (even Arrays!)

```SQL
SELECT
STRUCT(35 AS age, 'Jacob' AS name)
```
```SQL
SELECT
STRUCT(35 AS age, 'Jacob' AS name) AS customers
```

## 7. STRUCTs can even contain ARRAY values

```SQL
SELECT
STRUCT(35 AS age, 'Jacob' AS name, ['apple', 'pear', 'peach'] AS items) AS customers
```

## 8. ARRAYs can contain STRUCTs as values

```SQL
SELECT
[
    STRUCT(35 AS age, 'Jacob' AS name, ['apple', 'pear', 'peach'] AS items),
    STRUCT(33 AS age, 'Miranda' AS name, ['water', 'pineapple', 'ice cream'] AS items) 
] AS customers
```

## 9. Filter for customers who bought ice cream

```SQL
WITH orders AS (
SELECT
[
    STRUCT(35 AS age, 'Jacob' AS name, ['apple', 'pear', 'peach'] AS items),
    STRUCT(33 AS age, 'Miranda' AS name, ['water', 'pineapple', 'ice cream'] AS items) 
] AS customers

)

SELECT customers
FROM orders AS o
CROSS JOIN UNNEST(o.customers) AS customers
WHERE 'ice cream' IN UNNEST(customers.items)