# 📘 SQL Lab 18 - Subqueries in SQL

![SQL](https://img.shields.io/badge/SQL-Learning-blue)
![Database](https://img.shields.io/badge/Database-MySQL-orange)
![GitHub](https://img.shields.io/badge/GitHub-README-success)
![Lab](https://img.shields.io/badge/Lab-18-green)

---

# 📌 Objective

The objective of this lab is to understand how **Subqueries** work in SQL and how they help retrieve data based on the result of another query.

After completing this lab, students will be able to:

- Understand Subqueries
- Write Nested Queries
- Use Aggregate Functions inside Subqueries
- Retrieve Maximum and Minimum Values
- Compare Records using Subqueries
- Use Single Row and Multiple Row Subqueries
- Solve real-world SQL problems efficiently

---

# 📚 Prerequisites

Before starting this lab, students should know:

- Database Basics
- Tables and Records
- SELECT Statement
- WHERE Clause
- Comparison Operators
- Aggregate Functions
- GROUP BY
- HAVING

---

# 📋 Sample Tables

## STUDENT

| STID | SNAME | CITY | BRANCH | SPI |
|------|--------|---------|-----------|------|
|101|Deep|Rajkot|CE|8.90|
|102|Rahul|Surat|IT|7.80|
|103|Priya|Rajkot|CE|9.20|
|104|Amit|Ahmedabad|ME|7.40|
|105|Riya|Surat|IT|8.60|

---

## STUDENT_INFO

| STID | EMAIL | MOBILE |
|------|--------|---------|
|101|deep@gmail.com|9876543210|
|102|rahul@gmail.com|9876543211|
|103|priya@gmail.com|9876543212|

---

# 📖 Introduction

In SQL, sometimes one query depends on the result of another query.

Instead of writing multiple separate queries, SQL allows one query to be placed inside another query.

This inner query is called a **Subquery**.

Subqueries make SQL powerful because they allow dynamic filtering without manually providing values.

---

# What is a Subquery?

A **Subquery** is a query written inside another SQL query.

It is also called an

- Inner Query
- Nested Query
- Inner SELECT

The result of the inner query is used by the outer query.

```
Outer Query
    ↓
Uses Result Of
    ↓
Inner Query (Subquery)
```

---

# General Syntax

```sql
SELECT column_name
FROM table_name
WHERE column_name OPERATOR
(
    SELECT column_name
    FROM table_name
);
```

---

# Example 1

Retrieve students whose SPI is equal to the highest SPI.

```sql
SELECT *
FROM STUDENT
WHERE SPI =
(
    SELECT MAX(SPI)
    FROM STUDENT
);
```

### Explanation

1. Inner query finds the maximum SPI.
2. Outer query returns the student having that SPI.

---

# Example 2

Retrieve students belonging to the same city as Deep.

```sql
SELECT *
FROM STUDENT
WHERE CITY =
(
    SELECT CITY
    FROM STUDENT
    WHERE SNAME='Deep'
);
```

---

# Why Use Subqueries?

Subqueries help when:

- One query depends on another query.
- Exact values are not known beforehand.
- Aggregate functions are involved.
- Dynamic searching is required.
- Reports become easier to write.

---

# Advantages of Subqueries

- Easy to understand
- Reduce multiple SQL statements
- Dynamic filtering
- Better readability
- Useful in reports
- Works with Aggregate Functions

---

# Types of Subqueries

There are several types of Subqueries.

| Type | Description |
|------|-------------|
| Scalar Subquery | Returns one value |
| Single Row Subquery | Returns one row |
| Multiple Row Subquery | Returns multiple rows |
| Multiple Column Subquery | Returns multiple columns |
| Correlated Subquery | Depends on outer query |
| Nested Subquery | Query inside another query |

---

# Scalar Subquery

## What is a Scalar Subquery?

A Scalar Subquery returns **only one value**.

This value can be

- Number
- String
- Date

It is commonly used with

- WHERE
- SELECT
- HAVING

---

## Syntax

```sql
SELECT *
FROM table_name
WHERE column=
(
SELECT expression
FROM table_name
);
```

---

## Example

```sql
SELECT *
FROM STUDENT
WHERE SPI=
(
SELECT MAX(SPI)
FROM STUDENT
);
```

---

## Real World Example

Find employee having highest salary.

---

# Single Row Subquery

A Single Row Subquery returns only one row.

It usually works with

```
=
>
<
>=
<=
<>
```

---

## Example

```sql
SELECT *
FROM STUDENT
WHERE SPI >
(
SELECT AVG(SPI)
FROM STUDENT
);
```

Explanation:

Average SPI is calculated first.

Students having SPI greater than average are displayed.

---

# Multiple Row Subquery

A Multiple Row Subquery returns more than one row.

It usually works with

- IN
- ANY
- ALL

---

## Example

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

---

# Nested Subquery

A Nested Subquery contains another Subquery inside it.

```
Query

↓

Subquery

↓

Another Subquery
```

---

## Example

```sql
SELECT *
FROM STUDENT
WHERE SPI=
(
SELECT MAX(SPI)
FROM STUDENT
WHERE BRANCH=
(
SELECT BRANCH
FROM STUDENT
WHERE SNAME='Deep'
)
);
```

---

# Comparison Operators with Subqueries

Subqueries can be used with comparison operators.

| Operator | Meaning |
|----------|----------|
| = | Equal |
| > | Greater Than |
| < | Less Than |
| >= | Greater Than Equal |
| <= | Less Than Equal |
| <> | Not Equal |

---

## Equal (=)

```sql
SELECT *
FROM STUDENT
WHERE SPI=
(
SELECT MAX(SPI)
FROM STUDENT
);
```

---

## Greater Than (>)

```sql
SELECT *
FROM STUDENT
WHERE SPI>
(
SELECT AVG(SPI)
FROM STUDENT
);
```

---

## Less Than (<)

```sql
SELECT *
FROM STUDENT
WHERE SPI<
(
SELECT AVG(SPI)
FROM STUDENT
);
```

---

## Greater Than or Equal (>=)

```sql
SELECT *
FROM STUDENT
WHERE SPI>=
(
SELECT AVG(SPI)
FROM STUDENT
);
```

---

## Less Than or Equal (<=)

```sql
SELECT *
FROM STUDENT
WHERE SPI<=
(
SELECT AVG(SPI)
FROM STUDENT
);
```

---

## Not Equal (<>)

```sql
SELECT *
FROM STUDENT
WHERE BRANCH<>
(
SELECT BRANCH
FROM STUDENT
WHERE STID=101
);
```

---

# Best Practices

- Write the inner query first.
- Test the subquery independently.
- Use meaningful aliases.
- Keep subqueries simple.
- Use aggregate functions carefully.
- Avoid unnecessary nesting.
- Use indexes on frequently searched columns.

---

# Common Mistakes

❌ Returning multiple rows with `=`

```sql
SELECT *
FROM STUDENT
WHERE BRANCH =
(
SELECT BRANCH
FROM STUDENT
);
```

✅ Use `IN` instead.

```sql
SELECT *
FROM STUDENT
WHERE BRANCH IN
(
SELECT BRANCH
FROM STUDENT
);
```

---

❌ Forgetting parentheses.

Wrong

```sql
SELECT *
FROM STUDENT
WHERE SPI=
SELECT MAX(SPI)
FROM STUDENT;
```

Correct

```sql
SELECT *
FROM STUDENT
WHERE SPI=
(
SELECT MAX(SPI)
FROM STUDENT
);
```

---

# Summary

| Concept | Purpose |
|----------|---------|
| Subquery | Query inside another query |
| Scalar Subquery | Returns one value |
| Single Row | Returns one row |
| Multiple Row | Returns many rows |
| Nested Subquery | Query inside another query |
| Comparison Operators | Compare results returned by subqueries |

---

➡️ **Next:** Part 2 will cover `IN`, `ANY`, `ALL`, `EXISTS`, `NOT EXISTS`, Correlated Subqueries, Aggregate Functions with Subqueries, Second Highest/Lowest, Branch-wise Average, SQL Execution Order, Interview Questions, Practice Questions, and Key Takeaways.
---

# IN Operator with Subquery

## What is IN?

The `IN` operator is used when a subquery returns **multiple values**.

Instead of comparing one value, SQL checks whether the value exists in the list returned by the subquery.

---

## Syntax

```sql
SELECT column_name
FROM table_name
WHERE column_name IN
(
    SELECT column_name
    FROM table_name
);
```

---

## Example 1

Find students who belong to the same branch as students living in Rajkot.

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

### Explanation

- Inner query returns all branches of Rajkot students.
- Outer query displays all students from those branches.

---

## Example 2

Find students whose SPI matches any SPI greater than 8.

```sql
SELECT *
FROM STUDENT
WHERE SPI IN
(
    SELECT SPI
    FROM STUDENT
    WHERE SPI>8
);
```

---

# ANY Operator

## What is ANY?

The `ANY` operator compares a value with **any value returned by a subquery**.

If one comparison becomes TRUE, the record is selected.

---

## Syntax

```sql
SELECT *
FROM table_name
WHERE column_name > ANY
(
    SELECT column_name
    FROM table_name
);
```

---

## Example

```sql
SELECT *
FROM STUDENT
WHERE SPI > ANY
(
    SELECT SPI
    FROM STUDENT
    WHERE BRANCH='IT'
);
```

---

### Explanation

The query returns students whose SPI is greater than at least one IT student's SPI.

---

# ALL Operator

## What is ALL?

The `ALL` operator compares a value with **every value returned by the subquery**.

Every comparison must be TRUE.

---

## Syntax

```sql
SELECT *
FROM table_name
WHERE column_name > ALL
(
    SELECT column_name
    FROM table_name
);
```

---

## Example

```sql
SELECT *
FROM STUDENT
WHERE SPI >
ALL
(
SELECT SPI
FROM STUDENT
WHERE BRANCH='IT'
);
```

---

### Explanation

Returns students whose SPI is greater than every IT student's SPI.

---

# Difference Between ANY and ALL

| ANY | ALL |
|------|------|
| One comparison should be TRUE | Every comparison should be TRUE |
| Easier condition | Strict condition |
| Returns more rows | Returns fewer rows |

---

# EXISTS Operator

## What is EXISTS?

The `EXISTS` operator checks whether the subquery returns at least one row.

If the subquery returns data, EXISTS becomes TRUE.

---

## Syntax

```sql
SELECT *
FROM table_name
WHERE EXISTS
(
SELECT *
FROM another_table
WHERE condition
);
```

---

## Example

```sql
SELECT *
FROM STUDENT S
WHERE EXISTS
(
SELECT *
FROM STUDENT_INFO SI
WHERE SI.STID=S.STID
);
```

---

### Explanation

Only students having information in STUDENT_INFO will be displayed.

---

# NOT EXISTS

## What is NOT EXISTS?

Returns records when the subquery returns no rows.

---

## Example

```sql
SELECT *
FROM STUDENT S
WHERE NOT EXISTS
(
SELECT *
FROM STUDENT_INFO SI
WHERE SI.STID=S.STID
);
```

---

### Explanation

Displays students whose information does not exist.

---

# Correlated Subquery

## What is a Correlated Subquery?

A Correlated Subquery depends on the outer query.

Unlike normal subqueries, it executes once for every row processed by the outer query.

```
Outer Query

↓

One Row

↓

Subquery Executes

↓

Next Row

↓

Subquery Executes Again
```

---

## Syntax

```sql
SELECT *
FROM table1 A
WHERE column >
(
SELECT AVG(column)
FROM table1 B
WHERE A.column=B.column
);
```

---

## Example

Find students whose SPI is greater than the average SPI of their branch.

```sql
SELECT *
FROM STUDENT S1
WHERE SPI >
(
SELECT AVG(SPI)
FROM STUDENT S2
WHERE S1.BRANCH=S2.BRANCH
);
```

---

### Explanation

The average is calculated separately for each branch.

---

# Aggregate Functions with Subqueries

Subqueries work perfectly with Aggregate Functions.

Common Aggregate Functions:

- MAX()
- MIN()
- AVG()
- SUM()
- COUNT()

---

# MAX()

Find student having highest SPI.

```sql
SELECT *
FROM STUDENT
WHERE SPI=
(
SELECT MAX(SPI)
FROM STUDENT
);
```

---

# MIN()

Find student having lowest SPI.

```sql
SELECT *
FROM STUDENT
WHERE SPI=
(
SELECT MIN(SPI)
FROM STUDENT
);
```

---

# AVG()

Find students scoring above average.

```sql
SELECT *
FROM STUDENT
WHERE SPI>
(
SELECT AVG(SPI)
FROM STUDENT
);
```

---

# COUNT()

Display total students.

```sql
SELECT COUNT(*)
FROM STUDENT;
```

---

# SUM()

Calculate total SPI.

```sql
SELECT SUM(SPI)
FROM STUDENT;
```

---

# Second Highest SPI

```sql
SELECT MAX(SPI)
FROM STUDENT
WHERE SPI<
(
SELECT MAX(SPI)
FROM STUDENT
);
```

---

### Explanation

- Inner query finds highest SPI.
- Outer query finds highest SPI less than that value.

---

# Second Lowest SPI

```sql
SELECT MIN(SPI)
FROM STUDENT
WHERE SPI>
(
SELECT MIN(SPI)
FROM STUDENT
);
```

---

# Branch-wise Average SPI

```sql
SELECT BRANCH,
AVG(SPI)
FROM STUDENT
GROUP BY BRANCH;
```

---

# Students Above Branch Average

```sql
SELECT *
FROM STUDENT S1
WHERE SPI >
(
SELECT AVG(SPI)
FROM STUDENT S2
WHERE S1.BRANCH=S2.BRANCH
);
```

---

# SQL Execution Order

```
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

ORDER BY

↓

LIMIT
```

---

# Real World Applications

Subqueries are widely used in:

- Banking Systems
- Hospital Management
- School Management
- HR Management
- Payroll Systems
- Inventory Systems
- E-commerce Websites
- University Portals

---

# Best Practices

- Write the inner query first.
- Test every subquery separately.
- Use aliases for readability.
- Avoid unnecessary nested queries.
- Prefer JOIN when performance is important.
- Use EXISTS for existence checking.
- Use IN for multiple values.
- Keep queries properly indented.
- Add comments for complex queries.
- Optimize frequently used columns with indexes.

---

# Common Mistakes

## ❌ Using '=' with multiple rows

Wrong

```sql
WHERE BRANCH=
(
SELECT BRANCH
FROM STUDENT
);
```

Correct

```sql
WHERE BRANCH IN
(
SELECT BRANCH
FROM STUDENT
);
```

---

## ❌ Forgetting aliases in Correlated Subqueries

Wrong

```sql
SELECT *
FROM STUDENT
WHERE SPI>
(
SELECT AVG(SPI)
FROM STUDENT
WHERE BRANCH=BRANCH
);
```

Correct

```sql
SELECT *
FROM STUDENT S1
WHERE SPI>
(
SELECT AVG(SPI)
FROM STUDENT S2
WHERE S1.BRANCH=S2.BRANCH
);
```

---

# Interview Questions

1. What is a Subquery?
2. What is the difference between a Subquery and a JOIN?
3. What are Scalar Subqueries?
4. Explain Correlated Subqueries.
5. Difference between IN and EXISTS.
6. Difference between ANY and ALL.
7. Can a Subquery return multiple columns?
8. Which is faster: JOIN or Subquery?
9. Where can a Subquery be used?
10. What are the different types of Subqueries?

---

# Practice Questions

1. Find students with the maximum SPI.
2. Find students with the minimum SPI.
3. Find students scoring above average.
4. Find students scoring below average.
5. Find the second highest SPI.
6. Find the second lowest SPI.
7. Find students belonging to the same city as Deep.
8. Find students having the same branch as Rahul.
9. Display students whose SPI is greater than every IT student.
10. Display students whose information exists in STUDENT_INFO.

---

# Summary Table

| Concept | Purpose |
|----------|----------|
| Subquery | Query inside another query |
| Scalar Subquery | Returns one value |
| Single Row Subquery | Returns one row |
| Multiple Row Subquery | Returns multiple rows |
| Correlated Subquery | Depends on outer query |
| Nested Subquery | Query inside another query |
| IN | Compare multiple values |
| ANY | Compare with any returned value |
| ALL | Compare with every returned value |
| EXISTS | Checks if rows exist |
| NOT EXISTS | Checks if rows do not exist |
| MAX() | Highest value |
| MIN() | Lowest value |
| AVG() | Average value |
| SUM() | Total |
| COUNT() | Number of rows |

---

# Key Takeaways

- A **Subquery** is a query inside another SQL query.
- Use **Scalar Subqueries** when only one value is returned.
- Use **IN** when the subquery returns multiple values.
- Use **EXISTS** to check whether matching records exist.
- Use **Correlated Subqueries** when the inner query depends on the outer query.
- Aggregate functions like **MAX(), MIN(), AVG(), SUM(), and COUNT()** work well with subqueries.
- Always test the inner query separately before using it in the outer query.
- Choose **JOINs** over subqueries when they provide better readability and performance.

---

# 🎯 Learning Outcome

After completing this lab, students will be able to:

- Write single-row and multiple-row subqueries.
- Use correlated and nested subqueries.
- Combine aggregate functions with subqueries.
- Retrieve maximum, minimum, second highest, and second lowest values.
- Apply `IN`, `ANY`, `ALL`, `EXISTS`, and `NOT EXISTS`.
- Solve real-world SQL problems using subqueries.

---

# ⭐ Happy Learning SQL ⭐
