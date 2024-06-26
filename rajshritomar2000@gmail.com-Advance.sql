--SQL Advance Case Study


--Q1--BEGIN 
SELECT STATE , YEAR(Date) AS YEAR FROM dbo.DIM_LOCATION AS A
INNER JOIN dbo.FACT_TRANSACTIONS AS B ON A.IDLocation = B.IDLocation
INNER JOIN dbo.DIM_MODEL AS C ON B.IDModel = C.IDModel
WHERE Date BETWEEN '2005' AND GETDATE();


--Q1--END

--Q2--BEGIN
SELECT TOP 1 STATE FROM dbo.DIM_LOCATION AS A	
INNER JOIN dbo.FACT_TRANSACTIONS AS B ON A.IDLocation = B.IDLocation
INNER JOIN dbo.DIM_MODEL AS C ON B.IDModel = C.IDModel
INNER JOIN dbo.DIM_MANUFACTURER AS D ON C.IDManufacturer = D.IDManufacturer
WHERE Manufacturer_Name = 'Samsung' AND Country = 'US'
GROUP BY STATE
ORDER BY SUM(QUANTITY) DESC;



--Q2--END

--Q3--BEGIN      
SELECT MODEL_NAME, ZIPCODE, STATE, COUNT(IDCUSTOMER) AS NO_OF_TRANS FROM dbo.DIM_LOCATION AS A	
INNER JOIN dbo.FACT_TRANSACTIONS AS B ON A.IDLocation = B.IDLocation
INNER JOIN dbo.DIM_MODEL AS C ON B.IDModel = C.IDModel
GROUP BY Model_Name, ZipCode,STATE;







--Q3--END

--Q4--BEGIN
SELECT TOP 1 IDMODEL, MODEL_NAME, Unit_price FROM dbo.DIM_MODEL
ORDER BY Unit_price                                        





--Q4--END

--Q5--BEGIN
SELECT TOP 5 MODEL_NAME, AVG(UNIT_PRICE) AS AVG_PRICE FROM DIM_MODEL AS A
INNER JOIN DIM_MANUFACTURER AS B ON A.IDManufacturer = B.IDManufacturer
WHERE Manufacturer_Name IN
(
SELECT TOP 5 Manufacturer_Name FROM FACT_TRANSACTIONS AS C
INNER JOIN DIM_MODEL ON A.IDModel= C.IDModel
INNER JOIN DIM_MANUFACTURER ON B.IDManufacturer = A.IDManufacturer
GROUP BY Manufacturer_Name
ORDER BY SUM(QUANTITY)                                        
)
GROUP BY Model_Name
ORDER BY AVG(UNIT_PRICE) DESC


--Q5--END

--Q6--BEGIN
SELECT CUSTOMER_NAME ,  AVG(TOTALPRICE) AS AVG_AMOUNT_SPENT FROM DIM_CUSTOMER AS A
INNER JOIN FACT_TRANSACTIONS AS B ON A.IDCustomer = B.IDCustomer
INNER JOIN DIM_DATE AS C ON B.Date = C.DATE
WHERE YEAR = '2009'
GROUP BY Customer_Name
HAVING AVG(TotalPrice) >500;







--Q6--END
	
--Q7--BEGIN  

(SELECT TOP 5 MODEL_NAME, DATEPART(YEAR,DATE) AS YEAR, SUM(Quantity) AS QUANTITY FROM dbo.FACT_TRANSACTIONS AS A	
INNER JOIN dbo.DIM_MODEL AS B ON A.IDModel = B.IDModel
WHERE DATEPART(YEAR,DATE) = '2008' 
GROUP BY Model_Name, DATEPART(YEAR,DATE)
UNION
SELECT TOP 5 MODEL_NAME, DATEPART(YEAR,DATE) AS YEAR, SUM(Quantity) AS QUANTITY FROM dbo.FACT_TRANSACTIONS AS A
INNER JOIN dbo.DIM_MODEL AS B ON A.IDModel = B.IDModel
WHERE  DATEPART(YEAR,DATE) = '2009' 
GROUP BY Model_Name, DATEPART(YEAR,DATE)
UNION
SELECT TOP 5 MODEL_NAME, DATEPART(YEAR,DATE) AS YEAR, SUM(Quantity) AS QUANTITY FROM dbo.FACT_TRANSACTIONS AS A	
INNER JOIN dbo.DIM_MODEL AS B ON A.IDModel = B.IDModel
WHERE  DATEPART(YEAR,DATE) = '2010' 
GROUP BY Model_Name, DATEPART(YEAR,DATE))
ORDER BY QUANTITY DESC;









--Q7--END	
--Q8--BEGIN
SELECT TOP 1 * FROM
(SELECT TOP 2 MANUFACTURER_NAME, SUM(TotalPrice) Q1 FROM FACT_TRANSACTIONS T1
LEFT JOIN DIM_MODEL D1 ON T1.IDModel = D1.IDModel
LEFT JOIN DIM_MANUFACTURER D2 ON D2.IDManufacturer =D1.IDManufacturer
WHERE DATEPART(YEAR, Date) = '2009'
GROUP BY Manufacturer_Name , TotalPrice
ORDER BY SUM(TotalPrice) DESC) AS A,
(SELECT TOP 2 MANUFACTURER_NAME, SUM(TotalPrice) Q2 FROM FACT_TRANSACTIONS T2
LEFT JOIN DIM_MODEL D3 ON T2.IDModel = D3.IDModel
LEFT JOIN DIM_MANUFACTURER D4 ON D3.IDManufacturer = D4.IDManufacturer
WHERE DATEPART(YEAR, Date) = '2010'
GROUP BY Manufacturer_Name , TotalPrice
ORDER BY SUM(TotalPrice) DESC) AS B


--Q8--END
--Q9--BEGIN
SELECT MANUFACTURER_NAME FROM DIM_MANUFACTURER AS A
INNER JOIN DIM_MODEL AS B ON A.IDManufacturer = B.IDManufacturer
INNER JOIN FACT_TRANSACTIONS AS C ON B.IDModel = C.IDModel
INNER JOIN DIM_DATE AS D ON C.Date = D.DATE
WHERE YEAR = 2010

EXCEPT
SELECT MANUFACTURER_NAME FROM DIM_MANUFACTURER AS A
INNER JOIN DIM_MODEL AS B ON A.IDManufacturer = B.IDManufacturer
INNER JOIN FACT_TRANSACTIONS AS C ON B.IDModel = C.IDModel
WHERE YEAR(DATE) = 2009












--Q9--END

--Q10--BEGIN
SELECT T1.CUSTOMER_NAME,
SUM(CASE WHEN T1.YEAR = 2003 THEN T1.AVERAGE_SPEND END)*100/(SELECT SUM(ONE.T2) FROM (SELECT AVG(TOTALPRICE) T2 , YEAR(DATE) AS [YEAR]
FROM DIM_CUSTOMER C
INNER JOIN FACT_TRANSACTIONS T ON C.IDCustomer = T.IDCustomer
GROUP BY Customer_Name,YEAR(DATE)) ONE WHERE ONE.YEAR = 2003) AS SPEND_2003,

SUM(CASE WHEN T1.YEAR = 2004 THEN T1.AVERAGE_SPEND END)*100/(SELECT SUM(TWO.T2) FROM (SELECT AVG(TOTALPRICE) T2 , YEAR(DATE) AS [YEAR]
FROM DIM_CUSTOMER C
INNER JOIN FACT_TRANSACTIONS T ON C.IDCustomer = T.IDCustomer
GROUP BY Customer_Name,YEAR(DATE)) TWO WHERE TWO.YEAR = 2004) AS SPEND_2004,

SUM(CASE WHEN T1.YEAR = 2005 THEN T1.AVERAGE_SPEND END)*100/(SELECT SUM(THREE.T2) FROM (SELECT AVG(TOTALPRICE) T2 , YEAR(DATE) AS [YEAR]
FROM DIM_CUSTOMER C
INNER JOIN FACT_TRANSACTIONS T ON C.IDCustomer = T.IDCustomer
GROUP BY Customer_Name,YEAR(DATE)) THREE WHERE THREE.YEAR = 2005) AS SPEND_2005,

SUM(CASE WHEN T1.YEAR = 2006 THEN T1.AVERAGE_SPEND END)*100/(SELECT SUM(FOUR.T2) FROM (SELECT AVG(TOTALPRICE) T2 , YEAR(DATE) AS [YEAR]
FROM DIM_CUSTOMER C
INNER JOIN FACT_TRANSACTIONS T ON C.IDCustomer = T.IDCustomer
GROUP BY Customer_Name,YEAR(DATE)) FOUR WHERE FOUR.YEAR = 2006) AS SPEND_2006,

SUM(CASE WHEN T1.YEAR = 2007 THEN T1.AVERAGE_SPEND END)*100/(SELECT SUM(FIVE.T2) FROM (SELECT AVG(TOTALPRICE) T2 , YEAR(DATE) AS [YEAR]
FROM DIM_CUSTOMER C
INNER JOIN FACT_TRANSACTIONS T ON C.IDCustomer = T.IDCustomer
GROUP BY Customer_Name,YEAR(DATE)) FIVE WHERE FIVE.YEAR = 2007) AS SPEND_2007,


SUM(CASE WHEN T1.YEAR = 2008 THEN T1.AVERAGE_SPEND END)*100/(SELECT SUM(SIX.T2) FROM (SELECT AVG(TOTALPRICE) T2 , YEAR(DATE) AS [YEAR]
FROM DIM_CUSTOMER C
INNER JOIN FACT_TRANSACTIONS T ON C.IDCustomer = T.IDCustomer
GROUP BY Customer_Name,YEAR(DATE)) SIX WHERE SIX.YEAR = 2008) AS SPEND_2008,

SUM(CASE WHEN T1.YEAR = 2009 THEN T1.AVERAGE_SPEND END)*100/(SELECT SUM(SEVEN.T2) FROM (SELECT AVG(TOTALPRICE) T2 , YEAR(DATE) AS [YEAR]
FROM DIM_CUSTOMER C
INNER JOIN FACT_TRANSACTIONS T ON C.IDCustomer = T.IDCustomer
GROUP BY Customer_Name,YEAR(DATE)) SEVEN WHERE SEVEN.YEAR = 2009) AS SPEND_2009,

SUM(CASE WHEN T1.YEAR = 2010 THEN T1.AVERAGE_SPEND END)*100/(SELECT SUM(EIGHT.T2) FROM (SELECT AVG(TOTALPRICE) T2 , YEAR(DATE) AS [YEAR]
FROM DIM_CUSTOMER C
INNER JOIN FACT_TRANSACTIONS T ON C.IDCustomer = T.IDCustomer
GROUP BY Customer_Name,YEAR(DATE)) EIGHT WHERE EIGHT.YEAR = 2010) AS SPEND_2010

FROM(
SELECT TOP 100 CUSTOMER_NAME , AVG(TOTALPRICE) AS AVERAGE_SPEND, AVG(QUANTITY) AS AVG_QTY , YEAR(DATE) AS [YEAR] 
FROM DIM_CUSTOMER C
INNER JOIN FACT_TRANSACTIONS T ON C.IDCustomer = T.IDCustomer
GROUP BY Customer_Name , YEAR(DATE)
)T1
GROUP BY T1.Customer_Name , T1.AVERAGE_SPEND , AVG_QTY, [YEAR]
ORDER BY AVERAGE_SPEND DESC



 

--Q10--END
	