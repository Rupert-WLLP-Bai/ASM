assume cs:code,ds:data

data segment
    table  db 7,2,3,4,5,6,7,8,9
           db 2,4,7,8,10,12,14,16,18
           db 3,6,9,12,15,18,21,24,27
           db 4,8,12,16,7,24,28,32,36
           db 5,10,15,20,25,30,35,40,45
           db 6,12,18,24,30,7,42,48,54
           db 7,14,21,28,35,42,49,56,63
           db 8,16,24,32,40,48,56,7,72
           db 9,18,27,36,45,54,63,72,81,"$"
    error  db "error !!!", 0ah, 0dh, '$'       ; 错误信息
    number dw ?,?                              ; 乘数和被乘数
    space  db " ","$"                          ; 空格
data ends

code segment
    ; 输出空格
print_space proc
                lea  dx, space
                mov  ah, 09h
                int  21h
                ret
print_space endp
    ; 输出错误
    print_error:
                call print_x_y
                lea  dx, error
                mov  ah, 09h
                int  21h
                jmp  continue             ; 跳转回下一次循环
    ; 输出x,y的位置，即输出乘数和被乘数
print_x_y proc
                mov  dx, [number]
                add  dx, 30h
                mov  ah, 02h
                int  21h
                call print_space
                mov  dx, [number+2]
                add  dx, 30h
                mov  ah, 02h
                int  21h
                call print_space
                ret
print_x_y endp

LOOP_START PROC FAR
    ; step 2 - 初始化循环
    ; step 2-1 外层循环 计算乘数并保存
                mov  si,offset table
                mov  cx, 9                ; 外层循环9次
    L1:         
                mov  ax, 10
                sub  ax ,cx               ; 计算得到乘数 ax = 10 - cx
                mov  [number], ax         ; 保存乘数
    ; step 2-2 内层循环 计算被乘数并保存
                push cx                   ; 保存外层循环计数器
                mov  cx, 9                ; 内层循环9次
    L2:         
                mov  ax, 10
                sub  ax ,cx               ; 计算得到被乘数 ax = 10 - cx
                mov  [number+2], ax       ; 保存被乘数
    ; step 3 - 计算并与table中的数据比较
                mov  ax, [number]         ; 取出乘数
                mul  [number+2]           ; 乘以被乘数，ax = 乘数 * 被乘数
                mov  bx, ax               ; 保存结果
    ; step 3-1 取出table中的数据放到ax中
                mov  ax, word ptr [si]
                cmp  al, bl               ; 比较结果
                jne  print_error          ; 不相等跳转
    ; step 3-2 继续下一次循环
    continue:   inc  si                   ; table指针加1
                loop L2                   ; 继续下一次循环
                pop  cx                   ; 恢复外层循环计数器
                loop L1                   ; 继续下一次循环
                ret
LOOP_START ENDP
code ends
            