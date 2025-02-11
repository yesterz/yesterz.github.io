怎么计算出来一个对象的内存占用?



Example: 空String占用的空间

```java
package wiki.yesterz;

import org.openjdk.jol.info.ClassLayout;

public class Main {
    public static void main(String[] args) {
        String s = new String();
        String printable = ClassLayout.parseInstance(s).toPrintable();
        System.out.println(printable);
    }
}

```

output:

```bash
➜  V1  /usr/bin/env /usr/lib/jvm/java-17-openjdk-amd64/bin/java @/tmp/cp_dl0kjjki4
4mdmlptmjef8p7k.argfile wiki.yesterz.Main 
# WARNING: Unable to get Instrumentation. Dynamic Attach failed. You may add this JAR as -javaagent manually, or supply -Djdk.attach.allowAttachSelf
java.lang.String object internals:
OFF  SZ      TYPE DESCRIPTION               VALUE
  0   8           (object header: mark)     0x0000000000000001 (non-biasable; age: 0)
  8   4           (object header: class)    0x0000ec20
 12   4       int String.hash               0
 16   1      byte String.coder              0
 17   1   boolean String.hashIsZero         false
 18   2           (alignment/padding gap)   
 20   4    byte[] String.value              []
Instance size: 24 bytes
Space losses: 2 bytes internal + 0 bytes external = 2 bytes total

```

当前内存大小是在默认开启压缩指针的条件下

1. object header 8+4=12
2. char[]数组引用 4
3. int 类型 hash数据大小 4
4. loss due to the next object alignment 对齐填充 4

总结：24





```xml
<!-- https://mvnrepository.com/artifact/org.openjdk.jol/jol-core -->
<dependency>
    <groupId>org.openjdk.jol</groupId>
    <artifactId>jol-core</artifactId>
    <version>0.17</version>
</dependency>
```

