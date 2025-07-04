```java
Collections.sort(inventory, new Comparator<Apple>() {
    public int compare(Apple a1, Apple a2) {
        return a1.getWeight().compareTo(a2.getWeight());
    }
});
// Stream API
inventory.sort(comparing(Apple::getWeight));
```

> inventory n. 详细目录；存货(清单) vt. 编制(详细目录)

Java 8 假如 Stream 1. 向方法传递代码的简洁技巧（方法引用、Lambda）；2. 接口中的默认方法；

向方法传递代码 -> 行为参数化，即函数式编程。

函数式编程：将代码传递给方法，同时也能够返回代码并将其包含在数据结构中，同样被成为函数的代码。

如果我想筛选出一个目录中的所有隐藏文件：

```java
File[] hiddenFiles = new File(".").listFiles(new FileFilter() {
    public boolean accept(File file) {
        return file.isHidden();
    }
})
```

Java 8 写法：

```java
File[] hiddenFiles = new File(".").listFiles(File::isHidden);
```

因此只需要用 Java 8 的方法引用`::`语法（即“把这个方法当作值”）将其传给`listFiles`方法。
