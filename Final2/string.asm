; strlen - find the length of a null-terminated string
;
; inputs:
;   rdi - pointer to the null-terminated string
;
; output:
;   rax - the length of the string, not including the null terminator

global strlen

strlen:
    xor rax, rax        ; initialize length to 0
    .loop:
        cmp byte [rdi + rax], 0
        je .done          ; if null terminator, exit loop
        inc rax           ; increment length
        jmp .loop         ; continue to next character
    .done:
    ret                  ; return the length


; strcpy - copy a null-terminated string
;
; inputs:
;   rdi - pointer to destination string
;   rsi - pointer to source string
;
; output:
;   rax - pointer to destination string

global strcpy

strcpy:
    xor rax, rax        ; initialize index to 0
    .loop:
        cmp byte [rsi + rax], 0
        je .done          ; if null terminator, exit loop
        mov rbx, [rsi + rax] ; use rbx as temporary register
        mov [rdi + rax], rbx  ; copy character
        inc rax           ; increment index
        jmp .loop         ; continue to next character
    .done:
        mov byte [rdi + rax], 0  ; append null terminator
        mov rax, rdi       ; return pointer to destination string
    ret


; strncpy - copy at most n characters of src to dst
;
; Arguments:
;   dst - pointer to destination buffer
;   src - pointer to source buffer
;   n - number of characters to copy
;
; Returns:
;   Returns dst

global strncpy

strncpy:
    ; check for null pointers
    cmp rdi, 0
    jz .null_dst
    cmp rsi, 0
    jz .null_src

    ; initialize variables
    mov r8, rsi  ; r8 = src
    mov r9, rdi  ; r9 = dst
    xor rcx, rcx ; rcx = 0 (index for copying characters)
    xor rax, rax ; rax = 0 (zero byte for copying null terminator)

    ; copy characters from src to dst
    .copy_loop:
        cmp cl, dl  ; have we copied n characters?
        jge .done   ; if yes, then done

        mov dl, [r8+rcx]   ; load character from src
        mov [r9+rcx], dl   ; store character in dst
        inc rcx            ; increment index

        jmp .copy_loop

    ; copy null terminator
    .done:
        mov [r9+rcx], al

    ; add null terminator to end of string in buf
    mov [r9+rcx+1], al

    ; return dst
    mov rax, r9
    ret

.null_dst:
    ; return null if dst is null
    xor rax, rax
    ret

.null_src:
    ; return dst if src is null
    mov rax, rdi
    ret



global strcmp

strcmp:
    ; check for null pointers
    cmp rdi, 0
    jz .null_str1
    cmp rsi, 0
    jz .null_str2

    ; initialize variables
    mov r8, rsi  ; r8 = str1
    mov r9, rdi  ; r9 = str2
    xor rcx, rcx ; rcx = 0 (index for comparing characters)

    ; compare characters from str1 and str2
    .compare_loop:
        cmp cl, dl      ; have we reached the end of either string?
        jge .done       ; if yes, then done

        mov al, [r8+rcx]    ; load character from str1
        mov bl, [r9+rcx]    ; load character from str2
        cmp al, bl          ; compare characters
        jne .done           ; if not equal, then done

        inc rcx             ; increment index

        jmp .compare_loop

    ; return result of comparison
    .done:
        mov rax, rcx
        ret

    ; return 0 if str1 is null
    .null_str1:
        xor rax, rax
        ret

    ; return -1 if str2 is null
    .null_str2:
        mov rax, -1
        ret
