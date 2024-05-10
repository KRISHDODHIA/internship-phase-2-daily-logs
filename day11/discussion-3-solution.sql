--- Write a query to display a list of customers who locate in the same city by joining the customers table to itself.
> select c1.customerName, c1.city, c2.customerName
    -> from customers c1
    -> inner join customers c2 on c1.city=c2.city
    -> where c1.customerName = c2.CustomerName order by city;

--- Write a query to get:
    --- a. The productCode and productName from the products table.
    --- b. The textDescription of product lines from the productlines table.
> select productCode, productName from products;
> select productCode, productName,textDescription
    -> from products
    -> inner join productlines using(productLine);

--- Write a query that returns order number, order status, and total sales from the orders and orderdetails tables as follows:
> select orderNumber, status as order_status, sum(quantityOrdered*priceEach) as total_sales
    -> from orders
    -> inner join orderdetails using(orderNumber)
    -> group by orderNumber;

--- Write a query to fetch the complete details of orders from the orders, orderDetails, and products table, and sort them by orderNumber and orderLineNumber as follows:   
> select o.orderNumber, o.orderDate, od.orderLineNumber, p.productName, od.quantityOrdered, od.priceEach
    -> from orderdetails od
    -> inner join orders o using(orderNumber)
    -> inner join products p using(productCode)
    -> order by od.orderLineNumber,od.orderNumber;

--- Write a query to perform INNER JOIN of four tables and Display the details sorted by orderNumber, orderLineNumber as per the following
> select orderNumber, orderDate, CustomerName, orderLineNumber, productName, quantityOrdered, priceEach
    -> from products
    -> inner join orderdetails using(productCode)
    -> inner join orders using(orderNumber)
    -> inner join customers using(customerNumber)
    -> order by orderNumber,orderLineNumber;

--- Write a query to find the sales price of the product whose code is S10_1678 that is less than the manufacturer’s suggested retail price (MSRP) for that product as follows:
> select orderNumber, productName, msrp, priceEach
    -> from products
    -> inner join orderdetails using(productCode)
    -> where productCode="S10_1678" and priceEach<msrp;

--- Each customer can have zero or more orders while each order must belong to one customer. Write a query to find all the customers and their orders as follows:
> select customerNumber, customerName, orderNumber,
    -> status from customers left join orders using(customerNumber);

--- Write a query that uses the LEFT JOIN to find customers who have no order:
> select customerNumber, customerName, orderNumber,
    -> status from customers left join orders using(customerNumber)
    -> where orderNumber is null;