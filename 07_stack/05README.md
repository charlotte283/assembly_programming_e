# 05.asm — Saving and restoring 64-bit register values

## Purpose

This program demonstrates how PUSH and POP can preserve register contents while values are temporarily stored on the stack.

## Execution, from start to finish

1. `mov rax, 0x1122334455667788` loads a 64-bit hexadecimal value into `RAX`.
2. `mov rbx, 0x1234` loads hexadecimal `0x1234` into `RBX`.
3. `push rax` subtracts 8 from `RSP` and stores the full 64-bit RAX value at `[RSP]`.
4. `push rbx` subtracts another 8 from `RSP` and stores `0x1234` at the new stack top.
5. `nop` has no effect.
6. `pop rbx` retrieves the most recently pushed value (`0x1234`) into `RBX`, then increases `RSP` by 8.
7. `pop rax` retrieves the earlier 64-bit value (`0x1122334455667788`) into `RAX`, then increases `RSP` by another 8.
8. The exit setup changes `RAX` to 60, sets `RDI` to zero, and executes `syscall`.

## Stack movement and contents

Let `S` be `RSP` before the first PUSH.

| Point | RSP | Stack contents |
|---|---:|---|
| Before PUSH | `S` | No values pushed by this program |
| After `push rax` | `S - 8` | `[RSP] = 0x1122334455667788` |
| After `push rbx` | `S - 16` | `[RSP] = 0x1234`; `[RSP+8] = 0x1122334455667788` |
| After `pop rbx` | `S - 8` | `RBX = 0x1234` |
| After `pop rax` | `S` | `RAX = 0x1122334455667788` |

This shows LIFO order: the second value pushed is the first value popped. Both original values are restored to their corresponding registers.

## Expected observations when debugging

After both PUSH instructions, `x/2gx $rsp` should show `0x1234` at the top and `0x1122334455667788` in the next 8-byte slot. After both POP instructions, `info registers rax rbx rsp` should show the original values and the original `RSP`.

Be careful when checking the final RAX: the exit setup overwrites it with 60. Inspect it immediately after `pop rax`, not after `mov rax, 60`.

## How to assemble and test in WSL

```bash
nasm -f elf64 -g -F dwarf 05.asm -o 05.o
ld 05.o -o 05
gdb -q ./05
```

In GDB:

```gdb
break _start
run
display/i $rip
```

Step through the two MOVs and two PUSHes, then inspect `x/2gx $rsp`. Continue through the POPs and inspect `rax`, `rbx`, and `rsp`.

## Test note

The expected stack contents and restored register values follow directly from the instructions. Confirm them in WSL/GDB before recording them as observed results.
