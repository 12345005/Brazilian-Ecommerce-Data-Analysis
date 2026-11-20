create database Ecommerce_Analysis

use Ecommerce_Analysis

select distinct p.product_category_name
from products p left join category c
   on p.product_category_name = c.product_category_name
where c.product_category_name is null 
      and p.product_category_name is not null

select *
from category
where product_category_name in ('pc_gamer', 'portateis_cozinha_e_preparadores_de_alimentos')

insert into category
    (product_category_name, product_category_name_english)
values ('pc_gamer',null ),
       ('portateis_cozinha_e_preparadores_de_alimentos', null)


select 'cuctomers' as table_name, count(*) as total_rows
from customers
union all
select 'orders', count(*)
from orders
union all
select 'order_items', count(*)
from order_items
union all
select 'products', count(*)
from products
union all
select 'order_payments', count(*)
from order_payments
union all 
select 'order_reviews', count(*)
from order_reviews
union all
select 'sellers', count(*)
from sellers
union all
select 'category', count(*)
from category
union all
select 'geolocation', count(*)
from geolocation



select *
from orders

select count(*) as total_rows,
       count(order_id) as order_id_not_null,
       count(customer_id) as customer_id_not_null,
       count(order_status) as order_status_not_null,
       count(order_purchase_timestamp) as order_purchase_timestamp_not_null,
       count(order_approved_at)as order_approved_at_not_null,
       count(order_delivered_carrier_date) as order_delivered_carrier_date_not_null,
       count(order_delivered_customer_date) as order_delivered_customer_date_not_null,
       count(order_estimated_delivery_date) as order_estimated_delivery_date_not_null
from orders


select order_status, count(*) as total_order
from orders
where order_delivered_customer_date is null
group by order_status
order by total_order

select *
from orders
where order_status = 'delivered'  and order_delivered_customer_date is null


select count(*) as total_rows,
       count(order_id) as order_id,
       count(order_item_id) as order_item_id,
       count(product_id) as product_id,
       count(seller_id) as seller_id,
       count(shipping_limit_date) as shipping_limit_date,
       count(price) as price,
       count(freight_value) as freight_value
from order_items


select count(*) as total_rows,
       count(product_id) as product_id,
       count(product_category_name) as product_category_name,
       count(product_name_lenght) as product_name_lenght,
       count(product_description_lenght) as product_description_lenght,
       count(product_photos_qty) as product_photos_qty,
       count(product_weight_g) as product_weight_g,
       count(product_length_cm) as product_length_cm,
       count(product_height_cm) as product_height_cm,
       count(product_width_cm) as product_width_cm
from products


select count(*) as missing_produt_details
from products
where product_category_name is null
 and  product_name_lenght is null
 and  product_description_lenght is null
 and  product_photos_qty is null


 select count(*) as total_rows,
       count(order_id) as order_id,
       count(payment_sequential) as payment_sequential,
       count(payment_type) as payment_type,
       count(payment_installments) as payment_installments,
       count(payment_value) as payment_value
from order_payments



select count(*) as total_rows,
       count(review_id) as review_id,
       count(order_id) as order_id,
       count(review_score) as review_score,
       count(review_comment_title) as review_comment_title,
       count(review_comment_message) as review_comment_message,
       count(review_creation_date) as review_creation_date,
       count(review_answer_timestamp) as review_answer_timestamp
from order_reviews


select count(*) as total_rows,
       count(seller_id) as seller_id,
       count(seller_zip_code_prefix) asseller_zip_code_prefix,
       count(seller_city) as seller_city,
       count(seller_state) as seller_state
from sellers


select count(*) as total_rows,
       count(product_category_name) as product_category_name,
       count(product_category_name_english) as product_category_name_english
from category



select count(*) as total_rows,
       count(geolocation_zip_code_prefix) asgeolocation_zip_code_prefix ,
       count(geolocation_lat) as geolocation_lat,
       count(geolocation_lng) as geolocation_lng,
       count(geolocation_city) as geolocation_city,
       count(geolocation_state) as geolocation_state
from geolocation


select customer_id, count(*) as duplicate_count
from customers
group by customer_id
having count(*) > 1

select order_id, count(*) as duplicate_count
from orders
group by order_id
having count(*) > 1 

select product_id, count(*) as duplicate_count
from products
group by product_id
having count(*) > 1

select seller_id, count(*) as duplicate_count
from sellers
group by seller_id
having count(*) > 1

select product_category_name, count(*) as duplicate_count
from category
group by product_category_name
having count(*) > 1

select order_id,payment_sequential, count(*) as duplicate_count
from order_payments
group by order_id, payment_sequential
having count(*) > 1

select order_id,order_item_id, count(*) as duplicate_count
from order_items
group by order_id, order_item_id
having count(*) > 1

select order_id,review_id, count(*) as duplicate_count
from order_reviews
group by order_id, review_id
having count(*) > 1

select geolocation_zip_code_prefix, geolocation_lat, geolocation_lng,
       geolocation_city, geolocation_state, count(*) as duplicate_count
from geolocation
group by geolocation_zip_code_prefix, geolocation_lat, geolocation_lng,
       geolocation_city, geolocation_state
having count(*) > 1

select 
   sum(duplicate_count - 1) as extra_duplicate_rows
   from(
        select count(*) as duplicate_count
        from geolocation
        group by geolocation_zip_code_prefix, geolocation_lat, geolocation_lng,
       geolocation_city, geolocation_state
       having count(*) > 1) as duplicate

select top 10
       geolocation_zip_code_prefix, geolocation_lat, geolocation_lng,
       geolocation_city, geolocation_state, count(*) as duplicate_count
from geolocation
group by geolocation_zip_code_prefix, geolocation_lat, geolocation_lng,
       geolocation_city, geolocation_state
having count(*) > 1
order by duplicate_count desc


select count(*) as invalid_delivery_date
from orders
where order_delivered_customer_date < order_delivered_carrier_date

select count(*) as inconsistent_delivery_status
from orders
where order_delivered_customer_date is not null
and order_status <> 'delivered'

select *
from orders
where order_delivered_customer_date is not null
and order_status = 'canceled'

select *
from orders
where order_delivered_customer_date is null
and order_status = 'delivered'

select *
from orders
where order_approved_at is not null
and order_status = 'canceled'

select *
from orders
where order_delivered_carrier_date is not null
and order_status in ('invoiced', 'created', 'processing', 'approved')

select sum(case when price < 0 then 1 else 0 end) as negative_prices,
sum(case when freight_value < 0 then 1 else 0 end) as negative_freight
from order_items

select sum(case when payment_value < 0 then 1 else 0 end) ,
sum(case when payment_value = 0 then 1 else 0 end) as e
from order_payments

select *
from order_payments
where payment_value = 0

select order_id, 
       count(*) as patment_records,
       sum(payment_value) as total_payment
from order_payments
where order_id in (
       select order_id
       from order_payments
       where payment_value = 0)
group by order_id
order by patment_records desc

select p.order_id, p.payment_type, p.payment_value, o.order_status
from order_payments p join orders o
on p.order_id = o.order_id
where p.payment_value = 0
and p.order_id in( 
                  select order_id
                  from order_payments
                  group by order_id
                  having sum(payment_value) = 0 )


select min(review_score) as min_score,
       max(review_score) as max_score,
       count(case when review_score < 1 or review_score > 5 then 1 end) as invalid_score
from order_reviews

select count(*) as reviews_for_non_delivered_orders
from order_reviews r join orders o
   on r.order_id = o.order_id
where o.order_status <> 'delivered'


select o.order_status ,count(*) as total_reviews
from order_reviews r join orders o
   on r.order_id = o.order_id
where o.order_status <> 'delivered'
group by o.order_status
order by total_reviews desc


select count(case when product_weight_g <= 0 then 1 end) as invalid_weight,
       count(case when product_length_cm <= 0 then 1 end) as invalid_length,
       count(case when product_height_cm <= 0 then 1 end) as invalid_height,
       count(case when product_width_cm <= 0 then 1 end) as invalid_width
from products


select count(*) as invalid_zip_code
from sellers
where len(seller_zip_code_prefix) <> 5
      or try_cast(seller_zip_code_prefix as int) is null


select count(*) as empty_english_categories
from category
where ltrim(rtrim(product_category_name_english)) = ''


create view vw_orders_analysis as
select * ,
   case
       when order_delivered_customer_date < order_delivered_carrier_date
       or   order_delivered_carrier_date < order_purchase_timestamp
       or   order_approved_at > order_delivered_carrier_date
       or   order_delivered_customer_date < order_approved_at
       then 1  else 0 
    end  as  has_invalied_date_sequence,

    case
         when order_delivered_customer_date > order_estimated_delivery_date
         then 1  else 0
    end  as is_late_delivery
from orders


select *
from vw_orders_analysis

create view order_items_analysis as
select *
from order_items

select *
from order_items_analysis

create view osrder_payments_analysis as
select *
from order_payments


select *
from order_payments_analysis

create view order_reviews_analysis as
select *
from order_reviews

select *
from order_reviews_analysis

create view products_analysis as
select *
from products

select *
from products_analysis

create view sellers_analysis as
select *
from sellers

select *
from sellers_analysis

create view category_analysis as
select *
from category

select *
from category_analysis

create view geolocation_analysis as
select *
from geolocation

select *
from geolocation_analysis


create view customers_analysis as
select *
from customers

select *
from customers_analysis
      ---------------------------------
      -- SQL Business Analysis
--Sales

select sum(oi.price) as total_revenue
from order_items_analysis oi
join vw_orders_analysis o
  on oi.order_id = o.order_id
where o.order_status = 'delivered'


select count(*) as total_delivered_orders
from vw_orders_analysis
where order_status = 'delivered'

select sum(price) / count(distinct o.order_id) as average_order_value
from order_items_analysis oi
join vw_orders_analysis o
    on oi.order_id = o.order_id
where order_status = 'delivered'

select year(o.order_purchase_timestamp) as orders_year,
       month(o.order_purchase_timestamp) as orders_month,
       sum(oi.price) as monthly_revenue
from order_items_analysis oi
join vw_orders_analysis o
    on oi.order_id = o.order_id
where order_status = 'delivered'
group by year(o.order_purchase_timestamp),
         month(o.order_purchase_timestamp)
order by orders_year,
         orders_month
    ---------------------------------
    --2 Orders Analysis

select count(*) as total_orders
from vw_orders_analysis

select order_status,
       count(*) as total_orders,
       round(count(*) * 100.0 /
       sum(count(*)) over(), 2) as percentage
from vw_orders_analysis
group by order_status
order by total_orders 
    ----------------------------
       --Delivery Analysis

select avg(cast(
               datediff(day, order_purchase_timestamp,
                        order_delivered_customer_date) as float
           )) as avg_delivery_days
from vw_orders_analysis
where order_status = 'delivered'
and has_invalied_date_sequence = 0
and order_delivered_customer_date is not null


select 
       count(case when is_late_delivery = 1 then 1 end) * 100.0
       / count(*) as late_delivery_rate
from vw_orders_analysis
where order_status = 'delivered'
and has_invalied_date_sequence = 0
and order_delivered_customer_date is not null
     ---------------------------------
     --Products Analysis

select top 10
       c.product_category_name_english as category_name,
       sum(oi.price) as total_revenue
from order_items_analysis oi
join vw_orders_analysis o
   on oi.order_id = o.order_id
join products_analysis p
   on oi.product_id = p.product_id
join category_analysis c
   on p.product_category_name = c.product_category_name
where o.order_status = 'delivered'
group by c.product_category_name_english
order by total_revenue desc
    --------------------------------------
       --Customers Analysis

select count(distinct customer_unique_id) as total_customers
from customers_analysis

with customer_orders as(
select c.customer_unique_id,
       count(distinct o.order_id) as total_orders
from customers_analysis c
join vw_orders_analysis o
   on c.customer_id = o.customer_id
where o.order_status = 'delivered'
group by c.customer_unique_id
)
select 
      count(case when total_orders > 1 then 1 end) * 100.0
      / count(*) as repeat_purchase_rate
from customer_orders


select top 10
       customer_state,
       count(distinct customer_unique_id) as total_customers
from customers_analysis
group by customer_state
order by total_customers desc
    ----------------------------------------
         --Sellers Analysis

select top 10
       oi.seller_id,
       sum(oi.price) as total_revenue
from order_items_analysis oi
join vw_orders_analysis o
   on oi.order_id = o.order_id
where o.order_status = 'delivered'
group by oi.seller_id
order by total_revenue desc
    -----------------------------------------
        --Payments Analysis

select payment_type,
       count(*) as total_payments,
       round(count(*) *100.0/
       sum(count(*)) over(), 2) as payment_percentage
from order_payments_analysis
group by payment_type
order by payment_percentage desc
   --------------------------------------
       --Reviews Analysis

select 
      avg(cast(review_score as float)) as average_review_score
from order_reviews_analysis


SELECT CASE
        WHEN o.is_late_delivery = 1 THEN 'Late Delivery'
        ELSE 'On-Time Delivery' END AS delivery_status,
    COUNT(*) AS total_reviews,
    AVG(CAST(r.review_score AS FLOAT)) AS avg_review_score
FROM order_reviews_analysis r
JOIN vw_orders_analysis o
    ON r.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.has_invalied_date_sequence = 0
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY case
        WHEN o.is_late_delivery = 1 THEN 'Late Delivery'
        ELSE 'On-Time Delivery' END
