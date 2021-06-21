
/* Query 1- query used for first insight */

SELECT f.film_id AS id,
		title AS title,
		c.name AS film_type,
		rental_rate AS number_of_times,
		rental_duration AS duration,
		CASE WHEN rental_rate = 4.99 AND rental_duration >=6 THEN 'VERY POPULAR MOVIE'
			 WHEN rental_rate = 2.99 AND rental_duration =5 THEN 'POPULAR MOVIE'
			 ELSE 'NOT POPULAR MOVIE'
		   END AS popularity
FROM film f
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON c.category_id = fc.category_id
GROUP BY 1,2,3
ORDER BY 5 DESC,6 DESC;

/* Query 2- query used for second insight */

SELECT f.title AS film_title,
		c.name AS category_name,
		COUNT (*) AS rental_count
FROM film_category fc
JOIN category c
ON c.category_id = fc.category_id
JOIN film f
ON f.film_id = fc.film_id
JOIN inventory i
ON i.film_id = f.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id

GROUP BY 2,1
ORDER BY 3 DESC
LIMIT 10;

/* Query 3- query used for thrid insight */


WITH t1 as (
		SELECT f.title AS title,
			   c.name AS film_type,
			   f.rental_duration AS rental_duration

	    FROM film_category fc
		JOIN category c
		ON c.category_id = fc.category_id
		JOIN film f
		ON f.film_id = fc.film_id)

SELECT title,film_type, rental_duration,
NTILE(4) OVER (PARTITION BY film_type ) AS total_percentile
FROM t1
WHERE film_type ='Animation'OR film_type ='Children'OR
	  film_type ='Classics' OR film_type ='Comedy'  OR
	  film_type ='Comedy'   OR film_type ='Family'  OR film_type ='Music'
GROUP BY 1,2,3
ORDER BY 2;

/* Query 4- query used for forth insight */

SELECT  staffid,
		staff_full_name,
		SUM (amount)
FROM
	(SELECT s.staff_id staffid,
       		s.first_name || ' ' || s.last_name AS staff_full_name,
            p.amount AS amount
     FROM    staff s
     JOIN    payment p
     ON      s.staff_id = p.staff_id) tab1

GROUP BY 1,2
ORDER BY 3 DESC;
