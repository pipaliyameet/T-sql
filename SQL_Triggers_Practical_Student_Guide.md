# SQL Server Triggers — Practical Student Guide

## 1. What is a Trigger?

A **Trigger** is a special SQL Server object that automatically executes when a specified event happens on a table.

### Simple definition

> **Trigger = Automatic action performed by SQL Server when a database event occurs.**

Unlike a Stored Procedure, we normally do not execute a trigger manually with `EXEC`.

### Flow

```text
INSERT / UPDATE / DELETE
          ↓
      Trigger fires
          ↓
   Automatic action
```

---

# 2. Why do we use Triggers?

Suppose an employee's data is changed.

We may want SQL Server to automatically:

- print a message
- create a log
- save old and new values
- convert a city to uppercase
- set a default value
- record the date/time of a change

A trigger can perform these actions automatically.

---

# 3. Basic Trigger Syntax

```sql
CREATE TRIGGER TriggerName
ON TableName
AFTER INSERT
AS
BEGIN
    -- trigger statements
END;
GO
```

Example:

```sql
CREATE TRIGGER TR_Student_AfterDelete
ON student
AFTER DELETE
AS
BEGIN
    PRINT 'Delete successfully';
END;
GO
```

Then simply execute:

```sql
DELETE FROM student
WHERE stdid = 101;
```

You do **not** execute the trigger manually.

SQL Server automatically fires it.

### Execution flow

```text
DELETE FROM student
WHERE stdid = 101
        ↓
Row is deleted
        ↓
AFTER DELETE trigger fires
        ↓
PRINT 'Delete successfully'
```

---

# 4. INSERT, UPDATE and DELETE

The most common DML trigger events are:

| Event | Meaning |
|---|---|
| `INSERT` | A new row is added |
| `UPDATE` | Existing data is changed |
| `DELETE` | A row is removed |

Examples:

```sql
AFTER INSERT
AFTER UPDATE
AFTER DELETE
```

---

# 5. What does AFTER mean?

`AFTER` means the original operation happens first, and then the trigger executes.

### AFTER INSERT

```text
INSERT
  ↓
Insert succeeds
  ↓
Trigger executes
```

### AFTER UPDATE

```text
UPDATE
  ↓
Update succeeds
  ↓
Trigger executes
```

### AFTER DELETE

```text
DELETE
  ↓
Delete succeeds
  ↓
Trigger executes
```

---

# 6. BEGIN and END

A trigger can contain one or multiple SQL statements.

```sql
AS
BEGIN

    PRINT 'Hello';

END;
```

`BEGIN` and `END` define the block of statements belonging to the trigger.

For example:

```sql
CREATE TRIGGER TR_Student_AfterDelete
ON student
AFTER DELETE
AS
BEGIN

    PRINT 'Delete successfully';

END;
GO
```

---

# 7. `inserted` and `deleted`

This is the **most important trigger concept**.

`inserted` and `deleted` are special logical tables that SQL Server provides while a DML trigger is executing.

They are **not normal permanent tables**.

You cannot normally see them in Object Explorer like:

```text
dbo.student
```

They are available inside the trigger.

---

## 7.1 What is `inserted`?

`inserted` contains the **new version** of affected rows.

For an INSERT:

```text
INSERT
  ↓
inserted = NEW row
```

Example:

```sql
CREATE TRIGGER TR_Student_Insert
ON student
AFTER INSERT
AS
BEGIN
    SELECT * FROM inserted;
END;
GO
```

When a new student is inserted, the newly inserted row can be read from `inserted`.

---

## 7.2 What is `deleted`?

`deleted` contains the **old/deleted version** of affected rows.

For a DELETE:

```text
DELETE
  ↓
deleted = OLD row
```

Example:

```sql
CREATE TRIGGER TR_Student_Delete
ON student
AFTER DELETE
AS
BEGIN
    SELECT * FROM deleted;
END;
GO
```

---

## 7.3 INSERT / UPDATE / DELETE table behavior

Remember this table:

| Operation | `inserted` | `deleted` |
|---|---|---|
| INSERT | New row | No rows |
| DELETE | No rows | Deleted/old row |
| UPDATE | New version | Old version |

### Most important shortcut

```text
INSERT
→ inserted = NEW

DELETE
→ deleted = OLD

UPDATE
→ deleted  = OLD
→ inserted = NEW
```

---

# 8. Where are `inserted` and `deleted` actually stored?

Students often ask:

> "Where can I find these tables?"

They are maintained internally by SQL Server for the duration of trigger execution.

They are **not permanent database tables** and are not objects such as:

```sql
dbo.inserted
dbo.deleted
```

This is correct:

```sql
SELECT * FROM inserted;
```

This is not how they are referenced:

```sql
SELECT * FROM dbo.inserted; -- ❌
```

After the trigger finishes, you cannot query `inserted` or `deleted` from a normal query window.

Think of them as a temporary workspace supplied by SQL Server to the trigger.

---

# 9. UPDATE: Old Value vs New Value

UPDATE is where `inserted` and `deleted` become especially useful.

Suppose:

```text
Before UPDATE:

EID = 101
SALARY = 50000
CITY = RAJKOT
```

Then:

```sql
UPDATE EMPLOYEE
SET SALARY = 60000,
    CITY = 'AHMEDABAD'
WHERE EID = 101;
```

Inside the trigger:

```text
deleted                    inserted
-------                    --------
EID = 101                  EID = 101
SALARY = 50000             SALARY = 60000
CITY = RAJKOT              CITY = AHMEDABAD
```

Therefore:

```text
deleted  → BEFORE UPDATE
inserted → AFTER UPDATE
```

---

# 10. Why do we JOIN `inserted` and `deleted`?

When we want to compare old and new values, we usually join them using the primary key.

Example:

```sql
SELECT
    d.SALARY AS OldSalary,
    i.SALARY AS NewSalary
FROM inserted i
INNER JOIN deleted d
    ON i.EID = d.EID;
```

The join:

```sql
ON i.EID = d.EID
```

matches the old and new versions of the same employee.

---

# 11. Example: Salary Increment Trigger

```sql
CREATE TRIGGER TR_Employee_SalaryIncrement
ON EMPLOYEE
AFTER UPDATE
AS
BEGIN

    IF UPDATE(SALARY)
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM inserted i
            JOIN deleted d
                ON i.EID = d.EID
            WHERE i.SALARY > d.SALARY
        )
        BEGIN
            PRINT 'Employee salary incremented successfully.';
        END

    END
END;
GO
```

## Understand it step by step

### Step 1 — `AFTER UPDATE`

```sql
AFTER UPDATE
```

Salary changes through an UPDATE operation.

---

### Step 2 — `UPDATE(SALARY)`

```sql
IF UPDATE(SALARY)
```

Checks whether the `SALARY` column was included in the UPDATE statement.

It does not by itself prove that the value increased.

---

### Step 3 — Compare old and new salary

```sql
WHERE i.SALARY > d.SALARY
```

Remember:

```text
i.SALARY = new salary
d.SALARY = old salary
```

So:

```text
60000 > 50000
```

means salary increased.

---

# 12. `IF UPDATE(ColumnName)`

Example:

```sql
IF UPDATE(CITY)
```

means:

> Was the CITY column included in the UPDATE operation that fired the trigger?

Example:

```sql
UPDATE EMPLOYEE
SET CITY = 'RAJKOT'
WHERE EID = 101;
```

Here:

```sql
UPDATE(CITY)
```

is true.

But:

```sql
UPDATE EMPLOYEE
SET SALARY = 60000
WHERE EID = 101;
```

does not target CITY.

So:

```sql
UPDATE(CITY)
```

is false.

### Important

`UPDATE(CITY)` checks whether the column was targeted by the UPDATE statement. It does not necessarily mean the old and new values are different.

---

# 13. `UPPER()` in a Trigger

Example:

```sql
UPPER('rajkot')
```

returns:

```text
RAJKOT
```

Trigger example:

```sql
CREATE TRIGGER TR_Employee_UpperCity
ON EMPLOYEE
AFTER INSERT
AS
BEGIN

    UPDATE EMPLOYEE
    SET CITY = UPPER(i.CITY)
    FROM EMPLOYEE e
    INNER JOIN inserted i
        ON e.EID = i.EID
    WHERE i.CITY IS NOT NULL;

END;
GO
```

### Flow

```text
User inserts:

city = rajkot
      ↓
Row inserted
      ↓
AFTER INSERT trigger
      ↓
UPPER('rajkot')
      ↓
RAJKOT
```

---

# 14. Default City Using a Trigger

```sql
CREATE TRIGGER TR_Employee_DefaultCity
ON EMPLOYEE
AFTER INSERT
AS
BEGIN

    UPDATE EMPLOYEE
    SET CITY = 'RAJKOT'
    FROM EMPLOYEE e
    INNER JOIN inserted i
        ON e.EID = i.EID
    WHERE i.CITY IS NULL;

END;
GO
```

If the user inserts:

```text
CITY = NULL
```

the trigger changes it to:

```text
CITY = RAJKOT
```

Flow:

```text
INSERT
  ↓
CITY = NULL
  ↓
Trigger
  ↓
CITY = RAJKOT
```

---

# 15. `GETDATE()`

```sql
GETDATE()
```

returns the current SQL Server date and time.

Example:

```sql
SELECT GETDATE();
```

It is useful for log columns such as:

```text
INSERTDATE
UPDATEDATE
LOGDATE
```

Example:

```sql
INSERT INTO EMPLOYEE_INSERT_LOG (...)
SELECT ..., GETDATE()
FROM inserted;
```

---

# 16. `ISNULL()`

Example:

```sql
ISNULL(@OldCity, 'NULL')
```

means:

> If `@OldCity` is NULL, use the text `'NULL'`.

Example:

```text
@OldCity = RAJKOT
→ RAJKOT

@OldCity = NULL
→ NULL
```

It is useful when creating messages or handling NULL values.

---

# 17. Logging / Auditing with Triggers

Triggers are commonly used for logging.

Suppose:

```text
Employee salary:

50000 → 60000
```

We may want to save:

```text
EID       101
OldSalary 50000
NewSalary 60000
Date      current date/time
```

A trigger can automatically insert this information into a log table.

---

# 18. Example: Employee Update Log

```sql
CREATE TRIGGER TR_Employee_UpdateLog
ON EMPLOYEE
AFTER UPDATE
AS
BEGIN

    INSERT INTO EMPLOYEE_UPDATE_LOG
    (
        EID,
        OLDSALARY,
        NEWSALARY,
        OLDDEPARTMENT,
        NEWDEPARTMENT,
        UPDATEDATE
    )

    SELECT
        i.EID,
        d.SALARY,
        i.SALARY,
        d.DEPARTMENT,
        i.DEPARTMENT,
        GETDATE()

    FROM inserted i
    INNER JOIN deleted d
        ON i.EID = d.EID;

END;
GO
```

### Why both tables?

Because we need:

```text
deleted  → old salary + old department
inserted → new salary + new department
```

---

# 19. Example: Insert Log

For an INSERT, we only need new data.

```sql
CREATE TRIGGER TR_Employee_InsertLog
ON EMPLOYEE
AFTER INSERT
AS
BEGIN

    INSERT INTO EMPLOYEE_INSERT_LOG
    (
        EID,
        FIRSTNAME,
        LASTNAME,
        DEPARTMENT,
        SALARY,
        CITY,
        GENDER,
        JOININGYEAR,
        INSERTDATE
    )

    SELECT
        EID,
        FIRSTNAME,
        LASTNAME,
        DEPARTMENT,
        SALARY,
        CITY,
        GENDER,
        JOININGYEAR,
        GETDATE()
    FROM inserted;

END;
GO
```

Why only `inserted`?

Because INSERT creates new data.

There is no old version to compare.

---

# 20. Logging a Name Change

```sql
CREATE TRIGGER TR_Employee_NameChangeLog
ON EMPLOYEE
AFTER UPDATE
AS
BEGIN

    IF UPDATE(FIRSTNAME)
    BEGIN

        INSERT INTO NAME_CHANGE_LOG
        (
            EID,
            OLDFIRSTNAME,
            NEWFIRSTNAME,
            UPDATEDATE
        )

        SELECT
            i.EID,
            d.FIRSTNAME,
            i.FIRSTNAME,
            GETDATE()

        FROM inserted i
        INNER JOIN deleted d
            ON i.EID = d.EID;

    END
END;
GO
```

If:

```text
Meet → Rahul
```

then:

```text
deleted.FIRSTNAME  = Meet
inserted.FIRSTNAME = Rahul
```

Log:

```text
EID    OLD       NEW
101    Meet      Rahul
```

---

# 21. Logging a City Change

Same concept:

```sql
CREATE TRIGGER TR_Employee_CityUpdateLog
ON EMPLOYEE
AFTER UPDATE
AS
BEGIN

    IF UPDATE(CITY)
    BEGIN

        INSERT INTO CITY_UPDATE_LOG
        (
            EID,
            OLDCITY,
            NEWCITY,
            UPDATEDATE
        )

        SELECT
            i.EID,
            d.CITY,
            i.CITY,
            GETDATE()

        FROM inserted i
        INNER JOIN deleted d
            ON i.EID = d.EID;

    END
END;
GO
```

If:

```text
RAJKOT → AHMEDABAD
```

then:

```text
deleted.CITY  = RAJKOT
inserted.CITY = AHMEDABAD
```

---

# 22. INSTEAD OF Trigger

`INSTEAD OF` is different from `AFTER`.

### AFTER

```text
Original operation
       ↓
Trigger
```

### INSTEAD OF

```text
Operation requested
       ↓
INSTEAD OF trigger
       ↓
Trigger decides what to do
```

Example:

```sql
CREATE TRIGGER TR_Employee_InsteadOfInsertSpaces
ON EMPLOYEE
INSTEAD OF INSERT
AS
BEGIN

    INSERT INTO EMPLOYEE
    (
        EID,
        FIRSTNAME,
        LASTNAME,
        DEPARTMENT,
        SALARY,
        CITY,
        GENDER,
        JOININGYEAR
    )

    SELECT
        EID,
        LTRIM(RTRIM(FIRSTNAME)),
        LTRIM(RTRIM(LASTNAME)),
        DEPARTMENT,
        SALARY,
        CITY,
        GENDER,
        JOININGYEAR
    FROM inserted;

END;
GO
```

---

# 23. Why use `INSTEAD OF` in this example?

Suppose the user enters:

```text
FIRSTNAME = '   Meet   '
LASTNAME  = '   Pipaliya   '
```

We want:

```text
FIRSTNAME = 'Meet'
LASTNAME  = 'Pipaliya'
```

The trigger uses:

```sql
LTRIM(RTRIM(FIRSTNAME))
```

and:

```sql
LTRIM(RTRIM(LASTNAME))
```

---

# 24. `LTRIM()` and `RTRIM()`

### LTRIM

Removes spaces from the left side.

```text
'   Meet' → 'Meet'
```

### RTRIM

Removes spaces from the right side.

```text
'Meet   ' → 'Meet'
```

Together:

```sql
LTRIM(RTRIM('   Meet   '))
```

gives:

```text
Meet
```

---

# 25. Why does the INSTEAD OF trigger perform another INSERT?

Because the original INSERT is intercepted.

The trigger receives the requested data through:

```sql
inserted
```

Then it cleans the values:

```sql
LTRIM(RTRIM(FIRSTNAME))
```

and performs its own:

```sql
INSERT INTO EMPLOYEE
```

Flow:

```text
User requests INSERT
        ↓
INSTEAD OF trigger
        ↓
Read data from inserted
        ↓
Remove extra spaces
        ↓
INSERT cleaned data into EMPLOYEE
```

---

# 26. AFTER vs INSTEAD OF

| AFTER | INSTEAD OF |
|---|---|
| Original operation occurs | Original operation is intercepted |
| Trigger runs after operation | Trigger runs instead of operation |
| Common for logging | Useful for intercepting/modifying an operation |

Easy memory:

```text
AFTER:
INSERT → Trigger

INSTEAD OF:
INSERT → Trigger → INSERT
```

---

# 27. Multiple Triggers on One Table

In this lab, many triggers are created on `EMPLOYEE`.

For example, several triggers are:

```sql
AFTER INSERT
```

and several are:

```sql
AFTER UPDATE
```

Therefore, one operation can cause multiple triggers to execute.

Example:

```text
INSERT EMPLOYEE
       ↓
AFTER INSERT triggers
       ├── Print message
       ├── Uppercase city
       ├── Default city
       ├── Default joining year
       ├── Print full name
       ├── Default department
       └── Insert log
```

This is useful for demonstrating trigger behavior, although real applications should be designed carefully to avoid unnecessary complexity.

---

# 28. Important: Triggers can handle multiple rows

A single SQL statement can affect many rows.

Example:

```sql
UPDATE EMPLOYEE
SET CITY = 'RAJKOT';
```

This could update 100 employees.

Then:

```text
inserted
```

can contain 100 new rows, and:

```text
deleted
```

can contain 100 old rows.

Therefore, a good trigger should generally be written using set-based SQL:

```sql
INSERT INTO LOG_TABLE (...)
SELECT ...
FROM inserted;
```

rather than assuming only one row exists.

---

# 29. Why some simple examples use variables

For demonstration, you may see:

```sql
DECLARE @OldCity VARCHAR(50),
        @NewCity VARCHAR(50);

SELECT
    @OldCity = d.CITY,
    @NewCity = i.CITY
FROM inserted i
JOIN deleted d
    ON i.EID = d.EID;
```

Variables hold only one value.

So this style is suitable for a simple one-row demonstration, but it is not the best general pattern for multi-row trigger operations.

For logging multiple rows, prefer:

```sql
INSERT INTO LOG_TABLE (...)
SELECT ...
FROM inserted i
JOIN deleted d
    ON i.EID = d.EID;
```

---

# 30. Trigger vs Stored Procedure

This is a common viva question.

| Trigger | Stored Procedure |
|---|---|
| Automatically executes | Usually manually executed |
| Associated with table/view | Independent database object |
| Fired by events such as INSERT/UPDATE/DELETE | Called using `EXEC` |
| Does not use normal input parameters | Can accept parameters |
| Often used for automatic actions/logging | Used for reusable business operations |

Example procedure:

```sql
EXEC MyProcedure @id = 101;
```

Trigger:

```sql
DELETE FROM student
WHERE stdid = 101;
```

The trigger fires automatically because the DELETE event happened.

---

# 31. Practical Example to Demonstrate to Students

## Step 1 — Create trigger

```sql
CREATE TRIGGER TR_Student_AfterDelete
ON student
AFTER DELETE
AS
BEGIN
    PRINT 'Delete successfully';
END;
GO
```

## Step 2 — Delete a student

```sql
DELETE FROM student
WHERE stdid = 101;
```

## Step 3 — Observe output

```text
delete successfully

(1 row affected)
```

### Explain the output

`delete successfully`:

> Comes from the trigger's `PRINT` statement.

`(1 row affected)`:

> SQL Server is telling us that one row was deleted by the DELETE statement.

The trigger was not manually executed.

---

# 32. Best Mental Model

Tell students to remember this:

```text
                TABLE
                  │
          INSERT / UPDATE / DELETE
                  │
                  ↓
               TRIGGER
                  │
       ┌──────────┼──────────┐
       ↓          ↓          ↓
     PRINT      UPDATE      LOG
                  │
                  ↓
           inserted/deleted
```

---

# 33. Super Short Revision

### Trigger

> Automatically executes when a specified database event occurs.

### `AFTER`

> Original operation happens first, trigger runs afterward.

### `INSTEAD OF`

> Trigger runs instead of the original operation.

### `inserted`

> Contains new/inserted versions of affected rows.

### `deleted`

> Contains old/deleted versions of affected rows.

### UPDATE

```text
deleted  = OLD
inserted = NEW
```

### `UPDATE(Column)`

> Checks whether that column was included in the UPDATE statement.

### `GETDATE()`

> Current SQL Server date and time.

### `UPPER()`

> Converts text to uppercase.

### `LTRIM()`

> Removes left-side spaces.

### `RTRIM()`

> Removes right-side spaces.

### Trigger use cases

> Automatic actions, default handling, data processing, logging and auditing.

---

# 34. Quick Viva Questions

### Q1. What is a trigger?
A: A database object that automatically executes when a specified event occurs.

### Q2. Can we manually execute a trigger?
A: Normally no. It is automatically fired by its associated event.

### Q3. What are the common DML trigger events?
A: INSERT, UPDATE and DELETE.

### Q4. What is `AFTER INSERT`?
A: The trigger executes after the INSERT operation.

### Q5. What is `INSTEAD OF INSERT`?
A: The trigger executes instead of the original INSERT operation.

### Q6. What is `inserted`?
A: A special logical table containing new affected rows.

### Q7. What is `deleted`?
A: A special logical table containing old/deleted affected rows.

### Q8. During UPDATE, where is old data?
A: `deleted`.

### Q9. During UPDATE, where is new data?
A: `inserted`.

### Q10. Do `inserted` and `deleted` have a schema like `dbo`?
A: No. They are special logical tables available inside a trigger.

### Q11. Can we see `inserted` in Object Explorer?
A: No. It is not a permanent table.

### Q12. Why join `inserted` and `deleted`?
A: To compare old and new values of the same row.

### Q13. What does `UPDATE(CITY)` check?
A: Whether CITY was included in the UPDATE statement.

### Q14. What is `GETDATE()`?
A: It returns the current date and time.

### Q15. Why use triggers for logging?
A: To automatically record changes without relying on the application to remember to create a log.

### Q16. Can one INSERT/UPDATE statement affect multiple rows?
A: Yes.

### Q17. Can `inserted` and `deleted` contain multiple rows?
A: Yes.

### Q18. Should a trigger be designed to handle multiple rows?
A: Yes, generally.

### Q19. What is the main difference between AFTER and INSTEAD OF?
A:
- AFTER → operation first, trigger afterward.
- INSTEAD OF → trigger intercepts/replaces the original operation.

### Q20. What is the easiest way to remember UPDATE?
A:

```text
deleted  = BEFORE
inserted = AFTER
```
