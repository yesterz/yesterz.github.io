---
title: 查询性能优化
date: 2023-06-25 14:09:00 +0800
author: 
categories: [Database]
tags: [MySQL, Database]
pin: false
math: false
mermaid: false
media_subpath: /assets/images/
---

ch6 查询性能优化

## 慢查询基础：优化数据访问



## 优化小细节

1. 当使用索引列进行查询的时候尽量不要使用表达式，把计算放到业务层而不是数据库层
2. 尽量使用主键查询，而不是其他索引，因此主键查询不会触发回表查询
3. 使用前缀索引
4. 使用索引扫描来排序
5. union all, in, or都能够使用索引，但是推荐使用in
6. 范围列可以用到索引 范围条件是：<、<=、>、>=、between
7. 范围列可以用到索引，但是范围列后面的列无法用到索引，索引最多用于一个范围列
8. 强制类型转换会全表扫描
   1. explain select * from user where phone=13800001234; 不会触发索引
   2. explain select * from user where phone='13800001234'; 触发索引
9. 更新十分频繁，数据区分度不高的字段上不宜建立索引
   1. 更新会变更B+树，更新频繁的字段建议索引会大大降低数据库性能
   2. 类似于性别这类区分不大的属性，建立索引是没有意义的，不能有效的过滤数据，
   3. 一般区分度在80%以上的时候就可以建立索引，区分度可以使用 count(distinct(列名))/count(*) 来计算
10. 创建索引的列，不允许为null，可能会得到不符合预期的结果
11. 当需要进行表连接的时候，最好不要超过三张表，因为需要join的字段，数据类型必须一致
12. 能使用limit的时候尽量使用limit
13. 单表索引建议控制在5个以内
14. 单索引字段数不允许超过5个（组合索引）
15. 创建索引的时候应该避免以下错误概念
    1. 索引越多越好
    2. 过早优化，在不了解系统的情况下进行优化

## 索引监控

```sql
show status like 'Handler_read%';
```

参数解释

1. Handler_read_first：读取索引第一个条目的次数 Handler_read_key：通过index获取数据的次数 
2. Handler_read_last：读取索引最后一个条目的次数 Handler_read_next：通过索引读取下一条数据的次数 
3. Handler_read_prev：通过索引读取上一条数据的次数 Handler_read_rnd：从固定位置读取数据的次数 
4. Handler_read_rnd_next：从数据节点读取下一条数据的次数

## 查询优化器的提示（hint）

如果对优化器选择的执行计划不满意，可以使用优化器提供的几个提示（hint）来控制最终的执行计划。

**在查询中加入相应的提示，就可以控制该查询的执行计划。**

[MySQL :: MySQL 8.0 Reference Manual :: 8.9.3 Optimizer Hints](https://dev.mysql.com/doc/refman/8.0/en/optimizer-hints.html)

## 优化特定类型的查询

### 优化 COUNT() 查询

1. 如果希望知道的是结果集的行数，最好使用 `COUNT(*)` ，这样写意义清晰，性能也会很好。
2. 对于 MyISAM 来说，只有没有任何 WHERE 条件的 COUNT(*) 才非常快。可以利用这个特性来优化查询
3. 使用近似值，业务场景不要求完全精确 COUNT 值，可以用 EXPLAIN 出来的优化器估估算的行数就是一个不错的近似值，执行 EXPLAIN 并不需要真地区执行查询，所以成本很低。
4. 更复杂优化，索引覆盖扫描，还不够就训词增加汇总表或者外部缓存系统。

或者增加类似 Memcached 这样的外部缓存系统。可能很快你就会发现陷入到一个熟悉的困境，“快速，精确和实现简单”，三者永远只能满足其二，必须舍掉其中一个。

### 优化关联查询

1. 确保 ON 或者 USING 子句的列上有索引
2. 确保任何的 GROUP BY 和 ORDER BY 中的表达式只涉及到一个表中的列，这样 MySQL 才有可能使用索引来优化这个过程。

### 优化子查询

这里的建议：尽可能使用关联查询代替。

### 优化 GROUP BY 和 DISTINCT

有时候优化器会内部处理时相互转换这两类查询。

在 MySQL 中，当无法使用索引的适合，GROUP BY 使用两种策略来完成：

1. 使用临时表
2. 文件排序来做分组

对关联查询做分组，并且是按照查找表中的某个列进行分组，那么通常采用查找表的标识列分组的效率会比其他列更高。

优化 GROUP BY WITH ROLLUP

分组查询的一个变种就是要求 MySQL 对返回的分组结果再做一次超级聚合。就可以用 WITH ROLLUP 子句来实现这种逻辑。

### 优化 LIMIT 分页

优化办法：尽可能地使用索引覆盖扫描，而不是查询所有的列。然后根据需要做一次关联操作返回所需的列。

### 优化 UNION 查询

优化办法，手动的将 WHERE、LIMIT、ORDER BY 等子句“下推”到 UNION 的各个子查询中，优化器就能充分利用这些条件进行优化。

### 静态查询分析

Percona Toolkit’s pt-query-advisor 能够解析查询日志，分析查询模式，然后给出所有可能存在的问题的查询，并给出足够详细的建议。相当于给 MySQL 所有的查询做一次全面健康的检查。

### 使用用户自定义变量

[MySQL :: MySQL 8.0 Reference Manual :: 9.4 User-Defined Variables](https://dev.mysql.com/doc/refman/8.0/en/user-variables.html)

用户自定义变量是一个用来存储内容的临时容器，在连接 MySQL 的整个过程中都存在。

```sql
SET @var_name = expr [, @var_name = expr] ...
mysql> SET @v1 = X'41';
mysql> SET @v2 = X'41'+0;
mysql> SET @v3 = CAST(X'41' AS UNSIGNED);
mysql> SELECT @v1, @v2, @v3;
+------+------+------+
| @v1  | @v2  | @v3  |
+------+------+------+
| A    |   65 |   65 |
+------+------+------+
mysql> SET @v1 = b'1000001';
mysql> SET @v2 = b'1000001'+0;
mysql> SET @v3 = CAST(b'1000001' AS UNSIGNED);
mysql> SELECT @v1, @v2, @v3;
+------+------+------+
| @v1  | @v2  | @v3  |
+------+------+------+
| A    |   65 |   65 |
+------+------+------+
```

1. 查询运行时计算总数和平均值
2. 模拟 GROUP 语句中的函数 FIRST() 和 LAST()
3. 对大量数据做一些数据计算
4. 计算一个大表的 MD5 散列值
5. 编写一个样本处理函数，当样本中的数值超过某个边界值的适合将其变成0
6. 模拟读/写游标
7. 在 SHOW 语句的 WHERE 子句中加入变量值