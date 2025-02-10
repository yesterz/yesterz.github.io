---
title: 事务和事务的隔离级别
date: 2024-01-18 08:44:00 +0800
author: CAFEBABY
categories: [Database]
tags: [Database]
pin: false
math: true
mermaid: false
media_subpath: /assets/images/
---

1.4.事务和事务的隔离级别

## 1. 为什么需要事务

事务（Transaction）是数据库管理系统（DBMS）执行过程中的一个逻辑单位（Unit，不可再进行分割），由一个有限的数据库操作序列构成（多个DML语句，select语句不包含事务），**要不全部成功，要不全部不成功。**

A 给 B 要划钱，A 的账户-1000元， B 的账户就要+1000元，这两个update 语句必须作为一个整体来执行，不然A 扣钱了，B 没有加钱这种情况就是错误的。那么事务就可以保证A 、B 账户的变动要么全部一起发生，要么全部一起不发生。

## 2. 事务特性

事务应该具有 4 个属性：原子性、一致性、隔离性、持久性。这四个属性通常称为 ACID 特性。

原子性（atomicity）、一致性（consistency）、隔离性（isolation）、持久性（durability）

### 2.1 原子性（atomicity）

一个事务必须被视为一个不可分割的最小单元，整个事务中的所有操作要么全部提交成功，要么全部失败，对于一个事务来说，不能只执行其中的一部分操作。比如：

A 借给 B 1000 元：

1. A 工资卡扣除 1000 元；
2. B 工资卡增加 1000 元。

整个事务的操作要么全部成功，要么全部失败，不能出现 A 工资卡扣除，但是 B 工资卡不增加的情况。如果原子性不能保证，就会很自然的出现一致性问题。

### 2.2 一致性（consistency）

数据库总是从一个一致性状态转换到下一个一致性状态。

事务将数据库从一种一致性转换到另外一种一致性状态，在事务开始之前和事务结束之后数据库中数据的完整性没有被破坏。

A 借给 B 1000 元：

1. A 工资卡扣除 1000 元；
2. B 工资卡增加 1000 元。

扣除的钱（-500） 与增加的钱（500） 相加应该为 0，或者说 A 和 B 的账户的钱加起来，前后应该不变。

### 2.3 持久性（durability）

一旦事务提交，则其所做的修改就会永久保存到数据库中。此时即使系统崩溃，已经提交的修改数据也不会丢失。

当发生系统崩溃或机器宕机，只要数据库能够重新启动，那么一定能够将其恢复到事务成功结束时的状态。

### 2.4 隔离性（isolation）

在并发环境中，并发的事务是相互隔离的，一个事务的执行不能被其他事务干扰。即一个事务内部的操作及使用的数据对并发的其他事务是隔离的，并发执行的各个事务之间不能互相干扰。不同的事务并发操纵相同的数据时，每个事务都有各自完整的数据空间。

如果隔离性不能保证，会导致什么问题？

A 借给 B 生活费，借了两次，每次都是 1000，A 的卡里开始有 10000，B 的卡里开始有 500，从理论上，借完后，A 的卡里有 8000，B 的卡里应该有 2500。

我们将 A 向 B 同时进行的两次转账操作分别称为 T1 和 T2 ，在现实世界中 T1 和 T2 是应该没有关系的，可以先执行完 T1，再执行 T2，或者先执行完 T2，再执行 T1，结果都是一样的。但是很不幸，真实的数据库中 T1 和 T2 的操作可能交替执行的，执行顺序就有可能是：

![image.png](./TransactionsAndIsolationLevels/db81c54724b54e749ec5dd801f29e91b.png)

如果按照上图中的执行顺序来进行两次转账的话，最终我们看到，A 的账户里还剩 9000 元钱，相当于只扣了 1000 元钱，但是 B 的账户里却成了 2500 元钱，多了 1000 元，这银行岂不是要亏死了？

所以对于现实世界中状态转换对应的某些数据库操作来说，不仅**要保证这些操作以原子性的方式执行完成，而且要保证其它的状态转换不会影响到本次状态转换**，这个规则被称之为隔离性。

## 3. 事务并发引发的问题

我们知道 MySQL 是一个客户端／服务器架构（C/S）的软件，对于同一个服务器来说，可以有若干个客户端与之连接，每个客户端与服务器连接上之后，就可以称之为一个会话（Session）。每个客户端都可以在自己的会话中向服务器发出请求语句，一个请求语句可能是某个事务的一部分，也就是对于服务器来说可能同时处理多个事务。

在上面我们说过事务有一个称之为隔离性的特性，理论上在某个事务对某个数据进行访问时，其他事务应该进行排队，当该事务提交之后，其他事务才可以继续访问这个数据，这样的话并发事务的执行就变成了串行化执行。

但是对串行化执行性能影响太大，我们既想保持事务的一定的隔离性，又想让服务器在处理访问同一数据的多个事务时性能尽量高些，当我们舍弃隔离性的时候，可能会带来什么样的数据问题呢？

### 3.1 脏读

当一个事务读取到了另外一个事务修改但未提交的数据，被称为脏读。

![image.png](./TransactionsAndIsolationLevels/05e67865973a410e93190c52a74be697.png)

1、在事务A执⾏过程中，事务A对数据资源进⾏了修改，事务B读取了事务A修改后的数据。
2、由于某些原因，事务A并没有完成提交，发⽣了RollBack操作，则事务B读取的数据就是脏数据。
这种读取到另⼀个事务未提交的数据的现象就是脏读(Dirty Read)。

### 3.2 不可重复读

当事务内相同的记录被检索两次，且两次得到的结果不同时，此现象称为不可重复读。

![image.png](./TransactionsAndIsolationLevels/3895ad68683747e88b114bba40f48ad9.png)

事务B读取了两次数据资源，在这两次读取的过程中事务A修改了数据，导致事务B在这两次读取出来的
数据不⼀致。

### 3.3 幻读

在事务执行过程中，另一个事务将新记录添加到正在读取的事务中时，会发生幻读。

![image.png](./TransactionsAndIsolationLevels/3a92feb9aa014a7eaaf784d1c7057822.png)

事务B前后两次读取同⼀个范围的数据，在事务B两次读取的过程中事务A新增了数据，导致事务B后⼀
次读取到前⼀次查询没有看到的⾏。

幻读和不可重复读有些类似，但是幻读重点强调了读取到了之前读取没有获取到的记录。

## 4. SQL 标准中的四种隔离级别

我们上边介绍了几种并发事务执行过程中可能遇到的一些问题，这些问题也有轻重缓急之分，我们给这些问题按照严重性来排一下序：

脏读 > 不可重复读 > 幻读

我们上边所说的舍弃一部分隔离性来换取一部分性能在这里就体现在：设立一些隔离级别，隔离级别越低，越严重的问题就越可能发生。有一帮人（并不是设计MySQL的大叔们）制定了一个所谓的SQL标准，在标准中设立了4个隔离级别：

**READ UNCOMMITTED：未提交读。**

**READ COMMITTED：已提交读。**

**REPEATABLE READ：可重复读。**

**SERIALIZABLE：可串行化。**

SQL标准中规定，针对不同的隔离级别，并发事务可以发生不同严重程度的问题，具体情况如下：

也就是说：

1. READ UNCOMMITTED 隔离级别下，可能发生脏读、不可重复读和幻读问题。
2. READ COMMITTED 隔离级别下，可能发生不可重复读和幻读问题，但是不可以发生脏读问题。
3. REPEATABLE READ 隔离级别下，可能发生幻读问题，但是不可以发生脏读和不可重复读的问题。
4. SERIALIZABLE 隔离级别下，各种问题都不可以发生。

| 隔离级别 | 脏读 | 不可重复读 | 幻读 | 描述 |
| --- | --- | --- | --- | --- |
| READ UNCOMMITTED | 可能发生 | 可能发生 | 可能发生 | 允许读取尚未提交的数据变更，<br>可能导致数据的不一致性。 |
| READ COMMITTED | 不可能发生 | 可能发生 | 可能发生 | 只允许读取并发事务已经提交的<br>数据，防止脏读。 |
| REPEATABLE READ | 不可能发生 | 不可能发生 | 可能发生 | 同一事务中多次读取同一数据时，<br>看到的是相同的数据版本，<br>避免脏读和不可重复读。 |
| SERIALIZABLE | 不可能发生 | 不可能发生 | 不可能发生 | 强制事务串行执行，避免脏读、<br>不可重复读和幻读，<br>但可能导致性能下降。 |

Oracle 中默认的事务隔离级别是提交读（read committed），对于 MySQL 的 Innodb 的默认事务隔离级别是重复读（repeated read）。

## 5. MySQL 中的隔离级别

不同的数据库厂商对 SQL 标准中规定的四种隔离级别支持不一样，比方说 Oracle 就只支持 READ COMMITTED 和 SERIALIZABLE 隔离级别。本书中所讨论的 MySQL 虽然支持4种隔离级别，但与 SQL 标准中所规定的各级隔离级别允许发生的问题却有些出入，MySQL 在 REPEATABLE READ 隔离级别下，是可以禁止幻读问题的发生的。

![image.png](./TransactionsAndIsolationLevels/1452d922eb0f4dda803126784436e8b2.png)

MySQL 的默认隔离级别为 REPEATABLE READ，我们可以手动修改事务的隔离级别。

* 如何设置事务的隔离级别

我们可以通过下边的语句修改事务的隔离级别：

```sql
SET [GLOBAL|SESSION] TRANSACTION ISOLATION LEVEL level;
```

其中的level可选值有4个：

```sql
level: {
    REPEATABLE READ
   | READ COMMITTED
   | READ UNCOMMITTED
   | SERIALIZABLE
}
```

设置事务的隔离级别的语句中，在SET关键字后可以放置GLOBAL关键字、SESSION关键字或者什么都不放，这样会对不同范围的事务产生不同的影响，具体如下：

**使用GLOBAL关键字（在全局范围影响）：**

比方说这样：

```sql
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

则： 只对执行完该语句之后产生的会话起作用。当前已经存在的会话无效。

**使用SESSION关键字（在会话范围影响）：**

比方说这样：

```sql
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

则：对当前会话的所有后续的事务有效；

该语句可以在已经开启的事务中间执行，但不会影响当前正在执行的事务。

如果在事务之间执行，则对后续的事务有效。

**上述两个关键字都不用（只对执行语句后的下一个事务产生影响）：**

比方说这样：

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

则：只对当前会话中下一个即将开启的事务有效。下一个事务执行完后，后续事务将恢复到之前的隔离级别。该语句不能在已经开启的事务中间执行，会报错的。

如果我们在服务器启动时想改变事务的默认隔离级别，可以修改启动参数transaction-isolation的值，比方说我们在启动服务器时指定了--transaction-isolation=SERIALIZABLE，那么事务的默认隔离级别就从原来的REPEATABLE READ变成了SERIALIZABLE。

想要查看当前会话默认的隔离级别可以通过查看系统变量 transaction_isolation 的值来确定：

```sql
SHOW VARIABLES LIKE 'transaction_isolation';
```

```terminal
mysql> SHOW VARIABLES LIKE 'transaction_isolation';
+-----------------------+-----------------+
| Variable_name         | Value           |
+-----------------------+-----------------+
| transaction_isolation | REPEATABLE-READ |
+-----------------------+-----------------+
1 row in set (0.29 sec)

mysql>
```

或者使用更简便的写法：

```sql
SELECT @@transaction_isolation;
```

```terminal
mysql> SELECT @@transaction_isolation;
+-------------------------+
| @@transaction_isolation |
+-------------------------+
| REPEATABLE-READ         |
+-------------------------+
1 row in set (0.00 sec)

mysql>
```

注意：transaction_isolation是在MySQL 5.7.20的版本中引入来替换tx_isolation的，如果你使用的是之前版本的MySQL，请将上述用到系统变量transaction_isolation的地方替换为tx_isolation。

## 6. MySQL 事务

### 6.1 事务基本语法

**事务开始**

1、begin

2、START TRANSACTION（推荐）

3、begin work

**事务回滚**

rollback

**事务提交**

commit

使用事务插入两行数据，commit后数据还在

![image.png](./TransactionsAndIsolationLevels/874c5a5d37c44347827edc01c7646d58.png)

使用事务插入两行数据，rollback后数据没有了

![image.png](./TransactionsAndIsolationLevels/80e27d57435b4034a20c3ea4566c7674.png)

### 6.2 保存点

如果你开启了一个事务，执行了很多语句，忽然发现某条语句有点问题，你只好使用ROLLBACK语句来让数据库状态恢复到事务执行之前的样子，然后一切从头再来，但是可能根据业务和数据的变化，不需要全部回滚。所以MySQL里提出了一个保存点（英文：savepoint）的概念，就是在事务对应的数据库语句中打几个点，我们在调用ROLLBACK语句时可以指定会滚到哪个点，而不是回到最初的原点。定义保存点的语法如下：

SAVEPOINT 保存点名称;

当我们想回滚到某个保存点时，可以使用下边这个语句（下边语句中的单词WORK和SAVEPOINT是可有可无的）：

```sql
ROLLBACK TO [SAVEPOINT] 保存点名称;
```

不过如果ROLLBACK语句后边不跟随保存点名称的话，会直接回滚到事务执行之前的状态。

如果我们想删除某个保存点，可以使用这个语句：

```sql
RELEASE SAVEPOINT 保存点名称;
```

![image.png](./TransactionsAndIsolationLevels/3dd600ff2c384d5f8e348c8bc33a6c76.png)

![image.png](./TransactionsAndIsolationLevels/2e56bef3f9954c3f943168d546ae662f.png)

![image.png](./TransactionsAndIsolationLevels/dbca0f38164045eda2543112de99d69b.png)

### 6.3 隐式提交

当我们使用START TRANSACTION或者BEGIN语句开启了一个事务，或者把系统变量autocommit的值设置为OFF时，事务就不会进行自动提交，但是如果我们输入了某些语句之后就会悄悄的提交掉，就像我们输入了COMMIT语句了一样，这种因为某些特殊的语句而导致事务提交的情况称为隐式提交，这些会导致事务隐式提交的语句包括：

#### 6.3.1 执行DDL

定义或修改数据库对象的数据定义语言（Datadefinition language，缩写为：DDL）。

所谓的数据库对象，指的就是数据库、表、视图、存储过程等等这些东西。当我们使用CREATE、ALTER、DROP等语句去修改这些所谓的数据库对象时，就会隐式的提交前边语句所属于的事务，就像这样：

```sql
BEGIN;

SELECT ... # 事务中的一条语句

UPDATE ... # 事务中的一条语句

... # 事务中的其它语句

CREATE TABLE ...
```

![image.png](./TransactionsAndIsolationLevels/34acaa6366574b638f74d96d65f76274.png)

![image.png](./TransactionsAndIsolationLevels/9a70501b6a0645f389deae88494426fa.png)

**此语句会隐式的提交前边语句所属于的事务**

#### 6.3.2 隐式使用或修改mysql数据库中的表

当我们使用ALTER USER、CREATE USER、DROP USER、GRANT、RENAME USER、REVOKE、SET PASSWORD等语句时也会隐式的提交前边语句所属于的事务。

#### 6.3.3 事务控制或关于锁定的语句

当我们在一个会话里，一个事务还没提交或者回滚时就又使用START TRANSACTION或者BEGIN语句开启了另一个事务时，会隐式的提交上一个事务，比如这样：

```sql
BEGIN;

SELECT ... # 事务中的一条语句

UPDATE ... # 事务中的一条语句

... # 事务中的其它语句

BEGIN; # 此语句会隐式的提交前边语句所属于的事务
```

![image.png](./TransactionsAndIsolationLevels/6aaf9a1f630c4210996782d1c6fa6a97.png)

![image.png](./TransactionsAndIsolationLevels/93a9ef0063704f31b47838b257fb6cf0.png)

或者当前的autocommit系统变量的值为OFF，我们手动把它调为ON时，也会隐式的提交前边语句所属的事务。

或者使用LOCK TABLES、UNLOCK TABLES等关于锁定的语句也会隐式的提交前边语句所属的事务。

#### 6.3.4 加载数据的语句

比如我们使用LOAD DATA语句来批量往数据库中导入数据时，也会隐式的提交前边语句所属的事务。

#### 6.3.5 关于MySQL复制的一些语句

使用START SLAVE、STOP SLAVE、RESET SLAVE、CHANGE MASTER TO等语句时也会隐式的提交前边语句所属的事务。

#### 6.3.6 其它的一些语句

使用ANALYZE TABLE、CACHE INDEX、CHECK TABLE、FLUSH、 LOAD INDEX INTO CACHE、OPTIMIZE TABLE、REPAIR TABLE、RESET等语句也会隐式的提交前边语句所属的事务。
