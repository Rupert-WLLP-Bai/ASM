DATA SEGMENT
      INPUT_PROMPT      DB "ENTER HOURS MINUTES AND SECONDS(HH MM SS)", 0
      INPUT_PROMPT_LEN  =  $ - INPUT_PROMPT
      OUTPUT_PROMPT     DB "THE TIME IS ", 0
      OUTPUT_PROMPT_LEN =  $ - OUTPUT_PROMPT
      CRLF              DB 13, 10, 0
      CRLF_LEN          =  $ - CRLF
DATA ENDS

STACK SEGMENT
            DB 100 DUP(?)
STACK ENDS

CODE SEGMENT
                 ASSUME CS:CODE, DS:DATA, SS:STACK
      ; CLS PROC
CLS PROC
                 MOV    AX,0B800H                       ; START ADDRESS OF VIDEO MEMORY
                 MOV    ES,AX
                 MOV    CX,80*50                        ; SCREEN SIZE
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
      ; INITIALIZE THE DATA SEGMENT AND STACK SEGMENT
      INIT:      
                 MOV    AX, DATA
                 MOV    DS, AX
                 MOV    AX, STACK
                 MOV    SS, AX
                 MOV    SP, 100
      ; CLEAR THE SCREEN
                 CALL   CLS
      ; PRINT "ABC" ON THE FIRST LINE
      ; THE ADDRESS OFFSET RANGE IS 00A0H - 013FH
                 MOV    AX, 0B800H
                 MOV    ES, AX
                 MOV    DI, 00A0H
                 MOV    AH, 0A1H                        ; COLOR OF THE FIRST LINE
                 MOV    AL, 'A'
                 MOV    ES:[DI], AX
                 INC    DI
                 INC    DI
                 MOV    AL, 'B'
                 MOV    ES:[DI], AX
                 INC    DI
                 INC    DI
                 MOV    AL, 'C'
                 MOV    ES:[DI], AX
                 INC    DI
                 INC    DI
      ; PRINT "DEF" ON THE SECOND LINE
      ; THE ADDRESS OFFSET RANGE IS 0140H - 01DF
                 MOV    DI, 0140H
                 MOV    AH, 07H                         ; COLOR OF THE SECOND LINE
                 MOV    AL, 'D'
                 MOV    ES:[DI], AX
                 INC    DI
                 INC    DI
                 MOV    AL, 'E'
                 MOV    ES:[DI], AX
                 INC    DI
                 INC    DI
                 MOV    AL, 'F'
                 MOV    ES:[DI], AX
                 INC    DI
                 INC    DI
      ; PRINT "GHI" ON THE THIRD LINE
      ; THE ADDRESS OFFSET RANGE IS 01E0H - 027FH
                 MOV    DI, 01E0H
                 MOV    AH, 043H                        ; COLOR OF THE THIRD LINE
                 MOV    AL, 'G'
                 MOV    ES:[DI], AX
                 INC    DI
                 INC    DI
                 MOV    AL, 'H'
                 MOV    ES:[DI], AX
                 INC    DI
                 INC    DI
                 MOV    AL, 'I'
                 MOV    ES:[DI], AX
                 INC    DI
                 INC    DI
      ; QUIT
      EXIT:      
                 MOV    AX, 4C00H
                 INT    21H
CODE ENDS
    END START
