## 1. Create a dataset

Next, name your Dataset ID bqml_lab and click Create dataset.

## 2. Create a model

Now, move on to your task!

Go to BigQuery EDITOR, type or paste the following query to create a model that predicts whether a visitor will make a transaction:

```SQL
#standardSQL
CREATE OR REPLACE MODEL `bqml_lab.sample_model`
OPTIONS(model_type='logistic_reg') AS
SELECT
  IF(totals.transactions IS NULL, 0, 1) AS label,
  IFNULL(device.operatingSystem, "") AS os,
  device.isMobile AS is_mobile,
  IFNULL(geoNetwork.country, "") AS country,
  IFNULL(totals.pageviews, 0) AS pageviews
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20160801' AND '20170631'
LIMIT 100000;
```

Click RUN.

Here the visitor's device's operating system is used, whether said device is a mobile device, the visitor's country and the number of page views as the criteria for whether a transaction has been made.

In this case, bqml_lab is the name of the dataset and sample_model is the name of the model. The model type specified is binary logistic regression. In this case, label is what you're trying to fit to.

`Note: If you're only interested in 1 column, this is an alternative way to setting input_label_cols.
The training data is being limited to those collected from 1 August 2016 to 30 June 2017. This is done to save the last month of data for "prediction". It is further limited to 100,000 data points to save some time.`

Running the CREATE MODEL command creates a Query Job that will run asynchronously so you can, for example, close or refresh the BigQuery UI window.

## 3. Evaluate the model

Replace the previous query with the following and then click Run:

```SQL
#standardSQL
SELECT
  *
FROM
  ml.EVALUATE(MODEL `bqml_lab.sample_model`, (
SELECT
  IF(totals.transactions IS NULL, 0, 1) AS label,
  IFNULL(device.operatingSystem, "") AS os,
  device.isMobile AS is_mobile,
  IFNULL(geoNetwork.country, "") AS country,
  IFNULL(totals.pageviews, 0) AS pageviews
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'));
```

If used with a linear regression model, the above query returns the following columns:

- mean_absolute_error, mean_squared_error, mean_squared_log_error,
- median_absolute_error, r2_score, explained_variance.

If used with a logistic regression model, the above query returns the following columns:

- precision, recall
- accuracy, f1_score
- log_loss, roc_auc

Please consult the [machine learning glossary](https://developers.google.com/machine-learning/glossary/) or run a Google search to understand how each of these metrics are calculated and what they mean.

You'll realize the SELECT and FROM portions of the query is identical to that used during training. The WHERE portion reflects the change in time frame and the FROM portion shows that you're calling ml.EVALUATE.


## Use the Model

### Predict purchases per country


With this query you will try to predict the number of transactions made by visitors of each country, sort the results, and select the top 10 countries by purchases:

Replace the previous query with the following and then click Run:

```SQL
#standardSQL
SELECT
  country,
  SUM(predicted_label) as total_predicted_purchases
FROM
  ml.PREDICT(MODEL `bqml_lab.sample_model`, (
SELECT
  IFNULL(device.operatingSystem, "") AS os,
  device.isMobile AS is_mobile,
  IFNULL(totals.pageviews, 0) AS pageviews,
  IFNULL(geoNetwork.country, "") AS country
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'))
GROUP BY country
ORDER BY total_predicted_purchases DESC
LIMIT 10;
```

### Predict purchases per user

Here is another example. This time you will try to predict the number of transactions each visitor makes, sort the results, and select the top 10 visitors by transactions:

Replace the previous query with the following and then click Run:

```SQL
#standardSQL
SELECT
  fullVisitorId,
  SUM(predicted_label) as total_predicted_purchases
FROM
  ml.PREDICT(MODEL `bqml_lab.sample_model`, (
SELECT
  IFNULL(device.operatingSystem, "") AS os,
  device.isMobile AS is_mobile,
  IFNULL(totals.pageviews, 0) AS pageviews,
  IFNULL(geoNetwork.country, "") AS country,
  fullVisitorId
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'))
GROUP BY fullVisitorId
ORDER BY total_predicted_purchases DESC
LIMIT 10;
```

Next steps / learn more
- For more information on BigQuery ML, see the [documentation](https://cloud.google.com/bigquery-ml/docs/introduction).
- [Getting Started with BigQuery ML for Data Scientists](https://cloud.google.com/bigquery-ml/docs/create-machine-learning-model)
- Already have a Google Analytics account and want to query your own datasets in BigQuery? Follow this [export guide](https://support.google.com/analytics/answer/3416092#zippy=%2Cin-this-article).
- The complete BigQuery SQL reference guide is here as an additional resource: https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax