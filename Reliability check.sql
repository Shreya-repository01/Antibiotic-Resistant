#Relaiability check -sample size
SELECT country, organism, antibiotic, resistant_percent, isolates_tested
FROM `amr-resistance-project.amr_resistance.AMR`
WHERE year = 2015 AND isolates_tested < 30
ORDER BY isolates_tested ASC