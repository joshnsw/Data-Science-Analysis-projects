<b>Description:</b>
In this project, I utilized mysql queries to clean data from a dataset titled "nashville housing data". 


<b>What I learnt:</b>
I learnt the basics of data cleaning,and the necessity of cleaning data before using it for analysis. Often times,datasets contain null values,fields that have unusable formats or inconsistencies within them. For accurate data analysis results,it is important to correct these issues before conducting any data analysis.

<b>Details of the project:</b>

The steps of these data project is as follows:

1. Set date to number format 

```
UPDATE DataCleaning.nashvilledata
SET SalesDateConverted = STR_TO_DATE(SaleDate, '%d-%b-%y');
```

SaleDate, SalesDateConverted
'31-Oct-16', '2016-10-31'


2.Populate MISSING Property Address Data with correct values 

```
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

```

3. Break out address fields into seperate values (city,state)

```

SELECT SUBSTRING_INDEX (PropertyAddress,',',1) as Address,SUBSTRING_INDEX (PropertyAddress,',',-1) as City
FROM DataCleaning.nashvilledata;

SELECT SUBSTRING_INDEX (OwnerAddress,',',1) as Address,SUBSTRING_INDEX (OwnerAddress,',',2) as City,SUBSTRING_INDEX (OwnerAddress,',',-1) as State
FROM DataCleaning.nashvilledata;

```

4. Standardize values for SoldAsVacant Columns ( Values should either be Yes or No,some fields contain inconsistent values such as y or n)

```

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

```

5.Delete duplicate columns(using common table expression query) (give each row number unique id of 1,duplicate values will be given value 2 and so on,so we will only select unique values by filtering out rows that are not valued 1)


```
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
```

6.Delete columns query

```

ALTER TABLE DataCleaning.nashvilledata
DROP OwnerAddress,
DROP TaxDistrict,
DROP PropertyAddress;

SELECT * 
FROM DataCleaning.nashvilledata

```



Full code:
```

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



```
