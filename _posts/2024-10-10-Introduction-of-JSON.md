---
title: 关于 JSON
categories: [Uncategorized]
tags: [Uncategorized]
toc: true
media_subpath: 
---

## 摘要

JavaScript对象表示法（JSON）是一种轻量级、基于文本、独立于语言的数据交换格式。它源于ECMAScript编程语言标准。JSON为结构化数据的可移植表示定义了一小组格式化规则。

## 1. 介绍

JavaScript对象表示法（JSON）是用于结构化数据序列化的文本格式。它源自JavaScript的对象文本，如ECMAScript编程语言标准第三版[ECMA]中所定义。

JSON可以表示四种基本类型（字符串、数字、布尔值和null）和两种结构化类型（对象和数组）。

字符串是零个或多个Unicode字符[Unicode]的序列。

对象是零个或多个名称/值对的无序集合，其中名称是字符串，值是字符串、数字、布尔值、null、对象或数组。

数组是零个或多个值的有序序列。

术语“对象”和“数组”来自JavaScript的约定。

JSON的设计目标是使其最小化、可移植、文本化，并且是JavaScript的一个子集。

## 2. JSON语法

JSON文本是一系列标记。标记集包括六个结构字符、字符串、数字和三个文字名称。

JSON文本是序列化的对象或数组。

```plaintext
JSON-text = object / array
```



### 2.1 Values

JSON的值必须是对象（object），数组（array），字符串（string）或者这三个其中之一：`false`，`null`，`true`。

1. 必须是三者之一：`false`、`null`、`true`；
2. 必须是小写。

value = false / null / true / object / array / number / string

### 2.2 Objects

一个JSON对象的表示是由一对话括号（a pair of curly brackets）包裹的0或多个键值对。一个键就是一个字符串，然后每个键后面跟着一个英文冒号（a single colon），英文冒号是用来分隔键和值的。键的名字在对象中应该唯一（unique）。

This is a JSON object:

```json
{
  "Image": {
      "Width":  800,
      "Height": 600,
      "Title":  "View from 15th Floor",
      "Thumbnail": {
          "Url":    "http://www.example.com/image/481989943",
          "Height": 125,
          "Width":  "100"
      },
      "IDs": [116, 943, 234, 38793]
              }
}
```

Its Image member is an object whose Thumbnail member is an object and whose IDs member is an array of numbers.

### 2.3 Arrays

一个数组的结构由一对方括号（square brackets）组成，并且里面有0到多个值（或者叫元素）。值（或者元素）之间由逗号分隔（commas）。

This is a JSON array containing two objects:

```json
[
  {
     "precision": "zip",
     "Latitude":  37.7668,
     "Longitude": -122.3959,
     "Address":   "",
     "City":      "SAN FRANCISCO",
     "State":     "CA",
     "Zip":       "94107",
     "Country":   "US"
  },
  {
     "precision": "zip",
     "Latitude":  37.371991,
     "Longitude": -122.026020,
     "Address":   "",
     "City":      "SUNNYVALE",
     "State":     "CA",
     "Zip":       "94085",
     "Country":   "US"
  }
]
```

### 2.4 Numbers

数字的表示和大多数编程语言差不多，都类似。它可以包括负号、小数点和指数符号等。

* 小数点（ decimal-point）：`.`
* 数字1到9（digit1-9）：`1`，`2`等等，不列了
* 指数（e）：大写`E`或者小写`e`
* 指数表示（exp）：e [ minus / plus ] 1*DIGIT
* 分数（frac）：decimal-point 1*DIGIT
* 减号（minus）：`-`
* 加号（plus）：`+`
* 零（zero）：`0`

### 2.5 Strings











## JSON

JSON 格式（JavaScript Object Notation 的缩写）是一种用于数据交换的文本格式，2001年由 Douglas Crockford 提出，目的是取代繁琐笨重的 XML 格式。

相比 XML 格式，JSON 格式有两个显著的优点：书写简单，一目了然；符合 JavaScript 原生语法，可以由解释引擎直接处理，不用另外添加解析代码。所以，JSON 迅速被接受，已经成为各大网站交换数据的标准格式，并被写入标准。

每个 JSON 对象就是一个值，可能是一个数组或对象，也可能是一个原始类型的值。总之，只能是一个值，不能是两个或更多的值。

JSON 对值的类型和格式有严格的规定。

1. 复合类型的值只能是数组或对象，不能是函数、正则表达式对象、日期对象。
2. 原始类型的值只有四种：字符串、数值（必须以十进制表示）、布尔值和`null`（不能使用`NaN`, `Infinity`, `-Infinity`和`undefined`）。
3. 字符串必须使用双引号表示，不能使用单引号。
4. 对象的键名必须放在双引号里面。
5. 数组或对象最后一个成员的后面，不能加逗号。

json的基本类型有objects(dicts), arrays(lists), strings, numbers, booleans, and nulls(json中关键字)。在一个object中所有的key都要是字符串。

## **JSON对象**

一个JSON对象，无非是括在大括号内的用逗号分隔的键值（名称/值）对。

```ruby
{"name1":value1, "name2":value2 ...}
```

JSON对象可以任意嵌套，以创建更复杂的对象：

```json
{"user":
	{	"userid": 1900,
		"username": "jsmith",
		"password": "secret",
		"groups": [ "admins", "users", "maintainers"]
	}
}
```

已定义的JSON语法（参看[RFC 4627](https://datatracker.ietf.org/doc/html/rfc4627)）中的介绍：

- JSON对象封装在大括号内`{ }`。空对象可以表示为`{ }`；
- 数组封装在方括号内`[ ]`。空数组可以表示为 `[ ]`；
- 成员由一个键-值对代表；
- 成员中的键名应该使用双引号括起来；
- 每个成员都应该有一个对象结构中唯一的键；
- 值如果是字符串，则表示括在双引号中；
- 布尔值使用小写**true**或**false**表示；
- 数字使用双精度浮点格式表示；支持科学记数法形式；数字前不应该有零；
- "攻击（冲突）"（像单、双引号、大、中括号等）性质的字符必须使用反斜杠进行转义；
- 空值由小写**null**表示；
- 其它类型，如日期，（JSON）本身不支持，应该由解析器/客户端处理转换为字符串；
- 对象或数组每个成员后面必须跟一个逗号，如果它不是最后一个的话；
- 常见的JSON文件扩展名是**.json**；
- JSON文件的MIME类型为**application/json**；

## References

1. The JavaScript Object Notation (JSON) Data Interchange Format  <https://datatracker.ietf.org/doc/html/rfc8259>
2. RFC4627:  The application/json Media Type for JavaScript Object Notation (JSON) <https://datatracker.ietf.org/doc/html/rfc4627>
