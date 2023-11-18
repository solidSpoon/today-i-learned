# 1.正则元字符

- 特殊单字符 [try](https://regex101.com/r/PnzZ4k/1)
    - `.` 任意字符（换行除外）
    - `\d` 任意数字；`\D` 任意非数字
    - `\w` 任意字母数字下划线；`\W` 任意非字母数字下划线
    - `\s` 任意空白符；`\S` 任意非空白符
- 空白符
    - `\r` 回车符
    - `\n` 换行符
    - `\f` 换页符
    - `\t` 制表符
    - `\v` 垂直制表符
    - `\s` **任意空白符**
- 量词
    - `.` 0到多次
    - `+` 1到多次
    - `?` 0到1次
    - `{m}` 出现m次
    - `{m,}` 出现至少m次
    - `{m,n}` 出现m到n次
- 范围 [try](https://regex101.com/r/PnzZ4k/5)
    - `|` 或，如 `ab|bc` 代表 ab 或 bc
    - `[...]` 多选1，括号中任意单个元素
    - `[a-z]` 匹配 a 到 z 之间任意单个元素
    - `[^...]` **取反**，不能是括号中任意单个元素

---

[01 | 元字符：如何巧妙记忆正则表达式的基本元件？-极客时间](https://time.geekbang.org/column/article/245214)

[正则测试](https://regex101.com/	"regex101")
[正则图](https://regexper.com/	"regexper")



# 2.贪婪模式

## 量词

![Untitled](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165638.png)
## 三种模式

### 贪婪匹配（Greedy）

尽可能进行最长匹配

**用法**：贪婪匹配为默认模式，如 `a*`

匹配不上会回溯

![|800](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165801.jpeg)

![|800](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165817.jpeg)

### 非贪婪匹配（Lazy）

尽可能进行最短匹配。

**用法**：“数量”元字符后加 `?` （英文问号），如 `a*?`

匹配不上会回溯

![|700](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165829.png)

### 独占模式（Possessive）

与贪婪模式类似，尽可能进行最长匹配，如果匹配失败就结束，

**不会进行回溯**，比较节省时间。

**用法**：“数量”元字符后加 `+` 。如 `a*+`

![|800](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165842.jpeg)

解释：独占模式中 `a{1,3}+` 会把前面三个 a 都用掉，并且不会回溯，这样字符串中内容只剩下 b 了，导致正则中加号后面的 a 匹配不到符合要求的内容

## 回溯（Backtracking）

后面匹配不上，会吐出已匹配的再尝试

![|500](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165851.png)

![|500](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165908.png)

---

[02丨量词与贪婪：小小的正则，也可能把CPU拖垮！-极客时间](https://time.geekbang.org/column/article/248408)

# 3.分组与引用

- 将某部分（子表达式）看成一个整体
- 在后续查找或替换中引用分组

## 分组与编号

括号在正则中可以用于分组，被括号括起来的部分“子表达式”会被保存成一个子组。第几个括号就是第几个分组。

![|600](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165923.png)

## 非捕获分组

在括号里面的会保存成子组，但有些情况下，你可能只想用括号将某些部分看成一个整体，后续不用再用它。 

用法：在括号中使用 `?:`

![|800](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165933.png)

## 命名分组

命名分组的格式为 `(?P<分组名>正则)`

```
^profile/(?P<username>\w+)/$
```

## 分组引用

![|700](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165940.png)

例子：

![|500](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165950.png)

![|500](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-165959.png)

---

# 4.匹配模式

匹配模式（Match Mode）：指的是正则中一些改变元字符匹配行为的方式，通过模式修饰符来指定

**用法**： `(?模式标识)正则表达式`

可以将多种模式标识放一起 `(?标识1标识2)正则表达式`

可通过添加括号来改变模式标识**作用范围**

## 不区分大小写模式（Case-Insensitive）

**用法**：正则前添加模式修饰符 `(?i)`

例：

`(?i)cat` 不区分大小写的 cat，同 `[Cc][Aa][Tt]`

匹配两个 cat 时，

`(?i)(cat) \1` 可以匹配前后大小写不同，即 `(?i)` 范围包扩 `\i`

`((?i)cat) \1` 前后大小写必须相同，限制了 `(?i)` 的范围

`((?i)(cat)) \1` 会多出一个子组，和 `((?i)(cat)) \2` 效果一样

## 点号通配模式（Dot All）

也叫单行匹配模式（Single Line）

**用法**：正则前添加模式修饰符 `(?s)`

通常 `.` 不能匹配换行符，使用点号通配模式可以匹配上换行符

![|500](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-170013.png)

也可以使用 `[\s\S]` 或 `[\d\D]` 或 `[\w\W]` 等实现匹配真正任意字符

> 特殊单字符 [try](https://regex101.com/r/PnzZ4k/1)
> 
> - `.` 任意字符（换行除外）
> - `\d` 任意数字；`\D` 任意非数字
> - `\w` 任意字母数字下划线；`\W` 任意非字母数字下划线
> - `\s` 任意空白符；`\S` 任意非空白符

## 多行匹配模式（Multiline）

**用法**：正则前添加模式修饰符 `(?m)`

通常 `^` 匹配**整个字符串**的开头， `$` 匹配**整个字符串**的结尾

多行匹配模式下会匹配**每行**的开头或结尾

![|500](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-170019.png)

正则中还有 `\A` 仅匹配整个字符串的开始，`\z` 仅匹配整个字符串的结束，在多行匹配模式下，它们的匹配行为不会改变，如果只想匹配整个字符串，而不是匹配每一行，用这个更严谨一些。

## 注释模式（Comment）

正则中书写注释

用法 `(?#comment)`

例：

`(\w+) \1` 添加注释后  `(\w+)(?#word) \1(?#word repeat again)`

---

[04 | 匹配模式：一次性掌握正则中常见的4种匹配模式-极客时间](https://time.geekbang.org/column/article/250629)

# 5.断言

## 单词边界（Word Boundary）

**用法**：正则中使用\b 来表示单词的边界

![https://cdn.nlark.com/yuque/0/2020/jpeg/1548042/1592805374734-04096c78-1d2a-47d4-84f4-2a98c6bebd3c.jpeg#align=left&display=inline&height=404&margin=%5Bobject%20Object%5D&originHeight=404&originWidth=1442&size=0&status=done&style=none&width=1442](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-170032.jpeg)

`\b\w+\b` 匹配单词，或者空格分隔的字符串等

## 行的开始或结束

**用法**：使用 `^` 和 `$` 匹配行的开始或结束（多行匹配模式）
`\A` 和 `\z` 匹配整个字符串的开始或结束，不受匹配模式的影响。

例如：`^\d{6}$` 匹配六位数字

各平台换行符：

![https://cdn.nlark.com/yuque/0/2020/jpeg/1548042/1592806451962-de0ee6c9-5deb-4b9c-b093-90c8aa336bb7.jpeg#align=left&display=inline&height=268&margin=%5Bobject%20Object%5D&originHeight=268&originWidth=1250&size=0&status=done&style=none&width=1250](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-170042.jpeg)

## 环视（ Look Around）

也称零宽断言

**用法**：

![https://cdn.nlark.com/yuque/0/2020/jpeg/1548042/1592807064322-46551c2d-eaef-4be1-aed4-44c436ba8122.jpeg#align=left&display=inline&height=478&margin=%5Bobject%20Object%5D&originHeight=478&originWidth=1262&size=0&status=done&style=none&width=1262](https://ced-md-picture.oss-cn-beijing.aliyuncs.com/img/2021/11/27/20211127-170052.jpeg)

**口诀**：

- 左尖括号代表看左边
- 没有尖括号是看右边
- 感叹号是非的意思

**表示环视的括号不算做子组**

**例子**：
匹配邮政编码
`(?<!\d)[1-9]\d{5}(?!\d)`

匹配单词
`(?<!\w)\w+(?!\w)` 
`(?<=\W)\w+(?=\W)` 
`\b\w+\b`

JavaScript 不支持逆向环视(逆向断言)

---

[05 | 断言：如何用断言更好地实现替换重复出现的单词？-极客时间](https://time.geekbang.org/column/article/251972)