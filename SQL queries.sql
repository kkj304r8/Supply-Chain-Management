###### 1. KPI_Total Sales Amount ######
USE project;
SELECT * FROM point_of_sales;
SELECT format(sum(Sales_Amount),0) AS Total_Sales FROM point_of_sales;

###### 2. KPI_Total Inventory ######
SELECT * FROM inventory;
SELECT format(sum(Quantity_on_Hand),0) AS Total_Inventory FROM inventory;

###### 3. KPI_Inventory Value ######
SELECT format(sum(Quantity_on_Hand*Price),0) AS Inventory_Value FROM inventory;

#################################################################################################

###### 1. TABLE_Yearly Sales ######
SELECT year(Date) AS Year, sum(Sales_Amount) AS Yearly_Sales FROM sales
INNER JOIN point_of_sales
ON sales.Order_Number = point_of_sales.Order_Number
GROUP BY Year
ORDER BY Yearly_Sales DESC;

###### 2. TABLE_Quarterly Sales ######
SELECT quarter(Date) AS Quarter, sum(Sales_Amount) AS Quarterly_Sales FROM sales
INNER JOIN point_of_sales
ON sales.Order_Number = point_of_sales.Order_Number
GROUP BY Quarter
ORDER BY Quarterly_Sales DESC;

###### 3. TABLE_Monthly Sales ######
SELECT monthname(Date) AS Month, sum(Sales_Amount) AS Monthly_Sales FROM sales
INNER JOIN point_of_sales
ON sales.Order_Number = point_of_sales.Order_Number
GROUP BY Month
ORDER BY Monthly_Sales DESC;

###### 4. TABLE_Product wise Sales ######
USE project;
SELECT * FROM product;
SELECT * FROM point_of_sales;
SELECT Product_Type, sum(Sales_Amount) AS Total_Sales FROM product
INNER JOIN point_of_sales
ON product.Product_Key = point_of_sales.Product_Key
GROUP BY Product_Type
ORDER BY Total_Sales DESC;

###### 5. TABLE_Top 10 Store Sales ######
SELECT Store_Name, sum(Sales_Amount) AS Total_Sales FROM sales
INNER JOIN store
ON sales.Store_Key = store.Store_Key
INNER JOIN point_of_sales
ON sales.Order_Number = point_of_sales.Order_Number
GROUP BY Store_Name
ORDER BY Total_Sales DESC
LIMIT 10;

###### 6. TABLE_Top 10 State wise Sales ######
SELECT Store_State, sum(Sales_Amount) AS Total_Sales FROM sales
INNER JOIN store
ON sales.Store_Key = store.Store_Key
INNER JOIN point_of_sales
ON sales.Order_Number = point_of_sales.Order_Number
GROUP BY Store_State
ORDER BY Total_Sales DESC
LIMIT 10;

###### 7. TABLE_Region wise Sales ######
SELECT * FROM store;
SELECT Store_Region, sum(Sales_Amount) AS Total_Sales FROM sales
INNER JOIN store
ON sales.Store_Key = store.Store_Key
INNER JOIN point_of_sales
ON sales.Order_Number = point_of_sales.Order_Number
GROUP BY Store_Region
ORDER BY Total_Sales DESC;

###### 8. TABLE_Items Sold per Product Family ######
SELECT * FROM inventory;
SELECT Product_Family, count(Sales_Quantity) AS Total_Items_Sold FROM point_of_sales
INNER JOIN inventory
ON point_of_sales.Product_Key = inventory.Product_Key
GROUP BY Product_Family
ORDER BY Total_Items_Sold DESC;

###### 9. TABLE_Purchase Method Wise Sales ######
SELECT Purchase_Method, sum(Sales_Amount) AS Total_Sales FROM sales
INNER JOIN point_of_sales
ON sales.Order_Number = point_of_sales.Order_Number
GROUP BY Purchase_Method
ORDER BY Total_Sales DESC;

###### 10. TABLE_Sales Growth ######
WITH CTE AS(SELECT
year(Date) AS Year, sum(Sales_Amount) AS Total_Sales
FROM sales
INNER JOIN point_of_sales
ON sales.Order_Number = point_of_sales.Order_Number
GROUP BY Year
),
YOY AS (SELECT
Year, Total_Sales, LAG(Total_Sales,1) OVER (ORDER BY Year) AS PY
FROM CTE
)
SELECT Year, Total_Sales, concat(format((Total_Sales - PY) * 100 / PY, 0), '%') AS '%YOY Change'
FROM YOY
ORDER BY Year;