select * from DataCleaning.nashvilledata;

-- ---------------------------------------------------------------------------------------------------------------------- --
-- Standardize Date Format

ALTER TABLE DataCleaning.nashvilledata
ADD SalesDateConverted Date;

SET SQL_SAFE_UPDATES = 0;
UPDATE DataCleaning.nashvilledata
SET SalesDateConverted = STR_TO_DATE(SaleDate, '%d-%b-%y');

SELECT SaleDate,SalesDateConverted
from DataCleaning.nashvilledata;

-- ---------------------------------------------------------------------------------------------------------------------- --
-- Populate MISSING Property Address Data with correct values

SELECT *
from DataCleaning.nashvilledata
WHERE PropertyAddress = '';

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
FROM DataCleaning.nashvilledata a
JOIN DataCleaning.nashvilledata b
ON a.ParcelID = b.ParcelID
AND a.uniqueID <> b.uniqueID
WHERE a.PropertyAddress = '';


UPDATE DataCleaning.nashvilledata a
JOIN DataCleaning.nashvilledata b
ON a.ParcelID = b.ParcelID
AND a.uniqueID <> b.uniqueID
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress = '';


-- ---------------------------------------------------------------------------------------------------------------------- --
-- Break out address into separate values

SELECT SUBSTRING_INDEX (PropertyAddress,',',1) as Address,SUBSTRING_INDEX (PropertyAddress,',',-1) as City
FROM DataCleaning.nashvilledata;

SELECT SUBSTRING_INDEX (OwnerAddress,',',1) as Address,SUBSTRING_INDEX (OwnerAddress,',',2) as City,SUBSTRING_INDEX (OwnerAddress,',',-1) as State
FROM DataCleaning.nashvilledata;

-- ---------------------------------------------------------------------------------------------------------------------- --
-- Standardize values for SoldAsVacant Columns

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM DataCleaning.nashvilledata;

Update DataCleaning.nashvilledata
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;
       
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From DataCleaning.nashvilledata
Group by SoldAsVacant
order by 2;


-- ---------------------------------------------------------------------------------------------------------------------- --
-- Remove Duplicates

WITH CTE AS (
    Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From DataCleaning.nashvilledata

)
Select *	
From CTE
Where row_num > 1
Order by PropertyAddress;



-- ---------------------------------------------------------------------------------------------------------------------- --
-- Delete unused columns



ALTER TABLE DataCleaning.nashvilledata
DROP OwnerAddress,
DROP TaxDistrict,
DROP PropertyAddress;

SELECT * 
FROM DataCleaning.nashvilledata
