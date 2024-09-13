create database Loan;
use Loan;
-- Q1 Write basic SQL queries to select data from the loans table, such as selecting all columns for all records,
-- and specific columns like loan amount and type.
select * from loan_data;
select  LoanAmount,LoanType from loan_data;

-- Q2 sort loans by issue date and filter loans by criteria such as loan type (e.g., Personal, Home).

select * from loan_data where LoanType in ("Personal","Home")
order by IssueDate;

-- Q3 calculate aggregates like the total number of loans, average loan amount, and the maximum and minimum loan amounts.
select * from loan_data;
select count(*) as Total_loan,AVG(LoanAmount) as AvgLoan,MAX(LoanAmount) as Maximum_Loan_amount,
MIN(LoanAmount) as Minimum_loan_Amt
from loan_data;

-- Q4  joining the loans table with a customer table (assuming such a table exists or is created for this task) on the customer ID 
select * from loan_data l 
inner join customer c
on l.Customer_ID=c.Customer_ID;

-- Q5 view for all active loans.
create view  All_active_loan as
select * from loan_data
where LoanStatus  = "Approved";

select * from All_active_loan;
drop view All_active_loan;

-- Intermediate Level task
-- Q1.finding the average loan amount for each type of loan or identifying customers with loans in more than one category
select * from loan_data;
select LoanType,CustomerAgeGroup,AVG(LoanAmount) as Avg_Loan_amt 
from loan_data
group by LoanType,CustomerAgeGroup 
order by LoanType;

-- Q2.Group data by various attributes such as loan type or region, and use the HAVING clause to filter groups based on aggregate conditions,
-- like regions with average loan amounts above a certain threshold.
select  LoanType,Region, AVG(LoanAmount) as AvgLoan from loan_data
group by LoanType,Region
having AvgLoan > 24000;
 
 
call loandata;
call loantype_parameter("Education");
call loantype_parameter("Home");
call Loan_status;

-- Q3 Create Index views
create index idx_LoanAmount on loan_data(LoanAmount);
explain select * from loan_data where LoanAmount>30000;
select * from loan_data;

-- create temprory table

create temporary table temp1(LoanType varchar(50),
AvgLoanAmount int,
MaxLoanAmount int,
MinLoanAmout int
);

 -- insert the value

insert into temp1 (LoanType,AvgLoanAmount,MaxLoanAmount,MinLoanAmout)
select LoanType,
AVG(LoanAmount) AS AvgLoanAmount, 
MAX(LoanAmount) AS MaxLoanAmount, 
MIN(LoanAmount) AS MinLoanAmont
FROM loan_data
GROUP BY LoanType;

drop table temp1;

select * from temp1;
 
-- Q5. Implement CASE statements in SQL to perform conditional logic,such as categorizing loan risk based on  repayment terms.

select * from loan_data;
SELECT 
 LoanID,Term (months),
CASE
    WHEN Term (months) <= 12 THEN "short-term"
    WHEN Term (months) Between 13 AND 36 THEN "Medium-term"
    ELSE "Long-term"
END AS Loan_risk
FROM  loan_data;

SELECT
LoanID,
PaymentStatus,
CASE
	WHEN PaymentStatus = 'Delinquent' THEN 'Medium Risk'
	WHEN PaymentStatus = 'Paid' THEN 'Low-Risk'
	WHEN PaymentStatus = 'Unpaid' THEN 'High-Risk'
	ELSE 'NA'
END AS payment_status_category
FROM
loan_data;
-- Conduct sophisticated analyses to understand financial trends and customer behaviors over time.
-- Use window functions for advanced analytics, like running totals, moving averages, 
-- or ranking loans within each category by size or interest rate.

select * from Loan_data;
-- Running Total
SELECT 
    LoanID,
    LoanType,
    LoanAmount,
    SUM(LoanAmount) OVER (PARTITION BY LoanType ORDER BY LoanID) AS RunningTotal
FROM 
    Loan_data;
-- Moving Average    
SELECT 
    LoanID,
    LoanType,
    LoanAmount,
    AVG(LoanAmount) OVER (PARTITION BY LoanType ORDER BY LoanID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAverage
FROM 
    Loan_data;

-- Ranking Loans by Size or Interest Rate
SELECT 
    LoanID,
    LoanType,
    LoanAmount,
    InterestRate,
    RANK() OVER (PARTITION BY LoanType ORDER BY LoanAmount DESC) AS RankBySize,
    RANK() OVER (PARTITION BY LoanType ORDER BY InterestRate DESC) AS RankByInterestRate
FROM 
    Loan_data;


 