---
title: 在 Java 中的用户输入和输出
author: my-test-author-id
date: 2023-08-18 21:09:00 +0800
categories: [Algorithms]
tags: []
pin: false
math: false
mermaid: false
---

在校招笔试（虽然我已经没机会参加校招了）中，有的时候我们要自己设计输入输出，下面罗列一些常见的输入输出；
首先把输入包加载进来： `import java.util.* ;`

## 各种输入

### 创建一个扫描器对象

> 看 Java 官方文档 API <https://docs.oracle.com/javase/8/docs/api/java/util/Scanner.html>
{: .prompt-info }

### 读入一个数字

```java
Scanner sc = new Scanner(System.in) ;
int i = nextInt() ;
```
解释一下：

1. `Scanner sc = new Scanner(System.in);` 这一行创建了一个名为 **sc** 的 **Scanner** 对象，它使用标准输入流 (**System.in**) 来读取用户的输入。
2. `int i = sc.nextInt();` 这一行从用户输入中读取一个整数，并将它存储在名为 **i** 的整数变量中。
3. 标准输入流就是键盘输入
4. 运行到第2行的时候，就会停住等你敲一个数字然后你再敲下回车键程序就继续运行了。

### 读入一个字符串

```java
Scanner sc = new Scanner(System.in) ;
String str = sc.next() ;
```

### 读一个浮点数

```java
Scanner sc = new Scanner(System.in) ;
double floatNumber = sc.nextDouble() ;
```

### 读入一整行内容

```java
Scanner sc = new Scanner(System.in) ;
String str = sc.nextLine() ;
```

### 读入一组数

假设读入`k`个
```java
Scanner sc = new Scanner(System.in) ;
int [] numbers = new int[k]
for (int index = 0; index < k; index++) {
    numbers[index] = sc.nextInt();
}
```

### 判断是否有下一个输入

```java
Scanner sc = new Scanner(System.in) ;
sc.hasNext() ;
sc.hasNextInt() ;
sc.hasNextDouble() ;
sc.hasNextLine() ;
```

### 读入一个矩阵

来自Chat老师的一个示例代码：
```java
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Enter the number of rows: ");
        int rows = sc.nextInt();

        System.out.print("Enter the number of columns: ");
        int columns = sc.nextInt();

        int[][] matrix = new int[rows][columns];

        System.out.println("Enter the matrix elements:");
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < columns; j++) {
                matrix[i][j] = sc.nextInt();
            }
        }

        System.out.println("Matrix you entered:");
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < columns; j++) {
                System.out.print(matrix[i][j] + " ");
            }
            System.out.println();
        }
    }
}
```

## 区分hasNext()和hasNextLine()、next()和NextLine()

- `sc.hasNextLine()`是只以**回车分割**分作为一个字符串的结束
- `sc.nextLine()`读取以**回车**结束的一个字符串
- `sc.hasNext()`是以**空格、回车等分隔符**作为一个字符串的结束
- `sc.next()`读取以**空格、回车等**结束的一个字符串

## 格式化输出

`System.out.printf('%8.2f', float) ;`
`System.out.print() ;`
`System.out.println() ;`
`System.out.format() ;`
`System.out.printf() ;`

> 细看文档 <https://docs.oracle.com/javase/8/docs/api/java/lang/System.html>
{: .prompt-info }