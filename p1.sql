SELECT SUM(value)
FROM GENERATE_SERIES(1, 999)
WHERE value%3 = 0 OR value%5 = 0