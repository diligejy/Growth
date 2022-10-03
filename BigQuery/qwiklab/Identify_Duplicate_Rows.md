Seeing a sample amount of data may give you greater intuition for what is included in the dataset.

- To preview sample rows from the table without using SQL, click the preview tab.
- Scan and scroll through the rows. There is no singular field that uniquely identifies a row, so you need advanced logic to identify duplicate rows.
- The query you'll use (below) uses the SQL GROUP BY function on every field and counts (COUNT) where there are rows that have the same values across every field:
- If every field is unique, the COUNT returns 1 as there are no other groupings of rows with the exact same value for all fields.
- If there are multiple rows with the same values for all fields, these rows are grouped together and the COUNT will be greater than 1.

The last part of the query is an aggregation filter using HAVING to only show the results that have a COUNT of duplicates greater than 1. Therefore, the number of records that have duplicates will be the same as the number of rows in the resulting table.

>>>

```SQL
#standardSQL
SELECT 
    COUNT(*) as num_duplicate_rows
    , * 

FROM
`data-to-insights.ecommerce.all_sessions_raw`

GROUP BY
fullVisitorId, channelGrouping, time, country, city, totalTransactionRevenue, transactions, timeOnSite, pageviews, sessionQualityDim, date, visitId, type, productRefundAmount, productQuantity, productPrice, productRevenue, productSKU, v2ProductName, v2ProductCategory, productVariant, currencyCode, itemQuantity, itemRevenue, transactionRevenue, transactionId, pageTitle, searchKeyword, pagePathLevel1, eCommerceAction_type, eCommerceAction_step, eCommerceAction_option

HAVING num_duplicate_rows > 1;
```

Note: In your own datasets, even if you have a unique key, it is still beneficial to confirm the uniqueness of the rows with COUNT, GROUP BY, and HAVING before you begin your analysis.