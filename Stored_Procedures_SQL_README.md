# Stored Procedures in SQL

## 1. Stored Procedure

A **Stored Procedure** is a precompiled collection of SQL statements stored inside a database. It can be executed whenever required by calling its procedure name, optionally passing input parameters.

Stored procedures are commonly used to perform reusable database operations such as:

- Retrieving records
- Inserting new records
- Updating existing records
- Deleting records
- Performing calculations
- Filtering data using user-provided parameters
- Generating reports

---

## 2. Introduction

A stored procedure is a named set of SQL statements that is stored permanently in the database.

Instead of writing the same SQL query again and again, we can create a stored procedure once and execute it whenever required.

### Why Use Stored Procedures?

Stored procedures are useful because they:

1. **Reduce repeated SQL code**
2. **Improve code reusability**
3. **Accept parameters**
4. **Keep database operations organized**
5. **Can improve security by controlling direct table access**
6. **Make complex database operations easier to execute**
7. **Can perform multiple SQL operations together**

### Simple Example

Instead of repeatedly writing:

```sql
SELECT *
FROM Employee
WHERE Department = 'Computer';
```

we can create a procedure:

```sql
CREATE PROCEDURE GetEmployeesByDepartment
    @Department VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE Department = @Department;
END;
```

Now the same operation can be performed using:

```sql
EXEC GetEmployeesByDepartment 'Computer';
```

---

# 3. Syntax

The general syntax for creating a stored procedure in **T-SQL / SQL Server** is:

```sql
CREATE PROCEDURE ProcedureName
    @Parameter1 DataType,
    @Parameter2 DataType
AS
BEGIN

    -- SQL statements

END;
```

### Example

```sql
CREATE PROCEDURE GetEmployeeByDepartment
    @Department VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE Department = @Department;
END;
```

### Explanation

| Part | Meaning |
|---|---|
| `CREATE PROCEDURE` | Creates a new stored procedure |
| `GetEmployeeByDepartment` | Name of the procedure |
| `@Department` | Input parameter |
| `VARCHAR(50)` | Data type of the parameter |
| `AS` | Starts the procedure definition |
| `BEGIN` | Starts the block of SQL statements |
| `SELECT` | SQL operation performed by the procedure |
| `END` | Ends the procedure |

---

## Executing a Stored Procedure

Use `EXEC` or `EXECUTE` to run a stored procedure.

```sql
EXEC GetEmployeeByDepartment 'Computer';
```

The parameter can also be passed by name:

```sql
EXEC GetEmployeeByDepartment
    @Department = 'Computer';
```

---

# 4. Key Points

### 1. Procedure is stored in the database

A stored procedure is saved as a database object and can be executed multiple times.

### 2. Procedures can accept parameters

Parameters allow users to provide different values without changing the procedure itself.

```sql
CREATE PROCEDURE GetEmployeeBySalary
    @Salary DECIMAL(10,2)
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE Salary > @Salary;
END;
```

Execution:

```sql
EXEC GetEmployeeBySalary 50000;
```

### 3. Procedures can contain multiple SQL statements

A procedure can perform several operations.

```sql
CREATE PROCEDURE EmployeeReport
AS
BEGIN
    SELECT COUNT(*) AS TotalEmployees
    FROM Employee;

    SELECT AVG(Salary) AS AverageSalary
    FROM Employee;
END;
```

### 4. Parameters have data types

Each parameter should have an appropriate SQL data type.

```sql
@EmployeeID INT
@EmployeeName VARCHAR(50)
@Salary DECIMAL(10,2)
```

### 5. Input parameters

Input parameters provide values to the procedure.

```sql
CREATE PROCEDURE GetEmployee
    @EmployeeID INT
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE EmployeeID = @EmployeeID;
END;
```

### 6. Procedures can perform INSERT, UPDATE and DELETE

Stored procedures are not limited to `SELECT`.

```sql
CREATE PROCEDURE UpdateEmployeeSalary
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    UPDATE Employee
    SET Salary = @NewSalary
    WHERE EmployeeID = @EmployeeID;
END;
```

Execute:

```sql
EXEC UpdateEmployeeSalary 101, 65000;
```

### 7. `BEGIN` and `END`

`BEGIN` and `END` are used to group multiple SQL statements into one block.

```sql
BEGIN
    SELECT * FROM Employee;

    SELECT COUNT(*) AS TotalEmployees
    FROM Employee;
END;
```

### 8. Procedure names should be meaningful

Prefer:

```sql
GetEmployeesByDepartment
```

instead of:

```sql
Proc1
```

Meaningful names make database programs easier to understand and maintain.

---

# 5. Examples

## Example 1: Display All Employees

```sql
CREATE PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT *
    FROM Employee;
END;
```

Execute:

```sql
EXEC GetAllEmployees;
```

The procedure does not require any parameter. Whenever it is executed, it displays all employees.

---

## Example 2: Search Employee by ID

```sql
CREATE PROCEDURE GetEmployeeByID
    @EmployeeID INT
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE EmployeeID = @EmployeeID;
END;
```

Execute:

```sql
EXEC GetEmployeeByID 101;
```

The user provides an employee ID. The procedure searches the `Employee` table and returns the matching employee.

---

## Example 3: Search Employees by Department

```sql
CREATE PROCEDURE GetEmployeesByDepartment
    @Department VARCHAR(50)
AS
BEGIN
    SELECT EmployeeID, EmployeeName, Salary, Department
    FROM Employee
    WHERE Department = @Department;
END;
```

Execute:

```sql
EXEC GetEmployeesByDepartment 'Computer';
```

### Example Output

```text
EmployeeID   EmployeeName   Salary    Department
-------------------------------------------------
101          Rahul          60000     Computer
105          Priya          55000     Computer
108          Amit           70000     Computer
```

---

## Example 4: Salary Statistics

A stored procedure can perform aggregate calculations.

```sql
CREATE PROCEDURE GetSalaryStatistics
    @Department VARCHAR(50)
AS
BEGIN
    SELECT
        SUM(Salary) AS TotalSalary,
        AVG(Salary) AS AverageSalary,
        MIN(Salary) AS MinimumSalary,
        MAX(Salary) AS MaximumSalary
    FROM Employee
    WHERE Department = @Department;
END;
```

Execute:

```sql
EXEC GetSalaryStatistics 'Computer';
```

### Example Output

```text
TotalSalary   AverageSalary   MinimumSalary   MaximumSalary
------------------------------------------------------------
185000        61666.67        55000           70000
```

This type of procedure is useful for generating department-wise reports.

---

## Example 5: Employees Joining in a Particular Year

```sql
CREATE PROCEDURE GetEmployeesByJoiningYear
    @JoiningYear INT
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE YEAR(JoiningDate) = @JoiningYear;
END;
```

Execute:

```sql
EXEC GetEmployeesByJoiningYear 2025;
```

The procedure receives a year and returns employees whose joining date belongs to that year.

---

## Example 6: Employees Earning More Than a Given Salary

```sql
CREATE PROCEDURE GetEmployeesAboveSalary
    @Salary DECIMAL(10,2)
AS
BEGIN
    SELECT EmployeeID, EmployeeName, Salary
    FROM Employee
    WHERE Salary > @Salary;
END;
```

Execute:

```sql
EXEC GetEmployeesAboveSalary 50000;
```

This makes the salary value reusable instead of hard-coding it inside the query.

---

## Example 7: Updating Data Using a Procedure

```sql
CREATE PROCEDURE UpdateEmployeeSalary
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    UPDATE Employee
    SET Salary = @NewSalary
    WHERE EmployeeID = @EmployeeID;
END;
```

Execute:

```sql
EXEC UpdateEmployeeSalary
    @EmployeeID = 101,
    @NewSalary = 75000;
```

The procedure receives an employee ID and a new salary, then updates that employee's salary.

---

## Example 8: Deleting Data Using a Procedure

```sql
CREATE PROCEDURE DeleteEmployee
    @EmployeeID INT
AS
BEGIN
    DELETE FROM Employee
    WHERE EmployeeID = @EmployeeID;
END;
```

Execute:

```sql
EXEC DeleteEmployee 101;
```

This deletes the employee whose ID is `101`.

---

# 6. How It Works

The execution flow of a stored procedure can be understood in these steps:

### Step 1: Create the Procedure

The developer defines the SQL statements.

```sql
CREATE PROCEDURE GetEmployeeByID
    @EmployeeID INT
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE EmployeeID = @EmployeeID;
END;
```

The procedure is stored as a database object.

### Step 2: Call the Procedure

The user executes it using `EXEC`.

```sql
EXEC GetEmployeeByID 101;
```

### Step 3: Parameter Value Is Passed

The value:

```text
101
```

is assigned to:

```sql
@EmployeeID
```

### Step 4: SQL Statements Execute

The procedure executes:

```sql
SELECT *
FROM Employee
WHERE EmployeeID = @EmployeeID;
```

The parameter value is used by the query.

### Step 5: Database Returns the Result

The matching employee record is returned.

### Overall Flow

```text
User
  |
  | EXEC Procedure
  v
Stored Procedure
  |
  | Accept Parameters
  v
SQL Statements
  |
  | Execute
  v
Database Table
  |
  v
Result
```

---

# 7. Example Output

Consider the following `Employee` table:

```text
EmployeeID   EmployeeName   Department   Salary
------------------------------------------------
101          Rahul          Computer     60000
102          Priya          HR           45000
103          Amit           Computer     70000
104          Neha           Finance      55000
```

Procedure:

```sql
CREATE PROCEDURE GetEmployeesByDepartment
    @Department VARCHAR(50)
AS
BEGIN
    SELECT EmployeeID, EmployeeName, Salary
    FROM Employee
    WHERE Department = @Department;
END;
```

Execute:

```sql
EXEC GetEmployeesByDepartment 'Computer';
```

Output:

```text
EmployeeID   EmployeeName   Salary
-----------------------------------
101          Rahul          60000
103          Amit           70000
```

The procedure filters the records according to the supplied department.

---

# 8. Common Mistakes

## Mistake 1: Forgetting the Parameter Data Type

Incorrect:

```sql
CREATE PROCEDURE GetEmployee
    @EmployeeID
AS
BEGIN
    SELECT *
    FROM Employee;
END;
```

Correct:

```sql
CREATE PROCEDURE GetEmployee
    @EmployeeID INT
AS
BEGIN
    SELECT *
    FROM Employee
    WHERE EmployeeID = @EmployeeID;
END;
```

---

## Mistake 2: Forgetting `AS`

Incorrect:

```sql
CREATE PROCEDURE GetEmployee
    @EmployeeID INT
BEGIN
    SELECT *
    FROM Employee;
END;
```

Correct:

```sql
CREATE PROCEDURE GetEmployee
    @EmployeeID INT
AS
BEGIN
    SELECT *
    FROM Employee;
END;
```

---

## Mistake 3: Forgetting to Pass Required Parameters

If the procedure requires:

```sql
@EmployeeID INT
```

this is incomplete:

```sql
EXEC GetEmployee;
```

Correct:

```sql
EXEC GetEmployee 101;
```

---

## Mistake 4: Using the Wrong Parameter Data Type

If an employee ID is an integer:

```sql
@EmployeeID INT
```

should be used instead of an unnecessarily large text type.

---

## Mistake 5: Forgetting the `WHERE` Condition in UPDATE

Be careful with:

```sql
UPDATE Employee
SET Salary = 50000;
```

This updates **every employee**.

Usually, you need:

```sql
UPDATE Employee
SET Salary = 50000
WHERE EmployeeID = 101;
```

---

## Mistake 6: Forgetting the `WHERE` Condition in DELETE

This is dangerous:

```sql
DELETE FROM Employee;
```

It can delete all records.

Use an appropriate condition:

```sql
DELETE FROM Employee
WHERE EmployeeID = 101;
```

---

## Mistake 7: Using Incorrect Parameter Names

If the procedure contains:

```sql
@Department VARCHAR(50)
```

use:

```sql
EXEC GetEmployeesByDepartment
    @Department = 'Computer';
```

Do not accidentally use a different parameter name.

---

## Mistake 8: Confusing Procedure Creation and Execution

Creating a procedure:

```sql
CREATE PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT * FROM Employee;
END;
```

Executing it:

```sql
EXEC GetAllEmployees;
```

These are two different operations.

---

# 9. Real-World Use

Stored procedures are widely used in applications where software needs to communicate with databases.

### 1. Banking Systems

A procedure can retrieve account information.

```sql
CREATE PROCEDURE GetAccountBalance
    @AccountID INT
AS
BEGIN
    SELECT Balance
    FROM Account
    WHERE AccountID = @AccountID;
END;
```

### 2. Employee Management Systems

Procedures can be used to:

- Search employees
- Calculate salary statistics
- Update salaries
- Find employees by department
- Generate employee reports

### 3. E-Commerce Applications

Stored procedures can handle:

- Product searches
- Order processing
- Stock updates
- Customer information

### 4. Library Management Systems

Procedures can be used to:

- Search books
- Issue books
- Return books
- Find books by author
- Calculate available books

### 5. College Management Systems

Procedures can perform operations such as:

- Searching students
- Updating student information
- Displaying students by branch
- Generating student reports

---

# 10. Quick Revision

## Stored Procedure — One-Minute Revision

| Concept | Meaning |
|---|---|
| Stored Procedure | Predefined SQL statements stored in the database |
| Create | `CREATE PROCEDURE` |
| Execute | `EXEC` / `EXECUTE` |
| Parameter | Allows values to be passed to a procedure |
| `BEGIN` | Starts a group of SQL statements |
| `END` | Ends the group |
| Input Parameter | Sends data into the procedure |
| SELECT | Retrieves data |
| INSERT | Adds data |
| UPDATE | Modifies data |
| DELETE | Removes data |

### Basic Pattern

```sql
CREATE PROCEDURE ProcedureName
    @Parameter DataType
AS
BEGIN

    -- SQL statement

END;
```

### Execute

```sql
EXEC ProcedureName Value;
```

### Remember

```text
CREATE → Define the procedure
        ↓
STORE  → Procedure is saved in database
        ↓
EXEC   → Call the procedure
        ↓
PARAMETER → Pass required values
        ↓
SQL QUERY → Execute the statements
        ↓
RESULT → Return or modify data
```

## Key Takeaway

> A **stored procedure** is a reusable, named collection of SQL statements stored in the database. It can accept parameters and can be used for retrieving, inserting, updating, deleting, and processing data.

**Main idea:**

**Create once → Store in database → Execute whenever needed.**
