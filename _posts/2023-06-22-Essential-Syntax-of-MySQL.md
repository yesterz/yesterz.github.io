---
title: MySQL 基础语法整理
categories: [Database]
tags: [MySQL, Database]
toc: true
---


## Database 名词

DDL：用于创建，修改，删除数据库中的各种对象（数据库，表，视图，索引等）

DML：用于操作数据库表中的记录，Insert，update，delete

DQL：用于查询数据库表中的记录，select

DCL：用于定义数据库访问权限和安全级别，grant，revoke

DML（data manipulation language）

DDL（data definition language）

DCL（Data Control Language）

DQL（Data Query Language）

## SQL 书写要求

* SQL 语句可以单行或多行书写，用分号结尾
* SQL 关键字用空格分隔，也可以用缩进来增强语句的可读性
* SQL 对大小写不敏感
* 用 # 或 -- 单行注释，用 /* */ 多行注释，注释语句不可执行

## 导入数据

```sql
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/userinfo.csv"
	into table userinfo
    fields terminated by ','
	ignore 1 lines;
```

##  SET SQL_SAFE_UPDATES=0;

## 数据定义语言 DDL

Data Definition Language 

### 数据库基本结构

* **数据库：**组织、存储和管理相关数据的集合， 同一个数据库管理系统中数据库名必须**唯一**
* **表：**由固定列数和任意行数构成的二维表结构的数据集， 同一个数据库中表名必须**唯一**
* **字段：**一列即为一个字段， 同一个表中字段名必须**唯一**
* **记录：**一行即为一条记录
* 以**字段**为基本存储和计算单位，每个字段的数据类型必须一致

### 数据库的增删改查

* 查看系统中有哪些数据库
```sql
show databases;
```
* 创建数据库
```sql
create database 数据库名称;
```
>数据库名称不能与SQL关键字相同，也不能重复
* 选择使用数据库
```sql
use 数据库名称;
```
* 删除数据库
```sql
drop database 数据库名称;
```

### 数据表的增删改查

* 创建数据表
```sql
create table 表名(... ...);
```
Pre：建表之前要先选择进入数据库：use 数据库名称;
建表时可以不指定约束条件，但是**必须指定表名、字段名及每个字段的数据类型**

表名不能与SQL关键字相同，同一个数据库下的表名不能重复

* 查看当前数据库中所有表
```sql
show tables;
```
* 查看表结构
```sql
describe 表名;
desc 表名;
```
* 删除数据表
```sql
drop table 表名;
```

```sql
CREATE TABLE new_tbl [AS] SELECT * FROM orig_tbl;
```
注：**as**可以省略
利用select语句创建数据表

```sql
CREATE TABLE artists_and_works as
  SELECT artist.name, COUNT(work.artist_id) AS number_of_works
  FROM artist LEFT JOIN work ON artist.id=work.artist_id
  GROUP BY artist.id;
```
>[https://dev.mysql.com/doc/refman/8.0/en/create-table-select.html](https://dev.mysql.com/doc/refman/8.0/en/create-table-select.html)


## MySQL常用数据类型

* **int：**大整数型，有符号大小-2147483648~2147483647， 无符号大小0~4294967295，默认长度最多为11个数字，如int(11)
* **float：**单精度浮点型，默认float(10,2)，表示最多10个数字，其中有2位小数
* **decimal：**十进制小数型，适合金额、价格等对精度要求较高的数据存储。默认decimal(10,0)，表示最多10位数字，其中0位小数。
* **char：**固定长度字符串型，长度为1-255。如果长度小于指定长度，右边填充空格。如果不指定长度，默认为1。如char(10)，‘abc ’
* **varchar：**可变长度字符串型，长度为1-255。必须指定长度，如varchar(10)，‘abc’
* **text：**长文本字符串型，最大长度65535，不能指定长度
* **date：**日期型，‘yyyy-MM-dd’
* **time：**时间型，‘hh:mm:ss’
* **datetime：**日期时间型，‘yyyy-MM-dd hh:mm:ss’
* **Timestamp：**时间戳，在1970-01-01 00:00:00和2037-12-31 23:59:59之间，如1973-12-30 15:30，时间戳为:19731230153000
>字符串类型和日期时间类型都需要用引号括起来

## 约束条件

* 约束条件使在表上强制执行的数据检验规则
* 用来保证创建的表的数据完整性和准确性
* 主要在两方面对数据进行约束：空值和重复值

## 只是因为你 不是因为你的任何

### MySQL 数据库常用约束条件

|约束条件|备注|说明|
|:----|:----|:----|
|primary key|主键约束|非空不重复|
|not null|非空约束|不能为空|
|unique|唯一约束|不能重复|
|auto_increment|自增字段|自动增长|
|default|默认约束|默认值|
|foreign key|外键约束|与主键相对应|

### 主键约束（primary key）

每个表中只能有一个主键

非空不重复的字段可以作为主键

可以设置单字段主键，也可以设置多字段联合主键

联合主键中多个字  的取值完全相同时，才违反主键约束

添加主键约束：

```sql
create table emp(empno int primary key, empname varchar(10));
```

列级添加主键约束：

```sql

```

### 唯一约束（unique）

* 指定字段的取值不能重复，可以为空，但只能出现一个空值
* 添加唯一约束：
    * 列级添加唯一约束：create table <表名> (<字段名1> <字段类型1> unique, ...... <字段名n> <字段类型n>);
    * 表级添加唯一约束：create talbe <表名> (<字段名1> <字段类型1>, ...... <字段名n> <字段类型n>, [constraint 唯一约束名] unique(字段名1,[字段名2,....,字段名n]));

### 自动增长列（auto_increment）

* 指定字段的取值自动生成，默认从 1 开始，每增加一条记录，该字段的取值会加 1
* 只适用于整数型，配合主键一起使用
* 创建自动增长约束：create table <表名> (<字段名1> <字段类型1> primary key auto_increment, ......<字段名n> <字段类型n>);

### 非空约束（not null）

* 字段的值不能空
* 创建非空约束：create table <表名> (<字段名1> <字段类型1> not null,...... <字段名n> <字段类型n>);

### 默认约束（default）

* 如果新插入一条记录时没有为该字段赋值，系统会自动为这个字段赋值为默认约束设定的值
* 创建默认约束：
```sql
create table <表名> 
(<字段名1> <字段类型1> default value, 
......
<字段名n> <字段类型n>);
```

### 外键约束（foreign key）

在一张表中执行数据插入、更新、删除等操作时，DBMS都会跟另一张表进行对照，避免不规范的操作，以确保数据存储的完整性。

* 某一表中某字段的值依赖于另一张表中某字段的值
* 主键所在的表为主表，外键所在的表为从表
* 每一个外键值必须与另一个表中的主键值相对应
* 创建外键约束：
```sql
create table <表名> (<字段名1> <字段类型1>, ......<字段名n> <字段类型n>, [constraint 外键约束名] foreign key(字段名) references <主表>(主键字段));
```

## ！！！修改数据表

修改数据库中已经存在的数据表的结构

* **修改表名：**
```sql
alter table 原表名 rename 新表名;
```
* **修改字段名：**
```sql
alter table 表名 change 原字段名 新字段名 数据类型 [自增/非空/默认] [字段位置];
```
* **修改字段类型：**
```sql
alter table 表名 modify 字段名 新数据类型 [自增/非空/默认] [字段位置];
```
* **添加字段：**
```sql
alter table 表名 add 新字段名 数据类型;
```
* **修改字段的排列位置：**
```sql
alter table 表名 modify 字段名 数据类型 first;
alter table 表名 modify 要排列的字段名 数据类型 after 参照字段;
```
* **删除字段：**
```sql
alter table 表名 drop 字段名;
```

## DML data  manipulation language

插入，添加，修改，删除

### 插入数据

字段名与字段值的数据类型、个数顺序必须一一对应

* **指定字段名插入：**
```sql
insert into 表名(字段名1[, 字段名2, ...]) values(字段值1[, 字段值2, ...]);
```
* **不指定字段名插入：**
```sql
insert into 表名 values(字段值1[, 字段值2, ...]);
```
需要为表中的每一个字段指定值，且值的顺序需和数据表中字段顺序相同
* **批量导入数据：**（路径中不能有中文，并且要将 '\' 改为 '\\' 或 '/'）
```sql
load data infile '文件路径.csv' into table 表名[ fields terminated by ',' ignore 1 lines];
```

### 更新数据

```sql
update 表名 set 字段名1=字段值1 [, 字段名2=字段值2[,...]] [where 更新条件];
```

>Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.
```sql
set SQL_SAFE_UPDATES=0;
```

### 删除

```sql
delete from 表名 [where 删除条件];
```
* truncate 表名;
与 delete from 表名一样，都是**删除表中全部数据，保留表结构**

* delete 和 truncate 的区别：
delete 可以添加 where 子句删除表中部分数据，turncate 只能删除表中全部数据

truncate 删除表中数据保留表结构，turncate 直接把表删除（drop table）然后再创建一张新表（create table），执行速度比 delete 快。


## 单表查询

* 全表查询：
```sql
select * from 表名;
```
* 查询指定列：
```sql
select 字段1[, 字段2, ...] from 表名;
```
* 别名的设置：
```sql
select 字段名 [as] 列别名 from 原表名 [as] 表别名;
```
>as 关键字可以省略
* 查询不重复的记录：
```sql
select distinct 字段名 from 表名;
```
* 条件查询：
```sql
select 字段1[, 字段2, ...] from 表名 where 查询条件;
```
* 空值查询：
```sql
select 字段1[, 字段2, ...] from 表名 where 空值字段 is [not] null;
```
* 模糊查询：
```sql
select 字段1[, 字段2, ...] from 表名 where 字符串字段 [not] like 通配符;
```
    * **百分号（%）通配符：**匹配**任意字符出现任意次数**
    * **下划线（_）通配符：**总是匹配**一个字符**
模糊查询只能用于**字符串类型**的字段

* 查询结果排序： 
```sql
select 字段1[,字段2,…] 
from 表名 
order by 字段1[ 排序方向,字段2 排序方向,…];
```
**解释：多字段排序时**，先按第一个字段排序，第一个字段值相同时再按第二个字段排序，指定排序方向： asc升序， desc降序（没有指定排序方向时，默认是asc升序）
* 限制查询结果数量： 
```sql
select 字段1[,字段2,…] 
from 表名 
limit [偏移量,] 行数;
```
**注意：**limit接受一个或两个数字参数，参数必须是一个整数常量，第一个参数指定第一个返回记录行的偏移量，第二个参数指定返回记录行的最大数目，如果只给定一个参数，表示返回最大的记录行数目，初始记录行的偏移量是0(而不是1)

## 分组查询

```sql
select 字段1[,字段2,…] 
from 表名[ where 查询条件] 
group by 分组字段1[,分组字段2,…];
```
将查询结果按照一个或多个字段进行分组， 字段值相同的为一组，对每个组进行聚合计算

### **分组后筛选**

```sql
select 字段1[,字段2, …] 
from 表名[ where 查询条件][ group by 分组字段1[,分组字段2,…]] 
having 筛选条件;
```

### **where 与 having 的区别：**

* where子句作用于整个二维表的每行记录， having子句作用于组的每行记录
* where条件查询的作用域是针对数据表进行筛选，而having条件查询则是对分组结果进行过滤
* where在分组和聚合计算之前筛选行，而having 在分组和聚合之后筛选分组的行，**因此where子句不能包含聚合函数**

## SQL执行顺序

数据库在运行时的先后顺序

**(8)**SELECT **(9)**DISTINCT **(11)** <Top Num> <select list>

**(1)****FROM**[left_table]

**(3)** <join_type> JOIN <right_table>

**(2)** ON <join_condition>

**(4)**WHERE <where_condition>

**(5)**GROUP BY <group_by_list>

**(6)**WITH <CUBE | RollUP>

**(7)**HAVING <having_condition>

**(10)**ORDER BY <order_by_list>


## select 语句书写顺序

|子句顺序|说明|是否必须使用|
|:----|:----|:----|
|SELECT|要返回的列或表达式|是|
|FROM|从中检索数据的表或视图|仅从中检索数据时使用|
|WHERE|行级过滤|仅对记录进行筛选时使用|
|GROUP BY|分组字段|仅在分组聚合运算时使用|
|HAVING|组级过滤|仅对分组进行筛选时使用|
|ORDER BY|输出排序|仅对查询结果进行排序时使用|
|LIMIT|限制输出|仅对查询结果限制输出时使用|

### 例子

```sql
select columnName
from tableName
where queryExpression
group by groupbyExpression
having groupCondition
order by columnName asc/desc
limit [offset,] count;
```
>select后面出现的列名必须在 group by 中或者必须使用聚合函数。

## 运算符与优先级

### 算术运算符

|运算符|作用|
|:----|:----|
|+|加|
|-|减|
|*|乘|
|/|除|

### 逻辑运算符

|运算符|作用|
|:----|:----|
|and|且|
|or|或|
|not|非|

### 比较运算符

|运算符|作用|
|:----|:----|
|=|等于|
|>、＞=|大于、大于等于|
|＜、＜＝|小于、小于等于|
|!＝、<>|不等于|
|between ... and ...|值范围|

### 运算符优先级

|优先级|运算符|
|:----|:----|
|1|括号 ( )|
|2|算术运算符|
|3|比较运算符|
|4|逻辑运算符|

>其中逻辑运算符先非运算，再且运算，最后或运算

## 聚合函数

|aggregate function|notes|
|:----|:----|
|avg( )|返回某列的平均值|
|count( )|返回某列的行数|
|max( )|返回某列的最大值|
|min( )|返回某列的最小值|
|sum( )|返回某列值之和|

**注意：**AVG( ) 函数只能用来求一列的平均值，COUNT( * ) 函数列中的所有行进行计数不忽略空值，COUNT(column) 对特定列中具有值的行进行计数且忽略空值。

查询语句的**select**，**group by**和**having**字句是**聚合函数唯一出现的地方**，在where子句中不能出现聚组函数。

>[https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html)
# 
### **Table 12.25 Aggregate Functions**

|Name|Description|
|:----|:----|
|[AVG()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_avg)|Return the average value of the argument|
|[BIT_AND()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_bit-and)|Return bitwise AND|
|[BIT_OR()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_bit-or)|Return bitwise OR|
|[BIT_XOR()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_bit-xor)|Return bitwise XOR|
|[COUNT()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_count)|Return a count of the number of rows returned|
|[COUNT(DISTINCT)](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_count-distinct)|Return the count of a number of different values|
|[GROUP_CONCAT()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_group-concat)|Return a concatenated string|
|[JSON_ARRAYAGG()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_json-arrayagg)|Return result set as a single JSON array|
|[JSON_OBJECTAGG()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_json-objectagg)|Return result set as a single JSON object|
|[MAX()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_max)|Return the maximum value|
|[MIN()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_min)|Return the minimum value|
|[STD()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_std)|Return the population standard deviation|
|[STDDEV()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_stddev)|Return the population standard deviation|
|[STDDEV_POP()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_stddev-pop)|Return the population standard deviation|
|[STDDEV_SAMP()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_stddev-samp)|Return the sample standard deviation|
|[SUM()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_sum)|Return the sum|
|[VAR_POP()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_var-pop)|Return the population standard variance|
|[VAR_SAMP()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_var-samp)|Return the sample variance|
|[VARIANCE()](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html#function_variance)|Return the population standard variance|

## 多表查询

通过不同表中具有相同意义的关键字段，将多个表进行连接，查询不同表中的字段信息

### 连接方式

* 内连接和外连接（左连接和右连接）

### SQL 查询的基本原理：

* **单表查询：**根据 where 条件过滤表中的记录，然后根据 select 指定的列返回查询结果。
* **两表连接查询：**使用 on 条件对两表进行连接形成一张虚拟结果集；然后根据 where 条件过滤结果集中的记录，再根据 select 指定的列返回查询结果。
* **多表连接查询：**先对第一个和第二个表按照两表连接查询，然后用连接后的虚拟结果集和第三个表做链接查询，以此类推，直到所有的表都连接上为止，最终形成一张虚拟结果集，然后根据 where 条件过滤虚拟结果集中的记录，再根据 select 指定的列返回查询结果。

### 多表连接的结果通过三个属性决定

* **方向性：**在外连接中写在前边的表为左表、写在后边的表为右表
* **主附关系：**主表要出所有的数据范围，附表与主表无匹配项时标记 为null，内连接时无主附表之分
* **对应关系：**关键字段中有重复值的表为多表，没有重复值的表为一表

### 解题思路

1、 需要查询的信息在哪几张表

2、表和表之间的对应关系和主附关系

3、表和表之间的连接条件


### 三种对应关系

* 一对一：1:1
* 一对多（多对一）：1:N
* 多对多：N:N

### 为什么要拆分表

节省存储空间，避免数据冗余

### 内连接

按照连接条件合并两个表，返回满足条件的行。

```sql
select 字段1[, …] 
from 表1[ inner] join 表2 on 表1.key=表2.key;
```


### 左连接

结果中除了包括满足连接条件的行外，还包括左表的所有行。

```sql
select 字段1[, …] 
from 表1 
left join 表2 on 表1.key=表2.key;
```

### 右连接

结果中除了包括满足连接条件的行外，还包括右表的所有行。

```sql
select 字段1[,…] 
from 表1 
right join 表2 on 表1.key=表2.key;
```

### 联合查询

把多条select语句的查询结果合并为一个结果集。

* 被合并的结果集的列数、顺序和数据类型必须完全一致

#### union去重： 

```sql
select 字段1[,字段2,…] 
from 表名 
union 
select 字段1[,字段2,…] 
from 表名;
```

#### union all不去重： 

```sql
select 字段1[,字段2,…] 
from 表名 
union all 
select 字段1[,字段2,…] 
from 表名;
```
纵向合并

### 不等值连接

## 子查询

一个 select 语句中包含另一个或多个完整的select语句。

### 子查询分类

1. **标量子查询：**返回的结果是一个数据（单行单列）
2. **行子查询：**返回的结果是一行(单行多列)
3. **列子查询：**返回的结果是一列(多行单列)
4. **表子查询：**返回的结果是一张表(多行多列)

### 子查询出现的位置

1. **出现在 select 子句中：**将子查询返回结果作为主查询的一个字段或者计算值（标量子查询、列子查询）
2. **出现在 where/having 子句中：**将子查询返回的结果作为主查询的条件（标量子查询、行子查询、列子查询、表子查询）
3. **出现在 from 子句中：**将子查询返回的结果作为主查询的一个表（标量子查询、行子查询、列子查询、表子查询）

### 子查询操作符

|语义|操作符|使用格式或示例|示例解释|
|:----|:----|:----|:----|
|在（不在）其中|[not] in|<字段> in (<数据表/子查询>)|将字段值与数据表/子查询的结果集比较，看字段值在（不对）数据表或结果集中。|
|任何一个|any|<字段><比较>any(<数据表/子查询>)|测试字段值是否大于数据表或子查询结果集中的任何一个值|
|全部（每个）|all|<字段><比较>any(<数据表/子查询>)|测试字段值是否大于数据表或子查询结果集中的每一个值|

**in 与 = 的转换**

```sql
select * 
from Websites 
where name in ('Google','Baidu');
```
**=** 的等效表达：
```sql
select * 
from Websites 
where name='Google' or name='Baidu';
```

## 常用函数

### 数学函数

|函数|说明|
|:----|:----|
|abs( n )|返回 n 的**绝对值**|
|floor( n )|返回**不大于**n 的**最大**整数值**（去掉小数取整）**|
|ceiling( n )|返回**不小于** n 的**最小**整数值**（进一取整）**|
|round( n[, d] )|返回 n 的四舍五入值，保留 d 位小数（d 的默认值为 0）**（四舍五入**）|
|round( [n] )|返回在范围 0 到 1.0 内的**随机浮点值**（可以使用数字 **n 作为初始值**）|
|bin( x )|返回 x 的二进制（OCT 返回八进制，HEX 返回十六进制）|
|exp( x )|返回值 e （自然对数的底）的 x 次方|
|greatest( x1, x2, ..., xn )|返回集合中最大的值|
|ln( x )|返回 x 的自然对数|
|log( x, y )|返回 x 的以 y 为底的对数|
|mod( x, y )|返回 x/y 的模**（余数）**|
|pi( )|返回 pi 的值**（圆周率）**|
|rand( )|返回 0 到 1 内的随机值，可以通过提供一个参数（种子）使 rand( ) 随机数生成器生成一个指定的值|
|truncate( x, y )|返回**数字 x 截短为 y 位小数**的结果|
|sign( x )|返回数字 x 的符号的值（正数返回 1，负数返回 -1，0 返回 0）|
|sqrt( x )|返回一个数的平方根|

### 时间日期函数

|函数|说明|
|:----|:----|
|date_format( date, fmt )|依照指定的 fmt 格式格式化日期 date 值|
|from_unixtime( ts, fmt )|依据指定的 fmt 格式，格式化 UNIX 时间戳 ts|
|monthname( date )|返回 date 的月份名（英语月份，如 October）|
|dayname( date )|返回 date 的星期名（英语星期几，如 Saturday）|
|now( )|返回当前的日期和时间|
|curdate( )<br>current_date( )|返回当前的日期|
|curtime( )<br>current_time( )|返回当前的时间|
|quarter( date )|返回 date 在一年中的季度**（1 ~ 4）**|
|week( date )|返回日期 date 为一年中第几周**（0 ~ 53）**|
|dayofyear( date )|返回 date 是一年的第几天**（1 ~ 366）**|
|dayofmonth( date )|返回 date 是一个月中的第几天**（1 ~ 7）**|
|year( date )|返回日期 date 的年份**（1000 ~ 9999）**|
|month( date )|返回 date 的月份值**（1 ~ 12）**|
|day( date )|返回 date 的天数部分|
|hour( time )|返回 time 的小时值**（0 ~ 23）**|
|minute( time )|返回 time 的分钟值**（0 ~ 59）**|
|second( time )|返回 time 的秒值**（r0 ~ 59）**|
|date( datetime )|返回 datetime 的日期值|
|time( datetime )|返回 datetime 的时间值|

#### fmt格式详解

MySQL 使用下列数据类型在数据库中存储日期或日期/时间值：

* DATE - 格式 YYYY-MM-DD
* DATETIME - 格式: YYYY-MM-DD HH:MM:SS
* TIMESTAMP - 格式: YYYY-MM-DD HH:MM:SS
* YEAR - 格式 YYYY 或 YY
|date值|格式缩写|
|:----|:----|
|年|yy, yyyy|
|季度|qq, q|
|月|mm, m|
|年中的日|dy, y|
|日|dd, d|
|周|wk, w|
|星期|dw, w|
|小时|hh|
|分钟|mi, n|
|秒|ss, s|
|毫秒|ms|

### 字符串函数

|函数|说明|
|:----|:----|
|    |    |
|    |    |
|    |    |
|    |    |
|    |    |

#### MID( ) 函数

MID 函数用于从文本字段中提取字符。

```sql
SELECT MID(column_name,start[,length]) 
FROM table_name
```
|参数|描述|
|:----|:----|
|column_name|必需。要提取字符的字段。|
|start|必需。规定开始位置（起始值是 1）。|
|length|可选。要返回的字符数。如果省略，则 MID() 函数返回剩余文本。|

#### LEN() 函数

LEN 函数返回文本字段中值的长度。

```sql
SELECT LEN(column_name) 
FROM table_name
```
#### UCASE() 函数

UCASE 函数把字段的值转换为大写。

```sql
SELECT UCASE(column_name) 
FROM table_name
```
#### LCASE() 函数

LCASE 函数把字段的值转换为小写。

```sql
SELECT LCASE(column_name) 
FROM table_name
```

## 分组聚合函数

### Flow Control Functions

|**Flow Control Operators**|    |
|:----|:----|
|Name|Description|
|[CASE](https://dev.mysql.com/doc/refman/8.0/en/flow-control-functions.html#operator_case)|Case **operator**|
|[IF()](https://dev.mysql.com/doc/refman/8.0/en/flow-control-functions.html#function_if)|If/else construct|
|[IFNULL()](https://dev.mysql.com/doc/refman/8.0/en/flow-control-functions.html#function_ifnull)|Null if/else construct|
|[NULLIF()](https://dev.mysql.com/doc/refman/8.0/en/flow-control-functions.html#function_nullif)|Return NULL if expr1 = expr2|

### CASE ***operator*** 

```sql
CASE value WHEN compare_value THEN result 
    [WHEN compare_value THEN result ...] 
    [ELSE result] 
    END

CASE WHEN condition THEN result 
    [WHEN condition THEN result ...] 
    [ELSE result] 
    END 
```

* 第一个case语法，当value值等于compare_value值时返回result值。
* 第二个case语法，当条件condition为True则返回result值，当没有条件condition为True则返回else后的result值，如果没有else则返回null。

#### 语法实例1

```sql
create table order_new
select order_id, original_value-discount as spend,
  case when discount>0 then 1
       when discount=0 then 0
       else "其他"
       end as discount_flag
from order_2017
```

#### 语法实例2

```sql
select name,
sum (case course when 'Chinese' then grade else 0 end) as Chinese,
sum (case course when 'Math' then grade else 0 end) as Math,
sum (case course when 'English' then grade else 0 end) as English
from Table_A
group by name
```
>一个横标转纵表的例子，分段统计的例子
**Note**

>The syntax of the `CASE` *operator* described here differs slightly from that of the SQL `CASE` *statement* described in [Section 13.6.5.1, “CASE Statement”](https://dev.mysql.com/doc/refman/8.0/en/case.html), for use inside stored programs. The `CASE` statement cannot have an `ELSE NULL` clause, and it is terminated with `END CASE` instead of `END`.
Note: 

①CASE Operator的语法与CASE Statement语法不同，CASE Statement不能有ELSE NULL子句，而且用END CASE结束，而CASE Operator用end结束

**②The return type of a**`CASE`**expression result is the aggregated type of all result values:（其他例子见参考文档）**

 

### IF(expr1, expr2, expr3)

如果expr1 为True（expr1不等于0，expr为NULL），函数返回expr2，否则返回expr3

#### 语法实例

```sql

```

### IFNULL(expr1, expr2)

如果expr1不为NULL，IFNULL()返回expr1，否则返回expr2

#### 语法实例

```sql

```


### NULLIF(expr1,expr2)

返回NULL如果expr1=expr2为True，否则返回expr1

* 与下面语句相同
```sql
case when expr1=expr2 then null else expr1 end
```
返回值的类型与第一个参数相同

### if Satement

```sql
IF search_condition THEN statement_list
    [ELSEIF search_condition THEN statement_list] ...
    [ELSE statement_list]
END IF
```

### CASE Statement

```sql
CASE case_value
    WHEN when_value THEN statement_list
    [WHEN when_value THEN statement_list] ...
    [ELSE statement_list]
END CASE
```
或者
```sql
CASE
    WHEN search_condition THEN statement_list
    [WHEN search_condition THEN statement_list] ...
    [ELSE statement_list]
END CASE
```

## Window Function Concepts and Syntax

This section describes how to use window functions. Examples use the same sales information data set as found in the discussion of the `GROUPING()` function in [Section 12.20.2, “GROUP BY Modifiers”](https://dev.mysql.com/doc/refman/8.0/en/group-by-modifiers.html):

这一章节描述了怎么使用窗口函数。例子用的是同样的一个销售信息数据集。

```plain
mysql> SELECT * FROM sales ORDER BY country, year, product;
+------+---------+------------+--------+
| year | country | product    | profit |
+------+---------+------------+--------+
| 2000 | Finland | Computer   |   1500 |
| 2000 | Finland | Phone      |    100 |
| 2001 | Finland | Phone      |     10 |
| 2000 | India   | Calculator |     75 |
| 2000 | India   | Calculator |     75 |
| 2000 | India   | Computer   |   1200 |
| 2000 | USA     | Calculator |     75 |
| 2000 | USA     | Computer   |   1500 |
| 2001 | USA     | Calculator |     50 |
| 2001 | USA     | Computer   |   1500 |
| 2001 | USA     | Computer   |   1200 |
| 2001 | USA     | TV         |    150 |
| 2001 | USA     | TV         |    100 |
+------+---------+------------+--------+

```
A window function performs an aggregate-like operation on a set of query rows. 
一个窗口函数类似于执行在一系列查询行的聚集函数。

However, whereas an aggregate operation groups query rows into a single result row, a window function produces a result for each query row:

然而，聚集操作是将多个查询行以一个结果行展示，而窗口函数的结果将在每一个查询行展示。

* The row for which function evaluation occurs is called the current row.
当前行（the current row）是窗口函数每次计算的行。

* The query rows related to the current row over which function evaluation occurs comprise the window for the current row.
与当前行相关的查询行（函数求值发生在该行上）构成当前行的窗口。

For example, using the sales information table, these two queries perform aggregate operations that produce a single global sum for all rows taken as a group, and sums grouped per country:

```plain
mysql> SELECT SUM(profit) AS total_profit
       FROM sales;
+--------------+
| total_profit |
+--------------+
|         7535 |
+--------------+
mysql> SELECT country, SUM(profit) AS country_profit
       FROM sales
       GROUP BY country
       ORDER BY country;
+---------+----------------+
| country | country_profit |
+---------+----------------+
| Finland |           1610 |
| India   |           1350 |
| USA     |           4575 |
+---------+----------------+

```
By contrast, window operations do not collapse groups of query rows to a single output row. Instead, they produce a result for each row. Like the preceding queries, the following query uses `SUM()`, but this time as a window function:
进行对比，窗口函数将产生的结果作为每一行的结果集输出

```plain
mysql> SELECT
         year, country, product, profit,
         SUM(profit) OVER() AS total_profit,
         SUM(profit) OVER(PARTITION BY country) AS country_profit
       FROM sales
       ORDER BY country, year, product, profit;
+------+---------+------------+--------+--------------+----------------+
| year | country | product    | profit | total_profit | country_profit |
+------+---------+------------+--------+--------------+----------------+
| 2000 | Finland | Computer   |   1500 |         7535 |           1610 |
| 2000 | Finland | Phone      |    100 |         7535 |           1610 |
| 2001 | Finland | Phone      |     10 |         7535 |           1610 |
| 2000 | India   | Calculator |     75 |         7535 |           1350 |
| 2000 | India   | Calculator |     75 |         7535 |           1350 |
| 2000 | India   | Computer   |   1200 |         7535 |           1350 |
| 2000 | USA     | Calculator |     75 |         7535 |           4575 |
| 2000 | USA     | Computer   |   1500 |         7535 |           4575 |
| 2001 | USA     | Calculator |     50 |         7535 |           4575 |
| 2001 | USA     | Computer   |   1200 |         7535 |           4575 |
| 2001 | USA     | Computer   |   1500 |         7535 |           4575 |
| 2001 | USA     | TV         |    100 |         7535 |           4575 |
| 2001 | USA     | TV         |    150 |         7535 |           4575 |
+------+---------+------------+--------+--------------+----------------+

```
Each window operation in the query is signified by inclusion of an `OVER` clause that specifies how to partition query rows into groups for processing by the window function:
* The first `OVER` clause is**empty**, which **treats the entire set of query rows as a single partition**. The window function thus produces a global sum, but does so for each row.
* The second `OVER` clause**partitions rows by country**, producing a sum per partition (per country). The function produces this sum for each partition row.
**Window functions are permitted only in the select list and**`ORDER BY`**clause.**Query result rows are determined from the `FROM` clause, after `WHERE`, `GROUP BY`, and `HAVING` processing, and windowing execution occurs before `ORDER BY`, `LIMIT`, and `SELECT DISTINCT`.

**The**`OVER`**clause is permitted for many aggregate functions,** which therefore can be used as window or nonwindow functions, depending on whether the `OVER` clause is present or absent:

```plain
AVG()
BIT_AND()
BIT_OR()
BIT_XOR()
COUNT()
JSON_ARRAYAGG()
JSON_OBJECTAGG()
MAX()
MIN()
STDDEV_POP(), STDDEV(), STD()
STDDEV_SAMP()
SUM()
VAR_POP(), VARIANCE()
VAR_SAMP()

```
For details about each aggregate function, see [Section 12.20.1, “Aggregate Function Descriptions”](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html).
MySQL also supports nonaggregate functions that are used only as window functions. For these, the `OVER` clause is mandatory（必须的，强制性的）:

```plain
CUME_DIST()
DENSE_RANK()
FIRST_VALUE()
LAG()
LAST_VALUE()
LEAD()
NTH_VALUE()
NTILE()
PERCENT_RANK()
RANK()
ROW_NUMBER()
```
For details about each nonaggregate function, see [Section 12.21.1, “Window Function Descriptions”](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html).
As an example of one of those nonaggregate window functions, this query uses `ROW_NUMBER()`, which **produces the row number of each row within its partition.** In this case, rows are numbered per country. By default, partition rows are unordered and row numbering is nondeterministic. To sort partition rows, include an `ORDER BY` clause within the window definition. The query uses unordered and ordered partitions (the `row_num1` and `row_num2` columns) to illustrate the difference between omitting and including `ORDER BY`:

```plain
mysql> SELECT
         year, country, product, profit,
         ROW_NUMBER() OVER(PARTITION BY country) AS row_num1,
         ROW_NUMBER() OVER(PARTITION BY country ORDER BY year, product) AS row_num2
       FROM sales;
+------+---------+------------+--------+----------+----------+
| year | country | product    | profit | row_num1 | row_num2 |
+------+---------+------------+--------+----------+----------+
| 2000 | Finland | Computer   |   1500 |        2 |        1 |
| 2000 | Finland | Phone      |    100 |        1 |        2 |
| 2001 | Finland | Phone      |     10 |        3 |        3 |
| 2000 | India   | Calculator |     75 |        2 |        1 |
| 2000 | India   | Calculator |     75 |        3 |        2 |
| 2000 | India   | Computer   |   1200 |        1 |        3 |
| 2000 | USA     | Calculator |     75 |        5 |        1 |
| 2000 | USA     | Computer   |   1500 |        4 |        2 |
| 2001 | USA     | Calculator |     50 |        2 |        3 |
| 2001 | USA     | Computer   |   1500 |        3 |        4 |
| 2001 | USA     | Computer   |   1200 |        7 |        5 |
| 2001 | USA     | TV         |    150 |        1 |        6 |
| 2001 | USA     | TV         |    100 |        6 |        7 |
+------+---------+------------+--------+----------+----------+

```
As mentioned previously, to use a window function (or treat an aggregate function as a window function), include an `OVER` clause following the function call. The `OVER` clause has two forms:
```plain
over_clause:
    {OVER (window_spec) | OVER window_name}

```
Both forms define how the window function should process query rows. They differ in whether the window is defined directly in the `OVER` clause, or supplied by a reference to a named window defined elsewhere in the query:
* In the first case, the window specification appears directly in the `OVER` clause, between the parentheses.
* In the second case, `window_name` is the name for a window specification defined by a `WINDOW` clause elsewhere in the query. For details, see [Section 12.21.4, “Named Windows”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-named-windows.html).
**For**`OVER (``window_spec``)`**syntax, the window specification has several parts, all optional:**

```plain
window_spec:
    [window_name] [partition_clause] [order_clause] [frame_clause]

```
**If**`OVER()`**is empty, the window consists of all query rows and the window function computes a result using all rows.** Otherwise, the clauses present within the parentheses determine which query rows are used to compute the function result and how they are partitioned and ordered:
* `window_name`: The name of a window defined by a `WINDOW` clause elsewhere in the query. If `window_name` appears by itself within the `OVER` clause, it completely defines the window. If partitioning, ordering, or framing clauses are also given, they modify interpretation of the named window. For details, see [Section 12.21.4, “Named Windows”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-named-windows.html).
`partition_clause`: A `PARTITION BY` clause indicates how to divide the query rows into groups. The window function result for a given row is based on the rows of the partition that contains the row. If `PARTITION BY` is omitted, there is a single partition consisting of all query rows.

**Note**

Partitioning for window functions differs from table partitioning. For information about table partitioning, see [Chapter 24, ](https://dev.mysql.com/doc/refman/8.0/en/partitioning.html)[Partitioning](https://dev.mysql.com/doc/refman/8.0/en/partitioning.html).

`partition_clause` has this syntax:

```plain
partition_clause:
    PARTITION BY expr [, expr] ...

```
* Standard SQL requires `PARTITION BY` to be followed by column names only. A MySQL extension is to permit expressions, not just column names. For example, if a table contains a `TIMESTAMP` column named `ts`, standard SQL permits `PARTITION BY ts` but not `PARTITION BY HOUR(ts)`, whereas MySQL permits both.
`order_clause`: An `ORDER BY` clause indicates how to sort rows in each partition. Partition rows that are equal according to the `ORDER BY` clause are considered peers. If `ORDER BY` is omitted, partition rows are unordered, with no processing order implied, and all partition rows are peers.

`order_clause` has this syntax:

```plain
order_clause:
    ORDER BY expr [ASC|DESC] [, expr [ASC|DESC]] ...

```
Each `ORDER BY` expression optionally can be followed by `ASC` or `DESC` to indicate sort direction. The default is `ASC` if no direction is specified. `NULL` values sort first for ascending sorts, last for descending sorts.
* An `ORDER BY` in a window definition applies within individual partitions. To sort the result set as a whole, include an `ORDER BY` at the query top level.
* `frame_clause`: A frame is a subset of the current partition and the frame clause specifies how to define the subset. The frame clause has many subclauses of its own. For details, see [Section 12.21.3, “Window Function Frame Specification”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-frames.html).


### 12.21.3 Window Function Frame Specification

The definition of a window used with a window function can include a frame clause. A frame is a subset of the current partition and the frame clause specifies how to define the subset.

Frames are determined with respect to the current row, which enables a frame to move within a partition depending on the location of the current row within its partition. Examples:

* By defining a frame to be all rows from the partition start to the current row, you can compute running totals for each row.
* By defining a frame as extending `N` rows on either side of the current row, you can compute rolling averages.
The following query demonstrates the use of moving frames to compute running totals within each group of time-ordered `level` values, as well as rolling averages computed from the current row and the rows that immediately precede and follow it:

```plain
mysql> SELECT
         time, subject, val,
         SUM(val) OVER (PARTITION BY subject ORDER BY time
                        ROWS UNBOUNDED PRECEDING)
           AS running_total,
         AVG(val) OVER (PARTITION BY subject ORDER BY time
                        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
           AS running_average
       FROM observations;
+----------+---------+------+---------------+-----------------+
| time     | subject | val  | running_total | running_average |
+----------+---------+------+---------------+-----------------+
| 07:00:00 | st113   |   10 |            10 |          9.5000 |
| 07:15:00 | st113   |    9 |            19 |         14.6667 |
| 07:30:00 | st113   |   25 |            44 |         18.0000 |
| 07:45:00 | st113   |   20 |            64 |         22.5000 |
| 07:00:00 | xh458   |    0 |             0 |          5.0000 |
| 07:15:00 | xh458   |   10 |            10 |          5.0000 |
| 07:30:00 | xh458   |    5 |            15 |         15.0000 |
| 07:45:00 | xh458   |   30 |            45 |         20.0000 |
| 08:00:00 | xh458   |   25 |            70 |         27.5000 |
+----------+---------+------+---------------+-----------------+

```
For the `running_average` column, there is no frame row preceding the first one or following the last. In these cases, `AVG()` computes the average of the rows that are available.
Aggregate functions used as window functions operate on rows in the current row frame, as do these nonaggregate window functions:

```plain
FIRST_VALUE()
LAST_VALUE()
NTH_VALUE()

```
Standard SQL specifies that window functions that operate on the entire partition should have no frame clause. MySQL permits a frame clause for such functions but ignores it. These functions use the entire partition even if a frame is specified:
```plain
CUME_DIST()
DENSE_RANK()
LAG()
LEAD()
NTILE()
PERCENT_RANK()
RANK()
ROW_NUMBER()

```
The frame clause, if given, has this syntax:
```plain
frame_clause:
    frame_units frame_extent

frame_units:
    {ROWS | RANGE}

```
In the absence of a frame clause, the default frame depends on whether an `ORDER BY` clause is present, as described later in this section.
The `frame_units` value indicates the type of relationship between the current row and frame rows:

* `ROWS`: The frame is defined by beginning and ending row positions. Offsets are differences in row numbers from the current row number.
* `RANGE`: The frame is defined by rows within a value range. Offsets are differences in row values from the current row value.
The `frame_extent` value indicates the start and end points of the frame. You can specify just the start of the frame (in which case the current row is implicitly the end) or use `BETWEEN` to specify both frame endpoints:

```plain
frame_extent:
    {frame_start | frame_between}

frame_between:
    BETWEEN frame_start AND frame_end

frame_start, frame_end: {
    CURRENT ROW
  | UNBOUNDED PRECEDING
  | UNBOUNDED FOLLOWING
  | expr PRECEDING
  | expr FOLLOWING
}

```
With `BETWEEN` syntax, `frame_start` must not occur later than `frame_end`.
The permitted `frame_start` and `frame_end` values have these meanings:

* `CURRENT ROW`: For `ROWS`, the bound is the current row. For `RANGE`, the bound is the peers of the current row.
* `UNBOUNDED PRECEDING`: The bound is the first partition row.
* `UNBOUNDED FOLLOWING`: The bound is the last partition row.
`expr``PRECEDING`: For `ROWS`, the bound is `expr` rows before the current row. For `RANGE`, the bound is the rows with values equal to the current row value minus `expr`; if the current row value is `NULL`, the bound is the peers of the row.

For `expr``PRECEDING` (and `expr``FOLLOWING`), `expr` can be a `?` parameter marker (for use in a prepared statement), a nonnegative numeric literal, or a temporal interval of the form `INTERVAL``val` `unit`. For `INTERVAL` expressions, `val` specifies nonnegative interval value, and `unit` is a keyword indicating the units in which the value should be interpreted. (For details about the permitted `units` specifiers, see the description of the `DATE_ADD()` function in [Section 12.7, “Date and Time Functions”](https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html).)

`RANGE` on a numeric or temporal `expr` requires `ORDER BY` on a numeric or temporal expression, respectively.

Examples of valid `expr``PRECEDING` and `expr``FOLLOWING` indicators:

```plain
10 PRECEDING
INTERVAL 5 DAY PRECEDING
5 FOLLOWING
INTERVAL '2:30' MINUTE_SECOND FOLLOWING

```
`expr``FOLLOWING`: For `ROWS`, the bound is `expr` rows after the current row. For `RANGE`, the bound is the rows with values equal to the current row value plus `expr`; if the current row value is `NULL`, the bound is the peers of the row.
* For permitted values of `expr`, see the description of `expr``PRECEDING`.
The following query demonstrates `FIRST_VALUE()`, `LAST_VALUE()`, and two instances of `NTH_VALUE()`:

```plain
mysql> SELECT
         time, subject, val,
         FIRST_VALUE(val)  OVER w AS 'first',
         LAST_VALUE(val)   OVER w AS 'last',
         NTH_VALUE(val, 2) OVER w AS 'second',
         NTH_VALUE(val, 4) OVER w AS 'fourth'
       FROM observations
       WINDOW w AS (PARTITION BY subject ORDER BY time
                    ROWS UNBOUNDED PRECEDING);
+----------+---------+------+-------+------+--------+--------+
| time     | subject | val  | first | last | second | fourth |
+----------+---------+------+-------+------+--------+--------+
| 07:00:00 | st113   |   10 |    10 |   10 |   NULL |   NULL |
| 07:15:00 | st113   |    9 |    10 |    9 |      9 |   NULL |
| 07:30:00 | st113   |   25 |    10 |   25 |      9 |   NULL |
| 07:45:00 | st113   |   20 |    10 |   20 |      9 |     20 |
| 07:00:00 | xh458   |    0 |     0 |    0 |   NULL |   NULL |
| 07:15:00 | xh458   |   10 |     0 |   10 |     10 |   NULL |
| 07:30:00 | xh458   |    5 |     0 |    5 |     10 |   NULL |
| 07:45:00 | xh458   |   30 |     0 |   30 |     10 |     30 |
| 08:00:00 | xh458   |   25 |     0 |   25 |     10 |     30 |
+----------+---------+------+-------+------+--------+--------+

```
Each function uses the rows in the current frame, which, per the window definition shown, extends from the first partition row to the current row. For the `NTH_VALUE()` calls, the current frame does not always include the requested row; in such cases, the return value is `NULL`.
In the absence of a frame clause, the default frame depends on whether an `ORDER BY` clause is present:

With `ORDER BY`: The default frame includes rows from the partition start through the current row, including all peers of the current row (rows equal to the current row according to the `ORDER BY` clause). The default is equivalent to this frame specification:

```plain
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

```
Without `ORDER BY`: The default frame includes all partition rows (because, without `ORDER BY`, all partition rows are peers). The default is equivalent to this frame specification:
```plain
RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

```
Because the default frame differs depending on presence or absence of `ORDER BY`, adding `ORDER BY` to a query to get deterministic results may change the results. (For example, the values produced by `SUM()` might change.) To obtain the same results but ordered per `ORDER BY`, provide an explicit frame specification to be used regardless of whether `ORDER BY` is present.
The meaning of a frame specification can be nonobvious when the current row value is `NULL`. Assuming that to be the case, these examples illustrate how various frame specifications apply:

`ORDER BY X ASC RANGE BETWEEN 10 FOLLOWING AND 15 FOLLOWING`

* The frame starts at `NULL` and stops at `NULL`, thus includes only rows with value `NULL`.
`ORDER BY X ASC RANGE BETWEEN 10 FOLLOWING AND UNBOUNDED FOLLOWING`

* The frame starts at `NULL` and stops at the end of the partition. Because an `ASC` sort puts `NULL` values first, the frame is the entire partition.
`ORDER BY X DESC RANGE BETWEEN 10 FOLLOWING AND UNBOUNDED FOLLOWING`

* The frame starts at `NULL` and stops at the end of the partition. Because a `DESC` sort puts `NULL` values last, the frame is only the `NULL` values.
`ORDER BY X ASC RANGE BETWEEN 10 PRECEDING AND UNBOUNDED FOLLOWING`

* The frame starts at `NULL` and stops at the end of the partition. Because an `ASC` sort puts `NULL` values first, the frame is the entire partition.
`ORDER BY X ASC RANGE BETWEEN 10 PRECEDING AND 10 FOLLOWING`

* The frame starts at `NULL` and stops at `NULL`, thus includes only rows with value `NULL`.
`ORDER BY X ASC RANGE BETWEEN 10 PRECEDING AND 1 PRECEDING`

* The frame starts at `NULL` and stops at `NULL`, thus includes only rows with value `NULL`.
`ORDER BY X ASC RANGE BETWEEN UNBOUNDED PRECEDING AND 10 FOLLOWING`

* The frame starts at the beginning of the partition and stops at rows with value `NULL`. Because an `ASC` sort puts `NULL` values first, the frame is only the `NULL` values.
* 

 




### Window Function Descriptions

|Name|Description|
|:----|:----|
|[CUME_DIST()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_cume-dist)|Cumulative distribution value|
|[DENSE_RANK()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_dense-rank)|Rank of current row within its partition, without gaps|
|[FIRST_VALUE()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_first-value)|Value of argument from first row of window frame|
|[LAG()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_lag)|Value of argument from row lagging current row within partition|
|[LAST_VALUE()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_last-value)|Value of argument from last row of window frame|
|[LEAD()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_lead)|Value of argument from row leading current row within partition|
|[NTH_VALUE()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_nth-value)|Value of argument from N-th row of window frame|
|[NTILE()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_ntile)|Bucket number of current row within its partition.|
|[PERCENT_RANK()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_percent-rank)|Percentage rank value|
|[RANK()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_rank)|Rank of current row within its partition, with gaps|
|[ROW_NUMBER()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_row-number)|Number of current row within its partition|

This section describes nonaggregate window functions that, for each row from a query, perform a calculation using rows related to that row. Most aggregate functions also can be used as window functions; see [Section 12.20.1, “Aggregate Function Descriptions”](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html).

For window function usage information and examples, and definitions of terms such as the `OVER` clause, window, partition, frame, and peer, see [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html).

**Table 12.26 Window Functions**

|Name|Description|
|:----|:----|
|[CUME_DIST()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_cume-dist)|Cumulative distribution value|
|[DENSE_RANK()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_dense-rank)|Rank of current row within its partition, without gaps|
|[FIRST_VALUE()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_first-value)|Value of argument from first row of window frame|
|[LAG()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_lag)|Value of argument from row lagging current row within partition|
|[LAST_VALUE()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_last-value)|Value of argument from last row of window frame|
|[LEAD()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_lead)|Value of argument from row leading current row within partition|
|[NTH_VALUE()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_nth-value)|Value of argument from N-th row of window frame|
|[NTILE()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_ntile)|Bucket number of current row within its partition.|
|[PERCENT_RANK()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_percent-rank)|Percentage rank value|
|[RANK()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_rank)|Rank of current row within its partition, with gaps|
|[ROW_NUMBER()](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html#function_row-number)|Number of current row within its partition|


In the following function descriptions, `over_clause` represents the `OVER` clause, described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html). Some window functions permit a `null_treatment` clause that specifies how to handle `NULL` values when calculating results. This clause is optional. It is part of the SQL standard, but the MySQL implementation permits only `RESPECT NULLS` (which is also the default). This means that `NULL` values are considered when calculating results. `IGNORE NULLS` is parsed, but produces an error.

`CUME_DIST()` `over_clause`

Returns the cumulative distribution of a value within a group of values; that is, the percentage of partition values less than or equal to the value in the current row. This represents the number of rows preceding or peer with the current row in the window ordering of the window partition divided by the total number of rows in the window partition. Return values range from 0 to 1.

This function should be used with `ORDER BY` to sort partition rows into the desired order. Without `ORDER BY`, all rows are peers and have value `N`/`N` = 1, where `N` is the partition size.

`over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html).

The following query shows, for the set of values in the `val` column, the `CUME_DIST()` value for each row, as well as the percentage rank value returned by the similar `PERCENT_RANK()` function. For reference, the query also displays row numbers using `ROW_NUMBER()`:

```plain
mysql> SELECT
         val,
         ROW_NUMBER()   OVER w AS 'row_number',
         CUME_DIST()    OVER w AS 'cume_dist',
         PERCENT_RANK() OVER w AS 'percent_rank'
       FROM numbers
       WINDOW w AS (ORDER BY val);
+------+------------+--------------------+--------------+
| val  | row_number | cume_dist          | percent_rank |
+------+------------+--------------------+--------------+
|    1 |          1 | 0.2222222222222222 |            0 |
|    1 |          2 | 0.2222222222222222 |            0 |
|    2 |          3 | 0.3333333333333333 |         0.25 |
|    3 |          4 | 0.6666666666666666 |        0.375 |
|    3 |          5 | 0.6666666666666666 |        0.375 |
|    3 |          6 | 0.6666666666666666 |        0.375 |
|    4 |          7 | 0.8888888888888888 |         0.75 |
|    4 |          8 | 0.8888888888888888 |         0.75 |
|    5 |          9 |                  1 |            1 |
+------+------------+--------------------+--------------+

```
`DENSE_RANK()` `over_clause`
Returns the rank of the current row within its partition, without gaps. Peers are considered ties and receive the same rank. This function assigns consecutive ranks to peer groups; the result is that groups of size greater than one do not produce noncontiguous rank numbers. For an example, see the `RANK()` function description.

This function should be used with `ORDER BY` to sort partition rows into the desired order. Without `ORDER BY`, all rows are peers.

* `over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html).
`FIRST_VALUE(``expr``)` [`null_treatment`] `over_clause`

Returns the value of `expr` from the first row of the window frame.

`over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html). `null_treatment` is as described in the section introduction.

The following query demonstrates `FIRST_VALUE()`, `LAST_VALUE()`, and two instances of `NTH_VALUE()`:

```plain
mysql> SELECT
         time, subject, val,
         FIRST_VALUE(val)  OVER w AS 'first',
         LAST_VALUE(val)   OVER w AS 'last',
         NTH_VALUE(val, 2) OVER w AS 'second',
         NTH_VALUE(val, 4) OVER w AS 'fourth'
       FROM observations
       WINDOW w AS (PARTITION BY subject ORDER BY time
                    ROWS UNBOUNDED PRECEDING);
+----------+---------+------+-------+------+--------+--------+
| time     | subject | val  | first | last | second | fourth |
+----------+---------+------+-------+------+--------+--------+
| 07:00:00 | st113   |   10 |    10 |   10 |   NULL |   NULL |
| 07:15:00 | st113   |    9 |    10 |    9 |      9 |   NULL |
| 07:30:00 | st113   |   25 |    10 |   25 |      9 |   NULL |
| 07:45:00 | st113   |   20 |    10 |   20 |      9 |     20 |
| 07:00:00 | xh458   |    0 |     0 |    0 |   NULL |   NULL |
| 07:15:00 | xh458   |   10 |     0 |   10 |     10 |   NULL |
| 07:30:00 | xh458   |    5 |     0 |    5 |     10 |   NULL |
| 07:45:00 | xh458   |   30 |     0 |   30 |     10 |     30 |
| 08:00:00 | xh458   |   25 |     0 |   25 |     10 |     30 |
+----------+---------+------+-------+------+--------+--------+

```
* Each function uses the rows in the current frame, which, per the window definition shown, extends from the first partition row to the current row. For the `NTH_VALUE()` calls, the current frame does not always include the requested row; in such cases, the return value is `NULL`.
`LAG(``expr``[,``N``[,``default``]])` [`null_treatment`] `over_clause`

Returns the value of `expr` from the row that lags (precedes) the current row by `N` rows within its partition. If there is no such row, the return value is `default`. For example, if `N` is 3, the return value is `default` for the first two rows. If `N` or `default` are missing, the defaults are 1 and `NULL`, respectively.

`N` must be a literal nonnegative integer. If `N` is 0, `expr` is evaluated for the current row.

Beginning with MySQL 8.0.22, `N` cannot be `NULL`. In addition, it must now be an integer in the range `1` to `263`, inclusive, in any of the following forms:

    * an unsigned integer constant literal
    * a positional parameter marker (`?`)
    * a user-defined variable
    * a local variable in a stored routine
`over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html). `null_treatment` is as described in the section introduction.

`LAG()` (and the similar `LEAD()` function) are often used to compute differences between rows. The following query shows a set of time-ordered observations and, for each one, the `LAG()` and `LEAD()` values from the adjoining rows, as well as the differences between the current and adjoining rows:

```plain
mysql> SELECT
         t, val,
         LAG(val)        OVER w AS 'lag',
         LEAD(val)       OVER w AS 'lead',
         val - LAG(val)  OVER w AS 'lag diff',
         val - LEAD(val) OVER w AS 'lead diff'
       FROM series
       WINDOW w AS (ORDER BY t);
+----------+------+------+------+----------+-----------+
| t        | val  | lag  | lead | lag diff | lead diff |
+----------+------+------+------+----------+-----------+
| 12:00:00 |  100 | NULL |  125 |     NULL |       -25 |
| 13:00:00 |  125 |  100 |  132 |       25 |        -7 |
| 14:00:00 |  132 |  125 |  145 |        7 |       -13 |
| 15:00:00 |  145 |  132 |  140 |       13 |         5 |
| 16:00:00 |  140 |  145 |  150 |       -5 |       -10 |
| 17:00:00 |  150 |  140 |  200 |       10 |       -50 |
| 18:00:00 |  200 |  150 | NULL |       50 |      NULL |
+----------+------+------+------+----------+-----------+

```
In the example, the `LAG()` and `LEAD()` calls use the default `N` and `default` values of 1 and `NULL`, respectively.
The first row shows what happens when there is no previous row for `LAG()`: The function returns the `default` value (in this case, `NULL`). The last row shows the same thing when there is no next row for `LEAD()`.

`LAG()` and `LEAD()` also serve to compute sums rather than differences. Consider this data set, which contains the first few numbers of the Fibonacci series:

```plain
mysql> SELECT n FROM fib ORDER BY n;
+------+
| n    |
+------+
|    1 |
|    1 |
|    2 |
|    3 |
|    5 |
|    8 |
+------+

```
The following query shows the `LAG()` and `LEAD()` values for the rows adjacent to the current row. It also uses those functions to add to the current row value the values from the preceding and following rows. The effect is to generate the next number in the Fibonacci series, and the next number after that:
```plain
mysql> SELECT
         n,
         LAG(n, 1, 0)      OVER w AS 'lag',
         LEAD(n, 1, 0)     OVER w AS 'lead',
         n + LAG(n, 1, 0)  OVER w AS 'next_n',
         n + LEAD(n, 1, 0) OVER w AS 'next_next_n'
       FROM fib
       WINDOW w AS (ORDER BY n);
+------+------+------+--------+-------------+
| n    | lag  | lead | next_n | next_next_n |
+------+------+------+--------+-------------+
|    1 |    0 |    1 |      1 |           2 |
|    1 |    1 |    2 |      2 |           3 |
|    2 |    1 |    3 |      3 |           5 |
|    3 |    2 |    5 |      5 |           8 |
|    5 |    3 |    8 |      8 |          13 |
|    8 |    5 |    0 |     13 |           8 |
+------+------+------+--------+-------------+

```
One way to generate the initial set of Fibonacci numbers is to use a recursive common table expression. For an example, see [Fibonacci Series Generation](https://dev.mysql.com/doc/refman/8.0/en/with.html#common-table-expressions-recursive-fibonacci-series).
* Beginning with MySQL 8.0.22, you cannot use a negative value for the rows argument of this function.
`LAST_VALUE(``expr``)` [`null_treatment`] `over_clause`

Returns the value of `expr` from the last row of the window frame.

`over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html). `null_treatment` is as described in the section introduction.

* For an example, see the `FIRST_VALUE()` function description.
`LEAD(``expr``[,``N``[,``default``]])` [`null_treatment`] `over_clause`

Returns the value of `expr` from the row that leads (follows) the current row by `N` rows within its partition. If there is no such row, the return value is `default`. For example, if `N` is 3, the return value is `default` for the last two rows. If `N` or `default` are missing, the defaults are 1 and `NULL`, respectively.

`N` must be a literal nonnegative integer. If `N` is 0, `expr` is evaluated for the current row.

Beginning with MySQL 8.0.22, `N` cannot be `NULL`. In addition, it must now be an integer in the range `1` to `263`, inclusive, in any of the following forms:

    * an unsigned integer constant literal
    * a positional parameter marker (`?`)
    * a user-defined variable
    * a local variable in a stored routine
`over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html). `null_treatment` is as described in the section introduction.

For an example, see the `LAG()` function description.

* In MySQL 8.0.22 and later, use of a negative value for the rows argument of this function is not permitted.
`NTH_VALUE(``expr``,``N``)` [`from_first_last`] [`null_treatment`] `over_clause`

Returns the value of `expr` from the `N`-th row of the window frame. If there is no such row, the return value is `NULL`.

`N` must be a literal positive integer.

`from_first_last` is part of the SQL standard, but the MySQL implementation permits only `FROM FIRST` (which is also the default). This means that calculations begin at the first row of the window. `FROM LAST` is parsed, but produces an error. To obtain the same effect as `FROM LAST` (begin calculations at the last row of the window), use `ORDER BY` to sort in reverse order.

`over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html). `null_treatment` is as described in the section introduction.

For an example, see the `FIRST_VALUE()` function description.

* In MySQL 8.0.22 and later, you cannot use `NULL` for the row argument of this function.
`NTILE(``N``)` `over_clause`

Divides a partition into `N` groups (buckets), assigns each row in the partition its bucket number, and returns the bucket number of the current row within its partition. For example, if `N` is 4, `NTILE()` divides rows into four buckets. If `N` is 100, `NTILE()` divides rows into 100 buckets.

`N` must be a literal positive integer. Bucket number return values range from 1 to `N`.

Beginning with MySQL 8.0.22, `N` cannot be `NULL`. In addition, it must be an integer in the range `1` to `263`, inclusive, in any of the following forms:

    * an unsigned integer constant literal
    * a positional parameter marker (`?`)
    * a user-defined variable
    * a local variable in a stored routine
This function should be used with `ORDER BY` to sort partition rows into the desired order.

`over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html).

The following query shows, for the set of values in the `val` column, the percentile values resulting from dividing the rows into two or four groups. For reference, the query also displays row numbers using `ROW_NUMBER()`:

```plain
mysql> SELECT
         val,
         ROW_NUMBER() OVER w AS 'row_number',
         NTILE(2)     OVER w AS 'ntile2',
         NTILE(4)     OVER w AS 'ntile4'
       FROM numbers
       WINDOW w AS (ORDER BY val);
+------+------------+--------+--------+
| val  | row_number | ntile2 | ntile4 |
+------+------------+--------+--------+
|    1 |          1 |      1 |      1 |
|    1 |          2 |      1 |      1 |
|    2 |          3 |      1 |      1 |
|    3 |          4 |      1 |      2 |
|    3 |          5 |      1 |      2 |
|    3 |          6 |      2 |      3 |
|    4 |          7 |      2 |      3 |
|    4 |          8 |      2 |      4 |
|    5 |          9 |      2 |      4 |
+------+------------+--------+--------+

```
* Beginning with MySQL 8.0.22, the construct `NTILE(NULL)` is no longer permitted.
`PERCENT_RANK()` `over_clause`

Returns the percentage of partition values less than the value in the current row, excluding the highest value. Return values range from 0 to 1 and represent the row relative rank, calculated as the result of this formula, where `rank` is the row rank and `rows` is the number of partition rows:

```plain
(rank - 1) / (rows - 1)

```
This function should be used with `ORDER BY` to sort partition rows into the desired order. Without `ORDER BY`, all rows are peers.
`over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html).

* For an example, see the `CUME_DIST()` function description.
`RANK()` `over_clause`

Returns the rank of the current row within its partition, with gaps. Peers are considered ties and receive the same rank. This function does not assign consecutive ranks to peer groups if groups of size greater than one exist; the result is noncontiguous rank numbers.

This function should be used with `ORDER BY` to sort partition rows into the desired order. Without `ORDER BY`, all rows are peers.

`over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html).

The following query shows the difference between `RANK()`, which produces ranks with gaps, and `DENSE_RANK()`, which produces ranks without gaps. The query shows rank values for each member of a set of values in the `val` column, which contains some duplicates. `RANK()` assigns peers (the duplicates) the same rank value, and the next greater value has a rank higher by the number of peers minus one. `DENSE_RANK()` also assigns peers the same rank value, but the next higher value has a rank one greater. For reference, the query also displays row numbers using `ROW_NUMBER()`:

```plain
mysql> SELECT
         val,
         ROW_NUMBER() OVER w AS 'row_number',
         RANK()       OVER w AS 'rank',
         DENSE_RANK() OVER w AS 'dense_rank'
       FROM numbers
       WINDOW w AS (ORDER BY val);
+------+------------+------+------------+
| val  | row_number | rank | dense_rank |
+------+------------+------+------------+
|    1 |          1 |    1 |          1 |
|    1 |          2 |    1 |          1 |
|    2 |          3 |    3 |          2 |
|    3 |          4 |    4 |          3 |
|    3 |          5 |    4 |          3 |
|    3 |          6 |    4 |          3 |
|    4 |          7 |    7 |          4 |
|    4 |          8 |    7 |          4 |
|    5 |          9 |    9 |          5 |
+------+------------+------+------------+

```
`ROW_NUMBER()` `over_clause`
Returns the number of the current row within its partition. Rows numbers range from 1 to the number of partition rows.

`ORDER BY` affects the order in which rows are numbered. Without `ORDER BY`, row numbering is nondeterministic.

`ROW_NUMBER()` assigns peers different row numbers. To assign peers the same value, use `RANK()` or `DENSE_RANK()`. For an example, see the `RANK()` function description.

* `over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html).


### *over_clause*

    OVER (window_spec) | OVER window_name

<https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html>

### `RANK()` `over_clause`

Returns the rank of the current row within its partition, with gaps. Peers are considered ties and receive the same rank. This function does not assign consecutive ranks to peer groups if groups of size greater than one exist; the result is noncontiguous rank numbers.

This function should be used with `ORDER BY` to sort partition rows into the desired order. Without `ORDER BY`, all rows are peers.

`over_clause` is as described in [Section 12.21.2, “Window Function Concepts and Syntax”](https://dev.mysql.com/doc/refman/8.0/en/window-functions-usage.html).

The following query shows the difference between `RANK()`, which produces ranks with gaps, and `DENSE_RANK()`, which produces ranks without gaps. The query shows rank values for each member of a set of values in the `val` column, which contains some duplicates. `RANK()` assigns peers (the duplicates) the same rank value, and the next greater value has a rank higher by the number of peers minus one. `DENSE_RANK()` also assigns peers the same rank value, but the next higher value has a rank one greater. For reference, the query also displays row numbers using `ROW_NUMBER()`: 

```sql
SELECT
   val,
   ROW_NUMBER() OVER w AS 'row_number',
   RANK()       OVER w AS 'rank',
   DENSE_RANK() OVER w AS 'dense_rank'
 FROM numbers
 WINDOW w AS (ORDER BY val);
+------+------------+------+------------+
| val  | row_number | rank | dense_rank |
+------+------------+------+------------+
|    1 |          1 |    1 |          1 |
|    1 |          2 |    1 |          1 |
|    2 |          3 |    3 |          2 |
|    3 |          4 |    4 |          3 |
|    3 |          5 |    4 |          3 |
|    3 |          6 |    4 |          3 |
|    4 |          7 |    7 |          4 |
|    4 |          8 |    7 |          4 |
|    5 |          9 |    9 |          5 |
+------+------------+------+------------+
```


### `ROW_NUMBER()` `over_clause`

Returns the number of the current row within its partition. Rows numbers range from 1 to the number of partition rows.

`ORDER BY` affects the order in which rows are numbered. Without `ORDER BY`, row numbering is nondeterministic.

`ROW_NUMBER()` assigns peers different row numbers. To assign peers the same value, use `RANK()` or `DENSE_RANK()`. For an example, see the `RANK()` function description. 

### 开窗函数

开窗函数是在满足某种条件的记录集合上执行的特殊函数。对于每条记录都要在此窗口内执行函数，有的函数随着记录不同，窗口大小都是固定的，这种属于静态窗口；有的函数则相反，不同的记录对应着不同的窗口，这种动态变化的窗口叫滑动窗口。开窗函数的本质还是聚合运算，只不过它更具灵活性，它对数据的每一行，都使用与该行相关的行进行计算并返回计算结果。

语法开窗函数的一个概念是当前行，当前行属于某个窗口，窗口由over关键字来指定函数执行的窗口范围，如果后面括号中什么都不写，则意味着窗口包含满足where条件的所有行，开窗函数基于所有行进行计算；如果不为空，则有三个参数来设置窗口：

partition by子句：按照指定字段进行分区，两个分区由边界分隔，开窗函数在不同的分区内分别执行，在跨越分区边界时重新初始化。

order by子句：按照指定字段进行排序，开窗函数将按照排序后的记录顺序进行编号。可以和

partition by子句配合使用，也可以单独使用。

frame子句：当前分区的一个子集，用来定义子集的规则，通常用来作为滑动窗口使用。

对于滑动窗口的范围指定，通常使用 between frame_start and frame_end 语法来表示行范围，frame_start和frame_end可以支持如下关键字，来确定不同的动态行记录：

比如，下面都是合法的范围：

开窗函数名([<字段名>]) over([partition by <分组字段>] [order by <排序字段> [desc]] [<

滑动窗口>])

current row 边界是当前行，一般和其他范围关键字一起使用

unbounded preceding 边界是分区中的第一行

unbounded following 边界是分区中的最后一行

expr preceding 边界是当前行减去 expr 的值

expr following 边界是当前行加上 expr 的值

rows between 1 preceding and 1 following 窗口范围是当前行、前一行、后一行一共三行记录。

rows unbounded preceding 窗口范围是分区中的第一行到当前行。

rows between unbounded preceding and unbounded following 窗口范围是当前分区中所有行，

等同于不写。

开窗函数和普通聚合函数的区别：

聚合函数是将多条记录聚合为一条；而开窗函数是每条记录都会执行，有几条记录执行完还是几

条。

聚合函数也可以用于开窗函数中。

### 序号函数

row_number()

显示分区中不重复不间断的序号

dense_rank()

显示分区中重复不间断的序号

rank()

显示分区中重复间断的序号

