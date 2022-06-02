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









