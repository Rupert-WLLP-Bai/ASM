- [NASM实现带参数和返回值的函数](#nasm实现带参数和返回值的函数)
  - [long型两数相加](#long型两数相加)
    - [C定义](#c定义)
    - [汇编代码](#汇编代码)
    - [C测试](#c测试)
    - [实现](#实现)
      - [汇编部分](#汇编部分)
      - [注](#注)
        - [long型参数传递](#long型参数传递)
        - [leave指令](#leave指令)
  - [double型的数组求和](#double型的数组求和)
    - [C定义](#c定义-1)
    - [汇编代码](#汇编代码-1)
    - [C测试](#c测试-1)
    - [实现](#实现-1)
      - [汇编部分](#汇编部分-1)
      - [注意事项](#注意事项)
  - [strlen](#strlen)
    - [C定义](#c定义-2)
    - [汇编代码](#汇编代码-2)
    - [C测试](#c测试-2)
    - [实现](#实现-2)
      - [汇编部分](#汇编部分-2)
      - [注意事项](#注意事项-1)
  - [strcpy](#strcpy)
    - [C定义](#c定义-3)
    - [汇编代码](#汇编代码-3)
    - [C测试](#c测试-3)
    - [实现](#实现-3)
      - [汇编部分](#汇编部分-3)
      - [注意事项](#注意事项-2)
  - [strncpy](#strncpy)
    - [C定义](#c定义-4)
    - [汇编代码](#汇编代码-4)
    - [C测试](#c测试-4)
    - [实现](#实现-4)
      - [汇编部分](#汇编部分-4)
      - [注意事项](#注意事项-3)

> Update: 2022年12月13日01:15:16

# NASM实现带参数和返回值的函数

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
2. 将寄存器` rbx` 的值保存到堆栈上。
3. 将第一个参数从寄存器 `rdi `移动到寄存器` rax` 中，将第二个参数从寄存器` rsi `移动到寄存器 `rbx` 中。
4. 将` rbx` 加到 `rax` 中，并将结果存储在 `rax `中。
5. 从堆栈上恢复` rbx `的值。
6. 恢复基址指针并返回。

#### 注

##### long型参数传递

64位汇编中，long型参数通常通过寄存器传递，并且遵循一种称为"System V AMD64 ABI"的规则。根据这个规则，前六个参数通常通过寄存器`rdi`、`rsi`、`rdx`、`rcx`、`r8`和`r9`传递。如果需要传递更多的参数，则需要将它们压入堆栈中。

##### leave指令

`leave` 指令是一条汇编语言指令，它将基址指针恢复到保存的值，并将堆栈指针设置为基址指针的值。`leave` 指令等同于执行以下操作：

1. 将堆栈指针设置为基址指针的值。
2. 将基址指针设置为基址指针保存的值。

这两个操作一起实现了从函数的子程序中恢复原始的基址指针和堆栈指针的值。它是一种常用的函数调用和返回模式。

## double型的数组求和

### C定义

```c
```

### 汇编代码

```assembly

```

### C测试

```c
```

```

```

### 实现

#### 汇编部分

#### 注意事项

## strlen

### C定义

```c

```

### 汇编代码

```assembly

```

### C测试

```c

```

```

```

### 实现

#### 汇编部分

#### 注意事项

## strcpy

### C定义

```c

```

### 汇编代码

```assembly

```

### C测试

```c

```

```

```

### 实现

#### 汇编部分

#### 注意事项

## strncpy

### C定义

```c

```

### 汇编代码

```assembly

```

### C测试

```c

```

```

```

### 实现

#### 汇编部分

#### 注意事项