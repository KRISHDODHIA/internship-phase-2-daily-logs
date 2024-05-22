-- Scenario 1: Advanced Analytics Dashboard
-- Create an inline view to calculate the daily total sales.
> create view daily_sales
    -> as select date(orderdate) as order_date, sum(quantityordered*priceeach) as total_sales
    -> from orders join orderdetails using(ordernumber)
    -> group by order_date;
-- Create an updatable view to show the number of orders for each day. Also include a functionality to update the order status in the same view.
> create view daily_orders as
    -> select date(orderdate)as order_date, count(ordernumber) as num_orders, status
    -> from orders
    -> group by order_date,status;

> update daily_orders
    -> set status="shipped" where order_date = 2005-05-31;
-- Create a view to identify the most purchased product of each day.
> create view daily_top_product as
    -> select date(orderdate) as order_date, productcode, sum(quantityordered) as total_quantity
    -> from orders join orderdetails using(ordernumber)
    -> group by order_date,productcode
    -> order by total_quantity desc;
-- Finally, combine these views to produce the required daily report
> create view daily_report as
    -> select ds.order_date, ds.total_sales, do.num_orders, dtp.productCode as top_product, dtp.total_quantity
    -> from daily_sales ds
    -> join daily_orders do on ds.order_date = do.order_date
    -> join (
    -> select dtp1.order_date, dtp1.productCode, dtp1.total_quantity
    -> from daily_top_product dtp1
    -> join (
    -> select order_date, max(total_quantity) as max_quantity
    -> from daily_top_product
    -> group by order_date
    -> ) dtp2 on dtp1.order_date = dtp2.order_date and dtp1.total_quantity = dtp2.max_quantity
    -> ) dtp on ds.order_date = dtp.order_date;

-- Scenario 2: Sales Monitoring System
-- Create a view that shows the total number of customers handled by each sales rep.
> create view rep_customers as
    -> select e.employeenumber,count(distinct c.customernumber) as num_customers
    -> from customers c join employees e on e.employeenumber=c.salesrepemployeenumber
    -> group by e.employeenumber;
-- Create a view that displays the total payments received by each sales rep.
> create view rep_payments as
    -> select e.employeenumber, sum(p.amount) as total_payments
    -> from employees e join customers c on e.employeenumber = c.salesrepemployeenumber
    -> join payments p on c.customernumber=p.customernumber
    -> group by e.employeenumber;
-- Create another view that shows the total number of orders handled by each sales rep.
> create view rep_orders as
    -> select e.employeenumber , count(o.ordernumber) as total_orders
    -> from employees e join customers c on e.employeenumber = c.salesrepemployeenumber
    -> join orders o on c.customernumber=o.customernumber
    -> group by e.employeenumber;

-- finally, create a combined view that uses the above views to display the performance of each sales rep.
> create view sales_rep_performance as
    -> select rc.employeenumber, rc.num_customers, rp.total_payments, ro.total_orders
    -> from rep_customers rc
    -> join rep_payments rp on rc.employeenumber=rp.employeenumber
    -> join rep_orders ro on rc.employeenumber=ro.employeenumber;


-- Scenario 3: HR and Sales Data Analysis
-- Create a view in the hr database that shows the department and age of each employee.

-- Create a view in the classicmodels database that shows the sales performance of each employee.