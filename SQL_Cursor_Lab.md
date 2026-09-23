# SQL Server Cursor Lab – EMPLOYEE

## Introduction

A **cursor** in SQL Server is used to process query results **row by row**.

Cursors are useful for learning row-by-row processing and for situations where each row needs individual handling.

> **Note:** The queries below assume the `EMPLOYEE` table contains columns such as:
>
> `EID`, `FirstName`, `LastName`, `Gender`, `Salary`, `JoiningYear`, `Department`, and `City`.
>
> If your actual column names are different, replace them accordingly.

---

# Cursor Syntax

```sql
DECLARE cursor_name CURSOR FOR
SELECT column1, column2
FROM EMPLOYEE;

OPEN cursor_name;

FETCH NEXT FROM cursor_name
INTO @variable1, @variable2;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Process current row

    FETCH NEXT FROM cursor_name
    INTO @variable1, @variable2;
END;

CLOSE cursor_name;
DEALLOCATE cursor_name;
```

### Important Cursor Statements

| Statement | Purpose |
|---|---|
| `DECLARE` | Creates the cursor |
| `OPEN` | Opens the cursor and starts processing |
| `FETCH NEXT` | Gets the next row |
| `@@FETCH_STATUS` | Checks whether the last fetch was successful |
| `CLOSE` | Closes the cursor |
| `DEALLOCATE` | Removes the cursor from memory |

---

# Part – A

## 1. Display All Employees

Create a cursor `Employee_Cursor` to fetch all rows from the `EMPLOYEE` table and display them.

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID, FirstName, LastName, Gender, Salary, JoiningYear, Department, City
FROM EMPLOYEE;

DECLARE
    @EID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Gender VARCHAR(10),
    @Salary DECIMAL(10,2),
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

---

## 2. Display All Female Employees

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
    PRINT CONCAT(@EID, '_', @FirstName, '_', @LastName);

    FETCH NEXT FROM Employee_Cursor
    INTO @EID, @FirstName, @LastName;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

## 3. Display Employee in `EID_FirstName_LastName` Format

Example:

```text
101_Hetvi_Patel
```

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
    PRINT CONCAT(@EID, '_', @FirstName, '_', @LastName);

    FETCH NEXT FROM Employee_Cursor_Fetch
    INTO @EID, @FirstName, @LastName;
END;

CLOSE Employee_Cursor_Fetch;
DEALLOCATE Employee_Cursor_Fetch;
```

---

## 4. Display Employees with Salary Greater Than 12000

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID, FirstName, LastName, Salary
FROM EMPLOYEE
WHERE Salary > 12000;

DECLARE
    @EID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Salary DECIMAL(10,2);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @EID, @FirstName, @LastName, @Salary;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT CONCAT(@FirstName, ' ', @LastName, ' = ', @Salary);

    FETCH NEXT FROM Employee_Cursor
    INTO @EID, @FirstName, @LastName, @Salary;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

## 5. Display Employees Who Joined in 2022 or Later

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID, FirstName, LastName, JoiningYear
FROM EMPLOYEE
WHERE JoiningYear >= 2022;

DECLARE
    @EID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @JoiningYear INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @EID, @FirstName, @LastName, @JoiningYear;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT CONCAT(
        @FirstName, ' ',
        @LastName,
        ' joined in ',
        @JoiningYear
    );

    FETCH NEXT FROM Employee_Cursor
    INTO @EID, @FirstName, @LastName, @JoiningYear;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

## 6. Display Employee Name with Department Name

Example:

```text
Raj Mehta works in IT Department
```

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

## 7. Update NULL City to AHMEDABAD

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID
FROM EMPLOYEE
WHERE City IS NULL;

DECLARE @EID INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor INTO @EID;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE EMPLOYEE
    SET City = 'AHMEDABAD'
    WHERE EID = @EID;

    FETCH NEXT FROM Employee_Cursor INTO @EID;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

## 8. Display Employee Name with City

Example:

```text
Deep Patel lives in Rajkot
```

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

## 9. Delete Employees Whose Salary Is Less Than 5000

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID
FROM EMPLOYEE
WHERE Salary < 5000;

DECLARE @EID INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor INTO @EID;

WHILE @@FETCH_STATUS = 0
BEGIN
    DELETE FROM EMPLOYEE
    WHERE EID = @EID;

    FETCH NEXT FROM Employee_Cursor INTO @EID;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

> **Warning:** This query permanently deletes matching rows. Use a backup/test table while practicing.

---

## 10. Display Employees Department-Wise

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

## 11. Count Total Employees from Each Department

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT DISTINCT Department
FROM EMPLOYEE;

DECLARE
    @Department VARCHAR(50),
    @TotalEmployees INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor INTO @Department;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @TotalEmployees = COUNT(*)
    FROM EMPLOYEE
    WHERE Department = @Department;

    PRINT CONCAT(
        @Department,
        ' Department = ',
        @TotalEmployees,
        ' employees'
    );

    FETCH NEXT FROM Employee_Cursor INTO @Department;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

## 12. Display Employees Whose City Starts with `R`

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

---

## 13. Display Top 3 Highest Salary Employees

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT TOP 3 FirstName, LastName, Salary
FROM EMPLOYEE
ORDER BY Salary DESC;

DECLARE
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Salary DECIMAL(10,2);

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

## 14. Calculate Total Salary Department-Wise

Example:

```text
IT Department total salary = 33000
```

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT DISTINCT Department
FROM EMPLOYEE;

DECLARE
    @Department VARCHAR(50),
    @TotalSalary DECIMAL(12,2);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor INTO @Department;

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

    FETCH NEXT FROM Employee_Cursor INTO @Department;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

## 15. Calculate Average Salary City-Wise

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT DISTINCT City
FROM EMPLOYEE
WHERE City IS NOT NULL;

DECLARE
    @City VARCHAR(50),
    @AverageSalary DECIMAL(12,2);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor INTO @City;

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

    FETCH NEXT FROM Employee_Cursor INTO @City;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

# Part – C

## 16. Display Employee Experience Using `JOININGYEAR`

Example:

```text
Raj Mehta has experience = 4 years
```

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

> `YEAR(GETDATE())` gives the current year, so the experience is calculated dynamically.

---

## 17. Display Employee Full Name with Annual Salary

Example:

```text
Hetvi Patel annual salary = 144000
```

If `Salary` stores the **monthly salary**:

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT FirstName, LastName, Salary
FROM EMPLOYEE;

DECLARE
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Salary DECIMAL(10,2),
    @AnnualSalary DECIMAL(12,2);

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

---

## 18. Calculate Total Male and Female Employees Separately

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT DISTINCT Gender
FROM EMPLOYEE;

DECLARE
    @Gender VARCHAR(10),
    @TotalEmployees INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor INTO @Gender;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @TotalEmployees = COUNT(*)
    FROM EMPLOYEE
    WHERE Gender = @Gender;

    PRINT CONCAT(
        @Gender,
        ' employees = ',
        @TotalEmployees
    );

    FETCH NEXT FROM Employee_Cursor INTO @Gender;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

## 19. Display Employees Whose Salary Is Greater Than Department Average

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID, FirstName, LastName, Department, Salary
FROM EMPLOYEE;

DECLARE
    @EID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Department VARCHAR(50),
    @Salary DECIMAL(10,2),
    @DepartmentAverage DECIMAL(12,2);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor
INTO @EID, @FirstName, @LastName, @Department, @Salary;

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @DepartmentAverage = AVG(Salary)
    FROM EMPLOYEE
    WHERE Department = @Department;

    IF @Salary > @DepartmentAverage
    BEGIN
        PRINT CONCAT(
            @FirstName, ' ',
            @LastName,
            ' salary = ',
            @Salary,
            ', Department Average = ',
            @DepartmentAverage
        );
    END;

    FETCH NEXT FROM Employee_Cursor
    INTO @EID, @FirstName, @LastName, @Department, @Salary;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

## 20. Transfer All Employees from ADMIN to HR

This updates the department of every employee currently belonging to `ADMIN`.

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT EID
FROM EMPLOYEE
WHERE Department = 'ADMIN';

DECLARE @EID INT;

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor INTO @EID;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE EMPLOYEE
    SET Department = 'HR'
    WHERE EID = @EID;

    FETCH NEXT FROM Employee_Cursor INTO @EID;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

---

# Cursor Flow

```text
DECLARE
   ↓
OPEN
   ↓
FETCH NEXT
   ↓
@@FETCH_STATUS = 0 ?
   ↓ Yes
Process Current Row
   ↓
FETCH NEXT
   ↓
Repeat
   ↓ No
CLOSE
   ↓
DEALLOCATE
```

## Simple Example

```sql
DECLARE Employee_Cursor CURSOR FOR
SELECT FirstName
FROM EMPLOYEE;

DECLARE @Name VARCHAR(50);

OPEN Employee_Cursor;

FETCH NEXT FROM Employee_Cursor INTO @Name;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @Name;

    FETCH NEXT FROM Employee_Cursor INTO @Name;
END;

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;
```

### Remember

**DECLARE → OPEN → FETCH → WHILE → FETCH → CLOSE → DEALLOCATE**

This is the basic pattern you should remember for cursor viva questions.
