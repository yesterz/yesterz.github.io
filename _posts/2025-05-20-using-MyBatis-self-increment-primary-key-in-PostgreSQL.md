## PostgreSQL 使用 MyBatis 自增主键

在 PostgreSQL 中使用 MyBatis 实现自增主键，可以通过创建序列并在插入数据时调用该序列来实现。

## 创建自增序列

首先，创建一个自增序列：

```sql
CREATE SEQUENCE user_id_seq START 1;
```

然后，在表定义中设置字段的默认值为该序列的下一个值：

```sql
CREATE TABLE "public"."user" (
    "id" int4 NOT NULL DEFAULT nextval('user_id_seq'),
    "name" varchar(50) COLLATE "pg_catalog"."default",
    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);
```

## 在 MyBatis 中使用自增主键

在 MyBatis 的 XML 配置文件中，可以通过 *\<selectKey>* 元素来获取插入后的自增主键值。

```xml
<insert id="addUser" parameterType="com.congge.entity.TUser">
INSERT INTO user (name)
VALUES (#{name})
<selectKey keyProperty="id" resultType="java.lang.Integer" order="AFTER">
SELECT nextval('user_id_seq') as id
</selectKey>
</insert>
```

这样，在插入数据后，MyBatis 会自动获取并设置自增主键的值。

## 注意事项

**序列冲突**：在数据迁移时，可能会遇到主键冲突的问题。可以通过调整序列的起始值来避免这种情况。

**批量插入**：对于批量插入操作，可以在 XML 配置文件中使用 *\<foreach>* 元素来实现。