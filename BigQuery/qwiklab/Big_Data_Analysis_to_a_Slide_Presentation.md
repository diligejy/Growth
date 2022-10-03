## Task 1. Query BigQuery and log results to Sheet

1. Google AppsScript에서 BigQuery API 연결한 뒤 아래 코드 입력

> Google Apps Script Code
```javascript
/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// Filename for data results
var QUERY_NAME = "Most common words in all of Shakespeare's works";
// Replace this value with your Google Cloud API project ID
var PROJECT_ID = '<YOUR_PROJECT_ID>';
if (!PROJECT_ID) throw Error('Project ID is required in setup');
/**
 * Runs a BigQuery query; puts results into Sheet. You must enable
 * the BigQuery advanced service before you can run this code.
 * @see http://developers.google.com/apps-script/advanced/bigquery#run_query
 * @see http://github.com/gsuitedevs/apps-script-samples/blob/master/advanced/bigquery.gs
 *
 * @returns {Spreadsheet} Returns a spreadsheet with BigQuery results
 * @see http://developers.google.com/apps-script/reference/spreadsheet/spreadsheet
 */
function runQuery() {
  // Replace sample with your own BigQuery query.
  var request = {
    query:
        'SELECT ' +
            'LOWER(word) AS word, ' +
            'SUM(word_count) AS count ' +
        'FROM [bigquery-public-data:samples.shakespeare] ' +
        'GROUP BY word ' +
        'ORDER BY count ' +
        'DESC LIMIT 10'
  };
  var queryResults = BigQuery.Jobs.query(request, PROJECT_ID);
  var jobId = queryResults.jobReference.jobId;
  // Wait for BQ job completion (with exponential backoff).
  var sleepTimeMs = 500;
  while (!queryResults.jobComplete) {
    Utilities.sleep(sleepTimeMs);
    sleepTimeMs *= 2;
    queryResults = BigQuery.Jobs.getQueryResults(PROJECT_ID, jobId);
  }
  // Get all results from BigQuery.
  var rows = queryResults.rows;
  while (queryResults.pageToken) {
    queryResults = BigQuery.Jobs.getQueryResults(PROJECT_ID, jobId, {
      pageToken: queryResults.pageToken
    });
    rows = rows.concat(queryResults.rows);
  }
  // Return null if no data returned.
  if (!rows) {
    return Logger.log('No rows returned.');
  }
  // Create the new results spreadsheet.
  var spreadsheet = SpreadsheetApp.create(QUERY_NAME);
  var sheet = spreadsheet.getActiveSheet();
  // Add headers to Sheet.
  var headers = queryResults.schema.fields.map(function(field) {
    return field.name.toUpperCase();
  });
  sheet.appendRow(headers);
  // Append the results.
  var data = new Array(rows.length);
  for (var i = 0; i < rows.length; i++) {
    var cols = rows[i].f;
    data[i] = new Array(cols.length);
    for (var j = 0; j < cols.length; j++) {
      data[i][j] = cols[j].v;
    }
  }
  // Start storing data in row 2, col 1
  var START_ROW = 2;      // skip header row
  var START_COL = 1;
  sheet.getRange(START_ROW, START_COL, rows.length, headers.length).setValues(data);
  Logger.log('Results spreadsheet created: %s', spreadsheet.getUrl());
}
```

2. Replace <YOUR_PROJECT_ID> with your Project ID found in the left panel.


## Task 2. Create a chart in Google Sheets

1. Create the chart: Add the createColumnChart() function to bq-sheets-slides.gs right after runQuery(). {after the last line of code}:

> AppsScript Code

```javascript
/**
 * Uses spreadsheet data to create columnar chart.
 * @param {Spreadsheet} Spreadsheet containing results data
 * @returns {EmbeddedChart} visualizing the results
 * @see http://developers.google.com/apps-script/reference/spreadsheet/embedded-chart
 */
function createColumnChart(spreadsheet) {
  // Retrieve the populated (first and only) Sheet.
  var sheet = spreadsheet.getSheets()[0];
  // Data range in Sheet is from cell A2 to B11
  var START_CELL = 'A2';  // skip header row
  var END_CELL = 'B11';
  // Place chart on Sheet starting on cell E5.
  var START_ROW = 5;      // row 5
  var START_COL = 5;      // col E
  var OFFSET = 0;
  // Create & place chart on the Sheet using above params.
  var chart = sheet.newChart()
     .setChartType(Charts.ChartType.COLUMN)
     .addRange(sheet.getRange(START_CELL + ':' + END_CELL))
     .setPosition(START_ROW, START_COL, OFFSET, OFFSET)
     .build();
  sheet.insertChart(chart);
}
```

2. Return spreadsheet: In the above code, createColumnChart() needs the spreadsheet object, so tweak app to return spreadsheet object so it can pass it to createColumnChart(). After logging the successful creation of the Google Sheet, return the object at the end of runQuery().

3. Replace the last line (starts with Logger.log) with the following:

```javascript
Logger.log('Results spreadsheet created: %s', spreadsheet.getUrl());
  // Return the spreadsheet object for later use.
  return spreadsheet;
}
```

4. Drive createBigQueryPresentation() function: Logically segregating the BigQuery and chart-creation functionality is a great idea. Create a createBigQueryPresentation() function to drive the app, calling both and createColumnChart(). The code you add should look like this:

```javascript
/**
 * Runs a BigQuery query, adds data and a chart in a Sheet.
 */
function createBigQueryPresentation() {
  var spreadsheet = runQuery();
  createColumnChart(spreadsheet);
}
```

5. Put the createBigQueryPresentation() function right after this code block:

```javascript
// Filename for data results
var QUERY_NAME = "Most common words in all of Shakespeare's works";
// Replace this value with your Google Cloud API project ID
var PROJECT_ID = 'project-id-4323960745859879834';
if (!PROJECT_ID) throw Error('Project ID is required in setup');
```

6. Make code more reusable: You took 2 important steps above: returned the spreadsheet object and created a driving function. What if a colleague wanted to reuse runQuery() and doesn't want the URL logged?

To make runQuery() more digestible for general use, move that log line. The best place to move it? If you guessed createBigQueryPresentation(), you'd be correct!

After moving the log line, it should look like this:

```javascript
/**
 * Runs a BigQuery query, adds data and a chart in a Sheet.
 */
function createBigQueryPresentation() {
  var spreadsheet = runQuery();
  Logger.log('Results spreadsheet created: %s', spreadsheet.getUrl());
  createColumnChart(spreadsheet);
}
```

With the changes above, your bq-sheets-slides.js should now look like the following (except for PROJECT_ID):


```javascript
/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// Filename for data results
var QUERY_NAME = "Most common words in all of Shakespeare's works";
// Replace this value with your Google Cloud API project ID
var PROJECT_ID = 'qwiklabs-gcp-5c0cf6ad321746e4';
if (!PROJECT_ID) throw Error('Project ID is required in setup');
/**
 * Runs a BigQuery query, adds data and a chart in a Sheet.
 */
function createBigQueryPresentation() {
  var spreadsheet = runQuery();
  Logger.log('Results spreadsheet created: %s', spreadsheet.getUrl());
  createColumnChart(spreadsheet);
}
/**
 * Runs a BigQuery query; puts results into Sheet. You must enable
 * the BigQuery advanced service before you can run this code.
 * @see http://developers.google.com/apps-script/advanced/bigquery#run_query
 * @see http://github.com/gsuitedevs/apps-script-samples/blob/master/advanced/bigquery.gs
 *
 * @returns {Spreadsheet} Returns a spreadsheet with BigQuery results
 * @see http://developers.google.com/apps-script/reference/spreadsheet/spreadsheet
 */
function runQuery() {
  // Replace sample with your own BigQuery query.
  var request = {
    query:
        'SELECT ' +
            'LOWER(word) AS word, ' +
            'SUM(word_count) AS count ' +
        'FROM [bigquery-public-data:samples.shakespeare] ' +
        'GROUP BY word ' +
        'ORDER BY count ' +
        'DESC LIMIT 10'
  };
  var queryResults = BigQuery.Jobs.query(request, PROJECT_ID);
  var jobId = queryResults.jobReference.jobId;
  // Wait for BQ job completion (with exponential backoff).
  var sleepTimeMs = 500;
  while (!queryResults.jobComplete) {
    Utilities.sleep(sleepTimeMs);
    sleepTimeMs *= 2;
    queryResults = BigQuery.Jobs.getQueryResults(PROJECT_ID, jobId);
  }
  // Get all results from BigQuery.
  var rows = queryResults.rows;
  while (queryResults.pageToken) {
    queryResults = BigQuery.Jobs.getQueryResults(PROJECT_ID, jobId, {
      pageToken: queryResults.pageToken
    });
    rows = rows.concat(queryResults.rows);
  }
  // Return null if no data returned.
  if (!rows) {
    return Logger.log('No rows returned.');
  }
  // Create the new results spreadsheet.
  var spreadsheet = SpreadsheetApp.create(QUERY_NAME);
  var sheet = spreadsheet.getActiveSheet();
  // Add headers to Sheet.
  var headers = queryResults.schema.fields.map(function(field) {
    return field.name.toUpperCase();
  });
  sheet.appendRow(headers);
  // Append the results.
  var data = new Array(rows.length);
  for (var i = 0; i < rows.length; i++) {
    var cols = rows[i].f;
    data[i] = new Array(cols.length);
    for (var j = 0; j < cols.length; j++) {
      data[i][j] = cols[j].v;
    }
  }
  // Start storing data in row 2, col 1
  var START_ROW = 2;      // skip header row
  var START_COL = 1;
  sheet.getRange(START_ROW, START_COL, rows.length, headers.length).setValues(data);
  Logger.log('Results spreadsheet created: %s', spreadsheet.getUrl());
  // Return the spreadsheet object for later use.
  return spreadsheet;
}
/**
 * Uses spreadsheet data to create columnar chart.
 * @param {Spreadsheet} Spreadsheet containing results data
 * @returns {EmbeddedChart} visualizing the results
 * @see http://developers.google.com/apps-script/reference/spreadsheet/embedded-chart
 */
function createColumnChart(spreadsheet) {
  // Retrieve the populated (first and only) Sheet.
  var sheet = spreadsheet.getSheets()[0];
  // Data range in Sheet is from cell A2 to B11
  var START_CELL = 'A2';  // skip header row
  var END_CELL = 'B11';
  // Place chart on Sheet starting on cell E5.
  var START_ROW = 5;      // row 5
  var START_COL = 5;      // col E
  var OFFSET = 0;
  // Create & place chart on the Sheet using above params.
  var chart = sheet.newChart()
     .setChartType(Charts.ChartType.COLUMN)
     .addRange(sheet.getRange(START_CELL + ':' + END_CELL))
     .setPosition(START_ROW, START_COL, OFFSET, OFFSET)
     .build();
  sheet.insertChart(chart);
}
```

## Task 3. Put the results data into a slide deck

1. Create slide deck: Start with the creation of a new slide deck, then add a title and subtitle to the default title slide you get with all new presentations. All of the work on the slide deck takes place in the createSlidePresentation() function, which you add to bq-sheets-slides.gs right after the createColumnChart()function code:

```javascript
/**
 * Create presentation with spreadsheet data & chart
 * @param {Spreadsheet} Spreadsheet with results data
 * @param {EmbeddedChart} Sheets chart to embed on slide
 * @returns {Presentation} Slide deck with results
 */
function createSlidePresentation(spreadsheet, chart) {
  // Create the new presentation.
  var deck = SlidesApp.create(QUERY_NAME);
  // Populate the title slide.
  var [title, subtitle] = deck.getSlides()[0].getPageElements();
  title.asShape().getText().setText(QUERY_NAME);
  subtitle.asShape().getText().setText('via GCP and G Suite APIs:\n' +
    'Google Apps Script, BigQuery, Sheets, Slides');
```

2. Add data table: The next step in createSlidePresentation() is to import the cell data from the Google Sheet into our new slide deck. Add this code snippet to the createSlidePresentation()function:

```javascript
  // Data range to copy is from cell A1 to B11
  var START_CELL = 'A1';  // include header row
  var END_CELL = 'B11';
  // Add the table slide and insert an empty table on it of
  // the dimensions of the data range; fails if Sheet empty.
  var tableSlide = deck.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  var sheetValues = spreadsheet.getSheets()[0].getRange(
      START_CELL + ':' + END_CELL).getValues();
  var table = tableSlide.insertTable(sheetValues.length, sheetValues[0].length);
  // Populate the table with spreadsheet data.
  for (var i = 0; i < sheetValues.length; i++) {
    for (var j = 0; j < sheetValues[0].length; j++) {
      table.getCell(i, j).getText().setText(String(sheetValues[i][j]));
    }
  }
```

3. Import chart: The final step in createSlidePresentation() is to create one more slide, import the chart from our spreadsheet, and return the Presentation object. Add this final snippet to the function:


```javascript
  // Add a chart slide and insert the chart on it.
  var chartSlide = deck.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  chartSlide.insertSheetsChart(chart);
  // Return the presentation object for later use.
  return deck;
}
```

4. Return chart: Now that our final function is complete, take another look at its signature. Yes, createSlidePresentation() requires both a spreadsheet and a chart object. You've already adjusted runQuery() to return the Spreadsheet object but now you need to make a similar change to createColumnChart() to return the chart (EmbeddedChart) object. Do that by going back in your application and add one last line at the end of createColumnChart():

```javascript
 // Return chart object for later use
  return chart;
}
```

5. Update createBigQueryPresentation(): Since createColumnChart() returns the chart, you need to save that chart to a variable then pass both the spreadsheet and the chart to createSlidePresentation(). Since you log the URL of the newly-created spreadsheet, you can also log the URL of the new slide presentation. Replace this code block:


```javascript
/**
 * Runs a BigQuery query, adds data and a chart in a Sheet.
 */
function createBigQueryPresentation() {
  var spreadsheet = runQuery();
  Logger.log('Results spreadsheet created: %s', spreadsheet.getUrl());
  createColumnChart(spreadsheet);
}
```

With this:

```javascript
/**
 * Runs a BigQuery query, adds data and a chart in a Sheet,
 * and adds the data and chart to a new slide presentation.
 */
function createBigQueryPresentation() {
  var spreadsheet = runQuery();
  Logger.log('Results spreadsheet created: %s', spreadsheet.getUrl());
  var chart = createColumnChart(spreadsheet);
  var deck = createSlidePresentation(spreadsheet, chart);
  Logger.log('Results slide deck created: %s', deck.getUrl());
}
```


After all updates, your bq-sheets-slides.gs should now look like this, except for the PROJECT_ID:

bq-sheets-slides.gs - final version

```javascript
// Filename for data results
var QUERY_NAME = "Most common words in all of Shakespeare's works";
// Replace this value with your Google Cloud API project ID
var PROJECT_ID = '';
if (!PROJECT_ID) throw Error('Project ID is required in setup');
/**
 * Runs a BigQuery query; puts results into Sheet. You must enable
 * the BigQuery advanced service before you can run this code.
 * @see http://developers.google.com/apps-script/advanced/bigquery#run_query
 * @see http://github.com/gsuitedevs/apps-script-samples/blob/master/advanced/bigquery.gs
 *
 * @returns {Spreadsheet} Returns a spreadsheet with BigQuery results
 * @see http://developers.google.com/apps-script/reference/spreadsheet/spreadsheet
 */
function runQuery() {
  // Replace sample with your own BigQuery query.
  var request = {
    query:
        'SELECT ' +
            'LOWER(word) AS word, ' +
            'SUM(word_count) AS count ' +
        'FROM [bigquery-public-data:samples.shakespeare] ' +
        'GROUP BY word ' +
        'ORDER BY count ' +
        'DESC LIMIT 10'
  };
  var queryResults = BigQuery.Jobs.query(request, PROJECT_ID);
  var jobId = queryResults.jobReference.jobId;
  // Wait for BQ job completion (with exponential backoff).
  var sleepTimeMs = 500;
  while (!queryResults.jobComplete) {
    Utilities.sleep(sleepTimeMs);
    sleepTimeMs *= 2;
    queryResults = BigQuery.Jobs.getQueryResults(PROJECT_ID, jobId);
  }
  // Get all results from BigQuery.
  var rows = queryResults.rows;
  while (queryResults.pageToken) {
    queryResults = BigQuery.Jobs.getQueryResults(PROJECT_ID, jobId, {
      pageToken: queryResults.pageToken
    });
    rows = rows.concat(queryResults.rows);
  }
  // Return null if no data returned.
  if (!rows) {
    return Logger.log('No rows returned.');
  }
  // Create the new results spreadsheet.
  var spreadsheet = SpreadsheetApp.create(QUERY_NAME);
  var sheet = spreadsheet.getActiveSheet();
  // Add headers to Sheet.
  var headers = queryResults.schema.fields.map(function(field) {
    return field.name.toUpperCase();
  });
  sheet.appendRow(headers);
  // Append the results.
  var data = new Array(rows.length);
  for (var i = 0; i < rows.length; i++) {
    var cols = rows[i].f;
    data[i] = new Array(cols.length);
    for (var j = 0; j < cols.length; j++) {
      data[i][j] = cols[j].v;
    }
  }
  // Start storing data in row 2, col 1
  var START_ROW = 2;      // skip header row
  var START_COL = 1;
  sheet.getRange(START_ROW, START_COL, rows.length, headers.length).setValues(data);
  // Return the spreadsheet object for later use.
  return spreadsheet;
}
/**
 * Uses spreadsheet data to create columnar chart.
 * @param {Spreadsheet} Spreadsheet containing results data
 * @returns {EmbeddedChart} visualizing the results
 * @see http://developers.google.com/apps-script/reference/spreadsheet/embedded-chart
 */
function createColumnChart(spreadsheet) {
  // Retrieve the populated (first and only) Sheet.
  var sheet = spreadsheet.getSheets()[0];
  // Data range in Sheet is from cell A2 to B11
  var START_CELL = 'A2';  // skip header row
  var END_CELL = 'B11';
  // Place chart on Sheet starting on cell E5.
  var START_ROW = 5;      // row 5
  var START_COL = 5;      // col E
  var OFFSET = 0;
  // Create & place chart on the Sheet using above params.
  var chart = sheet.newChart()
     .setChartType(Charts.ChartType.COLUMN)
     .addRange(sheet.getRange(START_CELL + ':' + END_CELL))
     .setPosition(START_ROW, START_COL, OFFSET, OFFSET)
     .build();
  sheet.insertChart(chart);
  // Return the chart object for later use.
  return chart;
}
/**
 * Create presentation with spreadsheet data & chart
 * @param {Spreadsheet} Spreadsheet with results data
 * @param {EmbeddedChart} Sheets chart to embed on slide
 * @returns {Presentation} Returns a slide deck with results
 * @see http://developers.google.com/apps-script/reference/slides/presentation
 */
function createSlidePresentation(spreadsheet, chart) {
  // Create the new presentation.
  var deck = SlidesApp.create(QUERY_NAME);
  // Populate the title slide.
  var [title, subtitle] = deck.getSlides()[0].getPageElements();
  title.asShape().getText().setText(QUERY_NAME);
  subtitle.asShape().getText().setText('via GCP and G Suite APIs:\n' +
    'Google Apps Script, BigQuery, Sheets, Slides');
  // Data range to copy is from cell A1 to B11
  var START_CELL = 'A1';  // include header row
  var END_CELL = 'B11';
  // Add the table slide and insert an empty table on it of
  // the dimensions of the data range; fails if Sheet empty.
  var tableSlide = deck.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  var sheetValues = spreadsheet.getSheets()[0].getRange(
      START_CELL + ':' + END_CELL).getValues();
  var table = tableSlide.insertTable(sheetValues.length, sheetValues[0].length);
  // Populate the table with spreadsheet data.
  for (var i = 0; i < sheetValues.length; i++) {
    for (var j = 0; j < sheetValues[0].length; j++) {
      table.getCell(i, j).getText().setText(String(sheetValues[i][j]));
    }
  }
  // Add a chart slide and insert the chart on it.
  var chartSlide = deck.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  chartSlide.insertSheetsChart(chart);
  // Return the presentation object for later use.
  return deck;
}
/**
 * Runs a BigQuery query, adds data and a chart in a Sheet,
 * and adds the data and chart to a new slide presentation.
 */
function createBigQueryPresentation() {
  var spreadsheet = runQuery();
  Logger.log('Results spreadsheet created: %s', spreadsheet.getUrl());
  var chart = createColumnChart(spreadsheet);
  var deck = createSlidePresentation(spreadsheet, chart);
  Logger.log('Results slide deck created: %s', deck.getUrl());
}
```

