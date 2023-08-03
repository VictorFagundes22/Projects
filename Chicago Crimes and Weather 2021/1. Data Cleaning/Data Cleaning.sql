SELECT * FROM chicago_crimes_2021
SELECT * FROM chicago_temps_2021
SELECT * FROM chicago_areas


ALTER TABLE chicago_crimes_2021
ADD date date

UPDATE chicago_crimes_2021
SET date = PARSENAME(REPLACE(crime_date, ' ','.'),3)

ALTER TABLE chicago_crimes_2021
ADD time_report time

UPDATE chicago_crimes_2021
SET time_report = PARSENAME(REPLACE(crime_date, ' ','.'),2)

ALTER TABLE chicago_crimes_2021
ADD month varchar(255)

UPDATE chicago_crimes_2021
SET MONTH = DATENAME(MONTH, DATE)

ALTER TABLE chicago_temps_2021
ALTER COLUMN TEMP_HIGH FLOAT

ALTER TABLE chicago_temps_2021
ALTER COLUMN TEMP_LOW FLOAT