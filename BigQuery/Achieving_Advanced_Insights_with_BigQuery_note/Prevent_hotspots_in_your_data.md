## 1. Shuffle wisely : Be aware of data skew in your dataset

- Filter your dataset as early as possible (this avoids overloading workers on JOINs)

- Hint: Use the Query Explanation map and compare the Max versus the Avg times to highlight skew.

- BigQuery will automatically attempt to reshuffle workers that are overloaded with data

