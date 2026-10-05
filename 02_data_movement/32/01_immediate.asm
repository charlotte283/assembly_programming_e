; nasm -f elf32 01_immediate.asm && ld -m elf_i386 01_immediate.o && ./a.out
; nasm -f elf32 01_immediate.asm
<<<<<<< HEAD
;ld -m elf_i386 01_immediate.o  
;gdb --silent a.out
=======
; ld -m elf_i386 01_immediate.o
; gdb --silent a.out

>>>>>>> 56e0a40d524baf473a8fe9e8f7b3c954ca00e967



section .text
global _start

_start:

    mov eax, 10
    mov ebx, 20

    add eax, 5

    mov eax, 1
    int 0x80



