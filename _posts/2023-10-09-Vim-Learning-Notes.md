---
title: Vim 实操教程（Learning Vim）
date: 2023-10-09 10:51:00 +0800
author: dofy
categories: [Linux]
tags: [Linux, Vim]
pin: false
math: true
mermaid: false
media_subpath: /assets/images/IntroductionToDPImages/
---


# Vim 实操教程（Learning Vim）

[English](en/README.md) | [中文](README.md)

以我个人学习 Vim 的经验来看，通过看文档或看其他人操作其实是很难真正学会 Vim 的，你必须在实际
应用中，进入真实场景才能逐渐熟悉并掌握相关命令。

因此，为了同时满足学习和操作的需求，项目中的文件都采用了 Markdown 格式，既可以当作说明文档来
阅读，也可以用 Vim 打开文件进行实际操作（建议采用后者）。

### 如何使用

1. 进入控制台
2. clone 项目到本地
   ```bash
   git clone https://github.com/dofy/learn-vim.git
   ```
3. 进入项目文件夹
   ```bash
   cd learn-vim
   ```
4. 用 Vim 打开文件 `file-one.md`
   ```bash
   vim file-one.md
   ```

### 排版规范

```Markdown
## 大标题表示一大类

### 小标题表示该大类下的小分类

没有任何格式的文本为正常描述，只有阅读功能。

> 嵌入到引用块中的文本为操作指示，你可以按照里面提到的内容进行操作
>
> 同时操作符或命令会包含在类似 `:w` 的符号中

命令中形如 f<X> 中的 < 和 > 不需要打出来，<X> 代表一个变量，即你可以打 fa 或 fb 亦或 fC

_注意：命令区分大小写（需要注意的事项会出现在当前行这样的符号中）_
```

> **Note**
>
> 如果你已经有了自己的 `.vimrc` 文件 (参考 [第四章](file-four.md)) 并在其中修改了一些默认设
> 置，那么可能导致某些操作与教程不符。如遇此情况，你可以用下面的命令来运行 `Vim`：
>
> ```bash
> # 不加载配置文件
> vim -u NONE
> # 加载特定配置文件
> vim -u <filename>
> ```

## 导航

### 基础操作

1. [光标的移动](file-one.md)
1. [打开文件、查找内容](file-two.md)
1. [文档的修改与保存](file-three.md)
1. [一些小技巧](file-four.md)
1. [分屏与标签页](file-five.md)
1. [块操作](file-six.md)
1. [Vim 中的宏](file-seven.md)
1. [Vim 的模式](file-modes.md)

### 附加内容

1. [Vim 插件](plugin.md)
1. [插件推荐](plugins/index.md)
    1. [NERDTree](plugins/nerdtree.md)
    1. [EasyAlign](plugins/easyalign.md)
    1. [Airline & Themes](plugins/airline.md)
    1. [surround.vim](plugins/surround.md)

> **Note**
>
> - 教程中会有下一章或相关章节的导航，定位到文件名执行 `gf`（goto file）就可以打开相关文件
> - 你可以随时打开相关章节查看，然后用 `:bp` 回到之前的文件（该命令会在[第二章](file-two.md)中讲到）
> - 当你用 `:q` 或 `:qa` 退出教程时可能会收到文件未保存的错误提醒，试试在命令后面加上 `!`

### TODO

- [ ] vimdiff
- [ ] more settings
- [x] other mode
- [ ] text object
- [x] [plugins](plugin.md)

### 推荐几个 Vim 配置方案

  - [dofy / **7th-vim**][7th-vim]
  - [kepbod / **ivim**][kepbod]
  - [chxuan / **vimplus**][chxuan]
  - [SpaceVim / **SpaceVim**][spacevim]

### 推荐另外几个出色的 Vim 教程

- 控制台运行 `vimtutor` 这是 Vim 官方实操教程
- [简明 Vim 练级攻略][coolshell] 很不错的入门教程
- [Vim Galore][vimgalore] 更新频繁，Vim 进阶必读
- [每日一Vim][liuzhijun] 共 30 篇，内容比较全
- [Vim 教程网][vimjc] 一个女生维护的 Vim 中文教程网站，持续更新中
- [A book for learning the Vim editor][learnvim] 另一个 Learn Vim （英语）
- [Open Vim][openvim] 交互式 Vim 教程
- [QuickRef.ME/vim][quickref] Vim cheatsheet

### Cheatsheets

> [Vim Cheat Sheet][cheatsheets1]

> [A Great Vim Cheat Sheet][cheatsheets2]

> [![003][cheatsheets3]][cheatsheets3]

> [![004][cheatsheets4]][cheatsheets4]

**再次感谢您的关注！如果爱，请分享。爱生活，爱 VIM！**

[7th-vim]: https://github.com/dofy/7th-vim
[kepbod]: https://github.com/kepbod/ivim
[chxuan]: https://github.com/chxuan/vimplus
[spacevim]: https://github.com/SpaceVim/SpaceVim
[coolshell]: https://coolshell.cn/articles/5426.html
[vimgalore]: https://github.com/mhinz/vim-galore
[liuzhijun]: https://liuzhijun.iteye.com/category/270228
[vimjc]: https://vimjc.com
[learnvim]: https://github.com/iggredible/Learn-Vim
[openvim]: https://openvim.com/
[quickref]: https://quickref.me/vim
[cheatsheets1]: https://vim.rtorr.com/lang/zh_tw
[cheatsheets2]: https://vimsheet.com/
[cheatsheets3]: https://people.csail.mit.edu/vgod/vim/vim-cheat-sheet-en.png
[cheatsheets4]: https://cdn.shopify.com/s/files/1/0165/4168/files/preview.png

## 光标的移动

欢迎进入第一章，这一章将学习简单的光标移动操作。

如果你已经有了一定基础，这部分可以略过，直接 `G` 到文档尾部按照操作进入下一章。

### 移动光标

#### 单位级
- `h` 向左一字符
- `j` 下一行
- `k` 上一行
- `l` 向右一字符

#### 单词级
- `w` or `W` 向右移动到下一单词开头
- `e` or `E` 向右移动到单词结尾
- `b` or `B` 向左移动到单词开头

_注意：所有小写单词都是以分词符作为单词界限，大写字母以空格作为界限_

> 在下面字符块中感受一下各种移动吧！

```
This project's GitHub url is https://github.com/dofy/learn-vim
Please clone it to your local folder and open the first file which is
named file-one.md via following command "vim file-one.md"
and welcome to https://yahaha.net :)
```

#### 块级
- `gg` 到文档第一行
- `G` 到文档最后一行
- `0` 到行首（第 1 列）
- `^` 到第一个非空白字符
- `$` 到行尾
- `H` 移动到屏幕顶端
- `M` 移动到屏幕中间
- `L` 移动到屏幕底部
- `Ctrl-d` 向下移动半页
- `Ctrl-u` 向上移动半页
- `Ctrl-f` 向下移动一页
- `Ctrl-b` 向上移动一页
- `:<N>` or `<N>gg` 跳转到第 N 行
- `:+<N>` or `<N>j` 向下跳 N 行
- `:-<N>` or `<N>k` 向上跳 N 行

_注意：所有命令前都可以加一个数字 N，表示对后面的命令执行 N 次，例如你想向下移动 3 行，除了
可以用 `:+3` 之外，还可以用 `3j` 来实现同样的效果。另外，上面实际上有两种命令：一种是键入后
立即执行的，比如 `gg`；还有一种是先输入 `:` 的（后面还会出现先按 `/` 的），这类命令需要在
输入完成后按回车执行，后面的教程中也是一样。_

> 现在你可以在当前文件中畅游了，当你熟悉了各种移动操作后就可以通过 `G` 定位到当前文档到最后
> 一行，按照提示进入下一章了。
>
> 将光标定位到后面文件名的任意位置上，直接敲键盘 `gf` 进入[第二章](file-two.md)。
## 打开文件、查找内容

### 打开文件

哈，现在你已经在无意间学会了一种在 Vim 中打开文件的方式，虽然这种方式并不是最常用的，但却是最
直接的，尤其是当你的代码中 include 了某文件时，下面介绍另外两种常用的打开方式。

#### 在 Vim 中打开文件

- `:e <filename>` 打开名为 filename 的文件，若文件不存在则创建之
- `:Ex` 在 Vim 中打开目录树，光标选中后回车打开对应文件（提示：`-` 进入上级目录）

### 查找

#### 文档内查找

- `*` 向后查找光标当前所在单词
- `#` 向前查找光标当前所在单词
- `/<search>` 向后查找指定字符串
- `?<search>` 向前查找指定字符串
- `n` 继续查找下一个
- `N` 继续查找上一个

_注意： `n` 和 `N` 是有方向性的，若你之前通过 `*` 查找，则 `n` 会继续向文档尾方向查找，`N`
向文档首方向；反之，若你通过 `#` 查找，则 `n` 指向文档首，`N` 指向文档尾_

#### 行内查找

- `f<X>` 当前行内向行尾方向查找并定位到字符 `X`
- `t<X>` 当前行内向行尾方向查找并定位到字符 `X` 之前
- `F<X>` 当前行内向行首方向查找并定位到字符 `X`
- `T<X>` 当前行内向行首方向查找并定位到字符 `X` 之后
- `;` 继续向当前方向查找下一个字符
- `,` 向当前相反方向查找下一个字符

> 当前文档中有几个 “Vim” 单词，你可以尝试用 `*` 和 `#` 进行查找并感受 `n` 和 `N` 的方向性。
>
> 上面的 “注意” 中有几个字符 "n"，你可以在那试试行内查找并感受下 `;` 和 `,` 的方向性。

#### 匹配查找

Vim 中可以使用 `%` 对 `(` 和 `)`，`[` 和 `]`，`{` 和 `}` 进行匹配查找，当光标位于其中一个
符号上时，按下 `%`，光标会跳到与之匹配的另外一个符号上。

> 在下列文本中的 `()[]{}` 字符上按 `%` 看看效果，连续多按几次。

```javascript
const func = (win, doc) => {
  const SEVEN = ((1 + 2) * (3 + 4) * (5 - 6)) / 7;
  const YU = [1, 2, [[3, 4], 5, 6], 7];
  if (true) {
    return SEVEN;
  } else {
    return YU;
  }
}
```

[下一章](file-three.md)将介绍文档的修改，在这之前先简单介绍一下 Vim 的 buffer，简单理解
buffer 就是当前 Vim session 的文件历史记录。

> 现在你的 buffer 中应该已经有两个文件了，你可以用 `:buffers` 或 `:ls` 命令查看，看到
> buffer 列表了吧，大概是这个样子的：

```
:ls
  1 #h   "file-one.md"                  line 47
  2 %a   "file-two.md"                  line 1
Press ENTER or type command to continue
```

> 接下来你可以尝试通过以下命令在文件缓存中进行跳转了
>
> - `:bn` 打开缓存中下一个文件
> - `:bp` 打开缓存中上一个文件
> - `:b<N>` 打开缓存中第 N 个文件
>
> 你也可以使用 `:bdelete<N>` 来删除所要关闭的缓冲区，缩写 `:bd<N>`。
> 
> 当然你也可以使用 `:Ex` 命令，选择 file-three.md 并打开，进入[第三章](file-three.md)。
## 文档的修改与保存

### 修改文档

你现在已经学会了控制光标、打开文件、切换文件、并在文件中查找内容，这些操作都是在 Vim 的 normal
模式下进行的。现在，是时候进入 Vim 的另外一种模式 —— insert 模式，学习一下如何修改文件了。

#### 插入

- `i` 当前字符前插入
- `a` 当前字符后插入
- `I` 行首插入
- `A` 行尾插入
- `o` 在下一行插入
- `O` 在上一行插入

_注意：以上任何一个命令都会使 Vim 进入 insert 模式，进入该模式后光标会发生变化，这时输入的
文字会直接出现在文档中，按 `Esc` 键或 `Ctrl-[` 或 `Ctrl-C` 退出 insert 模式。_

#### 删除（并保存到 Vim 剪贴板）

- `s` 删除当前字符，并进入 `INSERT` 模式
- `S` 删除当前行并保存到 Vim 剪贴板，同时进入 `INSERT` 模式（等同于 `cc`）
- `x` 删除当前字符，相当于 insert 模式下的 `Delete`
- `X` 删除前一个字符，相当于 insert 模式下的 `Backspace`
- `dd` 删除当前行，并将删除的内容保存到 Vim 剪贴板
- `d<X>` 删除指定内容并保存到 Vim 剪贴板
- `cc` 删除当前行并保存到 Vim 剪贴板，同时进入 `INSERT` 模式
- `c<X>` 删除指定内容并保存到 Vim 剪贴板，同时进入 `INSERT` 模式

_说明： `<X>` 部分是对操作内容的描述，如果要删除一个单词，就输入 `dw` 或者 `de`，要复制当前
位置到行尾的内容，就输入 `y$`，要删除后面 3 个字符并插入，就输入 `c3l` 诸如此类。_

#### 复制

- `yy` 复制当前行到 Vim 剪贴板
- `y<X>` 复制指定内容到 Vim 剪贴板

#### 粘贴

- `p` 在当前位置后粘贴
- `P` 在当前位置前粘贴

#### 合并

- `J` 将当前行与下一行合并

> 尝试在下面的文本中进行复制粘贴练习

```
删除这一行
粘贴到这一行下面
剪切 ABC 并把它粘贴到 XYZ 前面，使这部分内容看起来像
剪切 并把它粘贴到 ABC XYZ 前面。
```

#### 替换

- `r<X>` 将当前字符替换为 X
- `gu<X>` 将指定的文本转换为小写
- `gU<X>` 将指定的文本转换为大写
- `:%s/<search>/<replace>/` 查找 search 内容并替换为 replace 内容

> 尝试修改下列文本的大小写

```
Change this line to UPPERCASE, THEN TO lowercase.
```

> 还有个更好玩的命令 `g~<X>`，先将光标定位到上面那行文本，执行 `0g~$` 看看发生了什么。

#### 撤销、重做

- `u` 撤销
- `Ctrl-r` 重做

#### 保存文件

- `:w` 保存当前文件
- `:wa` 保存全部文件
- `:wq` or `ZZ` 保存并退出
- `:q!` or `ZQ` 强制退出，不保存
- `:saveas <new filename>` 文件另存为
- `:w <new filename>` 文件另存一份名为 `<new filename>` 的副本并继续编辑原文件

> 你可以试着把当前（也许已经改得面目全非的）文件另存一份，然后继续[下一章](file-four.md)的学习。
## 一些小技巧

### 简单设置 Vim

“工欲善其事，必先利其器”。尽管 Vim 非常强大，但默认配置的 Vim 看起来还是比较朴素的，为了适合
我们的开发需求，要对 Vim 进行一些简单的配置。

- `:set number` 显示行号
- `:set relativenumber` 显示相对行号（这个非常重要，慢慢体会）
- `:set hlsearch` 搜索结果高亮
- `:set autoindent` 自动缩进
- `:set smartindent` 智能缩进
- `:set tabstop=4` 设置 tab 制表符所占宽度为 4
- `:set softtabstop=4` 设置按 `tab` 时缩进的宽度为 4
- `:set shiftwidth=4` 设置自动缩进宽度为 4
- `:set expandtab` 缩进时将 tab 制表符转换为空格
- `:filetype on` 开启文件类型检测
- `:syntax on` 开启语法高亮

这里列出的是命令，你可以通过在 Vim 中输入进行设置，但这种方式设置的参数只在本次关闭 Vim 前生效，
如果你退出 Vim 再打开，之前的设置就失效了。

若要永久生效，需要修改 Vim 的一个自动配置文件，一般文件路径是 `/home/<user>/.vimrc`（Linux
系统）或 `/Users/<user>/.vimrc`（Mac OS 系统）

如果没有就新建一个，以 Mac OS 系统为例：

> 在控制台执行如下命令，每行结尾记得回车

```bash
cd ~
vim .vimrc
```

> 现在你已经在 Vim 中打开了你的 Vim 专属配置文件，将上面提到的配置复制到你的文件中，记得要删除
> 每行开头的 `:`
>
> 修改完成执行 `:wq` 或者 `ZZ` 保存退出，再次进入 Vim 时，你的这些配置就已经生效了
>
> 当然，机智如我也为你准备好了一份 [vimrc](vimrc.vim) 样本文件，你可以在控制台执行
> `cp vimrc.vim ~/.vimrc` 直接使用，再次启动 Vim 或在 Vim 中执行  `:source ~/.vimrc`你的配置就
> 应该生效了。

_**[ AD ]** 当然你也可以在我维护的另外一个项目 [The 7th Vim](https://github.com/dofy/7th-vim) 中找到一个更为完整的配置方案。_

### 清除搜索高亮

前面提到的配置中，有一项是高亮全部搜索结果 `:set hlsearch`，其作用是当你执行 `/`
、`?`、`*` 或 `#` 搜索后高亮所有匹配结果。

> 如果你已经设置了这个选项，尝试执行 `/set`

看到效果了吧，搜索结果一目了然，但这有时候也是一种困扰，因为知道搜索结果后高亮就没用了，但高亮
本人并不这样认为，它会一直高亮下去，直到你用 `:set nohlsearch` 将其关闭。

但这样需要就打开，不需要就关闭也不是个办法，有没有更好的解决方案呢？当然！请看下面的终极答案：

> **再搜一个不存在的字符串**

通常我用来清除搜索高亮的命令是 `/lfw`，一是因为 `lfw` 这个组合一般不会出现（不适用于
本文档...），二是这三个字母的组合按起来比较舒服，手指基本不需要怎么移动（你感受一下）。

### 重复上一次命令

Vim 有一个特殊的命令 `.`，你可以用它重复执行上一个命令。

> 按下面的说明进行操作

```
按 dd 删除本行
按 . 重复删除操作
2. 再删除两行
这行也没了
p 把刚才删掉的粘回来
3. 又多出 6 行
```

### 缩进

- `>>` 向右缩进当前行
- `<<` 向左缩进当前行

> 在这一行上依次按 `3>>`，`<<` 和 `<G` 看看效果
>
> 打酱油行

### 自动排版

- `==` 自动排版当前行
- `gg=G` 当前文档全文自动排版
- `<N>==` 对从当前行开始的 N 行进行自动排版
- `=<N>j` 对当前行以及向下 N 行进行自动排版
- `=<N>k` 对当前行以及向上 N 行进行自动排版

> 另外，还可以利用[第二章](file-two.md)中提到的匹配搜索对代码块进行批量排版，尝试用
> `gf` 命令打开 [file-four-demo.js](file-four-demo.js) 按照里面的说明进行操作

如果智能缩进设置生效了，执行后会看到如[第二章](file-two.md)中一样的排版效果。

[下一章](file-five.md)将介绍分屏和标签页。
## 分屏与标签页

### 窗口分屏

工作中经常会遇到这种情况，就是需要参照其他文档编辑当前文档（场景：翻译），或者从另外一个文档
copy 代码到当前文档（场景：复制 html 元素类名到 css 文档），这时候就是你最需要分屏的时候。

#### 分屏方式

- `:split` 缩写 `:sp` or `Ctrl-w s` 上下分屏
- `:vsplit` 缩写 `:vs` or `Ctrl-w v` 左右分屏
- `:diffsplit` 缩写 `:diffs` diff 模式打开一个分屏，后面可以加上 {filename}

#### 窗口跳转

- `Ctrl-w w` 激活下一个窗口
- `Ctrl-w j` 激活下方窗口
- `Ctrl-w k` 激活上方窗口
- `Ctrl-w h` 激活左侧窗口
- `Ctrl-w l` 激活右侧窗口

#### 移动分屏

- `Ctrl-w L` 移动到最右侧
- `Ctrl-w H` 移动到最左侧
- `Ctrl-w K` 移动到顶部
- `Ctrl-w J` 移动到底部

_注意：区分大小写。另外，可以将底部的屏幕移动到右侧，实现上下分屏到左右分屏的转换。_

#### 屏幕缩放

- `Ctrl-w =` 平均窗口尺寸
- `Ctrl-w +` 增加高度
- `Ctrl-w -` 缩减高度
- `Ctrl-w _` 最大高度
- `Ctrl-w >` 增加宽度
- `Ctrl-w <` 缩减宽度
- `Ctrl-w |` 最大宽度

> 实践！实践！实践！

### 标签页

[第二章](file-two.md)中提到过的 buffer 和刚刚讲到的分屏操作都很适合在少量文件之间进行切换，
文件超过 3 个我觉得就不方便了，而标签页则更适合多文件之间的切换。

#### 创建标签页

- `:tabnew` or `:tabedit` 缩写 `:tabe` 打开新标签页
- `Ctrl-w gf` 在新标签页中打开当前光标所在位置的文件名

_注意：`:tabnew` 和 `:tabedit` 后面都可以跟一个 <空格><文件名> 用以在新标签页中
打开指定文件，还可以在 `:` 后面加一个数字，指出新标签页在列表中的位置（从 0 开始）。_

#### 切换标签页

- `gt` or `:tabnext` 缩写 `:tabn` 下一个标签页（最后一个会循环到第一个）
- `gT` or `:tabprevious` 缩写 `:tabp` 上一个标签页（第一个会循环到最后一个）
- `:tabrewind` 缩写 `:tabr` or `:tabfirst` 缩写 `:tabfir` 到第一个
- `:tablast` 缩写 `:tabl` 到最后一个标签页

#### 关闭标签页

- `:tabclose` 缩写 `:tabc` 关闭当前标签页
- `:-tabc` 关闭上一个标签页
- `:+tabc` 关闭下一个标签页
- `:tabonly` 缩写 `:tabo` 关闭其他标签页

[下一章](file-six.md)将介绍块操作。
## 块操作

我们经常会遇到这种情况：某处有一个多行文本，我们要把他复制到代码中用来初始化一个数组。 大部分
时候我们会这么做：

- 写好数组声明；
- 把内容复制到中括号内（大概长成下面那段文本的样子）
- 然后行首加 `'` 行尾加 `',`，重复直到最后一行（想象一下这段文本有50行）

> 有了 Vim 块操作就不用这么麻烦了，按 `014gg`，然后跟着选中那一行的指示操作。

```javascript
var myArray = [
Ctrl-v 进入块操作，$ 到行尾，j 到下一行（做！）。
按 j 到下一行
下面还好多行，干脆来个 4j 多跳几行
https://www.yahaha.net
https://www.yahaha.net
以后看好行号再跳！现在按 A 插入，然后输入 <单引号><逗号><Esc> 完成第一步。
// Oops... 跳多了，没事，按 k 回到上一行
];
```

> 现在已经完成了第一步，还需要补前面的 `'`，按 `14gg` 回到那一行，再操作一次，但是这次有三个
> 地方要变化一下：
>
> 1. 第一行按 `$` 时改按 `0`，因为这次要在行首插入；
> 1. 末行按 `A` 时改按 `I`，块操作中 `A` 是字符后插入， `I` 是字符前插入；
> 1. 最后按 `<单引号><Esc>`。
>
> 最后再做些收尾工作，`19gg$x` 删掉最后一行结尾处的 `,`，然后 `14gg7==` 把代码缩进一下。
>
> Done!

_注意：选择行首行尾的操作也可以在选择完要处理的内容之后执行，即 `Ctrl-v jjj$A',<Esc>`_

接下来我们说说 [Vim 中的宏](file-seven.md)。
## Vim 中的宏

宏操作在 Vim 中（甚至任何编辑器中）属于比较复杂的操作了，如果前面的内容都已经掌握了，那么你
已经可以算是一个 Vim 高手了，所以，这位高手，我们不妨再来进阶一下吧。

还记得[上一章](file-six.md)中把文本转成数组的例子吧，我们还做同样的事，不过这次是用宏来操作。

> `12gg` 跳转到准备开始处理的起始行，按指示进行操作，先看效果后解释。

```javascript
var myArray = [
按 qa 开启宏录制，前方高能，连续按 I<单引号><Esc>A<单引号><逗号><Esc>jq7@a
我也要
我也要
我也要
我也要
我也要
我也要
我也要
];
```

OMG! 发生了什么，有没有惊出一身冷汗，之前两次块操作的结果瞬间就完成了，最后再简单做些收尾工作，
去掉最后一行的逗号，集体缩进一下，搞定！

下面来解释一下刚才的操作：

- `q` 是开启录制宏，`a` 是给这次宏的录制过程一个存储位置，可以是 0-9 或 a-z；
- 然后 `I<单引号><Esc>A<单引号><逗号><Esc>j` 是你这次录制的整个宏的操作过程，意思就是行首
插入单引号，行尾插入单引号和逗号，跳到下一行；
- 接下来的 `q` 是结束本次宏的录制；
- `@` 是唤起宏，`a` 是要唤起的宏的名字（存储位置），前面的 `7` 你应该明白吧，就是执行 7 次。

_Tips：`@@` 再次唤起最后一次执行的宏。_

---

日常工作中频繁用到的和不怎么用得上的在这七章中应该都已经涉及到了，如果 Vim 中遇到了什么问题，
或者教程中遗漏了什么常规操作，欢迎在 [issues](../../issues) 中提出来，我会尽我所能给予回答
或完善到教程中。

**再次感谢您的关注！如果爱，请分享。爱极客公园，爱 VIM！**