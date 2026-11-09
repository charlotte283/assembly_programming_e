# 01.asm — Basic PUSH and POP (64-bit)

## Purpose

This program demonstrates the stack's LIFO (Last In, First Out) behaviour by pushing two 64-bit register values and popping them into different registers.

## Execution, from start to finish

1. `mov rax, 100` places decimal 100 in `RAX`.
2. `mov rbx, 200` places decimal 200 in `RBX`.
3. `push rax` subtracts 8 from `RSP` and stores the 8-byte value 100 at the new stack top.
4. `push rbx` subtracts another 8 from `RSP` and stores 200 at the new stack top. The 200 is now above the 100 and is the next value to be popped.
5. `nop` performs no operation. It is simply a convenient point for observing execution.
6. `pop rcx` loads 200 from the top of the stack into `RCX`, then adds 8 to `RSP`.
7. `pop rdx` loads 100 into `RDX`, then adds another 8 to `RSP`.
8. The second `nop` also has no effect.
9. `mov rax, 60`, `xor rdi, rdi`, and `syscall` invoke the Linux x86-64 `exit(0)` system call. `RAX` is changed from 100 to the syscall number 60 immediately before the program exits.

## Stack and register trace

Let the value of `RSP` on entry to `_start` be `S`.

| Point | RSP | Stack top / effect |
|---|---:|---|
| Entry | `S` | No values pushed by this program yet |
| After `push rax` | `S - 8` | `[RSP] = 100` |
| After `push rbx` | `S - 16` | `[RSP] = 200`; `[RSP+8] = 100` |
| After `pop rcx` | `S - 8` | `RCX = 200` |
| After `pop rdx` | `S` | `RDX = 100`; the two pushes have been undone |

The stack grows toward lower memory addresses: PUSH decreases `RSP`; POP increases it. Each operation uses 8 bytes in 64-bit mode.

## Expected observations when debugging

After both PUSH instructions, `info registers rax rbx rsp` should show `RAX = 0x64`, `RBX = 0xc8`, and an `RSP` value 16 bytes below its entry value. `x/2gx $rsp` should display `0xc8` first and `0x64` second (200 and 100).

After both POP instructions, `info registers rcx rdx rsp` should show `RCX = 0xc8` and `RDX = 0x64`; `RSP` should be back to its entry value. The program does not print these values; GDB is used to inspect them.

## How to assemble and test in WSL

```bash
nasm -f elf64 -g -F dwarf 01.asm -o 01.o
ld 01.o -o 01
gdb -q ./01
```

In GDB:

```gdb
break _start
run
display/i $rip
si
info registers rax rbx rsp
```

Step until after the two PUSH instructions, then run `x/2gx $rsp`. Continue through both POP instructions and inspect `rcx`, `rdx`, and `rsp`.

## Test note

These are the expected results from the instruction semantics. They should be confirmed in the WSL/GDB run above. A Windows-native GDB session is not a valid test of this Linux ELF program.
