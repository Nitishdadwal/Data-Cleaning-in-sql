/*
Cleaning Data in SQL Queries*/
SELECT * FROM PortfolioProject..[Nashville Housing]

--Standardize Date Format
Select SaleDate, CONVERT(Date,SaleDate)
FROM PortfolioProject..[Nashville Housing] 

Update  [Nashville Housing]
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [Nashville Housing]
Add SaleDateConverted Date;

Update  [Nashville Housing]
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select saleDateConverted,CONVERT(Date,SaleDate)
FROM PortfolioProject..[Nashville Housing]

--Populate Propert Address data
Select PropertyAddress
FROM PortfolioProject..[Nashville Housing]
Where PropertyAddress is null

Select *
FROM PortfolioProject..[Nashville Housing]
--Where PropertyAddress is null
order by ParcelID

Select *
FROM PortfolioProject..[Nashville Housing] a
JOIN PortfolioProject..[Nashville Housing] b
on a.ParcelID = b.ParcelID
AND a.[UniqueID]<>b.[UniqueID]


Select a.ParcelID,a.PropertyAddress,b.ParcelID,
b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..[Nashville Housing] a
JOIN PortfolioProject..[Nashville Housing] b
on a.ParcelID = b.ParcelID
AND a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null


--UPDATE a
--SET a.PropertyAddress = ISNULL(b.PropertyAddress, a.PropertyAddress)
--FROM PortfolioProject..[Nashville Housing] a
--JOIN PortfolioProject..[Nashville Housing] b
--  ON a.ParcelID = b.ParcelID
--  AND a.[UniqueID] <> b.[UniqueID]
--WHERE a.PropertyAddress IS NULL;

--Breaking Out Address INTO Individual columns/(Address,City,State)
--Select* FROM
--PortfolioProject..[Nashville Housing]
--order by ParcelID

Select PropertyAddress 
FROM PortfolioProject..[Nashville Housing]
--where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX
(',',PropertyAddress)-1) as Address,

SUBSTRING(PropertyAddress,CHARINDEX
(',',PropertyAddress)+1 ,LEN(PropertyAddress))as Address

FROM PortfolioProject..[Nashville Housing]

ALTER TABLE [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);
Update [Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Nashville Housing]
Add PropertySplitCity Nvarchar(255);

Update [Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, 
CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT * FROM PortfolioProject..[Nashville Housing]

Select OwnerAddress
FROM PortfolioProject..[Nashville Housing]

Select
ParseName(REPLACE(OwnerAddress,',','.'), 3)
,ParseName(REPLACE(OwnerAddress,',','.'), 2)
,ParseName(REPLACE(OwnerAddress,',','.'), 1)
FROM PortfolioProject..[Nashville Housing]



ALTER TABLE [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);
Update [Nashville Housing]
SET OwnerSplitAddress = ParseName(REPLACE(OwnerAddress,',','.'), 3)


ALTER TABLE [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitCity = ParseName(REPLACE(OwnerAddress,',','.'), 2)


ALTER TABLE [Nashville Housing]
Add PropertySplitState Nvarchar(255);

Update [Nashville Housing]
SET PropertySplitState = ParseName(REPLACE(OwnerAddress,',','.'), 1)

Select * FROM PortfolioProject..[Nashville Housing]

--change Y and NY Yes and No in'Sold as Vacant'
Select Distinct(SoldAsVacant),Count(SoldAsVacant)
FROM PortfolioProject..[Nashville Housing]
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N'  THEN 'No'
	   ELSE SoldAsVacant
	   END 
FROM PortfolioProject..[Nashville Housing]

Update [Nashville Housing]
SET SoldAsVacant=CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N'  THEN 'No'
	   ELSE SoldAsVacant
	   END 

--Remove Duplicates
WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, 
                         PropertyAddress, 
                         SalePrice, 
                         SaleDate,
                         LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM PortfolioProject..[Nashville Housing]
)

--SELECT * FROM RowNumCTE

-- To check duplicates
--SELECT *
--FROM RowNumCTE
--where row_num>1
--Order by PropertyAddress

DELETE FROM RowNumCTE
where row_num>1

--DElete Unused Colums
Select* FROM PortfolioProject..[Nashville Housing]

ALTER TABLE PortfolioProject..[Nashville Housing]
DROP COLUMN OwnerAddress,
TaxDistrict,PropertyAddress

ALTER TABLE PortfolioProject..[Nashville Housing]
DROP Column SaleDate