-- Table: Sales
CREATE TABLE Sales (
    sale_id INT,
    emp_id INT,
    sale_amount DECIMAL(10, 2),
    sale_date DATE
);

-- Table: Employees
CREATE TABLE Employees (
    emp_id INT,
    emp_name VARCHAR(50),
    region VARCHAR(50)
);

-- Sample Data
INSERT INTO Employees VALUES
(1, 'Alice', 'North'),
(2, 'Bob', 'South'),
(3, 'Charlie', 'East');

INSERT INTO Sales VALUES
(101, 1, 1000.00, '2024-01-05'),
(102, 1, 2000.00, '2024-01-10'),
(103, 2, 1500.00, '2024-01-07'),
(104, 3, 1800.00, '2024-01-15'),
(105, 2, 1700.00, '2024-01-20'),
(106, 1, 2200.00, '2024-02-05');

--window function: running total by employees
SELECT 
    emp_id,
    sale_date,
    sale_amount,
    SUM(sale_amount) OVER (PARTITION BY emp_id ORDER BY sale_date) AS running_total
FROM Sales;

--Subquery: Employees with Sales Above Average
SELECT emp_id, sale_amount
FROM Sales
WHERE sale_amount > (
    SELECT AVG(sale_amount) FROM Sales
);

--CTE: Monthly Sales Summary by Employee
WITH MonthlySales AS (
    SELECT 
        emp_id,
        CAST(DATEFROMPARTS(YEAR(sale_date), MONTH(sale_date), 1) AS DATE) AS month,
        SUM(sale_amount) AS total_sales
    FROM Sales
    GROUP BY emp_id, YEAR(sale_date), MONTH(sale_date)
)
SELECT 
    e.emp_name,
    ms.month,
    ms.total_sales
FROM MonthlySales ms
JOIN Employees e ON ms.emp_id = e.emp_id;
