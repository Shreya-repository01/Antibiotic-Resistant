# Multi-drug resistance count — how many different antibiotics is each organism resistant to (>25%) in each country
SELECT
  country,
  organism,
  COUNT(DISTINCT antibiotic) AS num_antibiotics_high_resistance
FROM `amr-resistance-project.amr_resistance.AMR`
WHERE year = 2015 AND resistant_percent > 25
GROUP BY country, organism
HAVING COUNT(DISTINCT antibiotic) >= 3
ORDER BY num_antibiotics_high_resistance DESC