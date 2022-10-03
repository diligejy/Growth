
## 1. [Introduction to external data sources](https://cloud.google.com/bigquery/docs/external-data-sources#external_data_source_limitations)

Linking external tables to BigQuery (e.g. Google Spreadsheets or directly from Cloud Storage) has several limitations. Two of the most significant are:

1. Data consistency is not guaranteed if the data values in the source are changed while querying.
2. Data sources stored outside of BigQuery lose the performance benefits of having BigQuery manage your data storage (including but not limited to auto-optimization of your query execution path, certain wildcard functions are disabled, etc.).


## 2. 

