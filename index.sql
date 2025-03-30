/* Task 1: Find the Most Valuable Customers
Expected Result: A list of customers (first name, last name, and total amount spent) sorted by the total amount spent in 
descending order. Only include customers who have spent more than $500.
*/

select id, first_name, last_name, 
(select sum(total_amount) from orders where customer_id=customers.id and status != 'cancelled') as total_amt_spent
from customers 
left join orders on customers.id = orders.customer_id
where (select sum(total_amount) from orders where customer_id=customers.id and status != 'cancelled') > 500
group by id, first_name, last_name
order by total_amt_spent desc;

/*
Task 2: Detect High-Value Orders
Expected Result: A list of orders where the total amount is more than twice the average order total in the system.
-- doing "(avg_vals.total_amt_avg *2)" returns 0 rows (dataset poorly made)
*/

with avg_vals as (
select avg(total_amount) as total_amt_avg from orders
)
select *
from orders, avg_vals
where total_amount > (avg_vals.total_amt_avg);

/*
Task 3: Identify Inactive Customers
Expected Result: A list of customers who haven't placed an order in the last 6 months.
*/
select extract(month from age(current_timestamp, order_date)) as dormant_since,
(select email from customers where id = orders.customer_id),
customer_id
from orders
where extract(month from age(current_timestamp, order_date)) >= 6;


/*
Task 4: Detect Late Payments
Expected Result: A list of orders where the payment was made more than 5 days after the order date.
*/

select payment_date - (select order_date from orders where order_id = payments.order_id) as payment_diff
from payments
where extract(day from payment_date - (select order_date from orders where order_id = payments.order_id)) >= 5;

/*
Task 5: Find the Most Popular Payment Method
Expected Result: A single row showing the payment method used in the highest number of transactions.
*/
select count(payment_id) as transaction_count, payment_method from payments 
group by payment_method 
order by transaction_count desc
limit 1;