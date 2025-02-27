use traning;
select * from creditcard_sample;
SELECT * 
FROM creditcard 
LIMIT 5;
-- 1. The dataset appears to be related to credit card transactions, with multiple numerical features.
-- 2. The first column seems to represent time, possibly indicating the transaction timestamp or order.
-- 3. Columns V1 to V28 appear to be principal components (likely transformed via PCA), meaning the dataset has undergone dimensionality reduction.
-- 4. The second last column represents transaction amount, which could be crucial in detecting fraud.
-- 5. The last column, Class (0/1), seems to indicate whether a transaction is fraudulent (1) or legitimate (0).
-- 6. No missing values are immediately visible in this sample, but we need to verify this for the full dataset.


DESCRIBE creditcard;

-- 1. The dataset consists of 30 columns, with Time, 28 PCA-transformed features (V1 to V28), Amount, and Class.
-- 2. The Time column is an integer, likely representing the number of seconds since the first recorded transaction.
-- 3. Features V1 to V28 are double-precision floating-point numbers, likely the result of Principal Component Analysis (PCA) for dimensionality reduction.
-- 4. The Amount column represents the transaction amount, which could be crucial in detecting fraud.
-- 5. The Class column is an integer (0 or 1), indicating whether a transaction is legitimate (0) or fraudulent (1).

SELECT 
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions,
    SUM(CASE WHEN Class = 0 THEN 1 ELSE 0 END) AS legitimate_transactions,
    ROUND(100 * SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS fraud_percentage
FROM creditcard;

-- 1. The dataset contains 47,821 transactions, out of which only 147 (0.31%) are fraudulent, showing a highly imbalanced dataset.
-- 2. Legitimate transactions (47,674) dominate the dataset, making it essential to handle class imbalance in future analysis (e.g., using oversampling or weighted models).
-- 3. Fraud detection is challenging due to the extremely low fraud rate (0.31%), which may lead to biased models if not addressed properly.

SELECT 
    ROUND(AVG(Amount), 2) AS avg_amount,
    ROUND(MIN(Amount), 2) AS min_amount,
    ROUND(MAX(Amount), 2) AS max_amount,
    ROUND(STDDEV(Amount), 2) AS stddev_amount
FROM creditcard;


-- 1. The average transaction amount is $91.82, but there is high variability with a standard deviation of $249.69, indicating a wide range of transaction values.
-- 2. The minimum transaction amount is $0, suggesting possible null or zero-value transactions that may need further investigation.
-- 3. The maximum transaction amount is $12,910.93, which could be a potential indicator of fraudulent behavior, as frauds often involve large transactions.
-- 4. The high standard deviation suggests that transaction amounts are highly dispersed, meaning some transactions are significantly larger than others.

SELECT 
    Class,
    ROUND(AVG(Amount), 2) AS avg_amount,
    ROUND(MIN(Amount), 2) AS min_amount,
    ROUND(MAX(Amount), 2) AS max_amount,
    ROUND(STDDEV(Amount), 2) AS stddev_amount,
    COUNT(*) AS total_transactions
FROM creditcard
GROUP BY Class;

-- 1. Fraudulent transactions (Class = 1) have a slightly higher average amount ($100.68) compared to non-fraudulent ones ($91.79), but the difference is not very significant.
-- 2. The maximum fraudulent transaction is $1,809.68, much lower than the maximum non-fraudulent transaction ($12,910.93). This suggests that frauds tend to involve medium-sized transactions rather than extreme high-value ones.
-- 3. The standard deviation of fraudulent transactions ($233.26) is lower than that of non-fraudulent transactions ($249.74), indicating that fraudulent transactions are more consistent in amount.
-- 4. Fraudulent transactions make up a very small proportion of the dataset (147 out of 47,821 total transactions), which is expected in a typical credit card fraud detection dataset.

SELECT 
    Class,
    ROUND(AVG(Time), 2) AS avg_time,
    ROUND(MIN(Time), 2) AS min_time,
    ROUND(MAX(Time), 2) AS max_time,
    ROUND(STDDEV(Time), 2) AS stddev_time
FROM creditcard
GROUP BY Class;

-- 1. Fraudulent transactions occur at a slightly earlier average time (26,764.14) than non-fraudulent ones (28,248.82). However, the difference is not substantial.
-- 2. The minimum recorded time for fraudulent transactions is 406 seconds (~6.8 minutes), whereas non-fraudulent transactions start from 0 seconds. This suggests that fraud is not necessarily concentrated at the very beginning of the dataset.
-- 3. Both fraudulent and non-fraudulent transactions have similar maximum times (~43,375 seconds), indicating fraud is distributed across the full time range.
-- 4. The standard deviation of time is almost identical for both classes (~13,000 seconds), meaning fraud and non-fraud transactions are spread similarly across time.

SELECT 
    Class,
    ROUND(AVG(V1), 2) AS avg_V1,
    ROUND(AVG(V2), 2) AS avg_V2,
    ROUND(AVG(V3), 2) AS avg_V3,
    ROUND(AVG(V4), 2) AS avg_V4,
    ROUND(AVG(V5), 2) AS avg_V5,
    ROUND(AVG(V6), 2) AS avg_V6,
    ROUND(AVG(V7), 2) AS avg_V7
FROM creditcard
GROUP BY Class;

-- 1. Fraudulent transactions show significantly different average values for V1-V7 compared to non-fraudulent transactions. This suggests these features have strong predictive power in fraud detection.
-- 2. V1, V3, V5, V7 have strongly negative values for fraudulent transactions, whereas they are closer to zero for non-fraudulent ones. This indicates that fraud cases are more extreme in these dimensions.
-- 3. V2 and V4 have highly positive averages for fraudulent transactions (5.48 and 5.98), while they remain close to zero for non-fraud transactions. This suggests that positive values in these dimensions could be a fraud signal.
-- 4. V3 shows the largest contrast (-10.46 for fraud vs. 0.73 for non-fraud), making it a highly influential factor in fraud detection.

SELECT 
    Class,
    ROUND(AVG(V8), 2) AS avg_V8,
    ROUND(AVG(V9), 2) AS avg_V9,
    ROUND(AVG(V10), 2) AS avg_V10,
    ROUND(AVG(V11), 2) AS avg_V11,
    ROUND(AVG(V12), 2) AS avg_V12,
    ROUND(AVG(V13), 2) AS avg_V13,
    ROUND(AVG(V14), 2) AS avg_V14
FROM creditcard
GROUP BY Class;

-- 1. Fraudulent transactions show extreme values in V8-V14 compared to non-fraudulent ones, reinforcing their predictive power.
-- 2. V8, V11, and V12 have significantly higher averages for fraud cases (e.g., V8 = 3.76 vs. 0.04, V11 = 5.45 vs. 0.37, V12 = -8.72 vs. -0.34), suggesting strong fraud indicators.
-- 3. V10, V13, and V14 have highly negative values for fraud cases (-7.58, 0.37, and -8.95, respectively), while they remain close to zero for non-fraud transactions.
-- 4. V9 is notably negative for fraud transactions (-3.6) but positive for non-fraud (0.15), showing a clear directional difference.
-- 5. V14 shows one of the strongest contrasts (-8.95 for fraud vs. 0.21 for non-fraud), making it a key feature in fraud detection.

SELECT 
    Class,
    COUNT(*) AS transaction_count,
    ROUND(AVG(Amount), 2) AS avg_amount,
    ROUND(MIN(Amount), 2) AS min_amount,
    ROUND(MAX(Amount), 2) AS max_amount
FROM creditcard
GROUP BY Class;

-- 1. Fraudulent transactions have a slightly higher average amount ($100.68) compared to non-fraudulent ones ($91.79).
-- 2. The maximum transaction amount for fraud cases ($1,809.68) is much lower than for non-fraud cases ($12,910.93), suggesting fraud typically occurs on smaller transactions.
-- 3. Both fraud and non-fraud transactions have a minimum amount of $0, meaning there are some zero-value transactions in the dataset.
-- 4. Fraudulent transactions account for only 147 cases out of 47,821 total transactions (~0.31%), making this a highly imbalanced dataset.

SELECT 
    Class,
    ROUND(AVG(Time), 2) AS avg_time,
    ROUND(MIN(Time), 2) AS min_time,
    ROUND(MAX(Time), 2) AS max_time
FROM creditcard
GROUP BY Class;

-- 1. The average transaction time for fraud cases is 26,764.14 seconds (~7.43 hours) compared to 28,248.82 seconds (~7.85 hours) for non-fraud cases. This suggests that fraudulent transactions occur slightly earlier in the day on average.
-- 2. Fraud cases have a minimum recorded time of 406 seconds (~6.8 minutes), while non-fraud cases have a minimum time of 0 seconds. This confirms transactions are recorded from the start of the time window.
-- 3. The maximum transaction time is nearly the same for both fraud (43,369 sec) and non-fraud (43,375 sec), meaning fraudulent activity is spread throughout the dataset's time range.
-- 4. The time variable is recorded in seconds from an unspecified starting point, so further analysis is needed to determine whether fraud happens more frequently at certain hours of the day.

SELECT 
    Class, 
    ROUND(AVG(V1), 2) AS avg_V1,
    ROUND(AVG(V2), 2) AS avg_V2,
    ROUND(AVG(V3), 2) AS avg_V3,
    ROUND(AVG(V4), 2) AS avg_V4,
    ROUND(AVG(V5), 2) AS avg_V5,
    ROUND(AVG(V6), 2) AS avg_V6,
    ROUND(AVG(V7), 2) AS avg_V7
FROM creditcard
GROUP BY Class;


-- 1. Fraudulent transactions show significantly different patterns in V1 to V7 compared to non-fraud transactions. The values for fraud cases are much more extreme (e.g., V1 = -7.72 for fraud vs. -0.22 for non-fraud).
-- 2. V2, V3, V4, V5, V6, and V7 exhibit strong variations between fraud and non-fraud transactions. For instance, V4 is 5.98 for fraud but only 0.17 for non-fraud, indicating it could be a strong fraud predictor.
-- 3. Most of these features are transformed versions of original transaction data, likely using PCA (Principal Component Analysis). The extreme differences in values suggest that these components are effective in distinguishing fraudulent transactions.
-- 4. Negative values dominate for fraud cases in most features (V1, V3, V5, V7), while some features have high positive values (V2, V4). This suggests that fraud patterns are not random but have distinct trends.

SELECT 
    Class, 
    ROUND(AVG(Amount), 2) AS avg_amount, 
    ROUND(MAX(Amount), 2) AS max_amount, 
    ROUND(MIN(Amount), 2) AS min_amount, 
    ROUND(SUM(Amount), 2) AS total_amount
FROM creditcard
GROUP BY Class;

-- 1. The average transaction amount is similar for fraud ($100.68) and non-fraud ($91.79), meaning fraud detection cannot rely on just the mean value of transactions.
-- 2. The total monetary impact of fraud is extremely low ($14,800.36) compared to non-fraud transactions ($4,375,942.91). This suggests that fraudulent transactions are rare but still need to be detected efficiently.
-- 3. The maximum transaction amount for fraud is $1,809.68, while for non-fraud it is $12,910.93, meaning fraud cases generally involve smaller amounts.
-- 4. The minimum transaction amount for both fraud and non-fraud is 0, indicating possible cases of failed or test transactions.

SELECT 
    FLOOR(Time / 3600) AS hour, 
    Class, 
    COUNT(*) AS transaction_count 
FROM creditcard 
GROUP BY hour, Class 
ORDER BY hour, Class;


-- 1. Fraudulent transactions occur at all hours but peak at hour 11 (43 fraud cases). This may indicate a pattern in fraudulent activity.
-- 2. Fraud is significantly lower in early morning hours (0-6), but still occurs, suggesting fraud is not limited to business hours.
-- 3. The highest number of transactions (fraud + non-fraud) occurs between hours 9-11, aligning with general business activity.
-- 4. Hour 2 shows a notable spike in fraud (21 cases), which might indicate a potential vulnerability during this period.
-- 5. Despite high transaction volume during peak hours (8-11), fraud cases remain relatively low, which might suggest fraudsters prefer lower-traffic hours to avoid detection.

SELECT 
    CASE 
        WHEN Amount < 10 THEN 'Low (<$10)' 
        WHEN Amount BETWEEN 10 AND 100 THEN 'Medium ($10-$100)' 
        WHEN Amount BETWEEN 100 AND 1000 THEN 'High ($100-$1000)' 
        ELSE 'Very High (>$1000)' 
    END AS amount_category,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY amount_category, Class
ORDER BY amount_category, Class;


-- 1. Most fraudulent transactions (75 cases) occur in the ‘Low (<$10)’ category. This suggests fraudsters may test small amounts before attempting larger fraud.
-- 2. Fraud rate is lowest in the ‘Very High (>$1000)’ category (only 2 fraud cases out of 531 transactions). High-value transactions may have stricter security checks.
-- 3. Fraud is relatively uncommon in mid-range transactions ($10-$100 and $100-$1000). This could mean fraudsters either avoid these amounts or banks have stronger monitoring in these ranges.
-- 4. Despite ‘High ($100-$1000)’ transactions being frequent (9171 non-fraud cases), only 25 fraud cases occur in this range. This suggests mid-range fraud is relatively rare.
-- 5. Fraudulent transactions tend to cluster in smaller amounts, possibly to avoid detection.

SELECT 
    HOUR(Time) AS transaction_hour, 
    CASE 
        WHEN Amount < 10 THEN 'Low (<$10)' 
        WHEN Amount BETWEEN 10 AND 100 THEN 'Medium ($10-$100)' 
        WHEN Amount BETWEEN 100 AND 1000 THEN 'High ($100-$1000)' 
        ELSE 'Very High (>$1000)' 
    END AS amount_category, 
    Class, 
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY transaction_hour, amount_category, Class
ORDER BY transaction_hour, amount_category, Class;

-- 1. Fraudulent transactions (Class = 1) in the ‘Low (<$10)’ category peak between hours 0-4, with 1-7 fraud cases per hour. This suggests fraudsters may be more active during early morning hours.
-- 2. The highest fraud rate occurs at hour 4 in the ‘High ($100-$1000)’ category (10 fraud cases out of 1093 transactions). This might indicate a pattern where fraudsters attempt higher-value fraud at specific hours.
-- 3. The ‘Very High (>$1000)’ category has the fewest fraud cases (only 2), but one occurs at hour 4. This suggests that extremely large fraudulent transactions are rare but can happen at specific times.
-- 4. Fraudulent transactions in the ‘Medium ($10-$100)’ category are evenly distributed, with no significant peak hour. This indicates fraudsters may not favor any particular time for mid-range transactions.
-- 5. Hour 3 sees fraud across all amount categories, making it a potential high-risk period for fraud detection.
-- 6. The lowest fraud activity happens during hour 0 (midnight), with just 1 fraudulent transaction in the ‘Low (<$10)’ category.

SELECT 
    ROUND(AVG(V1),2) AS avg_V1, 
    ROUND(AVG(V2),2) AS avg_V2, 
    ROUND(AVG(V3),2) AS avg_V3, 
    ROUND(AVG(V4),2) AS avg_V4, 
    ROUND(AVG(V5),2) AS avg_V5, 
    ROUND(AVG(V6),2) AS avg_V6, 
    Class
FROM creditcard
GROUP BY Class;

-- 1. Fraudulent transactions (Class = 1) show significantly higher variation in feature values. For example, V2, V3, and V4 have extreme positive and negative values compared to non-fraudulent transactions.
-- 2. Feature V2 has a much higher average for fraud (-7.72) than non-fraud (0.00), suggesting it may be a strong indicator of fraudulent activity.
-- 3. Feature V3 has a strong negative value for fraud (-10.46) but is positive for non-fraud (0.73), reinforcing its potential role in fraud detection.
-- 4. V4 follows a similar trend, with a much higher mean (5.98) in fraudulent transactions compared to legitimate ones (0.17).
-- 5. Non-fraudulent transactions show feature values closer to zero, suggesting they have more stable patterns compared to fraud cases.
-- 6. V5 and V6 also exhibit extreme differences, further supporting the idea that fraud transactions tend to deviate sharply in feature values.

SELECT 
    ROUND(STDDEV(V1),2) AS std_V1, 
    ROUND(STDDEV(V2),2) AS std_V2, 
    ROUND(STDDEV(V3),2) AS std_V3, 
    ROUND(STDDEV(V4),2) AS std_V4, 
    ROUND(STDDEV(V5),2) AS std_V5, 
    ROUND(STDDEV(V6),2) AS std_V6, 
    Class
FROM creditcard
GROUP BY Class;

-- 1. Fraudulent transactions have much higher feature variations compared to non-fraudulent ones.
-- 2. For example, V1 has a standard deviation of 8.43 for fraud cases vs. only 1.78 for non-fraud cases, indicating that fraud-related values fluctuate significantly.
-- 3. V3 shows a similar pattern (8.62 vs. 1.3), reinforcing that fraud transactions tend to be more erratic.
-- 4. V5 (6.54 vs. 1.33) and V2 (4.3 vs. 1.58) also show large differences, suggesting that these features might be strong fraud indicators.
-- 5. Non-fraud transactions have lower, more consistent standard deviations (~1.3 to 1.78 across features), meaning they follow a more predictable pattern.
-- 6. The lower variation in non-fraud cases suggests that normal transactions have a stable range of values, whereas fraudulent transactions are much more spread out.

SELECT 
    Class, 
    ROUND(AVG(Amount), 2) AS avg_amount, 
    ROUND(STDDEV(Amount), 2) AS std_amount, 
    MIN(Amount) AS min_amount, 
    MAX(Amount) AS max_amount 
FROM creditcard 
GROUP BY Class;

-- 1. Fraudulent transactions have a slightly higher average amount ($100.68) compared to non-fraud transactions ($91.79).
-- 2. The standard deviation of transaction amounts is lower for fraud ($233.26) than for non-fraud ($249.74), suggesting that fraudulent transactions may be more controlled in their amount.
-- 3. Both fraud and non-fraud transactions have a minimum amount of $0, meaning small or test transactions are common in both categories.
-- 4. The maximum transaction amount for non-fraud cases ($12,910.93) is significantly higher than for fraud cases ($1,809.68), indicating that fraudsters may avoid extremely large transactions to evade detection.

SELECT 
    FLOOR(Time / 3600) AS hour_of_day, 
    Class, 
    COUNT(*) AS transaction_count 
FROM creditcard 
GROUP BY hour_of_day, Class 
ORDER BY hour_of_day, Class;

-- 1. Fraudulent transactions occur at all hours but peak at hour 11 (43 fraud cases), suggesting a potential vulnerability in fraud detection around this time.
-- 2. Hour 9 and hour 7 also show relatively high fraud counts (15 and 23 cases, respectively), possibly indicating another risk window.
-- 3. Most transactions (both fraud and non-fraud) happen between hours 0-12, with non-fraudulent transactions peaking at hour 11 (8,474 cases).
-- 4. Some hours have very few fraud cases (e.g., hour 10 with only 2 frauds), indicating that fraud might not be uniformly distributed throughout the day.

SELECT 
    CASE 
        WHEN Amount < 10 THEN 'Low (<$10)' 
        WHEN Amount BETWEEN 10 AND 100 THEN 'Medium ($10-$100)' 
        WHEN Amount BETWEEN 100 AND 1000 THEN 'High ($100-$1000)' 
        ELSE 'Very High (>$1000)' 
    END AS amount_category, 
    Class, 
    COUNT(*) AS transaction_count 
FROM creditcard 
GROUP BY amount_category, Class 
ORDER BY amount_category, Class;

-- 1. Fraud is most common in low-value transactions (<$10), with 75 fraudulent cases, which suggests fraudsters may be using small amounts to test stolen cards.
-- 2. Medium ($10-$100) and high ($100-$1000) transactions have similar fraud counts (45 and 25, respectively), indicating that fraud is not exclusive to small transactions.
-- 3. Very high transactions (>$1000) have the lowest fraud count (only 2 cases), possibly due to stricter security checks on large payments.
-- 4. Most transactions are in the medium ($10-$100) range (23,426 total), but fraud rates here are not significantly higher.

SELECT 
    CASE 
        WHEN Time BETWEEN 0 AND 21600 THEN 'Midnight - 6 AM'
        WHEN Time BETWEEN 21601 AND 43200 THEN '6 AM - Noon'
        WHEN Time BETWEEN 43201 AND 64800 THEN 'Noon - 6 PM'
        ELSE '6 PM - Midnight'
    END AS Time_Period,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY Time_Period, Class
ORDER BY Time_Period, Class;

-- 1. Most transactions occur between 6 AM - Noon (35,066 transactions), with fraud making up only 0.26% (91 cases).
-- 2. Midnight - 6 AM sees 12,340 transactions, with fraud occurring at a slightly higher rate (0.45% or 55 cases).
-- 3. Noon - 6 PM has very few transactions (415 total), but fraud remains present (1 fraudulent case).

SELECT 
    CASE 
        WHEN Amount < 10 THEN 'Low (<$10)'
        WHEN Amount BETWEEN 10 AND 100 THEN 'Medium ($10-$100)'
        WHEN Amount BETWEEN 100 AND 1000 THEN 'High ($100-$1000)'
        ELSE 'Very High (>$1000)'
    END AS Amount_Category,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY Amount_Category, Class
ORDER BY Amount_Category, Class;

-- 1. Low-value transactions (<$10) account for the most fraud cases (75 out of 146 fraud cases, 51.4%), suggesting fraudsters often make small transactions to avoid detection.
-- 2. Medium transactions ($10-$100) have 45 fraud cases (30.8%), indicating a moderate risk in this range.
-- 3. High-value transactions ($100-$1000) see a lower fraud rate (25 fraud cases, 17.1%), possibly due to stricter verification.
-- 4. Very high-value transactions (>$1000) are rare, with only 2 fraud cases, likely due to heightened security measures.

SELECT 
    DAYNAME(STR_TO_DATE(Time, '%s')) AS Day_Of_Week,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY Day_Of_Week, Class
ORDER BY FIELD(Day_Of_Week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), Class;

-- 1. Thursday has the highest number of fraud cases (125), indicating a potential pattern in fraudulent activities.
-- 2. Fraud cases are significantly lower on other days (22 on the recorded day), suggesting fraud may peak midweek.
-- 3. Total transactions are also highest on Thursday (45,425), meaning fraudsters might take advantage of increased activity.
-- 4. Further analysis is needed to confirm if fraud is more likely due to transaction volume or specific behaviors on Thursdays.

SELECT 
    CASE 
        WHEN HOUR(STR_TO_DATE(Time, '%s')) BETWEEN 0 AND 5 THEN 'Midnight - 6 AM'
        WHEN HOUR(STR_TO_DATE(Time, '%s')) BETWEEN 6 AND 11 THEN '6 AM - Noon'
        WHEN HOUR(STR_TO_DATE(Time, '%s')) BETWEEN 12 AND 17 THEN 'Noon - 6 PM'
        ELSE '6 PM - Midnight'
    END AS Time_Period,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY Time_Period, Class
ORDER BY FIELD(Time_Period, 'Midnight - 6 AM', '6 AM - Noon', 'Noon - 6 PM', '6 PM - Midnight'), Class;

-- 1. Most fraud cases (125) occur between Midnight - 6 AM, suggesting fraudsters prefer late-night transactions when monitoring may be lower.
-- 2. The number of fraud cases (22) is significantly lower during 6 PM - Midnight, indicating less fraudulent activity in the evening.
-- 3. Midnight - 6 AM also has the highest total transactions (45,425), meaning the high fraud count might correlate with volume.
-- 4. Further investigation is needed to determine if fraud rates are truly higher at night or if it's just a result of more transactions happening.

SELECT 
    CASE 
        WHEN Amount < 10 THEN 'Low (<$10)'
        WHEN Amount BETWEEN 10 AND 100 THEN 'Medium ($10-$100)'
        WHEN Amount BETWEEN 100 AND 1000 THEN 'High ($100-$1000)'
        ELSE 'Very High (>$1000)'
    END AS Amount_Category,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY Amount_Category, Class
ORDER BY FIELD(Amount_Category, 'Low (<$10)', 'Medium ($10-$100)', 'High ($100-$1000)', 'Very High (>$1000)'), Class;


-- 1. Fraud is more common in low-value transactions: 75 fraudulent transactions occurred for amounts under $10, the highest count among all categories.
-- 2. Medium transactions ($10-$100) have fewer fraud cases (45), despite having the highest total transaction count (23,426).
-- 3. High-value transactions ($100-$1000) show lower fraud cases (25), but this category also has fewer overall transactions (9,171).
-- 4. Very High transactions (>$1000) have the least fraud cases (2), likely due to stricter monitoring for large transactions.
-- 5. Fraud rates are highest in small transactions, suggesting fraudsters prefer lower amounts to avoid detection.

SELECT 
    DAYNAME(STR_TO_DATE(Time, '%s')) AS Day_of_Week,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY Day_of_Week, Class
ORDER BY FIELD(Day_of_Week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), Class;

-- 1. Most transactions occur on Thursday (45,425), with 125 fraudulent cases. This suggests Thursday is a high-activity day.
-- 2. A small subset of transactions (2,249 total) has null values for the day, with 22 fraud cases. This could indicate missing or improperly recorded timestamps.
-- 3. Fraud rate is slightly higher in the "null" category (0.978%) compared to Thursday (0.275%), suggesting missing timestamps might be linked to fraudulent activity.

SELECT 
    CASE 
        WHEN HOUR(STR_TO_DATE(Time, '%s')) BETWEEN 0 AND 6 THEN 'Midnight - 6 AM'
        WHEN HOUR(STR_TO_DATE(Time, '%s')) BETWEEN 6 AND 12 THEN '6 AM - Noon'
        WHEN HOUR(STR_TO_DATE(Time, '%s')) BETWEEN 12 AND 18 THEN 'Noon - 6 PM'
        ELSE '6 PM - Midnight'
    END AS Time_of_Day,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY Time_of_Day, Class
ORDER BY FIELD(Time_of_Day, 'Midnight - 6 AM', '6 AM - Noon', 'Noon - 6 PM', '6 PM - Midnight'), Class;


-- 1. Most transactions (45,425) occur between Midnight - 6 AM, with 125 fraud cases. This suggests that a high volume of transactions happens overnight.
-- 2. The fraud rate is slightly higher in the 6 PM - Midnight period (0.97%) compared to Midnight - 6 AM (0.27%).
-- 3. Fraudulent transactions are spread across different times, but late-night transactions might need further scrutiny.

SELECT 
    CASE 
        WHEN Amount < 10 THEN 'Low (<$10)'
        WHEN Amount BETWEEN 10 AND 100 THEN 'Medium ($10-$100)'
        WHEN Amount BETWEEN 100 AND 1000 THEN 'High ($100-$1000)'
        ELSE 'Very High (>$1000)'
    END AS Amount_Category,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY Amount_Category, Class
ORDER BY FIELD(Amount_Category, 'Low (<$10)', 'Medium ($10-$100)', 'High ($100-$1000)', 'Very High (>$1000)'), Class;

-- 1. Most transactions (23,426) fall in the Medium ($10-$100) category, followed by Low (<$10) transactions (14,548).
-- 2. Fraudulent transactions are more frequent in the Low (<$10) category (75 cases), which is the highest among all categories.
-- 3. Fraud rate (%) by category:

-- 4. While low-value transactions dominate fraud cases in volume, the highest fraud rate is observed in the Very High (>$1000) category (0.38%).

SELECT 
    CASE 
        WHEN DAYOFWEEK(Time) = 1 THEN 'Sunday'
        WHEN DAYOFWEEK(Time) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(Time) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(Time) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(Time) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(Time) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(Time) = 7 THEN 'Saturday'
    END AS DayOfWeek,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY DayOfWeek, Class
ORDER BY FIELD(DayOfWeek, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'), Class;

-- 1. Most transactions (45,469) occur on unspecified days, with 140 fraud cases. This suggests missing or misclassified timestamps.
-- 2. Fraud is distributed across all days but remains extremely low (1-2 cases per day).
-- 3. Sunday, Monday, Tuesday, and Thursday each report only 1 fraud case.
-- 4. Saturday has the highest recorded fraud cases (2), but the sample size is too small to draw strong conclusions.
-- 5. Fraud rates by day are nearly identical, indicating no strong correlation between fraud and the day of the week.

SELECT 
    CASE 
        WHEN HOUR(Time) BETWEEN 0 AND 5 THEN 'Midnight - 6 AM'
        WHEN HOUR(Time) BETWEEN 6 AND 11 THEN '6 AM - Noon'
        WHEN HOUR(Time) BETWEEN 12 AND 17 THEN 'Noon - 6 PM'
        ELSE '6 PM - Midnight'
    END AS TimeOfDay,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY TimeOfDay, Class
ORDER BY FIELD(TimeOfDay, 'Midnight - 6 AM', '6 AM - Noon', 'Noon - 6 PM', '6 PM - Midnight'), Class;
-- 1. Most transactions occur in the evening (6 PM - Midnight), with 28,779 legitimate transactions and 97 fraud cases.
-- 2. Fraud is more frequent in the evening (97 cases) compared to late night/early morning (50 cases).
-- 3. The fraud rate is higher between 6 PM - Midnight (0.34%) compared to Midnight - 6 AM (0.26%), suggesting fraudsters are more active in the evening.
-- 4. No recorded transactions for Noon - 6 PM or 6 AM - Noon, indicating missing data or a logging issue.

SELECT 
    CASE 
        WHEN Amount < 10 THEN 'Low (<$10)'
        WHEN Amount BETWEEN 10 AND 100 THEN 'Medium ($10-$100)'
        WHEN Amount BETWEEN 100 AND 1000 THEN 'High ($100-$1000)'
        ELSE 'Very High (>$1000)'
    END AS AmountCategory,
    Class,
    COUNT(*) AS transaction_count
FROM creditcard
GROUP BY AmountCategory, Class
ORDER BY FIELD(AmountCategory, 'Low (<$10)', 'Medium ($10-$100)', 'High ($100-$1000)', 'Very High (>$1000)'), Class;

CREATE TABLE final_creditcard_data AS 
SELECT * FROM creditcard;

SHOW VARIABLES LIKE 'secure_file_priv';

SELECT * FROM final_creditcard_data  
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/final_creditcard_data.csv'  
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n';

