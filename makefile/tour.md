# Rules
A simple makefile consists of "rules" with the following shape:
```
target ... : prerequisites ...
       	command
       	...
       	...
```

这个文件主要描述哪些文件（'target'目的文件）是从哪些别的文件（'prerequisites'依赖文件）中产生的，用什么命令（command）来进行这个产生过程。
有了这些信息，make会检查磁盘上的文件，如果目标文件的时间戳（该文件生成或被改动时的时间）比至少它的一个依赖文件旧的话，make就执行相应的命令，以便更新目标文件。
（目标文件不一定是最后的可执行档，它可以是任何一个文件。）

## 1st version: Makefile.rule
```makefile
# A rule for building a object file.
fmt: fmt.o word.o line.o
	gcc fmt.o word.o line.o -o fmt

fmt.o: fmt.c word.h line.h
	gcc -c fmt.c -o fmt.o
 
word.o: word.c word.h
	gcc -c word.c -o word.o
 
line.o: line.c line.h
    gcc -c line.c -o line.o
```

make从最上面开始，把上面第一个目标fmt，做为它的主要目标（一个它需要保证其总是最新的最终目标）。给出的规则说明只要文件fmt比文件fmt.o，word.o或line.o中的任何一个旧，下面一行的命令将会被执行。
在检查文件fmt.o，word.o和line.o的时间戳之前，它会往下查找那些把fmt.o，word.o或line.o做为目标文件的规则。找到关于fmt.o的规则，其依赖文件是fmt.c, word.h和line.h，从下面再找不到生成这些依赖文件的规则，就开始检查磁盘上这些依赖文件的时间戳。如果这些文件中任何一个的时间戳比fmt.o的新，命令'gcc -c fmt.c -o fmt.o'将会执行，从而更新文件fmt.o。接下来对文件word.o及line.o做类似的检查，最后make返回到fmt的规则。如果下面的三个规则中的任何一个被执行，fmt就需要重建（因为其中一个.o档就会比fmt新），因此链接命令将被执行。


# Automatic Variables

    |变量       |说明                                                                   |
    |:----------|:----------------------------------------------------------------------|
    |$*         |不包含扩展名的目标文件名称                                             |
    |$+         |所有的依赖文件，以空格分开，并以出现的先后为序，可能包含重复的依赖文件 |
    |$<         |第一个依赖文件的名称                                                   |
    |$?         |所有的依赖文件，以空格分开，这些依赖文件的修改日期比目标的创建日期晚   |
    |$@         |目标的完整名称                                                         |
    |$^         |所有的依赖文件，以空格分开，不包含重复的依赖文件                       |
    |$%         |如果目标是归档成员，则该变量表示目标的归档成员名称                     |
    |AR         |归档维护程序的名称，默认值为ar                                         |
    |ARFLAGS    |归档维护程序的选项                                                     |
    |AS         |汇编程序的名称，默认值为as                                             |
    |ASFLAGS    |汇编程序的选项                                                         |
    |CC         |c编译器的名称, 默认值为cc                                              |
    |CCFLAGS    |c编译器的选项                                                          |


## 2nd version: Makefile.variable
```makefile
# Define a macro for name of objects
OBJS = fmt.o word.o line.o

# Define macros for name of compiler
CC = gcc
 
# Define a macro for the CC flags
CFLAGS = -Wall -g -std=c99

# A rule for building a object file
fmt: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ 
 
fmt.o: fmt.c word.h line.h
	$(CC) $(CFLAGS) -c $< -o $@
 
word.o: word.c word.h
	$(CC) $(CFLAGS) -c $< -o $@
 
line.o: line.c line.h
	$(CC) $(CFLAGS) -c $< -o $@
```



# Implicit Rules
Implicit rules tell make how to use customary techniques so that you do not have to specify them in detail when you want to use them. 

## 后缀规则(Suffix Rules)
后缀规则是定义隐含规则的老风格方法。
后缀规则定义了将一个具有某个后缀的文件（例如.c文件）转换为具有另外一种后缀的文件（例如.o 文件）的方法。
每个后缀规则以两个成对出现的后缀名定义，例如将.c文件转换为.o文件的后缀规则可定义为：
```makefile
.c.o:
	$(CC) $(CFLAGS) -c $< -o $@
```

## 模式规则(pattern rules)
这种规则更加通用，因为可以利用模式规则定义更加复杂的依赖性规则。
模式规则看起来非常类似于正则规则，但在目标名称的前面多了一个%号，同时可用来定义目标和依赖文件之间的关系，例如下面的模式规则定义了如何将任意一个.c文件转换为.o文件：
```makefile
%.c:%.o
	$(CC) $(CFLAGS) -c $< -o $@ 
```

## 3rd version: Makefile.implict
```makefile
# Define a macro for name of objects
OBJS = fmt.o word.o line.o

# Define macros for name of compiler
CC = gcc
 
# Define a macro for the CC flags
CFLAGS = -Wall -g -std=c99

# A rule for building a object file
fmt: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ 

fmt.o word.o line.o: %.o:%.c
	$(CC) $(CFLAGS) -c $< -o $@
```


# Phony Targets
“伪目标”并不是一个文件，只是一个标签，由于其不是文件，所以make无法生成它的依赖关系和决定它是否要执行。只有通过显示地指明这个“目标”才能让其生效。“伪目标”的取名不能和文件名重名，不然其就失去了“伪目标”的意义了。为了避免和文件重名的这种情况，可以使用一个特殊的标记“.PHONY”来显示地指明一个目标是“伪目标”，向make说明，无论是否有这个文件，这个目标就是“伪目标”。

只要有这个声明，不管是否有clean文件，要运行clean这个目标，只有执行make clean。整个过程可以这样写：
## 4th version: Makefile.phony
```makefile
# Define a macro for name of objects
OBJS = fmt.o word.o line.o

# Define macros for name of compiler
CC = gcc
 
# Define a macro for the CC flags
CFLAGS = -Wall -g -std=c99

# A rule for building a object file
fmt: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ 

fmt.o word.o line.o: %.o:%.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f *.o fmt
```


# Conditional Parts of Makefiles
使用条件判断，可以让make根据运行时的不同情况选择不同的执行分支。条件表达式可以是比较变量的值，或是比较变量和常量的值。
```
Syntax of Conditionals:
	<conditional-directive>;
	<text-if-true>;
	endif
or:
	<conditional-directive>;
	<text-if-true>;
	else
	<text-if-false>;
	endif
```

其中<conditional-directive>;表示条件关键字，这个关键字有四个：
1）ifeq
    ifeq (<arg1>, <arg2>)
    比较参数"arg1"和"arg2"的值是否相同

2）ifneq
	ifneq (<arg1>, <arg2>)
    比较参数"arg1"和"arg2"的值是否不同，如果不同则为真。

3）ifdef
	ifdef <variable-name>
    如果变量<variable-name>的值非空，那么表达式为真，否则表达式为假。
    <variable-name>同样可以是一个函数的返回值。
    注意：ifdef只是测试一个变量是否有值，其并不会把变量扩展到当前位置。
    e.g.1:
    ```makefile
    bar =
    foo = $(bar)
    ifdef foo
        frobozz = yes
    else
        frobozz = no
    endif
    ```
    e.g.2:
    ```makefile
    foo =
    ifdef foo
	    frobozz = yes
    else
        frobozz = no
    endif
    ```
    第一个例子中"$(frobozz)"值是"yes"，第二个则是"no"。

4）ifndef
	ifndef <variable-name>;
    与"ifdef"相反

在<conditional-directive>;这一行上，多余的空格是被允许的，但是不能以[Tab]键做为开始（否则会被认为是命令），而注释符"#"同样也是安全的。"else"和"endif"也一样,只要不是以[Tab]键开始就行。

注意: make是在读取Makefile时就计算条件表达式的值，并根据条件表达式的值来选择语句，所以最好不要把自动化变量（如"$@"等）放入条件表达式中，因为自动化变量是在运行时才有的，而且为了避免混乱，make不允许把整个条件语句分成两部分放在不同的文件中。


# Functions
函数主要分为两类：make内嵌函数和用户自定义函数。
对于make内嵌函数，直接引用就可以了；对于用户自定义的函数，要通过make的call函数来间接调用。
函数和参数列表之间要用空格隔开，多个参数之间使用逗号隔开。
如果在参数中引用了变量，变量的引用建议和函数引用使用统一格式：要么是一对小括号，要么是一对大括号。
函数调用很像变量的使用，也是以"$"来标识的，其语法如下：
```
	$(<function> <arguments>)
or:
	${<function> <arguments>}
```

<function>是函数名，<arguments>是函数的参数，参数间以逗号","分隔，而函数名和参数之间以"空格"分隔。 

## 内嵌函数

### 文件名处理函数

#### dir
$(dir NAMES...)
dir函数用来从一个路径名中截取目录的部分
e.g.
```makefile
LIST := ~/toolchain/makefile/tour.md ~/linux.kernel.archives/linux-stable/arch/x86/kernel/vmlinux.lds.S
all:
    @echo $(LIST)
    @echo $(dir $(LIST))
```

#### notdir
notdir函数和dir函数实现完全相反的功能，从一个文件路径名中去文件名，而不是目录。
$(notdir NAMES...)
e.g.
```makefile
LIST := ~/toolchain/makefile/tour.md ~/linux.kernel.archives/linux-stable/arch/x86/kernel/vmlinux.lds.S
all:
    @echo $(LIST)
    @echo $(notdir $(LIST))
```

#### suffix
$(suffix NAMES...)
suffix函数从一系列文件名序列中，取出各个文件名的后缀。
文件名的后缀是文件名中以点号开始（包括点号）的部分。若文件名没有后缀，suffix函数则返回空字符串。
e.g.
```makefile
LIST := ~/toolchain/makefile/tour.md ~/linux.kernel.archives/linux-stable/arch/x86/kernel/vmlinux.lds.S
all:
    @echo $(LIST)
    @echo $(suffix $(LIST))
```

#### basename
$(basename NAMES...)
basename函数从一系列文件名序列中，取出各个文件名的前缀。
如果一个文件名中包括多个点号，basename函数返回最后一个点号之前的文件名部分；如果一个文件名没有前缀，函数返回空字符串。
e.g.
```makefile
LIST := ~/toolchain/makefile/tour.md ~/linux.kernel.archives/linux-stable/arch/x86/kernel/vmlinux.lds.S
all:
    @echo $(LIST)
    @echo $(basename $(LIST))
```

#### addsuffix
$(addsuffix SUFFIX,NAMES...)
给文件列表中的每个文件名添加一个后缀SUFFIX
e.g.
```makefile
LIST := ~/toolchain/makefile/tour.md ~/linux.kernel.archives/linux-stable/arch/x86/kernel/vmlinux.lds.S
all:
    @echo $(LIST)
    @echo $(addsuffix .suffix,$(LIST))
```

#### addprefix
$(addprefix PREFIX,NAMES...)
给文件列表中的每个文件名添加一个前缀PREFIX
e.g.
```makefile
LIST := ~/toolchain/makefile/tour.md ~/linux.kernel.archives/linux-stable/arch/x86/kernel/vmlinux.lds.S
all:
    @echo $(LIST)
    @echo $(addprefix prefix.,$(LIST))
```

#### join
$(join LIST1,LIST2)
将字符串LIST1和字符串LIST2的各个单词依次连接，合并为新的单词构成的字符串。
e.g.
```makefile
LIST1 = a b c
LIST2 = .c .h .s
all:
    @echo $(LIST1)
    @echo $(LIST2)
    @echo $(join $(LIST1),$(LIST2))
```
如果两个字符串中的单词个数不相等，则只合并前面的单词，剩下的单词不合并。
e.g.
```makefile
LIST1 = a b c
LIST2 = .c .h
all:
    @echo $(LIST1)
    @echo $(LIST2)
    @echo $(join $(LIST1),$(LIST2))
```

#### wildcard
$(wildcard PATTERN)
列出当前目录下所有符合PATTREN模式的文件名
e.g.
```makefile
all:
    @echo $(wildcard *.c)
```

#### abspath
$(abspath NAMES...)
用来将相对路径转换成绝对路径
e.g.
```makefile
all:
    @echo $(abspath .)
```

### 文本处理函数

#### subst
$(subst old,new,text) 
字符串替换函数, 将字符串text中的old替换为new
e.g. 
```makefile
SRCS := $(wildcard *.c)
OBJS := $(subst .c,.o,$(SRCS))

all:
    @echo $(OBJS)
    @echo $(subst banana,apple,"banana is good, I like banana")
```

#### patsubst
$(patsubst PATTERN,REPLACEMENT,TEXT)
patsubst函数用来模式替换, 使用通配符 % 代表一个单词中的若干字符，在PATTERN和REPLACEMENT中如果都包含这个通配符，表示两者表示的是相同的若干个字符，并执行替换操作。
e.g. 
```makefile
SRCS := $(wildcard *.c)
OBJS := $(patsubst %.c,%.o,$(SRCS))

all:
    @echo $(OBJS)
```

#### strip
strip函数是一个去空格函数，一个字符串通常有多个单词，单词之间使用一个或多个空格进行分割，strip函数用来将多个连续的空字符合并成一个，并去掉字符串开头、末尾的空字符。空字符包括：空格、多个空格、tab等不可显示的字符。
e.g.
```makefile
STR =     hello a    b   c
STRIP_STR = $(strip $(STR))
all:
    @echo "$(STR)"
    @echo "$(STRIP_STR)"
```
strip函数经常用在条件判断语句的表达式中，去掉多余的空格等因素，确保表达式比较的可靠和健壮。

#### findstring
$(findstring FIND,IN)
findstring函数在字符串IN中查找FIND字符串，如果找到则返回字符串FIND，否则返回空。
e.g.
```makefile
STR = hello a b c
FIND = $(findstring hello,$(STR))
all:
    @echo $(STR)
    @echo $(FIND)
```

#### filter
$(filter PATTERN...,TEXT)
filter函数用来过滤掉字符串TEXT中所有不符合PATTERN模式的单词，只留下符合PATTERN格式的单词。
e.g.
```makefile
FILE = a.c b.h c.s d.cpp
SRC = $(filter %.c,$(FILE))
all:
    @echo $(FILE)
    @echo $(SRC)
```

#### filter-out
$(filter-out PATTERN,TEXT) 
filer-out函数是一个反过滤函数，功能和filter函数恰恰相反，该函数会过滤掉所有符合PATTERN模式的单词，保留所有不符合此模式的单词。
e.g.
```makefile
FILE = a.c b.h c.s d.cpp
SRC = $(filter-out %.c,$(FILE))
all:
    @echo $(FILE)
    @echo $(SRC)
```

#### sort
$(sort LIST)
sort函数对字符串LIST中的单词以首字母为准进行排序，并删除重复的单词。
e.g.
```makefile
LIST = banana pear apple peach apple orange 
all:
    @echo $(LIST)
    @echo $(sort $(LIST))
```

#### word
$(word N,TEXT)
word函数的作用是从一个字符串TEXT中，按照指定的数目N取单词。
返回值是字符串TEXT中的第N个单词。如果N的值大于字符串中单词的个数，返回空；如果N为0，则出错。
e.g.
```makefile
LIST = banana pear apple peach orange
all:
    @echo $(word 1,$(LIST))
    @echo $(word 2,$(LIST))
    @echo $(word 3,$(LIST))
    @echo $(word 4,$(LIST))
    @echo $(word 5,$(LIST))
    @echo $(word 6,$(LIST))
```

#### firstword && lastword
$(firstword NAMES...)
firstword函数用来取一个字符串中的首个单词，firstword函数其实就相当于$(word 1, TEXT)。
$(lastword NAMES...)
lastword函数用来取一个字符串中的末尾单词
e.g.
```makefile
LIST = banana pear apple peach orange
all:
    @echo $(LIST)
    @echo "first word = $(firstword $(LIST))"
    @echo "last word = $(lastword $(LIST))"
```

#### wordlist
$(wordlist N,M,TEXT)
wordlist函数用来从一个字符串TEXT中取出从N到M之间的一个单词串。
N和M都是从1开始的一个数字，函数的返回值是字符串TEXT中从N到M的一个单词串。当N比字符串TEXT中的单词个数大时，函数返回空。
e.g.
```makefile
LIST = banana pear apple peach orange
all:
    @echo $(LIST)
    @echo $(wordlist 1,3,$(LIST))
```

#### words
$(words TEXT)
words函数用来统计一个字符串TEXT中单词的个数
e.g.
```makefile
LIST = banana pear apple peach orange
all:
    @echo $(LIST)
    @echo $(words $(LIST))
```

### foreach
$(foreach VAR,LIST,TEXT)
把LIST中使用空格分割的单词依次取出并赋值给变量VAR，然后执行TEXT表达式。重复这个过程，直到遍历完LIST中的最后一个单词。返回值是TEXT多次计算的结果。
e.g.
```makefile
dirs = cunit emacs gcov gdb makefile strace-ltrace vim
all:
    @echo $(foreach dir,$(dirs),$(wildcard $(dir)/*.c))
```

### if
$(if CONDITION,THEN-PART)
$(if CONDITION,THEN-PART[,ELSE-PART])
if函数的第一个参数CONDITION表示条件判断，展开后如果非空，则条件为真，执行THEN-PART部分；否则，如果有ELSE-PART部分，则执行ELSE-PART部分。
if函数的返回值即执行分支（THEN-PART或ELSE-PART）的表达式值。如果没有ELSE-PART，则返回一个空字符串。
e.g.
```makefile
.PHONY: install
install:
    @echo $(if $(install_path),$(install_path),/usr/local)
```
当我们使用make编译安装一个软件时，通常会指定一个安装路径，如果没有指定的话，则会默认安装在/usr/local目录下。
```shell
$ make install
/usr/local
$ make install install_path=/opt
/opt
```

### origin
其他函数不同，origin函数的动作不是操作变量（它的参数）。
它只是获取此变量（参数）相关的信息，告诉我们这个变量的出处（定义方式）。
如果变量没有定义，origin函数的返回值为undefined。
e.g.
```makefile
all:
	@echo $(CC)
	@echo $(origin CC)
	@echo $(MAKEFILE_LIST)
	@echo $(origin MAKEFILE_LIST)
	@echo $(PWD)
	@echo $(origin PWD)
```

### shell
如果你想在Makefile中运行shell命令，可以使用shell函数来完成这个功能。shell函数的参数是shell命令，它和反引号\`\`具有相同的功能。shell命令的运行结果即为shell函数的返回值。
e.g.
```makefile
all:
    @echo $(PWD)
    @echo $(shell pwd)
```

### error & warning
make提供了两个可以控制make运行方式的函数：error和warning。
如果这两个函数在Makefile中使用，当make执行过程中检测到某些错误，就可以给用户提供一些信息，并且可以控制make的是否继续执行下去。

#### error
$(error TEXT...)
e.g.
```makefile
all:
    @echo "make command start..."
    $(error find a error)
    @echo "make command end..."
```
当执行make命令时，make会执行默认目标all下的命令，当遇到error函数时，就会给用户一个错误提示信息，并终止make的继续执行。
```shell
$ make
Makefile:3: *** find a error.  Stop.
```

#### warning
$(warning TEXT...)
warning函数跟error函数类似，也会给用户提示信息，唯一的区别是：warning函数不会终止make的运行，make会继续运行下去。
e.g.
```makefile
all:
    @echo "make command start..."
    $(warning find a error)
    @echo "make command end..."
```
```shell
$ make
Makefile:3: find a error
make command start...
make command end...
```

### call
call函数是唯一可以用来创建新的参数化的函数。call函数不仅可以用来调用一个用户自定义函数并传参，还可以向一个表达式传参：
$(call <expression>,<parm1>,<parm2>,<parm3>...)
当make执行这个函数时，expression表达式中的参数变量，如$(1)，$(2)，$(3)等，会被参数parm1，parm2，parm3依次取代。而expression的返回值就是call函数的返回值。
e.g.
```makefile
param = $(1) $(2)
reverse_param = $(2) $(1)
str1 = $(call param,hello,zhaixue.cc)
str2 = $(call reverse_param,hello,zhaixue.cc)
all:
	@echo $(str1)
	@echo $(str2)
```

## 用户自定义函数
用户自定义函以define开头，endef结束，给函数传递的参数在函数中使用$(0)、$(1)、$(2)...引用，分别表示函数名、第1个参数、第2个参数...
对于用户自定义函数，在Makefile中要使用call函数间接调用，各个参数之间使用空格隔开。
e.g.
```Makefile
define func
    @echo "param0 = $(0)"
    @echo "param1 = $(1)"
    @echo "param2 = $(2)"
endef

all:
    $(call func,hello,makefile)
```
```shell
$ make
param0 = func
param1 = hello
param2 = makefile
```


# Others

## := VS =
定义大部分变量的时候使用的是 := 而不是 = ，它的作用是立即把定义中参考到的函数和变量都展开。如果使用 = 的话，函数和变量参考会留在那儿，就是说改变一个变量的值会导致其它变量的值也被改变。
e.g. 
```makefile
A = foo
B = $(A)
# 现在B是$(A), 而$(A)是'foo'
A = bar
# 现在B仍然是$(A), 但它的值已随着变成'bar'了

B := $(A)
# 现在B的值是'bar' 
A = foo
# B的值仍然是'bar' 
```
