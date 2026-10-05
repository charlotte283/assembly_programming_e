section .data

    num1 dd 10
    num2 dd 20

section .text
global _start

_start:

<<<<<<< HEAD
    mov eax, [num1] ; getting the values stored in num1
    add eax, [num2]; getting the value stores in num 2
=======
    mov eax, [num1]   ; getting the value stored in num1
    add eax, [num2]   ; getting the value stored in num2

    ; mov eax, num1
    ; add eax, num2

    mov ebx, eax
>>>>>>> 56e0a40d524baf473a8fe9e8f7b3c954ca00e967

    ;mov ebx, num1
    ;add aex,num2
 mov ebx,eax
    mov eax, 1
    int 0x80