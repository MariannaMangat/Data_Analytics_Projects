use sakila;

################## Homework Instructions #################################

# 1a. Display the first and last names of all actors from the table `actor`.
select first_name, last_name from actor;


# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT upper(CONCAT(a.first_name, ' ', a.last_name)) AS `Actor Name` FROM `actor` a;


# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
#     What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor
where first_name = 'Joe';


# 2b. Find all actors whose last name contain the letters `GEN`:
select first_name, last_name from actor
where last_name like '%GEN%';


# 2c. Find all actors whose last names contain the letters `LI`. 
#     This time, order the rows by last name and first name, in that order:
select last_name, first_name from actor
where last_name like '%LI%' order by last_name, first_name;


# 2d. Using `IN`, display the `country_id` and `country` columns of the following 
#     countries: Afghanistan, Bangladesh, and China:
select * from country limit 10;
select country_id,country from country where country in ('Afghanistan', 'Bangladesh', 'China');


# 3a. Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. 
#     Hint: you will need to specify the data type.
alter table actor add column middle_name char(20) after first_name;
select * from actor;


# 3b. You realize that some of these actors have tremendously long last names. 
#     Change the data type of the `middle_name` column to `blobs`.
alter table actor modify middle_name blob;
select * from actor;


# 3c. Now delete the `middle_name` column.
alter table actor drop column middle_name;
select * from actor;


# 4a. List the last names of actors, as well as how many actors have that last name.
select last_name as 'Last Name', count(last_name) as 'Total Last Names' 
from actor  group by last_name;


# 4b. List last names of actors and the number of actors who have that last name, 
#      but only for names that are shared by at least two actors
select last_name as 'Last Name', count(last_name) as 'At Least 2 Last Names' 
from actor  group by last_name
having count(last_name) >= 2;


# 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
#     the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
update actor set first_name = 'HARPO' where first_name = 'GROUCHO' and last_name = 'WILLIAMS';


# 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
#     It turns out that `GROUCHO` was the correct name after all! In a single query, 
#     if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. 
#     Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor will be with the grievous error. 
#     BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, HOWEVER! 
#     (Hint: update the record using a unique identifier.)
update actor set first_name = 
case
	when first_name = 'HARPO' then 'GROUCHO' 
    else 'MUCHO GROUCHO'
end
where actor_id = 172;
select * from actor;


# 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
#Hint: <https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html>
show create table sakila.address;

CREATE TABLE `address` (
   `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
   `address` varchar(50) NOT NULL,
   `address2` varchar(50) DEFAULT NULL,
   `district` varchar(20) NOT NULL,
   `city_id` smallint(5) unsigned NOT NULL,
   `postal_code` varchar(10) DEFAULT NULL,
   `phone` varchar(20) NOT NULL,
   `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`address_id`),
   KEY `idx_fk_city_id` (`city_id`),
   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8


# 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
#     Use the tables `staff` and `address`.
select first_name, last_name, address from staff 
inner join address on staff.address_id=address.address_id;


# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
#     Use tables `staff` and `payment`.
select first_name 'First Name', last_name 'Last Name', sum(amount) 'Total Charges' from staff	
inner join payment on staff.staff_id=payment.staff_id 
group by payment.staff_id
order by sum(amount) desc;


# 6c. List each film and the number of actors who are listed for that film. 
#     Use tables `film_actor` and `film`. Use inner join.
select title 'Film Title', count(actor_id) 'Number of Actors' from film f
inner join film_actor f_a on f.film_id=f_a.film_id 
group by f_a.film_id;


# 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
select title 'Film Title', count(inventory_id) 'Inventory - Total Available' from film
inner join inventory on film.film_id=inventory.film_id 
where title = 'Hunchback Impossible';


# 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
#     List the customers alphabetically by last name
# ```
#  ![Total amount paid](Images/total_payment.png)
# ```
select first_name, last_name, sum(amount) from customer c 
inner join payment p on c.customer_id=p.customer_id 
group by c.last_name;


# 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#     As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
#     Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select title from film
where language_id in (
	select language_id from language
    where name='English'
)
and (title like 'K%') or (title like 'Q%');


# 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select first_name, last_name from actor
where actor_id in (
	select actor_id from film_actor
    where film_id in (
		select film_id from film
		where title = 'Alone Trip'
        )
);


# 7c. You want to run an email marketing campaign in Canada, 
#     for which you will need the names and email addresses of all Canadian customers. 
#     Use joins to retrieve this information.
select c.first_name, c.last_name, c.email from customer c
inner join address a on c.address_id = a.address_id
inner join city y on a.city_id=y.city_id 
where y.country_id = (
	select country_id from country where country = 'Canada'
    );


# 7d. Sales have been lagging among young families, and you wish to target all 
#     family movies for a promotion. Identify all movies categorized as famiy films.
select f.title from film f 
inner join film_category f_c on f.film_id = f_c.film_id
where f_c.category_id = (
	select category_id from category c where c.name = 'Family'
);


# 7e. Display the most frequently rented movies in descending order.
select f.title 'Film Title', sum(r.rental_id) 'Rentals Frequency' from film f
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
group by r.rental_id
order by sum(r.rental_id) desc limit 10;


# 7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(p.amount) 'Total Sales ($)' from store s
left join staff t on s.store_id = t.store_id
left join payment p on t.staff_id = p.staff_id 
group by s.store_id;


# 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id, a.address, c.city, a.district, r.country from store s
left join address a on s.address_id = a.address_id
left join city c on a.city_id = c.city_id
left join country r on c.country_id = r.country_id
group by s.store_id;


# 7h. List the top five genres in gross revenue in descending order. 
#     (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select c.name 'Film Genres', sum(p.amount) 'Total Sales ($)' from category c
inner join film_category f on c.category_id = f.category_id
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
inner join payment p on r.rental_id = p.rental_id
group by c.name 
order by sum(p.amount) desc
limit 5;
 

# 8a. In your new role as an executive, you would like to have an easy way of viewing 
#     the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
#     If you haven't solved 7h, you can substitute another query to create a view.
create view top5_genres_revenue as (
	select c.name 'Film Genres', sum(p.amount) 'Total Sales ($)' from category c
	inner join film_category f on c.category_id = f.category_id
	inner join inventory i on f.film_id = i.film_id
	inner join rental r on i.inventory_id = r.inventory_id
	inner join payment p on r.rental_id = p.rental_id
	group by c.name 
	order by sum(p.amount) desc
	limit 5
);


# 8b. How would you display the view that you created in 8a?
select * from top5_genres_revenue;


# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view if exists top5_genres_revenue;