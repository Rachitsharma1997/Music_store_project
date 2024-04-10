---------------------------------------------------Question set 1- Beginner ------------------------------------------------------
-- Who is senior most employee based on job title?##
SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1;

--Which countries has the most invoices?
SELECT billing_country, count(*) FROM invoice
GROUP BY billing_country
ORDER BY billing_country DESC
LIMIT 1;

-- What are top 3 values of total invoice?
SELECT total FROM invoice 
ORDER BY total DESC
LIMIT 3;

-- Which city has the best customers? we made most money in which city return sum of invoice and city name
SELECT billing_city,SUM(total) FROM invoice
GROUP BY billing_city
ORDER BY SUM(total) DESC
LIMIT  1;

--Who is the best customer? The customer who has spend the most money will be declared the best customer
--Write a query to return the person who has spent the most money. 

SELECT i.customer_id,first_name,last_name,SUM(total) FROM customer AS cc
JOIN invoice AS i
ON cc.customer_id=i.customer_id
GROUP BY 1,2,3
ORDER BY SUM(total) DESC
LIMIT 1;

------------------------------------------------- Question Set 2 - Moderate -----------------------------------------------------
-- Q1 Write a query to return the email,first name , last name ,& genre of all rock music listeners. Return the list orderd by Email ASC
SELECT cu.first_name,cu.last_name,cu.email,g.name FROM customer AS cu
JOIN invoice AS inv ON cu.customer_id=inv.customer_id
JOIN invoice_line AS inl ON inv.invoice_id=inl.invoice_id 
JOIN track AS t ON t.track_id=inl.track_id
JOIN genre AS g ON g.genre_id=t.genre_id
WHERE g.name = 'Rock'
GROUP BY 1,2,3,4
ORDER BY email ASC;

-- Q2. Let's invite the artists who have written the most Rock music in our dataset. Write a query that returns the artist name 
-- and total track count of top 10 rock bands

SELECT artist.name,COUNT(artist.artist_id) AS no_of_songs FROM artist
JOIN album ON album.artist_id=artist.artist_id
JOIN track ON track.album_id=album.album_id
JOIN genre ON genre.genre_id=track.genre_id
WHERE genre.name = 'Rock'
GROUP BY artist.artist_id
ORDER BY COUNT(genre.name) DESC
LIMIT 10;

-- Q3. Return all the track names that have a song length longer than the average song length. Return the track and milliseconds for
--  each track. Order by the song length with the longest song listed first.

SELECT AVG(	milliseconds) FROM track; 

SELECT name,milliseconds FROM track 
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;


---------------------------------------------------Question SET-3 Advance----------------------------------------------------------

-- Q1. Find how much amount spent by each customer on artists? Write a query to return customer name , artist name ,total spent.
WITH topselling_artist AS (
	SELECT artist.artist_id,artist.name,SUM(invoice_line.unit_price*invoice_line.quantity) AS total_spent FROM artist
	JOIN album ON album.artist_id=artist.artist_id
	JOIN track ON track.album_id=album.album_id
	JOIN invoice_line ON invoice_line.track_id=track.track_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)	
	SELECT ca.customer_id,ca.first_name,ca.last_name,tsa.name AS artist_name ,SUM(invoice_line.unit_price*invoice_line.quantity) as total_spent FROM customer AS ca
	JOIN invoice ON invoice.customer_id=ca.customer_id
	JOIN invoice_line ON invoice_line.invoice_id=invoice.invoice_id
	JOIN track ON track.track_id=invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN topselling_artist AS tsa ON tsa.artist_id=album.artist_id
	GROUP BY 1,2,3,4
	ORDER BY total_spent DESC;


-- Q2. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest 
-- amount of purchases. Write a query that returns each country along with the top genre.For countries where the maximum number of purchases
-- is shared return all genres.


WITH my_cte AS (
	SELECT COUNT(inv.quantity), genre.name,genre.genre_id,customer.country,
	ROW_NUMBER() OVER(partition by customer.country ORDER BY COUNT(inv.quantity) DESC) AS rowno
	FROM invoice
	JOIN customer ON customer.customer_id=invoice.customer_id
	JOIN invoice_line AS inv ON inv.invoice_id=invoice.invoice_id
	JOIN track ON track.track_id=inv.track_id
	JOIN genre ON genre.genre_id=track.genre_id
	GROUP BY 2,3,4
	ORDER BY 3 ASC,1 DESC
	)
	SELECT * FROM my_cte
	WHERE rowno <=1;
	
	
--Q3. Write a query that determines the customer that has spent the most on music for each country. Write a query that 
-- returns the country along with the top customer and how much they spent. for the countrys where the top amount spent is
-- shared,probide all coustomers who spent this amount.
 
 WITH myct AS (
 	SELECT customer.customer_id, customer.first_name,customer.last_name,billing_country,SUM(invoice.total) AS total,
	ROW_NUMBER() OVER(partition by billing_country order by SUM(invoice.total) DESC) AS ROWNO
	FROM customer
 	JOIN invoice ON invoice.customer_id=customer.customer_id
	GROUP BY 1,2,3,4
	ORDER BY billing_country ASC,SUM(invoice.total)DESC
	)
	SELECT * FROM myct
	WHERE rowno = 1 
	ORDER BY billing_country;
	
	
	


SELECT * FROM customer;







