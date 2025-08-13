---
title: W B
date: 2025-07-01 09:28:00 +0800
author: Template
categories: [Template]
tags: [Template]
pin: false
math: false
mermaid: false
---

**题目**  
编写一个 SQL 查询，满足条件：无论 `person` 是否有地址信息，都需要基于上述两表提供 `person` 的以下信息：  
`FirstName`, `LastName`, `City`, `State`

---

**表 1：person**

| 列名       | 类型    | 说明  |
|------------|--------|-------|
| personId   | int    | 主键  |
| FirstName  | varchar|       |
| LastName   | varchar|       |

---

**表 2：address**

| 列名       | 类型    | 说明  |
|------------|--------|-------|
| AddressId  | int    | 主键  |
| PersonId   | int    |       |
| City       | varchar|       |
| State      | varchar|       |


这个需求是 **无论 person 是否有地址信息** 都要显示，所以我们需要用 **LEFT JOIN** 来保证 person 表里的数据不会因为没有地址而被过滤掉。

SQL 语句如下：

```sql
SELECT 
    p.FirstName,
    p.LastName,
    a.City,
    a.State
FROM person p
LEFT JOIN address a
    ON p.personId = a.PersonId;
```

**解释：**

- `LEFT JOIN`：以 `person` 表为主表，即使 `address` 中没有匹配记录，也会显示 `person` 数据，`City` 和 `State` 会显示 `NULL`。
- `p` 和 `a` 是别名，方便书写。
- `ON p.personId = a.PersonId` 是连接条件。

如果希望 **没有地址的人 City 和 State 显示为空字符串而不是 NULL**，可以用 `COALESCE`：

```sql
SELECT 
    p.FirstName,
    p.LastName,
    COALESCE(a.City, '') AS City,
    COALESCE(a.State, '') AS State
FROM person p
LEFT JOIN address a
    ON p.personId = a.PersonId;
```

------


