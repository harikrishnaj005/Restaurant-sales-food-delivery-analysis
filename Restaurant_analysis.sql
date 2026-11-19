#RESTAURANT SALES & CUSTOMER ANALYSIS
#1. DATA VALIDATION
SELECT COUNT(*) AS Total_Orders
FROM orders;

#Total revenue
SELECT SUM(Bill_amt) AS Total_Revenue
FROM orders;

#Average order value
SELECT AVG(Bill_amt) AS Average_Order_Value
FROM orders;

#Orders by deliverystatus
SELECT
    DeliveryStatus,
    COUNT(OrderID) AS Total_Orders
FROM orders
GROUP BY DeliveryStatus
ORDER BY Total_Orders DESC;

#Revenue by restaurant
SELECT
    Hotelname,
    SUM(Bill_amt) AS Revenue
FROM orders
GROUP BY Hotelname
ORDER BY Revenue DESC;

#Order count by restaurant
SELECT
    Hotelname,
    COUNT(OrderID) AS Total_Orders
FROM orders
GROUP BY Hotelname
ORDER BY Total_Orders DESC;

#Most ordered fooditem
SELECT
    Fooditem,
    SUM(Quantity) AS Total_Quantity
FROM orders
GROUP BY Fooditem
ORDER BY Total_Quantity DESC;

#Revenue by fooditem
SELECT
    Fooditem,
    SUM(Bill_amt) AS Total_Revenue
FROM orders
GROUP BY Fooditem
ORDER BY Total_Revenue DESC;

#Orders by payment method
SELECT
    payment_method,
    COUNT(*) AS Order_Count
FROM orders
GROUP BY payment_method
ORDER BY Order_Count DESC;

#Revenue by payment method
SELECT
    payment_method,
    SUM(Bill_amt) AS Total_Revenue
FROM orders
GROUP BY payment_method
ORDER BY Total_Revenue DESC;

#Top customers by spending
SELECT
    c.Customer_name,
    COUNT(o.OrderID) AS Total_Orders,
    SUM(o.Bill_amt) AS Total_Spent
FROM orders o
JOIN customers c
    ON o.Customer_Id = c.Cust_Id
GROUP BY c.Cust_Id, c.Customer_name
ORDER BY Total_Spent DESC;

#Orders by deliverypartners
SELECT
    d.Deliverypartner_name,
    COUNT(o.OrderID) AS Total_Orders
FROM orders o
JOIN deliverypartner d
    ON o.Deliverypartner_Id = d.Deliverypartner_Id
GROUP BY d.Deliverypartner_Id, d.Deliverypartner_name
ORDER BY Total_Orders DESC;

#Monthly order volume
SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    COUNT(OrderID) AS Total_Orders
FROM orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

#Average order value by restaurant
SELECT
    Hotelname,
    ROUND(AVG(Bill_amt), 2) AS Average_Order_Value
FROM orders
GROUP BY Hotelname
ORDER BY Average_Order_Value DESC;

#Delivery status and revenue
SELECT
    DeliveryStatus,
    COUNT(OrderID) AS Total_Orders,
    SUM(Bill_amt) AS Total_Revenue
FROM orders
GROUP BY DeliveryStatus
ORDER BY Total_Orders DESC;

#Top fooditems by restaurant
SELECT
    Hotelname,
    Fooditem,
    SUM(Quantity) AS Total_Quantity,
    SUM(Bill_amt) AS Total_Revenue
FROM orders
GROUP BY Hotelname, Fooditem
ORDER BY Total_Revenue DESC;

#Custmer order frequency
SELECT
    Customer_Id,
    COUNT(OrderID) AS Total_Orders,
    SUM(Bill_amt) AS Total_Spent
FROM orders
GROUP BY Customer_Id
ORDER BY Total_Orders DESC;

#Cancellation rate
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN DeliveryStatus = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS Cancellation_Rate_Percent
FROM orders;

#Restaurants with above average revenue
SELECT
    Hotelname,
    SUM(Bill_amt) AS Total_Revenue
FROM orders
GROUP BY Hotelname
HAVING SUM(Bill_amt) > (
    SELECT AVG(Restaurant_Revenue)
    FROM (
        SELECT SUM(Bill_amt) AS Restaurant_Revenue
        FROM orders
        GROUP BY Hotelname
    ) AS Revenue_Table
)
ORDER BY Total_Revenue DESC;

#Customers spending above average
SELECT
    Customer_Id,
    SUM(Bill_amt) AS Total_Spent
FROM orders
GROUP BY Customer_Id
HAVING SUM(Bill_amt) > (
    SELECT AVG(Customer_Spending)
    FROM (
        SELECT SUM(Bill_amt) AS Customer_Spending
        FROM orders
        GROUP BY Customer_Id
    ) AS Customer_Table
)
ORDER BY Total_Spent DESC;

#Deliverypartner performance
SELECT
    d.Deliverypartner_name,
    COUNT(o.OrderID) AS Total_Orders,
    SUM(o.Bill_amt) AS Total_Revenue
FROM deliverypartner d
JOIN orders o
    ON d.Deliverypartner_Id = o.Deliverypartner_Id
GROUP BY d.Deliverypartner_Id, d.Deliverypartner_name
ORDER BY Total_Orders DESC;

#Monthly revenue using CTE
WITH Monthly_Sales AS (
    SELECT
        YEAR(OrderDate) AS Order_Year,
        MONTH(OrderDate) AS Order_Month,
        SUM(Bill_amt) AS Monthly_Revenue
    FROM orders
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT
    Order_Year,
    Order_Month,
    Monthly_Revenue
FROM Monthly_Sales
ORDER BY Order_Year, Order_Month;
