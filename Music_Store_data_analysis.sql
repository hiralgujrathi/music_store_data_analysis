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
--Write a query that returns the person who has spent the most money
select * from customer
select *,concat(first_name,' ',last_name) as full_name FROM customer
select top 1 concat(first_name,' ',last_name) as full_name, invoice.customer_id,sum(invoice.total)  as total
from invoice join customer on invoice.customer_id=customer.customer_id 
group by invoice.customer_id,customer.first_name,customer.last_name order by sum(invoice.total) desc 

--. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
--Return your list ordered alphabetically by email starting with A
select distinct customer.email,customer.first_name,customer.last_name 
from customer join invoice on customer.customer_id=invoice.invoice_id 
join invoice_line on invoice.invoice_id=invoice_line.invoice_id 
join track on invoice_line.track_id=track.track_id 
join genre on track.genre_id=genre.genre_id
where genre.name='Rock'
order by customer.email


--Let's invite the artists who have written the most rock music in our dataset.
--Write a query that returns the Artist name and total track count of the top 10 rock bands
select top 10 artist.artist_id, artist.name,count(track.name) as count_of_tracks
from artist join album2 on artist.artist_id=album2.artist_id 
join track on album2.album_id=track.album_id 
join genre on track.genre_id=genre.genre_id
where genre.name='Rock'
group by artist.name,artist.artist_id
order by count_of_tracks desc

--.Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
select name,milliseconds 
from track 
where milliseconds > (select avg(milliseconds) from track) 
order by milliseconds desc


--Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
select customer.first_name,artist.name,SUM(invoice_line.quantity*invoice_line.unit_price) as amt_spent 
from customer join invoice on customer.customer_id=invoice.customer_id 
join invoice_line on invoice.invoice_id=invoice_line.invoice_id 
join track on track.track_id=invoice_line.track_id
join album2 on album2.album_id=track.album_id
join artist on artist.artist_id=album2.artist_id
GROUP BY customer.first_name,artist.name
order by artist.name,amt_spent

--We want to find out the most popular music Genre for each country. 
--We determine the most popular genre as the genre with the highest amount of purchases. 
--Write a query that returns each country along with the top Genre. 
--For countries where the maximum number of purchases is shared return all Genres
SELECT * FROM
(SELECT customer.country as country,genre.name as gen_name,COUNT(invoice_line.quantity) as purchase, 
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) as row_num
FROM customer JOIN invoice on customer.customer_id=invoice.customer_id 
JOIN invoice_line ON invoice.invoice_id=invoice_line.invoice_id
JOIN track on invoice_line.track_id=track.track_id 
JOIN genre on track.genre_id=genre.genre_id
GROUP BY customer.country,genre.name) tab
WHERE tab.row_num = 1

-- Write a query that determines the customer that has spent the most on music for each country. 
--Write a query that returns the country along with the top customer and how much they spent. 
--For countries where the top amount spent is shared, provide all customers who spent this amount
SELECT most_amt_spent.First_name,most_amt_spent.Last_name,most_amt_spent.Country,most_amt_spent.total FROM 
(SELECT customer.first_name as First_name,customer.last_name as Last_name,invoice.billing_country as Country,
SUM(invoice.total) as total,ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY SUM(invoice.total) DESC) as row_num
FROM customer join invoice  on customer.customer_id=invoice.customer_id
GROUP BY customer.first_name,customer.last_name,invoice.billing_country) most_amt_spent
WHERE most_amt_spent.row_num=1




