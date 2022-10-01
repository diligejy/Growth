## Task 2. Troubleshooting CREATE TABLE statements

### Rules for creating tables with SQL in BigQuery

Read through these create table rules which you will use as your guide when fixing broken queries:

- Either the specified column list or inferred columns from a query_statement (or both) must be present.

- When both the column list and the as query_statement clause are present, BigQuery ignores the names in the as query_statement clause and matches the columns with the column list by position.

- When the as query_statement clause is present and the column list is absent, BigQuery determines the column names and types from the as query_statement clause.

- Column names must be specified either through the column list or as query_statement clause.

- Duplicate column names are not allowed.

### Query : The gatekeeper
```SQL
#standardSQL
# copy one day of ecommerce data to explore
CREATE OR REPLACE TABLE ecommerce.all_sessions_raw_20170801
#schema
(
  fullVisitorId STRING NOT NULL OPTIONS(description="Unique visitor ID"),
  channelGrouping STRING NOT NULL OPTIONS(description="Channel e.g. Direct, Organic, Referral..."),
  totalTransactionRevenue INT64 NOT NULL OPTIONS(description="Revenue * 10^6 for the transaction")
)
 OPTIONS(
   description="Raw data from analyst team into our dataset for 08/01/2017"
 ) AS
 SELECT fullVisitorId, channelGrouping, totalTransactionRevenue FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE date = '20170801'  #56,989 records
;
```
Valid: This query will process 907.52 MiB when run.

> The query will fail. You need to specify totalTransactionRevenue as nullable (NULL) since not all visitors will buy


### Query 5: Working as intended
What are the key benefits to formally defining a table schema as opposed to relying on your query statement for the field names and data types?
- You can specify expected data types (rather than rely on inference)
- You can specify REQUIRED fields (NOT NULL)
- You can specify field descriptions.
- You may not have any existing data yet to populate the table with inferred field names in a query statement


## What are ways to overcome stale data?
There are two ways to overcome stale data in reporting tables:

1. Periodically refresh the permanent tables by re-running queries that insert in new records. This can be done with [BigQuery scheduled queries](https://cloud.google.com/bigquery/docs/scheduling-queries) or with a [Cloud Dataprep](https://cloud.google.com/dataprep/) / [Cloud Dataflow](https://cloud.google.com/dataflow/) workflow.
2. Use logical views to re-run a stored query each time the view is selected


## Task 3. Creating views

Views are saved queries that are run each time the view is called. In BigQuery, views are logical and not materialized. Only the query is stored as part of the view -- not the underlying data.

```SQL
#standardSQL
CREATE OR REPLACE VIEW ecommerce.vw_latest_transactions
AS
SELECT DISTINCT
  date,
  fullVisitorId,
  CAST(visitId AS STRING) AS visitId,
  channelGrouping,
  totalTransactionRevenue / 1000000 AS totalTransactionRevenue
 FROM `data-to-insights.ecommerce.all_sessions_raw`
 WHERE totalTransactionRevenue IS NOT NULL
 ORDER BY date DESC # latest transactions
 LIMIT 100
;
```

> Note: It is often difficult to know whether or not you are SELECTing from a Table or a View by just looking at the name. A simple convention is to prefix the view name with vw_ or add a suffix like _vw or _view.

## [BigQuery DDL](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-definition-language)