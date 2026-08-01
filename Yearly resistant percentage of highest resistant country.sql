# Yearly resistant data for highest AMR country
SELECT year, resistant_percent
FROM `amr-resistance-project.amr_resistance.AMR`
WHERE country = 'Greece'
  AND organism = 'Acinetobacter species'
  AND antibiotic = 'fluoroquinolones'
ORDER BY year