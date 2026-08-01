# Highest current resistance (2015)
SELECT 
 organism,
 antibiotic, 
 ROUND(AVG(resistant_percent),1) as avg_resistance_pct,
 COUNT(DISTINCT country) AS countries_reporting
FROM `amr-resistance-project.amr_resistance.AMR`
WHERE year =2015
GROUP BY organism,antibiotic
ORDER BY avg_resistance_pct DESC