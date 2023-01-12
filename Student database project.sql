Select * 
From StudentDatabase.dbo.Student_Admission

Insert into Student_Admission values
(015 , 'Ajay' ,'Sharma',12,'Male','12-June-2014'),
(251 ,'Maria','Gonsalves',10,'Female','24-June-2016'),
(345 , 'Pam', 'Spectre' ,15,'Female' ,' 02-July-2011'),
(365 ,'Ram','Sharma',15,'Male','26-June-2011'),
(372 ,'Azaan' , 'Pathan',10,'Male','04-July-2016'),
(432 ,'Harry', 'Geller',12,'Male','25-June-2014'),
(437,'Michelle','Turner',12,'Female','26-June-2014'),
(456,'Melissa','Cooper',15,'Female','07-July-2011'),
(501,'George','Pritchett',10,'Male','05-July-2016')

Select *
From Student_Data

Insert into Student_Data values
(010,'Anil','Kumar',7,92,94,91,93),
(015 , 'Ajay' ,'Sharma',7,92,95,94,97),
(251 ,'Maria','Gonsalves',5,87,89,86,85),
(345 , 'Pam', 'Spectre' ,10,89,92,94,87),
(365 ,'Ram','Sharma',10,87,89,94,95),
(372 ,'Azaan' , 'Pathan',5,90,92,91,95),
(432 ,'Harry', 'Geller',7,94,95,93,96),
(437,'Michelle','Turner',7,92,94,95,96),
(456,'Melissa','Cooper',10,94,95,92,93),
(501,'George','Pritchett',5,89,92,93,87)

Select Distinct (Age)
From StudentDatabase.dbo.Student_Admission

Select Distinct (Class)
From StudentDatabase.dbo.Student_Data

Select Count(AdmnNumber) as TotalStudents
From StudentDatabase.dbo.Student_Admission
Where Age=10

Select Count(AdmnNumber) as TotalStudents
From StudentDatabase.dbo.Student_Admission
Where Age=12


Select Count(AdmnNumber) as TotalStudents
From StudentDatabase.dbo.Student_Admission
Where Age=15

Select *
From StudentDatabase.dbo.Student_Data
Where Class=10 and Maths_Marks>=89


Select *
From StudentDatabase.dbo.Student_Data
Where Class=10 or Maths_Marks>=89

---Accidentally I had written duplicate rows, this is one of the simplest ways I found to remove dulicate rows
Truncate Table StudentDatabase.dbo.Student_Admission

Select * 
From StudentDatabase.dbo.Student_Admission

Alter Table StudentDatabase.dbo.Student_Admission
Drop Column UniqueId;

Insert into StudentDatabase.dbo.Student_Admission values
(015 , 'Ajay' ,'Sharma',12,'Male','12-June-2014'),
(251 ,'Maria','Gonsalves',10,'Female','24-June-2016'),
(345 , 'Pam', 'Spectre' ,15,'Female' ,' 02-July-2011'),
(365 ,'Ram','Sharma',15,'Male','26-June-2011'),
(372 ,'Azaan' , 'Pathan',10,'Male','04-July-2016'),
(432 ,'Harry', 'Geller',12,'Male','25-June-2014'),
(437,'Michelle','Turner',12,'Female','26-June-2014'),
(456,'Melissa','Cooper',15,'Female','07-July-2011'),
(501,'George','Pritchett',10,'Male','05-July-2016')

Truncate Table StudentDatabase.dbo.Student_Data

Select * 
From StudentDatabase.dbo.Student_Data

Insert into Student_Data values
(010,'Anil','Kumar',7,92,94,91,93),
(015 , 'Ajay' ,'Sharma',7,92,95,94,97),
(251 ,'Maria','Gonsalves',5,87,89,86,85),
(345 , 'Pam', 'Spectre' ,10,89,92,94,87),
(365 ,'Ram','Sharma',10,87,89,94,95),
(372 ,'Azaan' , 'Pathan',5,90,92,91,95),
(432 ,'Harry', 'Geller',7,94,95,93,96),
(437,'Michelle','Turner',7,92,94,95,96),
(456,'Melissa','Cooper',10,94,95,92,93),
(501,'George','Pritchett',5,89,92,93,87)

---- Now, moving on

Select *
From StudentDatabase.dbo.Student_Admission
Where LastName like '%S%v%'

Select *
From StudentDatabase.dbo.Student_Admission
Where LastName IN ('Sharma','Geller','Pritchett')

Select Maths_Marks , Count(AdmnNumber) as TotalNum
From StudentDatabase.dbo.Student_Data
Group by Maths_Marks

Select Age ,Count(AdmnNumber) as TotalNum
From StudentDatabase.dbo.Student_Admission
Group by Age

Select Maths_Marks,Science_Marks,COUNT(AdmnNumber) as TotalNumber
From StudentDatabase.dbo.Student_Data
Group by Maths_Marks,Science_Marks

--How many 15 year old students got maths marks above 85 and who are they

Select data.FirstName,data.LastName,Maths_Marks,COUNT(data.AdmnNumber) as TotalNumber
From StudentDatabase.dbo.Student_Data as data
Full Outer Join StudentDatabase.dbo.Student_Admission as Admn
on data.AdmnNumber = Admn.AdmnNumber
where Maths_Marks >85 and Age =15
Group by Maths_Marks,data.FirstName,data.LastName
Order by Maths_Marks desc

---which 15year old got the highest marks in maths
---my approach would be to first arrange all marks in descending order to get a look a who scred the ighest marks
---then search for the 2nd highest person

Select *
From StudentDatabase.dbo.Student_Data
where Class=10
Order by Maths_Marks desc

Select *
From StudentDatabase.dbo.Student_Data
where Maths_Marks <>94 and Class = 10
order by Maths_Marks desc

---Suppose we want to find out the average marks in maths in class 10
Select Class, AVG(Maths_Marks) as Avg_Maths
From StudentDatabase.dbo.Student_Data
where class=10
Group by Class

---Suppose we want to find average marks in maths for all classes
Select Class, Avg(Maths_Marks) as Avg_Maths
From StudentDatabase.dbo.Student_Data
Group by Class

---Difference between Joins and Union
--Join
Select *
From StudentDatabase.dbo.Student_Admission as adm
Full Outer Join StudentDatabase.dbo.Student_Data as data
On adm.AdmnNumber=data.AdmnNumber
--Joins need at least 1 common coloumn between 2 tables. Also, their output will duplicate the common coloumns

--Union (it combines 2 tables into 1 table)
--Union do not need any common coloumn and no duplication, but it requires same number of coloumns and same type of data in
--corresponding coloumn
Select *
From StudentDatabase.dbo.Student_Admission
Union
Select *
From StudentDatabase.dbo.Student_Data
--Here, union did not work because the 2 tables did not have the same number of coloumns. Hence, couldn't be combined using union

----Suppose I want that any student who has scored >90 in Maths_Marks should be rated as Above_Avg
----Here, I will use case statement

Select AdmnNumber,FirstName,LastName,Class,Maths_Marks,
Case 
When Maths_Marks>90 then 'Above Average'
Else 'Average'
End as StudentType
From StudentDatabase.dbo.Student_Data
Order by Class desc , Maths_Marks desc

---Suppose I want to distribute students into advance classes and average classes based on their science and maths marks
---Advance classes will have students with Maths marks>90 and Science marks >93 (will use case statements)


Select *
From StudentDatabase.dbo.Student_Data
Select *
From StudentDatabase.dbo.Student_Admission

Select AdmnNumber,FirstName,LastName,Class,
Case
When Maths_Marks >90 and Science_Marks>93 Then 'Advance Class'
Else 'Average Class'
End as ClassType
From StudentDatabase.dbo.Student_Data
Order by Class desc

---Suppose we want to see how many students scored >93 in Science (using where function)
Select AdmnNumber,Class,Science_Marks
From StudentDatabase.dbo.Student_Data
Where Science_Marks>93

---Group By vs Partition By 
Select Class, Count(Class) as TotalStudents
From StudentDatabase.dbo.Student_Data
Group by Class

Select AdmnNumber,FirstName,LastName,Class, 
Count(Class) Over(Partition By Class) as TotalStudents 
From StudentDatabase.dbo.Student_Data

---Suppose we wish to see how many students in each class have scored >93 in science marks and what are their details
Select AdmnNumber,FirstName,LastName,Class,
COUNT(Class) Over(Partition By Class) as TotalStudents
From StudentDatabase.dbo.Student_Data
Where Science_Marks>93


---Suppose we wish to see how many students in each class have scored >93 in science marks & more than 88 in maths marks
---and what are their details
Select AdmnNumber,FirstName,LastName,Science_Marks, Maths_Marks ,Class,
Count(Class) over(Partition By Class) as Total_Count
From StudentDatabase.dbo.Student_Data
Where Science_Marks>93 or Maths_Marks>88

---Common Table Expressions/With Queries
---They are useful in cases where I want to query off of data from a separate table which is not an original table.
---For eg - in above query , I have created a separate table based on Science and Maths Marks. Suppose , later I want to run a query
---only on the data present in this table, then I don't have to write the code for the table again, I can simply use With Queries

With CTE_Student as 
(Select AdmnNumber,FirstName,LastName,Science_Marks, Maths_Marks ,Class,
Count(Class) over(Partition By Class) as Total_Count
From StudentDatabase.dbo.Student_Data
Where Science_Marks>93 or Maths_Marks>88
) 
Select AdmnNumber
From CTE_Student
---shows only the admission numbers contained within the CTE


