; ASM 2022 期末
; Brief: 利用时钟中断实现计时器
; Author: 2052526 白俊豪
; Date: 2022-12-01

DATA SEGMENT
    MEMORY_ADDRESS DW 0B800H
    START_ADDRESS  DW 00A0H
    HOUR_ADDRESS   DW 00E8H
    OFFSET_ADDRESS DW 00A0H
    HOUR           DW 0
    MINUTE         DW 0
    SECOND         DW 0
    NUM            DW ?
    FIRST_BIT      DB ?
    SECOND_BIT     DB ?
DATA ENDS
    
STACK SEGMENT
          DB 100 DUP(?)
STACK ENDS

CODE SEGMENT
                      ASSUME CS:CODE,DS:DATA,SS:STACK
               
PRINT_CHAR PROC
                      MOV    ES:[SI],AX
                      INC    SI
                      INC    SI
                      RET
PRINT_CHAR ENDP

NUM_TO_DEC PROC
                      PUSH   AX
                      MOV    AX, NUM
    ;第一位
                      MOV    AH,0                        ;高位清零
                      MOV    BL,10                       ;%再除以10
                      DIV    BL                          ;除法，AX隐含寻址
                      ADD    AL,30H                      ;商转换为ASCII码
                      MOV    FIRST_BIT,AL                ;传送字符
 	
    ;第二位
                      ADD    AH,30H                      ;余数转换为ASCII码
                      MOV    SECOND_BIT,AH               ;传送字符
                      POP    AX
                      RET                                ;子程序退出重置堆栈
NUM_TO_DEC ENDP
    ; CLS PROC
CLS PROC
                      MOV    AX,0B800H                   ; START ADDRESS OF VIDEO MEMORY
                      MOV    ES,AX
                      MOV    CX,80*50                    ; SCREEN SIZE
                      MOV    SI,0
    CLS_S:            
                      MOV    AX,0
                      MOV    ES:[SI],AX
                      INC    SI
                      LOOP   CLS_S
                      RET
CLS ENDP
    ; CLS PROC END

    ; TIMER INIT PROC
TIMER_INIT PROC
                      MOV    AX , MEMORY_ADDRESS
                      MOV    ES , AX
                      MOV    SI , HOUR_ADDRESS
                      MOV    AH, 5H                      ; COLOR
                      MOV    AL,'0'
                      CALL   PRINT_CHAR
                      MOV    AL,'0'
                      CALL   PRINT_CHAR
                      MOV    AL,':'
                      CALL   PRINT_CHAR
                      MOV    AL,'0'
                      CALL   PRINT_CHAR
                      MOV    AL,'0'
                      CALL   PRINT_CHAR
                      MOV    AL,':'
                      CALL   PRINT_CHAR
                      MOV    AL,'0'
                      CALL   PRINT_CHAR
                      MOV    AL,'0'
                      CALL   PRINT_CHAR
                      RET
TIMER_INIT ENDP
SHOW_TIME PROC
                      PUSH   AX
                      PUSH   BX
                      MOV    BX, HOUR
                      MOV    NUM, BX
                      CALL   NUM_TO_DEC
                      MOV    SI, HOUR_ADDRESS
                      MOV    AL, FIRST_BIT
                      CALL   PRINT_CHAR
                      MOV    AL, SECOND_BIT
                      CALL   PRINT_CHAR
                      MOV    AL, ':'
                      CALL   PRINT_CHAR
                      MOV    BX, MINUTE
                      MOV    NUM, BX
                      CALL   NUM_TO_DEC
                      MOV    AL, FIRST_BIT
                      CALL   PRINT_CHAR
                      MOV    AL, SECOND_BIT
                      CALL   PRINT_CHAR
                      MOV    AL, ':'
                      CALL   PRINT_CHAR
                      MOV    BX, SECOND
                      MOV    NUM, BX
                      CALL   NUM_TO_DEC
                      MOV    AL, FIRST_BIT
                      CALL   PRINT_CHAR
                      MOV    AL, SECOND_BIT
                      CALL   PRINT_CHAR
                      POP    BX
                      POP    AX
                      RET
SHOW_TIME ENDP

DELAY PROC
                      PUSH   CX
    ; OUTTER LOOP
                      MOV    CX, 30
    DELAY_OUTTER_LOOP:
                      PUSH   CX
                      MOV    CX, 10
    ; INNER LOOP
    DELAY_INNER_LOOP: 
                      LOOP   DELAY_INNER_LOOP
                      POP    CX
                      LOOP   DELAY_OUTTER_LOOP
                      POP    CX
                      RET
DELAY ENDP

SET_TIME PROC
                      PUSH   AX
                      PUSH   BX
                      PUSH   CX
                      CMP    DX, 100                     ; 判断计数达到100
                      JGE    SET_TIME_COUNT
                      JMP    SET_TIME_END
    SET_TIME_COUNT:   
                      MOV    DX,0
    ; MOV SECOND TO AX
                      MOV    AX, SECOND
    ; MOV MINUTE TO BX
                      MOV    BX, MINUTE
    ; MOV HOUR TO CX
                      MOV    CX, HOUR
    ; SECOND INCREASE
                      INC    AX
    ; COMPARE SECOND TO 60
                      CMP    AX, 60
    ; IF SECOND >= 60
    ; SECOND = 0. MINITE + 1
                      JAE    SET_TIME_S1
    ; IF SECOND < 60
                      MOV    SECOND, AX
    ; JMP TO END
                      JMP    SET_TIME_END
    SET_TIME_S1:      
                      MOV    AX, 0
                      MOV    SECOND, AX
    ; MINUTE INCREASE
                      INC    BX
    ; COMPARE MINUTE TO 60
                      CMP    BX, 60
    ; IF MINUTE >= 60
    ; MINUTE = 0. HOUR + 1
                      JAE    SET_TIME_S2
    ; IF MINUTE < 60
    ; JMP TO END
                      MOV    MINUTE, BX
                      JMP    SET_TIME_END
    SET_TIME_S2:      
                      MOV    BX, 0
                      MOV    MINUTE, BX
    ; HOUR INCREASE
                      INC    CX
    ; COMPARE HOUR TO 24
                      CMP    CX, 24
    ; IF HOUR >= 24
    ; HOUR = 0
                      JAE    SET_TIME_S3
    ; IF HOUR < 24
    ; JMP TO END
                      MOV    HOUR, CX
                      JMP    SET_TIME_END
    SET_TIME_S3:      
                      MOV    CX, 0
                      MOV    HOUR, CX
    SET_TIME_END:     
                      INC    DX                          ; 计数器+1
                      POP    CX
                      POP    BX
                      POP    AX
                      RET
SET_TIME ENDP
    INIT:             
                      MOV    AX, DATA
                      MOV    DS, AX
                      MOV    AX, STACK
                      MOV    SS, AX
                      MOV    SP, 100
                      JMP    S1
    EXIT:             
                      MOV    AX, 4C00H
                      INT    21H
    START:            
                      JMP    INIT                        ; INIT
    S1:               
                      CALL   CLS                         ; CLEAR THE SCREEN
                      CALL   TIMER_INIT                  ; INIT TIMER
                      CALL   SHOW_TIME                   ; SHOW TIME
                      
    TIMING:           
                      MOV    DX,100                     ;初始化为0
    RE:               
                      CALL   SET_TIME
                      CALL   SHOW_TIME                   ;显示时间
                      CALL   DELAY                       ;延时
                      JMP    RE
    DO_ESC:           
                      JMP    EXIT
CODE ENDS
END START