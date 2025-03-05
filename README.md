# Ecommerce Customer Churn Analysis

## Table of Contents

*   [Project Overview](#project-overview)
*   [Dataset](#dataset)
*   [Methodology](#methodology)
*   [Insights](#insights)
*   [Recommendations](#recommendations)
*   [Tools Used](#tools-used)
*   [Potential Business Impact](#potential-business-impact)
*   [Conclusion](#conclusion)

## Project Overview

This project analyzes customer churn within an e-commerce platform to identify key factors contributing to churn and develop data-driven insights for customer retention strategies.

## Dataset

The dataset originates from a leading online e-commerce company. The goal is to identify customers likely to churn so that targeted promotions and interventions can be offered.

## Methodology

The project follows a structured approach:

1.  **Data Cleaning and Preparation:**

    *   **Initial Data Exploration:** Understanding the dataset structure, identifying duplicates, null values, and overall data characteristics.
    *   **Handling Null Values:** Imputing missing numerical data using the mean.
    *   **Data Transformation:**
        *   Standardizing inconsistent categorical values.
        *   Converting data types appropriately.
        *   Creating new categorical variables (e.g., tenure range, warehouse distance range).
        *   Creating `customer_status` (stayed/churned) and `complain_received` (yes/no) flags.
    *   **Final Data:** Creating a new table named `echurn`.

2.  **Data Exploration and Analysis:**

    *   **Churn Rate Calculation:** Calculating the overall churn rate.
    *   **Churn Rate by Attribute:** Analyzing churn rates across various customer attributes:
        *   Preferred login device
        *   City tier
        *   Warehouse-to-home distance
        *   Preferred payment mode
        *   Tenure
        *   Gender
        *   Time spent on the app
        *   Number of registered devices
        *   Preferred order category
        *   Customer satisfaction score
        *   Marital status
        *   Number of addresses
        *   Complaints
        *   Coupon usage
        *   Days since last order
        *   Cashback amount
        *   Order count
    *   **Key Metric Analysis:** Comparing key customer metrics between churned and non-churned customers:
        *   Average time spent on the app
        *   Average number of addresses
        *   Average days since the last order
        *   Average number of coupons used.
    *   **Advanced Tasks:**
        *   Analyzing key customer metrics across different tenure ranges.
        *   Performing RFM (Recency, Frequency, Monetary) segmentation of customers.

## Insights

This analysis reveals key insights into customer behavior and churn drivers based on a dataset of 5,630 customers.

1.  **Overall Churn Landscape:**

    *   **Significant Churn Rate:** The overall churn rate is 16.84%, indicating a need for focused retention efforts.

2.  **Customer Demographics and Preferences:**

    *   **Login Device:** Desktop users have a slightly higher churn rate (19.83%) than phone users (15.62%).
    *   **City Tier:** Churn rates are lower in Tier 1 cities (14.51%) compared to Tier 2 (19.83%) and Tier 3 (21.37%) cities.
    *   **Warehouse Proximity:** Closer proximity to the warehouse correlates with lower churn.
    *   **Payment Mode:** "Cash on Delivery" (24.90%) and "E-wallet" (22.80%) are associated with higher churn, while "Credit Card" (12.86%) and "Debit Card" (15.38%) have lower churn.
    *   **Gender:** Male customers have a slightly higher churn rate (17.73%) than female customers (15.49%).
    *   **Marital Status:** Single customers have the highest churn rate (26.73%), while married customers have the lowest (11.52%).

3.  **Customer Behavior and Engagement:**

    *   **Tenure:** Longer tenure is strongly associated with lower churn. Customers with >2 years tenure have 0% churn, while <6 months have 32.42% churn.
    *   **App Usage Time:**  Time spent on the app does not significantly differentiate between churned and non-churned customers (2 hours on average for both).
    *   **Registered Devices:** Higher numbers of registered devices correlate with higher churn (especially 6 devices: 34.57%).
    *   **Addresses:** Churned customers have an average of four associated addresses.
    *   **Coupon Usage:** Coupon usage is higher among non-churned customers.
    *   **Days Since Last Order:** Churned customers have had a shorter time since their last order.
    *   **Complaint:** Customer complaints are more prevalent among churned customers.

4.  **Product and Service-Related Factors:**

    *   **Order Category:** "Mobile Phone" orders have the highest churn rate (27.40%), while "Grocery" has the lowest (4.88%).
    *   **Satisfaction Scores:** Surprisingly, highly satisfied customers (rating 5) have a relatively higher churn rate (23.83%) than those with a rating of 3 (17.20%).
    *   **Cashback:** Moderate cashback amounts correspond to higher churn rates (18.91%), while higher amounts lead to lower churn (10.72%).

5.  **Order Count and Churn**

    *   **Order Count:** Customers with 16 orders have the highest churn rate (26.09%)

6.  **Advanced Analysis Insights:**

    *   **Tenure-Based Analysis:**
        *   Churn rate decreases significantly as tenure increases.
        *   Repeat purchase rate increases with tenure.
        *   Average cashback amount and order count tend to increase slightly with tenure.
        *   Average satisfaction score is constant.
        *   Customer shopping habits are constant over time.

    *   **RFM Segmentation:**

        *   Segments like "Lost Customers" and "Lost Potential Customers" are at high risk of churn.
        *   "Loyal Customers" and "Big Spenders" are valuable segments that require retention efforts.
        *   "Best Customers" is the most important segment that must be retained.
        *   "New Customers" and "Promising Customers" must be analyzed to convert them into the "Best Customers" and "Loyal Customer" segments.

## Recommendations

*   **Elevate the Desktop User Experience:** Improve design, navigation, and functionality for desktop users.
*   **Address City Tier Disparities and Improve Regional Service:** Focus on improving service quality and addressing logistical challenges in Tier 2 and Tier 3 cities.
*   **Optimize Delivery Operations for Speed and Transparency:** Improve delivery for customers within the "moderate distance" range (20-30 units).
*   **Streamline Payment Options and Incentivize Preferred Methods:** Encourage the use of "Credit Card" and "Debit Card" payment options.
*   **Cultivate Early Customer Loyalty Through Effective Onboarding:** Implement onboarding programs for new customers.
*   **Ensure a Consistent and Seamless Multi-Device Experience:** Guarantee a user-friendly experience across all registered devices.
*   **Develop Category-Specific Retention Strategies:** Tailor strategies for key customer segments, such as those who frequently purchase "Mobile Phone" items.
*   **Implement Proactive Customer Engagement Strategies Beyond Satisfaction Scores:** Personalize offers and improve the complaint handling process.
*   **Leverage RFM Segmentation for Targeted Re-engagement Campaigns:** Design campaigns for segments like "Lost Customers" and "Lost Potential Customers."
*   **Maximize Coupon Usage and Implement a Robust Loyalty Program:** Reward repeat purchases and engagement.
*   **Embrace Continuous Monitoring and Data-Driven Iteration:** Regularly monitor churn rates and strategy effectiveness.

## Tools Used

*   **SQL:**  Used for data querying, cleaning, transformation, and analysis.
*   **BigQuery:** The database where data is stored.

## Potential Business Impact

*   Reduce customer loss
*   Improve customer satisfaction
*   Increase customer lifetime value
*   Improve ROI through more suitable strategies.

## Conclusion

This project provides a comprehensive approach to analyzing customer churn in an e-commerce context, offering actionable insights for positive business impact.
