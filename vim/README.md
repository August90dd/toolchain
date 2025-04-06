PART1: Using
------------

## 1. about save && exit
    :wq!    强制保存退出
    :wq     保存退出(:x 与此功能相同)
    :q      退出
    :q!     强制退出

## 2. about move
    k   光标向上移动一个字符
    j   光标向下移动一个字符
    h   光标向左移动一个字符
    l   光标向右移动一个字符

    w   光标移至下一个单词的开头
    b   光标移至上一个单词的开头
    e   光标移至下一个单词的词尾

    :n  将光标定位到第n行

    0   将光标定位到本行的行首
    $   将光标定位到本行的行尾

    gg  将光标定位到文件第一行
    G   将光标定位到文件最后一行

    H   将光标定位到屏幕的顶端
    M   将光标定位到屏幕的中间
    L   将光标定位到屏幕的底端

## 3. about search
    /   后面跟要查找的东西, 在文件中向前搜索
    ?   后面跟要查找的东西, 在文件中向后搜索
    n   向前重复搜索
    N   向后重复搜索

## 4. about cp
    yy  复制光标当前行
    nyy 复制光标当前行到当前行以下的n-1行

## 5. about paste
    p   粘贴到当前行的下一行
    P   粘贴到当前行的上一行

## 6. about delete
    dd  删除当前行
    ndd 删除光标当前行到当前行以下的n-1行

    x   删除一个字符

    dG  删除当前光标到文件末尾的所有内容

    d0  删除当前光标到本行行首的所有内容
    d$  删除当前光标到本行行尾的所有内容

    :1,100d 删除1~100行
    :100d   删除第100行

    :g/^$/d 删除文件中空行

## 7. about insert
    i   在当前位置的字符前面进入插入模式
    I   在当前行的开头进行插入
    a   在当前位置的字符后面进入插入模式
    A   在当前行的结尾进行插入
    o   在当前行下面打开一个新行进行插入
    O   在当前行上面打开一个新行进行插入

## 8. about undo
    u       撤销上一次的更改
    Ctrl+r  撤消最近一次撤消操作

## 9. about replace
    (regexp是要匹配的式样, replacement是要替换的字符串)
    :s/regexp/replacement  	    替换当前行出现的第一个式样
    :s/regexp/replacement/g	    替换当前行所有的匹配
    :%s/regexp/replacement/g    替换文件中所有匹配式样

## 10. about commit
    多行注释:
	1) 首先按esc进入命令行模式下, 按下Ctrl+v, 进入列(也叫区块)模式;
	2) 在行首使用上下键选择需要注释的多行;
	3) 按下键盘"I"键, 进入插入模式;
	4) 然后输入注释符("//", "#"等);
	5) 最后按下"Esc"键.
	注: 在按下esc键后, 需稍等一会才会出现注释.
 
    删除多行注释:
	1) 首先按esc进入命令行模式下, 按下Ctrl+v, 进入列模式;
	2) 选定要取消注释的多行;
	3) 按下"x"或者"d".
	注: 如果是"//"注释, 那需要执行两次该操作, 如果是"#"注释, 一次即可.

## 11. about split screen
    Ctrl+w, s   水平分割窗口(:split)
    Ctrl+w, v   垂直分割窗口(:vsplit)
    :qa         关闭所有窗口

## 12. about roll screen
    Ctrl+g  查看光标当前的位置状态

    Ctrl+f  屏幕向下滚动一屏
    Ctrl+b  屏幕向上滚动一屏

    Ctrl+e  屏幕向下滚动一行
    Ctrl+y  屏幕向上滚动一行

    Ctrl+d  屏幕向下滚动半屏
    Ctrl+u  屏幕向上滚动半屏


PART2: Plugin
-------------
## Manage with Vundle(See .vimrc)
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    然后进入vim执行	:PluginInstall

## cscope
    0) INSTALL cscope

    1) cd src; cscope-indexer -r

    2) cscope find用法:
    :cs f(ind) s|g|d|c|t|e|f|i name 
    |command    |说明                               |快捷键     |
    |:----------|:----------------------------------|:----------|
    |s          |查找符号                           |ctrl-\ s   |
    |g          |查找全局的定义                     |ctrl-\ g   |
    |d          |查看指定函数调用了哪些函数         |ctrl-\ d   |      
    |c          |查看指定函数被哪些函数所调用       |ctrl-\ c   |
    |t          |查找字符串                         |ctrl-\ t   |
    |e          |查找正则表达式(egrep模式)          |ctrl-\ e   |
    |f          |查找文件                           |ctrl-\ f   |
    |i          |查看指定的文件被哪些文件include    |ctrl-\ i   |

    3) ctrl+o  回到上次位置

    4) ctrl+i  前进
