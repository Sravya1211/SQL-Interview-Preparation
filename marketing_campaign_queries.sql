/*-------------------------------------------------------------------------------
   MARKETING CAMPAIGN SQL ANALYSIS PROJECT
   TOOLS: PostgreSQL + DBeaver
   Description: Solutions to SQL questions using the marketing_campaign dataset
   -----------------------------------------------------------------------------*/

/* Q1: Total Customers records */   
-- Count the total number of rows in the dataset. Each row = one customer in the campaign
SELECT COUNT(*) AS total_customers FROM marketing_campaign;

/* Q2: How many customers accepted each of the five marketing campaigns?
-- Here, in the table, for the customers who accepted th campaign, it is marked as 1 and for the ones who didn't accept the campaign,
it is marked as 0.
-- So, we are supposed to count all the 1 and sum it up and give it the total value. */
SELECT
   SUM(CASE WHEN acceptedcmp1 = 1 THEN 1 ELSE 0 END) AS total_accepted_cmp1,
   SUM(CASE WHEN acceptedcmp2 = 1 THEN 1 ELSE 0 END) AS total_accepted_cmp2,
   SUM(CASE WHEN acceptedcmp3 = 1 THEN 1 ELSE 0 END) AS total_accepted_cmp3,
   SUM(CASE WHEN acceptedcmp4 = 1 THEN 1 ELSE 0 END) AS total_accepted_cmp4,
   SUM(CASE WHEN acceptedcmp5 = 1 THEN 1 ELSE 0 END) AS total_accepted_cmp5
FROM marketing_campaign;

/* Q3: What is the overall acceptance rate across all five marketing campaigns?

Logic:
- A customer is considered "accepted" if they accepted at least one of the campaigns (AcceptedCmp1–AcceptedCmp5).
- For each row, we create a flag: 1 if any campaign was accepted, else 0.
- Sum of this flag gives total accepted customers.
- Divide by total customers and multiply by 100 to get the overall acceptance rate (%).
*/

SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN acceptedcmp1 = 1
              OR acceptedcmp2 = 1
              OR acceptedcmp3 = 1
              OR acceptedcmp4 = 1
              OR acceptedcmp5 = 1
            THEN 1
            ELSE 0
        END
    ) AS customers_accepted_any,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN acceptedcmp1 = 1
                  OR acceptedcmp2 = 1
                  OR acceptedcmp3 = 1
                  OR acceptedcmp4 = 1
                  OR acceptedcmp5 = 1
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS overall_acceptance_rate_pct
FROM marketing_campaign;

/* Q4: Calculate the individual acceptance rates for each campaign 
Logic:
- Each AcceptedCmpX column is 1 if the customer accepted that specific campaign.
- We convert each campaign's 0/1 values into 1 (accepted) and 0 (not accepted).
- SUM() counts total acceptances for that campaign.
- Divide by total customers (COUNT(*)) to get acceptance rate.
- Multiply by 100 for percentage.
- ROUND() keeps results clean with 2 decimal points. */
select 
  round(100 * sum(case when acceptedcmp1 = 1 then 1 else 0 end) / count(*), 2) as cmp1_acceptance_rate,
  round(100 * sum(case when acceptedcmp2 = 1 then 1 else 0 end) / count(*), 2) as cmp2_acceptance_rate,
  round(100 * sum(case when acceptedcmp3 = 1 then 1 else 0 end) / count(*), 2) as cmp3_acceptance_rate,
  round(100 * sum(case when acceptedcmp4 = 1 then 1 else 0 end) / count(*), 2) as cmp4_acceptance_rate,
  round(100 * sum(case when acceptedcmp5 = 1 then 1 else 0 end) / count(*), 2) as cmp5_acceptance_rate
from marketing_campaign;
  
/* Q5: How many customers belong to each education level?
Here, first select the grouping column, and then select the count */
SELECT education, count(*) as total_count
from marketing_campaign
group by education;

/* Q6: What is the average income of customers who accepted the most recent campaign?
Here, we are supposed to calculate the average income of all the customers who accepted the recent campaign 
In the table, all the customers who accepted the most recent campaign are given a boolean value of 1 */
SELECT avg(income) as average_income
from marketing_campaign
where response =1;

/* Q7: Which purchase channel had the highest number of purchases?
-- Sum each channel's total purchase and then compare the total values of the three channels */
SELECT
    SUM(NumWebPurchases) AS total_web,
    SUM(NumCatalogPurchases) AS total_catalog,
    SUM(NumStorePurchases) AS total_store
FROM marketing_campaign;

/* Q8: How many customers visited the website more than five times in the last month? */
select COUNT(*) as total_customers
from marketing_campaign
where numwebvisitsmonth > 5;

/* Q9: How many customers made at least one purchase using a discount? */
select count(*) as total_customers
from marketing_campaign 
where numdealspurchases >= 1;

/* Q10: What is the average number of days since the last purchase across all customers? */
SELECT AVG(Recency) AS avg_number_of_days
FROM marketing_campaign;