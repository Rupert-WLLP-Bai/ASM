DATAS SEGMENT
    SINPUT     DB 'Please enter hours, minutes, and seconds with spaces: $'
    SOUTPUT    DB 'Any key to again and ESC to return. Now time is : $'
    BUF1       DB 20H
               DB 0
               DB 20H DUP(0)
    TIMEHOUR   DW 23
    TIMEMINUTE DW 56
    TIMESECOND DW 45
    NUM        DW ?
DATAS ENDS

STACKS SEGMENT PARA STACK
           DW 30H DUP(0)
STACKS ENDS

CODES SEGMENT

                ASSUME CS:CODES,DS:DATAS,SS:STACKS
    START:      
                MOV    AX,DATAS
                MOV    DS,AX
	
                MOV    AL,11111101B                   ;关定时器中断
                OUT    21H,AL                         ;中断屏蔽寄存器数据传回去
	
                PUSH   DS                             ;保存数据段地址
                MOV    AX,SEG INT08H                  ;SEG取得标号的段地址
                MOV    DS,AX                          ;获得08H号中断的段地址，放在中断向量中
                MOV    DX, OFFSET INT08H              ;获得08H号中断的偏移地址，放在中断向量中
                MOV    AL,08H                         ;设置中断号
                MOV    AH,25h                         ;设置中断向量
                int    21h                            ;调用系统dos中断
                POP    DS                             ;恢复数据段地址
	
                MOV    AL,00110110B                   ;设置通道0的方式3
                OUT    43H,AL                         ;输出控制字，43H是8253定时器芯片的控制寄存器地址
                MOV    AX,11932                       ;定时器的时钟频率为1.1931817MHz,计数初值=1193182/100，10ms中断一次
                OUT    40H,AL                         ;40H为计数器地址
                MOV    AL,AH                          ;先输出低位，再输出高位
                OUT    40H,AL                         ;40H为计数器地址
    TIMING:     
    ;换行
                MOV    DL,0DH                         ;CR
                MOV    AH,2                           ;显示一个字符
                INT    21H                            ;调用系统dos中断
                MOV    DL,0AH                         ;LF
                MOV    AH,2                           ;显示一个字符
                INT    21H                            ;调用系统dos中断
 	
                MOV    AH,09H                         ;显示字符串
                LEA    DX,SINPUT                      ;取段内偏移地址
                INT    21H                            ;调用系统dos中断
   
                MOV    AH,0AH                         ;键盘输入到缓冲区
                LEA    DX,BUF1                        ;取段内偏移地址
                INT    21H                            ;调用系统dos中断
                CALL   INPUTTIME                      ;调用子程序处理字符串
    
                MOV    AH,09H                         ;显示字符串
                LEA    DX,SOUTPUT                     ;取段内偏移地址
                INT    21H                            ;调用系统dos中断
    
                MOV    DX,100                         ;初始化为0
                MOV    AL,11111100B                   ;开键盘和定时器中断
                OUT    21H,AL                         ;中断屏蔽寄存器数据传回去

    RE:         
                MOV    AH,08H                         ;无回显键盘输入到AL
                INT    21H                            ;调用系统dos中断
    ;MOV AH,0;
    ;MOV NUM,AX;
    
    ;MOV AH,03H;获取光标位置信息
    ;INT 10H;BIOS中断
    ;ADD DL,10;
    ;MOV BH,0;显示到第一页
    ;MOV AH,02H;设置光标位置
    ;INT 10H;BIOS中断
    ;CALL SHOWNUM
                CMP    AL,27                          ;按键是否ESC
                JE     DO_ESC                         ;是退出
                CMP    AL,252                         ;按键是否是奇怪的那个字符
                JE     RE                             ;是奇怪的，循环
    
    ;MOV AH,0BH;检测键盘状态，有输入AL=00,无输入AL=FF
    ;INT 21H;调用系统dos中断
    ;CMP AL,0FFH;判断按键无输入
    ;JE RE;确实无输入，重复
 
                MOV    AL,11111101B                   ;关定时器中断
                OUT    21H,AL                         ;中断屏蔽寄存器数据传回去
                JMP    TIMING                         ;不是就重新对时
    DO_ESC:     
                MOV    AL,11111101B                   ;关定时器中断
                OUT    21H,AL                         ;中断屏蔽寄存器数据传回去
    ;退出代码
                MOV    AH,4CH
                INT    21H
    
    ;这是一段子程序，用来输入数字
INPUTTIME PROC
    ;初始化
                MOV    DX,0
                MOV    BX,10
                MOV    SI,2
                MOV    NUM,0
                MOV    AX,0
                MOV    CX,0                           ;
    LOP:        
                MOV    AL,BUF1[SI]                    ;寄存器相对寻址，从缓冲区取一个字符
                CMP    AL,0DH                         ;是否是CR
                JE     FINAL                          ;等于就跳转，JNE相反
                SUB    AL,30H                         ;减48，从ASCII码转数字
                CMP    NUM,0                          ;与0比较，相当于判断初始化
                JE     DO_DEAL                        ;等于就跳转，JNE相反
                PUSH   AX                             ;当前数字压入栈中
                MOV    AX,NUM                         ;当前数送入运算寄存器中
                MUL    BX                             ;隐含寻址，在AX中，相当于NUM乘以10
                MOV    NUM,AX                         ;运算结果存进NUM中
                POP    AX                             ;之前的数据弹出
    DO_DEAL:    
                ADD    NUM,AX                         ;加上之前的数据
                MOV    AX,0                           ;清零
                INC    SI                             ;自加1
                MOV    AL,BUF1[SI]                    ;寄存器相对寻址，从缓冲区取一个字符
                CMP    AL,' '                         ;是否是空格
                JE     DO_SPACE                       ;等于就跳转，JNE相反
                JMP    LOP                            ;跳转，处理下一个
    DO_SPACE:   
                INC    SI                             ;偏移量再自加1，跳过空格
                MOV    DX,NUM                         ;把NUM存起来
                MOV    NUM,0                          ;原先数清零
                INC    CX                             ;标志自加1
                CMP    CX,1                           ;与1比较，判断是不是时
                JE     HOUR                           ;等于就跳转，JNE相反
                CMP    CX,2                           ;与2比较，判断是不是分
                JE     MINUTE                         ;等于就跳转，JNE相反
                JMP    LOP                            ;跳转，处理下一个
    HOUR:       
                MOV    TIMEHOUR,DX                    ;把时传送到变量
                JMP    LOP                            ;跳转，处理下一个
    MINUTE:     
                MOV    TIMEMINUTE,DX                  ;把分钟传送到变量
                JMP    LOP                            ;跳转，处理下一个
    FINAL:      
                MOV    DX,NUM                         ;把NUM存起来
                MOV    TIMESECOND,DX                  ;把秒传送到变量
    ;换行
                MOV    DL,0DH                         ;CR
                MOV    AH,2                           ;显示一个字符
                INT    21H                            ;调用系统dos中断
                MOV    DL,0AH                         ;LF
                MOV    AH,2                           ;显示一个字符
                INT    21H                            ;调用系统dos中断
                RET                                   ;子程序退出重置堆栈
INPUTTIME ENDP


    ;这是一段子程序，用来显示数字NUM
SHOWNUM PROC
    ;其实正常这里显示不到第一位，懒得改了
                MOV    BL,100                         ;%先除100
                MOV    AX,NUM                         ;送入运算寄存器
                DIV    BL                             ;除法，AX隐含寻址
                ADD    AL,30H                         ;商转换为ASCII码
                PUSH   AX                             ;将余数先压入栈中
                CMP    AL,30H                         ;看一看首位是不是0
                JE     BITTWO                         ;若是，则不显示直接跳转到下一个
                MOV    DL,AL                          ;传送字符
                MOV    AH,2                           ;显示一个字符
                INT    21H                            ;调用系统dos中断
    BITTWO:     
                POP    AX                             ;将余数取出
	
    ;第二位
                MOV    AL,AH                          ;送入运算寄存器
                MOV    AH,0                           ;高位清零
                MOV    BL,10                          ;%再除以10
                DIV    BL                             ;除法，AX隐含寻址
                ADD    AL,30H                         ;商转换为ASCII码
                PUSH   AX                             ;将余数先压入栈中
                MOV    DL,AL                          ;传送字符
                MOV    AH,2                           ;显示一个字符
                INT    21H                            ;调用系统dos中断
                POP    AX                             ;将余数取出
 	
    ;第三位
                ADD    AH,30H                         ;余数转换为ASCII码
                MOV    DL,AH                          ;传送字符
                MOV    AH,2                           ;显示一个字符
                INT    21H                            ;调用系统dos中断
                RET                                   ;子程序退出重置堆栈
SHOWNUM ENDP

INT08H PROC NEAR                                      ;08H计数器中断
    ;保护现场
                PUSH   AX
                PUSH   BX
                PUSH   CX
                CMP    DX,100                         ;;计数达到100，执行一次，相当于1s一次
                JGE    COUNT                          ;大于等于100就跳转
                JMP    ENDINT                         ;没达到就结束中断响应
    COUNT:      
                MOV    DX,0                           ;计数值清零
                PUSH   DX                             ;保存计数值
                MOV    AH,03H                         ;获取光标位置信息
                INT    10H                            ;BIOS中断
                PUSH   DX                             ;将获得的信息压入栈中
                MOV    AX,TIMEHOUR                    ;传送指令
                MOV    NUM,AX                         ;传送指令
                CALL   SHOWNUM                        ;调用子程序显示数字
                MOV    DL,':'
                MOV    AH,2                           ;显示一个字符
                INT    21H                            ;调用系统dos中断
                MOV    AX,TIMEMINUTE                  ;传送指令
                MOV    NUM,AX                         ;传送指令
                CALL   SHOWNUM                        ;调用子程序显示数字
                MOV    DL,':'
                MOV    AH,2                           ;显示一个字符
                INT    21H                            ;调用系统dos中断
                MOV    AX,TIMESECOND                  ;传送指令
                MOV    NUM,AX                         ;传送指令
                INC    AX                             ;秒数自加1
                MOV    TIMESECOND,AX                  ;传送指令
                CALL   SHOWNUM                        ;调用子程序显示数字
                POP    DX                             ;将之前的光标信息从栈中取出
                MOV    BH,0                           ;显示到第一页
                MOV    AH,02H                         ;设置光标位置
                INT    10H                            ;BIOS中断
                POP    DX                             ;
	
    ;进位处理
                CMP    TIMESECOND,60                  ;大于等于60，进一位
                JGE    SECONDCARRY                    ;秒数进位
                JMP    ENDINT                         ;中断返回
    SECONDCARRY:
                MOV    TIMESECOND,0                   ;清零
                INC    TIMEMINUTE                     ;分钟自加一
                CMP    TIMEMINUTE,60                  ;大于等于60，进一位
                JGE    MINUTECARRY                    ;分钟进位
                JMP    ENDINT                         ;中断返回
    MINUTECARRY:
                MOV    TIMEMINUTE,0                   ;清零
                INC    TIMEHOUR                       ;小时自加一
                CMP    TIMEHOUR,24                    ;大于等于24，进一位
                JGE    HOURCARRY                      ;小时进位
                JMP    ENDINT                         ;中断返回
    HOURCARRY:  
                MOV    TIMEHOUR,0                     ;清零
                JMP    ENDINT                         ;中断返回
	
    ENDINT:     
    ;中断返回
                MOV    AL,20H                         ;
                OUT    20H,AL                         ;发送中断结束指令
    ;恢复现场
                POP    AX
                POP    BX
                POP    CX
                INC    DX                             ;计数加一
                IRET                                  ;;中断返回
INT08H ENDP
CODES ENDS
    END START
