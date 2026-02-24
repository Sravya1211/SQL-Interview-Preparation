## Q1 — Standardize Text + Case-Insensitive Search

**Problem:**  
At the winter market, Cindy Lou wants to find all items with **"sweater"** in their name.  
But the `color` column has inconsistent capitalization. Return only sweater names and cleaned colors.

**Table:** `winter_clothing(item_id, item_name, color)`

```sql
SELECT
  item_name,
  UPPER(SUBSTR(color, 1, 1)) || LOWER(SUBSTR(color, 2)) AS color
FROM winter_clothing
WHERE LOWER(item_name) LIKE '%sweater%';
```

Concepts Used:
LOWER() for case-insensitive search
SUBSTR() to split first letter vs remaining text
UPPER() + LOWER() to standardize capitalization


---

## Q2 — Date Filtering: strftime() vs BETWEEN

**Problem:**  
Compare two approaches to filter data by month or date range.

---

### Method 1: Using strftime()

```sql
SELECT *
FROM orders
WHERE strftime('%Y-%m', order_date) = '2024-10';
```
When to Use:
Filtering by year or month
Ignoring time component
Extracting specific parts of a date

### Method 2: Using BETWEEN(Range Filtering)

```sql
SELECT *
FROM orders
WHERE order_date >= '2024-10-01'
  AND order_date <  '2024-11-01';
```
When to Use:
Filtering continuous date ranges
Timestamp-safe comparisons
Performance-friendly filtering


---

## Q3 — Filtering Aggregated Results Using HAVING

**Problem:**  
Your team wants to know which labels have more than 5 emails assigned to them.

**Table:** `emails(email_id, label_id)`

```sql
SELECT
  label_id,
  COUNT(email_id) AS email_count
FROM emails
GROUP BY label_id
HAVING COUNT(email_id) > 5;
```

Explanation:
GROUP BY label_id groups emails per label.
COUNT(email_id) calculates total emails per label.
HAVING filters results after aggregation.

Important Distinction:
WHERE → filters rows before aggregation.
HAVING → filters groups after aggregation.

Concepts Used:
GROUP BY
COUNT()
HAVING
Aggregation filtering

