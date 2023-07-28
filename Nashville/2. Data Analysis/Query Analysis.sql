-- Some questions we might have from this cleaned data:
SELECT * FROM Nashville
select min(SaleDateConverted), max(SaleDateConverted) from Nashville

-- What is the average SalePrice only for the land?
SELECT AVG(SalePrice) FROM Nashville where BuildingValue = 0

-- create the average house with the average of every topic of the house
SELECT ROUND(AVG(SalePrice),2) AS AvgSalePrice, ROUND(AVG(Acreage),2) AS AvgAcreage, ROUND(AVG(LandValue),2) AS AvgLandValue, ROUND(AVG(BuildingValue),2) AS AvgBuildingValue, ROUND(AVG(TotalValue),2) AS AvgTotalValue, ROUND(AVG(YearBuilt),2) AS AvgYearBuilt, ROUND(AVG(Bedrooms),2) AS AvgBedrooms, ROUND(AVG(FullBath),2) AS AvgFullBath, ROUND(AVG(HalfBath),2) AS AvgHalfBath FROM Nashville

-- most of the house was sold empty?
SELECT (SELECT COUNT(*) FROM (SELECT * FROM Nashville WHERE SoldAsVacant = 'NO') AS SoldFull)-(SELECT COUNT(*) FROM (SELECT * FROM Nashville WHERE SoldAsVacant = 'YES') AS SoldEmpty)

-- how many cities have in this dataset? And wich of them has the highest price per land/house sold?
SELECT COUNT(DI) FROM Nashville 
-- what is the percentage of each city in numbers of sales?
-- how many times only the land was sold?
-- how was the profit of the sale considering only the TotalValue and the SalePrince?

