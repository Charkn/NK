SELECT * FROM NashvilleHousing
------------------------- Standarize Date Format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted, SaleDate FROM NashvilleHousing

----------------- ----------------------------------Populate AddressES where the property address field is null
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)-- ISNULL checks for the addresses if it is null
FROM NashvilleHousing a
JOIN
NashvilleHousing b
ON	a.ParcelID = b.ParcelID
AND a.[UniqueID]<>b.[UniqueID]
WHERE a.PropertyAddress IS NULL

-- -------------------------------------------------TO UPDATE the table the alias is used not the table name
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
	JOIN NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
WHERE a.PropertyAddress IS NULL

----------------------------------Breaking out addresses into Individual columns(address, city,state)
-- 1 starts at the first position of a word in the cel, the comma is at index 19 therefore -1 means one behind the comma
SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address, 
CHARINDEX(',', PropertyAddress) -- check the posion of a comma
FROM NashvilleHousing

-- +1
SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) AS Adress,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1 , LEN(PropertyAddress)) AS Address
FROM NashvilleHousing

------------------- Split address using substring
-- add a column by the name of PropertySplitAddress
ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

-- populate the col PropertySplitAddress
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 

-- Easier than Substring
------------- Parsename splits words in a cell if there is a period, it looks at words back ward
-- looking into owneraddress and replace comma with period, 
SELECT
OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM NashvilleHousing

--- Apply the query 
ALTER Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(55)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(55)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing -- add a new col by the name of (OwnerSplitState)
ADD OwnerSplitState Nvarchar(55)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1) -- from the last postion get first word TN, then replace(.) with (,) and split into col (OwnerSplitState)

---------------------- Change Y & N into Yes, No

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 1 THEN 'Yes'
		 WHEN SoldAsVacant = 0 THEN 'No'
		 END


UPDATE NashvilleHousing ---------------- Did not work
SET SoldAsVacant = 
	CASE WHEN SoldAsVacant <> 1 THEN 'Yes' ELSE 'No' END 




			
-- Delete unused columns

		 
WITH RownNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) row_num
from NashvilleHousing
--ORDER BY ParcelID
)
SELECT * FROM RownNumCTE -- REMOVE DUPLICATES, Replace select with delete
WHERE row_num >1
ORDER BY PropertyAddress

------------------------------- Drop/Remove a column
ALTER TABLE NashvilleHousing
DROP COLUMN soldAsVanacant




SELECT * FROM NashvilleHousing