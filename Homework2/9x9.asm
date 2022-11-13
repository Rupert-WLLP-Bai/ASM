; 2022年10月20日18:46:05
; 2052526 白俊豪
; 输出九九乘法表

data segment
       crlf   db 0dh , 0ah, '$'       ; 回车换行符
       number dw ?,?,?,?              ; 乘数和被乘数
       buf    db ?,?,?,?              ; 显示结果
data ends

stack segment
stack ends

code segment
              assume cs:code,ds:data,ss:stack       ; 默认程序段；默认数据段；默认堆栈段
       start: 
              mov    ax, data
              mov    ds, ax
              mov    cx, 9                          ; 外层循环9次
       s1:    
              mov    [number], cx                   ; 存放乘数
              push   cx                             ; 保存循环次数
              push   cx                             ; 保存乘数
       s2:    
       ; 输出乘数
              mov    dx, [number]
              add    dx, 30h
              mov    ah, 2
              int    21h

       ; 输出x
              mov    dl,78h
              mov    ah,2
              int    21h
       ;显示第二个乘数
              mov    [number+1],cx
              push   cx                             ;第二个乘数进栈
              mov    dx,cx
              add    dx,30h
              mov    ah,2
              int    21h

       ;显示=号
              mov    dl,3dh
              mov    ah,2
              int    21h
       
       ;计算两数相乘的结果，并显示
              pop    dx                             ;取出第二个乘数
              pop    ax                             ;取出第一个乘数
              push   ax                             ;第一个乘数再次进栈，在下次内层循环中推出再次使用
              mul    dx                             ;相乘，结果在AX中
              mov    bx,10                          ;准备除以10
              mov    si,2                           ;循环2次，最大到十位 (乘法表最大为81,所以最大到十位)
   
      
       toDec:                                       ;把各个位转换为数值，如ax中的81，转换为 8,1存在内存中
              mov    dx,0
              div    bx                             ;除10法得到各个位上的数值
              mov    [buf+si],dl                    ;余数为该位上的值，第一次循环为个位，第二次为十位...；存到内存中
              dec    si
              cmp    ax,0                           ;商是否为0，为0算法结束
              ja     toDec
  
      
       output:                                      ;输出内存中存放的转换数值数
              inc    si
              mov    dl,[buf+si]
              add    dl,30h                         ;转为ascii
              mov    ah,2
              int    21h
              cmp    si,2
              jb     output
       
              mov    dl,20h
              mov    ah,2
              int    21h
  
              loop   s2                             ;内层循环结束
           
              lea    dx,crlf                        ;输出回车换行
              mov    ah,9
              int    21h

              pop    cx
              pop    cx                             ;还原外层计数
       
              loop   s1
    
              mov    ah,1                           ;停留等待结束
              int    21h
    
              mov    ah,4ch                         ; 程序终止
              int    21h
code ends
    end start
