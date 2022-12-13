# NASM实现带参数和返回值的函数

> Update: 2022年12月13日12:31:30
>
> Author: 2052526 白俊豪
>
> Version: 1.0
>
> 2022 秋 汇编期末作业

<h1 align="center">
  <span style="color: red;">T</span>
  <span style="color: orange;">a</span>
  <span style="color: yellow;">b</span>
  <span style="color: green;">l</span>
  <span style="color: blue;">e</span>
  <span style="color: indigo;"> </span>
  <span style="color: purple;">O</span>
  <span style="color: pink;">f</span>
  <span style="color: red;"> </span>
  <span style="color: orange;">C</span>
  <span style="color: yellow;">o</span>
  <span style="color: green;">n</span>
  <span style="color: blue;">t</span>
  <span style="color: indigo;">e</span>
  <span style="color: purple;">n</span>
  <span style="color: pink;">t</span>
  <span style="color: red;">s</span>
</h1>

- [NASM实现带参数和返回值的函数](#nasm实现带参数和返回值的函数)
- [环境](#环境)
- [使用](#使用)
- [函数文档](#函数文档)
  - [long型两数相加](#long型两数相加)
    - [C定义](#c定义)
    - [汇编代码](#汇编代码)
    - [C测试](#c测试)
    - [实现](#实现)
      - [汇编部分](#汇编部分)
      - [注意事项](#注意事项)
        - [long型参数传递](#long型参数传递)
        - [leave指令](#leave指令)
  - [double型的数组求和](#double型的数组求和)
    - [C定义](#c定义-1)
    - [汇编代码](#汇编代码-1)
    - [C测试](#c测试-1)
    - [实现](#实现-1)
      - [汇编部分](#汇编部分-1)
      - [注意事项](#注意事项-1)
        - [参数传递](#参数传递)
        - [xmm寄存器](#xmm寄存器)
  - [strlen](#strlen)
    - [C定义](#c定义-2)
    - [汇编代码](#汇编代码-2)
    - [C测试](#c测试-2)
    - [实现](#实现-2)
      - [汇编部分](#汇编部分-2)
      - [注意事项](#注意事项-2)
        - [NULL Check](#null-check)
  - [strcpy](#strcpy)
    - [C定义](#c定义-3)
    - [汇编代码](#汇编代码-3)
    - [C测试](#c测试-3)
    - [实现](#实现-3)
      - [汇编部分](#汇编部分-3)
  - [strcmp](#strcmp)
    - [C定义](#c定义-4)
    - [汇编代码](#汇编代码-4)
    - [C测试](#c测试-4)
    - [实现](#实现-4)
      - [汇编部分](#汇编部分-4)
      - [注意事项](#注意事项-3)
        - [NULL Check](#null-check-1)
  - [Issue](#issue)
  - [参考](#参考)

# 环境
- Ubuntu 22.04
- NASM 2.15.05
- gcc 11.3.0 (Ubuntu 11.3.0-1ubuntu1~22.04)

# 使用

编译

```
make
```

运行

```
make run
```

清理

```
make clean
```

# 函数文档

## long型两数相加

### C定义

```c
long add(long a, long b)
```

### 汇编代码

```assembly
section .text
global add_long

add_long:
    ; save the base pointer and set the new base pointer to the current stack pointer
    push 	rbp
    mov 	rbp, rsp

    ; save the register rbx on the stack
    push 	rbx

    ; move the first argument from rdi to rax and the second argument from rsi to rbx
    mov		rax, rdi
    mov 	rbx, rsi 

    ; add rbx to rax, storing the result in rax
    add 	rax, rbx

    ; restore the value of rbx from the stack
    pop 	rbx

    ; restore the base pointer and return
    leave
    ret
```

### C测试

```c
void add_long_test() {
  long a = 1;
  long b = 2;
  long c = add_long(a, b);
  printf("add_long(%ld, %ld) = %ld\n", a, b, c);
}
```

```
add_long(1, 2) = 3
```

### 实现
#### 汇编部分

1. 保存基址指针并将新的基址指针设置为当前堆栈指针。
2. 将寄存器`rbx` 的值保存到堆栈上。
3. 将第一个参数从寄存器 `rdi`移动到寄存器`rax` 中，将第二个参数从寄存器`rsi`移动到寄存器 `rbx` 中。
4. 将`rbx` 加到 `rax` 中，并将结果存储在 `rax`中。
5. 从堆栈上恢复`rbx`的值。
6. 恢复基址指针并返回。

#### 注意事项

##### long型参数传递

64位汇编中，long型参数通常通过寄存器传递，并且遵循一种称为"System V AMD64 ABI"的规则。根据这个规则，前六个参数通常通过寄存器`rdi`、`rsi`、`rdx`、`rcx`、`r8`和`r9`传递。如果需要传递更多的参数，则需要将它们压入堆栈中。

> 参考文档：https://www.uclibc.org/docs/psABI-x86_64.pdf (P22)

![Register Usage](https://s2.loli.net/2022/12/13/cZuFgnCx9fJzidt.png)

##### leave指令

`leave` 指令是一条汇编语言指令，它将基址指针恢复到保存的值，并将堆栈指针设置为基址指针的值。`leave` 指令等同于执行以下操作：

1. 将堆栈指针设置为基址指针的值。
2. 将基址指针设置为基址指针保存的值。

这两个操作一起实现了从函数的子程序中恢复原始的基址指针和堆栈指针的值。它是一种常用的函数调用和返回模式。

## double型的数组求和

### C定义

```c
double sum(double[], long);
```

### 汇编代码

```assembly
global  sum
        section .text
sum:
        xorpd   xmm0, xmm0              ; initialize the sum to 0 初始化xmm0
        cmp     rsi, 0                  ; special case for length = 0 rsi计数
        je      done                    ; 计数到了，就done，退出
next:
        addsd   xmm0, [rdi]             ; add in the current array element rdi是一个偏移，用于取数组的地址, rdi默认存储的是数组的首地址
        add     rdi, 8                  ; move to next array element rdi 增加一个偏移
        dec     rsi                     ; count down 计数减少
        jnz     next                    ; if not done counting, continue
done:
        ret                             ; return value already in xmm0
```

### C测试

```c
void double_sum_test() {
  double d[] = {1.0, 2.0, 3.0};
  double e = sum(d, 3);
  printf("sum([1.0, 2.0, 3.0], 3) = %f\n", e);
}
```

```
sum([1.0, 2.0, 3.0], 3) = 6.000000
```

### 实现

#### 汇编部分

1. 将寄存器`xmm0`的值设为 0（初始化）
2. 如果`rsi` 为 0，则执行 done 标签，结束程序
3. 将寄存器`xmm0`的值加上当前数组元素的值
4. 将`rdi`增加 8，以便访问下一个数组元素
5. 将`rsi`的值减 1，表示已经处理了一个元素
6. 如果`rsi`不为 0，则继续执行 next 标签，处理下一个数组元素
7. 如果`rsi`为 0，则执行 done 标签，结束程序。返回值存储在`xmm0` 中

#### 注意事项

##### 参数传递

第一个参数`double []`通过`rdi`传递，`rdi`存储的是数组的首地址，所以使用[rdi]取出内存地址为`rdi`的数据，间接寻址

第二个参数`int`通过`rsi`传递，表示需要累加的数量

##### xmm寄存器

在 x86 架构下，xmm 寄存器被用于存储双精度浮点数。xmm 寄存器具有 128 位宽度，可以存储 8 个字节，即一个双精度浮点数，或两个单精度浮点数。因为 double 类型是双精度浮点数，所以它可以直接存储在 xmm 寄存器中

![AVX_registers](https://s2.loli.net/2022/12/13/rWFp5IkvbaBODTJ.png)

## strlen

### C定义

```c
size_t strlen(const char *s);
```

### 汇编代码

```assembly
; strlen - find the length of a null-terminated string
;
; inputs:
;   rdi - pointer to the null-terminated string
;
; output:
;   rax - the length of the string, not including the null terminator

global strlen

strlen:
    xor rax, rax        ; initialize length to 0
    .loop:
        cmp byte [rdi + rax], 0
        je .done          ; if null terminator, exit loop
        inc rax           ; increment length
        jmp .loop         ; continue to next character
    .done:
    ret                  ; return the length
```

### C测试

```c
void strlen_test() {
  char *s = "Hello, world!";
  size_t len = strlen(s);
  printf("strlen(\"%s\") = %zu\n", s, len);
}
```

```
strlen("Hello, world!") = 13
```

### 实现

#### 汇编部分

1. 定义`strlen`为全局符号
2. 初始化`rax`为0
3. 比较地址为`rdi + rax`的字节与0，并将结果存储在标志寄存器中
4. 如果标志寄存器为等于，则跳转到`.done`
5. 增加`rax`的值
6. 跳转到`.loop`
7. 返回`rax`的值

#### 注意事项

##### NULL Check

在调用strlen函数之前要先检查输入的参数是否是NULL，否则可能会出现`segmentation fault`

## strcpy

### C定义

```c
char *strcpy(char *dest, const char *src);
```

### 汇编代码

```assembly
; strcpy - copy a null-terminated string
;
; inputs:
;   rdi - pointer to destination string
;   rsi - pointer to source string
;
; output:
;   rax - pointer to destination string

global strcpy

strcpy:
    xor rax, rax        ; initialize index to 0
    .loop:
        cmp byte [rsi + rax], 0
        je .done          ; if null terminator, exit loop
        mov rbx, [rsi + rax] ; use rbx as temporary register
        mov [rdi + rax], rbx  ; copy character
        inc rax           ; increment index
        jmp .loop         ; continue to next character
    .done:
        mov byte [rdi + rax], 0  ; append null terminator
        mov rax, rdi       ; return pointer to destination string
    ret
```

### C测试

```c
void strcpy_test() {
  char *s = "Hello, world!";
  char buf[100];
  strcpy(buf, s);
  printf("strcpy(\"%s\") = \"%s\"\n", s, buf);
}
```

```
strcpy("Hello, world!") = "Hello, world!"
```

### 实现

#### 汇编部分

1. 定义`strcpy`为全局符号
2. 初始化`rax`为0
3. 比较地址为`rsi + rax`的字节与0，并将结果存储在标志寄存器中
4. 如果标志寄存器为等于，则跳转到`.done`
5. 将地址为`rsi + rax`的值赋值给`rbx`
6. 将`rbx`的值赋值给地址为`rdi + rax`的位置
7. 增加`rax`的值
8. 跳转到`.loop`
9. 在地址为`rdi + rax`的位置填充0
10. 将`rdi`的值赋值给`rax`
11. 返回`rax`的值

## strcmp

### C定义

```c
int strcmp(const char *a, const char *b);
```

### 汇编代码

```assembly
global strcmp

strcmp:
    ; check for null pointers
    cmp rdi, 0
    jz .null_str1
    cmp rsi, 0
    jz .null_str2

    ; initialize variables
    mov r8, rsi  ; r8 = str1
    mov r9, rdi  ; r9 = str2
    xor rcx, rcx ; rcx = 0 (index for comparing characters)

    ; compare characters from str1 and str2
    .compare_loop:
        cmp cl, dl      ; have we reached the end of either string?
        jge .done       ; if yes, then done

        mov al, [r8+rcx]    ; load character from str1
        mov bl, [r9+rcx]    ; load character from str2
        cmp al, bl          ; compare characters
        jne .done           ; if not equal, then done

        inc rcx             ; increment index

        jmp .compare_loop

    ; return result of comparison
    .done:
        mov rax, rcx
        ret

    ; return 0 if str1 is null
    .null_str1:
        xor rax, rax
        ret

    ; return -1 if str2 is null
    .null_str2:
        mov rax, -1
        ret
```

### C测试

```c
// ? 输出有时候为0，有时候为7
void strcmp_test() {
  char s1[] = "hello!";
  char s2[] = "hello!";
  int ret = strcmp(s1, s2);
  printf("strcmp(\"%s\",\"%s\") = %d\n", s1, s2, ret);
}
```

```
strcmp("hello!","hello!") = 0
```

### 实现

#### 汇编部分

1. 定义`strcmp`符号为全局标签。
2. 检查`rdi`是否为0，如果是，则转到`.null_str1`标签
3. 3. 检查`rsi`是否为0，如果是，转到`.null_str2`标签
4. 设置`r8`为`rsi`的值(`r8`现在将指向`str1`)
5. 将`r9`设置为`rdi`的值(`r9'现在将指向`str2`)
6. 设置`rcx`为0(`rcx`将被用作比较字符的索引)
7. 通过比较`cl`中的值和`dl`中的值来比较`str1`和`str2`的长度，如果它们相等或更大，进入`.done`标签
8. 将`str1`中当前索引的字符加载到`al`中
9. 将`str2`当前索引的字符加载到`b1`中
10. 比较`al`和`bl`中的字符，如果它们不相等，转到`.done`标签
11. 递增`rcx`中的索引
12. 跳回`.compare_loop`标签来比较下一组字符
13. 通过将`rax`置为`rcx`值并从`strcmp`函数返回比较的结果
14. 如果`str1`为空，通过将`rax`设置为0并从`strcmp`函数返回，返回0
15. 如果`str2`为空，通过将`rax`设置为-1并从`strcmp'函数返回，返回-1

#### 注意事项

##### NULL Check

`strcmp`的汇编实现中已经对null进行了处理

## Issue

[strcmp](#strcmp)测试代码有时输出7，有时输出0，原因未知，可能是调用的时候寄存器的问题

## 参考

1. https://wiki.osdev.org/System_V_ABI
2. https://www.uclibc.org/docs/psABI-x86_64.pdf
3. https://commons.wikimedia.org/wiki/File:AVX_registers.svg