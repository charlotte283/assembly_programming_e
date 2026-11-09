# 06.asm — Saving and restoring 32-bit register values

## Purpose

This program is the 32-bit counterpart of `05.asm`. It demonstrates PUSH and POP with 32-bit registers.

## Execution, from start to finish

1. `mov eax, 0x11223344` loads the 32-bit value `0x11223344` into `EAX`.
2. `mov ebx, 0x1234` loads `0x1234` into `EBX`.
3. `push eax` decreases `ESP` by 4 and stores the 4-byte EAX value at the top of the stack.
4. `push ebx` decreases `ESP` by another 4 and stores `0x1234` at the new stack top.
5. `nop` has no effect.
6. `pop ebx` retrieves `0x1234`, the last value pushed, into `EBX`; `ESP` increases by 4.
7. `pop eax` retrieves `0x11223344` into `EAX`; `ESP` increases by another 4.
8. The exit setup changes `EAX` to 1, sets `EBX` to zero, and executes `int 0x80` to invoke the 32-bit Linux `exit(0)` system call.

## Stack movement and contents

Let `S` be `ESP` before the first PUSH.

| Point | ESP | Stack contents |
|---|---:|---|
| Before PUSH | `S` | No values pushed by this program |
| After `push eax` | `S - 4` | `[ESP] = 0x11223344` |
| After `push ebx` | `S - 8` | `[ESP] = 0x1234`; `[ESP+4] = 0x11223344` |
| After `pop ebx` | `S - 4` | `EBX = 0x1234` |
| After `pop eax` | `S` | `EAX = 0x11223344` |

The stack grows toward lower memory addresses. In 32-bit mode, each PUSH or POP of a 32-bit register moves `ESP` by 4 bytes.

## Expected observations when debugging

After both PUSH instructions, `x/2wx $esp` should show `0x1234` first and `0x11223344` second. After both POP instructions, `EAX` and `EBX` should contain their original values, and `ESP` should be back to its starting value.

Inspect the registers before the exit instructions: `mov eax, 1` and `xor ebx, ebx` deliberately overwrite the values that were just restored.

## How to assemble and test in WSL

```bash
nasm -f elf32 -g -F dwarf 06.asm -o 06.o
ld -m elf_i386 06.o -o 06
gdb -q ./06
```

In GDB:

```gdb
break _start
run
display/i $eip
```

Step through the instructions. Use `x/2wx $esp` after the two PUSHes, then `info registers eax ebx esp` after the two POPs.

If the executable cannot run, verify that your WSL/Linux environment supports 32-bit ELF execution.

## Test note

The expected values are based on the assembly instructions. Confirm them in WSL/GDB and record the actual output from your machine.
