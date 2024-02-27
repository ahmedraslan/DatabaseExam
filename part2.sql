

---1.Write a query that displays Full name of an employee who has more than 3 letters in his/her First Name--

select concat(Fname,' ',Lname) [Full Name]
from Employee
where  len(Fname) > 3

---2.Write a query to display the total number of Programming books available in the library with alias name ‘NO OF PROGRAMMINGBOOKS’---

select count(b.Cat_id) as [No Of Programming Books]
from Book b,Category c
where b.Cat_id = c.Id
and c.Cat_name = 'programming'

---3.Write a query to display the number of books published by (HarperCollins) with the alias name 'NO_OF_BOOKS'---

select count(b.Cat_id) as [No Of Books]
from Book b,Publisher p
where b.Publisher_id = p.Id
and p.Name = 'HarperCollins'

---4.Write a query to display the User SSN and name, date of borrowing and due date of the User whose due date is before July 2022----

select u.SSN,u.User_Name,b.Borrow_date,b.Due_date
from Users u,Borrowing b
where u.SSN = b.User_ssn and b.Due_date < cast('2022-07-01' as date)

---5.Write a query to display book title, author name and display in the following format,' [Book Title] is written by [Author Name].---

select b.Title,'is written by ',a.Name
from Book b,book_Author ba,Author a
where b.Id = ba.Book_id and a.Id = ba.Author_id

---6.Write a query to display the name of users who have letter 'A' in their names.---

select User_Name
from Users
where User_Name like '%A%'

---7.Write a query that display user SSN who makes the most borrowing---

select top(1) u.SSN,count(u.SSN) NumOfBorrowing
from Users u,Borrowing b
where u.SSN = b.User_ssn 
group by u.SSN
order by count(u.SSN) desc

---8.Write a query that displays the total amount of money that each user paid for borrowing books.---

select  u.SSN,sum(b.Amount) as TotalAmount
from Users u,Borrowing b
where u.SSN = b.User_ssn 
group by u.SSN

---9.write a query that displays the category which has the book that has the minimum amount of money for borrowing.---

select top(1) c.Cat_name,b.Title,r.Amount
from book b,Category c,Borrowing r
where b.Cat_id = c.Id and b.Id = r.Book_id
order by r.Amount

---10.write a query that displays the email of an employee if it's not found, display address if it's not found, display date of birthday---

select isnull(Email,isnull(Address,isnull(DOB,' ')))
from Employee

---11.Write a query to list the category and number of books in each category with the alias name 'Count Of Books'.---

select c.Cat_name,count(b.Id) as CountOfBooks
from Category c,Book b
where c.Id = b.Cat_id
group by c.Cat_name

---12.Write a query that display books id which is not found in floor num = 1 and shelf-code = A1.---

select b.Id
from Book b,Shelf s
where b.Shelf_code = 'A1' and s.Floor_num = 1 and b.Shelf_code = s.Code

---13.Write a query that displays the floor number , Number of Blocks and number of employees working on that floor.---

select f.Number,f.Num_blocks,count(emp.Id) as NumOfEmployees
from Employee emp,Floor f
where emp.Floor_no = f.Number
group by f.Number,f.Num_blocks

---14.Display Book Title and User Name to designate Borrowing that occurred within the period ‘3/1/2022’ and ‘10/1/2022’---

select b.Title,u.User_Name
from book b,Users u,Borrowing r
where b.Id = r.Book_id and u.SSN = r.User_ssn and Borrow_date between '3/1/2022' and '10/1/2022' 

---15.Display Employee Full Name and Name Of his/her Supervisor as Supervisor Name

select concat(emp.Fname,' ',emp.Lname) [FullName],super.Fname [Supervisor]
from Employee emp inner join Employee super
on super.Super_id = emp.Id

---16.Select Employee name and his/her salary but if there is no salary display Employee bonus.---

select concat(Fname,' ',Lname),isnull(salary,Bouns)
from Employee

---17.Display max and min salary for Employees---

select max(salary) [MaxSalary],min(Salary) [MinSalary]
from Employee

---18.Write a function that take Number and display if it is even or odd---

create or alter function CheckNum(@num int)
returns varchar(50)
with encryption
as
begin
	declare @check varchar(50)
	set @check = @num%2
	if @num%2 = 0
	set @check = 'Even'
	else 
	set @check = 'Odd'
	return @check
end

	select dbo.CheckNum(6)

---19.write a function that take category name and display Title of books in that category---

create or alter function GetTitleOfBook(@cat varchar(50))
returns @table table
(
	BookTitle varchar(50),
	CatName varchar(50)
)
as
	begin
	insert into @table
	select b.Title,c.Cat_name
	from book b,Category c
	where c.Cat_name = @cat and b.Cat_id = c.Id
	group by b.Title,c.Cat_name
	return
	end
	-- there is another method using inline function
		select * from dbo.GetTitleOfBook('programming')

---20.write a function that takes the phone of the user and displays Book Title ,user-name, amount of money and due-date.---

create or alter function DisplayUserAndBook(@phNum varchar(11))
returns table
as
	return (
	select b.Title,us.User_Name,r.Amount,r.Due_date
	from book b,User_phones u,Users us,Borrowing r
	where  us.SSN = u.User_ssn and r.Book_id = b.Id
	and u.User_ssn = r.User_ssn and u.Phone_num = @phNum
	)
		
		select * from dbo.DisplayUserAndBook('0102585555')

---21.Write a function that take user name and check if it's duplicated ---

create or alter function CheckDuplicate (@UsName varchar(50))
returns varchar(50)
begin
	declare @msg varchar(50), @count int
	select @count = count(u.User_Name)
	from users u
	where u.User_Name = @UsName
	if  (@count > 1)
		select @msg = concat(@UsName,' is repeated ',@count,' times')
	else if (@count = 1)
		set @msg = 'Duplicated'
	else
		set @msg = 'Not Found'
		return @msg
end

	select dbo.CheckDuplicate('Amr Ahmed')

---22.Create a scalar function that takes date and Format to return Date With That Format.---

create function DateAndFormat(@date date,@format int)
returns varchar(50)
as
begin
	return convert(varchar(50),@date,@format)
end

	select dbo.DateAndFormat(getdate(),111)
		
---23.Create a stored procedure to show the number of books per Category---

create or alter procedure sp_BooksPerCategory @CatName varchar(20)
as
	select c.Cat_name,count(b.Id)
	from book b,category c
	where b.Cat_id = c.Id and c.Cat_name = @CatName
	group by c.Cat_name

		sp_BooksPerCategory 'mathematics'

/*24.Create a stored procedure that will be used in case there is an old manager
who has left the floor and a new one becomes his replacement. The
procedure should take 3 parameters (old Emp.id, new Emp.id and the
floor number) and it will be used to update the floor table.
*/

create procedure sp_OldNewEmployee @OldId int,@NewId int,@FNum int
as
	update Floor
	set MG_ID = @NewId
	where MG_ID = @OldId and number = @FNum

	sp_OldNewEmployee 1,222,3

---25.Create a view AlexAndCairoEmp that displays Employee data for users who live in Alex or Cairo.---

create view AlexAndCairoEmp
as
	select *
	from Employee
	where Address = 'Alex' or Address = 'cairo'

	select * from AlexAndCairoEmp

---26.create a view "V2" That displays number of books per shelf---

create view V2
as
	select s.Code,count(b.Id) as NumOfBooks
	from book b,shelf s
	where b.Shelf_code = s.Code
	group by s.Code

	select * from V2

---27.create a view "V3" That display the shelf code that have maximum number of books using the previous view "V2"

create or alter view V3
as
	select top(1) *
	from V2
	order by v2.NumOfBooks desc

	select * from V3

/*
	28.Create a table named ‘ReturnedBooks’ With the Following Structure :
		(UserSSN, BookId, DueDate, ReturnDate,fees)
	then create A trigger that instead of inserting the data of returned book
	checks if the return date is the due date or not if not so the user must pay
	a fee and it will be 20% of the amount that was paid before.
*/

create table ReturnedBooks
(
	UserSSN varchar(50),
	BookID int,
	DueDate date,
	ReturnDate date,
	fees money
)

create trigger tri_books
on ReturnedBooks
instead of insert
as
	declare @duedate2 date,@duedate date,@amount int,
			@fees int,@userid int,@bookid int

		select @returndate = ReturnDate,@duedate = DueDate,@amount = fees,@userid = UserSSN,@bookid = BookID
		from inserted 

	if @duedate2 != @duedate
		insert into ReturnedBooks
		values(@UserSSN,@BookID,@DueDate,@ReturnDate,@amount * 0.2)
	


/*
	29.In the Floor table insert new Floor With Number of blocks 2 , employee
	with SSN = 20 as a manager for this Floor,The start date for this manager
	is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5)
	moved to be the manager of the new Floor (id = 6), and they give Mr. Ali
	Mohamed(his SSN =12) His position
*/

insert into Floor
values(7,2,20,'2023-12-20')


update Floor
set MG_ID = 12
where MG_ID = 5

update Floor
set MG_ID = 5
where MG_ID = 2

/*
	30.Create view name (v_2006_check) that will display Manager id, Floor
	Number where he/she works , Number of Blocks and the Hiring Date
	which must be from the first of March and the end of December
	2022.this view will be used to insert data so make sure that the coming
	new data must match the condition then try to insert this 2 rows and
	Mention What will happen
*/

create view v_2006_check
as
	select f.MG_ID,f.Number,f.Num_blocks,f.Hiring_Date
	from Employee emp,Floor f,Borrowing b
	where emp.Floor_no = f.Number and b.Emp_id = emp.Id
	and f.Hiring_Date between '2022-03-01' and '2022-12-31'
	with check option

	select * from v_2006_check

	insert into v_2006_check
	values(2,6,2,'7-8-2023'),(4,7,1,'4-8-2022') -- invalid: Cannot insert duplicate key in object 'dbo.Floor'.

/*
	31.Create a trigger to prevent anyone from Modifying or Delete or Insert in
	the Employee table ( Display a message for user to tell him that he can’t
	take any action with this Table)
*/

create trigger preventModifying
on Employee
instead of update,delete,insert
as
	print 'you can’t take any action with this table'
	

	insert into Employee(Id,Fname,Address)
	values(7777,'Ahmed','cairo')

/*
	32.Testing Referential Integrity , Mention What Will Happen When:
	A. Add a new User Phone Number with User_SSN = 50 in User_Phones Table 
	B. Modify the employee id 20 in the employee table to 21 
	C. Delete the employee with id 1 
	D. Delete the employee with id 12 
	E. Create an index on column (Salary) that allows you to cluster the data in table Employee.
*/
--a--

insert into User_phones(User_ssn) 
values(50)  --Cannot insert the value NULL into column 'Phone_num'

--b--

update Employee
set Id = 21
where Id = 20 --you can’t take any action with this table

--c-- 

delete from Employee
where Id = 1

--d--
delete from Employee
where Id = 12	

--you can’t take any action with this table

--e--

create clustered index EmpIndex
on Employee(Salary)   
							-- Cannot create more than one clustered index on table 
							-- first we must drop the clustered index which on PK then
							-- we can create cluster on hiredate column.

/*
	33.Try to Create Login With Your Name And give yourself access Only to
	Employee and Floor tables then allow this login to select and insert data
	into tables and deny Delete and update
*/

create schema exam

alter schema exam
transfer Employee

alter schema exam
transfer Floor
					  