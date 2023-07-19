-- This project in SQL has as the main objective: Cleaning data from a dataset where's has information about housing pricing in Nashville.
-- Este projeto em SQL tem como objetivo principal: Limpeza de dados de um dataset que possui informações sobre precificações das casas de Nashville.

SELECT * FROM SQL_DB_1..Nashville

-- The first think that we can see is that the SaleDate column is in Date Time format and there isn't any information about the time in this column, only the sale date. So we are going to convert the SaleDate as date creating a new column.
-- A primeira coisa que podemos notar é que a coluna SaleDate está no formato de Date Time e não existe nenhuma informação sobre as horas nesta coluna, apenas a data da venda. Então iremos converter o SaleDate para o formato Date criando uma nova coluna.

ALTER TABLE SQL_DB_1..Nashville
ADD SaleDateConverted DATE

UPDATE SQL_DB_1..NASHVILLE
SET SaleDateConverted = CONVERT (DATE, SALEDATE)

-- Populating correctly the address data where is null.
-- Adicionando dados corretamente os dados onde for null.

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM SQL_DB_1..Nashville A
JOIN SQL_DB_1..Nashville B ON A.ParcelID = B.ParcelID AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM SQL_DB_1..Nashville A
JOIN SQL_DB_1..Nashville B ON A.ParcelID = B.ParcelID AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

-- Breaking out address into individual columns (address, city, state).
-- Separando os endereços em colunas separadas (endereço, cidade, estado).

SELECT
PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1),
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+2, LEN(PropertyAddress))
AS Address FROM SQL_DB_1..Nashville

ALTER TABLE SQL_DB_1..NASHVILLE
ADD Address nvarchar(255)

UPDATE SQL_DB_1..NASHVILLE
SET Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE SQL_DB_1..NASHVILLE
ADD City nvarchar(255)

UPDATE SQL_DB_1..NASHVILLE
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+2, LEN(PropertyAddress))

SELECT OWNERADDRESS FROM SQL_DB_1..Nashville

SELECT
OWNERADDRESS,
TRIM(PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 3)),
TRIM(PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 2)),
TRIM(PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 1)),
FROM SQL_DB_1..NASHVILLE

ALTER TABLE SQL_DB_1..NASHVILLE
ADD OnwerAddress nvarchar(255)

UPDATE SQL_DB_1..NASHVILLE
SET OnwerAddress = TRIM(PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 3))

ALTER TABLE SQL_DB_1..NASHVILLE
ADD OnwerCity nvarchar(255)

UPDATE SQL_DB_1..NASHVILLE
SET OnwerCity = TRIM(PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 2))

ALTER TABLE SQL_DB_1..NASHVILLE
ADD OnwerState nvarchar(255)

UPDATE SQL_DB_1..NASHVILLE
SET OnwerState = TRIM(PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 1))

-- Change Y and N to Yes and No in "Sold as Vacant" field.
-- Alterando Y e N para Sim e Não na campo "Sold as Vacant".

SELECT DISTINCT SoldAsVacant FROM SQL_DB_1..Nashville

SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM SQL_DB_1..Nashville

UPDATE SQL_DB_1..Nashville
SET SoldAsVacant = 
CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM SQL_DB_1..Nashville

-- Removing duplicates lines.
-- Removendo linhas duplicadas.

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY PARCELID,
			 PROPERTYADDRESS,
			 SALEPRICE,
			 SALEDATE,
			 LEGALREFERENCE
			 ORDER BY
				UNIQUEID
				)ROW
FROM SQL_DB_1..Nashville
)
DELETE FROM RowNumCTE
WHERE ROW > 1

-- Delete unused columns.
-- Deletando colunas não usadas.

ALTER TABLE SQL_DB_1..NASHVILLE
DROP COLUMN OWNERADDRESS1, TAXDISTRICT, PROPERTYADDRESS, SALEDATE