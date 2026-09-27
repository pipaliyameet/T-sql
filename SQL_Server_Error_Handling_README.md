# SQL Server Error Handling

## 1. Concept: TRY...CATCH, THROW, and RAISERROR

SQL Server provides error-handling features to detect, handle, and
report errors that occur during SQL execution.

The main concepts are:

-   `TRY...CATCH` -- handles runtime errors.
-   `THROW` -- generates a custom error or re-throws an existing error.
-   `RAISERROR` -- generates a custom error with a message, severity,
    and state.
-   Error functions -- provide details about an error, such as its
    message, number, severity, and state.

These concepts are useful for handling errors such as divide-by-zero,
invalid data conversion, duplicate Primary Keys, Foreign Key violations,
invalid dates, and custom validation errors.

------------------------------------------------------------------------

## 2. Introduction

An error can occur when a SQL statement is executed.

For example:

``` sql
SELECT 10 / 0;
```

This produces a divide-by-zero error.

Instead of allowing the operation to stop unexpectedly, SQL Server
allows us to handle the error using `TRY...CATCH`.

Error handling is especially useful inside Stored Procedures and
database applications because it allows us to:

-   Detect errors.
-   Display meaningful messages.
-   Get detailed error information.
-   Apply custom validation rules.
-   Re-throw errors when necessary.
-   Prevent unexpected application failures.

------------------------------------------------------------------------

# 3. TRY...CATCH

## What is TRY...CATCH?

`TRY...CATCH` is used to handle runtime errors in SQL Server.

Statements that may generate an error are placed inside the `TRY` block.

If an error occurs, SQL Server transfers control to the `CATCH` block.

### Syntax

``` sql
BEGIN TRY

    -- Statements that may generate an error

END TRY
BEGIN CATCH

    -- Error handling statements

END CATCH;
```

### Simple Example

``` sql
BEGIN TRY

    SELECT 10 / 0;

END TRY
BEGIN CATCH

    PRINT 'Error occurred';

END CATCH;
```

### Output

``` text
Error occurred
```

### How it works

1.  SQL Server starts executing the `TRY` block.
2.  The statement `10 / 0` causes an error.
3.  SQL Server stops normal execution of the `TRY` block.
4.  Control moves to the `CATCH` block.
5.  The `CATCH` block handles the error.

------------------------------------------------------------------------

# 4. THROW

## What is THROW?

`THROW` is used to generate a custom error or re-throw an existing
error.

It is useful when a condition violates a business rule.

### Syntax for a New Error

``` sql
THROW error_number, message, state;
```

### Example

``` sql
BEGIN TRY

    DECLARE @salary INT = -5000;

    IF @salary <= 0
    BEGIN
        THROW 50001, 'Salary must be greater than zero.', 1;
    END

END TRY
BEGIN CATCH

    PRINT ERROR_MESSAGE();

END CATCH;
```

### Output

``` text
Salary must be greater than zero.
```

### Parameters

  Parameter        Meaning
  ---------------- --------------------------------------------------------
  `error_number`   User-defined error number
  `message`        Custom error message
  `state`          State value used to identify the location or condition

For a new custom error, the error number should be in the user-defined
range supported by SQL Server, such as `50001`.

------------------------------------------------------------------------

## THROW to Re-Throw an Error

Inside a `CATCH` block, `THROW;` without parameters can re-throw the
original error.

``` sql
BEGIN TRY

    SELECT 10 / 0;

END TRY
BEGIN CATCH

    PRINT 'Error occurred.';
    THROW;

END CATCH;
```

The original error is passed to the calling code.

------------------------------------------------------------------------

# 5. RAISERROR

## What is RAISERROR?

`RAISERROR` is used to generate a custom error message.

It allows the programmer to specify:

-   Error message
-   Severity
-   State

### Syntax

``` sql
RAISERROR (
    'message',
    severity,
    state
);
```

### Example

``` sql
BEGIN TRY

    DECLARE @age INT = 15;

    IF @age < 18
    BEGIN
        RAISERROR('Age must be 18 or above.', 16, 1);
    END

END TRY
BEGIN CATCH

    PRINT ERROR_MESSAGE();

END CATCH;
```

### Output

``` text
Age must be 18 or above.
```

Here:

-   `16` is the severity.
-   `1` is the state.

------------------------------------------------------------------------

# 6. THROW vs RAISERROR

Both can be used to generate custom errors, but they have different
syntax and behavior.

  Feature                      THROW                 RAISERROR
  ---------------------------- --------------------- ---------------------
  Generate custom error        Yes                   Yes
  Re-throw original error      Yes, using `THROW;`   Different mechanism
  Specify severity directly    No                    Yes
  Specify state                Yes                   Yes
  Custom message               Yes                   Yes
  Common choice for new code   Yes                   Older mechanism

For new SQL Server code, `THROW` is generally the simpler mechanism for
generating and re-throwing errors.

------------------------------------------------------------------------

# 7. SQL Server Error Functions

SQL Server provides functions to retrieve information about an error
inside a `CATCH` block.

Important error functions are:

``` sql
ERROR_MESSAGE()
ERROR_NUMBER()
ERROR_SEVERITY()
ERROR_STATE()
ERROR_LINE()
ERROR_PROCEDURE()
```

## ERROR_MESSAGE()

Returns the error message.

``` sql
BEGIN TRY

    SELECT 10 / 0;

END TRY
BEGIN CATCH

    PRINT ERROR_MESSAGE();

END CATCH;
```

Possible output:

``` text
Divide by zero error encountered.
```

------------------------------------------------------------------------

## ERROR_NUMBER()

Returns the error number.

``` sql
BEGIN TRY

    SELECT 10 / 0;

END TRY
BEGIN CATCH

    PRINT CAST(ERROR_NUMBER() AS VARCHAR(20));

END CATCH;
```

------------------------------------------------------------------------

## ERROR_SEVERITY()

Returns the severity level of the error.

``` sql
SELECT ERROR_SEVERITY();
```

It is normally used inside a `CATCH` block.

------------------------------------------------------------------------

## ERROR_STATE()

Returns the state number associated with the error.

``` sql
SELECT ERROR_STATE();
```

------------------------------------------------------------------------

## ERROR_LINE()

Returns the line number where the error occurred.

``` sql
SELECT ERROR_LINE();
```

------------------------------------------------------------------------

## ERROR_PROCEDURE()

Returns the name of the stored procedure or trigger where the error
occurred, when applicable.

``` sql
SELECT ERROR_PROCEDURE();
```

------------------------------------------------------------------------

# 8. Displaying Complete Error Details

Multiple error functions can be used together.

``` sql
BEGIN TRY

    SELECT 10 / 0;

END TRY
BEGIN CATCH

    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
    PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(20));
    PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR(20));
    PRINT 'Line: ' + CAST(ERROR_LINE() AS VARCHAR(20));

END CATCH;
```

### Example Output

``` text
Error Message: Divide by zero error encountered.
Error Number: 8134
Severity: 16
State: 1
Line: 3
```

The exact line number depends on where the statement appears in the
script.

------------------------------------------------------------------------

# 9. How Error Handling Works

The general execution flow is:

``` text
START
  |
  v
BEGIN TRY
  |
  v
Execute SQL Statement
  |
  +---- No Error ----> Continue Execution
  |
  +---- Error -------> BEGIN CATCH
                           |
                           v
                     Handle Error
                           |
                           v
                          END
```

## Step-by-Step

### Step 1: Start TRY

SQL Server begins executing the statements inside `BEGIN TRY`.

### Step 2: Execute Statement

SQL Server executes each statement normally.

### Step 3: Check for Error

If no error occurs, execution continues.

If an error occurs, normal execution of the `TRY` block stops.

### Step 4: Move to CATCH

Control moves to `BEGIN CATCH`.

### Step 5: Get Error Information

The error functions can be used:

``` sql
ERROR_MESSAGE()
ERROR_NUMBER()
ERROR_SEVERITY()
ERROR_STATE()
ERROR_LINE()
ERROR_PROCEDURE()
```

### Step 6: Handle the Error

The program can:

-   Print the error.
-   Store/log error information.
-   Return an appropriate response.
-   Re-throw the error using `THROW`.

------------------------------------------------------------------------

# 10. Example: Divide by Zero

``` sql
BEGIN TRY

    DECLARE @a INT = 100;
    DECLARE @b INT = 0;

    SELECT @a / @b AS Result;

END TRY
BEGIN CATCH

    PRINT 'Error: ' + ERROR_MESSAGE();

END CATCH;
```

### Expected Output

``` text
Error: Divide by zero error encountered.
```

------------------------------------------------------------------------

# 11. Example: String to Integer Conversion

Trying to convert invalid text to an integer can cause an error.

``` sql
BEGIN TRY

    DECLARE @value VARCHAR(20) = 'ABC';
    DECLARE @number INT;

    SET @number = CONVERT(INT, @value);

    PRINT @number;

END TRY
BEGIN CATCH

    PRINT 'Conversion Error: ' + ERROR_MESSAGE();

END CATCH;
```

### Expected Output

``` text
Conversion Error: Conversion failed when converting the varchar value 'ABC' to data type int.
```

------------------------------------------------------------------------

# 12. Example: Primary Key Violation

Suppose we have:

``` sql
CREATE TABLE STUDENT_INFO
(
    RNO INT PRIMARY KEY,
    NAME VARCHAR(50)
);
```

Insert the first record:

``` sql
INSERT INTO STUDENT_INFO
VALUES (1, 'Meet');
```

Now try to insert another record with the same Primary Key:

``` sql
BEGIN TRY

    INSERT INTO STUDENT_INFO
    VALUES (1, 'Rahul');

END TRY
BEGIN CATCH

    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(20));
    PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR(20));

END CATCH;
```

### What happens?

`RNO` is a Primary Key, so duplicate value `1` cannot be inserted.

SQL Server generates an error and transfers control to the `CATCH`
block.

------------------------------------------------------------------------

# 13. Example: Foreign Key Violation

Suppose a child table contains a Foreign Key.

``` sql
BEGIN TRY

    INSERT INTO RESULT
    VALUES (999, 85);

END TRY
BEGIN CATCH

    PRINT 'Foreign Key Error: ' + ERROR_MESSAGE();

END CATCH;
```

If `999` does not exist in the referenced parent table, SQL Server
generates a Foreign Key violation.

The `CATCH` block handles the error.

------------------------------------------------------------------------

# 14. Example: Custom Validation Using THROW

A Stored Procedure can use `THROW` when a business rule is violated.

``` sql
CREATE PROCEDURE UpdateSalary
    @EmpId INT,
    @Salary INT
AS
BEGIN

    BEGIN TRY

        IF @Salary <= 0
        BEGIN
            THROW 50001, 'Salary must be greater than zero.', 1;
        END

        UPDATE EMPLOYEE
        SET SALARY = @Salary
        WHERE EMPID = @EmpId;

    END TRY
    BEGIN CATCH

        PRINT ERROR_MESSAGE();

    END CATCH;

END;
```

### Working

If:

``` text
Salary = 50000
```

the validation passes.

If:

``` text
Salary = 0
```

or:

``` text
Salary = -1000
```

the custom exception is generated.

------------------------------------------------------------------------

# 15. Example: Validation Using RAISERROR

``` sql
CREATE PROCEDURE CheckGender
    @Gender VARCHAR(10)
AS
BEGIN

    BEGIN TRY

        IF LOWER(@Gender) NOT IN ('male', 'female')
        BEGIN
            RAISERROR('Gender must be Male or Female.', 16, 1);
        END

    END TRY
    BEGIN CATCH

        PRINT ERROR_MESSAGE();

    END CATCH;

END;
```

If the input is:

``` text
Male
```

the validation passes.

If the input is:

``` text
Other
```

the custom error is generated.

------------------------------------------------------------------------

# 16. TRY, CATCH, THROW and RAISERROR Relationship

A simple way to remember these concepts:

``` text
TRY
 |
 |  Execute SQL
 |
 +---- Error
       |
       v
     CATCH
       |
       +---- ERROR_MESSAGE()
       +---- ERROR_NUMBER()
       +---- ERROR_SEVERITY()
       +---- ERROR_STATE()
       |
       +---- THROW
       |
       +---- RAISERROR
```

### Easy Meaning

``` text
TRY        → Try to execute the statements
CATCH      → Catch the error
THROW      → Generate or re-throw an error
RAISERROR  → Generate a custom error
```

------------------------------------------------------------------------

# 17. Key Points

1.  `TRY...CATCH` is used to handle runtime errors.
2.  Statements that may produce errors should be placed inside `TRY`.
3.  When an error occurs, control moves to `CATCH`.
4.  `ERROR_MESSAGE()` returns the error message.
5.  `ERROR_NUMBER()` returns the error number.
6.  `ERROR_SEVERITY()` returns the severity.
7.  `ERROR_STATE()` returns the state.
8.  `ERROR_LINE()` returns the line number.
9.  `ERROR_PROCEDURE()` returns the procedure name when applicable.
10. `THROW` can generate a custom error.
11. `THROW;` inside `CATCH` can re-throw the original error.
12. `RAISERROR` can generate an error with message, severity, and state.
13. Custom errors are useful for business-rule validation.
14. Error handling is commonly used in Stored Procedures and database
    applications.

------------------------------------------------------------------------

# 18. Common Mistakes

## Mistake 1: Incorrect TRY...CATCH Structure

Incorrect:

``` sql
TRY
    SELECT 10 / 0;
CATCH
    PRINT 'Error';
```

Correct:

``` sql
BEGIN TRY

    SELECT 10 / 0;

END TRY
BEGIN CATCH

    PRINT 'Error';

END CATCH;
```

------------------------------------------------------------------------

## Mistake 2: Incorrect THROW Syntax

Incorrect:

``` sql
THROW 'Invalid salary';
```

Correct:

``` sql
THROW 50001, 'Invalid salary.', 1;
```

------------------------------------------------------------------------

## Mistake 3: Forgetting the CATCH Block

`TRY` should be paired with a `CATCH` block when using `TRY...CATCH`
error handling.

``` sql
BEGIN TRY

    -- Statements

END TRY
BEGIN CATCH

    -- Error handling

END CATCH;
```

------------------------------------------------------------------------

## Mistake 4: Using Error Functions Without Understanding Their Context

Error functions such as:

``` sql
ERROR_MESSAGE()
ERROR_NUMBER()
ERROR_SEVERITY()
ERROR_STATE()
```

are intended to retrieve information about the error being handled,
normally from a `CATCH` block.

Example:

``` sql
BEGIN CATCH

    PRINT ERROR_MESSAGE();

END CATCH;
```

------------------------------------------------------------------------

## Mistake 5: Giving Unclear Custom Messages

Avoid:

``` sql
THROW 50001, 'Error.', 1;
```

Prefer:

``` sql
THROW 50001, 'Salary must be greater than zero.', 1;
```

A meaningful message makes debugging easier.

------------------------------------------------------------------------

# 19. Real-World Use

Error handling is useful in many database applications.

## Banking System

Examples:

``` text
Invalid account
Invalid transaction
Insufficient balance
Duplicate transaction
```

## Student Management System

Examples:

``` text
Duplicate roll number
Invalid student ID
Invalid marks
Missing student record
```

## Employee Management System

Examples:

``` text
Invalid salary
Invalid employee ID
Invalid joining year
Invalid gender value
```

## E-Commerce System

Examples:

``` text
Invalid product ID
Insufficient stock
Duplicate order
Invalid payment information
```

## API and Backend Applications

A backend application may execute a Stored Procedure.

The flow can be:

``` text
Frontend
   |
   v
Backend / API
   |
   v
Stored Procedure
   |
   v
SQL Server
   |
   +---- Error
          |
          v
       TRY...CATCH
          |
          v
     Error Information
          |
          v
      Backend / API
          |
          v
    User-friendly message
```

------------------------------------------------------------------------

# 20. Complete Simple Example

``` sql
CREATE PROCEDURE AddEmployee
    @EmpId INT,
    @Name VARCHAR(50),
    @Salary INT
AS
BEGIN

    BEGIN TRY

        IF @Salary <= 0
        BEGIN
            THROW 50001, 'Salary must be greater than zero.', 1;
        END

        INSERT INTO EMPLOYEE(EmpId, Name, Salary)
        VALUES (@EmpId, @Name, @Salary);

        PRINT 'Employee inserted successfully.';

    END TRY

    BEGIN CATCH

        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
        PRINT 'Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(20));
        PRINT 'State: ' + CAST(ERROR_STATE() AS VARCHAR(20));
        PRINT 'Line: ' + CAST(ERROR_LINE() AS VARCHAR(20));

    END CATCH;

END;
```

### Valid Input

``` sql
EXEC AddEmployee 101, 'Meet', 50000;
```

Possible output:

``` text
Employee inserted successfully.
```

### Invalid Input

``` sql
EXEC AddEmployee 102, 'Rahul', -5000;
```

Possible output:

``` text
Error Message: Salary must be greater than zero.
Error Number: 50001
Severity: 16
State: 1
```

------------------------------------------------------------------------

# 21. Quick Revision

  -----------------------------------------------------------------------
  Concept                             Purpose
  ----------------------------------- -----------------------------------
  `TRY`                               Contains statements that may
                                      generate an error

  `CATCH`                             Handles the error

  `THROW`                             Generates or re-throws an error

  `RAISERROR`                         Generates a custom error with
                                      message, severity, and state

  `ERROR_MESSAGE()`                   Returns the error message

  `ERROR_NUMBER()`                    Returns the error number

  `ERROR_SEVERITY()`                  Returns the severity

  `ERROR_STATE()`                     Returns the state

  `ERROR_LINE()`                      Returns the line number

  `ERROR_PROCEDURE()`                 Returns the procedure name
  -----------------------------------------------------------------------

## One-Line Definition

> **SQL Server Error Handling is the process of detecting, handling, and
> reporting runtime and custom errors using `TRY...CATCH`, `THROW`,
> `RAISERROR`, and error functions.**

------------------------------------------------------------------------

# 22. Final Quick Memory Trick

``` text
TRY
  ↓
Execute SQL
  ↓
Error?
  ↓ Yes
CATCH
  ↓
Check Error Functions
  ↓
ERROR_MESSAGE()
ERROR_NUMBER()
ERROR_SEVERITY()
ERROR_STATE()
  ↓
Handle / Log / Re-throw
```

**Remember:**

``` text
TRY       = Try the operation
CATCH     = Catch the error
THROW     = Throw / re-throw an error
RAISERROR = Raise a custom error
```
