# ADD — Arithmetic Programs

This folder contains three x86 assembly programs demonstrating addition using
8-bit and 16-bit operands. The programs also demonstrate how arithmetic
operations affect the CPU flags.

## Programs

* `file-add1.asm` — 8-bit addition
* `add16.asm` — 16-bit addition
* `add3.asm` — 16-bit addition with carry and `ADC`

---

# 1. file-add1.asm

### Operation

```asm
num1 = 120
num2 = 10

120 + 10 = 130
```

The values are stored as bytes (`db`), so the addition is performed in the
8-bit `AL` register.

### Binary calculation

```text
  01111000   (120)
+ 00001010   (10)
-----------
  10000010   (130)
```

The result is:

```text
AL = 10000010b = 130 unsigned
```

### Flags after `ADD AL, [num2]`

| Flag | Status          | Explanation                                                                                                                                           |
| ---- | --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| CF   | **0 (cleared)** | There is no carry out of the most significant bit. The result fits within 8 bits.                                                                     |
| ZF   | **0 (cleared)** | The result is `10000010`, which is not zero.                                                                                                          |
| SF   | **1 (set)**     | The most significant bit of the 8-bit result is `1`.                                                                                                  |
| OF   | **1 (set)**     | Both operands are positive signed numbers (`120` and `10`), but the 8-bit signed result becomes negative (`-126`). Therefore, signed overflow occurs. |
| PF   | **0 (cleared)** | The low byte `10000010` contains three `1` bits, which is odd parity.                                                                                 |
| AF   | **1 (set)**     | The lower nibbles are `1000 + 1010 = 1 0010`, producing a carry from bit 3 to bit 4.                                                                  |

### Important note

Although `130` is a valid **unsigned** 8-bit value, the maximum positive
signed 8-bit value is `127`.

Therefore:

```text
Unsigned: 120 + 10 = 130       → valid
Signed:   120 + 10 = 130       → overflow
```

This explains why **CF = 0** but **OF = 1**.

---

# 2. add16.asm

### Operation

```asm
num1 = 32000
num2 = 500

32000 + 500 = 32500
```

The addition is performed using the 16-bit `AX` register.

### Binary calculation

```text
32000 = 0111110100000000
  500 = 0000000111110100
--------------------------------
32500 = 0111111011110100
```

The result is:

```text
AX = 32500
```

### Flags immediately after `ADD AX, [num2]`

| Flag | Status          | Explanation                                                                                                                                                    |
| ---- | --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CF   | **0 (cleared)** | No carry is produced beyond the 16th bit. `32500` fits within an unsigned 16-bit value.                                                                        |
| ZF   | **0 (cleared)** | The result is `32500`, not zero.                                                                                                                               |
| SF   | **0 (cleared)** | The most significant bit of the 16-bit result is `0`, so the result is positive in signed representation.                                                      |
| OF   | **1 (set)**     | Both operands are positive signed numbers, but `32000 + 500 = 32500`, which is greater than the maximum signed 16-bit value `32767`? **No. Therefore OF = 0.** |
| PF   | **0 (cleared)** | The low byte of `32500` is `0xF4` (`11110100`), which contains five `1` bits, giving odd parity.                                                               |
| AF   | **0 (cleared)** | The lower nibbles are `0000 + 0100`, producing no carry from bit 3 to bit 4.                                                                                   |

### Corrected flag summary

The actual flags immediately after the `ADD` are:

```text
CF = 0
ZF = 0
SF = 0
OF = 0
PF = 0
AF = 0
```

### Why is OF cleared?

The largest positive signed 16-bit integer is:

```text
32767
```

Since:

```text
32000 + 500 = 32500
```

and:

```text
32500 < 32767
```

there is **no signed overflow**.

---

# 3. add3.asm

### Operation

```asm
num1 = 0xFFFF
num2 = 1

0xFFFF + 1 = 0x10000
```

Because `AX` is a 16-bit register, it can only store the lower 16 bits.

Therefore:

```text
0x10000 → 0x0000
```

and a carry is generated.

### Binary calculation

```text
  1111111111111111
+ 0000000000000001
------------------
1 0000000000000000
^
Carry
```

Immediately after:

```asm
add ax, [num2]
```

the CPU has:

```text
AX = 0000h
CF = 1
```

### Flags immediately after `ADD`

| Flag | Status          | Explanation                                                                                             |
| ---- | --------------- | ------------------------------------------------------------------------------------------------------- |
| CF   | **1 (set)**     | The addition produces a carry beyond bit 15. `0xFFFF + 1 = 0x10000`.                                    |
| ZF   | **1 (set)**     | The 16-bit result stored in `AX` is `0`.                                                                |
| SF   | **0 (cleared)** | The most significant bit of `0000` is `0`.                                                              |
| OF   | **0 (cleared)** | `0xFFFF` represents `-1` as a signed 16-bit number. `-1 + 1 = 0`, so there is no signed overflow.       |
| PF   | **1 (set)**     | The low byte of the result is `00000000`, which contains zero `1` bits. Zero is considered even parity. |
| AF   | **1 (set)**     | The lower nibble is `1111 + 0001`, producing a carry from bit 3 to bit 4.                               |

Therefore, immediately after the `ADD`:

```text
CF = 1
ZF = 1
SF = 0
OF = 0
PF = 1
AF = 1
```

---

## Effect of `ADC`

The program then executes:

```asm
adc ax, 0
```

`ADC` means **Add with Carry**.

It performs:

```text
AX = AX + 0 + CF
```

At this point:

```text
AX = 0000h
CF = 1
```

Therefore:

```text
AX = 0000h + 0 + 1
AX = 0001h
```

So the final value stored in `result` is:

```text
0001h
```

### Important distinction

The flags listed above describe the result of the **`ADD` instruction**.

However, `ADC` is another arithmetic instruction and therefore **changes the flags again**.

After:

```asm
adc ax, 0
```

the relevant final flags become:

```text
CF = 0
ZF = 0
SF = 0
OF = 0
PF = 0
AF = 0
```

because:

```text
0 + 0 + 1 = 1
```

---

# Overall Summary

| Program                  | Operation      | Result      | CF | ZF | SF | OF | PF | AF |
| ------------------------ | -------------- | ----------- | -- | -- | -- | -- | -- | -- |
| `file-add1.asm`          | 120 + 10       | 130 (`82h`) | 0  | 0  | 1  | 1  | 0  | 1  |
| `add16.asm`              | 32000 + 500    | 32500       | 0  | 0  | 0  | 0  | 0  | 0  |
| `add3.asm` — after `ADD` | FFFFh + 1      | 0000h       | 1  | 1  | 0  | 0  | 1  | 1  |
| `add3.asm` — after `ADC` | 0000h + 0 + CF | 0001h       | 0  | 0  | 0  | 0  | 0  | 0  |

## Key Concepts Demonstrated

### Carry Flag (CF)

Indicates an unsigned carry out of the most significant bit.

```text
FFFFh + 1 = 10000h
           ↑
          CF = 1
```

### Zero Flag (ZF)

Set when the result is zero.

```text
FFFFh + 1 → 0000h
            ↑
           ZF = 1
```

### Sign Flag (SF)

Copies the most significant bit of the result.

For an 8-bit result:

```text
10000010
↑
SF = 1
```

### Overflow Flag (OF)

Indicates signed arithmetic overflow.

For `120 + 10`:

```text
120 + 10 = 130
```

But the largest signed 8-bit number is `127`, so:

```text
OF = 1
```

### Parity Flag (PF)

PF is based only on the **lowest byte** of the result.

An even number of `1` bits gives:

```text
PF = 1
```

An odd number of `1` bits gives:

```text
PF = 0
```

### Auxiliary Carry Flag (AF)

AF is set when a carry occurs from bit 3 to bit 4, which is particularly
important in BCD arithmetic.

---

## Note on Flag Timing

When documenting flags for assembly programs, always specify **which
instruction's flags** are being discussed.

For example, in `add3.asm`:

```asm
add ax, [num2]
adc ax, 0
```

The `ADC` instruction changes the flags produced by the preceding `ADD`.
Therefore, the flags immediately after `ADD` are different from the final
flags after `ADC`.

For this assignment, the most useful values to document are the flags
**immediately after the arithmetic instruction being analyzed**.
