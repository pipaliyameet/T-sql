# 📘 SQL Lab 20 - Window Functions in SQL

![SQL](https://img.shields.io/badge/SQL-Learning-blue)
![Database](https://img.shields.io/badge/Database-MySQL-orange)
![GitHub](https://img.shields.io/badge/GitHub-README-success)
![Lab](https://img.shields.io/badge/Lab-20-green)

------------------------------------------------------------------------

# 📌 Objective

The objective of this lab is to understand **Window Functions** in SQL
in a simple, practical, student-friendly way.

After completing this lab, students will be able to:

-   Understand Window Functions
-   Understand `OVER()`
-   Understand `PARTITION BY`
-   Understand `ORDER BY` inside a window
-   Understand Window Functions vs `GROUP BY`
-   Use Aggregate Window Functions
-   Use Ranking Functions
-   Use Value / Analytical Functions
-   Use `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, and `NTILE()`
-   Use `SUM()`, `AVG()`, `COUNT()`, `MIN()`, and `MAX()`
-   Use `LAG()`, `LEAD()`, `FIRST_VALUE()`, and `LAST_VALUE()`
-   Generate department-wise row numbers
-   Find top employees in every department
-   Create running totals
-   Compare current, previous, and next rows
-   Divide records into groups
-   Solve real-world SQL problems using Window Functions

------------------------------------------------------------------------

# 📚 Prerequisites

Before starting this lab, students should know:

-   Database Basics
-   Tables and Records
-   `SELECT`
-   `WHERE`
-   `ORDER BY`
-   Aggregate Functions
-   `GROUP BY`
-   `HAVING`
-   Basic SQL aliases

------------------------------------------------------------------------

# 📋 Sample Table

We will use an `EMPLOYEE` table.

## EMPLOYEE

| EID | FirstName | Department | Salary | City | JoinDate |
|---:|---|---|---:|---|---|
| 101 | Deep | IT | 70000 | Rajkot | 2026-01-10 |
| 102 | Rahul | IT | 60000 | Surat | 2026-02-15 |
| 103 | Priya | HR | 65000 | Rajkot | 2026-01-20 |
| 104 | Amit | HR | 55000 | Ahmedabad | 2026-03-10 |
| 105 | Riya | IT | 80000 | Surat | 2026-04-05 |
| 106 | Neha | HR | 65000 | Rajkot | 2026-05-12 |
| 107 | Jay | Sales | 50000 | Rajkot | 2026-01-25 |
| 108 | Kiran | Sales | 70000 | Surat | 2026-02-20 |

------------------------------------------------------------------------

# 📖 Introduction

Suppose we want to show every employee along with the average salary of
their department.

A normal `GROUP BY` gives:

``` sql
SELECT Department, AVG(Salary)
FROM EMPLOYEE
GROUP BY Department;
```

This gives one row per department.

But sometimes we need:

``` text
Employee Name
Employee Salary
Department
Department Average Salary
```

We want to keep **every employee row**.

This is where a **Window Function** is useful.

------------------------------------------------------------------------

# What is a Window Function?

A **Window Function** performs a calculation across a set of related
rows called a **window**, while keeping the original rows in the result.

Example:

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    AVG(Salary) OVER(PARTITION BY Department) AS Dept_Avg
FROM EMPLOYEE;
```

The result contains every employee, plus their department average.

------------------------------------------------------------------------

# ⭐ Easy Definition for Students

Tell students:

> **Window Function = Calculate using a group of rows without removing
> the individual rows.**

Easy memory:

``` text
GROUP BY
→ makes groups and reduces rows

WINDOW FUNCTION
→ makes a window but keeps rows
```

------------------------------------------------------------------------

# Why Do We Need Window Functions?

Suppose:

``` sql
SELECT Department, AVG(Salary)
FROM EMPLOYEE
GROUP BY Department;
```

Result:

``` text
HR       61666.67
IT       70000
Sales    60000
```

Only department summaries remain.

But:

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    AVG(Salary) OVER(PARTITION BY Department) AS Dept_Avg
FROM EMPLOYEE;
```

keeps:

``` text
Deep     IT       70000    70000
Rahul    IT       60000    70000
Riya     IT       80000    70000
Priya    HR       65000    61666.67
Amit     HR       55000    61666.67
Neha     HR       65000    61666.67
```

------------------------------------------------------------------------

# ⭐ GROUP BY vs Window Function

| GROUP BY | Window Function |
|---|---|
| Groups rows | Creates a calculation window |
| Usually reduces rows | Keeps original rows |
| Good for summary | Good for detail + comparison |
| One result row per group | Usually one result row per input row |

------------------------------------------------------------------------

# Basic Syntax

The basic pattern is:

``` sql
FUNCTION()
OVER()
```

Example:

``` sql
AVG(Salary) OVER()
```

`OVER()` tells SQL that the function should work as a Window Function.

------------------------------------------------------------------------

# Parts of a Window Function

A more complete syntax is:

``` sql
FUNCTION(expression)
OVER
(
    PARTITION BY column
    ORDER BY column
)
```

A window can contain:

| Part | Purpose |
|---|---|
| Function | Performs calculation |
| `OVER()` | Defines Window Function |
| `PARTITION BY` | Divides rows into separate windows |
| `ORDER BY` | Defines order inside the window |

Not every Window Function requires every part.

------------------------------------------------------------------------

# ⭐ Types of Window Functions

The three easy categories are:

## 1. Aggregate Window Functions

``` text
SUM()
AVG()
COUNT()
MIN()
MAX()
```

## 2. Ranking Functions

``` text
ROW_NUMBER()
RANK()
DENSE_RANK()
NTILE()
```

## 3. Value / Analytical Functions

``` text
LAG()
LEAD()
FIRST_VALUE()
LAST_VALUE()
```

------------------------------------------------------------------------

# 1️⃣ Aggregate Window Functions

------------------------------------------------------------------------

# SUM() OVER()

## Total Salary of All Employees

``` sql
SELECT
    FirstName,
    Salary,
    SUM(Salary) OVER() AS Total_Salary
FROM EMPLOYEE;
```

Every row shows the same total salary.

------------------------------------------------------------------------

# SUM() with PARTITION BY

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    SUM(Salary) OVER(
        PARTITION BY Department
    ) AS Dept_Total_Salary
FROM EMPLOYEE;
```

Meaning:

``` text
IT     → IT salary total
HR     → HR salary total
Sales  → Sales salary total
```

------------------------------------------------------------------------

# Running Total

A running total means:

``` text
Current row
+
all previous rows
```

Example:

``` sql
SELECT
    EID,
    FirstName,
    Salary,
    SUM(Salary) OVER(
        ORDER BY EID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Running_Total
FROM EMPLOYEE;
```

Conceptually:

``` text
Row 1 → Salary 1
Row 2 → Salary 1 + Salary 2
Row 3 → Salary 1 + Salary 2 + Salary 3
```

------------------------------------------------------------------------

# Department-Wise Running Total

``` sql
SELECT
    EID,
    FirstName,
    Department,
    Salary,
    SUM(Salary) OVER(
        PARTITION BY Department
        ORDER BY EID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Dept_Running_Total
FROM EMPLOYEE;
```

The running total starts again for every department.

------------------------------------------------------------------------

# AVG() OVER()

## Overall Average

``` sql
SELECT
    FirstName,
    Salary,
    AVG(Salary) OVER() AS Avg_Salary
FROM EMPLOYEE;
```

------------------------------------------------------------------------

## Department Average

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    AVG(Salary) OVER(
        PARTITION BY Department
    ) AS Dept_Avg
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# COUNT() OVER()

## Total Employees

``` sql
SELECT
    FirstName,
    COUNT(*) OVER() AS Total_Employees
FROM EMPLOYEE;
```

------------------------------------------------------------------------

## Department Employee Count

``` sql
SELECT
    FirstName,
    Department,
    COUNT(*) OVER(
        PARTITION BY Department
    ) AS Dept_Employee_Count
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# MIN() OVER()

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    MIN(Salary) OVER(
        PARTITION BY Department
    ) AS Dept_Min_Salary
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# MAX() OVER()

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    MAX(Salary) OVER(
        PARTITION BY Department
    ) AS Dept_Max_Salary
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# ⭐ Aggregate Window Summary

  Function    Meaning
  ----------- ---------
  `SUM()`     Total
  `AVG()`     Average
  `COUNT()`   Count
  `MIN()`     Minimum
  `MAX()`     Maximum

------------------------------------------------------------------------

# 2️⃣ Ranking Functions

Ranking functions assign a position to rows.

Main ranking functions:

``` text
ROW_NUMBER()
RANK()
DENSE_RANK()
NTILE()
```

------------------------------------------------------------------------

# ROW_NUMBER()

## What is ROW_NUMBER()?

`ROW_NUMBER()` gives every row a unique sequential number.

``` sql
SELECT
    FirstName,
    Salary,
    ROW_NUMBER() OVER(
        ORDER BY Salary DESC
    ) AS RN
FROM EMPLOYEE;
```

If salaries are:

``` text
80000
70000
70000
60000
```

the result is:

``` text
80000 → 1
70000 → 2
70000 → 3
60000 → 4
```

Even tied values receive different row numbers.

------------------------------------------------------------------------

# Department-Wise ROW_NUMBER()

``` sql
SELECT
    E.*,
    ROW_NUMBER() OVER(
        PARTITION BY Department
        ORDER BY EID
    ) AS RN
FROM EMPLOYEE E;
```

Result concept:

``` text
IT     → 1, 2, 3
HR     → 1, 2, 3
Sales  → 1, 2
```

This is the important meaning of:

``` sql
PARTITION BY Department
```

The numbering starts again for each department.

------------------------------------------------------------------------

# ROW_NUMBER() with Salary

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    ROW_NUMBER() OVER(
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS RN
FROM EMPLOYEE;
```

Highest-paid employee in each department gets `1`.

------------------------------------------------------------------------

# RANK()

## What is RANK()?

`RANK()` gives equal values the same rank.

After a tie, rank numbers are skipped.

Example:

``` text
Salary
80000
70000
70000
60000
```

Result:

``` text
80000 → 1
70000 → 2
70000 → 2
60000 → 4
```

Rank `3` is skipped.

------------------------------------------------------------------------

# RANK() Example

``` sql
SELECT
    FirstName,
    Salary,
    RANK() OVER(
        ORDER BY Salary DESC
    ) AS Salary_Rank
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# DENSE_RANK()

## What is DENSE_RANK()?

`DENSE_RANK()` also gives tied values the same rank.

But it does **not** skip the next rank.

Example:

``` text
80000 → 1
70000 → 2
70000 → 2
60000 → 3
```

------------------------------------------------------------------------

# DENSE_RANK() Example

``` sql
SELECT
    FirstName,
    Salary,
    DENSE_RANK() OVER(
        ORDER BY Salary DESC
    ) AS Salary_Rank
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# ⭐ ROW_NUMBER vs RANK vs DENSE_RANK

Suppose:

``` text
100
90
90
80
```

### ROW_NUMBER()

``` text
100 → 1
90  → 2
90  → 3
80  → 4
```

### RANK()

``` text
100 → 1
90  → 2
90  → 2
80  → 4
```

### DENSE_RANK()

``` text
100 → 1
90  → 2
90  → 2
80  → 3
```

------------------------------------------------------------------------

# Easy Memory Trick

``` text
ROW_NUMBER
→ Every row gets a different number

RANK
→ Same values = same rank + gaps

DENSE_RANK
→ Same values = same rank + no gaps
```

------------------------------------------------------------------------

# NTILE()

## What is NTILE()?

`NTILE(n)` divides rows into `n` groups or buckets.

Example:

``` sql
NTILE(4)
```

means:

``` text
Divide rows into 4 groups
```

------------------------------------------------------------------------

# NTILE() Example

``` sql
SELECT
    FirstName,
    Salary,
    NTILE(4) OVER(
        ORDER BY Salary DESC
    ) AS Salary_Group
FROM EMPLOYEE;
```

If there are 8 rows:

``` text
Group 1 → 2 rows
Group 2 → 2 rows
Group 3 → 2 rows
Group 4 → 2 rows
```

If the rows cannot be divided equally, the database distributes the
extra rows as evenly as possible, with earlier buckets receiving the
extra rows.

------------------------------------------------------------------------

# Real-World Use of NTILE()

A company wants to divide employees into:

``` text
Top 25%
Second 25%
Third 25%
Bottom 25%
```

Use:

``` sql
NTILE(4)
```

------------------------------------------------------------------------

# 3️⃣ Value / Analytical Functions

Main functions:

``` text
LAG()
LEAD()
FIRST_VALUE()
LAST_VALUE()
```

------------------------------------------------------------------------

# LAG()

## What is LAG()?

`LAG()` looks at a **previous row**.

Easy memory:

``` text
LAG → Look Back
```

Example:

``` sql
SELECT
    EID,
    FirstName,
    Salary,
    LAG(Salary) OVER(
        ORDER BY EID
    ) AS Previous_Salary
FROM EMPLOYEE;
```

Concept:

``` text
Current row
     ↓
Previous row
```

------------------------------------------------------------------------

# LAG() Example

Suppose:

``` text
EID   Salary
101   50000
102   60000
103   70000
```

Result:

``` text
EID   Salary   Previous_Salary
101   50000    NULL
102   60000    50000
103   70000    60000
```

The first row has no previous row, so it gets `NULL`.

------------------------------------------------------------------------

# LAG() Offset

By default:

``` sql
LAG(Salary)
```

means previous 1 row.

For two rows back:

``` sql
LAG(Salary, 2)
```

means:

``` text
Look 2 rows backward
```

Some SQL dialects also support a default value:

``` sql
LAG(Salary, 1, 0) OVER(ORDER BY EID)
```

which can return `0` when there is no previous row. Check the syntax
supported by your database version.

------------------------------------------------------------------------

# LEAD()

## What is LEAD()?

`LEAD()` looks at a **next row**.

Easy memory:

``` text
LEAD → Look Forward
```

Example:

``` sql
SELECT
    EID,
    FirstName,
    Salary,
    LEAD(Salary) OVER(
        ORDER BY EID
    ) AS Next_Salary
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# LEAD() Example

``` text
EID   Salary   Next_Salary
101   50000    60000
102   60000    70000
103   70000    NULL
```

The last row has no next row.

------------------------------------------------------------------------

# LAG vs LEAD

| LAG | LEAD |
|---|---|
| Looks backward | Looks forward |
| Previous row | Next row |
| Previous value | Next value |

Easy:

``` text
LAG  → Back
LEAD → Forward
```

------------------------------------------------------------------------

# FIRST_VALUE()

## What is FIRST_VALUE()?

`FIRST_VALUE()` returns the first value according to the window ordering
and frame.

Example:

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    FIRST_VALUE(Salary) OVER(
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS Highest_Dept_Salary
FROM EMPLOYEE;
```

Because the order is descending:

``` text
First value = highest salary
```

If we use:

``` sql
ORDER BY Salary ASC
```

then the first value is the lowest salary.

------------------------------------------------------------------------

# LAST_VALUE()

## What is LAST_VALUE()?

`LAST_VALUE()` returns the last value according to the window ordering
and frame.

This function is important because the **window frame matters**.

To get the last value of the complete department partition, use an
explicit full frame:

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    LAST_VALUE(Salary) OVER(
        PARTITION BY Department
        ORDER BY Salary
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND UNBOUNDED FOLLOWING
    ) AS Last_Dept_Salary
FROM EMPLOYEE;
```

Meaning:

``` text
Start at first row
        ↓
Include all rows
        ↓
Finish at last row
```

------------------------------------------------------------------------

# ⭐ Why LAST_VALUE() Confuses Students

Students often write:

``` sql
LAST_VALUE(Salary) OVER(
    PARTITION BY Department
    ORDER BY Salary
)
```

and expect the last salary of the whole department.

But `LAST_VALUE()` depends on the current **window frame**.

Therefore, when the requirement is "last value of the complete
partition", explicitly use:

``` sql
ROWS BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING
```

------------------------------------------------------------------------

# FIRST_VALUE vs LAST_VALUE

| Function | Meaning |
|---|---|
| `FIRST_VALUE()` | First value in the window/frame |
| `LAST_VALUE()` | Last value in the window/frame |

------------------------------------------------------------------------

# ⭐ PARTITION BY

## What is PARTITION BY?

`PARTITION BY` divides rows into separate windows.

Example:

``` sql
AVG(Salary) OVER(
    PARTITION BY Department
)
```

creates:

``` text
IT Window
----------------
Deep
Rahul
Riya

HR Window
----------------
Priya
Amit
Neha

Sales Window
----------------
Jay
Kiran
```

The function works separately inside every window.

------------------------------------------------------------------------

# PARTITION BY vs GROUP BY

They look similar but behave differently.

``` text
GROUP BY
→ combines rows into groups and reduces rows

PARTITION BY
→ divides rows into windows but keeps rows
```

Example:

``` sql
SELECT Department, AVG(Salary)
FROM EMPLOYEE
GROUP BY Department;
```

vs:

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    AVG(Salary) OVER(
        PARTITION BY Department
    ) AS Dept_Avg
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# ⭐ OVER() Without PARTITION BY

``` sql
AVG(Salary) OVER()
```

means:

``` text
Use all rows as one window.
```

------------------------------------------------------------------------

# ⭐ OVER() With PARTITION BY

``` sql
AVG(Salary) OVER(
    PARTITION BY Department
)
```

means:

``` text
Create one window for every department.
```

------------------------------------------------------------------------

# Window ORDER BY vs Final ORDER BY

These are different.

## Window ORDER BY

``` sql
ROW_NUMBER() OVER(
    ORDER BY Salary DESC
)
```

controls how the function calculates.

## Final ORDER BY

``` sql
ORDER BY FirstName;
```

controls how the final result is displayed.

They can be different.

Example:

``` sql
SELECT
    FirstName,
    Salary,
    ROW_NUMBER() OVER(
        ORDER BY Salary DESC
    ) AS RN
FROM EMPLOYEE
ORDER BY FirstName;
```

Numbering is based on salary, but display is sorted by name.

------------------------------------------------------------------------

# ⭐ Deterministic ROW_NUMBER()

If two rows have the same ordering value:

``` sql
ROW_NUMBER() OVER(
    ORDER BY Salary DESC
)
```

the order between tied rows may not be predictable.

If you need a fixed order, add a tie-breaker:

``` sql
ROW_NUMBER() OVER(
    ORDER BY Salary DESC, EID ASC
)
```

Meaning:

``` text
First compare Salary
If salary is equal
→ compare EID
```

------------------------------------------------------------------------

# Window Frame

A **window frame** specifies which rows are included for the current
calculation.

Common terms:

``` text
ROWS
BETWEEN
UNBOUNDED PRECEDING
CURRENT ROW
UNBOUNDED FOLLOWING
```

------------------------------------------------------------------------

# Running Total Frame

``` sql
ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW
```

means:

``` text
Start from the first row
+
include rows up to current row
```

Example:

``` sql
SUM(Salary) OVER(
    ORDER BY EID
    ROWS BETWEEN UNBOUNDED PRECEDING
    AND CURRENT ROW
)
```

------------------------------------------------------------------------

# Full Partition Frame

``` sql
ROWS BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING
```

means:

``` text
First row → current row → last row
```

This is especially useful with `LAST_VALUE()` when the complete
partition is required.

------------------------------------------------------------------------

# Top 1 Employee Per Department

First rank employees:

``` sql
SELECT
    E.*,
    ROW_NUMBER() OVER(
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS RN
FROM EMPLOYEE E;
```

Then filter:

``` sql
SELECT *
FROM
(
    SELECT
        E.*,
        ROW_NUMBER() OVER(
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS RN
    FROM EMPLOYEE E
) X
WHERE RN=1;
```

------------------------------------------------------------------------

# Top 2 Employees Per Department

``` sql
SELECT *
FROM
(
    SELECT
        E.*,
        ROW_NUMBER() OVER(
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS RN
    FROM EMPLOYEE E
) X
WHERE RN<=2;
```

------------------------------------------------------------------------

# Top 3 Salary Ranks Overall

If tied salaries should share the same rank:

``` sql
SELECT *
FROM
(
    SELECT
        E.*,
        DENSE_RANK() OVER(
            ORDER BY Salary DESC
        ) AS DR
    FROM EMPLOYEE E
) X
WHERE DR<=3;
```

------------------------------------------------------------------------

# Highest-Paid Employee in Every Department

``` sql
WITH RankedEmployees AS
(
    SELECT
        E.*,
        ROW_NUMBER() OVER(
            PARTITION BY Department
            ORDER BY Salary DESC, EID
        ) AS RN
    FROM EMPLOYEE E
)
SELECT *
FROM RankedEmployees
WHERE RN=1;
```

------------------------------------------------------------------------

# Second-Highest Salary in Every Department

Use `DENSE_RANK()`:

``` sql
WITH RankedEmployees AS
(
    SELECT
        E.*,
        DENSE_RANK() OVER(
            PARTITION BY Department
            ORDER BY Salary DESC
        ) AS DR
    FROM EMPLOYEE E
)
SELECT *
FROM RankedEmployees
WHERE DR=2;
```

This keeps all employees who share the second-highest salary.

------------------------------------------------------------------------

# Salary Difference from Previous Row

``` sql
SELECT
    FirstName,
    Salary,
    Salary -
    LAG(Salary) OVER(
        ORDER BY EID
    ) AS Salary_Difference
FROM EMPLOYEE;
```

This compares the current salary with the previous employee's salary.

------------------------------------------------------------------------

# Department Average and Difference

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    AVG(Salary) OVER(
        PARTITION BY Department
    ) AS Dept_Avg,
    Salary -
    AVG(Salary) OVER(
        PARTITION BY Department
    ) AS Difference_From_Avg
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# Window Function vs Subquery

A subquery can calculate a value:

``` sql
SELECT
    E.*,
    (
        SELECT AVG(Salary)
        FROM EMPLOYEE
    ) AS Avg_Salary
FROM EMPLOYEE E;
```

A Window Function can express the same idea more directly:

``` sql
SELECT
    E.*,
    AVG(Salary) OVER() AS Avg_Salary
FROM EMPLOYEE E;
```

Window Functions become especially useful for ranking, previous/next
rows, running totals, and partition-wise analysis.

------------------------------------------------------------------------

# Window Function vs JOIN

Use a `JOIN` when you need to combine related columns from different
tables.

Use a Window Function when you need calculations such as:

``` text
Ranking
Running total
Previous row
Next row
Department average
Top N per department
```

Easy memory:

``` text
JOIN
→ combines columns

SET OPERATOR
→ combines rows from result sets

WINDOW FUNCTION
→ calculates across related rows while keeping rows
```

------------------------------------------------------------------------

# Window Functions with WHERE

A Window Function result generally cannot be filtered directly in the
same query's `WHERE`.

This is not the normal pattern:

``` sql
SELECT
    FirstName,
    Salary,
    ROW_NUMBER() OVER(
        ORDER BY Salary DESC
    ) AS RN
FROM EMPLOYEE
WHERE RN=1;
```

Why?

Because the `WHERE` phase is logically processed before the Window
Function result is available.

------------------------------------------------------------------------

# Correct Method Using Subquery

``` sql
SELECT *
FROM
(
    SELECT
        FirstName,
        Salary,
        ROW_NUMBER() OVER(
            ORDER BY Salary DESC
        ) AS RN
    FROM EMPLOYEE
) X
WHERE RN=1;
```

------------------------------------------------------------------------

# Correct Method Using CTE

``` sql
WITH RankedEmployees AS
(
    SELECT
        FirstName,
        Salary,
        ROW_NUMBER() OVER(
            ORDER BY Salary DESC
        ) AS RN
    FROM EMPLOYEE
)
SELECT *
FROM RankedEmployees
WHERE RN=1;
```

------------------------------------------------------------------------

# SQL Logical Processing - Simple View

A simplified learning model is:

``` text
FROM
  ↓
WHERE
  ↓
GROUP BY
  ↓
HAVING
  ↓
SELECT
  ↓
WINDOW CALCULATION
  ↓
ORDER BY
```

The database optimizer may execute operations differently internally,
but this logical order is useful for understanding why a Window Function
alias normally cannot be used directly in `WHERE`.

------------------------------------------------------------------------

# NULL Values

Window Functions can encounter `NULL`.

For aggregate functions such as:

``` sql
AVG(Salary) OVER()
```

`NULL` salary values are generally treated like normal aggregate
calculations, where `AVG()` ignores `NULL` values.

For:

``` sql
LAG()
LEAD()
```

if the requested previous/next row does not exist, the result is
normally `NULL` unless a supported default argument is supplied.

Always consider the meaning of `NULL` in the business data.

------------------------------------------------------------------------

# Common Mistakes

## ❌ Mistake 1 - Forgetting OVER()

Wrong:

``` sql
SELECT FirstName, AVG(Salary)
FROM EMPLOYEE;
```

Correct:

``` sql
SELECT
    FirstName,
    AVG(Salary) OVER() AS Avg_Salary
FROM EMPLOYEE;
```

------------------------------------------------------------------------

## ❌ Mistake 2 - Thinking PARTITION BY Removes Rows

It does not.

``` sql
AVG(Salary) OVER(
    PARTITION BY Department
)
```

keeps every employee row.

------------------------------------------------------------------------

## ❌ Mistake 3 - Confusing RANK and DENSE_RANK

Remember:

``` text
RANK
→ gaps after ties

DENSE_RANK
→ no gaps after ties
```

------------------------------------------------------------------------

## ❌ Mistake 4 - Using ROW_NUMBER for Shared Rank

If tied salaries should receive the same rank, use:

``` text
RANK()
```

or:

``` text
DENSE_RANK()
```

not `ROW_NUMBER()`.

------------------------------------------------------------------------

## ❌ Mistake 5 - Forgetting ORDER BY for Ranking

Use:

``` sql
ROW_NUMBER() OVER(
    ORDER BY Salary DESC
)
```

to define the order.

------------------------------------------------------------------------

## ❌ Mistake 6 - Confusing Window ORDER BY with Final ORDER BY

``` sql
ROW_NUMBER() OVER(
    ORDER BY Salary DESC
)
```

controls numbering.

``` sql
ORDER BY FirstName
```

controls final display.

------------------------------------------------------------------------

## ❌ Mistake 7 - Misunderstanding LAST_VALUE()

The last value depends on the window frame.

For the complete partition, use:

``` sql
ROWS BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING
```

when appropriate.

------------------------------------------------------------------------

# Best Practices

-   Learn `OVER()` first.
-   Use `PARTITION BY` when a calculation must restart for each group.
-   Use `ORDER BY` when row order matters.
-   Add a tie-breaker for deterministic `ROW_NUMBER()`.
-   Use `ROW_NUMBER()` for unique numbering.
-   Use `RANK()` for ranking with gaps.
-   Use `DENSE_RANK()` for ranking without gaps.
-   Use `NTILE()` for buckets.
-   Use `LAG()` for previous rows.
-   Use `LEAD()` for next rows.
-   Be careful with `LAST_VALUE()` and window frames.
-   Use a CTE or subquery when filtering a Window Function result.
-   Keep aliases meaningful.
-   Test complex Window Functions using small sample data first.

------------------------------------------------------------------------

# Real-World Applications

Window Functions are useful in:

-   Employee Management
-   Salary Analysis
-   Student Ranking
-   Sales Reports
-   Banking
-   Finance
-   E-commerce
-   Hospital Reports
-   Inventory
-   Attendance Systems
-   Sports Statistics
-   Customer Analytics
-   Business Intelligence
-   Data Analysis

------------------------------------------------------------------------

# Real-World Example 1 - Department Ranking

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    RANK() OVER(
        PARTITION BY Department
        ORDER BY Salary DESC
    ) AS Dept_Rank
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# Real-World Example 2 - Previous Salary

``` sql
SELECT
    FirstName,
    Salary,
    LAG(Salary) OVER(
        ORDER BY EID
    ) AS Previous_Salary
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# Real-World Example 3 - Running Total

``` sql
SELECT
    EID,
    FirstName,
    Salary,
    SUM(Salary) OVER(
        ORDER BY EID
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS Running_Total
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# Real-World Example 4 - Department Average

``` sql
SELECT
    FirstName,
    Department,
    Salary,
    AVG(Salary) OVER(
        PARTITION BY Department
    ) AS Dept_Avg
FROM EMPLOYEE;
```

------------------------------------------------------------------------

# Real-World Example 5 - Top Employee Per Department

``` sql
WITH RankedEmployees AS
(
    SELECT
        E.*,
        ROW_NUMBER() OVER(
            PARTITION BY Department
            ORDER BY Salary DESC, EID
        ) AS RN
    FROM EMPLOYEE E
)
SELECT *
FROM RankedEmployees
WHERE RN=1;
```

------------------------------------------------------------------------

# ⭐ How to Choose the Correct Window Function

When students get a question, first ask:

## Question 1: Do I need a total or calculation?

Use:

``` text
SUM()
AVG()
COUNT()
MIN()
MAX()
```

## Question 2: Do I need a position/rank?

Use:

``` text
ROW_NUMBER()
RANK()
DENSE_RANK()
NTILE()
```

## Question 3: Do I need the previous row?

Use:

``` text
LAG()
```

## Question 4: Do I need the next row?

Use:

``` text
LEAD()
```

## Question 5: Do I need the first value?

Use:

``` text
FIRST_VALUE()
```

## Question 6: Do I need the last value?

Use:

``` text
LAST_VALUE()
```

and carefully check the window frame.

## Question 7: Should the calculation restart for every department?

Add:

``` sql
PARTITION BY Department
```

## Question 8: Does the calculation need a specific order?

Add:

``` sql
ORDER BY ...
```

------------------------------------------------------------------------

# 🎯 How to Explain Window Functions to Students Easily

Start with this table:

``` text
Name     Department    Salary
Deep     IT            70000
Rahul    IT            60000
Riya     IT            80000
Priya    HR            65000
Amit     HR            55000
Neha     HR            65000
```

Ask:

> "Can I find the average salary of every department?"

Students will probably say:

``` sql
GROUP BY Department
```

Show:

``` sql
SELECT Department, AVG(Salary)
FROM EMPLOYEE
GROUP BY Department;
```

Then ask:

> "But can I show the employee AND the department average on the same
> row?"

Now introduce:

``` sql
AVG(Salary) OVER(
    PARTITION BY Department
)
```

Tell them:

``` text
GROUP BY
→ Summary only

WINDOW FUNCTION
→ Detail + calculation
```

This is an easy way to introduce the topic.

------------------------------------------------------------------------

# 🎯 How to Explain PARTITION BY

Tell students:

> "`PARTITION BY` means divide the rows into separate windows."

Example:

``` sql
PARTITION BY Department
```

creates:

``` text
IT Window
----------------
Deep
Rahul
Riya

HR Window
----------------
Priya
Amit
Neha

Sales Window
----------------
Jay
Kiran
```

Then explain:

> "The function works separately inside each window."

------------------------------------------------------------------------

# 🎯 How to Explain Ranking

Use:

``` text
Student   SPI
A         9.5
B         9.0
C         9.0
D         8.5
```

Then show:

``` text
ROW_NUMBER → 1, 2, 3, 4
RANK       → 1, 2, 2, 4
DENSE_RANK → 1, 2, 2, 3
```

Students can immediately see the difference.

------------------------------------------------------------------------

# 🎯 How to Explain LAG and LEAD

Use:

``` text
Month    Sales
Jan      100
Feb      120
Mar      150
```

Explain:

``` text
LAG
→ Previous month

LEAD
→ Next month
```

So:

``` text
Feb LAG  = Jan
Feb LEAD = Mar
```

------------------------------------------------------------------------

# 🎯 How to Explain NTILE

Suppose there are 12 students.

``` sql
NTILE(4)
```

means:

``` text
Group 1 → 3 students
Group 2 → 3 students
Group 3 → 3 students
Group 4 → 3 students
```

Tell students:

> "NTILE divides the ordered rows into a fixed number of buckets."

------------------------------------------------------------------------

# ⭐ Student-Friendly Memory Trick

``` text
SUM
→ How much total?

AVG
→ What is the average?

COUNT
→ How many?

MIN
→ What is the smallest?

MAX
→ What is the largest?

ROW_NUMBER
→ Give every row a unique number.

RANK
→ Same value = same rank, gaps allowed.

DENSE_RANK
→ Same value = same rank, no gaps.

NTILE
→ Divide rows into groups.

LAG
→ Look back.

LEAD
→ Look ahead.

FIRST_VALUE
→ Get the first value.

LAST_VALUE
→ Get the last value according to the window/frame.
```

------------------------------------------------------------------------

# ⭐ Interview Questions

1.  What is a Window Function?
2.  Why do we use Window Functions?
3.  What is the purpose of `OVER()`?
4.  What is `PARTITION BY`?
5.  Difference between `PARTITION BY` and `GROUP BY`?
6.  Difference between `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`?
7.  What is `NTILE()`?
8.  What is `LAG()`?
9.  What is `LEAD()`?
10. What is `FIRST_VALUE()`?
11. What is `LAST_VALUE()`?
12. Why can `LAST_VALUE()` be confusing?
13. What is a running total?
14. How do you calculate department-wise average without losing rows?
15. How do you find the top employee from every department?
16. How do you find the second-highest salary using a Window Function?
17. Can a Window Function result normally be used directly in `WHERE`?
18. Why do we use a subquery or CTE after a Window Function?
19. Difference between Window Functions and aggregate functions?
20. Difference between Window Functions and JOIN?
21. How do you handle ties in ranking?
22. How can `ROW_NUMBER()` be made deterministic?
23. What is a window frame?
24. What does `UNBOUNDED PRECEDING` mean?
25. What does `CURRENT ROW` mean?
26. What does `UNBOUNDED FOLLOWING` mean?

------------------------------------------------------------------------

# 📝 Practice Questions

Using the `EMPLOYEE` table:

1.  Display all employees with a row number based on `EID`.
2.  Display employees with row numbers based on salary descending.
3.  Generate department-wise row numbers.
4.  Rank all employees according to salary.
5.  Rank employees department-wise according to salary.
6.  Display employees using `DENSE_RANK()`.
7.  Display the top 3 salary ranks.
8.  Divide employees into 4 groups using `NTILE(4)`.
9.  Display the total salary along with every employee.
10. Display the department-wise total salary.
11. Display the overall average salary along with every employee.
12. Display the department-wise average salary.
13. Display the department-wise minimum salary.
14. Display the department-wise maximum salary.
15. Display the number of employees in each department using a Window
    Function.
16. Create a running salary total.
17. Create a department-wise running salary total.
18. Display each employee's previous salary using `LAG()`.
19. Display each employee's next salary using `LEAD()`.
20. Display the salary difference from the previous employee.
21. Display the highest salary of each department using `FIRST_VALUE()`.
22. Display the lowest salary of each department using `FIRST_VALUE()`
    with ascending order.
23. Display the last salary in each department using `LAST_VALUE()` with
    an explicit full-partition frame.
24. Find the highest-paid employee in every department.
25. Find the top 2 employees in every department.
26. Find the second-highest salary in every department using
    `DENSE_RANK()`.
27. Find employees whose salary is above their department average.
28. Find employees whose salary is equal to the department maximum.
29. Create a department-wise salary rank and sort the final result by
    department.
30. Use a CTE with a Window Function to find the top employee from each
    department.

------------------------------------------------------------------------

# 📊 Complete Summary Table

| Category | Function | Simple Meaning |
|---|---|---|
| Aggregate | `SUM()` | Total |
| Aggregate | `AVG()` | Average |
| Aggregate | `COUNT()` | Count |
| Aggregate | `MIN()` | Minimum |
| Aggregate | `MAX()` | Maximum |
| Ranking | `ROW_NUMBER()` | Unique row number |
| Ranking | `RANK()` | Rank with gaps after ties |
| Ranking | `DENSE_RANK()` | Rank without gaps |
| Ranking | `NTILE()` | Divide rows into groups |
| Analytical | `LAG()` | Previous row |
| Analytical | `LEAD()` | Next row |
| Analytical | `FIRST_VALUE()` | First value |
| Analytical | `LAST_VALUE()` | Last value according to frame |

------------------------------------------------------------------------

# ⭐ Final Comparison

| Requirement | Function |
|---|---|
| Total | `SUM()` |
| Average | `AVG()` |
| Count | `COUNT()` |
| Minimum | `MIN()` |
| Maximum | `MAX()` |
| Unique numbering | `ROW_NUMBER()` |
| Ranking with gaps | `RANK()` |
| Ranking without gaps | `DENSE_RANK()` |
| Divide into groups | `NTILE()` |
| Previous row | `LAG()` |
| Next row | `LEAD()` |
| First value | `FIRST_VALUE()` |
| Last value | `LAST_VALUE()` |

------------------------------------------------------------------------

# 🧠 Most Important Concepts

``` text
1. Window Function works across related rows.
2. OVER() is used for Window Functions.
3. PARTITION BY creates separate windows.
4. ORDER BY controls order inside the window.
5. Window Functions normally keep the original rows.
6. GROUP BY reduces rows; Window Functions normally do not.
7. ROW_NUMBER gives unique numbers.
8. RANK gives equal ranks with gaps.
9. DENSE_RANK gives equal ranks without gaps.
10. NTILE divides rows into buckets.
11. LAG looks backward.
12. LEAD looks forward.
13. FIRST_VALUE gets the first value.
14. LAST_VALUE depends on the window frame.
15. Use a subquery or CTE when filtering a Window Function result.
16. Add tie-breakers when deterministic ordering is required.
```

------------------------------------------------------------------------

# 🎓 Learning Outcome

After completing this lab, students will be able to:

-   Explain Window Functions in simple language.
-   Understand `OVER()`.
-   Use `PARTITION BY`.
-   Use `ORDER BY` inside Window Functions.
-   Use Aggregate Window Functions.
-   Use Ranking Functions.
-   Use Value / Analytical Functions.
-   Generate department-wise row numbers.
-   Rank employees and students.
-   Calculate running totals.
-   Compare previous and next rows.
-   Find top N records per group.
-   Divide records into buckets.
-   Understand window frames.
-   Use subqueries and CTEs with Window Functions.
-   Choose the correct Window Function for a problem.
-   Explain Window Functions confidently in an interview or classroom.

------------------------------------------------------------------------

# ⭐ Quick Final Revision

``` text
FUNCTION()
+
OVER()
=
WINDOW FUNCTION
```

Then:

``` text
OVER()
```

can become:

``` text
OVER(
    PARTITION BY ...
    ORDER BY ...
)
```

Main categories:

``` text
1. Aggregate
   SUM
   AVG
   COUNT
   MIN
   MAX

2. Ranking
   ROW_NUMBER
   RANK
   DENSE_RANK
   NTILE

3. Value / Analytical
   LAG
   LEAD
   FIRST_VALUE
   LAST_VALUE
```

------------------------------------------------------------------------

# ⭐ One Final Sentence

> **A Window Function performs calculations across a set of related rows
> while keeping the original rows in the result.**

------------------------------------------------------------------------

# ⭐ Happy Learning SQL ⭐
