-- =========================================================
-- Project 1: Antimicrobial Resistance (AMR) Surveillance Analysis
-- Schema + business-question queries
-- Data: amr_consolidated.csv (31 European countries, 2010-2015,
--       7 organisms, 15 antibiotic categories)
-- =========================================================

CREATE TABLE IF NOT EXISTS amr_resistance (
    country TEXT,
    year INTEGER,
    organism TEXT,
    antibiotic TEXT,
    resistant_percent REAL,
    isolates_tested REAL
);

-- Load the CSV into this table using Python (see load_to_sqlite.py) or
-- your SQLite client's ".import" / DB Browser's "Import from CSV" feature.


-- =========================================================
-- BUSINESS QUESTION QUERIES
-- =========================================================

-- Q1: Highest current resistance combinations (most recent year, 2015)
-- -> "Which drugs are already failing against which bacteria?"
SELECT
    organism,
    antibiotic,
    ROUND(AVG(resistant_percent), 1) AS avg_resistance_pct,
    COUNT(DISTINCT country) AS countries_reporting
FROM amr_resistance
WHERE year = 2015
GROUP BY organism, antibiotic
ORDER BY avg_resistance_pct DESC
LIMIT 15;

-- Q2: Resistance trend over time per organism-antibiotic combo
-- -> "Is resistance getting worse, and for what?"
SELECT
    organism,
    antibiotic,
    year,
    ROUND(AVG(resistant_percent), 1) AS avg_resistance_pct
FROM amr_resistance
GROUP BY organism, antibiotic, year
ORDER BY organism, antibiotic, year;

-- Q3: Change in resistance from 2010 to 2015 (simple trend signal)
-- -> "Which combinations are worsening fastest?"
WITH first_year AS (
    SELECT organism, antibiotic, AVG(resistant_percent) AS pct_start
    FROM amr_resistance WHERE year = 2010
    GROUP BY organism, antibiotic
),
last_year AS (
    SELECT organism, antibiotic, AVG(resistant_percent) AS pct_end
    FROM amr_resistance WHERE year = 2015
    GROUP BY organism, antibiotic
)
SELECT
    f.organism,
    f.antibiotic,
    ROUND(f.pct_start, 1) AS resistance_2010,
    ROUND(l.pct_end, 1) AS resistance_2015,
    ROUND(l.pct_end - f.pct_start, 1) AS change_percentage_points
FROM first_year f
JOIN last_year l ON f.organism = l.organism AND f.antibiotic = l.antibiotic
ORDER BY change_percentage_points DESC;

-- Q4: Country outliers -- who is much worse than the European average?
-- (using 2015 data, carbapenem resistance in K. pneumoniae as an example --
--  swap organism/antibiotic to explore others)
SELECT
    country,
    resistant_percent,
    (SELECT AVG(resistant_percent) FROM amr_resistance
        WHERE organism = 'Klebsiella pneumoniae' AND antibiotic = 'carbapenems' AND year = 2015)
        AS eu_average,
    ROUND(resistant_percent - (SELECT AVG(resistant_percent) FROM amr_resistance
        WHERE organism = 'Klebsiella pneumoniae' AND antibiotic = 'carbapenems' AND year = 2015), 1)
        AS gap_from_average
FROM amr_resistance
WHERE organism = 'Klebsiella pneumoniae' AND antibiotic = 'carbapenems' AND year = 2015
ORDER BY resistant_percent DESC;

-- Q5: Reliability check -- how many isolates back up each percentage?
-- (a 100% resistance rate based on 3 isolates is much less reliable than
--  50% based on 3000 isolates -- important for your write-up's credibility)
SELECT
    country, organism, antibiotic, year, resistant_percent, isolates_tested
FROM amr_resistance
WHERE year = 2015 AND isolates_tested < 30
ORDER BY isolates_tested ASC
LIMIT 20;
