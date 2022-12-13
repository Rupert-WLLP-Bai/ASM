# 8253计时器

> Update: 2022年12月14日00:17:17
>
> Author: 2052526 白俊豪
>
> Version: 1.0
>
> 2022 秋 汇编期末作业 8253计时器

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

- [8253计时器](#8253计时器)
  - [8253的控制字](#8253的控制字)
  - [8253的初始化](#8253的初始化)
  - [主要代码](#主要代码)
  - [效果](#效果)
  - [Issue](#issue)

## 8253的控制字

![img](https://s2.loli.net/2022/12/14/NdA3nEBRSTjmfto.jpg)

![image-20221213231822741](https://s2.loli.net/2022/12/14/kp81oxTdRQ2MuXE.png)

## 8253的初始化

在MASM中实现8253计时器的初始化，需要执行以下步骤：

1. 使用特殊的端口地址访问8253计时器，这些地址在8086汇编中定义为常量。
2. 使用适当的控制字节设置计时器的工作方式，包括计数器选择、工作模式和计数器触发方式。
3. 向计时器的数据端口写入计数器初值，以设定计时器计数的开始值。

以下是一些代码例子：

```assembly
Copy code; Set the control word register (0x43) to configure the 8253
; for mode 0, with a binary count and no gate input
mov al, 00110000b ; Control word value
out 0x43, al      ; Write control word to 8253

; Set the desired frequency and duration of the output pulses
; by writing to the corresponding counter registers (0x40, 0x41, 0x42)
; For example, to generate a 1 kHz pulse with a duration of 1 second:
mov al, 0x00      ; Low byte of counter value (1,000)
out 0x40, al      ; Write low byte to counter 0
mov al, 0x03      ; High byte of counter value (1,000)
out 0x40, al      ; Write high byte to counter 0

; The 8253 is now initialized and ready to generate output pulses
; at the specified frequency and duration.
```

## 主要代码

```assembly
START:            
                      JMP    INIT                        ; INIT
    S1:               
                      CALL   CLS                         ; CLEAR THE SCREEN
                      CALL   TIMER_INIT                  ; INIT TIMER
                      CALL   SHOW_TIME                   ; SHOW TIME
    INT_SET:          
                      PUSH   AX
                      MOV    AL,00110110B                ;设置通道0的方式3
                      OUT    43H,AL                      ;输出控制字
                      MOV    AL, LOW(11932)        ;设置通道0的计数值
                      OUT    40H,AL                      ;输出计数值
                      MOV    AL, HIGH(11932)       ;设置通道0的计数值
                      OUT    41H,AL                      ;输出计数值
                      POP    AX
    TIMING:           
                      MOV    DX,100                      ;初始化为0
    RE:               
                      IN     AL, 40H
                      CMP    AL,0
                      JE     SET_TIME
    SHOW:             
                      CALL   SHOW_TIME                   ;显示时间
                      JMP    RE
    DO_ESC:           
                      JMP    EXIT
```

## 效果

![image-20221214003720497](https://s2.loli.net/2022/12/14/Iba5XBRgltHw27y.png)

## Issue

1. 实际上的延时不到1s，参考了[timer-demo](timer-demo.asm)的实现，未成功解决。