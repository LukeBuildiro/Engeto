SELECT
	value,
	industry_branch_code,
	payroll_year,
	payroll_quarter,
	cpib.name
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

-- Mato

SELECT
	category_code,date_from,
	((SELECT
		value
	FROM
		czechia_price cp2
	WHERE
		date_from <= 
DATE_ADD(cp.date_from, INTERVAL 1 YEAR)
		AND date_to >= 
DATE_ADD(cp.date_from, INTERVAL 1 YEAR)
		AND category_code = cp.category_code
		AND region_code IS NULL
	LIMIT 1)/ value)*100-100 AS ratio
FROM
	czechia_price cp
WHERE
	region_code IS NULL
AND ((SELECT
		value
	FROM
		czechia_price cp2
	WHERE
		date_from <= 
DATE_ADD (cp.date_from, INTERVAL 1 YEAR)
		AND date_to >= 
DATE_ADD(cp.date_from, INTERVAL 1 YEAR)
		AND category_code = cp.category_code
		AND region_code IS NULL
	LIMIT 1)/ value)*100-100 IS NOT NULL
ORDER BY ratio ASC

-- Lukas 


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
	




	










