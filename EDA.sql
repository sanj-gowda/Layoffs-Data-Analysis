-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs_staging2 
SET total_laid_off = NULL 
WHERE total_laid_off = 'None';

ALTER TABLE layoffs_staging2
MODIFY COLUMN total_laid_off INT;
 
SELECT MAX(total_laid_off)
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET percentage_laid_off = NULL 
WHERE percentage_laid_off = 'None';

SELECT MAX(percentage_laid_off)
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET funds_raised_millions = NULL 
WHERE funds_raised_millions = 'None';

ALTER TABLE layoffs_staging2
MODIFY COLUMN funds_raised_millions INT;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1;

WITH Rolling_total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1
)
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
), Company_Year_Rank AS
( SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL )
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
