# DIV — Arithmetic Programs

This folder contains three x86 assembly programs demonstrating unsigned
division using 8-bit, 16-bit, and 32-bit operands.

## Programs

* `div1.asm` — 8-bit division
* `dive2.asm` — 16-bit division
* `div3.asm` — 32-bit division

---

## 1. div1.asm

### Operation

The program divides `100` by `7`.

```text
100 ÷ 7 = 14 remainder 2
```

Before the division:

```text
AX = 100
BL = 7
```

The instruction is:

```asm
div bl
```

For an 8-bit divisor, `DIV` uses `AX` as the dividend.

After the division:

```text
AL = 14       ; quotient
AH = 2        ; remainder
```

### Flags

Unlike `ADD`, `SUB`, and similar arithmetic instructions, the x86 `DIV`
instruction does **not define the status flags**.

Therefore, the values of the following flags cannot be reliably described as
set or cleared based on the division result:

| Flag | Status    |
| ---- | --------- |
| CF   | Undefined |
| ZF   | Undefined |
| SF   | Undefined |
| OF   | Undefined |
| PF   | Undefined |
| AF   | Undefined |

The important result of the instruction is the quotient and remainder:

```text
Quotient  = 14
Remainder = 2
```

---

## 2. dive2.asm

### Operation

The program divides `50000` by `300`.

Before division:

```text
DX:AX = 0000:50000
BX = 300
```

The instruction is:

```asm
div bx
```

For a 16-bit divisor, `DIV` uses the 32-bit `DX:AX` pair as the dividend.

Calculation:

```text
50000 ÷ 300 = 166 remainder 200
```

After division:

```text
AX = 166       ; quotient
DX = 200       ; remainder
```

### Checking the result

The result can be verified as:

```text
(300 × 166) + 200 = 50000
```

Therefore, the division is correct.

### Flags

`DIV` does not define the status flags. Consequently, their values after
the instruction are undefined.

| Flag | Status    |
| ---- | --------- |
| CF   | Undefined |
| ZF   | Undefined |
| SF   | Undefined |
| OF   | Undefined |
| PF   | Undefined |
| AF   | Undefined |

The meaningful results are:

```text
Quotient  = 166
Remainder = 200
```

---

## 3. div3.asm

### Operation

The program divides `300000000` by `1000`.

Before division:

```text
EDX:EAX = 00000000:300000000
EBX = 1000
```

The instruction is:

```asm
div ebx
```

For a 32-bit divisor, `DIV` uses the 64-bit `EDX:EAX` pair as the dividend.

Calculation:

```text
300000000 ÷ 1000 = 300000
```

There is no remainder.

After division:

```text
EAX = 300000       ; quotient
EDX = 0            ; remainder
```

### Checking the result

```text
1000 × 300000 + 0 = 300000000
```

Therefore:

```text
Quotient  = 300000
Remainder = 0
```

### Flags

As with the previous programs, `DIV` leaves the status flags undefined.

| Flag | Status    |
| ---- | --------- |
| CF   | Undefined |
| ZF   | Undefined |
| SF   | Undefined |
| OF   | Undefined |
| PF   | Undefined |
| AF   | Undefined |

The fact that the remainder is zero does **not** mean that `ZF` is set.
`DIV` does not set `ZF` according to whether the remainder is zero.

---

# Summary

| Program     | Dividend  | Divisor | Quotient | Remainder |
| ----------- | --------- | ------- | -------- | --------- |
| `div1.asm`  | 100       | 7       | 14       | 2         |
| `dive2.asm` | 50000     | 300     | 166      | 200       |
| `div3.asm`  | 300000000 | 1000    | 300000   | 0         |

## Flags Summary

| Program     | CF        | ZF        | SF        | OF        | PF        | AF        |
| ----------- | --------- | --------- | --------- | --------- | --------- | --------- |
| `div1.asm`  | Undefined | Undefined | Undefined | Undefined | Undefined | Undefined |
| `dive2.asm` | Undefined | Undefined | Undefined | Undefined | Undefined | Undefined |
| `div3.asm`  | Undefined | Undefined | Undefined | Undefined | Undefined | Undefined |

## Important Point

The `DIV` instruction is different from most of the arithmetic instructions
used in this folder. It does not provide defined values for the condition
flags.

Instead, the result is returned through specific registers:

```text
8-bit DIV:
AX ÷ operand → AL = quotient, AH = remainder

16-bit DIV:
DX:AX ÷ operand → AX = quotient, DX = remainder

32-bit DIV:
EDX:EAX ÷ operand → EAX = quotient, EDX = remainder
```

The programs above use unsigned division, and all three divisions produce a
valid quotient and remainder without a division overflow.
