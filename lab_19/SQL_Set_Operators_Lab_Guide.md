# 📘 SQL Lab 19 - Set Operators in SQL

![SQL](https://img.shields.io/badge/SQL-Learning-blue)
![Database](https://img.shields.io/badge/Database-MySQL-orange)
![GitHub](https://img.shields.io/badge/GitHub-README-success)
![Lab](https://img.shields.io/badge/Lab-19-green)

---

# 📌 Objective

The objective of this lab is to understand how **Set Operators** work in SQL and how they combine the results of two or more `SELECT` queries.

After completing this lab, students will be able to:

- Understand Set Operators
- Understand `UNION`
- Understand `UNION ALL`
- Understand `INTERSECT`
- Understand `EXCEPT`
- Understand the difference between `UNION` and `UNION ALL`
- Find common records using `INTERSECT`
- Find records available in one query but not another using `EXCEPT`
- Understand the rules required to combine queries
- Handle duplicate records
- Understand `NULL` values with Set Operators
- Use `ORDER BY` with Set Operators
- Combine Set Operators
- Choose between Set Operators and `JOIN`
- Solve real-world SQL problems using Set Operators

---

# 📚 Prerequisites

Before starting this lab, students should know:

- Database Basics
- Tables and Records
- `SELECT` Statement
- `WHERE` Clause
- `ORDER BY`
- `DISTINCT`
- Basic SQL Data Types

---

# 📋 Sample Tables

For learning Set Operators, it is useful to have two result sets.

## STUDENT_2025

| STID | SNAME | CITY | BRANCH |
|------|-------|------|--------|
|101|Deep|Rajkot|CE|
|102|Rahul|Surat|IT|
|103|Priya|Rajkot|CE|
|104|Amit|Ahmedabad|ME|

---

## STUDENT_2026

| STID | SNAME | CITY | BRANCH |
|------|-------|------|--------|
|103|Priya|Rajkot|CE|
|104|Amit|Ahmedabad|ME|
|105|Riya|Surat|IT|
|106|Neha|Rajkot|IT|

---

# 📖 Introduction

Sometimes we have two different `SELECT` queries and we want to combine their results.

For example:

```text
Query 1 → Students from 2025
Query 2 → Students from 2026
```

We may want:

- All students from both queries
- All students including duplicates
- Students common to both queries
- Students available in the first query but not the second

SQL provides **Set Operators** for this purpose.

---

# What is a Set Operator?

A **Set Operator** combines the result of two or more `SELECT` statements into one result.

The main Set Operators are:

| Set Operator | Purpose |
|--------------|---------|
| `UNION` | Combines results and removes duplicates |
| `UNION ALL` | Combines results and keeps duplicates |
| `INTERSECT` | Returns common rows |
| `EXCEPT` | Returns rows from first query that are not in second query |

Think of Set Operators like this:

```text
Query A
   +
Query B
   ↓
Combined Result
```

---

# ⭐ Important Idea

Set Operators combine **rows vertically**.

For example:

```text
Query A
---------
101
102
103

Query B
---------
103
104
105
```

Using `UNION`:

```text
101
102
103
104
105
```

The queries are placed one after another and duplicate rows are removed.

---

# Set Operators vs JOIN

This is one of the most important concepts.

## JOIN

A `JOIN` combines **columns from related tables**.

```text
Table A + Table B
       ↓
More Columns
```

Example:

```text
STUDENT
+ STUDENT_INFO
```

The result may contain:

```text
STID | SNAME | EMAIL | MOBILE
```

---

## Set Operator

A Set Operator combines **rows from query results**.

```text
Query A
+
Query B
↓
More Rows
```

Example:

```text
2025 Students
+
2026 Students
```

The result contains more rows.

---

# Easy Way to Remember

```text
JOIN
→ combines columns

SET OPERATOR
→ combines rows
```

---

# Rules of Set Operators

Before using Set Operators, the queries must follow important rules.

## Rule 1: Same Number of Columns

Both queries should return the same number of columns.

Correct:

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION

SELECT STID, SNAME
FROM STUDENT_2026;
```

Both queries return:

```text
2 columns
```

---

## Rule 2: Corresponding Columns Must Have Compatible Data Types

The first column of Query 1 should be compatible with the first column of Query 2.

Example:

```text
Query 1          Query 2
--------         --------
STID (INT)       STID (INT)
SNAME (VARCHAR)  SNAME (VARCHAR)
```

This is correct.

---

## Rule 3: Column Order Matters

SQL matches columns by their **position**, not by their name.

Example:

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION

SELECT STID, SNAME
FROM STUDENT_2026;
```

Here:

```text
1st column ↔ 1st column
2nd column ↔ 2nd column
```

---

## Rule 4: Column Names Come From the First Query

Example:

```sql
SELECT STID AS ID, SNAME AS NAME
FROM STUDENT_2025

UNION

SELECT STID AS STUDENT_ID, SNAME AS STUDENT_NAME
FROM STUDENT_2026;
```

The final result uses:

```text
ID
NAME
```

because the column names are taken from the first `SELECT`.

---

# UNION

## What is UNION?

`UNION` combines the results of two or more queries and **removes duplicate rows**.

---

## Syntax

```sql
SELECT column1, column2
FROM table1

UNION

SELECT column1, column2
FROM table2;
```

---

## Example

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION

SELECT STID, SNAME
FROM STUDENT_2026;
```

---

## Result

```text
STID | SNAME
-----|------
101  | Deep
102  | Rahul
103  | Priya
104  | Amit
105  | Riya
106  | Neha
```

Notice:

```text
103 Priya
104 Amit
```

appear in both tables, but `UNION` keeps only one copy.

---

# How UNION Works

Suppose:

### Query 1

```text
101
102
103
```

### Query 2

```text
103
104
105
```

Using:

```sql
Query1
UNION
Query2
```

Result:

```text
101
102
103
104
105
```

Duplicate `103` is removed.

---

# UNION = Combine + Remove Duplicates

Remember:

```text
UNION
=
All rows
+
Remove duplicate rows
```

---

# UNION ALL

## What is UNION ALL?

`UNION ALL` combines the results of two or more queries and **keeps duplicate rows**.

---

## Syntax

```sql
SELECT column1, column2
FROM table1

UNION ALL

SELECT column1, column2
FROM table2;
```

---

## Example

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION ALL

SELECT STID, SNAME
FROM STUDENT_2026;
```

---

## Result

```text
STID | SNAME
-----|------
101  | Deep
102  | Rahul
103  | Priya
104  | Amit
103  | Priya
104  | Amit
105  | Riya
106  | Neha
```

Here `103 Priya` and `104 Amit` appear twice because `UNION ALL` does not remove duplicates.

---

# UNION vs UNION ALL

| UNION | UNION ALL |
|-------|-----------|
| Removes duplicate rows | Keeps duplicate rows |
| Performs duplicate elimination | No duplicate elimination |
| Usually requires more processing | Usually faster |
| Use when unique results are required | Use when every row is required |

---

# Easy Example

Query 1:

```text
A
B
C
```

Query 2:

```text
C
D
E
```

### UNION

```text
A
B
C
D
E
```

### UNION ALL

```text
A
B
C
C
D
E
```

---

# When Should We Use UNION?

Use `UNION` when:

- You want unique rows
- Duplicate records are not required
- You are combining similar result sets
- You are preparing a report where repeated rows should appear only once

---

# When Should We Use UNION ALL?

Use `UNION ALL` when:

- Duplicate rows are meaningful
- You need every record
- You know duplicates are not a problem
- You want to avoid unnecessary duplicate-removal processing

---

# INTERSECT

## What is INTERSECT?

`INTERSECT` returns only the rows that are present in **both queries**.

Think:

```text
Query A
   ∩
Query B
   ↓
Common Rows
```

The symbol `∩` represents intersection in set theory.

---

## Syntax

```sql
SELECT column1, column2
FROM table1

INTERSECT

SELECT column1, column2
FROM table2;
```

---

## Example

```sql
SELECT STID, SNAME
FROM STUDENT_2025

INTERSECT

SELECT STID, SNAME
FROM STUDENT_2026;
```

---

## Result

```text
STID | SNAME
-----|------
103  | Priya
104  | Amit
```

These students are present in both result sets.

---

# Easy Way to Understand INTERSECT

Suppose:

```text
Query 1 = {1, 2, 3, 4}

Query 2 = {3, 4, 5, 6}
```

Then:

```text
Query1 INTERSECT Query2
```

Result:

```text
{3, 4}
```

Only common values are returned.

---

# Real-World Example of INTERSECT

Suppose:

```text
Students who attended Workshop A
```

and:

```text
Students who attended Workshop B
```

We want students who attended **both workshops**.

```sql
SELECT STID
FROM WORKSHOP_A

INTERSECT

SELECT STID
FROM WORKSHOP_B;
```

---

# EXCEPT

## What is EXCEPT?

`EXCEPT` returns rows from the **first query** that are not present in the second query.

Think:

```text
Query A
-
Query B
↓
Only A
```

The order is very important.

---

## Syntax

```sql
SELECT column1, column2
FROM table1

EXCEPT

SELECT column1, column2
FROM table2;
```

---

## Example

```sql
SELECT STID, SNAME
FROM STUDENT_2025

EXCEPT

SELECT STID, SNAME
FROM STUDENT_2026;
```

---

## Result

```text
STID | SNAME
-----|------
101  | Deep
102  | Rahul
```

These students are in `STUDENT_2025` but not in `STUDENT_2026`.

---

# EXCEPT is Directional

This is extremely important.

```sql
A EXCEPT B
```

means:

```text
Rows in A
that are not in B
```

But:

```sql
B EXCEPT A
```

means:

```text
Rows in B
that are not in A
```

They can produce completely different results.

---

# Example

Query A:

```text
1
2
3
```

Query B:

```text
2
3
4
```

### A EXCEPT B

```text
1
```

### B EXCEPT A

```text
4
```

---

# Set Operators Visual Summary

Suppose:

```text
A = {1, 2, 3, 4}
B = {3, 4, 5, 6}
```

## UNION

```text
{1, 2, 3, 4, 5, 6}
```

## UNION ALL

```text
{1, 2, 3, 4, 3, 4, 5, 6}
```

## INTERSECT

```text
{3, 4}
```

## EXCEPT

```text
{1, 2}
```

---

# ⭐ One-Line Memory Trick

```text
UNION
→ Everything from both

UNION ALL
→ Everything from both + duplicates

INTERSECT
→ Common in both

EXCEPT
→ First but not second
```

---

# Set Operators with WHERE

Set Operators can be combined with `WHERE`.

Example:

```sql
SELECT STID, SNAME
FROM STUDENT_2025
WHERE BRANCH='IT'

UNION

SELECT STID, SNAME
FROM STUDENT_2026
WHERE BRANCH='IT';
```

This returns IT students from both result sets.

---

# Set Operators with DISTINCT

`UNION` already removes duplicate rows.

Therefore, this:

```sql
SELECT DISTINCT STID
FROM STUDENT_2025

UNION

SELECT DISTINCT STID
FROM STUDENT_2026;
```

may perform duplicate removal at both individual query levels and the final set operation.

In many cases, simply using:

```sql
SELECT STID
FROM STUDENT_2025

UNION

SELECT STID
FROM STUDENT_2026;
```

is enough when only the final unique result is required.

---

# ORDER BY with Set Operators

`ORDER BY` is normally written at the **end of the complete Set Operator query**.

Correct:

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION

SELECT STID, SNAME
FROM STUDENT_2026

ORDER BY STID;
```

The final combined result is sorted.

---

# ORDER BY DESC

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION

SELECT STID, SNAME
FROM STUDENT_2026

ORDER BY STID DESC;
```

---

# Important ORDER BY Rule

Usually, do not write:

```sql
SELECT STID, SNAME
FROM STUDENT_2025
ORDER BY STID

UNION

SELECT STID, SNAME
FROM STUDENT_2026;
```

Instead, put the final ordering after the complete set expression.

---

# Set Operators with Different Tables

Set Operators do not require the tables themselves to have the same name.

The important requirement is that the **result of each SELECT** is compatible.

Example:

```sql
SELECT EID, FirstName
FROM EMPLOYEE

UNION

SELECT STID, SNAME
FROM STUDENT;
```

This can work if:

```text
EID   → compatible with STID
FirstName → compatible with SNAME
```

The table names do not matter.

---

# Example with Different Column Names

```sql
SELECT EID, FirstName
FROM EMPLOYEE

UNION

SELECT STID, SNAME
FROM STUDENT;
```

The first query's column names are used in the final result.

---

# ❌ Different Number of Columns

This is wrong:

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION

SELECT STID
FROM STUDENT_2026;
```

Why?

First query:

```text
2 columns
```

Second query:

```text
1 column
```

The number of columns does not match.

---

# ❌ Incompatible Data Types

Example:

```sql
SELECT STID
FROM STUDENT

UNION

SELECT SNAME
FROM STUDENT;
```

If the corresponding expressions have incompatible data types, the database may reject the query or require conversion.

Always make corresponding columns compatible.

---

# NULL with Set Operators

`NULL` can appear in Set Operator results.

Example:

```sql
SELECT STID, SNAME, CITY
FROM STUDENT_2025

UNION

SELECT STID, SNAME, NULL
FROM STUDENT_2026;
```

Here the third column of the second query is a `NULL` value.

The corresponding column must still be type-compatible with the first query's third column.

---

# Duplicate Rows and NULL

For duplicate elimination, Set Operators treat matching rows as duplicates even when corresponding values are `NULL`.

For example:

```text
Query 1
---------
101 | NULL

Query 2
---------
101 | NULL
```

With `UNION`, the duplicate row is removed.

With `UNION ALL`, both rows remain.

---

# Combining Multiple Set Operators

More than two queries can be combined.

Example:

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION

SELECT STID, SNAME
FROM STUDENT_2026

UNION

SELECT STID, SNAME
FROM STUDENT_2027;
```

---

# Mixing Different Set Operators

Set Operators can also be combined.

Example:

```sql
SELECT STID
FROM STUDENT_2025

UNION

SELECT STID
FROM STUDENT_2026

INTERSECT

SELECT STID
FROM STUDENT_2027;
```

When combining different operators, use parentheses when you need to make the intended grouping explicit.

Do not depend on operator precedence when teaching or writing a complex query.

---

# Parentheses with Set Operators

Parentheses can make the intended operation clear.

Example:

```sql
(
    SELECT STID
    FROM STUDENT_2025

    UNION

    SELECT STID
    FROM STUDENT_2026
)

INTERSECT

SELECT STID
FROM STUDENT_2027;
```

This first combines 2025 and 2026, then finds the common records with 2027.

---

# Set Operators and Aggregate Functions

Set Operators can combine aggregate query results as long as the resulting columns are compatible.

Example:

```sql
SELECT BRANCH, COUNT(*) AS TOTAL
FROM STUDENT_2025
GROUP BY BRANCH

UNION ALL

SELECT BRANCH, COUNT(*) AS TOTAL
FROM STUDENT_2026
GROUP BY BRANCH;
```

This combines the branch-wise counts from both years.

---

# Set Operators and GROUP BY

Each individual query can contain its own `GROUP BY`.

Example:

```sql
SELECT BRANCH, COUNT(*) AS TOTAL
FROM STUDENT_2025
GROUP BY BRANCH

UNION ALL

SELECT BRANCH, COUNT(*) AS TOTAL
FROM STUDENT_2026
GROUP BY BRANCH;
```

Remember:

```text
GROUP BY
→ works inside each SELECT

UNION / UNION ALL
→ combines their final results
```

---

# Set Operators and HAVING

Example:

```sql
SELECT BRANCH, AVG(SPI) AS AVG_SPI
FROM STUDENT_2025
GROUP BY BRANCH
HAVING AVG(SPI) > 8

UNION

SELECT BRANCH, AVG(SPI) AS AVG_SPI
FROM STUDENT_2026
GROUP BY BRANCH
HAVING AVG(SPI) > 8;
```

---

# Set Operators vs IN

Students often confuse these two.

## IN

`IN` compares one value against a list/result.

Example:

```sql
SELECT *
FROM STUDENT
WHERE BRANCH IN
(
    SELECT BRANCH
    FROM STUDENT
    WHERE CITY='Rajkot'
);
```

The subquery provides values for filtering.

---

## UNION

`UNION` combines complete query results.

Example:

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION

SELECT STID, SNAME
FROM STUDENT_2026;
```

---

# Easy Difference

```text
IN
→ filtering

UNION
→ combining result sets
```

---

# Set Operators vs JOIN

| JOIN | Set Operator |
|------|--------------|
| Combines columns | Combines rows |
| Usually uses related columns | Combines compatible result sets |
| Can produce wider results | Usually keeps same column structure |
| Example: INNER JOIN | Example: UNION |

---

# UNION vs JOIN Example

Suppose:

```text
EMPLOYEE
EID | NAME
1   | Deep
2   | Rahul
```

and:

```text
MANAGER
MID | NAME
3   | Priya
4   | Riya
```

If we want all people from both tables:

```sql
SELECT EID, NAME
FROM EMPLOYEE

UNION

SELECT MID, NAME
FROM MANAGER;
```

Use a Set Operator.

If we want employee details plus department details from related tables, a `JOIN` is more appropriate.

---

# Real-World Applications

Set Operators are useful in:

- Student Management Systems
- HR Systems
- Banking Systems
- Hospital Systems
- E-commerce
- Attendance Systems
- Inventory Systems
- Payroll Systems
- Reporting Systems
- Data Migration
- Data Comparison
- Audit Systems

---

# Real-World Example 1 - Students from Two Years

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION

SELECT STID, SNAME
FROM STUDENT_2026;
```

Purpose:

```text
Get unique students from both years.
```

---

# Real-World Example 2 - Students Common to Two Years

```sql
SELECT STID, SNAME
FROM STUDENT_2025

INTERSECT

SELECT STID, SNAME
FROM STUDENT_2026;
```

Purpose:

```text
Find students appearing in both datasets.
```

---

# Real-World Example 3 - Students Who Left

```sql
SELECT STID, SNAME
FROM STUDENT_2025

EXCEPT

SELECT STID, SNAME
FROM STUDENT_2026;
```

Purpose:

```text
Students in 2025 but not in 2026.
```

---

# Real-World Example 4 - Students in Either Dataset, Including Repeated Rows

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION ALL

SELECT STID, SNAME
FROM STUDENT_2026;
```

Purpose:

```text
Keep every row from both datasets.
```

---

# SQL Dialect Note

Set Operator support can vary by database system.

For example:

- `UNION` and `UNION ALL` are widely supported.
- `INTERSECT` is supported by modern MySQL versions and other major SQL databases.
- `EXCEPT` is supported by SQL Server, PostgreSQL, and modern MySQL.
- Oracle commonly uses `MINUS` for the operation equivalent to `EXCEPT`.

For this lab, examples use MySQL syntax.

If your lab uses an older MySQL version, check whether `INTERSECT` and `EXCEPT` are supported before running those queries.

---

# Performance Notes

`UNION` has to remove duplicate rows.

Therefore:

```text
UNION
→ combine
→ identify duplicates
→ remove duplicates
```

`UNION ALL` does not need that duplicate-removal step.

Therefore, when duplicates are intentionally required, `UNION ALL` is generally preferred.

Do not choose `UNION ALL` merely for speed if duplicate removal is required for correctness.

---

# Best Practices

- Make sure both queries return the same number of columns.
- Keep corresponding columns type-compatible.
- Remember that column position matters.
- Remember that output column names come from the first query.
- Use `UNION` when duplicates must be removed.
- Use `UNION ALL` when duplicates are meaningful or should be preserved.
- Use `INTERSECT` for common rows.
- Use `EXCEPT` for rows in the first result but not the second.
- Remember that `EXCEPT` is directional.
- Put the final `ORDER BY` after the complete set expression.
- Use parentheses for complex combinations of operators.
- Keep queries formatted and easy to read.
- Use `JOIN` when the real requirement is to combine related columns.

---

# Common Mistakes

## ❌ Mistake 1: Different Number of Columns

Wrong:

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION

SELECT STID
FROM STUDENT_2026;
```

Correct:

```sql
SELECT STID, SNAME
FROM STUDENT_2025

UNION

SELECT STID, SNAME
FROM STUDENT_2026;
```

---

## ❌ Mistake 2: Expecting UNION ALL to Remove Duplicates

```sql
SELECT STID
FROM STUDENT_2025

UNION ALL

SELECT STID
FROM STUDENT_2026;
```

`UNION ALL` keeps duplicates.

If unique rows are required:

```sql
SELECT STID
FROM STUDENT_2025

UNION

SELECT STID
FROM STUDENT_2026;
```

---

## ❌ Mistake 3: Reversing EXCEPT

These are not the same:

```sql
A EXCEPT B
```

and:

```sql
B EXCEPT A
```

Always identify which result should be the "first" result.

---

## ❌ Mistake 4: Thinking Column Names Must Match

This can still work:

```sql
SELECT EID, FirstName
FROM EMPLOYEE

UNION

SELECT STID, SNAME
FROM STUDENT;
```

The column names do not have to be identical.

The corresponding expressions need to be compatible.

---

## ❌ Mistake 5: Using Set Operator When JOIN Is Required

If you need:

```text
Employee Name + Department Name
```

a `JOIN` may be appropriate.

If you need:

```text
Employees + Managers
```

with the same result structure, a Set Operator may be appropriate.

---

# Interview Questions

1. What is a Set Operator?
2. What are the different Set Operators in SQL?
3. What is the difference between `UNION` and `UNION ALL`?
4. Does `UNION` remove duplicates?
5. Does `UNION ALL` remove duplicates?
6. What does `INTERSECT` return?
7. What does `EXCEPT` return?
8. Is `EXCEPT` directional?
9. How many columns must both SELECT statements return?
10. Do column names have to be the same?
11. Do corresponding columns need compatible data types?
12. Which query determines the final column names?
13. Where should `ORDER BY` normally be written?
14. What is the difference between `JOIN` and Set Operators?
15. When should `UNION ALL` be preferred over `UNION`?
16. Can more than two queries be combined using Set Operators?
17. Can `WHERE` be used with each SELECT?
18. Can `GROUP BY` be used with each SELECT?
19. Can Set Operators be combined with aggregate functions?
20. What is the equivalent of `EXCEPT` in Oracle?

---

# Practice Questions

Assume the following tables:

```text
STUDENT_2025
STUDENT_2026
```

1. Display all students from both years using `UNION`.
2. Display all students from both years using `UNION ALL`.
3. Find students present in both years using `INTERSECT`.
4. Find students present in 2025 but not 2026 using `EXCEPT`.
5. Find students present in 2026 but not 2025.
6. Display only `STID` from both tables using `UNION`.
7. Display students from both years whose branch is `IT`.
8. Combine both tables and sort the result by `STID`.
9. Find common student IDs between the two tables.
10. Find student IDs that exist only in the 2025 table.
11. Find student IDs that exist only in the 2026 table.
12. Count branch-wise students from both years and combine the results using `UNION ALL`.
13. Combine three yearly student tables using `UNION`.
14. Write an example showing why `UNION ALL` can contain duplicates.
15. Explain the difference between `A EXCEPT B` and `B EXCEPT A`.

---

# Quick Revision

## UNION

```sql
SELECT ...
FROM A

UNION

SELECT ...
FROM B;
```

Meaning:

```text
A + B
Remove duplicates
```

---

## UNION ALL

```sql
SELECT ...
FROM A

UNION ALL

SELECT ...
FROM B;
```

Meaning:

```text
A + B
Keep duplicates
```

---

## INTERSECT

```sql
SELECT ...
FROM A

INTERSECT

SELECT ...
FROM B;
```

Meaning:

```text
Common rows
```

---

## EXCEPT

```sql
SELECT ...
FROM A

EXCEPT

SELECT ...
FROM B;
```

Meaning:

```text
A but not B
```

---

# ⭐ Final Memory Diagram

```text
                 SET OPERATORS
                      |
        +-------------+-------------+
        |             |             |
      UNION       INTERSECT       EXCEPT
        |             |             |
   All from both   Common       First only
        |
    +---+---+
    |       |
 UNION    UNION ALL
    |       |
Unique   Keep duplicates
```

---

# 📊 Summary Table

| Operator | Meaning | Duplicates | Direction |
|----------|---------|------------|-----------|
| `UNION` | All rows from both results | Removed | No |
| `UNION ALL` | All rows from both results | Kept | No |
| `INTERSECT` | Common rows | Duplicate result rows removed | No |
| `EXCEPT` | Rows in first result but not second | Duplicate result rows removed | Yes |

---

# 🧠 Most Important Rules

```text
1. Same number of columns
2. Corresponding columns must be compatible
3. Column position matters
4. First query determines output column names
5. UNION removes duplicates
6. UNION ALL keeps duplicates
7. INTERSECT gives common rows
8. EXCEPT gives first-only rows
9. EXCEPT order matters
10. Final ORDER BY goes at the end
```

---

# 🎯 How to Explain Set Operators to Students

A simple teaching method is to first avoid SQL syntax and explain the idea using lists.

Suppose:

```text
Class A Students
----------------
Deep
Rahul
Priya

Class B Students
----------------
Priya
Riya
Neha
```

Ask students:

### Question 1
"Give me everyone from both classes, but don't repeat anyone."

Answer:

```text
UNION
```

Result:

```text
Deep
Rahul
Priya
Riya
Neha
```

---

### Question 2
"Give me everyone from both classes, and don't remove repeated students."

Answer:

```text
UNION ALL
```

Result:

```text
Deep
Rahul
Priya
Priya
Riya
Neha
```

---

### Question 3
"Give me students who are in both classes."

Answer:

```text
INTERSECT
```

Result:

```text
Priya
```

---

### Question 4
"Give me students who are in Class A but not Class B."

Answer:

```text
EXCEPT
```

Result:

```text
Deep
Rahul
```

---

# ⭐ Student-Friendly Memory Trick

Tell students:

```text
UNION
→ Both together, duplicates removed

UNION ALL
→ Both together, duplicates kept

INTERSECT
→ Common in both

EXCEPT
→ First list minus second list
```

Or remember:

```text
UNION       = OR
INTERSECT   = AND
EXCEPT      = First - Second
```

This is a learning shortcut, not a literal SQL replacement.

---

# 🔥 Important Exam Point

If the question says:

```text
"Combine two result sets and remove duplicates"
```

Think:

```text
UNION
```

If it says:

```text
"Combine two result sets including duplicates"
```

Think:

```text
UNION ALL
```

If it says:

```text
"Find common records"
```

Think:

```text
INTERSECT
```

If it says:

```text
"Find records from first query that are not in second query"
```

Think:

```text
EXCEPT
```

---

# 🎓 Learning Outcome

After completing this lab, students will be able to:

- Explain Set Operators in simple terms.
- Combine two or more `SELECT` results.
- Use `UNION` and understand duplicate removal.
- Use `UNION ALL` and preserve duplicates.
- Find common rows using `INTERSECT`.
- Find first-only rows using `EXCEPT`.
- Understand the difference between Set Operators and `JOIN`.
- Apply the rules for compatible Set Operator queries.
- Use `WHERE`, `GROUP BY`, `HAVING`, and `ORDER BY` with Set Operator queries.
- Solve real-world data comparison and reporting problems.

---

# ⭐ Key Takeaways

- Set Operators combine **result sets**, not related columns.
- `UNION` combines results and removes duplicates.
- `UNION ALL` combines results and keeps duplicates.
- `INTERSECT` returns common rows.
- `EXCEPT` returns rows from the first query that are absent from the second.
- Both queries must return the same number of columns.
- Corresponding columns should have compatible data types.
- Column position matters more than column names.
- The first query determines the output column names.
- `EXCEPT` is directional.
- `UNION ALL` is often preferable when duplicates are intentionally required.
- Use `JOIN` when you need to combine related columns.
- Use Set Operators when you need to combine compatible result sets.

---

# ⭐ Happy Learning SQL ⭐
