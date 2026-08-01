# Risk Categorization
SELECT
  organism,
  antibiotic,
  ROUND(AVG(resistant_percent), 1) AS avg_resistance_pct,
  CASE
    WHEN AVG(resistant_percent) >= 50 THEN 'Critical'
    WHEN AVG(resistant_percent) >= 25 THEN 'High Concern'
    WHEN AVG(resistant_percent) >= 10 THEN 'Moderate'
    ELSE 'Low'
  END AS risk_category
FROM `your-project-id.amr_data.resistance`
WHERE year = 2015
GROUP BY organism, antibiotic
ORDER BY avg_resistance_pct DESC