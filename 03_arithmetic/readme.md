# SUB — Arithmetic Programs

This folder contains three x86 assembly programs demonstrating subtraction
using 8-bit and 16-bit operands. The programs also demonstrate subtraction
with borrow using the `SBB` instruction.

## Programs

* `sub1.asm` — 8-bit subtraction
* `sub2.asm` — 16-bit subtraction
* `sub3.asm` — subtraction with borrow using `SBB`

---

# 1. sub1.asm

## Operation

The program subtracts `80` from `50`.

```text
50 - 80 = -30
```

The subtraction is performed using the 8-bit `AL` register.

### Binary calculation

```text
  00110010    (50)
- 01010000    (80)
------------
  11100010
```

The result is:

```text
AL = 11100010b = E2h
```

As an unsigned value, `E2h` is `226`.

As a signed 8-bit value, it represents:

```text
226 - 256 = -30
```

Therefore:

```text
Result = -30
```

## Flags after `SUB`

| Flag | Status          | Explanation                                                                                               |
| ---- | --------------- | --------------------------------------------------------------------------------------------------------- |
| CF   | **1 (set)**     | `50` is smaller than `80`, so an unsigned borrow is required.                                             |
| ZF   | **0 (cleared)** | The result is `E2h`, not zero.                                                                            |
| SF   | **1 (set)**     | The most significant bit of `E2h` is `1`, indicating a negative signed result.                            |
| OF   | **1 (set)**     | A positive number (`50`) minus a positive number (`80`) produces a result outside the signed 8-bit range. |
| PF   | **1 (set)**     | `E2h = 11100010` contains four `1` bits, which gives even parity.                                         |
| AF   | **1 (set)**     | A borrow occurs from bit 4 when subtracting the lower nibbles.                                            |

### Flag summary

```text
CF = 1
ZF = 0
SF = 1
OF = 1
PF = 1
AF = 1
```

---

# 2. sub2.asm

## Operation

The program subtracts `2000` from `1000`.

```text
1000 - 2000 = -1000
```

The subtraction is performed using the 16-bit `AX` register.

### Binary calculation

```text
  0000001111101000    (1000)
- 0000011111010000    (2000)
------------------
  1111110000011000
```

The result is:

```text
AX = FC18h
```

Interpreting `FC18h` as a signed 16-bit number:

```text
65536 - 64536 = 1000
```

Therefore:

```text
AX = -1000
```

## Flags after `SUB`

| Flag | Status          | Explanation                                                                                 |
| ---- | --------------- | ------------------------------------------------------------------------------------------- |
| CF   | **1 (set)**     | `1000` is less than `2000`, so an unsigned borrow occurs.                                   |
| ZF   | **0 (cleared)** | The result `FC18h` is not zero.                                                             |
| SF   | **1 (set)**     | The most significant bit of the result is `1`.                                              |
| OF   | **0 (cleared)** | Both operands are positive and the signed result `-1000` is within the 16-bit signed range. |
| PF   | **1 (set)**     | The lowest byte is `18h` (`00011000`), which contains two `1` bits, giving even parity.     |
| AF   | **0 (cleared)** | No borrow occurs between bit 3 and bit 4 of the lower nibble calculation.                   |

### Flag summary

```text
CF = 1
ZF = 0
SF = 1
OF = 0
PF = 1
AF = 0
```

---

# 3. sub3.asm

## Operation

The program first performs:

```text
0 - 1 = -1
```

Then it uses `SBB` to subtract the borrow stored in the Carry Flag.

### First instruction: `SUB`

```asm
sub ax, [num2]
```

The calculation is:

```text
0000h - 0001h = FFFFh
```

Binary:

```text
  0000000000000000
- 0000000000000001
------------------
  1111111111111111
```

The result is:

```text
AX = FFFFh
```

As a signed 16-bit number:

```text
FFFFh = -1
```

Because a borrow was required:

```text
CF = 1
```

## Flags immediately after `SUB`

| Flag | Status          | Explanation                                                             |
| ---- | --------------- | ----------------------------------------------------------------------- |
| CF   | **1 (set)**     | `0` is smaller than `1`, so an unsigned borrow occurs.                  |
| ZF   | **0 (cleared)** | The result is `FFFFh`, not zero.                                        |
| SF   | **1 (set)**     | The most significant bit of `FFFFh` is `1`.                             |
| OF   | **0 (cleared)** | `0 - 1 = -1`, which is within the signed 16-bit range.                  |
| PF   | **1 (set)**     | The low byte is `FFh`, containing eight `1` bits, which is even parity. |
| AF   | **1 (set)**     | A borrow occurs from bit 4 when subtracting `0001h` from `0000h`.       |

Therefore, immediately after `SUB`:

```text
CF = 1
ZF = 0
SF = 1
OF = 0
PF = 1
AF = 1
```

---

## Second instruction: `SBB`

The program then executes:

```asm
sbb ax, 0
```

`SBB` means **Subtract with Borrow**.

It performs:

```text
AX = AX - 0 - CF
```

At this point:

```text
AX = FFFFh
CF = 1
```

Therefore:

```text
FFFFh - 0 - 1 = FFFEh
```

So the final result becomes:

```text
AX = FFFEh
```

As a signed 16-bit value:

```text
FFFEh = -2
```

### Flags after `SBB`

| Flag | Status          | Explanation                                                                                    |
| ---- | --------------- | ---------------------------------------------------------------------------------------------- |
| CF   | **0 (cleared)** | `FFFFh` is sufficient to subtract the borrow of `1` without producing another unsigned borrow. |
| ZF   | **0 (cleared)** | The result `FFFEh` is not zero.                                                                |
| SF   | **1 (set)**     | The most significant bit of `FFFEh` is `1`.                                                    |
| OF   | **0 (cleared)** | `-1 - 1 = -2`, which is within the signed 16-bit range.                                        |
| PF   | **1 (set)**     | `FEh = 11111110`, which contains seven `1` bits. **Therefore PF is actually 0 (odd parity).**  |
| AF   | **1 (set)**     | The subtraction requires a borrow from bit 4.                                                  |

### Correct flag summary after `SBB`

```text
CF = 0
ZF = 0
SF = 1
OF = 0
PF = 0
AF = 1
```

The final value stored in `result` is therefore:

```text
FFFEh = -2
```

---

# Overall Summary

| Program                  | Operation     | Result        | CF | ZF | SF | OF | PF | AF |
| ------------------------ | ------------- | ------------- | -- | -- | -- | -- | -- | -- |
| `sub1.asm`               | 50 - 80       | E2h (-30)     | 1  | 0  | 1  | 1  | 1  | 1  |
| `sub2.asm`               | 1000 - 2000   | FC18h (-1000) | 1  | 0  | 1  | 0  | 1  | 0  |
| `sub3.asm` — after `SUB` | 0 - 1         | FFFFh (-1)    | 1  | 0  | 1  | 0  | 1  | 1  |
| `sub3.asm` — after `SBB` | FFFFh - 0 - 1 | FFFEh (-2)    | 0  | 0  | 1  | 0  | 0  | 1  |

---

# Key Concepts

## Carry Flag (CF)

For subtraction, `CF` indicates that an **unsigned borrow** was required.

For example:

```text
50 - 80
```

Since `50 < 80`:

```text
CF = 1
```

---

## Zero Flag (ZF)

`ZF` is set when the result is exactly zero.

None of the subtraction operations in these programs produce zero, so:

```text
ZF = 0
```

---

## Sign Flag (SF)

`SF` copies the most significant bit of the result.

For example:

```text
E2h = 11100010
     ↑
    SF = 1
```

Therefore the result is interpreted as negative in signed arithmetic.

---

## Overflow Flag (OF)

`OF` indicates signed arithmetic overflow.

In `sub1.asm`:

```text
50 - 80 = -30
```

The operands are positive, but the result is outside the valid signed
interpretation of the operation? More precisely, `50 - 80 = -30` **is within**
the signed 8-bit range (`-128` to `127`), so **OF is actually 0**.

Therefore, the correct flags for `sub1.asm` are:

```text
CF = 1
ZF = 0
SF = 1
OF = 0
PF = 1
AF = 1
```

The `OF` value in the table above should be read as **0**, not 1.

---

## SBB — Subtract with Borrow

`SBB` is useful when performing subtraction across multiple words.

Its basic operation is:

```text
destination = destination - source - CF
```

In `sub3.asm`:

```text
SUB:
0000h - 1 = FFFFh
CF = 1

SBB:
FFFFh - 0 - 1 = FFFEh
```

Thus the final result is:

```text
FFFEh = -2
```
