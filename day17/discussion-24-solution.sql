-- Updatable View:
-- Create an updatable view that includes customerNumber, customerName, contactLastName, and contactFirstName from the 
-- customers table. Then, try to update the contactFirstName for a specific customerNumber.

> create view customerinfo as
    -> select customernumber, customername, contactlastname, contactfirstname
    -> from customers;

> update customerinfo
    -> set contactfirstname= 'Krish'
    -> where customernumber=114;

-- Read-Only View:
-- Create a read-only view that joins the orderdetails table and the products table on productCode and includes orderNumber, 
-- productName, and quantityOrdered. Try to update the quantityOrdered for a specific orderNumber and see what happens.

> create view orderproductdetails as
    -> select od.ordernumber, p.productname,od.quantityordered
    -> from orderdetails od
    -> join products p on od.productcode=p.productcode
    -> with check option;

-- Inline View:
-- Write a query that uses an inline view to get the total number of orders for each customer. The inline view should select 
-- customerNumber and orderNumber from the orders table. The main query should then group by customerNumber.

> select customernumber, count(ordernumber) as totalorders
    -> from( select customernumber,ordernumber
    -> from orders) as viewtype
    -> group by customernumber;

-- Materialized View:
-- Note that MySQL does not natively support materialized views, but you can mimic them with a combination of stored procedures 
-- and triggers. The task here would be to create a stored procedure that creates a new table with productName and totalQuantityOrdered 
-- (this total should be aggregated from the orderdetails table). Then, create an AFTER INSERT trigger on the orderdetails table that 
-- calls this stored procedure to update the table (acting as a materialized view) whenever a new order detail is inserted

> create procedure refresh_materialized_view()
    -> begin
    -> drop table if exists materialized_view;
    -> create table materialized_view as
    -> select p.productName, sum(od.quantityordered) as totalquantityordered
    -> from orderdetails od
    -> join products p on od.productcode = p.productcode
    -> group by p.productname;
    -> end /

> create trigger orderdetails_after_insert
    -> after insert on orderdetails
    -> for each row
    -> call refresh_materialized_view();