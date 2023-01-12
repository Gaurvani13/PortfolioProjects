Select *
From PortfolioProject.dbo.NashvilleHousing

---1.Standardize Date format
Select SaleDate 
From PortfolioProject.dbo.NashvilleHousing

Select SaleDate, Convert(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

Select *
From PortfolioProject.dbo.NashvilleHousing
--For some reason, above didn't work

--So new technique, first add a new coloumn in the table and then change date format

ALter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)

Select *
From PortfolioProject.dbo.NashvilleHousing

--- 2.Populate Property Address data
Select *
From PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is Null
--- If we look at complete table, some listings with same parcel id. Parcel ids are unique for each property. Listings with same parcel
---id have same property address. Hence we can populate the null property addresses by looking at addresses in listings with same 
---property address. So, we'll join the table to itself and then populate.

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and
a.[UniqueID ]<> b.[UniqueID ]

---The above query joins the table to itself where parcel ids are the same but unique ids are different to ensure we are not looking at
---the same listig/row again and again. We want 2 different listings/rows with same property address or parcel id.
Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and
a.[UniqueID ]<> b.[UniqueID ]
where b.PropertyAddress is Null
--- last line to see the actual property addresses of properties we want to populate i.e. Null propert

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(b.PropertyAddress,a.PropertyAddress) --check if b.property is null, if yes, then replace by a.property
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and
a.[UniqueID ]<> b.[UniqueID ]
where b.PropertyAddress is Null

Update b--update table b
set b.PropertyAddress =  ISNULL(b.PropertyAddress,a.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and
a.[UniqueID ]<> b.[UniqueID ]
where b.PropertyAddress is Null

--to check if query worked
Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and
a.[UniqueID ]<> b.[UniqueID ]
where b.PropertyAddress is Null



--- 3.Break address (both property and owner) into individual coloumns by Address, City and State

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

-- one thing in property address, all of the addresses have a comma separating address and city & the comma isn't used anywhere
-- else in the address

Select
SUBSTRING (PropertyAddress , 1 , CHARINDEX (',' , PropertyAddress)-1) as Address,--this is to separate out address
CHARINDEX (',' , PropertyAddress)-1
From PortfolioProject.dbo.NashvilleHousing

--to separate out city and address we do the following
Select
SUBSTRING (PropertyAddress , 1 , CHARINDEX (',' , PropertyAddress)-1) as Address,
SUBSTRING (PropertyAddress ,CHARINDEX (',' , PropertyAddress) +1  , LEN(PropertyAddress)) as City---within property address,
---start from character before comma and end at last chracter of each address. However, each address is of different length, so 
--to specify where to end we just write end at length of the property address. This will help to separate city
From PortfolioProject.dbo.NashvilleHousing

---we can't separate city and address in a table without creating 2 new coloumns. So , we create 2 new coloumns in the table
---and add values
Alter table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING (PropertyAddress , 1 , CHARINDEX (',' , PropertyAddress)-1)

Alter table PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity =SUBSTRING (PropertyAddress ,CHARINDEX (',' , PropertyAddress) +1  , LEN(PropertyAddress))

Select * 
From PortfolioProject.dbo.NashvilleHousing

--we did above because then the property address is much more usable . You can run different queries easily

--Same thing with owner address, but different method

Select OwnerAddress 
From PortfolioProject.dbo.NashvilleHousing

---we're going to use ParseName to separate but ParseName only looks for . and in our date we have, So, we'll 1st convert all , into .

Select PARSENAME( Replace(OwnerAddress,',','.'),3),
PARSENAME( Replace(OwnerAddress,',','.'),2),
PARSENAME( Replace(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing

--now add coloumns in table and enter these values

Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress = PARSENAME( Replace(OwnerAddress,',','.'),3)

Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity = PARSENAME( Replace(OwnerAddress,',','.'),2)

Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME( Replace(OwnerAddress,',','.'),1)

Select *
From  PortfolioProject.dbo.NashvilleHousing

--- 4.Change Y and N into Yes and No in Sold As Vacant field

Select Distinct(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
--so since we can see that majority of answers have been given in Yes/No, let's convert all answers to Yes/No instead of Y/N

--so, we'll use case statements
Select SoldAsVacant,
CASE When SoldAsVacant='Y' then 'Yes'
When SoldAsVacant='N' then 'No'
Else SoldAsVacant
End
From PortfolioProject.dbo.NashvilleHousing

--now, update the actual table
Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant= CASE When SoldAsVacant='Y' then 'Yes'
When SoldAsVacant='N' then 'No'
Else SoldAsVacant
End

--to check if it worked
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant

--- 5.Remove Duplicates

With RowNumCTE as (
Select *,
       ROW_NUMBER() Over(
          Partition By ParcelId,
		               PropertyAddress,
					   SalePrice,
					   LegalReference
					   Order By
					   UniqueId
					   ) row_num
From PortfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)

Select *
From RowNumCTE
where row_num>1
order by PropertyAddress

--so now,rows with row_num>1 are the duplicate rows. We simply delete them

With RowNumCTE as (
Select *,
       ROW_NUMBER() Over(
          Partition By ParcelId,
		               PropertyAddress,
					   SalePrice,
					   LegalReference
					   Order By
					   UniqueId
					   ) row_num
From PortfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)

Delete 
From RowNumCTE
where row_num>1
--order by PropertyAddress

--to check 
With RowNumCTE as (
Select *,
       ROW_NUMBER() Over(
          Partition By ParcelId,
		               PropertyAddress,
					   SalePrice,
					   LegalReference
					   Order By
					   UniqueId
					   ) row_num
From PortfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)

Select * 
From RowNumCTE
where row_num>1
order by PropertyAddress

--- 6.Delete Unused Coloumns 
Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column PropertyAddress,OwnerAddress,TaxDistrict

--to check
Select *
From PortfolioProject.dbo.NashvilleHousing
