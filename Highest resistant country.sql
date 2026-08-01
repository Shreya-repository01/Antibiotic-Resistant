# Which country has the highest resistance, for every combination?
SELECT
  country,
  organism,
  antibiotic,
  year,
  resistant_percent AS highest_resistance_value
FROM `amr-resistance-project.amr_resistance.AMR`
WHERE year = 2015
ORDER BY highest_resistance_value DESC
LIMIT 15