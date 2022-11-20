DATA SEGMENT
    START_MSG      DB "ESTABLISHED IN 1907"
    MIDDLE_MSG     DB "WELCOME TO TONGJI UNIVERSITY"
    END_MSG        DB "IN SHANGHAI"
    START_MSG_LEN  DW 19
    MIDDLE_MSG_LEN DW 28
    END_MSG_LEN    DW 11
DATA ENDS

STACK SEGMENT
          DB 16 DUP(?)
STACK ENDS

CODE SEGMENT
          ASSUME CS:CODE,DS:DATA,SS:STACK
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

    START:
          CALL   CLS

          MOV    AX,DATA
          MOV    DS,AX
          MOV    BX,0                        ; DS:BX IS THE START ADDRESS OF DATA SEGMENT
          MOV    AX, 0B800H
          MOV    ES, AX                      ; START ADDRESS OF VIDEO MEMORY
          MOV    SI, 60                      ; START ADDRESS OF THE FIRST LINE
          MOV    CX, START_MSG_LEN           ; LENGTH OF THE FIRST LINE
    S1:   
          MOV    AL,DS:[BX]                  ; GET THE CHARACTER
          MOV    AH,0A1H                     ; COLOR OF THE FIRST LINE
          MOV    ES:[SI+6E0H],AX
          INC    BX
          INC    SI
          INC    SI
          LOOP   S1

          MOV    SI,58                       ; START ADDRESS OF THE SECOND LINE
          MOV    CX, MIDDLE_MSG_LEN          ; LENGTH OF THE SECOND LINE
    S2:   
          MOV    AL,DS:[BX]                  ; GET THE CHARACTER
          MOV    AH,43H                      ; COLOR OF THE SECOND LINE
          MOV    ES:[SI+780H],AX
          INC    BX
          INC    SI
          INC    SI
          LOOP   S2

          MOV    SI,64                       ; START ADDRESS OF THE THIRD LINE
          MOV    CX, END_MSG_LEN             ; LENGTH OF THE THIRD LINE
    S3:   
          MOV    AL,DS:[BX]                  ; GET THE CHARACTER
          MOV    AH,7H                       ; COLOR OF THE THIRD LINE
          MOV    ES:[SI+820H],AX
          INC    BX
          INC    SI
          INC    SI
          LOOP   S3

    EXIT: 
          MOV    AH,4CH
          INT    21H
CODE ENDS
END START