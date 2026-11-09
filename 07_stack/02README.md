# 02.asm — A 64-bit function stack frame and local variables

## Purpose

This program demonstrates how a function uses the stack for its return address, saved base pointer, and local variables.

## Execution, from start to finish

### In `_start`

1. `call work` transfers control to `work`. Before jumping, CALL pushes the address of the next instruction (the `mov rax, 60`) onto the stack. In 64-bit mode this return address occupies 8 bytes, so `RSP` decreases by 8.
2. When `work` returns, execution resumes at the instruction after `call work`.
3. The exit sequence sets `RAX = 60`, sets `RDI = 0`, and executes `syscall` to terminate normally on Linux x86-64.

### In `work`

4. `push rbp` saves the caller's old `RBP` on the stack. `RSP` decreases by another 8.
5. `mov rbp, rsp` establishes the current stack-frame base. From this point, `RBP` is used as a stable reference while `RSP` moves.
6. `sub rsp, 16` reserves 16 bytes for two 8-byte local variables. `RSP` decreases by 16.
7. `mov qword [rbp - 8], 100` stores 100 in the first local-variable slot.
8. `mov qword [rbp - 16], 200` stores 200 in the second local-variable slot.
9. `mov rax, [rbp - 8]` reads 100 into `RAX`.
10. `mov rbx, [rbp - 16]` reads 200 into `RBX`.
11. `mov rsp, rbp` discards the 16 bytes reserved for the local variables by restoring `RSP` to the saved-frame-pointer position.
12. `pop rbp` restores the caller's old `RBP` and increases `RSP` by 8.
13. `ret` pops the return address into the instruction pointer and transfers execution back to `_start`. `RSP` increases by 8, undoing the stack space used by CALL.

## Stack-frame layout

While `work` is executing after `sub rsp, 16`, the relevant layout is:

```text
Higher addresses
+--------------------------+
| Return address from CALL |  [RBP + 8]
+--------------------------+
| Saved caller RBP         |  [RBP]
+--------------------------+
| Local variable: 100      |  [RBP - 8]
+--------------------------+
| Local variable: 200      |  [RBP - 16]  <- RSP
+--------------------------+
Lower addresses
```

## RSP movement

Let `S` be `RSP` on entry to `_start`.

| Operation | RSP |
|---|---:|
| Before `call work` | `S` |
| CALL pushes return address | `S - 8` |
| `push rbp` | `S - 16` |
| `mov rbp, rsp` | unchanged; `RBP = S - 16` |
| `sub rsp, 16` | `S - 32` |
| `mov rsp, rbp` | `S - 16` |
| `pop rbp` | `S - 8` |
| `ret` | `S` |

The function therefore restores the stack pointer to its value immediately after the CALL, and RET then restores it to the value from before the CALL.

## Expected observations when debugging

At the two local-variable stores, the values should be visible at `[rbp-8]` and `[rbp-16]`. In GDB, use `x/2gx $rbp-16` to inspect the two slots; because the lower address is shown first, expect 200 at `$rbp-16` and 100 at `$rbp-8`. After the loads, `RAX = 100` and `RBX = 200`.

The program does not print the local variables. Inspect them in GDB. The values in `RAX` and `RBX` are not used by the exit system call.

## How to assemble and test in WSL

```bash
nasm -f elf64 -g -F dwarf 02.asm -o 02.o
ld 02.o -o 02
gdb -q ./02
```

In GDB:

```gdb
break work
run
display/i $rip
info registers rsp rbp
```

Step through the prologue and local-variable instructions. Inspect the frame with:

```gdb
x/4gx $rbp-16
info registers rax rbx rsp rbp
```

Step through `mov rsp, rbp`, `pop rbp`, and `ret` to observe the stack being restored.

## Test note

The observations above are expected from the code and should be confirmed in WSL/GDB. This source uses Linux x86-64 system calls.
