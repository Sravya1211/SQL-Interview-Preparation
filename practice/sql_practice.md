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

---

## Q4 — Count Unique New Artists Recommended in April 2024

**Problem:**  
How many **unique new artists** were recommended to users in **April 2024**?  
This helps measure diversity of recommendations during that month.

**Table:** `fct_artist_recommendations(recommendation_id, user_id, artist_id, recommendation_date, is_new_artist)`

```sql
SELECT
  COUNT(DISTINCT artist_id) AS unique_artists
FROM fct_artist_recommendations
WHERE recommendation_date >= '2024-04-01'
  AND recommendation_date <  '2024-05-01'
  AND is_new_artist = 1;
```

Why this date filter?

>= '2024-04-01' AND < '2024-05-01' is timestamp-safe (works even if time exists).
It filters exactly April 2024.

Concepts Used:
COUNT(DISTINCT)
Date range filtering
Boolean filtering


---

## Q5 — Most Active User Per Day (Including Ties)

**Problem:**  
The North Pole Network wants to find the most active user(s) each day based on message count.  
If multiple users tie for first place, return all of them.

**Tables:**
- `npn_users(user_id, user_name)`
- `npn_messages(message_id, sender_id, sent_at)`

```sql
WITH daily_counts AS (
  SELECT
    DATE(m.sent_at) AS message_date,
    u.user_name,
    COUNT(*) AS message_count,
    RANK() OVER (
      PARTITION BY DATE(m.sent_at)
      ORDER BY COUNT(*) DESC
    ) AS activity_rank
  FROM npn_users u
  JOIN npn_messages m
    ON u.user_id = m.sender_id
  GROUP BY DATE(m.sent_at), u.user_id, u.user_name
)

SELECT
  message_date,
  user_name,
  message_count
FROM daily_counts
WHERE activity_rank = 1
ORDER BY message_date, user_name;
```
Why RANK()?
RANK() assigns the same rank to tied values.
If two users have the same highest message count, both get rank 1.

Concepts Used:
CTE (WITH)
RANK()
Window functions
PARTITION BY
Handling ties

---

## Q6 — Add 14 Days to a Date Column

**Problem:**  
The Productivity Club wants to calculate each member’s `focus_end_date`, exactly 14 days after their `start_date`.

**Table:** `focus_challenges(member_id, member_name, start_date)`

```sql
SELECT
  member_id,
  member_name,
  start_date,
  DATE(start_date, '+14 days') AS focus_end_date
FROM focus_challenges;
```
How It Works:
DATE(start_date, '+14 days') adds 14 days to the existing date.
SQLite allows date arithmetic directly inside the DATE() function.

Concepts Used:
DATE()
Date arithmetic
Calculated columns

---

## Q7 — Day-over-Day Score Change Using LAG()

**Problem:**  
The Grinch is tracking his daily mischief scores. Find how many points his score increased or decreased each day compared to the previous day.

**Table:** `grinch_mischief_log(log_date, mischief_score)`

```sql
SELECT
  log_date,
  mischief_score,
  mischief_score - LAG(mischief_score) OVER (ORDER BY log_date) AS score_change
FROM grinch_mischief_log
ORDER BY log_date;
```

How It Works:
LAG(mischief_score) returns the previous day's score.
Subtracting it from the current score gives the daily change.

Concepts Used:
LAG()
Window functions
Time-series comparison
ORDER BY within OVER()
