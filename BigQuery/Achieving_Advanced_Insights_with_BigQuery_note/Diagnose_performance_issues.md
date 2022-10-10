## 1. Diagnose performance issues with the Query Explanation map

## 2. Table sharding - Then and now

- Traditional partitioning

    Traditional databases get performance boost by partitioning very large tables.

    Ususally requires an administrator to pre-allocate space, define partitions, and maintain them.

- Sharding tables manually (Better)

    Manual Table sharding divides big table into smaller tables with net suffix of YYYYMMDD

    Queries use Table Wildcard functions.

- Date-partitioned tables (Best)

    Date Partition a single table based on specified DAY or a Date Column.