
## Call stack 是什么?

Call stack(通常译作调用栈”)也是计算机系统中的一个重要概念。在介绍 call stack 之前，我们首先来回顾一下 procedure 是什么。在计算机程序当中，一个Procedure(通常译作'过程)吃进来一些参数，干些事情，再吐出去一个返回值(或者什么也不吐)。我们熟悉的Function、method、handler等等其实都是Procedure。当一个Procedure A调用另一个Procedure B的时候，计算机其实需要干好几件事。

1. 是转移控制--计算机要暂停 A并开始执行 B，并让 B在执行完之后还能回到A继续执行。
2. 是转移数据--A要能够传递参数给 B，并且 B也能返回值给 A。
3. 分配和释放内存--在 B开始执行时为它的局部变量分配内存，并在 B 返回时释放这部分内存。

同学们想一下，假设A调用B，B再调用C，C执行完返回给B，B再执行完返回给 A，哪种数据结构最适合管理它们所使用的内存?没错，是stack，因为过程调用具有last-in first-out的特点。当A调用 B的时候，A只要将它需要传递给 B的参数 push进这个stack，再把将来 B返回之后A应当继续执行的指令的地址(学名叫return address)也 push 进这个 stack，就万事大吉了。之后 B可以继续在这个 stack上面保存一些寄存器的值，分配局部变量，进而继续构造调C时需要传递的参数等等。这个stack其实就是我们所说的CalStack。(这里的描述有些简化，实际当中计算机会做一些优化，如果参数和局部变量不太多的话就懒得放在 call stack里，而是直接使用寄存器了。)Call stack在 virtual memory 里其实就是一段连续的地址空间，靠一个叫做SP的寄存器(32-bit叫ESP，64-bit叫RSP)来指向栈顶。既然尽管它叫做 call stack，我们依然可以同时有不止一个参数和不止一个局部变量的原因。

Example 举个例子吧。假设我们有这样一段求阶乘的代码:

```c
int fact(int n) {
    
    int result;

    if (n <= 1) {
        result = 1;
    } else {
        result = n * fact(n - 1);
    }

    return result;
}
```

当 main() 调用了 fact(n)，fact(n)又调用了 fact(n-1)，fact(n-1)即将调用 fact(n-2)的时候，它的 call stack差不多是这样:(具体情况大同小异，和编译器优化有关。)

其中每个 procedure分配的内存区域叫做它的 stack frame(通常译作“栈帧'，吕老师译作"梦境")。这也就解释了为什么当我们分析递归函数调用的空间复杂度时，既需要考虑recursion tree 的深度，也需要考虑每层所分配的局部变量的大小。对于上述 fact()函数，它的recursion tree 的深度是n，这就意味着总共有n个stack frame。每个希望同学们能够通过了解 call stack 进一步理解空间复杂度的计算，在面试的时候一通百通。

(本文在写作过程中参考了 Randal E.Bryant和 David R.O'Hallaron 所著的Computer Systems: A Programmer's Perspective 第二版和第三版。)