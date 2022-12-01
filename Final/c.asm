; ASM 2022 期末
; Brief: 利用时钟中断实现计时器
; Author: 2052526 白俊豪
; Date: 2022-12-01

DATA SEGMENT
    MEMORY_ADDRESS DW 0B800H
    START_ADDRESS  DW 00A0H
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
               MOV    SI , START_ADDRESS          ; FIRST LINE
               ADD    SI, 72                      ; MIDDLE OF THE LINE
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
               MOV    NUM, 22
               CALL   NUM_TO_DEC
               MOV    SI, START_ADDRESS
               ADD    SI, 72
               MOV    AL, FIRST_BIT
               CALL   PRINT_CHAR
               MOV    AL, SECOND_BIT
               CALL   PRINT_CHAR
               JMP    EXIT
CODE ENDS
END START