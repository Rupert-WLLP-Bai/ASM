; @File: add.asm

section .text
global add_long

add_long:
    ; save the base pointer and set the new base pointer to the current stack pointer
    push 	rbp
    mov 	rbp, rsp

    ; save the register rbx on the stack
    push 	rbx

    ; move the first argument from rdi to rax and the second argument from rsi to rbx
    mov		rax, rdi
    mov 	rbx, rsi

    ; add rbx to rax, storing the result in rax
    add 	rax, rbx

    ; restore the value of rbx from the stack
    pop 	rbx

    ; restore the base pointer and return
    leave
    ret


global  sum
        section .text
sum:
        xorpd   xmm0, xmm0              ; initialize the sum to 0 初始化xmm0
        cmp     rsi, 0                  ; special case for length = 0 rsi计数
        je      done                    ; 计数到了，就done，退出
next:
        addsd   xmm0, [rdi]             ; add in the current array element rdi是一个偏移，用于取数组的地址, rdi默认存储的是数组的首地址
        add     rdi, 8                  ; move to next array element rdi 增加一个偏移
        dec     rsi                     ; count down 计数减少
        jnz     next                    ; if not done counting, continue
done:
        ret                             ; return value already in xmm0