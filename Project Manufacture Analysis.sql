create Database if not exists Sales;

Use sales;

Create Table Buyers_sales(Buyer_ID varchar(10) Primary key,Buyer_Name Varchar(255),Region varchar(255),Founded_Year year,Segment Varchar(255));
Create Table Customer_sales(Customer_code varchar(20) primary key,Customer_Name Varchar(255),Customer_Type Varchar(255),City Varchar(255),Active Varchar(255));
create table Employee_sales(Employee_code varchar(20) primary key,Employee_Name varchar(255),Department Varchar(255),level Varchar(20));
Create table Operation_Sales(operation_code varchar(20)primary Key,Operation_Name varchar(255),Standard_Cost_Per_Hour int,Is_Automated varchar(10));
Create Table Machine_sales(Machine_code varchar(20) primary Key,Operation_Code varchar(20),Operation_Name varchar(255),Avg_Daily_Cost Double,Machine_Type varchar(20),Status varchar(20),foreign key(Operation_code)
 references Operation_sales(Operation_code));
create table Department_sales(Dept_ID Varchar(20)Primary key,Dept_Name varchar(20),Category varchar(255),Head_count_Range Varchar(20),Floor varchar(20));
Create table Item_Sales(Item_code Varchar(255) primary key,Item_name varchar(255),Department_name varchar(255),item_Category varchar(20));					
Create table Date_sales(Date date primary key,Day Int,Day_name varchar(20),week_num int,month_num int,month_name varchar(20),Quater varchar(20),year year,Is_weekend varchar(10),Season varchar(20));

Create Table Fact_sales
(
Doc_Num double primary key,
Date_FK date,
Buyer_ID Varchar(10),
Customer_Code Varchar(20),
Employee_Code Varchar(10),
Machine_Code Varchar(10),
Operation_Code Varchar(20),
Dept_ID Varchar(10),
Item_Code Varchar(255),
Delivery_Status Varchar(10),
Is_Repeat_Order Varchar(10),
WO_Qty Int,
Press_Qty Int,
Processed_Qty Int,
Produced_Qty Int,
Rejected_Qty Int,
Total_Manufactured_Qty Int,
Total_Qty Int,
Total_Value Double,
Per_Day_Machine_Cost Double,
Rejection_Rate_Pct double,
Efficiency_Rate_Pct Double,
Machine_Utilization_Pct Double,
Cost_per_Unit Double,
Foreign key(Buyer_ID) references Buyers_Sales(Buyer_ID),Foreign key(Customer_code) references Customer_sales(Customer_code),
foreign key(Employee_code) references Employee_sales(Employee_code),foreign key(Machine_code) references machine_sales(machine_code),
foreign key(operation_code) references operation_sales(operation_code),foreign key(Dept_ID) references department_sales(Dept_ID),
foreign key(item_code) references item_sales(Item_code),foreign key (Date_FK) references date_sales(Date)
 );
Select * from Buyers_Sales;
Select * from customer_sales;
select * from employee_sales;
select * from operation_sales;
 Select * from machine_sales;
Select * from department_Sales;
Select * from item_sales;
select * from Date_sales;
 select * from fact_sales;
 
 Show tables;
 SELECT 

f.*, b.buyer_name, c.customer_name, e.employee_name FROM

fact_sales f

join buyers_sales b
on f.buyer_id = b.buyer_id

join customer_sales c
on f.Customer_Code = c.customer_code

join employee_sales e
on f.employee_code = e.employee_code

join date_sales d
on f.Date_FK = d.Date;
 

 ## KPI Queries ##
 ## Produced Qty ##
  Select concat(round(sum(Produced_Qty)/1000000,0),'M') as Produced_Qty
  from fact_sales;
  
 ## Rejected Qty ##
 Select concat(round(Sum(Rejected_Qty)/1000,0),'K') as Rejected_Qty
 from fact_sales;
 
 ## Today Manufactured Qty ##
 select concat(round(sum(Total_manufactured_Qty)/1000000,0),'M') as Manufactured_Qty
 from fact_sales;
 
 ## Wastage Percentage ##
 select concat(round(sum(Rejected_qty)/(sum(Total_manufactured_Qty)-Sum(Rejected_Qty))*100,0),'%')
 as Wastage_percent from fact_sales;
 
 ## Per Unit Cost ##
 select round(sum(per_day_machine_cost)/sum(Total_manufactured_Qty),2) 
 as Per_unit_cost from fact_sales;
 
 ## Rejection Rate ##
 select concat(round(sum(Rejected_Qty)/sum(produced_Qty)*100,2),'%') 
 as Rejection_Rate from fact_sales;
 
 ## EmployeeWise Rejected Qty ##
 
 select e.employee_name,concat(round(sum(f.Rejected_Qty)/1000,0),'K')
 as Rejected_Qty 
 from employee_sales as e join fact_sales as f
 on e.Employee_code=f.Employee_code group by e.Employee_Name;
 
 ## MachineWise Rejected Qty ##
 select machine_code,Sum(Rejected_qty) as Rejected_Qty
 from fact_sales group by machine_code order by Rejected_Qty asc
 limit 10;
 
 ## Production Comparison Trend ##
 select monthname(Date_FK) as Month,concat(round(sum(Produced_qty)/1000000,2),'M') 
 as Produced_Qty,concat(round(sum(Rejected_Qty)/1000,2),'K') as Rejected_Qty
 from fact_sales group by Month order by monthname(Date_Fk);
 
 ## Manufacture Vs Rejected ##
 select m.Machine_Type,concat(round(Sum(f.Rejected_Qty)/1000,0),'K') 
 as Rejected_Quantity,concat(round(sum(f.Processed_Qty)/1000000,0),'M') as Processed_Quantity
 from machine_sales as m join
 fact_sales as f on m.Machine_code=f.Machine_Code group by Machine_Type; 
 
 ## Departmentwise manufactured vs Rejected ##
 
 Select d.dept_name,concat(round(sum(processed_Qty)/1000000,3),'M') 
 as Processed_Quantity,concat(round(Sum(Rejected_Qty)/1000,3),'K')
 as Rejected_Quantity
 from department_sales as d join
 fact_sales as f on d.Dept_ID=f.Dept_ID group by Dept_Name;
 
 ## Machine Utilisation ##
 select m.machine_code,
 round(sum(f.machine_Utilization_Pct),2) as Machine_Utilization_pct from machine_sales as m join fact_sales as f
 on m.Machine_code=f.Machine_Code 
 group by Machine_Code; 
 
 ## Operation wise Avg Cost Per unit ##
 select 
 o.operation_name,round(sum(f.cost_per_unit),2) as Average_cost_per_Unit
 from operation_sales as o join fact_sales as f on
 o.operation_code=f.Operation_Code group by 1;
