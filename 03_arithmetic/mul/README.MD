# MUL — Arithmetic Programs

This folder contains three programs demonstrating unsigned multiplication
using the x86 `MUL` instruction.

The three programs currently contain the same multiplication operation.

* `mul1.asm`
* `mul2.asm`
* `mul3.asm`

---

## 1. mul1.asm

### Operation

The program multiplies `25` by `10`.

```text
25 × 10 = 250
```

The first value is loaded into `AL`:

```asm
mov al, [num1]
```

Then the `MUL` instruction is used:

```asm
mul byte [num2]
```

For an 8-bit multiplication, the CPU automatically uses `AL` as one
operand and stores the 16-bit result in `AX`.

### Calculation

```text
AL = 25
num2 = 10

25 × 10 = 250
```

In hexadecimal:

```text
250 = 00FAh
```

Therefore:

```text
AX = 00FAh
```

The result is then stored in the 16-bit `result` variable.

### Flags after MUL

For unsigned `MUL`, the important defined flags are **CF** and **OF**.

| Flag | Status        | Explanation                                                                                                                                    |
| ---- | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| CF   | **1 (set)**   | The upper half of the result (`AH`) is non-zero. `AX = 00FAh`, so the multiplication cannot be represented using only the 8-bit `AL` register. |
| OF   | **1 (set)**   | The upper half of the result is non-zero, so the result does not fit entirely in the lower 8 bits.                                             |
| ZF   | **Undefined** | `MUL` does not define the Zero Flag.                                                                                                           |
| SF   | **Undefined** | `MUL` does not define the Sign Flag.                                                                                                           |
| PF   | **Undefined** | `MUL` does not define the Parity Flag.                                                                                                         |
| AF   | **Undefined** | `MUL` does not define the Auxiliary Carry Flag.                                                                                                |

### Register values

Immediately after:

```asm
mul byte [num2]
```

the important registers are:

```text
AL = FAh
AH = 00h
AX = 00FAh
```

In decimal:

```text
AX = 250
```

---

## 2. mul2.asm

`mul2.asm` contains the same instructions and operands as `mul1.asm`.

### Operation

```text
25 × 10 = 250
```

The multiplication is performed with:

```asm
mov al, [num1]
mul byte [num2]
```

The result is:

```text
AX = 00FAh = 250
```

### Flags

| Flag | Status        | Explanation                                                                                 |
| ---- | ------------- | ------------------------------------------------------------------------------------------- |
| CF   | **1 (set)**   | `AH` is non-zero? **No.** Since `AH = 00h`, the result fits in `AL`. Therefore, **CF = 0**. |
| OF   | **1 (set)**   | `AH` is non-zero? **No.** Therefore, **OF = 0**.                                            |
| ZF   | **Undefined** | `MUL` does not define ZF.                                                                   |
| SF   | **Undefined** | `MUL` does not define SF.                                                                   |
| PF   | **Undefined** | `MUL` does not define PF.                                                                   |
| AF   | **Undefined** | `MUL` does not define AF.                                                                   |

### Correct flag values

```text
CF = 0
OF = 0
ZF = Undefined
SF = Undefined
PF = Undefined
AF = Undefined
```

The result is `250`, which fits within an unsigned 8-bit value because:

```text
250 ≤ 255
```

Therefore, the upper half of `AX` is zero.

---

## 3. mul3.asm

`mul3.asm` is also identical to the previous two programs.

### Operation

```text
25 × 10 = 250
```

The result is stored in:

```text
AX = 00FAh
```

### Flags

| Flag | Status          | Explanation                                                                                                 |
| ---- | --------------- | ----------------------------------------------------------------------------------------------------------- |
| CF   | **0 (cleared)** | The upper half (`AH`) of the product is `00h`, meaning the result fits in 8 bits.                           |
| OF   | **0 (cleared)** | There is no significant upper half of the product, so there is no overflow for the unsigned multiplication. |
| ZF   | **Undefined**   | `MUL` does not define ZF.                                                                                   |
| SF   | **Undefined**   | `MUL` does not define SF.                                                                                   |
| PF   | **Undefined**   | `MUL` does not define PF.                                                                                   |
| AF   | **Undefined**   | `MUL` does not define AF.                                                                                   |

---

# Summary

Since all three programs contain the same code, they produce the same result.

| Program    | Operation | Result (`AX`) | CF | OF | ZF        | SF        | PF        | AF        |
| ---------- | --------- | ------------- | -- | -- | --------- | --------- | --------- | --------- |
| `mul1.asm` | 25 × 10   | 250 (`00FAh`) | 0  | 0  | Undefined | Undefined | Undefined | Undefined |
| `mul2.asm` | 25 × 10   | 250 (`00FAh`) | 0  | 0  | Undefined | Undefined | Undefined | Undefined |
| `mul3.asm` | 25 × 10   | 250 (`00FAh`) | 0  | 0  | Undefined | Undefined | Undefined | Undefined |

## Why CF and OF are cleared

For an 8-bit `MUL`:

```text
AL × operand → AX
```

The result is considered to fit in the 8-bit destination when the upper
8 bits (`AH`) are zero.

Here:

```text
25 × 10 = 250
250 = 11111010b
```

This fits within 8 bits:

```text
11111010
```

Therefore:

```text
AH = 00000000
```

Since the upper half of the result is zero:

```text
CF = 0
OF = 0
```

The other status flags are **undefined** after `MUL` and should not be
described as set or cleared based on the value `250`.

## Register Result

```text
AL = 11111010b = 250
AH = 00000000b = 0

AX = 0000000011111010b
   = 00FAh
   = 250
```

The `result` variable is 16 bits (`dw`), so it can store the complete
value of `AX`.
