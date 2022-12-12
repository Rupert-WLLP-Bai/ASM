; @File: add.asm

section .text
global add

add:
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
