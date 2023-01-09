
--Cleaning data in SQL queries

Select *
From Project.. Nash

--Standardize data format

Select SaleDateConverted, Convert(Date,Saledate)
From Project..Nash

Update Nash
Set Saledate = Convert(Date,Saledate


Alter Table nash
Add SaleDateConverted Date;

Update Nash
Set SaleDateConverted = Convert(Date,Saledate)








--Populate property Address

Select * 
From Project..Nash
-- Is Null
--Where PropertyAddress= ' '
Order by ParcelID


Update Project..Nash
Set PropertyAddress = Null
Where PropertyAddress = ' '

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.propertyaddress, b.PropertyAddress)
From Project..Nash a
Join Project..Nash b
		on a.ParcelID = b.ParcelIDAnd a.[UniqueID] <> b.[UniqueID]
		Where a.PropertyAddress is null




--Breaking out Address into Individual columns (Address, City, State)

Select PropertyAddress
From Project..Nash
-- Is Null
--Where PropertyAddress= ' '
--Order by ParcelID


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAdress)+ 1,
len(PropertyAddress))
as Address

from Project..Nash






Alter Table Project..nash
Add PropertySplitAddress Nvarchar(255);

Update Project..Nash
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', 
PropertyAddress))


Alter Table Project..nash
Add PropertySplitCity Nvarchar(255);

Update Project..Nash
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', 
PropertyAddress)+ 1, len(PropertyAddress))





Select *
From Project..Nash


Select OwnerAddress
Parsename(REPLACE(OwnerAddress, ',', '.',), 3)
Parsename(REPLACE(OwnerAddress, ',', '.',), 2)
Parsename(REPLACE(OwnerAddress, ',', '.',), 1)
from Project..nash



Alter Table Project..nash
Add OwnerSplitAddress Nvarchar(255);

Update Project..Nash
Set OwnerSplitAddress = Parsename(REPLACE(OwnerAddress, ',', '.',), 3)


Alter Table Project..nash
Add OwnerSplitCity Nvarchar(255);

Update Project..Nash
Set OwnerSplitAddress = Parsename(REPLACE(OwnerAddress, ',', '.',), 2)


Alter Table Project..nash
Add OwnerSplitAddress Nvarchar(255);

Update Project..Nash
Set OwnerSplitAddress = Parsename(REPLACE(OwnerAddress, ',', '.',), 1)

Select * 
From Project..Nash





--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldasVacant), Count(SoldasVacant)
From Project..Nash
Gropu by SoldAsVacant
Order by 2

Select SoldasVacan,
Case When SoldAsVacant = 'Y' Then 'Yes'
			When SoldAsVacant = 'N' Then 'No'
			Else SoldasVacant
			End



--Remove duplicates

With RowNumCTE() Over (
Select *,
		Row_Number() Over(
		Partition by ParcelID,
								Propertyaddress,
								SalePrice,
								Saledate,
								Legalreference
								Order by
										UniqueID
										) row_num

From Project..Nash
-- Order by ParcelID
)
--Delete
Select *
From RowNumCTE
Where Row_num > 1
Order by PropertyAddress




-- Delete Unused columns

Select * 
From Project..Nash

Alter Table Project..Nash
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table Project..Nash
Drop column Saledate