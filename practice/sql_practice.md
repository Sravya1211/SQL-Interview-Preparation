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
