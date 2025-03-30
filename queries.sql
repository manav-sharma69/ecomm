create table customers (
id serial primary key,
first_name text not null,
last_name text not null,
email text unique not null,
phone text,
city text,
country text,
registration_date timestamp);

create table orders (
order_id serial primary key,
customer_id integer not null,
order_date timestamp,
status text check(status in ('pending', 'shipped', 'delivered', 'cancelled')),
total_amount numeric not null,
constraint fk_customer_id 
 foreign key (customer_id) references customers(id)
 on delete cascade);

create table products (
product_id serial primary key,
name text not null,
category text not null,
price numeric not null,
stock_quantity integer check (stock_quantity >= 0)
);

create table order_items(
order_item_id serial primary key,
order_id integer not null,
product_id integer not null,
quantity integer not null,
subtotal numeric not null,
constraint fk_order_id 
 foreign key (order_id) references orders(order_id) on delete cascade,
constraint fk_product_id
 foreign key (product_id) references products(product_id) on delete cascade);


create table payments (
payment_id serial primary key, 
order_id integer not null,
payment_date timestamp,
payment_method text check (payment_method in ('Credit Card', 'PayPal', 'Bank Transfer')),
amount_paid numeric not null,
constraint fk_order_id
foreign key (order_id) references orders(order_id));