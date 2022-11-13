; 2022年10月20日20:13:38
; 2052526 白俊豪
; 乘法表纠错

data segment
    table      db 7,2,3,4,5,6,7,8,9
               db 2,4,7,8,10,12,14,16,18
               db 3,6,9,12,15,18,21,24,27
               db 4,8,12,16,7,24,28,32,36
               db 5,10,15,20,25,30,35,40,45
               db 6,12,18,24,30,7,42,48,54
               db 7,14,21,28,35,42,49,56,63
               db 8,16,24,32,40,48,56,7,72
               db 9,18,27,36,45,54,63,72,81,"$"
    header     db "x y", 0ah, 0dh, '$'               ; 表头
    error      db "error !!!", 0ah, 0dh, '$'         ; 错误信息
    space      db " ","$"                            ; 空格
    accomplish db "accomplish !!!", 0ah, 0dh, '$'    ; 完成信息
    number     dw ?,?                                ; 乘数和被乘数
data ends
stack segment
stack ends
code segment
                     assume cs:code, ds:data, ss:stack
    ; 输出结束
    print_accomplish:
                     mov    ah, 09h
                     lea    dx, accomplish
                     int    21h
                     ret
    ; 输出空格
    print_space:     
                     lea    dx, space
                     mov    ah, 09h
                     int    21h
                     ret
    ; 输出表头
    print_header:    
                     lea    dx, header
                     mov    ah, 09h
                     int    21h
                     ret
    ; 输出错误
    print_error:     
                     call   print_x_y
                     lea    dx, error
                     mov    ah, 09h
                     int    21h
                     jmp    continue                      ; 跳转回下一次循环

    ; 输出x,y的位置，即输出乘数和被乘数
    print_x_y:       
                     mov    dx, [number]
                     add    dx, 30h
                     mov    ah, 02h
                     int    21h
                     call   print_space
                     mov    dx, [number+2]
                     add    dx, 30h
                     mov    ah, 02h
                     int    21h
                     call   print_space
                     ret

    ; 程序入口
    start:           
                     mov    si, offset table
    ; step 1 - 输出表头
                     mov    ax, data
                     mov    ds, ax
                     call   print_header
    ; step 2 - 初始化循环
           
    ; step 2-1 外层循环 计算乘数并保存
                     mov    cx, 9                         ; 外层循环9次
    L1:              
                     mov    ax, 10
                     sub    ax ,cx                        ; 计算得到乘数 ax = 10 - cx
                     mov    [number], ax                  ; 保存乘数
    ; step 2-2 内层循环 计算被乘数并保存
                     push   cx                            ; 保存外层循环计数器
                     mov    cx, 9                         ; 内层循环9次
    L2:              
                     mov    ax, 10
                     sub    ax ,cx                        ; 计算得到被乘数 ax = 10 - cx
                     mov    [number+2], ax                ; 保存被乘数
    ; step 3 - 计算并与table中的数据比较
                     mov    ax, [number]                  ; 取出乘数
                     mul    [number+2]                    ; 乘以被乘数，ax = 乘数 * 被乘数
                     mov    bx, ax                        ; 保存结果
    ; step 3-1 取出table中的数据放到ax中
                     mov    ax, word ptr [si]
                     cmp    al, bl                        ; 比较结果
                     jne    print_error                   ; 不相等跳转
    ; step 3-2 继续下一次循环
    continue:        inc    si                            ; table指针加1
                     loop   L2                            ; 继续下一次循环
                     pop    cx                            ; 恢复外层循环计数器
                     loop   L1                            ; 继续下一次循环
    ; step 4 - 输出完成信息
                     call   print_accomplish
                     mov    ah,4ch                        ; 程序终止
                     int    21h
code ends
    end start