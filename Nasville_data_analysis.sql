/*

Cleaning Data in Sql
*/
select * from PortfolioProject..HousingData

-- Standardize Date format 

select SaleDateConverted,convert(date,SaleDate)
from PortfolioProject.dbo.HousingData

update PortfolioProject.dbo.HousingData
set SaleDate = convert(date,SaleDate)

alter table PortfolioProject.dbo.HousingData
add SaleDateConverted Date;
update PortfolioProject.dbo.HousingData
set SaleDateConverted = convert(date,SaleDate)

-- Populate Property Address data

select *
from PortfolioProject.dbo.HousingData
--where PropertyAddress is null;

-- Populating values for Null
select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.HousingData a
join PortfolioProject.dbo.HousingData b 
on (a.ParcelID = b.ParcelID) and (a.UniqueID <> b.UniqueID)
where a.PropertyAddress is null

Update a
set a.PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
    from PortfolioProject.dbo.HousingData a
	join PortfolioProject.dbo.HousingData b 
	on (a.ParcelID = b.ParcelID) and (a.UniqueID <> b.UniqueID)
	where a.PropertyAddress is null

-- Breaking out Address into Individual Columns
select
substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as Address,
substring(PropertyAddress, charindex(',',PropertyAddress)+1, len(PropertyAddress)) as City 
from PortfolioProject.dbo.HousingData

Alter table PortfolioProject.dbo.HousingData
Add PropertyAdresssplit Nvarchar(255);


update PortfolioProject.dbo.HousingData
set PropertyAdresssplit = substring(PropertyAddress,1,charindex(',',PropertyAddress)-1)

alter table PortfolioProject.dbo.HousingData
Add PropertySplitcity nvarchar(255)

update PortfolioProject.dbo.HousingData
set PropertySplitcity = substring(PropertyAddress, charindex(',',PropertyAddress)+1,len(PropertyAddress))


-- Breaking the Owner Address using Parsename
select PARSENAME(replace(OwnerAddress,',','.'),3),
       parsename(replace(OwnerAddress,',','.'),2),
	   parsename(replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.HousingData

Alter table PortfolioProject.dbo.HousingData
Add OwnerAdresssplit Nvarchar(255);

update PortfolioProject.dbo.HousingData
set OwnerAdresssplit = PARSENAME(replace(OwnerAddress,',','.'),3)

alter table PortfolioProject.dbo.HousingData
Add OwnerSplitcity nvarchar(255)

update PortfolioProject.dbo.HousingData
set OwnerSplitcity = parsename(replace(OwnerAddress,',','.'),2)

alter table PortfolioProject.dbo.HousingData
add OwnerSplitState nvarchar(255)

update PortfolioProject.dbo.HousingData
set OwnerSplitState = parsename(replace(OwnerAddress,',','.'),1)

select  *
from PortfolioProject.dbo.HousingData

select distinct(SoldAsVacant), count(*)
from PortfolioProject.dbo.HousingData
group by SoldAsVacant
order by 2

select SoldAsVacant,
       case when SoldAsVacant = 'Y' then 'Yes'
            when SoldAsVacant = 'N' then 'No'
		else
		    SoldAsVacant
		end 
from PortfolioProject.dbo.HousingData


update PortfolioProject.dbo.HousingData
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						else
						SoldAsVacant
						end 

-- Remove Duplicates

with rowCTE as(
select *,
       row_number()  over (partition by ParcelID,
	                                    PropertyAddress,
										SalePrice,
										SaleDate,
										LegalReference
										order by UniqueID)row_num
from PortfolioProject.dbo.HousingData)

Delete
from rowCTE
where row_num >1 
--order by ParcelID

-- Delete unused Columns

Alter table PortfolioProject.dbo.HousingData
drop column OwnerAddress,TaxDistrict,PropertyAddress

select * from PortfolioProject.dbo.HousingData