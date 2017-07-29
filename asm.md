RISC-V Assembler
=========================

This document gives an overview of RISC-V assembly language.


### Assembler Directives

The following table lists assembler directives:

Directive    | Arguments                      | Description
:----------- | :-------------                 | :---------------
<code><sub>.align</sub></code>       | <sub>integer</sub>                        | <sub>align to power of 2 (alias for .p2align)</sub>
<code><sub>.file</sub></code>        | <sub>"filename"</sub>                     | <sub>emit filename FILE LOCAL symbol table</sub>
<code><sub>.globl</sub></code>       | <sub>symbol_name</sub>                    | <sub>emit symbol_name to symbol table (scope GLOBAL)</sub>
<code><sub>.local</sub></code>       | <sub>symbol_name</sub>                    | <sub>emit symbol_name to symbol table (scope LOCAL)</sub>
<code><sub>.comm</sub></code>        | <sub>symbol_name,size,align</sub>         | <sub>emit common object to .bss section</sub>
<code><sub>.common</sub></code>      | <sub>symbol_name,size,align</sub>         | <sub>emit common object to .bss section</sub>
<code><sub>.ident</sub></code>       | <sub>"string"</sub>                       | <sub>accepted for source compatibility</sub>
<code><sub>.section</sub></code>     | <sub>[{.text,.data,.rodata,.bss}]</sub>   | <sub>emit section (if not present, default .text) and make current</sub>
<code><sub>.size</sub></code>        | <sub>symbol, symbol</sub>                 | <sub>accepted for source compatibility</sub>
<code><sub>.text</sub></code>        |                                           | <sub>emit .text section (if not present) and make current</sub>
<code><sub>.data</sub></code>        |                                           | <sub>emit .data section (if not present) and make current</sub>
<code><sub>.rodata</sub></code>      |                                           | <sub>emit .rodata section (if not present) and make current</sub>
<code><sub>.bss</sub></code>         |                                           | <sub>emit .bss section (if not present) and make current</sub>
<code><sub>.string</sub></code>      | <sub>"string"</sub>                       | <sub>emit string</sub>
<code><sub>.asciz</sub></code>       | <sub>"string"</sub>                       | <sub>emit string (alias for .string)</sub>
<code><sub>.equ</sub></code>         | <sub>name, value</sub>                    | <sub>constant definition</sub>
<code><sub>.macro</sub></code>       | <sub>name arg1 [, argn]</sub>             | <sub>begin macro definition \argname to substitute</sub>
<code><sub>.endm</sub></code>        |                                           | <sub>end macro definition</sub>
<code><sub>.type</sub></code>        | <sub>symbol, @function</sub>              | <sub>accepted for source compatibility</sub>
<code><sub>.option</sub></code>      | <sub>{rvc,norvc,pic,nopic,push,pop}</sub> | <sub>RISC-V options</sub>
<code><sub>.byte</sub></code>        |                                           | <sub>8-bit comma separated words</sub>
<code><sub>.2byte</sub></code>       |                                           | <sub>16-bit comma separated words (unaligned)</sub>
<code><sub>.4byte</sub></code>       |                                           | <sub>32-bit comma separated words (unaligned)</sub>
<code><sub>.8byte</sub></code>       |                                           | <sub>64-bit comma separated words (unaligned)</sub>
<code><sub>.half</sub></code>        |                                           | <sub>16-bit comma separated words (naturally aligned)</sub>
<code><sub>.word</sub></code>        |                                           | <sub>32-bit comma separated words (naturally aligned)</sub>
<code><sub>.dword</sub></code>       |                                           | <sub>64-bit comma separated words (naturally aligned)</sub>
<code><sub>.dtprelword</sub></code>  |                                           | <sub>32-bit thread local word</sub>
<code><sub>.dtpreldword</sub></code> |                                           | <sub>64-bit thread local word</sub>
<code><sub>.sleb128</sub></code>     | <sub>expression</sub>                     | <sub>signed little endian base 128, DWARF</sub>
<code><sub>.uleb128</sub></code>     | <sub>expression</sub>                     | <sub>unsigned little endian base 128, DWARF</sub>
<code><sub>.p2align</sub></code>     | <sub>p2,[pad_val=0],max</sub>             | <sub>align to power of 2</sub>
<code><sub>.balign</sub></code>      | <sub>b,[pad_val=0]</sub>                  | <sub>byte align</sub>
<code><sub>.zero</sub></code>        | <sub>integer</sub>                        | <sub>zero bytes</sub>


### Function expansions

The following table lists assembler function expansions:

Assembler Notation       | Description                 | Instruction / Macro
:----------------------  | :---------------            | :-------------------
<code><sub>%hi(symbol)</sub></code>              | <sub>Absolute (HI20)</sub>             | <sub>lui</sub>
<code><sub>%lo(symbol)</sub></code>              | <sub>Absolute (LO12)</sub>             | <sub>load, store, add</sub>
<code><sub>%pcrel_hi(symbol)</sub></code>        | <sub>PC-relative (HI20)</sub>          | <sub>auipc</sub>
<code><sub>%pcrel_lo(label)</sub></code>         | <sub>PC-relative (LO12)</sub>          | <sub>load, store, add</sub>
<code><sub>%tprel_hi(symbol)</sub></code>        | <sub>TLS LE "Local Exec"</sub>         | <sub>auipc</sub>
<code><sub>%tprel_lo(label)</sub></code>         | <sub>TLS LE "Local Exec"</sub>         | <sub>load, store, add</sub>
<code><sub>%tprel_add(offset)</sub></code>       | <sub>TLS LE "Local Exec"</sub>         | <sub>add</sub>


### Labels

Text labels are used as branch, unconditional jump targets and symbol offsets.
Text labels are added to the symbol table of the compiled module.

```
loop:
        j loop
```

Numeric labels are used for local references. References to local labels are
suffixed with 'f' for a forward reference or 'b' for a backwards reference.

```
1:
        j 1b
```


### Absolute addressing

The following example shows how to load an absolute address:

```
.section .text
.globl _start
_start:
	    lui a1,       %hi(msg)       # load msg(hi)
	    addi a1, a1,  %lo(msg)       # load msg(lo)
	    jalr ra, puts
2:	    j2b

.section .rodata
msg:
	    .string "Hello World\n"
```

which generates the following assembler output and relocations
as seen by objdump:

```
0000000000000000 <_start>:
   0:	000005b7          	lui	a1,0x0
			0: R_RISCV_HI20	msg
   4:	00858593          	addi	a1,a1,8 # 8 <.L21>
			4: R_RISCV_LO12_I	msg
```


### Relative addressing

The following example shows how to load a PC-relative address:

```
.section .text
.globl _start
_start:
1:	    auipc a1,     %pcrel_hi(msg) # load msg(hi)
	    addi  a1, a1, %pcrel_lo(1b)  # load msg(lo)
	    jalr ra, puts
2:	    j2b

.section .rodata
msg:
	    .string "Hello World\n"
```

which generates the following assembler output and relocations
as seen by objdump:

```
0000000000000000 <_start>:
   0:	00000597          	auipc	a1,0x0
			0: R_RISCV_PCREL_HI20	msg
   4:	00858593          	addi	a1,a1,8 # 8 <.L21>
			4: R_RISCV_PCREL_LO12_I	.L11
```

### Load Immediate

The following example shows the `li` psuedo instruction which
is used to load immediate values:

```
.section .text
.globl _start
_start:

.equ CONSTANT, 0xcafebabe

        li a0, CONSTANT
```

which generates the following assembler output as seen by objdump:

```
0000000000000000 <_start>:
   0:	00032537          	lui	    a0,0x32
   4:	bfb50513          	addi	a0,a0,-1029
   8:	00e51513          	slli	a0,a0,0xe
   c:	abe50513          	addi	a0,a0,-1346
```


### Load Address

The following example shows the `la` psuedo instruction which
is used to load symbol addresses:

```
.section .text
.globl _start
_start:

        la a0, msg

.section .rodata
msg:
	    .string "Hello World\n"
```

which generates the following assembler output and relocations
as seen by objdump:

```
0000000000000000 <_start>:
   0:	00000517          	auipc	a0,0x0
			0: R_RISCV_PCREL_HI20	msg
   4:	00850513          	addi	a0,a0,8 # 8 <_start+0x8>
			4: R_RISCV_PCREL_LO12_I	.L11
```


### Constants

The following example shows loading a constant using the %hi and
%lo assembler functions.

```
.equ UART_BASE, 0x40003000

        lui a0,      %hi(UART_BASE)
        addi a0, a0, %lo(UART_BASE)
```

This example uses the `li` pseudo instruction to load a constant
and writes a string using polled IO to a UART:

```
.equ UART_BASE, 0x40003000
.equ REG_RBR, 0
.equ REG_TBR, 0
.equ REG_IIR, 2
.equ IIR_TX_RDY, 2
.equ IIR_RX_RDY, 4

.section .text
.globl _start
_start:
1:      auipc a0, %pcrel_hi(msg)    # load msg(hi)
        addi a0, a0, %pcrel_lo(1b)  # load msg(lo)
2:      jal ra, puts
3:      j 3b

puts:
        li a2, UART_BASE
1:      lbu a1, (a0)
        beqz a1, 3f
2:      lbu a3, REG_IIR(a2)
        andi a3, a3, IIR_TX_RDY
        beqz a3, 2b
        sb a1, REG_TBR(a2)
        addi a0, a0, 1
        j 1b
3:      ret

.section .rodata
msg:
	    .string "Hello World\n"
```


### Control and Status Registers

The following code sample shows how to enable timer interrupts,
set and wait for a timer interrupt to occur:

```
.equ RTC_BASE,      0x40000000
.equ TIMER_BASE,    0x40004000

# setup machine trap vector
1:      auipc   t0, %pcrel_hi(mtvec)        # load mtvec(hi)
        addi    t0, t0, %pcrel_lo(1b)       # load mtvec(lo)
        csrrw   zero, mtvec, t0

# set mstatus.MIE=1 (enable M mode interrupt)
        li      t0, 8
        csrrs   zero, mstatus, t0

# set mie.MTIE=1 (enable M mode timer interrupts)
        li      t0, 128
        csrrs   zero, mie, t0

# read from mtime
        li      a0, RTC_BASE
        ld      a1, 0(a0)

# write to mtimecmp
        li      a0, TIMER_BASE
        li      t0, 1000000000
        add     a1, a1, t0
        sd      a1, 0(a0)

# loop
loop:
        wfi
        j loop

# break on interrupt
mtvec:
        csrrc  t0, mcause, zero
        bgez t0, fail       # interrupt causes are less than zero
        slli t0, t0, 1      # shift off high bit
        srli t0, t0, 1
        li t1, 7            # check this is an m_timer interrupt
        bne t0, t1, fail
        j pass

pass:
        la a0, pass_msg
        jal puts
        j shutdown

fail:
        la a0, fail_msg
        jal puts
        j shutdown

.section .rodata

pass_msg:
        .string "PASS\n"

fail_msg:
        .string "FAIL\n"
```
