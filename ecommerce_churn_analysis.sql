
-- DATA CLEANING --

WITH ecommercechurn AS (
  SELECT * FROM `lucaz-nguyen.project.ecommerce_customer_churn`) 

-- -- 1.Finding the total number of customers.
-- SELECT DISTINCT COUNT(CustomerID) AS TotalNumberOfCustomers
-- FROM ecommercechurn

-- -- 2. Checking for duplicate rows
-- SELECT CustomerID, COUNT(CustomerID) AS Count
-- FROM ecommercechurn
-- GROUP BY CustomerID
-- HAVING COUNT(CustomerID) > 1

-- -- 3. Checking for null values
-- SELECT 'Churn' AS ColumnName, COUNTIF(Churn IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'Tenure' AS ColumnName, COUNTIF(Tenure IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'PreferredLoginDevice' AS ColumnName, COUNTIF(PreferredLoginDevice IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'CityTier' AS ColumnName, COUNTIF(CityTier IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'WarehouseToHome' AS ColumnName, COUNTIF(WarehouseToHome IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'PreferredPaymentMode' AS ColumnName, COUNTIF(PreferredPaymentMode IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'Gender' AS ColumnName, COUNTIF(Gender IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'HourSpendOnApp' AS ColumnName, COUNTIF(HourSpendOnApp IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'NumberOfDeviceRegistered' AS ColumnName, COUNTIF(NumberOfDeviceRegistered IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'PreferedOrderCat' AS ColumnName, COUNTIF(PreferedOrderCat IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'SatisfactionScore' AS ColumnName, COUNTIF(SatisfactionScore IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'MaritalStatus' AS ColumnName, COUNTIF(MaritalStatus IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'NumberOfAddress' AS ColumnName, COUNTIF(NumberOfAddress IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'Complain' AS ColumnName, COUNTIF(Complain IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'OrderAmountHikeFromlastYear' AS ColumnName, COUNTIF(OrderAmountHikeFromlastYear IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'CouponUsed' AS ColumnName, COUNTIF(CouponUsed IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'OrderCount' AS ColumnName, COUNTIF(OrderCount IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'DaySinceLastOrder' AS ColumnName, COUNTIF(DaySinceLastOrder IS NULL) AS NullCount
-- FROM ecommercechurn
-- UNION ALL
-- SELECT 'CashbackAmount' AS ColumnName, COUNTIF(CashbackAmount IS NULL) AS NullCount
-- FROM ecommercechurn
-- ORDER BY NullCount DESC

-- -- 3.1 Handing Null Values
, ColumnMeans AS (
    SELECT
      ROUND(AVG(DaySinceLastOrder),0) AS DaySinceLastOrder_mean
      , ROUND(AVG(OrderAmountHikeFromlastYear),0) AS OrderAmountHikeFromlastYear_mean
      , ROUND(AVG(Tenure),0) AS Tenure_mean
      , ROUND(AVG(OrderCount),0) AS OrderCount_mean
      , ROUND(AVG(CouponUsed),0) AS CouponUsed_mean
      , ROUND(AVG(HourSpendOnApp),0) AS HourSpendOnApp_mean
      , ROUND(AVG(WarehouseToHome),0) AS WarehouseToHome_mean
    FROM ecommercechurn
  )

 , FilledValues AS (
    SELECT
      COALESCE(t1.DaySinceLastOrder, t2.DaySinceLastOrder_mean) AS DaySinceLastOrder
      , COALESCE(t1.OrderAmountHikeFromlastYear, t2.OrderAmountHikeFromlastYear_mean) AS OrderAmountHikeFromlastYear
      , COALESCE(t1.Tenure, t2.Tenure_mean) AS Tenure
      , COALESCE(t1.OrderCount, t2.OrderCount_mean) AS OrderCount
      , COALESCE(t1.CouponUsed, t2.CouponUsed_mean) AS CouponUsed
      , COALESCE(t1.HourSpendOnApp, t2.HourSpendOnApp_mean) AS HourSpendOnApp
      , COALESCE(t1.WarehouseToHome, t2.WarehouseToHome_mean) AS WarehouseToHome
      , t1.* EXCEPT (DaySinceLastOrder, OrderAmountHikeFromlastYear, Tenure, OrderCount, CouponUsed, HourSpendOnApp, WarehouseToHome)
    FROM ecommercechurn AS t1
    CROSS JOIN
      ColumnMeans AS t2
  )

, cleansed AS (
  SELECT 
    * EXCEPT(PreferredLoginDevice, PreferedOrderCat, PreferredPaymentMode, WarehouseToHome)
    , REPLACE(PreferredLoginDevice, 'Mobile Phone', 'Phone') AS PreferredLoginDevice
    , REPLACE(REPLACE(PreferedOrderCat, 'Mobile Phone', 'Phone'), 'Mobile', 'Phone') AS PreferedOrderCat
    , REPLACE(PreferredPaymentMode, 'COD', 'Cash on Delivery') AS PreferredPaymentMode
    , REPLACE(REPLACE(CAST(WarehouseToHome AS STRING), '126', '26'), '127', '27') AS WarehouseToHome
  FROM FilledValues
)

, enrich AS (
  SELECT
    *
    , CASE 
      WHEN Churn = 1 THEN 'Churned' 
      WHEN Churn = 0 THEN 'Stayed'
    END
    AS CustomerStatus 
    , CASE 
      WHEN Complain = 1 THEN 'Yes'
      WHEN Complain = 0 THEN 'No'
    END
    AS ComplainRecieved
  FROM cleansed
)

, echurn AS (
  SELECT 
    CustomerID
    , Churn
    , CustomerStatus
    , Tenure
    , PreferredLoginDevice
    , CityTier
    , WarehouseToHome
    , PreferredPaymentMode
    , Gender
    , HourSpendOnApp
    , NumberOfDeviceRegistered
    , PreferedOrderCat
    , SatisfactionScore
    , MaritalStatus
    , NumberOfAddress
    , Complain
    , ComplainRecieved
    , OrderAmountHikeFromlastYear
    , CouponUsed
    , OrderCount
    , DaySinceLastOrder
    , CashbackAmount
  FROM enrich
) 

-- DATA EXPLORATION --

-- -- 1. What is the overall customer churn rate? 

-- SELECT 
--   (SELECT COUNT(*) FROM echurn) AS TotalNumberofCustomers
--   , COUNT(CASE WHEN CustomerStatus = 'Churned' THEN 1 END) AS TotalNumberofChurnedCustomers
--   , ROUND(((COUNT(CASE WHEN CustomerStatus = 'Churned' THEN 1 END) / COUNT(*)) * 100),2) AS ChurnRate
-- FROM echurn

-- -- 2. How does the churn rate vary based on the preferred login device?
-- SELECT 
--   PreferredLoginDevice
--   , COUNT(*) AS TotalCustomers
--   , SUM(Churn) AS ChurnedCustomers
--   , ROUND((SUM(Churn) / COUNT(*)) *100 ,2) AS ChurnRate
-- FROM echurn
-- GROUP BY 1 
 
-- -- 3. What is the distribution of customers across different city tiers?
-- SELECT 
--   CityTier
--   , COUNT(*) AS TotalCustomers
--   , SUM(Churn) AS ChurnedCustomers
--   , ROUND((SUM(Churn) / COUNT(*)) *100 ,2) AS ChurnRate
-- FROM echurn
-- GROUP BY 1 
-- ORDER BY 4 DESC

-- -- 4. Is there any correlation between the warehouse-to-home distance and customer churn?

, seg_distance AS (
  SELECT
  *
  , CASE
      WHEN CAST(WarehouseToHome AS INT64) <= 10 THEN 'Very close distance'
      WHEN CAST(WarehouseToHome AS INT64) > 10 AND CAST(WarehouseToHome AS INT64) <= 20 THEN 'Close Distance'
      WHEN CAST(WarehouseToHome AS INT64) > 20 AND CAST(WarehouseToHome AS INT64) <= 30 THEN 'Moderate Distance'
      WHEN CAST(WarehouseToHome AS INT64) > 30 THEN 'Far Distance'
   END 
   AS WarehouseToHomeRange
  FROM echurn
)

-- SELECT
--   WarehouseToHomeRange
--   , COUNT(*) AS TotalCustomer
--   , SUM(Churn) AS CustomerChurn
--   , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRate 
-- FROM seg_distance
-- GROUP BY 1
-- ORDER BY 4 DESC

-- -- 5. Which is the most preferred payment mode among churned customers?

-- SELECT
--   PreferredPaymentMode
--   , COUNT(*) AS TotalCustomer
--   , SUM(Churn) AS CustomerChurn
--   , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRate 
-- FROM echurn
-- GROUP BY 1
-- ORDER BY 4 DESC

-- -- 6. What is the typical tenure for churned customers?

, seg_tenure AS (
  SELECT
    *
    , CASE
        WHEN Tenure <= 6 THEN '6 Months'
        WHEN Tenure > 6 AND Tenure <= 12 THEN '1 Year'
        WHEN Tenure > 12 AND Tenure <= 24 THEN '2 Years'
        WHEN Tenure > 24 THEN 'More than 2 Years'
      END
      AS TenureRange
  FROM echurn
)

-- SELECT
--   TenureRange
--   , COUNT(*) AS TotalCustomer
--   , SUM(Churn) AS CustomerChurn
--   , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRate 
-- FROM seg_tenure
-- GROUP BY 1
-- ORDER BY 4 DESC

-- -- 7. Is there ant difference in churn rate between male and fenale customers?

-- SELECT
--   Gender
--   , COUNT(*) AS TotalCustomer
--   , SUM(Churn) AS CustomerChurn
--   , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRate 
-- FROM echurn
-- GROUP BY 1
-- ORDER BY 4 DESC

-- -- 8. How does the average time spent on the app differ for churned and non-churned customers?

-- SELECT
--   CustomerStatus
--   , ROUND(AVG(HourSpendOnApp)) AS AvgHourSpendOnApp
-- FROM echurn
-- GROUP BY 1

-- -- 9. Does the number of registered devices impact the likelihood of churn?

-- SELECT
--   NumberOfDeviceRegistered
--   , COUNT(*) AS TotalCustomer
--   , SUM(Churn) AS CustomerChurn
--   , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRate 
-- FROM echurn
-- GROUP BY 1
-- ORDER BY 4 DESC

-- -- 10. Which order category is most preferred among churned customers?

-- SELECT
--   PreferedOrderCat
--   , COUNT(*) AS TotalCustomer
--   , SUM(Churn) AS CustomerChurn
--   , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRate 
-- FROM echurn
-- GROUP BY 1
-- ORDER BY 4 DESC

-- -- 11. Is there any relationship between customer satisfaction scores and churn?

-- SELECT
--   SatisfactionScore
--   , COUNT(*) AS TotalCustomer
--   , SUM(Churn) AS CustomerChurn
--   , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRate 
-- FROM echurn
-- GROUP BY 1
-- ORDER BY 4 DESC

-- -- 12. Does the marital status of customers influence churn behavior?

-- SELECT
--   MaritalStatus
--   , COUNT(*) AS TotalCustomer
--   , SUM(Churn) AS CustomerChurn
--   , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRate 
-- FROM echurn
-- GROUP BY 1
-- ORDER BY 4 DESC

-- -- 13. How many addresses do churned customers have on average? 

-- SELECT
--   CustomerStatus
--   , ROUND(AVG(NumberOfAddress)) AS AvgNumberOfAddress
-- FROM echurn
-- GROUP BY 1

-- -- 14. Do customer complaints influence churned behavior?

-- SELECT
--   ComplainRecieved
--   , COUNT(*) AS TotalCustomer
--   , SUM(Churn) AS CustomerChurn
--   , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRate 
-- FROM echurn
-- GROUP BY 1
-- ORDER BY 4 DESC

-- -- 15. How does the use of coupons differ between churned and non-churned customers?

-- SELECT
--   CustomerStatus
--   , SUM(CouponUsed) AS SumofCouponUsed 
-- FROM echurn
-- GROUP BY 1

-- -- 16. What is the average number of days since the last order for churned customers?

-- SELECT
--   ROUND(AVG(DaySinceLastOrder)) AS AvgNumofDaySinceLastOrder
-- FROM echurn
-- WHERE CustomerStatus = 'Churned'


-- -- 17. Is there any correlation between cashback amount and churn rate?

, seg_cashbackamt AS (
  SELECT
    *
    , CASE
        WHEN CashbackAmount <= 100 THEN 'Low Cashback Amount'
        WHEN CashbackAmount > 100 AND CashbackAmount <= 200 THEN 'Moderate Cashback Amount'
        WHEN CashbackAmount > 200 AND CashbackAmount <= 300 THEN 'High Cashback Amount'
        WHEN CashbackAmount > 300 THEN 'Very High Cashback Amount'      
      END
      AS CashbackAmountRange
  FROM echurn
) 

-- SELECT
--   CashbackAmountRange
--   , COUNT(*) AS TotalCustomer
--   , SUM(Churn) AS CustomerChurn
--   , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRate 
-- FROM seg_cashbackamt
-- GROUP BY 1
-- ORDER BY 4 DESC

-- -- 18. Correlation between the order count and churn rate

-- SELECT
--   OrderCount
--   , COUNT(*) AS TotalCustomer
--   , SUM(Churn) AS CustomerChurn
--   , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRate 
-- FROM echurn
-- GROUP BY 1
-- ORDER BY 4 DESC

--------------------------------------

-- Advance Tasks: 

-- 1. Analyze key customer metrics across different tenure ranges to gain insights for effective retention strategies.

-- , aggregated_data AS (
--     SELECT
--         TenureRange
--         , COUNT(CustomerID) AS TotalCustomer
--         , ROUND(AVG(CashbackAmount)) AS AvgCashbackAmount
--         , ROUND(AVG(CAST(OrderCount AS DECIMAL))) AS AvgOrderCount
--         , ROUND(AVG(SatisfactionScore)) AS AvgSatisfactionScore
--         , ROUND(COUNT(CASE WHEN OrderCount > 1 THEN CustomerID END) * 1.0 / COUNT(CustomerID),2) AS RepeatPurchaseRate
--         , ROUND(AVG(HourSpendOnApp)) AS AvgHourSpendOnApp
--         , ROUND(AVG(NumberOfDeviceRegistered)) AS AvgNumberOfDeviceRegistered
--         , ROUND(AVG(OrderAmountHikeFromlastYear),2) AS AvgOrderAmountHikeFromlastYear
--         /*Thêm thông tin danh mục sản phẩm và thanh toán ưa thích */
--         , (SELECT PreferedOrderCat
--             FROM (SELECT PreferedOrderCat
--                         , COUNT(*) AS cat_cnt 
--                   FROM echurn
--                   GROUP BY 1 
--                   ORDER BY cat_cnt 
--                   DESC LIMIT 1
--             )) AS TopPreferredCategory
--         , (SELECT PreferredPaymentMode 
--             FROM (SELECT PreferredPaymentMode
--                         , COUNT(*) AS payment_cnt 
--                   FROM echurn
--                   GROUP BY 1 
--                   ORDER BY payment_cnt 
--                   DESC LIMIT 1
--             )) AS TopPreferredPayment
--         , ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS ChurnRatePercentage 
--     FROM seg_tenure
--     GROUP BY 1
-- )

-- SELECT
--     TenureRange
--     , TotalCustomer
--     , AvgCashbackAmount
--     , AvgOrderCount
--     , AvgSatisfactionScore
--     , ChurnRatePercentage
--     , RepeatPurchaseRate
--     , AvgHourSpendOnApp
--     , AvgNumberOfDeviceRegistered
--     , AvgOrderAmountHikeFromlastYear
--     , TopPreferredCategory
--     , TopPreferredPayment
-- FROM aggregated_data
-- ORDER BY ChurnRatePercentage DESC



---- 2. Perform RFM (Recency, Frequency, Monetary) segmentation of customers.

-- --  Calculate RFM values and Quartiles (combined for efficiency)
-- , rfm_values AS (
--   SELECT
--     CustomerID
--     , DaySinceLastOrder AS Recency
--     , OrderCount AS Frequency
--     , CashbackAmount AS MonetaryValue
--   FROM echurn
-- )

-- , quartiles AS (
--   SELECT
--     APPROX_QUANTILES(Recency, 4) AS Recency_Quartiles
--     , APPROX_QUANTILES(Frequency, 4) AS Frequency_Quartiles
--     , APPROX_QUANTILES(MonetaryValue, 4) AS Monetary_Quartiles
--   FROM rfm_values
-- )

-- -- Determine Outlier Limits (using array indexing)

-- , outlier_limit AS (
--   SELECT
--     Recency_Quartiles[OFFSET(1)] - 1.5 * (Recency_Quartiles[OFFSET(3)] - Recency_Quartiles[OFFSET(1)]) AS Recency_LowerLimit
--     , Recency_Quartiles[OFFSET(3)] + 1.5 * (Recency_Quartiles[OFFSET(3)] - Recency_Quartiles[OFFSET(1)]) AS Recency_UpperLimit
--     , Frequency_Quartiles[OFFSET(1)] - 1.5 * (Frequency_Quartiles[OFFSET(3)] - Frequency_Quartiles[OFFSET(1)]) AS Frequency_LowerLimit
--     , Frequency_Quartiles[OFFSET(3)] + 1.5 * (Frequency_Quartiles[OFFSET(3)] - Frequency_Quartiles[OFFSET(1)]) AS Frequency_UpperLimit
--     , Monetary_Quartiles[OFFSET(1)] - 1.5 * (Monetary_Quartiles[OFFSET(3)] - Monetary_Quartiles[OFFSET(1)]) AS Monetary_LowerLimit
--     , Monetary_Quartiles[OFFSET(3)] + 1.5 * (Monetary_Quartiles[OFFSET(3)] - Monetary_Quartiles[OFFSET(1)]) AS Monetary_UpperLimit
--   FROM quartiles
-- )

-- -- Filter Outliers

-- , rfm_values_nooutliers AS (
--   SELECT
--     rv.CustomerID
--     , rv.Frequency
--     , rv.Recency
--     , rv.MonetaryValue
--   FROM rfm_values rv
--   CROSS JOIN outlier_limit ol
--   WHERE
--     rv.Recency >= ol.Recency_LowerLimit AND rv.Recency <= ol.Recency_UpperLimit
--     AND rv.Frequency >= ol.Frequency_LowerLimit AND rv.Frequency <= ol.Frequency_UpperLimit
--     AND rv.MonetaryValue >= ol.Monetary_LowerLimit AND rv.MonetaryValue <= ol.Monetary_UpperLimit
-- )

-- -- Assign RFM Scores (using NTILE)

-- ,  rfm_scores AS (
--   SELECT
--     CustomerID
--     , NTILE(4) OVER (ORDER BY Recency DESC) AS R
--     , NTILE(4) OVER (ORDER BY Frequency DESC) AS F
--     , NTILE(4) OVER (ORDER BY MonetaryValue DESC) AS M
--   FROM rfm_values_nooutliers
-- )

-- -- Create RFM Segments

-- , rfm_segments AS (
--   SELECT
--     CustomerID
--     , R
--     , F
--     , M
--     , CAST(R AS STRING) || CAST(F AS STRING) || CAST(M AS STRING) AS rfm_segment
--     , CASE
--         WHEN R = 1 AND F = 1 AND M = 1 THEN 'Best Customers'
--         WHEN F = 1 AND R IN (1,2) THEN 'Loyal Customers'
--         WHEN M = 1 AND R IN (1,2) THEN 'Big Spenders Customers'
--         WHEN R = 1 THEN 'New Customers'
--         WHEN R IN (1,2) AND F > 2 THEN 'Promising Customers'
--         WHEN R IN (3,4) AND F IN (1,2) THEN 'Lost Potential Customers'
--         WHEN R IN (3,4) THEN 'Lost Customers'
--         ELSE 'Need Attention'
--       END 
--       AS Segment
--   FROM rfm_scores
-- )

-- -- Create a New Table/View with all segments (best practice for data warehouses)

-- SELECT
--     ec.*
--     , WarehouseToHomeRange
--     , TenureRange
--     , CashbackAmountRange
--     , rs.R
--     , rs.F
--     , rs.M
--     , rs.RFM_Segment
--     , rs.Segment
-- FROM
--     echurn ec
-- LEFT JOIN seg_distance d ON ec.CustomerID = d.CustomerID 
-- LEFT JOIN seg_tenure t ON ec.CustomerID = t.CustomerID
-- LEFT JOIN seg_cashbackamt c ON ec.CustomerID = c.CustomerID
-- LEFT JOIN rfm_segments rs ON ec.CustomerID = rs.CustomerID;




