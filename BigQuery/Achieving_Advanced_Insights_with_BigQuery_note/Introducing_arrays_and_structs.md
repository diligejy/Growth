## 1. Arrays are supported natively in BigQuery

- Arrays are ordered lists of zero or more data values that must have the same data type

## 2. Working with SQL arrays

- Create an array with brackets []

```SQL
SELECT
    ['raspberry', 'blackberry', 'strawberry', 'cherry'] AS fruit_array
```