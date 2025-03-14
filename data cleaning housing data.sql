-- DATA CLEANING

SELECT  * FROM NashHousing

SELECT SaleDate, CONVERT(DATE, SaleDate)
FROM NashHousing

ALTER TABLE NashHousing ADD SaleDateConv DATE

UPDATE NashHousing SET SaleDateConv = CONVERT(DATE, SaleDate)

-- POPULATE PROPERTY ADDRESS

SELECT * 
FROM NashHousing
WHERE PropertyAddress IS NULL

SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress
, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashHousing A
JOIN NashHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL


UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashHousing A
JOIN NashHousing B
	ON A.ParcelID = B.ParcelID
	AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS ADDRESS,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS ADDRESS
FROM NashHousing


ALTER TABLE NashHousing ADD AddHouseSplit NVARCHAR(255)
UPDATE NashHousing
SET AddHouseSplit = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

UPDATE NashHousing 
SET AddCitySplit = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT * FROM NashHousing

SELECT PropertyAddress, AddHouseSplit, AddCitySplit
FROM NashHousing


--PARSE NAME
SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashHousing

ALTER TABLE NashHousing ADD OwnerSplitAdd NVARCHAR(255)
UPDATE NashHousing
SET OwnerSplitAdd = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashHousing ADD OwnerSplitCity NVARCHAR(255)
UPDATE NashHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashHousing ADD OwnerSplitState NVARCHAR(255)
UPDATE NashHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- HOW TO RENAME COLUMNS GHOSTS OF PAST
EXEC sp_rename 'NashHousing.AddCitySplit', 'PropertyCitySplit', 'COLUMN'
EXEC sp_rename 'NashHousing.AddHouseSplit', 'PropertyHouseAddSplit', 'COLUMN'


-- VACANCY
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashHousing
GROUP BY SoldAsVacant
ORDER BY 2

UPDATE NashHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
					END

SELECT * FROM NashHousing

---------------------------------------------------------------
--REMOVING DUPLICATES
WITH RowNumCTE AS(
SELECT * , ROW_NUMBER() OVER(
			PARTITION BY ParcelId, PropertyAddress, SalePrice,
			LegalReference
			ORDER BY UniqueID)	row_num
FROM NashHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

---------------------------------------------------------------
--DELETE UNUSED COLUMNS

ALTER TABLE NashHousing
DROP COLUMN PropertyAddress, TaxDistrict

ALTER TABLE NashHousing
DROP COLUMN SaleDate