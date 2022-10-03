

Using the provided query WITH clause below, write a SELECT statement that follows which calculates the avg_income (revenue - expenses) and sort the results by avg_income highest to lowest.

Also include year_filed and the other metrics from the WITH clause in your result.

```SQL
#standardSQL
WITH summary AS (
# count of filings, revenue, expenses since 2013
SELECT
  CONCAT("20",_TABLE_SUFFIX) AS year_filed,
  COUNT(ein) AS nonprofit_count,
  AVG(totrevenue) AS avg_revenue,
  AVG(totfuncexpns) AS avg_expenses
FROM `bigquery-public-data.irs_990.irs_990_20*`
WHERE _TABLE_SUFFIX >= '13'
GROUP BY year_filed
ORDER BY year_filed DESC
)
# write your code here
```

Compare your result against the solution below:

```SQL
#standardSQL
WITH summary AS (
# count of filings, revenue, expenses since 2013
SELECT
  CONCAT("20",_TABLE_SUFFIX) AS year_filed,
  COUNT(ein) AS nonprofit_count,
  AVG(totrevenue) AS avg_revenue,
  AVG(totfuncexpns) AS avg_expenses
FROM `bigquery-public-data.irs_990.irs_990_20*`
WHERE _TABLE_SUFFIX >= '13'
GROUP BY year_filed
ORDER BY year_filed DESC
)
SELECT
  year_filed,
  nonprofit_count,
  avg_revenue,
  avg_expenses,
  avg_revenue - avg_expenses AS avg_income
FROM summary
ORDER BY avg_income DESC
```