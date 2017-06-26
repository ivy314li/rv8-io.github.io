### About

**rv8** is a RISC-V simulation suite comprising a high performance x86-64 binary translator, a user mode simulator, a full system emulator, an ELF binary analysis tool and ISA metadata:

> * **rv-jit** - _user mode x86-64 binary translator_
> * **rv-sim** - _user mode system call proxy simulator_
> * **rv-sys** - _full system emulator with soft MMU_
> * **rv-bin** - _ELF disassembler and histogram tool_
> * **rv-meta** - _code and documentation generator_

The rv8 simulator suite contains libraries and command line tools for creating instruction opcode maps, C headers and source containing instruction set metadata, instruction decoders, a JIT assembler, LaTeX documentation, a metadata based RISC-V disassembler, a histogram tool for generating statistics on RISC-V ELF executables, a RISC-V proxy syscall simulator, a RISC-V full system emulator that implements the RISC-V 1.9.1 privileged specification and an x86-64 binary translator.

![rv8 binary translation]({{ site.url }}/images/bintrans.png)

_**RISC-V to x86-64 binary translation**_

The rv8 binary translation engine works by interpreting code while profiling it for hot paths. Hot paths are translated on the fly to native code. The translation engine maintains a call stack to allow runtime inlining of hot functions. A jump target cache is used to accelerate returns and indirect calls through function pointers. The translator supports hybrid binary translation and interpretation to handle instructions that do not have native translations. Currently ‘IM’ code is translated and ‘AFD’ is interpreted. The translator supports RVC compressed code.

The current version is available [here](https://github.com/rv8-io/rv8).

---

### Supported Platforms

- Target
  - RV32IMAFDC
  - RV64IMAFDC
  - Privilged ISA 1.9.1
- Host
  - Linux (Debian 9.0 x86-64, Ubuntu 16.04 x86-64, Fedora 25 x86-64) _(stable)_
  - macOS (Sierra 10.11 x86-64) _(stable)_
  - FreeBSD (11 x86-64) _(alpha)_

---

### Getting Started

_Building riscv-gnu-toolchain_

```
$ sudo apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev
$ git clone https://github.com/riscv/riscv-gnu-toolchain.git
$ cd riscv-gnu-toolchain
$ git submodule update --init --recursive
$ ./configure --prefix=/opt/riscv/toolchain
$ make
```

_Building rv8_

```
$ export RISCV=/opt/riscv/toolchain
$ git clone https://github.com/rv8-io/rv8.git
$ cd rv8
$ git submodule update --init --recursive
$ make
$ sudo make install
```

_Running rv8_

```
$ make test-build
$ rv-jit build/riscv64-unknown-elf/bin/test-dhrystone
```

---

### Benchmarks

_Runtime (seconds)_

program         | rv8-sim | rv8-jit | qemu-user | native
---             | ---     | ---     | ---       | ---
primes          |  5.07   | 0.16    | 0.27      | 0.11
miniz           | 41.52   | 1.82    | 2.20      | 0.76
SHA-512         | 23.69   | 0.70    | 1.12      | 0.24
AES             | 38.39   | 1.00    | 1.61      | 0.27
qsort           |  3.96   | 0.19    | 0.94      | 0.13
dhrystone       | 22.30   | 0.46    | 2.21      | 0.10
DMIPS (v1.1)    | 254     | 12492   | 2576      | 55132

_Performance Ratio (smaller is better)_

program         | rv8-sim | rv8-jit | qemu-user | native
---             | ---     | ---     | ---       | ---
primes          |  44.43  | 1.40    |  2.36     | 1.00
miniz           |  55.00  | 2.41    |  2.92     | 1.00
SHA-512         | 100.39  | 2.95    |  4.76     | 1.00
AES             | 140.12  | 3.63    |  5.88     | 1.00
qsort           |  29.52  | 1.41    |  7.04     | 1.00
dhrystone       | 214.45  | 4.38    | 21.23     | 1.00
Ratio (average) |   97:1  | 2.7:1   | 7.4:1     | 1:1

Notes:

- riscv32/riscv64 (gcc -Os) 7.0.1 20170321 (experimental)
- x86-32/x86-64 (gcc -O3) (Debian 6.3.0-6) 6.3.0 20170205
- native Intel(R) Core(TM) i7-5557U CPU @ 3.10GHz

---

### Logging

_Sample output from `rv-sim` with the `--log-instructions` option_

```
$ rv-sim -l build/riscv64-unknown-elf/bin/hello-world-pcrel
0000000000000000000 core-0   :0000000000010078 (4501    ) mv          a0, zero           
0000000000000000001 core-0   :000000000001007a (00000597) auipc       a1, pc + 0         
0000000000000000002 core-0   :000000000001007e (02658593) addi        a1, a1, 38         
0000000000000000003 core-0   :0000000000010082 (4631    ) addi        a2, zero, 12       
0000000000000000004 core-0   :0000000000010084 (4681    ) mv          a3, zero           
0000000000000000005 core-0   :0000000000010086 (04000893) addi        a7, zero, 64       
Hello World
0000000000000000006 core-0   :000000000001008a (00000073) ecall                          
0000000000000000007 core-0   :000000000001008e (4501    ) mv          a0, zero           
0000000000000000008 core-0   :0000000000010090 (4581    ) mv          a1, zero           
0000000000000000009 core-0   :0000000000010092 (4601    ) mv          a2, zero           
0000000000000000010 core-0   :0000000000010094 (4681    ) mv          a3, zero           
0000000000000000011 core-0   :0000000000010096 (05d00893) addi        a7, zero, 93       
```

---

### Tracing

_Sample output from `rv-jit` with the `--log-jit-trace` option_

```
	# 0x0000000000103d70	addi        a0, zero, 1
		mov r8, 1                               ; 41B801000000
		L3:
	# 0x0000000000103d74	slli        a0, a0, 28
		shl r8, 1C                              ; 49C1E01C
		L4:
	# 0x0000000000103d78	addi        a1, zero, -1
		mov r9, FFFFFFFFFFFFFFFF                ; 49C7C1FFFFFFFF
		L5:
	# 0x0000000000103d7c	sb          a1, 0(a0)
		rex mov byte [r8], r9b                  ; 458808
		L6:
	# 0x0000000000103d80	lbu         a2, 0(a0)
		movzx r10d, byte [r8]                   ; 450FB610
		L7:
```

---

### Building and running Linux

_Building riscv-gnu-toolchain_ for linux

```
$ cd riscv-gnu-toolchain
$ make linux
```

_Building linux, busybox and bbl-lite_

```
$ cd rv8
$ make linux
```

_Running the full system emulator_

```
$ rv-sys build/riscv64-unknown-elf/bin/bbl
              vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
                  vvvvvvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrrrr    vvvvvvvvvvvvvvvvvvvvvvvv
rrrrrrrrrrrrrrrr      vvvvvvvvvvvvvvvvvvvvvv  
rrrrrrrrrrrrr       vvvvvvvvvvvvvvvvvvvvvv    
rr                vvvvvvvvvvvvvvvvvvvvvv      
rr            vvvvvvvvvvvvvvvvvvvvvvvv      rr
rrrr      vvvvvvvvvvvvvvvvvvvvvvvvvv      rrrr
rrrrrr      vvvvvvvvvvvvvvvvvvvvvv      rrrrrr
rrrrrrrr      vvvvvvvvvvvvvvvvvv      rrrrrrrr
rrrrrrrrrr      vvvvvvvvvvvvvv      rrrrrrrrrr
rrrrrrrrrrrr      vvvvvvvvvv      rrrrrrrrrrrr
rrrrrrrrrrrrrr      vvvvvv      rrrrrrrrrrrrrr
rrrrrrrrrrrrrrrr      vv      rrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrr          rrrrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrrrr      rrrrrrrrrrrrrrrrrrrr
rrrrrrrrrrrrrrrrrrrrrr  rrrrrrrrrrrrrrrrrrrrrr

       INSTRUCTION SETS WANT TO BE FREE
[    0.000000] Linux version 4.6.2-00043-g23bf08e-dirty (mclark@minty) (gcc version 7.0.1 20170321 (experimental) (GCC) ) #21 Sun May 28 11:00:48 NZST 2017
[    0.000000] bootconsole [early0] enabled
[    0.000000] Available physical memory: 1020MB
[    0.000000] Initial ramdisk at: 0xffffffff800100b0 (261728 bytes)
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000080400000-0x00000000bfffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000080400000-0x00000000bfffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000080400000-0x00000000bfffffff]
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257550
[    0.000000] Kernel command line: earlyprintk=sbi-console rdinit=/sbin/init 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 1025684K/1044480K available (1701K kernel code, 125K rwdata, 488K rodata, 324K init, 230K bss, 18796K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:0 nr_irqs:0 0
[    0.000000] clocksource: riscv_clocksource: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 191126044627 ns
[    0.000000] Calibrating delay loop (skipped), value calculated using timer frequency.. 20.00 BogoMIPS (lpj=100000)
[    0.000000] pid_max: default: 32768 minimum: 301
[    0.010000] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.010000] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.010000] devtmpfs: initialized
[    0.010000] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.010000] NET: Registered protocol family 16
[    0.010000] clocksource: Switched to clocksource riscv_clocksource
[    0.010000] NET: Registered protocol family 2
[    0.010000] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.010000] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.010000] TCP: Hash tables configured (established 8192 bind 8192)
[    0.010000] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.010000] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.010000] NET: Registered protocol family 1
[    0.010000] Unpacking initramfs...
[    0.010000] console [sbi_console0] enabled
[    0.010000] console [sbi_console0] enabled
[    0.010000] bootconsole [early0] disabled
[    0.010000] bootconsole [early0] disabled
[    0.010000] futex hash table entries: 256 (order: 0, 6144 bytes)
[    0.010000] workingset: timestamp_bits=61 max_order=18 bucket_order=0
[    0.010000] 9p: Installing v9fs 9p2000 file system support
[    0.010000] io scheduler noop registered
[    0.010000] io scheduler cfq registered (default)
[    0.010000] 9pnet: Installing 9P2000 support
[    0.010000] Freeing unused kernel memory: 324K (ffffffff80000000 - ffffffff80051000)
[    0.010000] This architecture does not have kernel memory protection.


BusyBox v1.26.1 (2017-05-28 10:59:45 NZST) built-in shell (ash)
Enter 'help' for a list of built-in commands.

/ # 
```
