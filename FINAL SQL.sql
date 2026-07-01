
------------------------------
--------DATA EXPLORATION----------------
USE MarketingDb;
GO
SELECT 
    COUNT(*) AS [Total_Rows],    
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_Nulls,
    SUM(CASE WHEN customer_age IS NULL THEN 1 ELSE 0 END) AS customer_age_Nulls,  
    SUM(CASE WHEN website_traffic IS NULL THEN 1 ELSE 0 END) AS website_traffic_Nulls,
    SUM(CASE WHEN conversion_rate IS NULL THEN 1 ELSE 0 END) AS conversion_rate_Nulls,
    SUM(CASE WHEN email_open_rate IS NULL THEN 1 ELSE 0 END) AS email_open_rate_Nulls, 
    SUM(CASE WHEN discount_percentage IS NULL THEN 1 ELSE 0 END) AS discount_perc_Nulls,
    SUM(CASE WHEN competitor_price_index IS NULL THEN 1 ELSE 0 END) AS competitor_price_Nulls,
    SUM(CASE WHEN customer_satisfaction_score IS NULL THEN 1 ELSE 0 END) AS satisfaction_Nulls
FROM marketing1;
-------------------- DATA CLEANING--------------
USE MarketingDb;
GO
UPDATE marketing1
SET email_open_rate = (SELECT AVG(email_open_rate) FROM marketing1 WHERE email_open_rate IS NOT NULL)
WHERE email_open_rate IS NULL;

 
UPDATE marketing1
SET discount_percentage = (SELECT AVG(discount_percentage) FROM marketing1 WHERE discount_percentage IS NOT NULL)
WHERE discount_percentage IS NULL;

 
UPDATE marketing1
SET customer_satisfaction_score = (SELECT AVG(customer_satisfaction_score) FROM marketing1 WHERE customer_satisfaction_score IS NOT NULL)
WHERE customer_satisfaction_score IS NULL;
-------------------QUERIES and ANALYSIS-------------------
USE MarketingDB;
GO
SELECT 
    customer_age,
    COUNT(*) AS Total_Customers,
    SUM(website_traffic) AS Total_Traffic,
    AVG(customer_satisfaction_score) AS Avg_Satisfaction
FROM marketing1
GROUP BY customer_age
ORDER BY customer_age;
GO

SELECT TOP 10 
    id, 
    customer_age, 
    conversion_rate,
    discount_percentage
FROM marketing1
ORDER BY  customer_age DESC;
GO
----------- JOIN -------------

CREATE TABLE Satisfaction_LevelsS (
    Score_ID INT,
    Satisfaction_Level VARCHAR(30)
);
GO
INSERT INTO Satisfaction_Levels (Score_ID, Satisfaction_Level) VALUES 
(1, 'Very Dissatisfied'),
(2, 'Dissatisfied'),
(3, 'Neutral'),
(4, 'Satisfied'),
(5, 'Very Satisfied');
GO

SELECT TOP 100
    m.id,
    m.customer_age,
    m.customer_satisfaction_score,
    s.Satisfaction_Level
FROM marketing1 m
INNER JOIN Satisfaction_Levels s 
    ON CAST(m.customer_satisfaction_score AS INT) = s.Score_ID;
GO

----------- VIEW-----------------

CREATE VIEW v_CleanedMarketingSummary AS
SELECT 
    id, 
    customer_age, 
    website_traffic, 
    customer_satisfaction_score
FROM marketing1;
GO