Create database Bank_loan ;
use Bank_loan;

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

select * from Finance_1;
CREATE TABLE Finance_1 (
    id BIGINT PRIMARY KEY,
    member_id BIGINT,
    loan_amnt INT,
    funded_amnt INT,
    funded_amnt_inv DECIMAL(12,2),
    term VARCHAR(20),
    int_rate VARCHAR(10),
    installment DECIMAL(10,2),
    grade CHAR(1),
    sub_grade VARCHAR(5),
    emp_title VARCHAR(255),
    emp_length VARCHAR(50),
    home_ownership VARCHAR(30),
    annual_inc DECIMAL(15,2),
    verification_status VARCHAR(50),
    issue_d VARCHAR(20),
    loan_status VARCHAR(100),
    pymnt_plan CHAR(1),
    `desc` TEXT,
    purpose VARCHAR(100),
    title VARCHAR(255),
    zip_code VARCHAR(10),
    addr_state CHAR(2),
    dti DECIMAL(10,2)
);


--  Bluk insert query ( from fanance_1 ) 

LOAD DATA LOCAL INFILE 
'C:/Users/Kunal Khapekar/Desktop/Kunal K K/KK Details/New folder/Data Analyst content/SQL/SQL project/Finance_1.csv'
INTO TABLE Finance_1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

select count(*) from Finance_2;

create table Finance_2 (
    id BIGINT PRIMARY KEY,
    delinq_2yrs INT,
    earliest_cr_line VARCHAR(20),
    inq_last_6mths INT,
    mths_since_last_delinq DECIMAL(10,2) NULL,
    mths_since_last_record DECIMAL(10,2) NULL,
    open_acc INT,
    pub_rec INT,
    revol_bal BIGINT,
    revol_util VARCHAR(20),
    total_acc INT,
    initial_list_status CHAR(1),
    out_prncp DECIMAL(15,2),
    out_prncp_inv DECIMAL(15,2),
    total_pymnt DECIMAL(15,2),
    total_pymnt_inv DECIMAL(15,2),
    total_rec_prncp DECIMAL(15,2),
    total_rec_int DECIMAL(15,2),
    total_rec_late_fee DECIMAL(15,2),
    recoveries DECIMAL(15,2),
    collection_recovery_fee DECIMAL(15,2),
    last_pymnt_d VARCHAR(20),
    last_pymnt_amnt DECIMAL(15,2),
    next_pymnt_d VARCHAR(20),
    last_credit_pull_d VARCHAR(20)
);


SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

--  Bluk insert query ( from fanance_2 ) 

LOAD DATA LOCAL INFILE 
'C:/Users/Kunal Khapekar/Desktop/Kunal K K/KK Details/New folder/Data Analyst content/SQL/SQL project/Finance_2.csv'
INTO TABLE finance_2
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

 -- Project 1: Loan Portfolio Health Analysis
-- Business Problem

--  1.	Total Loan Amount Disbursed? 
select sum(loan_amnt )_Total_loanAmt from finance_1 ;

-- 2.	Total Customers? 
 select distinct count(member_id) Total_customer from finance_1;
 
 --  3.	Average Interest Rate? 
 select avg(int_rate) Avg_int from finance_1; 
 
 -- 4.	Fully Paid vs Charged Off Loan %? 
 select loan_status , count(*) from finance_1 
 where loan_status in ("Fully Paid" , "Charged Off") 
 group by loan_status ;
 
select 
round(
		sum(case when loan_status ='Fully Paid' then 1 else 0 end ) * 100 / count(*) , 2
	) as fully_paid_per,

round(
		sum(case when loan_status ='Charged Off' then 1 else 0 end ) * 100 / count(*) , 2
	) as fully_paid_per
    
    from finance_1 ;
    
    
    -- 5.	Which loan grade has the highest default rate? 
    
   select grade , count(*) from finance_1
   where loan_status = 'Charged Off'
   group by grade order by count(*) desc  limit 1 ;
   
   
   select grade, count(*) as Total_loan, sum( case when loan_status = 'Charged Off' then 1 else 0 end ) as charge_off_loan,
   round(
		sum( case when loan_status ='Charged Off' then 1 else 0 end) * 100 / count(*) , 2 
        ) as per_default_rate from finance_1
        group by grade 
        order by per_default_rate desc
        Limit 1;
    
	-- 6.	Which state contributes the most loan amount? 
    
    select addr_state, sum(loan_amnt) as total_loan_amt from finance_1
    group by addr_state 
    order by total_loan_amt desc
    limit 1	;
    
    
    
    select addr_state, sum(loan_amnt) as total_loan_amt, 
    round( sum(loan_amnt)* 100 / (select sum(loan_amnt)from finance_1 ) ,2 )
    as total_loan_amt from finance_1
    group by addr_state 
    order by total_loan_amt desc
    limit 1;
     
    --  7.	Which loan purpose has the highest funding?  
    
    select purpose, sum(loan_amnt) as total_loan_amt from finance_1
    group by purpose
    order by total_loan_amt desc
    Limit 1 ;
    
    select purpose, sum(loan_amnt) as total_loan_amt,
    round( sum(loan_amnt) * 100 / ( select sum(loan_amnt) from finance_1),2 
    ) as loan_percent     
    from finance_1
    group by purpose
    order by total_loan_amt desc
    Limit 1 ;
    
    -- A senior analyst might use a window function:

SELECT
    purpose,
    SUM(loan_amnt) AS total_loan_amt,
    ROUND(
        SUM(loan_amnt) * 100.0 /
        SUM(SUM(loan_amnt)) OVER (),
        2
    ) AS loan_percent
FROM finance_1
GROUP BY purpose
ORDER BY total_loan_amt DESC;
    
-- 8.	What is the portfolio risk by grade (A-G)? 

    select grade , count(*) as Total_loan ,
    sum(case when loan_status = 'Charged Off' then 1 else 0 end ) as default_loan ,
    round(
		sum( case when loan_status = 'Charged Off' then 1 else 0 end ) * 100 / count(*) ,2 ) as default_per
        from finance_1
        group by grade 
        order by grade desc;

 
 


 



