## 1. BigQuery automatically breaks apart data into smaller shards

## 2. BigQuery automatically balances and scales workers

- Up to 2,000 workers to process concurrent queries (on-demand tier)
- "Fairness model" for allocation.

## 3. BigQuery workers communicate by shuffling data in-memory

1. Workers consume data values and perform operations in parallel

2. Workers produce output to the In-Memory Shuffle Service.

3. Workers consume new data and continue processing

Workers (one or more slots) scale to meet the demand of the processing task.

## 4. BigQuery shuffling enables massive scale

1. Shuffle allows BigQuery to process massively parallel petabyte-scale data jobs.

2. Everything after Query Execution is automatically scaled and managed.

3. All queries large and small use shuffle.