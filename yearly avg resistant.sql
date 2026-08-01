#Overall average resistance per year
SELECT year, ROUND(AVG(resistant_percent), 1) AS overall_avg_resistance
FROM `amr-resistance-project.amr_resistance.AMR`
GROUP BY year
ORDER BY year