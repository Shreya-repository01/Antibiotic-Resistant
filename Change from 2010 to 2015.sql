# Change from 2010 to 2015
SELECT
  organism,
  antibiotic,
  ROUND(AVG(CASE WHEN year = 2010 THEN resistant_percent END), 1) AS resistance_2010,
  ROUND(AVG(CASE WHEN year = 2015 THEN resistant_percent END), 1) AS resistance_2015,
  ROUND(
    AVG(CASE WHEN year = 2015 THEN resistant_percent END) -
    AVG(CASE WHEN year = 2010 THEN resistant_percent END), 1
  ) AS change_2010_to_2015
FROM `amr-resistance-project.amr_resistance.AMR`
GROUP BY organism, antibiotic
ORDER BY change_2010_to_2015 DESC
