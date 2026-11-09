# 03.asm — CALL, RET, and a register return value (64-bit)

## Purpose

This program demonstrates that CALL and RET use the stack to remember where a function should return, while the function's result can be returned in a register.

## Execution, from start to finish

1. `_start` executes `mov rax, 10`, placing 10 in `RAX`.
2. `call calculate` pushes the address of the next instruction (`after_call`) onto the stack. This 8-byte return address makes `RSP` decrease by 8, then execution jumps to `calculate`.
3. `add rax, 5` changes the value in `RAX` from 10 to 15. This instruction does not push anything onto or pop anything from the stack.
4. `ret` pops the saved return address from the stack into the instruction pointer. `RSP` increases by 8 and execution resumes at `after_call`.
5. `nop` does nothing. At this point, `RAX` should contain 15.
6. The exit sequence changes `RAX` to 60, sets `RDI` to zero, and executes the Linux x86-64 exit system call.

## Stack movement

Let `S` be `RSP` before CALL.

| Point | RSP | Explanation |
|---|---:|---|
| Before CALL | `S` | No stack change from `mov rax, 10` |
| After `call calculate` | `S - 8` | Return address is at `[RSP]` |
| During `add rax, 5` | `S - 8` | ADD does not affect the stack |
| After `ret` | `S` | Return address is popped |

There is no explicit PUSH or POP in `calculate`; CALL and RET perform the stack operations that make the function call possible.

## Expected observations when debugging

Break at `calculate` and inspect `RSP`. The 8-byte return address should be at the top of the stack. `x/gx $rsp` displays it. Step over or execute `add rax, 5` and check `info registers rax`; it should show `0xf` (15). After RET, execution should be at `after_call`, and `RSP` should have returned to its pre-CALL value.

The comment says that RAX should be 15 after the call. That is true at `after_call`; it is later overwritten with 60 to request process exit. The program does not print 15.

## How to assemble and test in WSL

```bash
nasm -f elf64 -g -F dwarf 03.asm -o 03.o
ld 03.o -o 03
gdb -q ./03
```

In GDB:

```gdb
break calculate
run
info registers rax rsp
x/gx $rsp
si
info registers rax
```

Continue through `ret`, then inspect `RIP`, `RSP`, and `RAX` at `after_call`.

## Test note

The expected return value is 15. Confirm it at `after_call`, before the exit setup overwrites RAX.
