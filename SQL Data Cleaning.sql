-- Cleaning Data in SQL Queries

Select *
From PortfolioProject.dbo.NashvilleHousing

-- Standardize Date Format

Select SaleDateConverted, CONVERT(date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
-- Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
-- Where PropertyAddress is null
-- order by ParcelID

Select
Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , Len(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

Alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Alter table NashvilleHousing
Add PropertySplitCity Date;

Update NashvilleHousing
SET PropertySplitCity = , Substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , Len(PropertyAddress)) as Address


Select *
From PortfolioProject.dbo.NashvilleHousing



Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
Parsename (Replace(OwnerAddress, ',' , '.') , 3)
, Parsename (Replace(OwnerAddress, ',' , '.') , 2)
, Parsename (Replace(OwnerAddress, ',' , '.') , 1)
From PortfolioProject.dbo.NashvilleHousing



Alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = Parsename (Replace(OwnerAddress, ',' , '.') , 3)

Alter table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = Parsename (Replace(OwnerAddress, ',' , '.') , 2)

Alter table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = Parsename (Replace(OwnerAddress, ',' , '.') , 1)


Select *
From PortfolioProject.dbo.NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'NO'
		Else SoldAsVacant
		END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'NO'
		Else SoldAsVacant
		END


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() Over (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference
				ORDER BY
					UniqueID
					) row_num


From PortfolioProject.dbo.NashvilleHousing
-- Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--- Order by PropertyAddress


-- Delete Unused Column



Select *
From PortfolioProject.dbo.NashvilleHousing


Alter table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate
