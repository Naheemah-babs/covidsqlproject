-- CONVERT DATE FORMAT

ALTER Table nashvillehousing
Add SaleDateConverted Date;

UPDATE nashvillehousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- remove where property address is null and where parxelid is more than one 
update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM nashvillehousing a
JOIN nashvillehousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select *
from nashvillehousing

-- Breaking out Address into individual columns (Address, City, State)
-- -1 removes the coma at the end of the result and +1 does the same too
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
from nashvillehousing

-- anoda method of splitting
ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) 

-- OR
 ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM nashvillehousing



--change Y and N to Yes and No 
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
From nashvillehousing

-- update the table
UPDATE nashvillehousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

--counting the numbers of yes and no
SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM nashvillehousing
GROUP BY SoldAsVacant
order by 2

--Remove Duplicates

WITH RowNumCTE AS (
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM nashvillehousing
)
SELECT *
FROM RowNumCTE
Where row_num > 1
Order by PropertyAddress

-- delete columns
select *
from nashvillehousing

ALTER TABLE nashvillehousing
DROP COLUMN OwnerAddress, PropertyAddress



