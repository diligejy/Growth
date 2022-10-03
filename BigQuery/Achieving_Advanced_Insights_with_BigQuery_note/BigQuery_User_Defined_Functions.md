## 1. Components of a User-Defined Function (UDF)

- CREATE FUNCTION 
    - Creates a new function. A function can contain zero or more named_parameters

- RETURNS [data_type]
    - Specifies the data type that the function returns.

- Language [language].
    - Specifies the language for the function.

- AS [external_code].
    - Specifies the code that the function runs.

```SQL
CREATE FUNCTION d2i_demo.nlp_compromise_people(str String)
RETURNS ARRAY<STRING> LANGUAGE js AS '''
    return nlp(str).people().out('topk').map(x=>x.normal)
'''
OPTIONS (
library="gs://cloud-training/datatoinsights/assets/compromise.min.11.14.0.js"
);

SELECT 
    name
    , COUNT(*) c 
FROM (
    SELECT d2i_demo.nlp_compromise_people(title) names
    FROM `d2i_demo.reddit_posts`
    WHERE subreddit = 'movies'
), UNNEST(names) name
WHERE name LIKE '% %' 
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 10
```

## 2. Pitfall : User-Defined Functions hurt performance

- Use native SQL functions whenever possible
- Concurrent rate limits:
    - for non-UDF queries: 50
    - for UDF-queries: 6