-- Some questions we might have from this cleaned data:
SELECT * FROM Nashville

-- What is the average SalePrice only for the land?
SELECT ROUND(AVG(SalePrice),2) FROM Nashville where BuildingValue = 0

-- What is the average house? Including all of the proprierty topics?
SELECT ROUND(AVG(SalePrice),2) AS AvgSalePrice, ROUND(AVG(Acreage),2) AS AvgAcreage, ROUND(AVG(LandValue),2) AS AvgLandValue, ROUND(AVG(BuildingValue),2) AS AvgBuildingValue, ROUND(AVG(TotalValue),2) AS AvgTotalValue, ROUND(AVG(YearBuilt),2) AS AvgYearBuilt, ROUND(AVG(Bedrooms),2) AS AvgBedrooms, ROUND(AVG(FullBath),2) AS AvgFullBath, ROUND(AVG(HalfBath),2) AS AvgHalfBath FROM Nashville

-- Was most of the building sold empty?
SELECT (SELECT COUNT(*) FROM Nashville WHERE SoldAsVacant = 'NO')-(SELECT COUNT(*) FROM Nashville WHERE SoldAsVacant = 'YES')

-- How many cities have in this dataset?
SELECT DISTINCT CITY, COUNT(CITY) FROM Nashville GROUP BY City ORDER BY 2 DESC

-- Wich of them has the highest price per land/building sold?
SELECT DISTINCT CITY, ROUND(AVG(SalePrice),2) FROM Nashville GROUP BY City ORDER BY 2 DESC

-- How many times only the land was sold?
SELECT COUNT(*) FROM Nashville WHERE BuildingValue = 0

-- How was the profit of the sale considering only the TotalValue and the SalePrince?
SELECT *, (SalePrice - TotalValue) AS Profit FROM Nashville

-- How many times the lands/buildings whore sold with financial loss?
SELECT *, (SalePrice - TotalValue) AS Profit FROM Nashville where (SalePrice - TotalValue) < 0

-- What are the types of properties sold?
SELECT LandUse, COUNT(*) FROM Nashville GROUP BY LandUse ORDER BY 2 DESC

-- The properties that could not be sold with profit, are in average bigger or smaller than that ones that could be sold with profit?
SELECT (SELECT ROUND(AVG(Acreage),2) FROM Nashville WHERE (SalePrice - TotalValue) < 0) as FinancialLoss, (SELECT ROUND(AVG(Acreage),2) FROM Nashville WHERE (SalePrice - TotalValue) > 0) as Profit