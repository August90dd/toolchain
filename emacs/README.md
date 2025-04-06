CHAPTER 1: Quick start
====================== 

1. Key Note
    C: CTRL key
    M: ESC or ALT key

2. Cursor Navigation
    1) C-p : previous
    2) C-n : next
    3) C-b : backward
    4) C-f : forward
    5) C-e : go to the end of a line
    6) C-a : go to the start of a line
    7) M-> : go to the end of a file
    7) M-< : go to the top of a file
    8) C-v : go one screen down
    9) M-v : go one screen up
    10) C-j : new line
    11) M-g : go to the appoint line

3. Files & Buffers
    1) go to a file: 
        C-x C-f <file name> 
        (pressing the tab key invokes auto completion) 
    2) insert a File:
	    C-x i 
    3) save a file:
	    C-x C-s
    4) list the whole buffers:
	    C-x C-b
    5) go to the corresponding buffer:
	    C-x b buffer_name
    6) save the whole buffers (all opened files):
	    C-x s
    7) kill the current buffer:
        C-x k

4. Multiple Windows
    1) make other windows go away:
        C-x 1
    2) split screen into 2 horizontal windows:
        C-x 2
    3) split screen into 2 vertical windows:
        C-x 3
    4) move cursor to the next window:
        C-x o
    5) 在一个窗格中编辑, 想用另一个窗格作参考的时候,
        可以保持光标始终处于编辑窗格中, 然后用 C-M-v 和 C-M-V
        命令在另外一个窗格里滚动.
        C-M-v : go one screen down
        C-M-V : go one screen up

5. Hardcore
    1) undo what you just did:
        C-x u
    2) abort a command: 
        C-g
    3) quit emacs:
        C-x C-c

6. Managing Blocks Of Text
    1) delete to the end of a line:
        C-k	
    2) delete a character:
        C-d
    3) copy & cut & paste:
        * mark a block of text:
        1. C-<spacebar> at the top of your selection.
        2. Move cursor beneath the region you want to "select".
        * cut 	: C-w
        * copy 	: M-w
        * paste : C-y

7. Searching & Replacing
    1) search forward: 
        C-s (repeat forward search) 
    2) search backward:
        C-r (repeat backward search)
    3) replace: 
        M-x replace-string <search string> <RETURN> <replace string> <RETURN>

8. Help
    1) C-h k : 查看键盘键值对应的命令或作用
    2) C-h w : 查看命令所对应的键值
    3) C-h v : 查看变量的含义
    4) C-h t : 运行emacs教程
    5) C-h i : 在emacs中启动文档查看器

9. Bookmark
    1) C-x r m : 在当前光标位置设置书签
    2) C-x r b : 跳到书签指示的位置
    3) C-x r l : 列出书签清单

10. Start Tools
    1) M-x eshell : get a emacs shell.

11. Others
    1) M-; : insert a commit
    2) repeat:  
        为一个命令指定数字参数(重复次数)的方法是: 先输入 C-u,
        然后输入数字作为参数, 最后再输入命令.  
        (C-v 和 M-v 则属于另一种类型的例外.
        当给定一个参数时, 它们将滚动指定的"行数", 而不是"屏数".
        举例来说, C-u 8 C-v 将屏幕向下滚动8行, 而不是8屏.)


CHAPTER 2: Install template for emacs
=====================================

1. Download the template package
--------------------------------
    http://emacs-template.sourceforge.net/.
 
2. Install the template
-----------------------
    1) Copy the lisp file
    $ cp template/lisp/template.el /usr/share/emacs/site-lisp/ 

    2) Copy the templates files
    $ mkdir ~/.templates
    $ cp template/templates/* ~/.templates/

3. Set .emacs
-------------
    (require 'template)
    (template-initialize)
 
4. How to create a template
---------------------------
    1) Start emacs
    $ emacs &

  	2) Open a old template
    Edit--> Template Create -->Open template
    Display the information in minibuffer:
        Open template file: ~/.templates/
    Input README.tpl
        Open template file: ~/.templates/README.tpl

    3) Save as a new template
    File-->Save Buffer As... or C+c C+w
    Display the information in minibuffer:
        Write file: ~/emacs/
    Input readme.tpl
        Write file: ~/emacs/readme.tpl

    4) Edit the readme.tpl
    Edit-->Template Creation...
    Chooice some MACRO.	


CHAPTER 3: Install windows line toolbar for emacs
=================================================

1. Install the wbline
---------------------
    $ cp wbline/wb-line-number.el /usr/share/emacs/site-lisp/ 
 
2. Set .emacs
-------------
    (set-scroll-bar-mode nil) 
    (require 'wb-line-number)
    (wb-line-number-toggle)


CHAPTER 4: Advanced operation for C/C++ program
===============================================

1. Compile
----------
    save the current buffer, and run make:
        F5
    run make:
        C-F5
  
2. GDB
------
    F8 : run gdb
    click middle button of mouse to jump to error line.

3. Entry Manual
---------------
    C-F1 : Entry manual, input the function
 
4. Enter CVS mode
-----------------
    C-F3 : Entry CVS mode

5. TAGS operation
-----------------
    load a tags file:
        F7 
    find a definition by TAGS in another windows:
        M-. 
    close another windows:
        M-, 
    find a definition by TAGS in current windows:
        C-.
    close the information windows:
        C-,


CHAPTER 5: Etags
================

    etags *.[ch] */*
    find ./ -name '*.[ch]' -exec etags -a {} \;


CHAPTER 6: cscope
=================

1. Set .emacs
-------------
    (require 'xcscope)

2. Keybindings
--------------
All keybindings use the "C-c s" prefix, but are usable only while
editing a source file, or in the cscope results buffer:

    C-c s s         Find symbol.
    C-c s d         Find global definition.
    C-c s g         Find global definition (alternate binding).
    C-c s G         Find global definition without prompting.
    C-c s c         Find functions calling a function.
                    (看看指定函数被哪些函数所调用)
    C-c s C         Find called functions (list functions called from a function).
                    (看看指定函数调用了哪些函数)
    C-c s t         Find text string.
    C-c s e         Find egrep pattern.
                    (寻找正则表达式)
    C-c s f         Find a file.
    C-c s i         Find files #including a file.
                    (看看指定的文件被哪些文件include)

These pertain to navigation through the search results:

    C-c s b         Display *cscope* buffer.
    C-c s B         Auto display *cscope* buffer toggle.
    C-c s n         Next symbol.
    C-c s N         Next file.
    C-c s p         Previous symbol.
    C-c s P         Previous file.
    C-c s u         Pop mark.

These pertain to setting and unsetting the variable,
`cscope-initial-directory', (location searched for the cscope database directory):

    C-c s a         Set initial directory.
    C-c s A         Unset initial directory.

These pertain to cscope database maintenance:

    C-c s L         Create list of files to index.
    C-c s I         Create list and index.
    C-c s E         Edit list of files to index.
    C-c s W         Locate this buffer's cscope directory
                    ("W" --> "where").
    C-c s S         Locate this buffer's cscope directory.
                    (alternate binding: "S" --> "show").
    C-c s T         Locate this buffer's cscope directory.
                    (alternate binding: "T" --> "tell").
    C-c s D         Dired this buffer's directory.
