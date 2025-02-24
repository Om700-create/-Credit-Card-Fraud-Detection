use traning;
select * from creditcard_sample;
SELECT COUNT(*) FROM creditcard_sample;

SELECT Class, COUNT(*) AS count, 
       (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM creditcard_sample)) AS percentage
FROM creditcard_sample
GROUP BY Class;

CREATE TABLE fraud_analysis_summary (
    id INT AUTO_INCREMENT PRIMARY KEY,
    metric VARCHAR(255),
    value TEXT
);

INSERT INTO fraud_analysis_summary (metric, value) VALUES
('Highly Imbalanced Data', 'Fraud cases are extremely rare, making it challenging for machine learning models to detect them.'),
('Risk of False Negatives', 'Any fraud detection model must be carefully tuned to avoid missing fraudulent transactions.'),
('Need for Special Handling', 'Techniques like SMOTE (oversampling), anomaly detection, or cost-sensitive learning might be useful for better fraud detection.');

SELECT * FROM fraud_analysis_summary;

SELECT FLOOR(Time / 3600) AS hour_bin, COUNT(*) AS fraud_count
FROM creditcard_sample
WHERE Class = 1
GROUP BY hour_bin
ORDER BY hour_bin;

INSERT INTO fraud_analysis_summary (metric, value) VALUES
('Fraud Trend Over Time', 'Fraudulent transactions occur at various times, with some peaks around hours 3, 28, and 38.'),
('Risky Time Periods', 'Certain hours show more fraud cases, suggesting that fraudsters might be targeting specific times.'),
('Potential Monitoring Strategy', 'Real-time alerts can be set up during peak fraud hours to prevent fraudulent transactions.');

SELECT * FROM fraud_analysis_summary;

SELECT Class, 
       COUNT(*) AS count, 
       AVG(Amount) AS avg_amount, 
       MAX(Amount) AS max_amount, 
       MIN(Amount) AS min_amount
FROM creditcard_sample
GROUP BY Class;


INSERT INTO fraud_analysis_summary (metric, value) VALUES
('Fraud vs. Non-Fraud Amounts', 'Fraudulent transactions have a lower maximum amount (592.90) compared to legitimate transactions (3,848.01).'),
('Average Transaction Amount', 'On average, fraudulent transactions are slightly higher (103.98) than legitimate ones (87.97), but the difference is not significant.'),
('Fraudster Strategy', 'Fraudsters may be making mid-range transactions to avoid detection rather than very high-value ones.');

SELECT Class, 
       AVG(V1) AS avg_V1, MAX(V1) AS max_V1, MIN(V1) AS min_V1, 
       AVG(V2) AS avg_V2, MAX(V2) AS max_V2, MIN(V2) AS min_V2, 
       AVG(V3) AS avg_V3, MAX(V3) AS max_V3, MIN(V3) AS min_V3 
FROM creditcard_sample
GROUP BY Class;

INSERT INTO fraud_analysis_summary (metric, value) VALUES
('PCA Feature Analysis (V1-V3)', 'Fraudulent transactions tend to have highly negative V1 (-6.02 on average), while non-fraud transactions have V1 close to 0.'),
('PCA Feature Analysis (V2)', 'Fraudulent transactions have a higher V2 average (4.87) compared to non-fraud (-0.0042), suggesting a possible clustering effect.'),
('PCA Feature Analysis (V3)', 'Fraudulent transactions show a strong negative shift in V3 (-9.17) compared to non-fraud (0.0099), indicating potential fraud detection signals.');


SELECT * FROM creditcard_sample
WHERE Class = 1 
AND (V1 < -10 OR V2 > 10 OR V3 < -10)
ORDER BY Amount DESC;

INSERT INTO fraud_analysis_summary (metric, value) VALUES
('Extreme PCA Values & Fraud', 'Fraudulent transactions often have highly negative V1 (< -25) and V3 (< -25), suggesting an anomaly pattern.'),
('High V2 in Fraud Cases', 'Some fraudulent transactions show extremely high V2 values (~19), indicating a possible clustering behavior.'),
('Fraud & Fixed Transaction Amounts', 'Many fraud cases have amounts close to $99.99, hinting at fraudulent transaction strategies.');


SELECT 
    ROUND(Amount, -1) AS Amount_Range, 
    COUNT(*) AS Fraud_Count
FROM creditcard_sample
WHERE Class = 1
GROUP BY Amount_Range
ORDER BY Amount_Range;

INSERT INTO fraud_analysis_summary (metric, value) VALUES
('Small Fraud Transactions', 'Majority (~61%) of fraudulent transactions are below $10, likely as test transactions.'),
('Large Fraud Transactions', 'Some fraud transactions occur at $100, $150, $430, $440, and $590, indicating possible high-value fraud.'),
('Fraud Amounts Near Round Figures', 'Fraudulent transactions often appear at round values like $100 or $150, suggesting strategic spending patterns.');

SELECT 
    DAY(Time) AS Day_of_Month, 
    COUNT(*) AS Fraud_Count
FROM creditcard_sample
WHERE Class = 1
GROUP BY Day_of_Month
ORDER BY Day_of_Month;

INSERT INTO fraud_analysis_summary (metric, value) VALUES
('Missing Day Values', '16 fraud transactions have NULL day values, suggesting incomplete timestamps.'),
('Day 8 & 11 Fraud Transactions', 'Only 1 fraud case occurred on Day 8 and Day 11, indicating no clear monthly pattern yet.');

SELECT 
    HOUR(Time) AS Hour_of_Day, 
    COUNT(*) AS Fraud_Count
FROM creditcard_sample
WHERE Class = 1
GROUP BY Hour_of_Day
ORDER BY Hour_of_Day;

INSERT INTO fraud_analysis_summary (metric, value) VALUES
('Missing Hour Values', '9 fraud transactions have NULL hour values, indicating missing or anonymized timestamps.'),
('Peak Fraud Hours', 'Fraud cases are most frequent at Hour 1 and Hour 9 (2 cases each).'),
('Scattered Fraud Hours', 'Fraud cases appear across various hours, but no clear concentration observed.');

SELECT 
    DAYOFWEEK(Time) AS Day_of_Week, 
    COUNT(*) AS Fraud_Count
FROM creditcard_sample
WHERE Class = 1
GROUP BY Day_of_Week
ORDER BY Day_of_Week;

INSERT INTO fraud_analysis_summary (metric, value) VALUES
('Missing Day Values', '17 fraud transactions have NULL day values, which may indicate anonymized or missing data.'),
('Fraud on Sunday', '1 fraud case occurred on Sunday (Day 7), but more data is needed to find a clear trend.');


SELECT 
    CASE 
        WHEN Amount < 10 THEN 'Low (0-10)'
        WHEN Amount BETWEEN 10 AND 100 THEN 'Medium (10-100)'
        WHEN Amount > 100 THEN 'High (>100)'
    END AS Amount_Range, 
    COUNT(*) AS Fraud_Count
FROM creditcard_sample
WHERE Class = 1
GROUP BY Amount_Range
ORDER BY Fraud_Count DESC;

INSERT INTO fraud_analysis_summary (metric, value) VALUES
('Majority Small Transactions', '61% of fraud cases involve amounts between $0-$10, suggesting micro-transaction fraud.'),
('High-Value Fraud Exists', '22% of fraud transactions exceed $100, indicating riskier fraudulent attempts.'),
('Low Medium-Value Fraud', 'Only 17% of fraud cases fall in the $10-$100 range, meaning fraudsters may avoid mid-sized transactions.');

SHOW COLUMNS FROM creditcard_sample;
SELECT 
    CASE 
        WHEN FLOOR(Time / 3600) BETWEEN 0 AND 6 THEN 'Late Night (12AM-6AM)'
        WHEN FLOOR(Time / 3600) BETWEEN 7 AND 12 THEN 'Morning (7AM-12PM)'
        WHEN FLOOR(Time / 3600) BETWEEN 13 AND 18 THEN 'Afternoon (1PM-6PM)'
        WHEN FLOOR(Time / 3600) BETWEEN 19 AND 23 THEN 'Evening (7PM-11PM)'
    END AS Time_Period, 
    COUNT(*) AS Fraud_Count
FROM creditcard_sample
WHERE Class = 1
GROUP BY Time_Period
ORDER BY Fraud_Count DESC;


SELECT 
    CASE 
        WHEN FLOOR(Time / 3600) BETWEEN 0 AND 6 THEN 'Late Night (12AM-6AM)'
        WHEN FLOOR(Time / 3600) BETWEEN 7 AND 12 THEN 'Morning (7AM-12PM)'
        WHEN FLOOR(Time / 3600) BETWEEN 13 AND 18 THEN 'Afternoon (1PM-6PM)'
        WHEN FLOOR(Time / 3600) BETWEEN 19 AND 23 THEN 'Evening (7PM-11PM)'
    END AS Time_Period, 
    COUNT(*) AS Fraud_Count,
    SUM(Amount) AS Total_Fraud_Amount,
    AVG(Amount) AS Avg_Fraud_Amount
FROM creditcard_sample
WHERE Class = 1
GROUP BY Time_Period
ORDER BY Fraud_Count DESC;



SELECT 
    CASE 
        WHEN Amount <= 50 THEN 'Low (<=50)'
        WHEN Amount BETWEEN 51 AND 500 THEN 'Medium (51-500)'
        ELSE 'High (>500)'
    END AS Fraud_Amount_Category,
    COUNT(*) AS Fraud_Count,
    SUM(Amount) AS Total_Fraud_Amount,
    AVG(Amount) AS Avg_Fraud_Amount
FROM creditcard_sample
WHERE Class = 1
GROUP BY Fraud_Amount_Category
ORDER BY Fraud_Count DESC;

SHOW COLUMNS FROM creditcard_sample;


SELECT 
    Amount, 
    COUNT(*) AS Fraud_Count,
    SUM(Amount) AS Total_Fraud_Amount,
    AVG(Amount) AS Avg_Fraud_Amount
FROM creditcard_sample
WHERE Class = 1
GROUP BY Amount
ORDER BY Fraud_Count DESC, Total_Fraud_Amount DESC;


SELECT 
    CASE  
        WHEN Time BETWEEN 0 AND 21600 THEN 'Late Night (12AM-6AM)'
        WHEN Time BETWEEN 21601 AND 43200 THEN 'Morning (6AM-12PM)'
        WHEN Time BETWEEN 43201 AND 64800 THEN 'Afternoon (12PM-6PM)'
        WHEN Time BETWEEN 64801 AND 86400 THEN 'Evening (6PM-12AM)'
    END AS Time_Period,
    COUNT(*) AS Fraud_Count,
    SUM(Amount) AS Total_Fraud_Amount,
    AVG(Amount) AS Avg_Fraud_Amount
FROM creditcard_sample
WHERE Class = 1
GROUP BY Time_Period
ORDER BY Fraud_Count DESC;


INSERT INTO fraud_analysis_summary (metric, value) VALUES
('Frequent Low-Value Transactions', 'Most frequent fraud transaction amount is $5, occurring in 5 cases, suggesting repeated small-scale fraud.'),
('Suspicious Threshold Transactions', 'Two fraud cases involve transactions of $99.99, indicating possible attempts to stay below a common fraud detection threshold.'),
('High-Value Fraud Cases', 'Multiple fraud transactions exceed $400, with the highest at $592.9, indicating large-scale fraudulent activity.'),
('Testing Transactions Detected', 'Several fraud cases involve very low amounts ($4.49, $2.28, $0.76), suggesting fraudsters might be testing card validity.'),
('Late Night Fraud Pattern', 'Most fraud transactions (3 cases) occur between 12AM-6AM, but involve small amounts, possibly to avoid detection.'),
('Afternoon & Evening High-Value Fraud', 'Fraud in the afternoon (12PM-6PM) and evening (6PM-12AM) involves large transactions, averaging $272.08 and $213.7, respectively.'),
('Rare Morning Fraud', 'Only 1 fraud case detected in the morning (6AM-12PM), indicating fraudsters prefer other time periods.');


CREATE TABLE fraud_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_amount DOUBLE,
    fraud_flag INT,  -- 1 = Fraud, 0 = Normal
    transaction_time TIMESTAMP
);

INSERT INTO fraud_transactions (transaction_amount, fraud_flag, transaction_time) VALUES
(5, 1, '2025-02-24 02:15:00'),
(99.99, 1, '2025-02-24 10:30:00'),
(592.9, 1, '2025-02-24 16:45:00'),
(444.17, 1, '2025-02-24 18:10:00'),
(426.4, 1, '2025-02-24 21:20:00'),
(147.87, 1, '2025-02-24 14:50:00'),
(44.9, 1, '2025-02-24 03:40:00'),
(4.49, 1, '2025-02-24 05:00:00'),
(2.28, 1, '2025-02-24 23:10:00'),
(2.22, 1, '2025-02-24 00:25:00'),
(0.76, 1, '2025-02-24 01:55:00'),
(0.69, 1, '2025-02-24 04:35:00'),
(0, 1, '2025-02-24 07:20:00');

CREATE TABLE fraud_time_analysis (
    time_period VARCHAR(50),
    fraud_count INT,
    total_fraud_amount DOUBLE,
    avg_fraud_amount DOUBLE
);

INSERT INTO fraud_time_analysis (time_period, fraud_count, total_fraud_amount, avg_fraud_amount) VALUES
('Late Night (12AM-6AM)', 3, 3, 1),
('Afternoon (12PM-6PM)', 2, 544.16, 272.08),
('Evening (6PM-12AM)', 2, 427.4, 213.7),
('Morning (6AM-12PM)', 1, 99.99, 99.99);



CREATE TABLE fraud_amount_category (
    category VARCHAR(50),
    fraud_count INT,
    total_fraud_amount DOUBLE,
    avg_fraud_amount DOUBLE
);

INSERT INTO fraud_amount_category (category, fraud_count, total_fraud_amount, avg_fraud_amount) VALUES
('Low (<=50)', 12, 60.34, 5.03),
('Medium (51-500)', 5, 1218.42, 243.68),
('High (>500)', 1, 592.9, 592.9);


CREATE TABLE fraud_transaction_frequency (
    transaction_amount DOUBLE,
    fraud_count INT,
    total_fraud_amount DOUBLE,
    avg_fraud_amount DOUBLE
);

INSERT INTO fraud_transaction_frequency (transaction_amount, fraud_count, total_fraud_amount, avg_fraud_amount) VALUES
(5, 5, 25, 5),
(99.99, 2, 199.98, 99.99),
(592.9, 1, 592.9, 592.9),
(444.17, 1, 444.17, 444.17),
(426.4, 1, 426.4, 426.4),
(147.87, 1, 147.87, 147.87),
(44.9, 1, 44.9, 44.9),
(4.49, 1, 4.49, 4.49),
(2.28, 1, 2.28, 2.28),
(2.22, 1, 2.22, 2.22),
(0.76, 1, 0.76, 0.76),
(0.69, 1, 0.69, 0.69),
(0, 1, 0, 0);


