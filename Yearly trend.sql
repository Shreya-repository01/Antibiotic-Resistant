# Trend Over time
SELECT 
 organism,
 antibiotic,
 year,
 ROUND(AVG(resistant_percent),1) as avg_resistance_pct,
 COUNT(DISTINCT country) AS countries_reporting
FROM `amr-resistance-project.amr_resistance.AMR`
GROUP BY organism,antibiotic,year
ORDER BY organism, antibiotic,year DESC