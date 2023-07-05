------------Bike Sale----------------------------

use Bike_db

Select * from [dbo].[Bike_sale]

--Replacing 10+Miles to 10 Miles and above

UPDATE Bike_sale
SET Commute_Distance = REPLACE(Commute_Distance, '10+ Miles', '10 Miles and above')
WHERE Commute_Distance = '10+ Miles';

--Replacing M and S with Married and Single

UPDATE Bike_sale 
SET Marital_Status = CASE
							WHEN Marital_Status ='M' THEN 'Married'
							WHEN Marital_Status = 'S' THEN 'Single'
							ELSE Marital_Status
					 END
WHERE Marital_Status in('M','S')

--Replacing M and F with Male and Female

UPDATE Bike_sale
SET Gender = CASE
				 WHEN Gender = 'F' THEN 'Female'
			     WHEN Gender = 'M' THEN 'Male'
			 END
WHERE Gender in('F','M')

SELECT Commute_Distance FROM Bike_sale
WHERE Commute_Distance ='10 Miles and above'

--Determine the sales by age range

SELECT Min(Age) AS 'Age range' FROM Bike_sale
SELECT Max(Age) AS 'Age range' FROM Bike_sale

SELECT
	CASE
		WHEN Age >= 25 AND Age <= 32 THEN '25-32'
		WHEN Age > 32 AND Age <= 45 THEN '32-45'
		WHEN Age > 45 AND Age <= 60 THEN '45-60'
		ELSE 'Above 60'
	END AS [Age Range],
	SUM(CASE WHEN Purchased_Bike = 1 THEN 1 ELSE 0 END) AS Total_Sales,
	(SUM(CASE WHEN Purchased_Bike = 1 THEN 1 ELSE 0 END) / CAST(SUM(1) AS FLOAT)) * 100 AS Percentage
FROM
	Bike_sale
GROUP BY
	CASE
		WHEN Age >= 25 AND Age <= 32 THEN '25-32'
		WHEN Age > 32 AND Age <= 45 THEN '32-45'
		WHEN Age > 45 AND Age <= 60 THEN '45-60'
		ELSE 'Above 60'
	END;

--To find out the sum of sales by continents

SELECT
	Region,
	SUM(CASE
			WHEN Purchased_Bike=1 THEN 1
			ELSE 0
		END) AS 'Total Sales'
FROM Bike_sale
	GROUP BY Region

--To find out the commute distance by gender

SELECT Gender,
		SUM(CASE
				WHEN Commute_Distance ='0-1 Miles' THEN 1
				WHEN Commute_Distance ='2-5 Miles' THEN 3
                WHEN Commute_Distance = '5-10 Miles' THEN 7
                WHEN Commute_Distance = '1-2 Miles' THEN 1.5
                WHEN Commute_Distance = '10+ Miles' THEN 10
				ELSE 0
			END) AS 'Commute Distance By Gender'
FROM Bike_sale
              GROUP BY Gender

--To check the trend of purchasing bikes by commute distance

SELECT 
        Commute_Distance,
		SUM(CAST(Purchased_Bike AS INT)) AS 'Purchasing of Commute Distance'
FROM Bike_sale
		WHERE Purchased_Bike =1
GROUP BY Commute_Distance;

--To determine the average income of each gender

SELECT Gender,
		CAST(AVG(Income) AS INT) AS 'Average Income'
FROM Bike_sale
		GROUP BY Gender;

--To calculate the number of sold and unsold bikes

SELECT 
		SUM(CAST(Purchased_Bike AS int)) As 'Sold Bikes',
		SUM(Cast(1-Purchased_Bike AS int)) AS 'Unsold Bikes'
FROM Bike_sale	
				WHERE Purchased_Bike in(0, 1)

--To calculate the bike sales margin for each education profession

SELECT Education,
                SUM(CAST(Purchased_Bike AS int)) AS 'Bikes Sold',
                SUM(CAST(1-Purchased_Bike AS int)) AS 'Bikes Unsold'
FROM Bike_sale   
                WHERE Purchased_Bike in (0, 1)
GROUP BY Education

--To calculate the income of individuals based on their education profession

SELECT Education,
              SUM(Income)  AS 'Total Income'
FROM Bike_sale 
              GROUP BY Education 
ORDER BY [Total Income] Desc;

--Home ownership rates vary by marital status

SELECT
    Marital_Status,
    SUM(CAST(Home_Owner AS INT)) AS Homeowner,
    SUM(CAST(1 - Home_Owner AS INT)) AS Non_Homeowner
FROM
    Bike_sale
WHERE
    Home_Owner IN (0, 1)
GROUP BY
    Marital_Status;

--To figure up the tendency of purchasing bikes based on having cars

SELECT
    Marital_Status,
    Cars,
    SUM(CASE WHEN Purchased_Bike = 1 THEN 1 ELSE 0 END) AS 'Bike Sold',
    SUM(CASE WHEN Purchased_Bike = 0 THEN 1 ELSE 0 END) AS 'Bike Unsold'
FROM
    Bike_sale
GROUP BY
    Marital_Status, Cars
ORDER BY
    Marital_Status, Cars;