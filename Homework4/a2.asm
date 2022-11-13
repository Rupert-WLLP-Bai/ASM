assume cs:code, ds:data

data segment
    header     db "x y", 0ah, 0dh, '$'               ; 表头
    accomplish db "accomplish !!!", 0ah, 0dh, '$'    ; 完成信息
data ends

code segment
    ; 输出结束
print_accomplish proc far
                     mov dx, offset accomplish
                     mov ah , 09h
                     int 21h
                     ret
print_accomplish endp
    ; 输出表头
print_header proc far
                     lea dx, header
                     mov ah, 09h
                     int 21h
                     ret
print_header endp

code ends
