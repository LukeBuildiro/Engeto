SELECT
	value,
	industry_branch_code,
	payroll_year,
	payroll_quarter,
	cpib.name,
(value/(SELECT
	AVG (value)
	FROM czechia_payroll cp1
	WHERE industry_branch_code = cp.industry_branch_code
	AND payroll_year = cp.payroll_year -1
	GROUP BY payroll_year)) AS prev_year
FROM
	czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib 
ON
	cp.industry_branch_code = cpib.code
WHERE
	1 = 1
	AND value IS NOT null
	AND value_type_code != 316
ORDER BY
	payroll_year ASC,
	payroll_quarter ASC;


-- 2017-11-13 00:00:00.000, 112201
-- mleko 114201
-- chleba 111301
-- null mleko 20.35

SELECT
	AVG(value)
FROM
	czechia_price cp
WHERE
	1 = 1
	AND 114201 = cp.category_code
	AND "2017-11-13 00:00:00.000" = cp.date_from
	AND region_code IS NOT null;


SELECT
	AVG(value)
FROM
	czechia_price cp
WHERE
	1 = 1
	AND 114201 = cp.category_code
	AND date_from >= "2006-01-01"
	AND date_to <= "2007-01-01"
	AND region_code IS null;

-- avg.value of milk in 2006 = 14.44 Kc/l


SELECT
	AVG(value),
	payroll_year,
	cpib.name,
	FLOOR (AVG(value)/(
	SELECT
		AVG(value)
	FROM
		czechia_price cp
	WHERE
		1 = 1
		AND 114201 = cp.category_code
		AND date_from >= "2006-01-01"
		AND date_to <= "2007-01-01"
		AND region_code IS null
	LIMIT 1)) AS milks_per_salary,
	FLOOR (AVG(value)/(
	SELECT
		AVG(value)
	FROM
		czechia_price cp
	WHERE
		1 = 1
		AND 111301 = cp.category_code
		AND date_from >= "2006-01-01"
		AND date_to <= "2007-01-01"
		AND region_code IS null
	LIMIT 1)) AS breads_per_salary
FROM
	czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib 
ON
	cp.industry_branch_code = cpib.code
WHERE
	1 = 1
	AND value IS NOT null
	AND value_type_code != 316
	AND (payroll_year = 2006)
GROUP BY
	payroll_year,
	cpib.name
ORDER BY
	milks_per_salary ASC;


-- 3. ukol


SELECT
	(cur.value / prev.value)* 100-100 AS ratio,
	cur.category_code,
	CONCAT(cur.Y, ' / ', prev.Y),
	cpc.name
FROM
	(
	SELECT
		category_code,
		AVG (value) AS value,
		YEAR (date_from) AS Y
	FROM
		czechia_price cp
	GROUP BY
		YEAR (date_from),
		category_code
	ORDER BY
		YEAR (date_from),
		category_code) AS cur
JOIN 
(
	SELECT
		category_code,
		AVG (value) AS value,
		YEAR (date_from) AS Y
	FROM
		czechia_price cp
	GROUP BY
		YEAR (date_from),
		category_code
	ORDER BY
		YEAR (date_from),
		category_code) AS prev 
ON
	cur.Y-1 = prev.Y
	AND cur.category_code = prev.category_code
JOIN czechia_price_category cpc
ON
	cur.category_code = cpc.code 


SELECT
	AVG ((cur.value / prev.value)* 100-100) AS ratio,
	cur.category_code,
	cpc.name
FROM
	(
	SELECT
		category_code,
		AVG (value) AS value,
		YEAR (date_from) AS Y
	FROM
		czechia_price cp
	GROUP BY
		YEAR (date_from),
		category_code
	ORDER BY
		YEAR (date_from),
		category_code) AS cur
JOIN 
(
	SELECT
		category_code,
		AVG (value) AS value,
		YEAR (date_from) AS Y
	FROM
		czechia_price cp
	GROUP BY
		YEAR (date_from),
		category_code
	ORDER BY
		YEAR (date_from),
		category_code) AS prev 
ON
	cur.Y-1 = prev.Y
	AND cur.category_code = prev.category_code
JOIN czechia_price_category cpc
ON
	cur.category_code = cpc.code
GROUP BY
	cur.category_code,
	cpc.name
ORDER BY
	ratio ASC 
	
	
-- 4. ukol
	
SELECT FORMAT(AVG (value),2), YEAR (date_from) 
FROM czechia_price cp 
WHERE region_code IS NULL
GROUP BY
	YEAR (date_from) 
ORDER BY 
	YEAR (date_from);


-- check food values

SELECT COUNT(value)  
FROM czechia_price cp 
WHERE region_code IS NULL 
AND YEAR (date_from) = 2006


SELECT SUM(value)  
FROM czechia_price cp 
WHERE region_code IS NULL 
AND YEAR (date_from) = 2006

SELECT 55911.33000000001/1253;


SELECT
	FORMAT(AVG (value), 2),
	YEAR (date_from),
	FORMAT(AVG (value)/(
	SELECT
		AVG (value)
	FROM
		czechia_price cp2
	WHERE
		region_code IS NULL
	AND YEAR (date_from) = YEAR (cp.date_from)-1
	GROUP BY
		YEAR (date_from)
	LIMIT 1)*100-100,2) AS increase_per_year
FROM
	czechia_price cp
WHERE
	region_code IS NULL
GROUP BY
	YEAR (date_from)
ORDER BY 
	YEAR (date_from)
	
	
-- salaries
	
SELECT
	FORMAT(AVG (value), 2), payroll_year,
	FORMAT(AVG (value)/(
	SELECT
		AVG (value)
	FROM
		czechia_payroll cp2 
	WHERE
		value_type_code = 5958
	AND cp2.payroll_year = cp.payroll_year-1
	GROUP BY
		payroll_year 
	LIMIT 1)*100-100,2) AS increase_per_year
FROM
	czechia_payroll cp 
WHERE
	 value_type_code = 5958
GROUP BY
	payroll_year 
ORDER BY 
	payroll_year
	
-- increase over 10%


SELECT
	food_increase.increase_per_year AS food_inc,
	salary_increase.increase_per_year AS salary_inc,
	payroll_year,
	food_increase.increase_per_year/salary_increase.increase_per_year*100-100 AS avg_percentage_increase
FROM
	(
	SELECT
		AVG (value),
		YEAR (date_from) AS years,
		AVG (value)/(
	SELECT
		AVG (value)
	FROM
		czechia_price cp2
	WHERE
		region_code IS NULL
	AND YEAR (date_from) = YEAR (cp.date_from)-1
	GROUP BY
		YEAR (date_from)
	LIMIT 1)* 100-100 AS increase_per_year
	FROM
		czechia_price cp
	WHERE
		region_code IS NULL
	GROUP BY
		YEAR (date_from)
	ORDER BY
		YEAR (date_from)) AS food_increase
JOIN	
(
	SELECT
		AVG (value),
		payroll_year,
		AVG (value)/(
	SELECT
		AVG (value)
	FROM
		czechia_payroll cp2 
	WHERE
		value_type_code = 5958
	AND cp2.payroll_year = cp.payroll_year-1
	GROUP BY
		payroll_year 
	LIMIT 1)* 100-100 AS increase_per_year
	FROM
		czechia_payroll cp
	WHERE
		value_type_code = 5958
	GROUP BY
		payroll_year
	ORDER BY
		payroll_year) AS salary_increase
ON
	food_increase.years = salary_increase.payroll_year;




	
==== 5.ukol

SELECT
	food_increase.increase_per_year AS food_inc,
	salary_increase.increase_per_year AS salary_inc,
	payroll_year,
	food_increase.increase_per_year / salary_increase.increase_per_year * 100-100 AS avg_percentage_increase,
	hdp,
	hdp_perc_increase
FROM
	(
	SELECT
		AVG (value),
		YEAR (date_from) AS years,
		AVG (value)/(
		SELECT
			AVG (value)
		FROM
			czechia_price cp2
		WHERE
			region_code IS NULL
			AND YEAR (date_from) = YEAR (cp.date_from)-1
		GROUP BY
			YEAR (date_from)
		LIMIT 1)* 100-100 AS increase_per_year
	FROM
		czechia_price cp
	WHERE
		region_code IS NULL
	GROUP BY
		YEAR (date_from)
	ORDER BY
		YEAR (date_from)) AS food_increase
JOIN	
(
	SELECT
		AVG (value),
		payroll_year,
		AVG (value)/(
		SELECT
			AVG (value)
		FROM
			czechia_payroll cp2
		WHERE
			value_type_code = 5958
			AND cp2.payroll_year = cp.payroll_year-1
		GROUP BY
			payroll_year
		LIMIT 1)* 100-100 AS increase_per_year
	FROM
		czechia_payroll cp
	WHERE
		value_type_code = 5958
	GROUP BY
		payroll_year
	ORDER BY
		payroll_year) AS salary_increase
ON
	food_increase.years = salary_increase.payroll_year
JOIN
(
	SELECT
		e.year AS year,
		e.GDP AS hdp,
		e.gdp/(
		SELECT
			hdp AS hdp
		FROM
			economies e2
		WHERE
			country = "Czech Republic"
			AND e.`year` -1 = e2.`year`) AS hdp_perc_increase
	FROM
		economies e
	WHERE
		country = "Czech Republic") AS hdp
ON
	food_increase.years = hdp.year
ORDER BY
	years ASC;









