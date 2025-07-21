-- CHAPTER 7
-- SQL FUNCTIONS

-- NESTED FUNCTION = Function used inside another function.

-- Single-Row Functions
	-- STRING FUNCTIONS
	-- CONCAT() = Convert multiplr strings into one.
USE MyDatabase

-- Concatenate first name and country into one column.
SELECT 
first_name,
country,
CONCAT(first_name, '-', country) AS name_country
from customers

	-- UPPER() = Converts all characters to uppercase.
	-- LOWER() = Converts all characters to lowercase.
--  Converts first name to lowercase. 
SELECT
first_name,
country,
CONCAT(first_name, '-', country) AS name_country,
LOWER(first_name) AS low_name
from customers

--  Converts first name to uppercase.
SELECT
first_name,
country,
CONCAT(first_name, '-', country) AS name_country,
LOWER(first_name) AS low_name,
UPPER(first_name) AS up_name
from customers

	-- TRIM() = Removes Leading and Trailing spaces.
-- Find customers whose first name contains leading or trailing spaces.
SELECT
	first_name
FROM customers
WHERE first_name != TRIM(first_name)

-- OR

SELECT
	first_name,
	LEN(first_name) AS len_name,
	LEN(TRIM(first_name)) AS len_trim_name,
	LEN(first_name) - LEN(TRIM(first_name)) flag
FROM customers
WHERE LEN(first_name) != LEN(TRIM(first_name))

-- REPLACE = Replaces specific character with a new character.
		-- = Not only Replace but also Remove!.
-- Remove dashes (-) from a phone number.
SELECT
'123-456-7890' AS phone,
REPLACE('123-456-7890', '-', '/') AS clean_phone

-- Replace File Existence from txt to csv.
SELECT 
'report.txt' AS old_filename,
REPLACE ('report.txt','.txt','.csv') AS new_filename

-- CALCULATION
	-- LEN = Counts how many charcaters
-- Calculate the length of each customer's first name.
SELECT
first_name,
LEN(first_name) AS len_name
FROM customers

-- STRING EXTRACTION
	-- LEFT = Extract specific number of characters from the start.
	-- RIGHT = Extract specific number of characters from the end.
-- Retrieve the first two characters of each first name.
SELECT
	first_name,
	LEFT(first_name, 2) AS first_2_char
FROM customers

SELECT
	first_name,
	LEFT(TRIM(first_name), 2) AS first_2_char
FROM customers

-- Retrieve the last two characters of each first name.
SELECT
	first_name,
	LEFT(TRIM(first_name), 2) AS first_2_char,
	RIGHT(first_name, 2) AS last_2_char
FROM customers

	-- SUBSTRING = Extracts a part of string at a specificed position.
-- Retrieve a list of customers'first names removing the first character.
SELECT 
	first_name,
	SUBSTRING(first_name, 2, 4) AS sub_name
FROM customers

SELECT 
	first_name,
	SUBSTRING(first_name, 2, LEN(first_name)) AS sub_name
FROM customers

	-- 2.NUMBER FUNCTIONS
SELECT
3.516,
ROUND(3.516, 2) AS round_2,
ROUND(3.516, 1) AS round_1,
ROUND(3.516, 0) AS round_0

-- ABS (Absolute) = Returns the absolute value of a number, removing sny negstive sign.
SELECT
-10 AS number,
ABS(-10) AS fst_abs_no,
ABS(10) AS scnd_abs_no

	-- 3. DATE & TIME FUNCTIONS
USE SalesDB

SELECT 
OrderID,
OrderDate,
ShipDate,
CreationTime
FROM Sales.Orders

-- VALUES
/* 3 type of Date sources
	- Date Column From a table
	- Hardcoded Costant String value
	- GETDATE() Function = Returns current date and time. */
SELECT 
OrderID,
CreationTime,
'2025-08-20' HardCoded,
GETDATE() Today
FROM Sales.Orders

-- FUNCTIONS OVERVIEW 
-- PART EXTRACTION
	/* DAY = Returns the day from date.
	 MONTH = Returns the month from date.
	 YEAR  = Returns the year from date. */

SELECT 
OrderID,
CreationTime,
YEAR(CreationTime) Year,
MONTH(CreationTime) Month,
DAY(CreationTime) Day
FROM Sales.Orders

	-- DATEPART() = Returns a specific part of a date as a number.
SELECT 
OrderID,
CreationTime,
DATEPART(year, CreationTime) Year_dp,
DATEPART(month, CreationTime) Month_dp,
DATEPART(day, CreationTime) Day_dp,
DATEPART(hour, CreationTime) Hour_dp,
DATEPART(quarter, CreationTime) Quarter_dp,
DATEPART(week, CreationTime) Week_dp,
YEAR(CreationTime) Year,
MONTH(CreationTime) Month,
DAY(CreationTime) Day
FROM Sales.Orders

	-- DATENAME() = Returns the name of a specific part of a date.
SELECT 
OrderID,
CreationTime,
DATENAME(month, CreationTime) Month_dn,
DATENAME(weekday, CreationTime) Weekday_dn,
DATENAME(day, CreationTime) Day_dn,
DATENAME(year, CreationTime) Year_dn
FROM Sales.Orders

-- DATETRUNC() = Truncates the date to the specific part.
SELECT 
OrderID,
CreationTime,
DATETRUNC(year, CreationTime) Year_dt,
DATETRUNC(day, CreationTime) Day_dt,
DATETRUNC(minute, CreationTime) Minute_dt
FROM Sales.Orders

SELECT 
DATETRUNC(month, CreationTime) Creation,
COUNT(*)
FROM sales.Orders
GROUP BY DATETRUNC(month, CreationTime)

SELECT 
DATETRUNC(year, CreationTime) Creation,
COUNT(*)
FROM sales.Orders
GROUP BY DATETRUNC(year, CreationTime)

-- EOMONTH = Returns the last day of a month.
SELECT
OrderID,
CreationTime,
EOMONTH(CreationTime) EndOfMonth,
DATETRUNC(month, CreationTime) StartOfMonth
FROM sales.Orders

-- How many orders were placed each year?
SELECT
YEAR(OrderDate),
COUNT(*) NrOfOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate)

-- How many orders were placed each month?
SELECT
DATENAME(month, OrderDate) AS OrderDate,
COUNT(*) NrOfOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate)

-- DATA FILTERING 
-- Show all orders that were placed during the month of February.
SELECT
* 
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2

-- All possible parts can be used in DATEPART SQL FUNCTION

SELECT 
    'Year' AS DatePart, 
    DATEPART(year, GETDATE()) AS DatePart_Output,
    DATENAME(year, GETDATE()) AS DateName_Output,
    DATETRUNC(year, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'YY', 
    DATEPART(yy, GETDATE()) AS DatePart_Output,
    DATENAME(yy, GETDATE()) AS DateName_Output, 
    DATETRUNC(yy, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'YYYY', 
    DATEPART(yyyy, GETDATE()) AS DatePart_Output,
    DATENAME(yyyy, GETDATE()) AS DateName_Output, 
    DATETRUNC(yyyy, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'Quarter', 
    DATEPART(quarter, GETDATE()) AS DatePart_Output,
    DATENAME(quarter, GETDATE()) AS DateName_Output, 
    DATETRUNC(quarter, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'QQ', 
    DATEPART(qq, GETDATE()) AS DatePart_Output,
    DATENAME(qq, GETDATE()) AS DateName_Output, 
    DATETRUNC(qq, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'Q', 
    DATEPART(q, GETDATE()) AS DatePart_Output,
    DATENAME(q, GETDATE()) AS DateName_Output, 
    DATETRUNC(q, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'Month', 
    DATEPART(month, GETDATE()) AS DatePart_Output,
    DATENAME(month, GETDATE()) AS DateName_Output, 
    DATETRUNC(month, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'MM', 
    DATEPART(mm, GETDATE()) AS DatePart_Output,
    DATENAME(mm, GETDATE()) AS DateName_Output, 
    DATETRUNC(mm, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'M', 
    DATEPART(m, GETDATE()) AS DatePart_Output,
    DATENAME(m, GETDATE()) AS DateName_Output, 
    DATETRUNC(m, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'DayOfYear', 
    DATEPART(dayofyear, GETDATE()) AS DatePart_Output,
    DATENAME(dayofyear, GETDATE()) AS DateName_Output, 
    DATETRUNC(dayofyear, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'DY', 
    DATEPART(dy, GETDATE()) AS DatePart_Output,
    DATENAME(dy, GETDATE()) AS DateName_Output, 
    DATETRUNC(dy, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'Y', 
    DATEPART(y, GETDATE()) AS DatePart_Output,
    DATENAME(y, GETDATE()) AS DateName_Output, 
    DATETRUNC(y, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'Day', 
    DATEPART(day, GETDATE()) AS DatePart_Output,
    DATENAME(day, GETDATE()) AS DateName_Output, 
    DATETRUNC(day, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'DD', 
    DATEPART(dd, GETDATE()) AS DatePart_Output,
    DATENAME(dd, GETDATE()) AS DateName_Output, 
    DATETRUNC(dd, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'D', 
    DATEPART(d, GETDATE()) AS DatePart_Output,
    DATENAME(d, GETDATE()) AS DateName_Output, 
    DATETRUNC(d, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'Week', 
    DATEPART(week, GETDATE()) AS DatePart_Output,
    DATENAME(week, GETDATE()) AS DateName_Output, 
    DATETRUNC(week, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'WK', 
    DATEPART(wk, GETDATE()) AS DatePart_Output,
    DATENAME(wk, GETDATE()) AS DateName_Output, 
    DATETRUNC(wk, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'WW', 
    DATEPART(ww, GETDATE()) AS DatePart_Output,
    DATENAME(ww, GETDATE()) AS DateName_Output, 
    DATETRUNC(ww, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'Weekday', 
    DATEPART(weekday, GETDATE()) AS DatePart_Output,
    DATENAME(weekday, GETDATE()) AS DateName_Output, 
    NULL AS DateTrunc_Output
UNION ALL
SELECT 
    'DW', 
    DATEPART(dw, GETDATE()) AS DatePart_Output,
    DATENAME(dw, GETDATE()) AS DateName_Output, 
    NULL AS DateTrunc_Output
UNION ALL
SELECT 
    'Hour', 
    DATEPART(hour, GETDATE()) AS DatePart_Output,
    DATENAME(hour, GETDATE()) AS DateName_Output, 
    DATETRUNC(hour, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'HH', 
    DATEPART(hh, GETDATE()) AS DatePart_Output,
    DATENAME(hh, GETDATE()) AS DateName_Output, 
    DATETRUNC(hh, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'Minute', 
    DATEPART(minute, GETDATE()) AS DatePart_Output,
    DATENAME(minute, GETDATE()) AS DateName_Output, 
    DATETRUNC(minute, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'MI', 
    DATEPART(mi, GETDATE()) AS DatePart_Output,
    DATENAME(mi, GETDATE()) AS DateName_Output, 
    DATETRUNC(mi, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'N', 
    DATEPART(n, GETDATE()) AS DatePart_Output,
    DATENAME(n, GETDATE()) AS DateName_Output, 
    DATETRUNC(n, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'Second', 
    DATEPART(second, GETDATE()) AS DatePart_Output,
    DATENAME(second, GETDATE()) AS DateName_Output, 
    DATETRUNC(second, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'SS', 
    DATEPART(ss, GETDATE()) AS DatePart_Output,
    DATENAME(ss, GETDATE()) AS DateName_Output, 
    DATETRUNC(ss, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'S', 
    DATEPART(s, GETDATE()) AS DatePart_Output,
    DATENAME(s, GETDATE()) AS DateName_Output, 
    DATETRUNC(s, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'Millisecond', 
    DATEPART(millisecond, GETDATE()) AS DatePart_Output,
    DATENAME(millisecond, GETDATE()) AS DateName_Output, 
    DATETRUNC(millisecond, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'MS', 
    DATEPART(ms, GETDATE()) AS DatePart_Output,
    DATENAME(ms, GETDATE()) AS DateName_Output, 
    DATETRUNC(ms, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'Microsecond', 
    DATEPART(microsecond, GETDATE()) AS DatePart_Output,
    DATENAME(microsecond, GETDATE()) AS DateName_Output, 
    NULL AS DateTrunc_Output
UNION ALL
SELECT 
    'MCS', 
    DATEPART(mcs, GETDATE()) AS DatePart_Output,
    DATENAME(mcs, GETDATE()) AS DateName_Output, 
    NULL AS DateTrunc_Output
UNION ALL
SELECT 
    'Nanosecond', 
    DATEPART(nanosecond, GETDATE()) AS DatePart_Output,
    DATENAME(nanosecond, GETDATE()) AS DateName_Output, 
    NULL AS DateTrunc_Output
UNION ALL
SELECT 
    'NS', 
    DATEPART(ns, GETDATE()) AS DatePart_Output,
    DATENAME(ns, GETDATE()) AS DateName_Output, 
    NULL AS DateTrunc_Output
UNION ALL
SELECT 
    'ISOWeek', 
    DATEPART(iso_week, GETDATE()) AS DatePart_Output,
    DATENAME(iso_week, GETDATE()) AS DateName_Output, 
    DATETRUNC(iso_week, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'ISOWK', 
    DATEPART(isowk, GETDATE()) AS DatePart_Output,
    DATENAME(isowk, GETDATE()) AS DateName_Output, 
    DATETRUNC(isowk, GETDATE()) AS DateTrunc_Output
UNION ALL
SELECT 
    'ISOWW', 
    DATEPART(isoww, GETDATE()) AS DatePart_Output,
    DATENAME(isoww, GETDATE()) AS DateName_Output, 
    DATETRUNC(isoww, GETDATE()) AS DateTrunc_Output;

-- FROMAT = Changing format of a value from one to another.
-- CASTING = Chnaging data type from one to another.

-- Format CreationTime into various string representations.
SELECT
OrderID,
CreationTime,
FORMAT(CreationTime,'MM-dd-yyyy') USA_Format,
FORMAT(CreationTime,'MM-dd-yyyy') EURO_Format,
FORMAT(CreationTime,'dd') dd,
FORMAT(CreationTime,'ddd') ddd,
FORMAT(CreationTime,'dddd') dddd,
FORMAT(CreationTime,'MM') MM,
FORMAT(CreationTime,'MMM') MMM,
FORMAT(CreationTime,'MMMM') MMMM
FROM Sales.Orders

-- Display CreationTime using a custom format: Example: Day Wed Jan Q1 2025 12:34:56 PM
SELECT 
OrderID,
CreationTime,
'Day'+ FORMAT(CreationTime, 'ddd MMM') + 
'Q' + DATENAME(quarter, CreationTime) + ' ' +
FORMAT(CreationTime, 'yyyy hh:mm:ss')  AS CustomeFormat
FROM Sales.Orders

SELECT
FORMAT(OrderDate, 'MMM yy') OrderDate,
COUNT(*)
FROM  Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy')


-- All Date Format
SELECT 
    'D' AS FormatType, 
    FORMAT(GETDATE(), 'D') AS FormattedValue,
    'Full date pattern' AS Description
UNION ALL
SELECT 
    'd', 
    FORMAT(GETDATE(), 'd'), 
    'Short date pattern'
UNION ALL
SELECT 
    'dd', 
    FORMAT(GETDATE(), 'dd'), 
    'Day of month with leading zero'
UNION ALL
SELECT 
    'ddd', 
    FORMAT(GETDATE(), 'ddd'), 
    'Abbreviated name of day'
UNION ALL
SELECT 
    'dddd', 
    FORMAT(GETDATE(), 'dddd'), 
    'Full name of day'
UNION ALL
SELECT 
    'M', 
    FORMAT(GETDATE(), 'M'), 
    'Month without leading zero'
UNION ALL
SELECT 
    'MM', 
    FORMAT(GETDATE(), 'MM'), 
    'Month with leading zero'
UNION ALL
SELECT 
    'MMM', 
    FORMAT(GETDATE(), 'MMM'), 
    'Abbreviated name of month'
UNION ALL
SELECT 
    'MMMM', 
    FORMAT(GETDATE(), 'MMMM'), 
    'Full name of month'
UNION ALL
SELECT 
    'yy', 
    FORMAT(GETDATE(), 'yy'), 
    'Two-digit year'
UNION ALL
SELECT 
    'yyyy', 
    FORMAT(GETDATE(), 'yyyy'), 
    'Four-digit year'
UNION ALL
SELECT 
    'hh', 
    FORMAT(GETDATE(), 'hh'), 
    'Hour in 12-hour clock with leading zero'
UNION ALL
SELECT 
    'HH', 
    FORMAT(GETDATE(), 'HH'), 
    'Hour in 24-hour clock with leading zero'
UNION ALL
SELECT 
    'm', 
    FORMAT(GETDATE(), 'm'), 
    'Minutes without leading zero'
UNION ALL
SELECT 
    'mm', 
    FORMAT(GETDATE(), 'mm'), 
    'Minutes with leading zero'
UNION ALL
SELECT 
    's', 
    FORMAT(GETDATE(), 's'), 
    'Seconds without leading zero'
UNION ALL
SELECT 
    'ss', 
    FORMAT(GETDATE(), 'ss'), 
    'Seconds with leading zero'
UNION ALL
SELECT 
    'f', 
    FORMAT(GETDATE(), 'f'), 
    'Tenths of a second'
UNION ALL
SELECT 
    'ff', 
    FORMAT(GETDATE(), 'ff'), 
    'Hundredths of a second'
UNION ALL
SELECT 
    'fff', 
    FORMAT(GETDATE(), 'fff'), 
    'Milliseconds'
UNION ALL
SELECT 
    'T', 
    FORMAT(GETDATE(), 'T'), 
    'Full AM/PM designator'
UNION ALL
SELECT 
    't', 
    FORMAT(GETDATE(), 't'), 
    'Single character AM/PM designator'
UNION ALL
SELECT 
    'tt', 
    FORMAT(GETDATE(), 'tt'), 
    'Two character AM/PM designator';

-- All Number Format
SELECT 'N' AS FormatType, FORMAT(1234.56, 'N') AS FormattedValue
UNION ALL
SELECT 'P' AS FormatType, FORMAT(1234.56, 'P') AS FormattedValue
UNION ALL
SELECT 'C' AS FormatType, FORMAT(1234.56, 'C') AS FormattedValue
UNION ALL
SELECT 'E' AS FormatType, FORMAT(1234.56, 'E') AS FormattedValue
UNION ALL
SELECT 'F' AS FormatType, FORMAT(1234.56, 'F') AS FormattedValue
UNION ALL
SELECT 'N0' AS FormatType, FORMAT(1234.56, 'N0') AS FormattedValue
UNION ALL
SELECT 'N1' AS FormatType, FORMAT(1234.56, 'N1') AS FormattedValue
UNION ALL
SELECT 'N2' AS FormatType, FORMAT(1234.56, 'N2') AS FormattedValue
UNION ALL
SELECT 'N_de-DE' AS FormatType, FORMAT(1234.56, 'N', 'de-DE') AS FormattedValue
UNION ALL
SELECT 'N_en-US' AS FormatType, FORMAT(1234.56, 'N', 'en-US') AS FormattedValue;

-- CONVERT
SELECT 
CreationTime,
CONVERT(DATE,CreationTime) AS [Datetime to Date CONVERT],
CONVERT(VARCHAR,CreationTime, 32) AS [USA Std. Style:32],
CONVERT(VARCHAR,CreationTime, 34) AS [EURO Std.Style:34]
FROM Sales.Orders

-- CULTURE CODE FORMATTING USING FORMAT()

SELECT 
    'en-US' AS CultureCode,
    FORMAT(1234567.89, 'N', 'en-US') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'en-US') AS FormattedDate
UNION ALL
SELECT 
    'en-GB' AS CultureCode,
    FORMAT(1234567.89, 'N', 'en-GB') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'en-GB') AS FormattedDate
UNION ALL
SELECT 
    'fr-FR' AS CultureCode,
    FORMAT(1234567.89, 'N', 'fr-FR') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'fr-FR') AS FormattedDate
UNION ALL
SELECT 
    'de-DE' AS CultureCode,
    FORMAT(1234567.89, 'N', 'de-DE') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'de-DE') AS FormattedDate
UNION ALL
SELECT 
    'es-ES' AS CultureCode,
    FORMAT(1234567.89, 'N', 'es-ES') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'es-ES') AS FormattedDate
UNION ALL
SELECT 
    'zh-CN' AS CultureCode,
    FORMAT(1234567.89, 'N', 'zh-CN') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'zh-CN') AS FormattedDate
UNION ALL
SELECT 
    'ja-JP' AS CultureCode,
    FORMAT(1234567.89, 'N', 'ja-JP') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'ja-JP') AS FormattedDate
UNION ALL
SELECT 
    'ko-KR' AS CultureCode,
    FORMAT(1234567.89, 'N', 'ko-KR') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'ko-KR') AS FormattedDate
UNION ALL
SELECT 
    'pt-BR' AS CultureCode,
    FORMAT(1234567.89, 'N', 'pt-BR') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'pt-BR') AS FormattedDate
UNION ALL
SELECT 
    'it-IT' AS CultureCode,
    FORMAT(1234567.89, 'N', 'it-IT') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'it-IT') AS FormattedDate
UNION ALL
SELECT 
    'nl-NL' AS CultureCode,
    FORMAT(1234567.89, 'N', 'nl-NL') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'nl-NL') AS FormattedDate
UNION ALL
SELECT 
    'ru-RU' AS CultureCode,
    FORMAT(1234567.89, 'N', 'ru-RU') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'ru-RU') AS FormattedDate
UNION ALL
SELECT 
    'ar-SA' AS CultureCode,
    FORMAT(1234567.89, 'N', 'ar-SA') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'ar-SA') AS FormattedDate
UNION ALL
SELECT 
    'el-GR' AS CultureCode,
    FORMAT(1234567.89, 'N', 'el-GR') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'el-GR') AS FormattedDate
UNION ALL
SELECT 
    'tr-TR' AS CultureCode,
    FORMAT(1234567.89, 'N', 'tr-TR') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'tr-TR') AS FormattedDate
UNION ALL
SELECT 
    'he-IL' AS CultureCode,
    FORMAT(1234567.89, 'N', 'he-IL') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'he-IL') AS FormattedDate
UNION ALL
SELECT 
    'hi-IN' AS CultureCode,
    FORMAT(1234567.89, 'N', 'hi-IN') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'hi-IN') AS FormattedDate;

-- CAST() = Converts a value to a Specified data types.
SELECT 
CAST('123' AS INT) AS [String to Int],
CAST(123 AS VARCHAR) AS [Int to String],
CAST('2025-08-20' AS DATE) AS [String to Date],
CAST('2025-08-20' AS DATETIME2) AS [String to Datetime],
CreationTime,
CAST(CreationTime AS DATE) AS [Datetime to Date]
FROM Sales.Orders

-- CALCULATIONS
-- DATEADD() = Adds or substracts a specific time interval to/from a date.

SELECT
OrderID,
OrderDate,
DATEADD(day, -10,OrderDate) AS TenDaysBefore,
DATEADD(month, 3,OrderDate) AS ThreeMonthsLater,
DATEADD(year, 2, OrderDate) AS TwoYearsLater
FROM Sales.Orders

-- DATEDIFF() = Find the difference between two dates.
-- Calculate the age of employees.
SELECT 
EmployeeID,
BirthDate,
DATEDIFF(year, BirthDate, GETDATE()) Age
FROM Sales.Employees

-- Find the average shipping duration in days for each month.
SELECT 
OrderId,
OrderDate,
ShipDate
FROM Sales.Orders

SELECT 
MONTH(OrderDate) AS OrderDate,
AVG(DATEDIFF(day, OrderDate, ShipDate)) AvgShip
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

-- Time gap Analysis
-- Find the number of days between each order and previous order.
SELECT
OrderID,
OrderDate AS CurrentOrderDate,
LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
DATEDIFF(day,LAG(OrderDate) OVER (ORDER BY OrderDate),OrderDate) NrOfDays
From Sales.Orders

-- VALIDATION
-- ISDATE() = Check if a value is a date.Returns 1 If the string value is a valid date.
SELECT
ISDATE('123') DateCheck1,
ISDATE('2025-08-20') DateCheck2,
ISDATE('20-08-2025') DateCheck3,
ISDATE('2025') DateCheck4,
ISDATE('08') DateCheck5

SELECT
-- CAST(OrderDate as DATE) OrderDate,
    OrderDate,
    ISDATE(OrderDate),
    CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
        ELSE '1999-01-01'
    END NewOrderDate
FROM 
(
SELECT '2025-08-20' AS OrderDate UNION
SELECT '2025-08-21' UNION
SELECT '2025-08-23' UNION
SELECT '2025-08' 
)t
-- WHERE ISDATE(OrderDate) = 0

-- CHAPTER 4 = NULL FUNCTONS
-- ISNULL() = Replaces 'NULL' with a specified value.
-- Syntax = ISNULL(value, replacement_value)
-- Example = ISNULL(Shipping_Address, 'unknown') = Unknown is a default value.
      --   = ISNULL(Shipping_Address, Billing_Address)

-- COALESCE =Returns the first non-null alue from a list.
-- syntax = COALESCE(value1, value2, value3,...)
-- example = COALESCE(Shipping_Address, 'Unknown')
      --   = COALESCE(Shipping_Address,Billing_Address)

USE MyDatabase
USE SalesDB

-- Data Agrregation = USE CASE
-- Find the average score of the customers.
SELECT 
CustomerID,
Score,
COALESCE(Score,0) Score2,
AVG(Score) OVER () avgScores,
AVG(COALESCE(score,0)) OVER() avgScores2
FROM Sales.Customers

-- MATHEMATICAL OPERATIONS = Handle the NULL before doing mathematical Operations
/*Display the full name of customers in a single field 
by merging their first and last names, 
and add 10 bonus points to each customer's score.*/

SELECT 
CustomerID,
FirstName,
LastName,
FirstName + ' ' + COALESCE(LastName, ' ') AS FullName,
Score, 
COALESCE(Score, 0) + 10 AS ScoreWithBonus
FROM Sales.Customers

-- JOINS = Handle the NULL before JOINING Tables.
-- Sort the customers from lowest to highest scores, with NULLS appearing last.
SELECT 
CustomerID,
Score,
COALESCE(Score,999999)
FROM Sales.Customers
ORDER BY COALESCE(Score,999999) -- Lazy Method

SELECT 
CustomerID,
Score,
CASE WHEN Score IS NULL THEN 1 ELSE 0 END Flag
FROM Sales.Customers
ORDER BY COALESCE(Score,999999) -- Professional method

SELECT 
CustomerID,
Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score 

/* NULLIF() = Compares two expressions return:
            - NULL, if they are equal
            - First Value , if they are not equal.*/
-- Syntax  = NULLIF(valuue1, value2)
-- Example = NULLIF(Shipping_Address, 'unknown')
--         = NULLIF(Shipping_Address, Billing_Address)
--         = NULLIF(Price, -1)

-- DIVISION BY ZERO = Preventing the error of dividing by zero.
-- Find the sales price for each order by dividing sales by quantity.
SELECT
OrderID,
Sales,
Quantity,
Sales / NULLIF(Quantity, 0) AS  Price
FROM Sales.Orders

-- IS NULL = Returns True if the values IS NULL, Otherwise it returns FALSE.
-- Syntax  = Value IS NULL
-- Example = Shipping_Address IS NULL

-- IS NOT NULL = Returns True if the values IS NOT NULL, Otherwise it returns FALSE.
-- Syntax  = Value IS NOT NULL
-- Example = Shipping_Address IS NOT NULL

-- FILTERING DATA
-- Identify the customers who have no scores 
SELECT *
FROM Sales.Customers
WHERE Score IS NULL;

-- Identify the customers who have scores 
SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL;

 -- LEFT ANTI JOIN
 -- List all details for customers who have not placed any orders 
SELECT
    c.*,
    o.OrderID
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

--   NULLs vs EMPTY STRING vs BLANK SPACES
-- Demonstrate differences between NULL, empty strings, and blank spaces.
WITH Orders AS (
    SELECT 1 AS Id, 'A' AS Category UNION
    SELECT 2, NULL UNION
    SELECT 3, '' UNION
    SELECT 4, '  '
)
SELECT 
    *,
    DATALENGTH(Category) AS LenCategory,
    TRIM(Category) AS Policy1,
    NULLIF(TRIM(Category), '') AS Policy2,
    COALESCE(NULLIF(TRIM(Category), ''), 'unknown') AS Policy3
FROM Orders;

-- CHAPTER 5
-- CASE STATEMENT = Evaluates alist of conditions and returns a value when the first condition is met.
/* Syntax = CASE
                WHEN condition1 THEN result1
                WHEN condition2 THEN result2
                ...
                ELSE result
            END

example = CASE
               WHEN Sales > 50 THEN 'High'
          END
-- Create a report showing total sales for each category:
	   - High: Sales over 50
	   - Medium: Sales between 21 and 50
	   - Low: Sales 20 or less
   The results are sorted from highest to lowest total sales.*/
SELECT
Category,
SUM(Sales) AS TotalSales
FROM(
SELECT 
OrderID,
Sales,
CASE
    WHEN Sales > 50 THEN 'High'
    WHEN Sales > 20 THEN 'Medium'
    ELSE 'Low'
END Category
FROM Sales.Orders
)t
GROUP BY Category
ORDER BY TotalSales DESC

-- Rules
-- The Datatype of the result must be matching.

-- Mapping Value
-- Mapping = Transform the value from one to another.
-- Retrieve employee details with gender displayed as full text.
SELECT 
EmployeeID,
FirstName,
LastName,
Gender,
CASE
    WHEN Gender = 'F' THEN 'Female'
    WHEN Gender = 'M' THEN 'Male'
    ELSE 'Not Available'
END GenderFullText
FROM Sales.Employees

-- Retrieve customer details with abbreviated country codes 
SELECT
    CustomerID,
    FirstName,
    LastName,
    Country,
    CASE
        WHEN Country = 'Germany' THEN 'DE'
        WHEN Country = 'USA' THEN 'US'
        ELSE 'N/A'
    END CountryAbbr
FROM Sales.Customers;

SELECT DISTINCT Country
FROM Sales.Customers

-- QUICK FORM
-- Retrieve customer details with abbreviated country codes using quick form.
SELECT
    CustomerID,
    FirstName,
    LastName,
    Country,
    CASE Country 
        WHEN  'Germany' THEN 'DE'
        WHEN  'USA' THEN 'US'
        ELSE 'N/A'
    END CountryAbbr2
FROM Sales.Customers;

-- HANDLING NULLS = Replace null with specific value.
-- Nulls can lead to inaccurate results, which can lead to wrong decision-making.
/* Calculate the average score of customers, treating NULL as 0,
   and provide CustomerID and LastName details. */
SELECT 
CustomerID,
LastName,
Score,
CASE 
    WHEN Score IS NULL THEN 0
    ELSE Score
END ScoreClean,
AVG(CASE
        WHEN Score IS NULL THEN 0
        ELSE Score
     END) OVER () AvgCustomerClean,
AVG(Score) OVER() AvgCustomer
FROM Sales.Customers

-- CONDITIONAL AGGREGATION = Apply aggregate function only on substes of data that fulfill certain condition.
-- Count how many orders each customer made with sales greater than 30
SELECT
    CustomerID,
    SUM(CASE
        WHEN Sales > 30 THEN 1
        ELSE 0
    END) TotalOrdersHighSales,
    COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID
