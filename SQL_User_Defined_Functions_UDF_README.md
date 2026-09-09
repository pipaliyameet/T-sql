# User Defined Functions (UDF) in SQL

## 1. Concept Name

**User Defined Functions (UDF) in SQL**

The lab focuses on implementing **User Defined Functions (UDFs)** in
SQL, especially **scalar functions**.

------------------------------------------------------------------------

## 2. Introduction

A **User Defined Function (UDF)** is a function created by the
programmer to perform a specific task in SQL.

SQL already provides built-in functions such as:

``` sql
SUM()
AVG()
COUNT()
MAX()
MIN()
```

But sometimes we need our own reusable logic. In that case, we can
create a **User Defined Function**.

For example, if we frequently need to calculate simple interest:

``` text
Simple Interest = (Principal × Rate × Time) / 100
```

we can create a function and call it whenever required.

### Why use UDFs?

UDFs are useful because they:

-   Reduce repeated SQL code.
-   Make logic reusable.
-   Improve code organization.
-   Make queries easier to understand.
-   Allow the same calculation to be used in multiple queries.

------------------------------------------------------------------------

## 3. Syntax

For a SQL Server **scalar UDF**, the general syntax is:

``` sql
CREATE FUNCTION [schema_name].[function_name]
(
    @parameter1 datatype,
    @parameter2 datatype
)
RETURNS return_datatype
AS
BEGIN

    -- Function logic

    RETURN value;
END;
```

### Example

``` sql
CREATE FUNCTION dbo.AddNumbers
(
    @a INT,
    @b INT
)
RETURNS INT
AS
BEGIN
    RETURN @a + @b;
END;
```

### Syntax Explanation

  Part                Meaning
  ------------------- -------------------------------------
  `CREATE FUNCTION`   Creates a new user-defined function
  `dbo`               Schema name
  `AddNumbers`        Function name
  `@a`, `@b`          Input parameters
  `INT`               Parameter datatype
  `RETURNS INT`       Function returns an integer
  `BEGIN ... END`     Contains the function logic
  `RETURN`            Returns the final value

------------------------------------------------------------------------

## 4. Understanding `dbo` in SQL Server

One of the most common things students see when creating or calling a function is:

```sql
dbo.FunctionName
```

For example:

```sql
CREATE FUNCTION dbo.SquareNumber
(
    @Number INT
)
RETURNS INT
AS
BEGIN
    RETURN @Number * @Number;
END;
```

Here, **`dbo` is the schema name** and **`SquareNumber` is the function name**.

### What is a Schema?

A **schema** is a logical container used to organize database objects such as:

- Tables
- Views
- Functions
- Stored procedures

Think of a schema like a **folder inside a database**.

```text
Database
│
├── dbo
│   ├── Employee
│   ├── SquareNumber
│   └── CalculateInterest
│
└── OtherSchema
    └── SomeObject
```

So:

```text
dbo.SquareNumber
│   │
│   └── Object name (function)
└────── Schema name
```

### What does `dbo` mean?

`dbo` stands for **Database Owner**.

In SQL Server, `dbo` is a commonly used schema, and many database objects are created under the `dbo` schema when no different schema is specified.

For example:

```sql
dbo.Employee
dbo.SquareNumber
dbo.CalculateInterest
```

All three objects can belong to the `dbo` schema.

### Why do we use `dbo` with a function?

We use:

```sql
dbo.FunctionName
```

to clearly specify **which schema contains the function**.

For example:

```sql
SELECT dbo.SquareNumber(5);
```

This can be understood as:

```text
Database
   ↓
dbo schema
   ↓
SquareNumber function
   ↓
Input: 5
   ↓
Result: 25
```

A database can contain multiple schemas. Different schemas can also contain objects with the same name.

For example:

```text
dbo.CalculateSalary
HR.CalculateSalary
```

These are different objects because they belong to different schemas.

Therefore:

```sql
SELECT dbo.CalculateSalary(50000);
```

and:

```sql
SELECT HR.CalculateSalary(50000);
```

refer to different functions.

### Is `dbo` the function?

**No. This is very important.**

In:

```sql
dbo.SquareNumber
```

- `dbo` → **schema**
- `SquareNumber` → **function**

So, `dbo` is **not** a special type of function.

### Easy Way to Remember

Think of it like a computer folder:

```text
Database
   ↓
dbo (schema / folder)
   ↓
SquareNumber (function)
```

When we write:

```sql
dbo.SquareNumber(5)
```

we are saying:

> Use the `SquareNumber` function from the `dbo` schema.

---

## 4. Key Points

### 1. UDF is created using `CREATE FUNCTION`

``` sql
CREATE FUNCTION dbo.MyFunction
```

### 2. A scalar function returns a single value

``` sql
CREATE FUNCTION dbo.SquareNumber
(
    @num INT
)
RETURNS INT
AS
BEGIN
    RETURN @num * @num;
END;
```

If we pass `5`, the function returns:

``` text
25
```

### 3. Functions can accept parameters

``` sql
@num INT
```

Parameters allow us to provide different values each time the function
is called.

### 4. The return datatype must be specified

``` sql
RETURNS INT
```

The returned value should be compatible with the specified datatype.

### 5. `RETURN` gives the result

A scalar function returns its result using:

``` sql
RETURN @result;
```

### 6. Functions can be reused

Once created, the same function can be called multiple times:

``` sql
SELECT dbo.SquareNumber(5);
SELECT dbo.SquareNumber(10);
SELECT dbo.SquareNumber(20);
```

### 7. Schema is normally specified

Functions can be referenced as:

``` sql
dbo.FunctionName
```

Here:

``` text
dbo            → schema
FunctionName   → function
```

### 8. Scalar UDF returns one value

A scalar function returns a single value such as:

``` text
25
"Welcome to DBMS Lab"
"Even"
50000
```

------------------------------------------------------------------------

## 6. Examples

### Example 1: Function Returning Text

``` sql
CREATE FUNCTION dbo.WelcomeMessage()
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN 'Welcome to DBMS Lab';
END;
```

Call the function:

``` sql
SELECT dbo.WelcomeMessage() AS Message;
```

Expected output:

``` text
Message
---------------------
Welcome to DBMS Lab
```

------------------------------------------------------------------------

### Example 2: Function with Parameters

Simple interest:

``` text
SI = (P × R × T) / 100
```

``` sql
CREATE FUNCTION dbo.CalculateInterest
(
    @Principal DECIMAL(10,2),
    @Rate DECIMAL(10,2),
    @Time INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN (@Principal * @Rate * @Time) / 100;
END;
```

Call:

``` sql
SELECT dbo.CalculateInterest(10000, 5, 2) AS SimpleInterest;
```

Expected output:

``` text
SimpleInterest
--------------
1000.00
```

------------------------------------------------------------------------

### Example 3: Difference Between Two Dates

``` sql
CREATE FUNCTION dbo.DaysBetween
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @StartDate, @EndDate);
END;
```

Call:

``` sql
SELECT dbo.DaysBetween('2026-01-01', '2026-01-10') AS TotalDays;
```

Expected output:

``` text
TotalDays
---------
9
```

------------------------------------------------------------------------

### Example 4: Check Odd or Even

``` sql
CREATE FUNCTION dbo.CheckOddEven
(
    @Number INT
)
RETURNS VARCHAR(10)
AS
BEGIN
    IF @Number % 2 = 0
        RETURN 'Even';

    RETURN 'Odd';
END;
```

Call:

``` sql
SELECT dbo.CheckOddEven(10) AS Result;
```

Expected output:

``` text
Result
------
Even
```

For:

``` sql
SELECT dbo.CheckOddEven(7) AS Result;
```

Output:

``` text
Result
------
Odd
```

------------------------------------------------------------------------

### Example 5: Square of a Number

``` sql
CREATE FUNCTION dbo.SquareNumber
(
    @Number INT
)
RETURNS INT
AS
BEGIN
    RETURN @Number * @Number;
END;
```

Call:

``` sql
SELECT dbo.SquareNumber(6) AS Square;
```

Output:

``` text
Square
------
36
```

------------------------------------------------------------------------

### Example 6: Maximum of Three Numbers

``` sql
CREATE FUNCTION dbo.MaximumOfThree
(
    @A INT,
    @B INT,
    @C INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Max INT;

    SET @Max = @A;

    IF @B > @Max
        SET @Max = @B;

    IF @C > @Max
        SET @Max = @C;

    RETURN @Max;
END;
```

Call:

``` sql
SELECT dbo.MaximumOfThree(10, 25, 15) AS MaximumValue;
```

Output:

``` text
MaximumValue
------------
25
```

------------------------------------------------------------------------

### Example 7: Function Using Table Data

A scalar UDF can use table data to calculate a value.

Suppose an `EMPLOYEE` table contains:

``` text
EID
Name
Department
Salary
```

We can create a function to find the highest salary in a department:

``` sql
CREATE FUNCTION dbo.HighestSalary
(
    @Department VARCHAR(50)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Highest DECIMAL(10,2);

    SELECT @Highest = MAX(Salary)
    FROM EMPLOYEE
    WHERE Department = @Department;

    RETURN @Highest;
END;
```

Call:

``` sql
SELECT dbo.HighestSalary('IT') AS HighestSalary;
```

The function:

1.  Receives the department.
2.  Searches the `EMPLOYEE` table.
3.  Filters employees belonging to that department.
4.  Finds the maximum salary.
5.  Returns that salary.

------------------------------------------------------------------------

## 7. How It Works

Consider:

``` sql
CREATE FUNCTION dbo.SquareNumber
(
    @Number INT
)
RETURNS INT
AS
BEGIN
    RETURN @Number * @Number;
END;
```

When we execute:

``` sql
SELECT dbo.SquareNumber(5);
```

the execution flow is:

### Step 1: Function is called

``` sql
dbo.SquareNumber(5)
```

The value `5` is supplied to the function.

### Step 2: Parameter receives the value

Inside the function:

``` text
@Number = 5
```

### Step 3: Function executes its logic

``` sql
@Number * @Number
```

becomes:

``` text
5 × 5
```

### Step 4: Result is generated

``` text
25
```

### Step 5: `RETURN` sends the value back

``` sql
RETURN @Number * @Number;
```

returns:

``` text
25
```

### Step 6: `SELECT` displays the result

``` sql
SELECT dbo.SquareNumber(5);
```

Output:

``` text
25
```

### Overall Flow

``` text
Input
  ↓
Function Call
  ↓
Parameter receives value
  ↓
Function logic executes
  ↓
RETURN
  ↓
Single result
```

------------------------------------------------------------------------

## 8. Example Output

For:

``` sql
SELECT dbo.SquareNumber(4) AS Square;
```

Output:

``` text
Square
------
16
```

Multiple calls are also possible:

``` sql
SELECT
    dbo.SquareNumber(2) AS Square1,
    dbo.SquareNumber(5) AS Square2,
    dbo.SquareNumber(10) AS Square3;
```

Output:

``` text
Square1   Square2   Square3
-------   -------   -------
4         25        100
```

------------------------------------------------------------------------

## 9. Common Mistakes

### Mistake 1: Forgetting `RETURNS`

Incorrect:

``` sql
CREATE FUNCTION dbo.SquareNumber
(
    @Number INT
)
AS
```

Correct:

``` sql
CREATE FUNCTION dbo.SquareNumber
(
    @Number INT
)
RETURNS INT
AS
```

### Mistake 2: Not using `RETURN`

A scalar function needs to return a value:

``` sql
RETURN @Number * @Number;
```

### Mistake 3: Calling a function incorrectly

For a scalar function:

``` sql
SELECT dbo.SquareNumber(5);
```

Do not treat a scalar function like a stored procedure.

### Mistake 4: Confusing Function and Stored Procedure

A scalar function returns a value:

``` sql
SELECT dbo.SquareNumber(5);
```

A stored procedure is normally executed using:

``` sql
EXEC ProcedureName;
```

### Mistake 5: Returning the wrong datatype

If the function says:

``` sql
RETURNS INT
```

the returned value should be compatible with `INT`.

For text:

``` sql
RETURNS VARCHAR(100)
```

### Mistake 6: Forgetting the schema

Prefer:

``` sql
dbo.SquareNumber(5)
```

### Mistake 7: Mixing up parameters and variables

A parameter is supplied when calling the function:

``` sql
@Number INT
```

A variable is created and used inside the function:

``` sql
DECLARE @Result INT;
```

------------------------------------------------------------------------

## 10. Real-World Use

User Defined Functions are useful when the same logic needs to be
performed repeatedly.

### Financial Applications

Functions can calculate:

-   Interest
-   Tax
-   Discounts
-   Loan-related calculations

Example:

``` sql
SELECT dbo.CalculateInterest(50000, 7, 2);
```

### Employee Management

Functions can calculate or retrieve:

-   Employee experience
-   Highest salary
-   Employee count
-   Department-specific information

Example:

``` sql
SELECT dbo.HighestSalary('IT');
```

### E-Commerce

Functions can calculate:

-   Product discounts
-   Final prices
-   Tax
-   Shipping charges

### Date-Based Applications

Functions can calculate:

-   Number of days between dates
-   Years of experience
-   Duration of projects

### Reusable Business Logic

If the same calculation is needed in many queries, placing that logic
inside a UDF avoids repeatedly writing the same SQL logic.

------------------------------------------------------------------------

## 11. Quick Revision

### What is UDF?

A **User Defined Function** is a function created by the programmer to
perform reusable SQL logic.

### Main Syntax

``` sql
CREATE FUNCTION dbo.FunctionName
(
    @Parameter datatype
)
RETURNS datatype
AS
BEGIN
    -- logic
    RETURN value;
END;
```

### How to call a scalar function?

``` sql
SELECT dbo.FunctionName(value);
```

### What does a scalar function return?

It returns **one value**.

### What is `dbo`?

`dbo` stands for **Database Owner** and is commonly used as a **schema name** in SQL Server.

```text
dbo.FunctionName
│   │
│   └── Function / Object
└────── Schema
```

### Why use `dbo`?

It tells SQL Server which **schema** the function belongs to and makes the object reference clear.

```sql
SELECT dbo.SquareNumber(5);
```

Read it as:

> Use the `SquareNumber` function from the `dbo` schema.

Remember:

```text
dbo       → Schema
Function  → Object
```

### Important Keywords

``` text
CREATE FUNCTION
RETURNS
BEGIN
END
RETURN
```

### Remember the Flow

``` text
Create Function
      ↓
Define Parameters
      ↓
Write Logic
      ↓
Return One Value
      ↓
Call Function
      ↓
Get Result
```

## One-Line Definition

> **A User Defined Function (UDF) is a reusable SQL program created by
> the user that accepts inputs, performs specific logic, and returns a
> value.**
