#Q1(A)
select employeeNumber,firstName,lastName from employees where jobTitle = 'Sales Rep' and reportsTo = 1102;

#Q1(B)
select distinct productLine FROM products where productLine like '% Cars';

#Q2
SELECT
    CustomerNumber,
    CustomerName,
    CASE
        WHEN Country IN ('USA', 'Canada') THEN 'North America'
        WHEN Country IN ('UK', 'France', 'Germany') THEN 'Europe'
        ELSE 'Other' 
    END AS CustomerSegment
FROM
    Customers;
    
#Q3(a)
select * from orderdetails;
select productCode, sum(quantityOrdered) as total_ordered from orderdetails group by productCode order by total_ordered DESC LIMIT 10;

#Q3(b)
select * from payments;  
select monthname(paymentdate) as payment_month,count(*) as numberof_payments from payments group by monthname(paymentdate) having count(*) >20 order by numberof_payments desc;

#Q4(a)
CREATE TABLE Customers_data (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20)
);

INSERT INTO Customers_data (first_name, last_name, email, phone_number) VALUES
('Priya', 'Sharma', 'priya.sharma@example.com', '9876543210'),
('Rajesh', 'Verma', 'r.verma@corp.net', '8888877777'),
('Alia', 'Singh', 'alia.s@emailhost.co.in', '7777766666'),
('Gaurav', 'Reddy', 'gaurav.reddy@techfirm.com', '9900112233'),
('Sneha', 'Mishra', 'sneha.mishra@webmail.org', '7000700070');

select *from customers_data;

#Q4(b)

CREATE TABLE Orders_data (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers_data(customer_id),
    CHECK (total_amount > 0)
);

INSERT INTO Orders_data (customer_id, order_date, total_amount)
VALUES
(1, '2025-11-20', 150.75),
(2, '2025-11-20', 45.00),
(3, '2025-11-21', 899.99),
(4, '2025-11-22', 25.50),
(5, '2025-11-22', 500.00);

select *from orders_data;

#Q5
SELECT customers.country, COUNT(orders.orderNumber) AS order_count
FROM Customers JOIN Orders ON customers.customerNumber = orders.customerNumber
GROUP BY customers.country
ORDER BY order_count DESC
LIMIT 5;

#Q6
CREATE TABLE Project (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(50) NOT NULL,
    Gender VARCHAR(10) CHECK (Gender IN ('Male', 'Female')),
    ManagerID INT
);

INSERT INTO Project (EmployeeID, FullName, Gender, ManagerID) VALUES
(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);

SELECT *FROM PROJECT;
SELECT M.FullName AS "Manager Name", E.FullName AS "Emp Name"
FROM Project AS E    
JOIN Project AS M   
ON E.ManagerID = M.EmployeeID
ORDER BY M.FullName, E.FullName;

#Q7

CREATE TABLE facility (
    Facility_ID INT,
    Name VARCHAR(100) NULL,
    State VARCHAR(100) NULL,
    Country VARCHAR(100) NULL
);

ALTER TABLE facility
MODIFY Facility_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

alter table facility 
add column city varchar(100) not null after name;
 
 desc facility;
 
 
 #Q8
 
CREATE VIEW product_sales AS
SELECT pl.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM productlines pl
JOIN products p ON pl.productLine = p.productLine
JOIN orderdetails od ON p.productCode = od.productCode
JOIN orders o ON od.orderNumber = o.orderNumber
GROUP BY pl.productLine
ORDER BY total_sales DESC ;

DESC PRODUCT_SALES;
SELECT *FROM PRODUCT_SALES;

#Q9

CREATE PROCEDURE Get_country_payments (IN target_year INT,IN target_country VARCHAR(50))
DELIMITER ;
call get_country_payments(2003,"FRANCE");

#Q10(a)

SELECT *FROM CUSTOMERS;
SELECT *FROM ORDERS;

SELECT c.customerName, COUNT(o.orderNumber) AS Order_count,
DENSE_RANK() OVER (ORDER BY COUNT(o.orderNumber) DESC) AS order_freq
FROM customers c
JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerName
ORDER BY Order_count DESC, customerName ASC;


SELECT
  t.YearValue AS Year,
  t.MonthName AS Month,
  t.TotalOrders AS TotalOrders,
  CASE
    WHEN t.PrevMonthOrders IS NULL OR t.PrevMonthOrders = 0 THEN 'NULL'
    ELSE CONCAT(ROUND((t.TotalOrders - t.PrevMonthOrders) * 100.0 / t.PrevMonthOrders),'%')
  END AS MoM_Change
FROM (
  SELECT
    YEAR(o.orderDate) AS YearValue,
    MONTH(o.orderDate) AS MonthNumber,
    MONTHNAME(o.orderDate) AS MonthName,
    COUNT(DISTINCT o.orderNumber) AS TotalOrders,
    LAG(COUNT(DISTINCT o.orderNumber), 1) OVER (ORDER BY YEAR(o.orderDate), MONTH(o.orderDate)) AS PrevMonthOrders
  FROM Orders AS o
  GROUP BY YEAR(o.orderDate), MONTH(o.orderDate), MONTHNAME(o.orderDate)) AS t
ORDER BY t.YearValue, t.MonthNumber;

#Q11

SELECT p.productLine,
COUNT(p.productCode) AS Total
FROM
    products AS p
WHERE
p.buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY
    p.productLine
ORDER BY
    Total DESC, p.productLine;
    
#Q12

CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,         
    EmpName VARCHAR(100),
    EmailAddress VARCHAR(100)
);

CALL InsertEmployee(1, 'John Doe', 'john@example.com');
CALL InsertEmployee(1, 'Jane Smith', 'jane@example.com');


#Q13

CREATE TABLE Emp_BIT (
    Name VARCHAR(50),
    Occupation VARCHAR(50),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Robin', 'Scientist', '2020-10-04', 12),
('Warner', 'Engineer', '2020-10-04', 10),
('Peter', 'Actor', '2020-10-04', 13),
('Marco', 'Doctor', '2020-10-04', 14),
('Brayden', 'Teacher', '2020-10-04', 12),
('Antonio', 'Business', '2020-10-04', 11);

select *from emp_bit;

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Santria', 'Scientist', '2020-10-04', -6);


