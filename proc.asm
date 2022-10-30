; 2022年10月26日10:36:22
; 2052526 白俊豪
; 函数调用

data segment
      ; 输入格式为YY/MM/DD回车
      buffer               db 9
                           db ?
                           db 9 dup(0)
      crlf                 db 0ah,0dh,'$'
      year                 db 2 dup(0),'$'
      month                db 2 dup(0),'$'
      day                  db 2 dup(0),'$'
      year_prompt          db 'Year(YY): ','$'
      month_prompt         db 'Month(MM): ','$'
      day_prompt           db 'Day(DD): ','$'
      string_length_prompt db 'String length: ','$'
      input_date           db 'Input date(YY/MM/DD): ','$'
      output_date          db 'Output date: ','$'
data ends

stack segment
            dw 100 dup(?)
stack ends

code segment
                    assume cs:code,ds:data,ss:stack
      ; 输出换行
OUTPUT_CRLF PROC
                    mov    ah,09h
                    lea    dx,crlf
                    int    21h
                    ret
OUTPUT_CRLF ENDP

      ; 读取输入字符串
READ_INPUT PROC
                    lea    dx,input_date
                    mov    ah,09h
                    int    21h
                    mov    ah,0ah
                    lea    dx,buffer
                    int    21h
                    ret
READ_INPUT ENDP

      ; 输出字符串长度
STRING_LENGTH PROC
                    lea    dx,string_length_prompt
                    mov    ah,09h
                    int    21h
                    mov    dl, buffer[1]
                    add    dl, 30h
                    mov    ah, 02h
                    int    21h
                    call   OUTPUT_CRLF
                    ret
STRING_LENGTH ENDP
      ; 输出字符串
OUTPUT_STRING PROC
                    lea    dx, output_date
                    mov    ah, 09h
                    int    21h
                    lea    dx , buffer+2
                    mov    ah, 09h
                    int    21h
                    ret
OUTPUT_STRING ENDP

      ; 拆分字符串并存入相应的变量
SPLIT_STRING PROC
                    mov    dl, buffer[2]
                    mov    year[0], dl
                    mov    dl, buffer[3]
                    mov    year[1], dl
                    mov    dl, buffer[5]
                    mov    month[0], dl
                    mov    dl, buffer[6]
                    mov    month[1], dl
                    mov    dl, buffer[8]
                    mov    day[0], dl
                    mov    dl, buffer[9]
                    mov    day[1], dl
                    ret
SPLIT_STRING ENDP
      ; 输出年份
OUTPUT_YEAR PROC
                    lea    dx, year_prompt
                    mov    ah, 09h
                    int    21h
                    lea    dx, year
                    mov    ah, 09h
                    int    21h
                    call   OUTPUT_CRLF
                    ret
OUTPUT_YEAR ENDP
      ; 输出月份
OUTPUT_MONTH PROC
                    lea    dx, month_prompt
                    mov    ah, 09h
                    int    21h
                    lea    dx, month
                    mov    ah, 09h
                    int    21h
                    call   OUTPUT_CRLF
                    ret
OUTPUT_MONTH ENDP
      ; 输出日期
OUTPUT_DAY PROC
                    lea    dx, day_prompt
                    mov    ah, 09h
                    int    21h
                    lea    dx, day
                    mov    ah, 09h
                    int    21h
                    call   OUTPUT_CRLF
                    ret
OUTPUT_DAY ENDP
      start:        
      ; initialization
                    mov    ax,data
                    mov    ds,ax
                    mov    ax,stack
                    mov    ss,ax
                    mov    sp,100
      ; input a string
                    call   READ_INPUT
      ; output crlf
                    call   OUTPUT_CRLF
      ; output the length of the string
                    call   STRING_LENGTH
      ; output the string
                    call   OUTPUT_STRING
      ; split the string into year, month and day
                    call   SPLIT_STRING
      ; output year
                    call   OUTPUT_YEAR
      ; output month
                    call   OUTPUT_MONTH
      ; output day
                    call   OUTPUT_DAY
      ; end program
                    mov    ax,4c00h
                    int    21h

code ends
end start