

## 1. Use the Right Function for the Right Job

- String Manipulation Functions - FORMAT()
- Aggregation Functions - SUM(), COUNT(), AVG(), MAX()
- Data Type Conversion Functions - CAST()
- Date Functions - PARSE_DATETIME()
- Statistical Functions
- Analytic Functions
- User-Defined Functions


## 2. Run Statistical functions over values 

```SQL
SELECT 
    STDDEV(noemployeesw3cnt) AS st_dev_employee_count
    , CORR(totprgmrevnue, totfuncexpns) AS corr_rev_expenses
FROM bigquery-public-data.irs_990.irs_990_2015
```

## 3. Try Approximate Aggregate functions when 'close enough' will do 

```SQL
SELECT 
    APPROX_COUNT_DISTINCT(ein) AS approx_count
    , COUNT(DISTINCT ein) AS exact_count
FROM bigquery-public-data.irs_990.irs_990_2015
```

## 4. Approximate users per year of all Github user logins

```SQL
SELECT 
    CONCAT('20', _TABLE_SUFFIX) year,
    APPROX_COUNT_DISTINCT(actor.login) approx_cnt
FROM `githubarchive.year.20*`
GROUP BY year
ORDER BY year
```

## 5. Bonus: Approximate unique GitHub Users since 2011

```SQL
WITH github_year_sketches AS (
    SELECT
        CONCAT('20', _TABLE_SUFFIX) AS year
        , APPROX_COUNT_DISTINCT(actor.login) AS approx_cnt
        , HLL_COUNT.INIT(actor.login) AS sketch # HyperLogLog Estimation
    FROM `githubarchive.year.20*`
    GROUP BY year
    ORDER BY year
)

SELECT HLL_COUNT.MERGE(sketch) AS approx_unique_users
FROM `github_year_sketches`
```