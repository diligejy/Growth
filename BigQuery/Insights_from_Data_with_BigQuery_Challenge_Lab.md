## Scenario
You're part of a public health organization which is tasked with identifying answers to queries related to the Covid-19 pandemic. Obtaining the right answers will help the organization in planning and focusing healthcare efforts and awareness programs appropriately.

The dataset and table that will be used for this analysis will be : `bigquery-public-data.covid19_open_data.covid19_open_data`. This repository contains country-level datasets of daily time-series data related to COVID-19 globally. It includes data relating to demographics, economy, epidemiology, geography, health, hospitalizations, mobility, government response, and weather.

## Task 1. Total confirmed cases

Build a query that will answer "What was the total count of confirmed cases on `May 25, 2020 `?" The query needs to return a single row containing the sum of confirmed cases across all countries. The name of the column should be `total_cases_worldwide`.

Columns to reference:
- cumulative_confirmed
- date

```SQL 
SELECT sum(cumulative_confirmed) as total_cases_worldwide
FROM bigquery-public-data.covid19_open_data.covid19_open_data
WHERE date = '2020-05-25'
```

## Task 2. Worst affected areas

- Build a query for answering "How many states in the US had more than `150` deaths on `May 25, 2020`?" The query needs to list the output in the field count_of_states.

Note: Don't include NULL values.

Columns to reference:

- country_name
- subregion1_name (for state information)
- cumulative_deceased

```SQL
SELECT count(subregion1_name) as count_of_states
FROM 
(
  SELECT subregion1_name
  , sum(cumulative_deceased) as sum_of_cumulative_deceased
  FROM 
  (
    SELECT subregion1_name, cumulative_deceased
    FROM bigquery-public-data.covid19_open_data.covid19_open_data
    WHERE date = '2020-05-25'
    AND country_name = 'United States of America'
  )
  GROUP BY subregion1_name
  HAVING sum_of_cumulative_deceased > 150
)
```

## Task 3. Identifying hotspots

- Build a query that will answer "List all the states in the United States of America that had more than `1000` confirmed cases on `May 25, 2020` ?" The query needs to return the State Name and the corresponding confirmed cases arranged in descending order. Name of the fields to return state and total_confirmed_cases.

```SQL
 SELECT subregion1_name as state 
  , sum(cumulative_confirmed) as total_confirmed_cases
  FROM 
  (
    SELECT subregion1_name, cumulative_confirmed
    FROM bigquery-public-data.covid19_open_data.covid19_open_data
    WHERE date = '2020-05-25'
    AND country_name = 'United States of America'
    AND subregion1_name is not null
  )
  GROUP BY subregion1_name
  HAVING total_confirmed_cases > 1000
ORDER BY total_confirmed_cases DESC
```

## Task 4. Fatality ratio

1. Build a query that will answer "What was the case-fatality ratio in Italy for the month of `June` 2020?" Case-fatality ratio here is defined as (total deaths / total confirmed cases) * 100.

```SQL 
SELECT 
  sum(cumulative_confirmed) as total_confirmed_cases
  , sum(cumulative_deceased) as total_deaths
  , (sum(cumulative_deceased)/sum(cumulative_confirmed))*100 as case_fatality_ratio 
FROM `bigquery-public-data.covid19_open_data.covid19_open_data` 
WHERE country_name="Italy" 
AND date BETWEEN '2020-06-01'and '2020-06-30'

```

## Task 5. Identifying specific day

Build a query that will answer: "On what day did the total number of deaths cross `14000` in Italy?" The query should return the date in the format yyyy-mm-dd.

```SQL
SELECT 
  date
FROM bigquery-public-data.covid19_open_data.covid19_open_data
WHERE country_name="Italy" 
AND cumulative_deceased > 14000
ORDER BY date
LIMIT 1
```

## Task 6. Finding days with zero net new cases

The following query is written to identify the number of days in India between `24, Feb 2020` and `10, March 2020` when there were zero increases in the number of confirmed cases. However it is not executing properly.

```SQL
WITH india_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="India"
    AND date between '2020-02-24' and '2020-03-10'
  GROUP BY
    date
  ORDER BY
    date ASC
 )
, india_previous_day_comparison AS
(SELECT
  date,
  cases,
  LAG(cases) OVER(ORDER BY date) AS previous_day,
  cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
FROM india_cases_by_date
)

SELECT count(*)
FROM india_previous_day_comparison
WHERE net_new_cases=0
```

## Task 7. Doubling rate

- Using the previous query as a template, write a query to find out the dates on which the confirmed cases increased by more than `5` % compared to the previous day (indicating doubling rate of ~ 7 days) in the US between the dates March 22, 2020 and April 20, 2020. The query needs to return the list of dates, the confirmed cases on that day, the confirmed cases the previous day, and the percentage increase in cases between the days.

    - Use the following names for the returned fields: Date, Confirmed_Cases_On_Day, Confirmed_Cases_Previous_Day and Percentage_Increase_In_Cases.

```SQL
WITH us_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name='United States of America'
    AND date between '2020-03-22' and '2020-04-20'
  GROUP BY
    date
  ORDER BY
    date ASC
 )
, us_previous_day_comparison AS
(SELECT
  date,
  cases,
  LAG(cases) OVER(ORDER BY date) AS previous_day,
  cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
FROM us_cases_by_date
)

SELECT date as Date
    , cases as Confirmed_Cases_On_Day
    , previous_day as Confirmed_Cases_Previous_Day 
    , net_new_cases / previous_day * 100 as Percentage_Increase_In_Cases
FROM us_previous_day_comparison
WHERE net_new_cases / previous_day * 100 > 5
ORDER BY Date
```

## Task 8. Recovery rate

1. Build a query to list the recovery rates of countries arranged in descending order (limit to `5` ) upto the date May 10, 2020.

2. Restrict the query to only those countries having more than 50K confirmed cases.

  - The query needs to return the following fields: country, recovered_cases, confirmed_cases, recovery_rate.

Columns to reference:

* country_name
* cumulative_confirmed
* cumulative_recovered

```SQL
WITH cases_by_country AS (
  SELECT
    country_name AS country,
    sum(cumulative_confirmed) AS cases,
    sum(cumulative_recovered) AS recovered_cases
  FROM
    bigquery-public-data.covid19_open_data.covid19_open_data
  WHERE
    date = '2020-05-10'
  GROUP BY
    country_name
 )
, recovered_rate AS 
(SELECT
  country, cases, recovered_cases,
  (recovered_cases * 100)/cases AS recovery_rate
FROM cases_by_country
)
SELECT country, cases AS confirmed_cases, recovered_cases, recovery_rate
FROM recovered_rate
WHERE cases > 50000
ORDER BY recovery_rate desc
LIMIT 5
```

## Task 9. CDGR - Cumulative daily growth rate

- The following query is trying to calculate the CDGR on `April 15, 2020` (Cumulative Daily Growth Rate) for France since the day the first case was reported.The first case was reported on Jan 24, 2020.

- The CDGR is calculated as:

  `((last_day_cases/first_day_cases)^1/days_diff)-1)`

Where :

- last_day_cases is the number of confirmed cases on May 10, 2020

- first_day_cases is the number of confirmed cases on Jan 24, 2020

- days_diff is the number of days between Jan 24 - May 10, 2020

- The query isn’t executing properly. Can you fix the error to make the query execute successfully?

```SQL
WITH
  france_cases AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS total_cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="France"
    AND date IN ('2020-01-24',
      '2020-05-10')
  GROUP BY
    date
  ORDER BY
    date)
, summary as (
SELECT
  total_cases AS first_day_cases,
  LEAD(total_cases) AS last_day_cases,
  DATE_DIFF(LEAD(date) OVER(ORDER BY date),date, day) AS days_diff
FROM
  france_cases
LIMIT 1
)
select first_day_cases, last_day_cases, days_diff, SQRT((last_day_cases/first_day_cases),(1/days_diff))-1 as cdgr
from summary
```

`Note`: Refer to the following [Functions, operators, and conditionals documentation](https://cloud.google.com/bigquery/docs/reference/standard-sql/functions-and-operators) to learn more about the SQL function referenced `LEAD()`.

```SQL
WITH
  france_cases AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS total_cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="France"
    AND date IN ('2020-01-24',
      '2020-04-15')
  GROUP BY
    date
  ORDER BY
    date)
, summary as (
SELECT
  total_cases AS first_day_cases,
  LEAD(total_cases) OVER(ORDER BY date) AS last_day_cases,
  DATE_DIFF(LEAD(date) OVER(ORDER BY date),date, day) AS days_diff
FROM
  france_cases
LIMIT 1
)
SELECT first_day_cases
    , last_day_cases
    , days_diff
    , POW((last_day_cases/first_day_cases),(1/days_diff))-1 as cdgr
FROM summary
```

## Task 10. Create a Data Studio report

- Create a Google Data Studio report that plots the following for the United States:

  - Number of Confirmed Cases
  - Number of Deaths
  - Date range : 2020-03-31 to 2020-04-16

