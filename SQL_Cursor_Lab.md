# SQL Server Cursor Lab – EMPLOYEE
## Easy Student Version

This lab contains **20 cursor programs** based on the `EMPLOYEE` table.

The goal is to understand the **basic cursor flow** rather than write complicated SQL.

> **Important:** The programs below use the column names mentioned in the lab:
> `EID`, `FirstName`, `LastName`, `Gender`, `Salary`, `JoiningYear`, `Department`, `City`.
> If your actual table uses different column names, replace only those names.

---

# 1. What is a Cursor?

A **cursor** is used when we want to process table records **one row at a time**.

Normally:

```sql
SELECT * FROM EMPLOYEE;
```

returns all rows together.

With a cursor:

```text
First row
   ↓
Second row
   ↓
Third row
   ↓
...
```

So, remember:

**Cursor = Row-by-row processing**

---

# 2. Basic Cursor Structure

Every simple cursor normally follows this order:

```sql
DECLARE CursorName CURSOR FOR
SELECT ...;

OPEN CursorName;

FETCH NEXT FROM CursorName
INTO variables;

WHILE @@FETCH_STATUS = 0
BEGIN

    -- work with current row

    FETCH NEXT FROM CursorName
    INTO variables;

END;

CLOSE CursorName;
DEALLOCATE CursorName;
```

### Easy meaning

| Statement | Meaning |
|---|---|
| `DECLARE` | Create the cursor |
| `OPEN` | Start the cursor |
| `FETCH NEXT` | Take the next row |
| `WHILE` | Continue until rows finish |
| `CLOSE` | Close the cursor |
| `DEALLOCATE` | Remove the cursor |

### Most important flow

```text
DECLARE
   ↓
OPEN
   ↓
FETCH
   ↓
WHILE
   ↓
Work
   ↓
FETCH NEXT
   ↓
No rows left?
   ↓
CLOSE
   ↓
DEALLOCATE
```

---

# Part – A

## 1. Fetch All Rows from EMPLOYEE

### Question

Create a cursor `Employee_Cursor` to fetch all rows from `EMPLOYEE` and display them.

### Easy idea

1. Select all employee columns.
2. Put the values into variables.
3. Print the current employee.
4. Fetch the next employee.
5. Repeat until all rows are finished.

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID, FirstName, LastName, Gender, Salary,
       JoiningYear, Department, City
FROM EMPLOYEE;

DECLARE
    @EID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Gender VARCHAR(10),
    @Salary INT,
    @JoiningYear INT,
    @Department VARCHAR(50),
    @City VARCHAR(50);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @EID, @FirstName, @LastName, @Gender,
     @Salary, @JoiningYear, @Department, @City;

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT CONCAT(
        @EID, ' ',
        @FirstName, ' ',
        @LastName, ' ',
        @Gender, ' ',
        @Salary, ' ',
        @JoiningYear, ' ',
        @Department, ' ',
        @City
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @EID, @FirstName, @LastName, @Gender,
         @Salary, @JoiningYear, @Department, @City;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Remember

`FETCH NEXT` is written **two times**:

- once before `WHILE` to get the first row
- once inside `WHILE` to get the next row

---

# 2. Display All Female Employees

### Easy idea

We only need female employees, so put the condition in the cursor's `SELECT`.

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID, FirstName, LastName
FROM EMPLOYEE
WHERE Gender = 'Female';

DECLARE
    @EID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @EID, @FirstName, @LastName;

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT CONCAT(
        @EID, ' ',
        @FirstName, ' ',
        @LastName
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @EID, @FirstName, @LastName;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Important point

```sql
WHERE Gender = 'Female'
```

filters the records **before the cursor processes them**.

---

# 3. Display `EID_FirstName_LastName`

### Example

```text
101_Hetvi_Patel
```

### Query

```sql
DECLARE Employee_Cursor_Fetch CURSOR FOR
SELECT EID, FirstName, LastName
FROM EMPLOYEE;

DECLARE
    @EID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50);

OPEN Employee_Cursor_Fetch;

FETCH NEXT FROM Employee_Cursor_Fetch
INTO @EID, @FirstName, @LastName;

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT CONCAT(
        @EID, '_',
        @FirstName, '_',
        @LastName
    );

    FETCH NEXT FROM Employee_Cursor_Fetch
    INTO @EID, @FirstName, @LastName;

END;

CLOSE Employee_Cursor_Fetch;
DEALLOCATE Employee_Cursor_Fetch;
```

### Main concept

`CONCAT()` joins values together.

```sql
CONCAT(101, '_', 'Hetvi', '_', 'Patel')
```

gives:

```text
101_Hetvi_Patel
```

---

# 4. Display Employees with Salary Greater Than 12000

### Easy idea

Use:

```sql
WHERE Salary > 12000
```

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT FirstName, LastName, Salary
FROM EMPLOYEE
WHERE Salary > 12000;

DECLARE
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Salary INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @FirstName, @LastName, @Salary;

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT CONCAT(
        @FirstName, ' ',
        @LastName,
        ' Salary = ',
        @Salary
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @FirstName, @LastName, @Salary;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

# 5. Employees Who Joined in 2022 or Later

### Easy idea

2022 or later means:

```sql
JoiningYear >= 2022
```

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT FirstName, LastName, JoiningYear
FROM EMPLOYEE
WHERE JoiningYear >= 2022;

DECLARE
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @JoiningYear INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @FirstName, @LastName, @JoiningYear;

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT CONCAT(
        @FirstName, ' ',
        @LastName,
        ' joined in ',
        @JoiningYear
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @FirstName, @LastName, @JoiningYear;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

# 6. Employee Name with Department Name

### Example

```text
Raj Mehta works in IT Department
```

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT FirstName, LastName, Department
FROM EMPLOYEE;

DECLARE
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Department VARCHAR(50);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @FirstName, @LastName, @Department;

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT CONCAT(
        @FirstName, ' ',
        @LastName,
        ' works in ',
        @Department,
        ' Department'
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @FirstName, @LastName, @Department;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

# 7. Update NULL City to AHMEDABAD

### Easy idea

First find employees whose city is `NULL`.

```sql
WHERE City IS NULL
```

Then update their city.

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID
FROM EMPLOYEE
WHERE City IS NULL;

DECLARE @EID INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @EID;

WHILE @@FETCH_STATUS = 0
BEGIN

    UPDATE EMPLOYEE
    SET City = 'AHMEDABAD'
    WHERE EID = @EID;

    FETCH NEXT FROM Employee_Cursor
    INTO @EID;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Important

For `NULL`, don't write:

```sql
WHERE City = NULL
```

Correct:

```sql
WHERE City IS NULL
```

---

# 8. Display Employee Name with City

### Example

```text
Deep Patel lives in Rajkot
```

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT FirstName, LastName, City
FROM EMPLOYEE;

DECLARE
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @City VARCHAR(50);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @FirstName, @LastName, @City;

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT CONCAT(
        @FirstName, ' ',
        @LastName,
        ' lives in ',
        @City
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @FirstName, @LastName, @City;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

# 9. Delete Employees Whose Salary Is Less Than 5000

### Easy idea

Find employee IDs where salary is below 5000 and delete them one by one.

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID
FROM EMPLOYEE
WHERE Salary < 5000;

DECLARE @EID INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @EID;

WHILE @@FETCH_STATUS = 0
BEGIN

    DELETE FROM EMPLOYEE
    WHERE EID = @EID;

    FETCH NEXT FROM Employee_Cursor
    INTO @EID;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Warning

This permanently deletes the rows.

---

# 10. Display Employees Department-Wise

### Easy idea

Sort employees by department.

```sql
ORDER BY Department
```

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT Department, FirstName, LastName
FROM EMPLOYEE
ORDER BY Department;

DECLARE
    @Department VARCHAR(50),
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @Department, @FirstName, @LastName;

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT CONCAT(
        @Department, ' : ',
        @FirstName, ' ',
        @LastName
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @Department, @FirstName, @LastName;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

# Part – B

# 11. Count Total Employees from Each Department

### Easy idea

First get each different department:

```sql
SELECT DISTINCT Department
```

Then count employees belonging to that department.

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT DISTINCT Department
FROM EMPLOYEE;

DECLARE
    @Department VARCHAR(50),
    @Total INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @Department;

WHILE @@FETCH_STATUS = 0
BEGIN

    SELECT @Total = COUNT(*)
    FROM EMPLOYEE
    WHERE Department = @Department;

    PRINT CONCAT(
        @Department,
        ' Department = ',
        @Total,
        ' employees'
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @Department;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Example output

```text
IT Department = 5 employees
HR Department = 3 employees
ADMIN Department = 4 employees
```

---

# 12. Employees Whose City Starts with R

### Easy idea

Use:

```sql
LIKE 'R%'
```

`R%` means:

> Start with R, followed by anything.

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT FirstName, LastName, City
FROM EMPLOYEE
WHERE City LIKE 'R%';

DECLARE
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @City VARCHAR(50);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @FirstName, @LastName, @City;

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT CONCAT(
        @FirstName, ' ',
        @LastName,
        ' - ',
        @City
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @FirstName, @LastName, @City;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Example

```text
Raj Patel - Rajkot
Ravi Shah - Rajkot
```

---

# 13. Top 3 Highest Salary Employees

### Easy idea

Use:

```sql
TOP 3
ORDER BY Salary DESC
```

`DESC` means highest salary first.

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT TOP 3 FirstName, LastName, Salary
FROM EMPLOYEE
ORDER BY Salary DESC;

DECLARE
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Salary INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @FirstName, @LastName, @Salary;

WHILE @@FETCH_STATUS = 0
BEGIN

    PRINT CONCAT(
        @FirstName, ' ',
        @LastName,
        ' = ',
        @Salary
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @FirstName, @LastName, @Salary;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

# 14. Total Salary Department-Wise

### Example

```text
IT Department total salary = 33000
```

### Easy idea

1. Get each department.
2. Find `SUM(Salary)` for that department.
3. Display the result.

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT DISTINCT Department
FROM EMPLOYEE;

DECLARE
    @Department VARCHAR(50),
    @TotalSalary INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @Department;

WHILE @@FETCH_STATUS = 0
BEGIN

    SELECT @TotalSalary = SUM(Salary)
    FROM EMPLOYEE
    WHERE Department = @Department;

    PRINT CONCAT(
        @Department,
        ' Department total salary = ',
        @TotalSalary
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @Department;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

# 15. Average Salary City-Wise

### Easy idea

1. Get each different city.
2. Calculate `AVG(Salary)` for that city.
3. Display it.

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT DISTINCT City
FROM EMPLOYEE
WHERE City IS NOT NULL;

DECLARE
    @City VARCHAR(50),
    @AverageSalary DECIMAL(10,2);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @City;

WHILE @@FETCH_STATUS = 0
BEGIN

    SELECT @AverageSalary = AVG(Salary)
    FROM EMPLOYEE
    WHERE City = @City;

    PRINT CONCAT(
        @City,
        ' average salary = ',
        @AverageSalary
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @City;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

# Part – C

# 16. Employee Experience Using JOININGYEAR

### Example

```text
Raj Mehta has experience = 4 years
```

### Easy idea

Current year minus joining year:

```text
Experience = Current Year - Joining Year
```

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT FirstName, LastName, JoiningYear
FROM EMPLOYEE;

DECLARE
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @JoiningYear INT,
    @Experience INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @FirstName, @LastName, @JoiningYear;

WHILE @@FETCH_STATUS = 0
BEGIN

    SET @Experience = YEAR(GETDATE()) - @JoiningYear;

    PRINT CONCAT(
        @FirstName, ' ',
        @LastName,
        ' has experience = ',
        @Experience,
        ' years'
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @FirstName, @LastName, @JoiningYear;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Important functions

```sql
GETDATE()
```

gets the current date.

```sql
YEAR(GETDATE())
```

gets the current year.

---

# 17. Employee Full Name with Annual Salary

### Example

```text
Hetvi Patel annual salary = 144000
```

If the `Salary` column stores **monthly salary**, multiply it by 12.

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT FirstName, LastName, Salary
FROM EMPLOYEE;

DECLARE
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Salary INT,
    @AnnualSalary INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @FirstName, @LastName, @Salary;

WHILE @@FETCH_STATUS = 0
BEGIN

    SET @AnnualSalary = @Salary * 12;

    PRINT CONCAT(
        @FirstName, ' ',
        @LastName,
        ' annual salary = ',
        @AnnualSalary
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @FirstName, @LastName, @Salary;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Example

If:

```text
Salary = 12000
```

then:

```text
Annual Salary = 12000 × 12
              = 144000
```

---

# 18. Count Male and Female Employees Separately

### Easy idea

Get each gender and count employees for that gender.

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT DISTINCT Gender
FROM EMPLOYEE;

DECLARE
    @Gender VARCHAR(10),
    @Total INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @Gender;

WHILE @@FETCH_STATUS = 0
BEGIN

    SELECT @Total = COUNT(*)
    FROM EMPLOYEE
    WHERE Gender = @Gender;

    PRINT CONCAT(
        @Gender,
        ' employees = ',
        @Total
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @Gender;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Example output

```text
Male employees = 8
Female employees = 7
```

---

# 19. Employees Whose Salary Is Greater Than Department Average

### Easy idea

For every employee:

1. Find that employee's department.
2. Calculate that department's average salary.
3. Compare employee salary with the average.
4. Display only if employee salary is greater.

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT FirstName, LastName, Department, Salary
FROM EMPLOYEE;

DECLARE
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Department VARCHAR(50),
    @Salary INT,
    @AverageSalary DECIMAL(10,2);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @FirstName, @LastName, @Department, @Salary;

WHILE @@FETCH_STATUS = 0
BEGIN

    SELECT @AverageSalary = AVG(Salary)
    FROM EMPLOYEE
    WHERE Department = @Department;

    IF @Salary > @AverageSalary
    BEGIN

        PRINT CONCAT(
            @FirstName, ' ',
            @LastName,
            ' Salary = ',
            @Salary,
            ' Department Average = ',
            @AverageSalary
        );

    END;

    FETCH NEXT FROM Employee_Cursor
    INTO @FirstName, @LastName, @Department, @Salary;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Main concept

The important part is:

```sql
IF @Salary > @AverageSalary
```

Only employees earning more than their department average are displayed.

---

# 20. Transfer Employees from ADMIN to HR

### Question

Transfer all employees from `ADMIN` department to `HR`.

### Easy idea

Find employees whose department is `ADMIN`.

For each employee:

```sql
UPDATE EMPLOYEE
SET Department = 'HR'
```

### Query

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID
FROM EMPLOYEE
WHERE Department = 'ADMIN';

DECLARE @EID INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @EID;

WHILE @@FETCH_STATUS = 0
BEGIN

    UPDATE EMPLOYEE
    SET Department = 'HR'
    WHERE EID = @EID;

    FETCH NEXT FROM Employee_Cursor
    INTO @EID;

END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Before

```text
EID    Name          Department
101    Raj Mehta     ADMIN
102    Hetvi Patel   ADMIN
103    Ravi Shah     IT
```

### After

```text
EID    Name          Department
101    Raj Mehta     HR
102    Hetvi Patel   HR
103    Ravi Shah     IT
```

---

# Important Cursor Viva Questions

## 1. What is a cursor?

A cursor processes query results **one row at a time**.

---

## 2. Why do we use a cursor?

We use a cursor when we need to perform some operation **row by row**.

---

## 3. What is `DECLARE`?

`DECLARE` creates the cursor.

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT ...
FROM EMPLOYEE;
```

---

## 4. What is `OPEN`?

`OPEN` starts the cursor.

```sql
OPEN Employee_Cursor;
```

---

## 5. What is `FETCH NEXT`?

It gets the **next row** from the cursor.

```sql
FETCH NEXT FROM Employee_Cursor
INTO @Name;
```

---

## 6. What is `@@FETCH_STATUS`?

It tells us whether the last `FETCH` was successful.

```sql
WHILE @@FETCH_STATUS = 0
```

`0` means the row was fetched successfully.

---

## 7. Why do we use `WHILE`?

To continue processing rows until the cursor has no more rows.

---

## 8. What is `CLOSE`?

It closes the cursor after processing.

```sql
CLOSE Employee_Cursor;
```

---

## 9. What is `DEALLOCATE`?

It removes the cursor from memory.

```sql
DEALLOCATE Employee_Cursor;
```

---

## 10. What is the complete cursor flow?

Remember this one line:

```text
DECLARE → OPEN → FETCH → WHILE → FETCH → CLOSE → DEALLOCATE
```

---

# Quick Pattern for All 20 Questions

Most questions follow the same structure:

```sql
DECLARE CursorName CURSOR FOR
SELECT ...
FROM EMPLOYEE
WHERE ...;

DECLARE @Variable ...;

OPEN CursorName;

FETCH NEXT FROM CursorName
INTO @Variable;

WHILE @@FETCH_STATUS = 0
BEGIN

    -- SELECT / PRINT / UPDATE / DELETE / IF

    FETCH NEXT FROM CursorName
    INTO @Variable;

END;

CLOSE CursorName;
DEALLOCATE CursorName;
```

The main thing that changes in each question is the **SELECT condition and the work inside `BEGIN ... END`**.

---

# Student Shortcut

For the lab, remember these 7 steps:

```text
1. DECLARE
2. DECLARE VARIABLES
3. OPEN
4. FETCH
5. WHILE
6. FETCH NEXT
7. CLOSE + DEALLOCATE
```

And remember:

```text
DECLARE  →  Create
OPEN     →  Start
FETCH    →  Get row
WHILE    →  Repeat
CLOSE    →  Stop
DEALLOCATE → Remove
```
