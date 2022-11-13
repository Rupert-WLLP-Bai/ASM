data    segment
divisors DW 10000, 1000, 100, 10, 1
results  DB 0,0,0,0,0,"$"        ;存放五位数ASCII码
count DW 0
data ends

stack segment STACK
stack ends

code segment
assume cs:code, ds:data, ss:stack
start:
        mov ax,data
        mov ds,ax
        mov cx,64h
        mov ax,0
L1:     inc count
	add ax,count
	loop L1
        mov si, offset divisors
        mov di, offset results                    
        mov cx,5  
aa:
        mov dx, 0           
        div word ptr [si]   ;除法指令的被除数是隐含操作数，此处为dx:ax，商ax,余数dx
        add al,48           ;商加上48即可得到相应数字的ASCII码
        mov byte ptr [di],al       
        inc di                               
        add si, 2                          
        mov ax, dx                       
        loop aa
        mov cx, 4   
        mov di, offset results
bb:
        cmp byte ptr [di],'0'   ;不输出前面的0字符   
        jne print
        inc di                          
        loop bb
print:
        mov dx, di                      
        mov ah, 9
        int 21h                  
        mov ax, 4C00h      
        int 21h
code ends

end start




