## 1. Hasing columns with FARM_FINGERPRINT()

```SQL
SELECT
    FARM_FINGERPRINT("secure") AS one_way_encryption
```

## 2. Using Authorized views to limit row access

Create logical views into your dataset that filter based on user roles

```SQL
SELECT [COLUMN_1, COLUMN_2]
FROM `[DATASET.VIEW]`
WHERE allowed_viewer = SESSION_USER()
```

## 3. Flexible options for sharing a dataset

- Control Access to who can own, edit, and view your dataset

- Add authorized views

## 4. Avoid Access Pitfalls

- Dataset users should have the minimum permissions needed for their role

- Use separate projects or datasets for different environments (e.g DEV, QA, PRD)

- Audit roles periodically