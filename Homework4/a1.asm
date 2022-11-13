Include a2.asm
Include a3.asm

code segment
          assume cs:code, ds:data
    start:
    ; 初始化
          mov    ax, data
          mov    ds, ax
    ; 输出表头
          call   far ptr print_header
    ; 计算
          call   far ptr LOOP_START
    ; 输出结束
          call   far ptr print_accomplish
    ; 程序结束
          mov    ax, 4c00h
          int    21h
code ends
end start