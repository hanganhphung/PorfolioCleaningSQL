-- cleaning data in sql queries

select *
from PortfolioProject..NashvilleHousing

-- standardlize data format for date

select SaleDateConverted,
convert(date, saledate)
from PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing
set saledate = convert(date, saledate)

alter table PortfolioProject..NashvilleHousing
add SaleDateConverted Date;

update PortfolioProject..NashvilleHousing
set SaleDateConverted = convert(date, saledate)

-- populate property address dataselect SaleDateConverted, convert(date, saledate)

select a.parcelid,
a.propertyaddress,
b.parcelid,
b.propertyaddress,
isnull(a.propertyaddress,b.propertyaddress)
from PortfolioProject..NashvilleHousing a 
join PortfolioProject..NashvilleHousing b
	on a.parcelid=b.parcelid
	and a.uniqueid < > b.uniqueid
where a.propertyaddress is null

update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from PortfolioProject..NashvilleHousing a 
join PortfolioProject..NashvilleHousing b
	on a.parcelid=b.parcelid
	and a.uniqueid < > b.uniqueid
where a.propertyaddress is null

-- break down address

select propertyaddress
from PortfolioProject..nashvillehousing

select
substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as address,
substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress)) as address
from PortfolioProject..nashvillehousing


alter table PortfolioProject..NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update PortfolioProject..NashvilleHousing
set PropertySplitAddress = substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)


alter table PortfolioProject..NashvilleHousing
add PropertySplitCity Nvarchar(255);

update PortfolioProject..NashvilleHousing
set PropertySplitCity = substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))

Select PropertySplitAddress,PropertySplitCity
from PortfolioProject..nashvillehousing

-- breakdown owner address

select PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from PortfolioProject..nashvillehousing


alter table PortfolioProject..NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update PortfolioProject..NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(owneraddress,',','.'),3)


alter table PortfolioProject..NashvilleHousing
add OwnerSplitCity Nvarchar(255);

update PortfolioProject..NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(owneraddress,',','.'),2)


alter table PortfolioProject..NashvilleHousing
add OwnerSplitState Nvarchar(255);

update PortfolioProject..NashvilleHousing
set OwnerSplitState = PARSENAME(replace(owneraddress,',','.'),1)

select OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
from PortfolioProject..nashvillehousing

-- change Y/N to Yes/No

select SoldAsVacant
from PortfolioProject..nashvillehousing
group by SoldAsVacant

select SoldAsVacant
, case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from PortfolioProject..nashvillehousing

update PortfolioProject..nashvillehousing
set SoldAsVacant = case
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end

-- remove duplicates

--WITH RowNumCTE AS(
--Select *,
--	ROW_NUMBER() OVER (
--	PARTITION BY ParcelID,
--				 PropertyAddress,
--				 SalePrice,
--				 SaleDate,
--				 LegalReference
--				 ORDER BY
--					UniqueID
--					) row_num

--From PortfolioProject.dbo.NashvilleHousing
----order by ParcelID
--)
--Select *
--From RowNumCTE
--Where row_num > 1
--Order by PropertyAddress


--Select *
--From PortfolioProject.dbo.NashvilleHousing









