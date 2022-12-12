- [作业四 拆分为三个文件](#作业四-拆分为三个文件)
  - [实现](#实现)
  - [问题](#问题)


## 作业四 拆分为三个文件
时间：2022.11.13

### 实现
1. 使用public和extrn实现(遇到的问题比较多)
2. 使用include实现
    - 使用include实现时，只需要编译a1.asm即可，不需要编译a2.asm和a3.asm
    - 然后输入link a1.obj

### 问题
1. 遇到的问题
    - fixup overflow
        - 原因：跳转的地址超过了2字节的范围
        - 解决：使用call far ptr
    - 重定义
        - 原因：include之后，data段是共享的，所以会出现重定义的问题
        - 解决：使用extrn声明
2. 宏定义的写法(之后补上)
![](https://s2.loli.net/2022/12/02/gYWpteXvcIjnHJM.png)
