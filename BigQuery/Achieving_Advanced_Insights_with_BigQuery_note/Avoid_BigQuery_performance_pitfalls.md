## 1. Four Key elements of work

- Input/Output : How many bytes did you read? Write to storage?

- Communication between slots (shuffle) : How many bytes did you pass to the next stage?

- CPU work : User-defined functions(UDFs), functions

- SQL Syntax - Is there a more efficient way to write your query?

## 2. Avoid Input/output wastefulness

- Do not SELECT *, (use only the columns you need)

- Denormalize your schemas and take advantage of nested and repeated fields

- Use granular suffixes in your table wildcards for more specificity.

## 3. Use BigQuery native Storage for the best performance

- External direct data connections can never be cached.

- Live edits to underlying external sources (e.g. spreadsheets) could create race conditions.

- Native BigQuery tables have intelligence built-in like automatic predicate pushdown.

## 4. Optimize communication between slots (via shuffle)

- Pre-filter your data before doing JOINs

- Many shuffle stages can indicate data partition issues (skew)

## 5. Do not use WITH clauses in place of materializing results

```SQL
# standardSQL
#CTEs
WITH
    # 2015 filings joined with organization details
    irs_990_2015_ein AS (
        SELECT * 
        FROM 
            `bigquery-public-data.irs_990.irs_990_2015`
        JOIN 
            `bigquery-public-data.irs_990.irs_990_ein` USING (ein)
    ),

    # duplicate EINs in organization details
    duplidates AS (
        SELECT
            ein AS ein,
            count(ein) AS ein_count
        FROM 
            irs_990_2015_ein
        GROUP BY 
            ein
        HAVING
            ein_count > 1
    )
```

- Commonly filtering and transforming the same results? Store them into a permanent table

- WITH clause queries are not materialized and are re-queried if referenced more than once.

## 6. Be careful using GROUP BY across many distinct values

- Best when the number of distinct groups is small (fewer shuffles of data)

- Grouping by a high-cardinality unique ID is a bad idea.

## 7. Reduce Javascript UDFs to reduce computational load

- Javascript UDFs require BigQuery to launch a Java subprocess to runb 
- Use native SQL functions whenver possible
- Concurrent rate limits:
    - for non-UDF queries: 50
    - for UDF-queries: 6

## 8. Understand your data model before applying Joins and Unions

- Know your join conditions and if they're unique -- no accidental cross joins.
- Filter wildcard UNIONS with _TABLE_SUFFIX filter
- Do not use self-joins (consider window functions instead)