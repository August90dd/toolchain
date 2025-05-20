# Rules
A simple makefile consists of "rules" with the following shape:
```
target ... : prerequisites ...
       	command
       	...
       	...
```

����ļ���Ҫ������Щ�ļ���'target'Ŀ���ļ����Ǵ���Щ����ļ���'prerequisites'�����ļ����в����ģ���ʲô���command������������������̡�
������Щ��Ϣ��make��������ϵ��ļ������Ŀ���ļ���ʱ��������ļ����ɻ򱻸Ķ�ʱ��ʱ�䣩����������һ�������ļ��ɵĻ���make��ִ����Ӧ������Ա����Ŀ���ļ���
��Ŀ���ļ���һ�������Ŀ�ִ�е������������κ�һ���ļ�����

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

make�������濪ʼ���������һ��Ŀ��fmt����Ϊ������ҪĿ�꣨һ������Ҫ��֤���������µ�����Ŀ�꣩�������Ĺ���˵��ֻҪ�ļ�fmt���ļ�fmt.o��word.o��line.o�е��κ�һ���ɣ�����һ�е�����ᱻִ�С�
�ڼ���ļ�fmt.o��word.o��line.o��ʱ���֮ǰ���������²�����Щ��fmt.o��word.o��line.o��ΪĿ���ļ��Ĺ����ҵ�����fmt.o�Ĺ����������ļ���fmt.c, word.h��line.h�����������Ҳ���������Щ�����ļ��Ĺ��򣬾Ϳ�ʼ����������Щ�����ļ���ʱ����������Щ�ļ����κ�һ����ʱ�����fmt.o���£�����'gcc -c fmt.c -o fmt.o'����ִ�У��Ӷ������ļ�fmt.o�����������ļ�word.o��line.o�����Ƶļ�飬���make���ص�fmt�Ĺ��������������������е��κ�һ����ִ�У�fmt����Ҫ�ؽ�����Ϊ����һ��.o���ͻ��fmt�£���������������ִ�С�


# Automatic Variables

    |����       |˵��                                                                   |
    |:----------|:----------------------------------------------------------------------|
    |$*         |��������չ����Ŀ���ļ�����                                             |
    |$+         |���е������ļ����Կո�ֿ������Գ��ֵ��Ⱥ�Ϊ�򣬿��ܰ����ظ��������ļ� |
    |$<         |��һ�������ļ�������                                                   |
    |$?         |���е������ļ����Կո�ֿ�����Щ�����ļ����޸����ڱ�Ŀ��Ĵ���������   |
    |$@         |Ŀ�����������                                                         |
    |$^         |���е������ļ����Կո�ֿ����������ظ��������ļ�                       |
    |$%         |���Ŀ���ǹ鵵��Ա����ñ�����ʾĿ��Ĺ鵵��Ա����                     |
    |AR         |�鵵ά����������ƣ�Ĭ��ֵΪar                                         |
    |ARFLAGS    |�鵵ά�������ѡ��                                                     |
    |AS         |����������ƣ�Ĭ��ֵΪas                                             |
    |ASFLAGS    |�������ѡ��                                                         |
    |CC         |c������������, Ĭ��ֵΪcc                                              |
    |CCFLAGS    |c��������ѡ��                                                          |


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

## ��׺����(Suffix Rules)
��׺�����Ƕ�������������Ϸ�񷽷���
��׺�������˽�һ������ĳ����׺���ļ�������.c�ļ���ת��Ϊ��������һ�ֺ�׺���ļ�������.o �ļ����ķ�����
ÿ����׺�����������ɶԳ��ֵĺ�׺�����壬���罫.c�ļ�ת��Ϊ.o�ļ��ĺ�׺����ɶ���Ϊ��
```makefile
.c.o:
	$(CC) $(CFLAGS) -c $< -o $@
```

## ģʽ����(pattern rules)
���ֹ������ͨ�ã���Ϊ��������ģʽ��������Ӹ��ӵ������Թ���
ģʽ���������ǳ�������������򣬵���Ŀ�����Ƶ�ǰ�����һ��%�ţ�ͬʱ����������Ŀ��������ļ�֮��Ĺ�ϵ�����������ģʽ����������ν�����һ��.c�ļ�ת��Ϊ.o�ļ���
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
��αĿ�ꡱ������һ���ļ���ֻ��һ����ǩ�������䲻���ļ�������make�޷���������������ϵ�;������Ƿ�Ҫִ�С�ֻ��ͨ����ʾ��ָ�������Ŀ�ꡱ����������Ч����αĿ�ꡱ��ȡ�����ܺ��ļ�����������Ȼ���ʧȥ�ˡ�αĿ�ꡱ�������ˡ�Ϊ�˱�����ļ��������������������ʹ��һ������ı�ǡ�.PHONY������ʾ��ָ��һ��Ŀ���ǡ�αĿ�ꡱ����make˵���������Ƿ�������ļ������Ŀ����ǡ�αĿ�ꡱ��

ֻҪ����������������Ƿ���clean�ļ���Ҫ����clean���Ŀ�ֻ꣬��ִ��make clean���������̿�������д��
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
ʹ�������жϣ�������make��������ʱ�Ĳ�ͬ���ѡ��ͬ��ִ�з�֧���������ʽ�����ǱȽϱ�����ֵ�����ǱȽϱ����ͳ�����ֵ��
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

����<conditional-directive>;��ʾ�����ؼ��֣�����ؼ������ĸ���
1��ifeq
    ifeq (<arg1>, <arg2>)
    �Ƚϲ���"arg1"��"arg2"��ֵ�Ƿ���ͬ

2��ifneq
	ifneq (<arg1>, <arg2>)
    �Ƚϲ���"arg1"��"arg2"��ֵ�Ƿ�ͬ�������ͬ��Ϊ�档

3��ifdef
	ifdef <variable-name>
    �������<variable-name>��ֵ�ǿգ���ô���ʽΪ�棬������ʽΪ�١�
    <variable-name>ͬ��������һ�������ķ���ֵ��
    ע�⣺ifdefֻ�ǲ���һ�������Ƿ���ֵ���䲢����ѱ�����չ����ǰλ�á�
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
    ��һ��������"$(frobozz)"ֵ��"yes"���ڶ�������"no"��

4��ifndef
	ifndef <variable-name>;
    ��"ifdef"�෴

��<conditional-directive>;��һ���ϣ�����Ŀո��Ǳ�����ģ����ǲ�����[Tab]����Ϊ��ʼ������ᱻ��Ϊ���������ע�ͷ�"#"ͬ��Ҳ�ǰ�ȫ�ġ�"else"��"endif"Ҳһ��,ֻҪ������[Tab]����ʼ���С�

ע��: make���ڶ�ȡMakefileʱ�ͼ����������ʽ��ֵ���������������ʽ��ֵ��ѡ����䣬������ò�Ҫ���Զ�����������"$@"�ȣ������������ʽ�У���Ϊ�Զ���������������ʱ���еģ�����Ϊ�˱�����ң�make������������������ֳ������ַ��ڲ�ͬ���ļ��С�


# Functions
������Ҫ��Ϊ���ࣺmake��Ƕ�������û��Զ��庯����
����make��Ƕ������ֱ�����þͿ����ˣ������û��Զ���ĺ�����Ҫͨ��make��call��������ӵ��á�
�����Ͳ����б�֮��Ҫ�ÿո�������������֮��ʹ�ö��Ÿ�����
����ڲ����������˱��������������ý���ͺ�������ʹ��ͳһ��ʽ��Ҫô��һ��С���ţ�Ҫô��һ�Դ����š�
�������ú��������ʹ�ã�Ҳ����"$"����ʶ�ģ����﷨���£�
```
	$(<function> <arguments>)
or:
	${<function> <arguments>}
```

<function>�Ǻ�������<arguments>�Ǻ����Ĳ������������Զ���","�ָ������������Ͳ���֮����"�ո�"�ָ��� 

## ��Ƕ����

### �ļ���������

#### dir
$(dir NAMES...)
dir����������һ��·�����н�ȡĿ¼�Ĳ���
e.g.
```makefile
LIST := ~/toolchain/makefile/tour.md ~/linux.kernel.archives/linux-stable/arch/x86/kernel/vmlinux.lds.S
all:
    @echo $(LIST)
    @echo $(dir $(LIST))
```

#### notdir
notdir������dir����ʵ����ȫ�෴�Ĺ��ܣ���һ���ļ�·������ȥ�ļ�����������Ŀ¼��
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
suffix������һϵ���ļ��������У�ȡ�������ļ����ĺ�׺��
�ļ����ĺ�׺���ļ������Ե�ſ�ʼ��������ţ��Ĳ��֡����ļ���û�к�׺��suffix�����򷵻ؿ��ַ�����
e.g.
```makefile
LIST := ~/toolchain/makefile/tour.md ~/linux.kernel.archives/linux-stable/arch/x86/kernel/vmlinux.lds.S
all:
    @echo $(LIST)
    @echo $(suffix $(LIST))
```

#### basename
$(basename NAMES...)
basename������һϵ���ļ��������У�ȡ�������ļ�����ǰ׺��
���һ���ļ����а��������ţ�basename�����������һ�����֮ǰ���ļ������֣����һ���ļ���û��ǰ׺���������ؿ��ַ�����
e.g.
```makefile
LIST := ~/toolchain/makefile/tour.md ~/linux.kernel.archives/linux-stable/arch/x86/kernel/vmlinux.lds.S
all:
    @echo $(LIST)
    @echo $(basename $(LIST))
```

#### addsuffix
$(addsuffix SUFFIX,NAMES...)
���ļ��б��е�ÿ���ļ������һ����׺SUFFIX
e.g.
```makefile
LIST := ~/toolchain/makefile/tour.md ~/linux.kernel.archives/linux-stable/arch/x86/kernel/vmlinux.lds.S
all:
    @echo $(LIST)
    @echo $(addsuffix .suffix,$(LIST))
```

#### addprefix
$(addprefix PREFIX,NAMES...)
���ļ��б��е�ÿ���ļ������һ��ǰ׺PREFIX
e.g.
```makefile
LIST := ~/toolchain/makefile/tour.md ~/linux.kernel.archives/linux-stable/arch/x86/kernel/vmlinux.lds.S
all:
    @echo $(LIST)
    @echo $(addprefix prefix.,$(LIST))
```

#### join
$(join LIST1,LIST2)
���ַ���LIST1���ַ���LIST2�ĸ��������������ӣ��ϲ�Ϊ�µĵ��ʹ��ɵ��ַ�����
e.g.
```makefile
LIST1 = a b c
LIST2 = .c .h .s
all:
    @echo $(LIST1)
    @echo $(LIST2)
    @echo $(join $(LIST1),$(LIST2))
```
��������ַ����еĵ��ʸ�������ȣ���ֻ�ϲ�ǰ��ĵ��ʣ�ʣ�µĵ��ʲ��ϲ���
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
�г���ǰĿ¼�����з���PATTRENģʽ���ļ���
e.g.
```makefile
all:
    @echo $(wildcard *.c)
```

#### abspath
$(abspath NAMES...)
���������·��ת���ɾ���·��
e.g.
```makefile
all:
    @echo $(abspath .)
```

### �ı�������

#### subst
$(subst old,new,text) 
�ַ����滻����, ���ַ���text�е�old�滻Ϊnew
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
patsubst��������ģʽ�滻, ʹ��ͨ��� % ����һ�������е������ַ�����PATTERN��REPLACEMENT��������������ͨ�������ʾ���߱�ʾ������ͬ�����ɸ��ַ�����ִ���滻������
e.g. 
```makefile
SRCS := $(wildcard *.c)
OBJS := $(patsubst %.c,%.o,$(SRCS))

all:
    @echo $(OBJS)
```

#### strip
strip������һ��ȥ�ո�����һ���ַ���ͨ���ж�����ʣ�����֮��ʹ��һ�������ո���зָstrip������������������Ŀ��ַ��ϲ���һ������ȥ���ַ�����ͷ��ĩβ�Ŀ��ַ������ַ��������ո񡢶���ո�tab�Ȳ�����ʾ���ַ���
e.g.
```makefile
STR =     hello a    b   c
STRIP_STR = $(strip $(STR))
all:
    @echo "$(STR)"
    @echo "$(STRIP_STR)"
```
strip�����������������ж����ı��ʽ�У�ȥ������Ŀո�����أ�ȷ�����ʽ�ȽϵĿɿ��ͽ�׳��

#### findstring
$(findstring FIND,IN)
findstring�������ַ���IN�в���FIND�ַ���������ҵ��򷵻��ַ���FIND�����򷵻ؿա�
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
filter�����������˵��ַ���TEXT�����в�����PATTERNģʽ�ĵ��ʣ�ֻ���·���PATTERN��ʽ�ĵ��ʡ�
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
filer-out������һ�������˺��������ܺ�filter����ǡǡ�෴���ú�������˵����з���PATTERNģʽ�ĵ��ʣ��������в����ϴ�ģʽ�ĵ��ʡ�
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
sort�������ַ���LIST�еĵ���������ĸΪ׼�������򣬲�ɾ���ظ��ĵ��ʡ�
e.g.
```makefile
LIST = banana pear apple peach apple orange 
all:
    @echo $(LIST)
    @echo $(sort $(LIST))
```

#### word
$(word N,TEXT)
word�����������Ǵ�һ���ַ���TEXT�У�����ָ������ĿNȡ���ʡ�
����ֵ���ַ���TEXT�еĵ�N�����ʡ����N��ֵ�����ַ����е��ʵĸ��������ؿգ����NΪ0�������
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
firstword��������ȡһ���ַ����е��׸����ʣ�firstword������ʵ���൱��$(word 1, TEXT)��
$(lastword NAMES...)
lastword��������ȡһ���ַ����е�ĩβ����
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
wordlist����������һ���ַ���TEXT��ȡ����N��M֮���һ�����ʴ���
N��M���Ǵ�1��ʼ��һ�����֣������ķ���ֵ���ַ���TEXT�д�N��M��һ�����ʴ�����N���ַ���TEXT�еĵ��ʸ�����ʱ���������ؿա�
e.g.
```makefile
LIST = banana pear apple peach orange
all:
    @echo $(LIST)
    @echo $(wordlist 1,3,$(LIST))
```

#### words
$(words TEXT)
words��������ͳ��һ���ַ���TEXT�е��ʵĸ���
e.g.
```makefile
LIST = banana pear apple peach orange
all:
    @echo $(LIST)
    @echo $(words $(LIST))
```

### foreach
$(foreach VAR,LIST,TEXT)
��LIST��ʹ�ÿո�ָ�ĵ�������ȡ������ֵ������VAR��Ȼ��ִ��TEXT���ʽ���ظ�������̣�ֱ��������LIST�е����һ�����ʡ�����ֵ��TEXT��μ���Ľ����
e.g.
```makefile
dirs = cunit emacs gcov gdb makefile strace-ltrace vim
all:
    @echo $(foreach dir,$(dirs),$(wildcard $(dir)/*.c))
```

### if
$(if CONDITION,THEN-PART)
$(if CONDITION,THEN-PART[,ELSE-PART])
if�����ĵ�һ������CONDITION��ʾ�����жϣ�չ��������ǿգ�������Ϊ�棬ִ��THEN-PART���֣����������ELSE-PART���֣���ִ��ELSE-PART���֡�
if�����ķ���ֵ��ִ�з�֧��THEN-PART��ELSE-PART���ı��ʽֵ�����û��ELSE-PART���򷵻�һ�����ַ�����
e.g.
```makefile
.PHONY: install
install:
    @echo $(if $(install_path),$(install_path),/usr/local)
```
������ʹ��make���밲װһ�����ʱ��ͨ����ָ��һ����װ·�������û��ָ���Ļ������Ĭ�ϰ�װ��/usr/localĿ¼�¡�
```shell
$ make install
/usr/local
$ make install install_path=/opt
/opt
```

### origin
����������ͬ��origin�����Ķ������ǲ������������Ĳ�������
��ֻ�ǻ�ȡ�˱�������������ص���Ϣ������������������ĳ��������巽ʽ����
�������û�ж��壬origin�����ķ���ֵΪundefined��
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
���������Makefile������shell�������ʹ��shell���������������ܡ�shell�����Ĳ�����shell������ͷ�����\`\`������ͬ�Ĺ��ܡ�shell��������н����Ϊshell�����ķ���ֵ��
e.g.
```makefile
all:
    @echo $(PWD)
    @echo $(shell pwd)
```

### error & warning
make�ṩ���������Կ���make���з�ʽ�ĺ�����error��warning��
���������������Makefile��ʹ�ã���makeִ�й����м�⵽ĳЩ���󣬾Ϳ��Ը��û��ṩһЩ��Ϣ�����ҿ��Կ���make���Ƿ����ִ����ȥ��

#### error
$(error TEXT...)
e.g.
```makefile
all:
    @echo "make command start..."
    $(error find a error)
    @echo "make command end..."
```
��ִ��make����ʱ��make��ִ��Ĭ��Ŀ��all�µ����������error����ʱ���ͻ���û�һ��������ʾ��Ϣ������ֹmake�ļ���ִ�С�
```shell
$ make
Makefile:3: *** find a error.  Stop.
```

#### warning
$(warning TEXT...)
warning������error�������ƣ�Ҳ����û���ʾ��Ϣ��Ψһ�������ǣ�warning����������ֹmake�����У�make�����������ȥ��
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
call������Ψһ�������������µĲ������ĺ�����call��������������������һ���û��Զ��庯�������Σ���������һ�����ʽ���Σ�
$(call <expression>,<parm1>,<parm2>,<parm3>...)
��makeִ���������ʱ��expression���ʽ�еĲ�����������$(1)��$(2)��$(3)�ȣ��ᱻ����parm1��parm2��parm3����ȡ������expression�ķ���ֵ����call�����ķ���ֵ��
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

## �û��Զ��庯��
�û��Զ��庯��define��ͷ��endef���������������ݵĲ����ں�����ʹ��$(0)��$(1)��$(2)...���ã��ֱ��ʾ����������1����������2������...
�����û��Զ��庯������Makefile��Ҫʹ��call������ӵ��ã���������֮��ʹ�ÿո������
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
����󲿷ֱ�����ʱ��ʹ�õ��� := ������ = �����������������Ѷ����вο����ĺ����ͱ�����չ�������ʹ�� = �Ļ��������ͱ����ο��������Ƕ�������˵�ı�һ��������ֵ�ᵼ������������ֵҲ���ı䡣
e.g. 
```makefile
A = foo
B = $(A)
# ����B��$(A), ��$(A)��'foo'
A = bar
# ����B��Ȼ��$(A), ������ֵ�����ű��'bar'��

B := $(A)
# ����B��ֵ��'bar' 
A = foo
# B��ֵ��Ȼ��'bar' 
```
