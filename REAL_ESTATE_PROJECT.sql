
----------------------------------------------REAL ESTATE PROJECT------------------------------------------------------------------

--1-Retrieve all information for all properties in the dataset.

select * from [Real_Estate_Sales_2001-2020_GL]

--2-Retrieve property details for the town 'Woodbury' and display them in ascending order based on the Sale Amount.

select * from [Real_Estate_Sales_2001-2020_GL]
where town='Woodbury'
order by Sale_Amount

--3-Calculate and show the average Assessed Value for all properties.

select avg(assessed_value) from [Real_Estate_Sales_2001-2020_GL]

--4-Count the number of properties for each unique Residential Type.

select residential_type, count(*) as no_of_properties from [Real_Estate_Sales_2001-2020_GL]
where residential_type is not null
group by Residential_Type

------------------------------------- ---MODERATE LEVEL----------------------------------------------------------------------

--1-Retrieve property records where the sale was recorded in the year 2022.

select * from [Real_Estate_Sales_2001-2020_GL]
where year(date_recorded)='2022'

--2-Find the minimum and maximum Sales Ratio for each Property Type.

select property_type, min(sales_ratio) as minimum_sales_ratio, max(sales_ratio) as maximum_sales_ratio from [Real_Estate_Sales_2001-2020_GL]
where property_type is not null
group by property_type

--3-Retrieve details for properties in 'Torrington' with Sale Amount greater than the average Sale Amount for all towns.

select * from [Real_Estate_Sales_2001-2020_GL]
where sale_amount>(select avg(sale_amount) from [Real_Estate_Sales_2001-2020_GL]) and town='Torrington'

--4-Calculate the average Sale Amount for properties with a Sales Ratio above 0.8.

select avg(sale_amount) as average_sale_amount from [Real_Estate_Sales_2001-2020_GL]
where sales_ratio>0.8

------------------------------------------- HARD LEVEL----------------------------------------------------------------

--1-Retrieve property details with the highest Sale Amount for each town.

with cte as(
select *, dense_rank() over (partition by town order by sale_amount desc) as t from [Real_Estate_Sales_2001-2020_GL]
)
select * from cte 
where t=1

--2-Rank properties based on Sale Amount within each Property Type.

select *, dense_rank() over (partition by property_type order by sale_amount desc) as ranks 
from [Real_Estate_Sales_2001-2020_GL]

--3-Calculate the year-over-year percentage change in the total Sale Amount for each town.

with cte as(
select year(Date_recorded) as yr, sale_amount, lag(sale_amount) over(order by year(date_recorded) desc) as prev_yr_sale
from [Real_Estate_Sales_2001-2020_GL]
)
select yr, sale_amount, prev_yr_sale, 
case 
when prev_yr_sale<>0 then round((sale_amount-prev_yr_sale)/prev_yr_sale*100,2) 
else null
end as yoy_percentagechange
from cte
where prev_yr_sale is not null

--4-Identify the town with the highest total Sale Amount and retrieve its geographical location.

select top 1 town, location, total_sale_amount from(
select town, location, sum(sale_amount) as total_sale_amount from [Real_Estate_Sales_2001-2020_GL]
group by town, location
)t
order by total_sale_amount desc