--who is the senior most employee according to the job title
select TOP 1 * from employee order by levels desc 

--which country has most invoices
select top 1 billing_country,count(billing_country) as count_of_invoice from invoice 
group by billing_country 
order by count(billing_country) desc

--top 3 values of total invoice
select top 3 * from invoice                  
order by total desc

--Which city has the best customers? We would like to throw a promotional Music 
--Festival in the city we made the most money. Write a query that returns one city that 
--has the highest sum of invoice totals. Return both the city name & sum of all invoice 
--totals
select top 1 billing_city,SUM(total) as total from invoice group by billing_city order by SUM(total) DESC

--Who is the best customer? The customer who has spent the most money will be declared the best customer.