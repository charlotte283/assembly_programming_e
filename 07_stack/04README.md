# 04.asm — A 32-bit stack frame and local variables

## Purpose

This program repeats the stack-frame exercise using 32-bit registers and the 32-bit Linux system-call interface.

## Execution, from start to finish

1. `call work` pushes the address of the instruction after CALL onto the stack. In 32-bit mode, the return address is 4 bytes, so `ESP` decreases by 4.
2. `push ebp` saves the caller's old frame pointer; `ESP` decreases by another 4.
3. `mov ebp, esp` establishes the new frame pointer.
4. `sub esp, 8` reserves 8 bytes for two 4-byte local variables.
5. `mov dword [ebp - 4], 100` stores 100 in the first local slot.
6. `mov dword [ebp - 8], 200` stores 200 in the second local slot.
7. `mov eax, [ebp - 4]` loads 100 into `EAX`.
8. `mov ebx, [ebp - 8]` loads 200 into `EBX`.
9. `mov esp, ebp` releases the 8 bytes of local-variable space.
10. `pop ebp` restores the caller's old frame pointer and increases `ESP` by 4.
11. `ret` pops the 4-byte return address and resumes execution after `call work`; `ESP` returns to its pre-CALL value.
12. The exit sequence sets `EAX = 1`, sets `EBX = 0`, and executes `int 0x80`, the 32-bit Linux `exit(0)` system call.

## Stack-frame layout

While `work` is executing after `sub esp, 8`:

```text
Higher addresses
+--------------------------+
| Return address from CALL |  [EBP + 4]
+--------------------------+
| Saved caller EBP         |  [EBP]
+--------------------------+
| Local variable: 100      |  [EBP - 4]
+--------------------------+
| Local variable: 200      |  [EBP - 8]  <- ESP
+--------------------------+
Lower addresses
```

## ESP movement

Let `S` be `ESP` before CALL.

| Operation | ESP |
|---|---:|
| Before `call work` | `S` |
| CALL pushes return address | `S - 4` |
| `push ebp` | `S - 8` |
| `mov ebp, esp` | unchanged; `EBP = S - 8` |
| `sub esp, 8` | `S - 16` |
| `mov esp, ebp` | `S - 8` |
| `pop ebp` | `S - 4` |
| `ret` | `S` |

## Expected observations when debugging

At the local-variable instructions, inspect `x/2wx $ebp-8`. It should show 200 at the lower address (`[EBP-8]`) and 100 at `[EBP-4]`. After the loads, `EAX = 100` and `EBX = 200`. The exit code later overwrites both registers.

The program does not print the local values; use GDB to inspect them.

## How to assemble and test in WSL

```bash
nasm -f elf32 -g -F dwarf 04.asm -o 04.o
ld -m elf_i386 04.o -o 04
gdb -q ./04
```

In GDB:

```gdb
break work
run
display/i $eip
info registers esp ebp
```

Step through the function and inspect:

```gdb
x/2wx $ebp-8
info registers eax ebx esp ebp
```

If the 32-bit executable cannot run, check that the Linux environment supports 32-bit execution. The assembler and linker producing an ELF32 file does not by itself guarantee that the host kernel has 32-bit compatibility enabled.

## Test note

The expected register and stack values are derived from the instructions. Confirm them in WSL/GDB; do not use a Windows-native executable/debugger session for this Linux ELF32 program.
