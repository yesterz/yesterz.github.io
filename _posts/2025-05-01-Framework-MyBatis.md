## XML映射文件详解

MyBatis 的真正强大在于它的映射语句，也是它的魔力所在。

由于它的异常强大，映射器的 XML 文件就显得相对简单。

在MyBatis开发中，涉及到主要开发要素是：Dao接口类，Mapper映射文件，以及PO类。



一个Mapper映射文件的例子

```xml
<?xml version="1.0" encoding="UTF8" ?>
<!DOCTYPE mapper
          PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
          "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.mb.dao.StudentMapper">
  
  <!-- 配置方式一：通过结果集映射的方式进行查询 -->
  <select id="getStudentList" resultMap="StudentTeacherMap">
    select s.id sid, s.name sname, t.name tname
    from student s, teacher t
    where s.tid = t.id;
  </select>
  
  <resultMap id="StudentTeacherMap" type="Student">
    <result property="id" column="sid"/>
    <result property="name" column="sname"/>
    <!-- association表示关联对象：javaType表示关联对象的java类型，
    因为关联对象只有一个，而不是集合，所以直接配置关联对象对应属性即可 -->
    <association property="teacher" javaType="Teacher">
      <!-- 因为结果集中没有teacher的id，所以这里就不用配置id了 -->
      <result property="name" column="tname"/>
    </association>
  </resultMap>
  
  <!-- 配置方式二：通过子查询的方式进行查询，这种方式的缺点是，因为每个查询都要单独配置，所以
  不能直接使用完整的SQL去调试 -->
  <select id="getStudentList2" resultMap="StudentTeacherMap2">
    select * from student;
  </select>
  
  <select id="getTeacherById" resultType="Teacher">
    select * from teacher where id = #{tid};
  </select>
  
  <resultMap id="StudentTeacherMap2" type="Student">
    <result property="id" column="id"/>
    <result property="name" column="id"/>
    <!-- association表示关联对象： column表示要传入子查询的字段，javaType表示关联对
    象的java类型，
    select表示子查询，这里表示将查询到的column="tid"传入子查询
    select="getTeacherById"作为参数#{tid}的值进行查询 -->
    <association property="teacher" column="tid" javaType="Teacher"
      select="getTeacherById"/>
  </resultMap>
  
</mapper>
```

## Mapper映射文件的顶级元素

映射器（mapper）的XML文件，有几个顶级元素：

- select – 映射查询语句；
- insert – 映射插入语句；
- update – 映射更新语句；
- delete – 映射删除语句；
- sql – 可被其他语句引用的可重用语句块；
- cache – 给定命名空间的缓存配置；
- cache-ref – 其他命名空间缓存配置的引用；
- resultMap – 是最复杂也是最强大的元素，用来描述如何从数据库结果集中来加载对象。



### 1、select 元素

1. 最基本的查询

```xml
<select id="getUserById" resultType="MemberUser" parameterType="int">
select ID, NAME, PERSONMOBILE, ADDRESS, AGE 
  FROM MEMBER_USER 
  WHERE ID = #{id}
</select>
```

上述配置类似于：

```java
// Similar JDBC code, NOT MyBatis…
String selectMember = "select ID, NAME, PERSONMOBILE, ADDRESS, AGE FROM MEMBER_USER WHERE ID=?";
PreparedStatement ps = conn.prepareStatement(selectMember);
ps.setInt(1,id);
```

2. select 元素有很多属性允许你配置，来决定每条语句的作用细节

示范：

```java
<select
    id="selectPerson"
    parameterType="int"
    parameterMap="deprecated"
    resultType="hashmap"
    resultMap="personResultMap"
    flushCache="false"
    useCache="true"
    timeout="10000"
    fetchSize="256"
    statementType="PREPARED"
    resultSetType="FORWARD_ONLY">
```

详细说明：

| **属性**      | **描述**                                                     |
| ------------- | ------------------------------------------------------------ |
| id            | 在命名空间中唯一的标识符，可以被用来引用这条语句。           |
| parameterType | 将会传入这条语句的参数类的完全限定名或别名。这个属性是可选的，因为 MyBatis 可以通过 TypeHandler 推断出具体传入语句的参数，默认值为 unset。 |
| resultType    | 从这条语句中返回的期望类型的类的完全限定名或别名。注意如果是集合情 形，那应该是集合可以包含的类型，而不能是集合本身。使用 resultType 或 resultMap，但不能同时使用。 |
| resultMap     | 外部 resultMap 的命名引用。结果集的映射是 MyBatis 最强大的特性，对其有一个很好的理解的话，许多复杂映射的情形都能迎刃而解。使用resultMap 或 resultType，但不能同时使用。 |
| flflushCache  | 将其设置为 true，任何时候只要语句被调用，都会导致本地缓存和二级缓存都会被清空，默认值：false。 |
| useCache      | 将其设置为 true，将会导致本条语句的结果被二级缓存，默认值：对 select 元素为 true。 |
| timeout       | 这个设置是在抛出异常之前，驱动程序等待数据库返回请求结果的秒数。默认值为 unset（依赖驱动）。 |
| fetchSize     | 这是尝试影响驱动程序每次批量返回的结果行数和这个设置值相等。默认值 为 unset（依赖驱动）。 |
| statementType | STATEMENT，PREPARED 或 CALLABLE 的一个。这会让 MyBatis 分别使用Statement，PreparedStatement 或 CallableStatement，默认值： PREPARED。 |
| resultSetType | FORWARD_ONLY，SCROLL_SENSITIVE 或 SCROLL_INSENSITIVE 中的一个，默认值为 unset （依赖驱动）。 |
| databaseId    | 如果配置了 databaseIdProvider，MyBatis 会加载所有的不带 databaseId 或匹配当前 databaseId 的语句；如果带或者不带的语句都有，则不带的会被忽略。 |
| resultOrdered | 这个设置仅针对嵌套结果 select 语句适用：如果为 true，就是假设包含了嵌套结果集或是分组了，这样的话当返回一个主结果行的时候，就不会发生有对前面结果集的引用的情况。这就使得在获取嵌套的结果集的时候不至于导致内存不够用。默认值：false。 |
| resultSets    | 这个设置仅对多结果集的情况适用，它将列出语句执行后返回的结果集并每个结果集给一个名称，名称是逗号分隔的。 |