<a href="https://rv8.io/"><img style="float: right;" src="/images/rv8.svg"></a>

## rv8 benchmark results

This document contains [rv8-bench](https://github.com/rv8-io/rv8-bench/)
results compiled using GCC 7.1.0 and musl libc. The results include runtime
and instructions per second comparisons for the QEMU and rv8 JIT engines
and native x86. The benchmark suite is compiled for aarch64, riscv64, riscv32,
x86-64 and x86-32. The results include various runtime neutral metrics
such as retired RISC-V instructions, x86 micro-ops, executable file sizes
plus dynamic register and instruction usage histograms for RISC-V.

#### Benchmark source

The following sources have been used to run the benchmarks:

- rv8 - [https://github.com/rv8-io/rv8/](https://github.com/rv8-io/rv8/)
- rv8-bench - [https://github.com/rv8-io/rv8-bench/](https://github.com/rv8-io/rv8-bench/)
- qemu-riscv - [https://github.com/riscv/riscv-qemu/](https://github.com/riscv/riscv-qemu/)
- musl-riscv-toolchain - [https://github.com/rv8-io/musl-riscv-toolchain/](https://github.com/rv8-io/musl-riscv-toolchain/)

#### Benchmark metrics

The following benchmark metrics have been plotted and tabulated:

- [Runtimes](#runtimes)
- [Optimisation](#optimisation)
- [Instructions Per Second](#instructions-per-second)
- [Retired Micro-ops](#retired-micro-ops)
- [Executable File Sizes](#executable-file-sizes)
- [Dynamic Register Usage](#dynamic-register-usage)
- [Dynamic Instruction Usage](#dynamic-instruction-usage)

#### Benchmark details

The [rv8-bench](https://github.com/rv8-io/rv8-bench/)
benchmark suite contains the following test programs:

Benchmark | Type        | Description
:--       | :--         | :--
aes       | crypto      | encrypt, decrypt and compare 30MiB of data
bigint    | numeric     | compute 23 ^ 111121 and count base 10 digits
dhrystone | synthetic   | synthetic integer workload
miniz     | compression | compress, decompress and compare 8MiB of data
norx      | crypto      | encrypt, decrypt and compare 30MiB of data
primes    | numeric     | calculate largest prime number below 33333333
qsort     | sorting     | sort array containing 50 million items
sha512    | digest      | calculate SHA-512 hash of 64MiB of data

#### Compiler details

The following compiler architectures, versions, compile options
and runtime libraries are used to run the benchmarks:

Architecture | Compiler  | C Library | Compile options
:--          | :--       | :--       | :--
x86-32       | GCC 7.1.0 | musl libc | `'-O3'`, `'-O2'` and `'-Os'`
x86-64       | GCC 7.1.0 | musl libc | `'-O3'`, `'-O2'` and `'-Os'`
riscv32      | GCC 7.1.0 | musl libc | `'-O3'`, `'-O2'` and `'-Os'`
riscv64      | GCC 7.1.0 | musl libc | `'-O3'`, `'-O2'` and `'-Os'`
aarch64      | GCC 7.1.0 | musl libc | `'-O3'`, `'-O2'` and `'-Os'`

#### Measurement details

- rv8 benchmarks use `rv-jit`
- Dynamic instruction counts are measured using `rv-sim -E`
- QEMU benchmarks use `qemu-riscv32`, `qemu-riscv64` and `qemu-aarch64`
- Benchmarks are run 20 times and the best result is taken
- All programs are compiled as position independent executables (`-fPIE`)
- Host: Intel® 6th-gen Core™ i7-5557U Broadwell (3.10-3.40GHz, 4MB cache)
- x86-64 μops measured with
  - `perf stat -e cycles,instructions,r1b1,r10e,r2c2,r1c2 <cmd>`


### Runtimes

Runtime results comparing qemu, rv8 and native x86:

![benchmark runtimes -O3 64-bit]({{ site.url }}/plots/runtime-O3-64.svg)
_Figure 1: Benchmark runtimes -O3 64-bit_

**Runtime 64-bit -O3 (seconds)**

program | qemu-aarch64 | qemu-riscv64 | rv8-riscv64 | native-x86-64
:-- | --: | --: | --: | --:
aes | 1.31 | 2.16 | 1.53 | 0.32
bigint | 1.38 | 1.08 | 0.71 | 0.38
dhrystone | 0.98 | 0.57 | 0.20 | 0.10
miniz | 2.66 | 2.21 | 1.60 | 0.77
norx | 0.60 | 1.17 | 1.20 | 0.22
primes | 2.09 | 1.26 | 0.70 | 0.60
qsort | 7.38 | 4.76 | 1.22 | 0.64
sha512 | 0.64 | 1.24 | 0.81 | 0.24
_(Sum)_ | 17.04 | 14.45 | 7.97 | 3.27

**Performance Ratio 64-bit -O3 (smaller is better)**

program | qemu-aarch64 | qemu-riscv64 | rv8-riscv64 | native-x86-64
:-- | --: | --: | --: | --:
aes | 4.12 | 6.76 | 4.81 | 1.00
bigint | 3.62 | 2.83 | 1.85 | 1.00
dhrystone | 9.96 | 5.87 | 2.05 | 1.00
miniz | 3.46 | 2.86 | 2.07 | 1.00
norx | 2.73 | 5.33 | 5.47 | 1.00
primes | 3.49 | 2.11 | 1.17 | 1.00
qsort | 11.55 | 7.46 | 1.91 | 1.00
sha512 | 2.66 | 5.13 | 3.36 | 1.00
_(Geomean)_ | 4.44 | 4.39 | 2.51 | 1.00

![benchmark runtimes -O2 64-bit]({{ site.url }}/plots/runtime-O2-64.svg)
_Figure 2: Benchmark runtimes -O2 64-bit_

**Runtime 64-bit -O2 (seconds)**

program | qemu-aarch64 | qemu-riscv64 | rv8-riscv64 | native-x86-64
:-- | --: | --: | --: | --:
aes | 1.32 | 2.18 | 1.53 | 0.32
bigint | 1.34 | 1.03 | 1.44 | 0.38
dhrystone | 1.77 | 1.06 | 0.24 | 0.12
miniz | 2.72 | 2.22 | 1.61 | 0.77
norx | 0.66 | 1.16 | 1.29 | 0.22
primes | 2.11 | 1.25 | 0.70 | 0.59
qsort | 7.35 | 4.74 | 1.20 | 0.62
sha512 | 0.68 | 1.32 | 0.96 | 0.24
_(Sum)_ | 17.95 | 14.96 | 8.97 | 3.26

**Performance Ratio 64-bit -O2 (smaller is better)**

program | qemu-aarch64 | qemu-riscv64 | rv8-riscv64 | native-x86-64
:-- | --: | --: | --: | --:
aes | 4.13 | 6.84 | 4.81 | 1.00
bigint | 3.51 | 2.70 | 3.77 | 1.00
dhrystone | 14.73 | 8.81 | 2.01 | 1.00
miniz | 3.52 | 2.87 | 2.08 | 1.00
norx | 2.94 | 5.20 | 5.75 | 1.00
primes | 3.58 | 2.13 | 1.19 | 1.00
qsort | 11.79 | 7.60 | 1.92 | 1.00
sha512 | 2.80 | 5.45 | 3.96 | 1.00
_(Geomean)_ | 4.75 | 4.64 | 2.82 | 1.00

![benchmark runtimes -Os 64-bit]({{ site.url }}/plots/runtime-Os-64.svg)
_Figure 3: Benchmark runtimes -Os 64-bit_

**Runtime 64-bit -Os (seconds)**

program | qemu-aarch64 | qemu-riscv64 | rv8-riscv64 | native-x86-64
:-- | --: | --: | --: | --:
aes | 1.22 | 1.91 | 1.31 | 0.37
bigint | 1.60 | 1.40 | 2.85 | 0.38
dhrystone | 5.42 | 2.59 | 1.31 | 0.39
miniz | 2.74 | 2.24 | 1.73 | 0.83
norx | 1.58 | 1.53 | 1.14 | 0.24
primes | 1.97 | 1.23 | 0.77 | 0.59
qsort | 7.99 | 5.27 | 0.90 | 0.66
sha512 | 0.64 | 1.14 | 0.67 | 0.25
_(Sum)_ | 23.16 | 17.31 | 10.68 | 3.71

**Performance Ratio 64-bit -Os (smaller is better)**

program | qemu-aarch64 | qemu-riscv64 | rv8-riscv64 | native-x86-64
:-- | --: | --: | --: | --:
aes | 3.29 | 5.16 | 3.53 | 1.00
bigint | 4.22 | 3.70 | 7.53 | 1.00
dhrystone | 13.97 | 6.66 | 3.38 | 1.00
miniz | 3.30 | 2.70 | 2.08 | 1.00
norx | 6.59 | 6.36 | 4.74 | 1.00
primes | 3.31 | 2.07 | 1.29 | 1.00
qsort | 12.20 | 8.05 | 1.38 | 1.00
sha512 | 2.56 | 4.58 | 2.69 | 1.00
_(Geomean)_ | 5.07 | 4.49 | 2.84 | 1.00

![benchmark runtimes -O3 32-bit]({{ site.url }}/plots/runtime-O3-32.svg)
_Figure 4: Benchmark runtimes -O3 32-bit_

**Runtime 32-bit -O3 (seconds)**

program | qemu-riscv32 | rv8-riscv32 | native-x86-32
:-- | --: | --: | --:
aes | 1.89 | 1.62 | 0.48
bigint | 1.37 | 1.41 | 0.88
dhrystone | 1.11 | 0.39 | 0.28
miniz | 2.17 | 1.41 | 0.88
norx | 0.77 | 0.85 | 0.26
primes | 2.34 | 1.95 | 1.51
qsort | 4.56 | 1.15 | 0.70
sha512 | 2.91 | 2.20 | 0.63
_(Sum)_ | 17.12 | 10.98 | 5.62

**Performance Ratio 32-bit -O3 (smaller is better)**

program | qemu-riscv32 | rv8-riscv32 | native-x86-32
:-- | --: | --: | --:
aes | 3.97 | 3.40 | 1.00
bigint | 1.56 | 1.61 | 1.00
dhrystone | 3.91 | 1.38 | 1.00
miniz | 2.47 | 1.61 | 1.00
norx | 2.96 | 3.27 | 1.00
primes | 1.55 | 1.29 | 1.00
qsort | 6.54 | 1.65 | 1.00
sha512 | 4.60 | 3.47 | 1.00
_(Geomean)_ | 3.09 | 2.03 | 1.00

![benchmark runtimes -O2 32-bit]({{ site.url }}/plots/runtime-O2-32.svg)
_Figure 5: Benchmark runtimes -O2 32-bit_

**Runtime 32-bit -O2 (seconds)**

program | qemu-riscv32 | rv8-riscv32 | native-x86-32
:-- | --: | --: | --:
aes | 1.88 | 1.56 | 0.48
bigint | 1.46 | 1.76 | 0.85
dhrystone | 1.80 | 0.41 | 0.36
miniz | 2.16 | 1.36 | 0.88
norx | 0.78 | 0.90 | 0.27
primes | 2.31 | 1.96 | 1.54
qsort | 4.55 | 1.16 | 0.68
sha512 | 3.95 | 2.40 | 0.57
_(Sum)_ | 18.89 | 11.51 | 5.63

**Performance Ratio 32-bit -O2 (smaller is better)**

program | qemu-riscv32 | rv8-riscv32 | native-x86-32
:-- | --: | --: | --:
aes | 3.92 | 3.24 | 1.00
bigint | 1.71 | 2.06 | 1.00
dhrystone | 5.02 | 1.13 | 1.00
miniz | 2.46 | 1.55 | 1.00
norx | 2.87 | 3.31 | 1.00
primes | 1.50 | 1.27 | 1.00
qsort | 6.67 | 1.70 | 1.00
sha512 | 6.92 | 4.21 | 1.00
_(Geomean)_ | 3.37 | 2.08 | 1.00

![benchmark runtimes -Os 32-bit]({{ site.url }}/plots/runtime-Os-32.svg)
_Figure 6: Benchmark runtimes -Os 32-bit_

**Runtime 32-bit -Os (seconds)**

program | qemu-riscv32 | rv8-riscv32 | native-x86-32
:-- | --: | --: | --:
aes | 1.57 | 1.25 | 0.50
bigint | 1.80 | 3.21 | 1.02
dhrystone | 2.31 | 1.42 | 0.58
miniz | 2.20 | 1.56 | 1.26
norx | 1.18 | 1.18 | 0.32
primes | 2.20 | 2.73 | 1.38
qsort | 5.01 | 0.82 | 0.77
sha512 | 2.69 | 2.49 | 0.79
_(Sum)_ | 18.96 | 14.66 | 6.62

**Performance Ratio 32-bit -Os (smaller is better)**

program | qemu-riscv32 | rv8-riscv32 | native-x86-32
:-- | --: | --: | --:
aes | 3.15 | 2.50 | 1.00
bigint | 1.76 | 3.14 | 1.00
dhrystone | 4.00 | 2.45 | 1.00
miniz | 1.74 | 1.24 | 1.00
norx | 3.70 | 3.69 | 1.00
primes | 1.59 | 1.97 | 1.00
qsort | 6.47 | 1.06 | 1.00
sha512 | 3.41 | 3.16 | 1.00
_(Geomean)_ | 2.90 | 2.22 | 1.00


### Optimisation

Runtimes and ratios for optimisation levels (-O3, -O2 and -Os):

![optimisation comparison native x86-64, -O3, -O2 and -Os]({{ site.url }}/plots/optimisation-x86-64.svg )
_Figure 7: Optimisation native x86-64, -O3, -O2 and -Os_

**Optimisation native x86-64, -O3, -O2 and -Os**

program | x86-64-O3 | x86-64-O2 | x86-64-Os | x86-64-O3:O2 | x86-64-O3:Os | x86-64-O2:Os
:-- | --: | --: | --: | --: | --: | --:
aes | 0.32 | 0.32 | 0.37 | 1.00 | 0.86 | 0.86
bigint | 0.38 | 0.38 | 0.38 | 1.00 | 1.01 | 1.01
dhrystone | 0.10 | 0.12 | 0.39 | 0.82 | 0.25 | 0.31
miniz | 0.77 | 0.77 | 0.83 | 1.00 | 0.93 | 0.93
norx | 0.22 | 0.22 | 0.24 | 0.98 | 0.92 | 0.93
primes | 0.60 | 0.59 | 0.59 | 1.02 | 1.01 | 0.99
qsort | 0.64 | 0.62 | 0.66 | 1.03 | 0.98 | 0.95
sha512 | 0.24 | 0.24 | 0.25 | 1.00 | 0.97 | 0.97
_(Geomean)_ | 0.34 | 0.35 | 0.42 | 0.98 | 0.81 | 0.82

![optimisation comparison native x86-32, -O3, -O2 and -Os]({{ site.url }}/plots/optimisation-x86-32.svg )
_Figure 8: Optimisation native x86-32, -O3, -O2 and -Os_

**Optimisation native x86-32, -O3, -O2 and -Os**

program | x86-32-O3 | x86-32-O2 | x86-32-Os | x86-32-O3:O2 | x86-32-O3:Os | x86-32-O2:Os
:-- | --: | --: | --: | --: | --: | --:
aes | 0.48 | 0.48 | 0.50 | 0.99 | 0.96 | 0.97
bigint | 0.88 | 0.85 | 1.02 | 1.03 | 0.86 | 0.84
dhrystone | 0.28 | 0.36 | 0.58 | 0.79 | 0.49 | 0.62
miniz | 0.88 | 0.88 | 1.26 | 1.00 | 0.70 | 0.70
norx | 0.26 | 0.27 | 0.32 | 0.95 | 0.81 | 0.85
primes | 1.51 | 1.54 | 1.38 | 0.98 | 1.09 | 1.11
qsort | 0.70 | 0.68 | 0.77 | 1.02 | 0.90 | 0.88
sha512 | 0.63 | 0.57 | 0.79 | 1.11 | 0.80 | 0.72
_(Geomean)_ | 0.61 | 0.62 | 0.75 | 0.98 | 0.81 | 0.82

![optimisation comparison rv8 riscv64, -O3, -O2 and -Os]({{ site.url }}/plots/optimisation-riscv64.svg )
_Figure 9: Optimisation rv8 riscv64, -O3, -O2 and -Os_

**Optimisation rv8 riscv64, -O3, -O2 and -Os**

program | rv8-rv64-O3 | rv8-rv64-O2 | rv8-rv64-Os | rv8-rv64-O3:O2 | rv8-rv64-O3:Os | rv8-rv64-O2:Os
:-- | --: | --: | --: | --: | --: | --:
aes | 1.53 | 1.53 | 1.31 | 1.00 | 1.17 | 1.17
bigint | 0.71 | 1.44 | 2.85 | 0.49 | 0.25 | 0.50
dhrystone | 0.20 | 0.24 | 1.31 | 0.83 | 0.15 | 0.18
miniz | 1.60 | 1.61 | 1.73 | 1.00 | 0.92 | 0.93
norx | 1.20 | 1.29 | 1.14 | 0.93 | 1.06 | 1.13
primes | 0.70 | 0.70 | 0.77 | 0.99 | 0.91 | 0.91
qsort | 1.22 | 1.20 | 0.90 | 1.02 | 1.35 | 1.33
sha512 | 0.81 | 0.96 | 0.67 | 0.85 | 1.21 | 1.43
_(Geomean)_ | 0.86 | 0.98 | 1.21 | 0.87 | 0.71 | 0.81

![optimisation comparison rv8 riscv32, -O3, -O2 and -Os]({{ site.url }}/plots/optimisation-riscv32.svg )
_Figure 10: Optimisation rv8 riscv32, -O3, -O2 and -Os_

**Optimisation rv8 riscv32, -O3, -O2 and -Os**

program | rv8-rv32-O3 | rv8-rv32-O2 | rv8-rv32-Os | rv8-rv32-O3:O2 | rv8-rv32-O3:Os | rv8-rv32-O2:Os
:-- | --: | --: | --: | --: | --: | --:
aes | 1.62 | 1.56 | 1.25 | 1.04 | 1.30 | 1.25
bigint | 1.41 | 1.76 | 3.21 | 0.80 | 0.44 | 0.55
dhrystone | 0.39 | 0.41 | 1.42 | 0.96 | 0.28 | 0.29
miniz | 1.41 | 1.36 | 1.56 | 1.04 | 0.90 | 0.87
norx | 0.85 | 0.90 | 1.18 | 0.94 | 0.72 | 0.76
primes | 1.95 | 1.96 | 2.73 | 1.00 | 0.71 | 0.72
qsort | 1.15 | 1.16 | 0.82 | 0.99 | 1.41 | 1.42
sha512 | 2.20 | 2.40 | 2.49 | 0.92 | 0.88 | 0.96
_(Geomean)_ | 1.23 | 1.29 | 1.66 | 0.96 | 0.74 | 0.77


### Instructions Per Second

Instructions per second in millions comparing qemu, rv8 and native x86:

![operation counts -O3 64-bit]({{ site.url }}/plots/mips-O3-64.svg)
_Figure 11: Millions of Instructions Per Second -O3 64-bit_

**Instructions per second (MIPS) qemu, rv8 and native 64-bit -O3**

program | qemu-riscv64-mips | rv8-riscv64-mips | native-x86-mips
:-- | --: | --: | --:
aes | 2414 | 3395 | 11035
bigint | 3738 | 5712 | 10557
dhrystone | 1843 | 5274 | 8369
miniz | 2625 | 3622 | 5530
norx | 2223 | 2167 | 9112
primes | 2438 | 4421 | 6100
qsort | 644 | 2518 | 5780
sha512 | 2982 | 4556 | 12177
_(Geomean)_ | 2149 | 3769 | 8232

![operation counts -O2 64-bit]({{ site.url }}/plots/mips-O2-64.svg)
_Figure 12: Millions of Instructions Per Second -O2 64-bit_

**Instructions per second (MIPS) qemu, rv8 and native 64-bit -O2**

program | qemu-riscv64-mips | rv8-riscv64-mips | native-x86-mips
:-- | --: | --: | --:
aes | 2384 | 3393 | 10984
bigint | 4155 | 2983 | 10584
dhrystone | 1353 | 5934 | 9930
miniz | 2617 | 3618 | 5468
norx | 2309 | 2088 | 9342
primes | 2461 | 4383 | 6238
qsort | 627 | 2481 | 6118
sha512 | 2860 | 3936 | 12395
_(Geomean)_ | 2085 | 3436 | 8525

![operation counts -Os 64-bit]({{ site.url }}/plots/mips-Os-64.svg)
_Figure 13: Millions of Instructions Per Second -Os 64-bit_

**Instructions per second (MIPS) qemu, rv8 and native 64-bit -Os**

program | qemu-riscv64-mips | rv8-riscv64-mips | native-x86-mips
:-- | --: | --: | --:
aes | 2655 | 3879 | 10072
bigint | 3973 | 1955 | 12873
dhrystone | 1250 | 2462 | 9073
miniz | 2650 | 3427 | 5052
norx | 1817 | 2439 | 8852
primes | 2226 | 3555 | 6101
qsort | 572 | 3340 | 6063
sha512 | 3269 | 5567 | 12206
_(Geomean)_ | 2008 | 3175 | 8355

![operation counts -O3 32-bit]({{ site.url }}/plots/mips-O3-32.svg)
_Figure 14: Millions of Instructions Per Second -O3 32-bit_

**Instructions per second (MIPS) qemu, rv8 and native 32-bit -O3**

program | qemu-riscv32-mips | rv8-riscv32-mips | native-x86-mips
:-- | --: | --: | --:
aes | 2442 | 2851 | 9634
bigint | 3964 | 3835 | 9780
dhrystone | 1998 | 5667 | 3747
miniz | 2195 | 3379 | 4988
norx | 2824 | 2554 | 9146
primes | 3039 | 3652 | 6368
qsort | 671 | 2658 | 6259
sha512 | 2773 | 3671 | 11074
_(Geomean)_ | 2259 | 3428 | 7186

![operation counts -O2 32-bit]({{ site.url }}/plots/mips-O2-32.svg)
_Figure 15: Millions of Instructions Per Second -O2 32-bit_

**Instructions per second (MIPS) qemu, rv8 and native 32-bit -O2**

program | qemu-riscv32-mips | rv8-riscv32-mips | native-x86-mips
:-- | --: | --: | --:
aes | 2451 | 2960 | 9551
bigint | 3709 | 3079 | 9740
dhrystone | 1381 | 6118 | 4820
miniz | 2195 | 3493 | 4960
norx | 2879 | 2498 | 9155
primes | 3085 | 3636 | 6257
qsort | 614 | 2406 | 5969
sha512 | 2477 | 4072 | 11191
_(Geomean)_ | 2096 | 3387 | 7349

![operation counts -Os 32-bit]({{ site.url }}/plots/mips-Os-32.svg)
_Figure 16: Millions of Instructions Per Second -Os 32-bit_

**Instructions per second (MIPS) qemu, rv8 and native 32-bit -Os**

program | qemu-riscv32-mips | rv8-riscv32-mips | native-x86-mips
:-- | --: | --: | --:
aes | 2832 | 3565 | 9472
bigint | 3856 | 2166 | 9817
dhrystone | 1435 | 2345 | 8479
miniz | 2177 | 3062 | 4171
norx | 1965 | 1970 | 8129
primes | 2928 | 2355 | 7105
qsort | 576 | 3528 | 5892
sha512 | 2901 | 3131 | 8396
_(Geomean)_ | 2063 | 2702 | 7441


### Retired Micro-ops

The following table describes the measured x86 performance counters:

counter       | x86 event mask              | description
:------------ | :-------------------------- | :-----------------------------------
instret       | `INST_RETIRED`              | instructions retired
uops-executed | `UOPS_EXECUTED.THREAD`      | uops executed
uops-issued   | `UOPS_ISSUED.ANY`           | uops issued
uops-slots    | `UOPS_RETIRED.RETIRE_SLOTS` | uop retirement slots used
uops-retired  | `UOPS_RETIRED.ANY`          | uops retired

Total retired micro-op/instruction counts comparing RISC-V and x86:

![operation counts -O3 64-bit]({{ site.url }}/plots/operations-O3-64.svg)
_Figure 17: Retired operation counts -O3 64-bit_

**Retired Operations (Mops) x86-64 vs riscv64 -O3**

program | x86-instret | x86-uops-executed | x86-uops-issued | x86-uops-retired | x86-uops-slots | riscv64-instret
:-- | --: | --: | --: | --: | --: | --:
aes | 3520 | 3855 | 3455 | 4335 | 3442 | 5205
bigint | 4033 | 3927 | 4033 | 4355 | 4045 | 4044
dhrystone | 820 | 1131 | 860 | 1151 | 854 | 1060
miniz | 4264 | 4151 | 4224 | 4232 | 3832 | 5791
norx | 2005 | 1970 | 2029 | 2230 | 2002 | 2607
primes | 3642 | 3151 | 3855 | 3650 | 3653 | 3077
qsort | 3694 | 5052 | 4036 | 4897 | 3546 | 3067
sha512 | 2947 | 2623 | 3073 | 3264 | 3045 | 3704
_(Sum)_ | 24925 | 25860 | 25565 | 28114 | 24419 | 28555

![operation counts -Os 64-bit]({{ site.url }}/plots/operations-O2-64.svg)
_Figure 18: Retired operation counts -O2 64-bit_

**Retired Operations (Mops) x86-64 vs riscv64 -O2**

program | x86-instret | x86-uops-executed | x86-uops-issued | x86-uops-retired | x86-uops-slots | riscv64-instret
:-- | --: | --: | --: | --: | --: | --:
aes | 3504 | 3852 | 3439 | 4363 | 3466 | 5205
bigint | 4043 | 3899 | 4055 | 4360 | 4052 | 4292
dhrystone | 1192 | 1578 | 1228 | 1643 | 1250 | 1430
miniz | 4221 | 4128 | 4179 | 4200 | 3799 | 5807
norx | 2093 | 2014 | 2054 | 2288 | 2033 | 2687
primes | 3668 | 3169 | 3829 | 3652 | 3640 | 3077
qsort | 3812 | 4379 | 3909 | 4531 | 3583 | 2969
sha512 | 3000 | 2709 | 3068 | 3276 | 3064 | 3775
_(Sum)_ | 25533 | 25728 | 25761 | 28313 | 24887 | 29242

![operation counts -O2 64-bit]({{ site.url }}/plots/operations-Os-64.svg)
_Figure 19: Retired operation counts -Os 64-bit_

**Retired Operations (Mops) x86-64 vs riscv64 -Os**

program | x86-instret | x86-uops-executed | x86-uops-issued | x86-uops-retired | x86-uops-slots | riscv64-instret
:-- | --: | --: | --: | --: | --: | --:
aes | 3737 | 4323 | 3711 | 4789 | 3697 | 5081
bigint | 4879 | 4617 | 4593 | 4896 | 4595 | 5579
dhrystone | 3520 | 5401 | 4293 | 5540 | 4257 | 3230
miniz | 4193 | 4519 | 4251 | 4446 | 3875 | 5928
norx | 2124 | 2294 | 2177 | 2459 | 2148 | 2775
primes | 3624 | 3161 | 3793 | 3633 | 3629 | 2734
qsort | 3972 | 4932 | 4243 | 4897 | 3858 | 3016
sha512 | 3039 | 2750 | 3155 | 3359 | 3155 | 3730
_(Sum)_ | 29088 | 31997 | 30216 | 34019 | 29214 | 32073

![operation counts -O3 32-bit]({{ site.url }}/plots/operations-O3-32.svg)
_Figure 20: Retired operation counts -O3 32-bit_

**Retired Operations (Mops) x86-32 vs riscv32 -O3**

program | x86-instret | x86-uops-executed | x86-uops-issued | x86-uops-retired | x86-uops-slots | riscv32-instret
:-- | --: | --: | --: | --: | --: | --:
aes | 4586 | 5246 | 4590 | 5864 | 4573 | 4618
bigint | 8587 | 9909 | 9219 | 11659 | 9203 | 5418
dhrystone | 1060 | 3151 | 2651 | 3251 | 2631 | 2210
miniz | 4389 | 5253 | 4587 | 5024 | 4097 | 4775
norx | 2369 | 2380 | 2361 | 2683 | 2347 | 2166
primes | 9591 | 14598 | 11931 | 14999 | 11612 | 7115
qsort | 4362 | 7313 | 5934 | 6512 | 4975 | 3062
sha512 | 7010 | 6841 | 7074 | 8110 | 7056 | 8073
_(Sum)_ | 41954 | 54691 | 48347 | 58102 | 46494 | 37437

![operation counts -O2 32-bit]({{ site.url }}/plots/operations-O2-32.svg)
_Figure 21: Retired operation counts -O2 32-bit_

**Retired Operations (Mops) x86-32 vs riscv32 -O2**

program | x86-instret | x86-uops-executed | x86-uops-issued | x86-uops-retired | x86-uops-slots | riscv32-instret
:-- | --: | --: | --: | --: | --: | --:
aes | 4594 | 5298 | 4641 | 5870 | 4589 | 4618
bigint | 8318 | 9704 | 8938 | 11329 | 8927 | 5420
dhrystone | 1730 | 4292 | 3468 | 4401 | 3471 | 2490
miniz | 4360 | 5196 | 4559 | 4957 | 4035 | 4747
norx | 2490 | 2532 | 2480 | 2838 | 2474 | 2245
primes | 9610 | 14586 | 11928 | 15021 | 11605 | 7115
qsort | 4071 | 6384 | 4961 | 5834 | 4295 | 2794
sha512 | 6379 | 6511 | 6471 | 7394 | 6472 | 9777
_(Sum)_ | 41552 | 54503 | 47446 | 57644 | 45868 | 39206

![operation counts -Os 32-bit]({{ site.url }}/plots/operations-Os-32.svg)
_Figure 22: Retired operation counts -Os 32-bit_

**Retired Operations (Mops) x86-32 vs riscv32 -Os**

program | x86-instret | x86-uops-executed | x86-uops-issued | x86-uops-retired | x86-uops-slots | riscv32-instret
:-- | --: | --: | --: | --: | --: | --:
aes | 4717 | 5756 | 4775 | 6063 | 4737 | 4446
bigint | 10033 | 11596 | 11049 | 13471 | 11033 | 6953
dhrystone | 4901 | 7398 | 5669 | 7591 | 5634 | 3320
miniz | 5256 | 6571 | 5568 | 6460 | 4983 | 4783
norx | 2601 | 3120 | 2675 | 3268 | 2641 | 2325
primes | 9834 | 10948 | 10661 | 12072 | 10429 | 6429
qsort | 4560 | 7633 | 6052 | 7033 | 5226 | 2886
sha512 | 6624 | 6830 | 6655 | 7639 | 6671 | 7796
_(Sum)_ | 48526 | 59852 | 53104 | 63597 | 51354 | 38938


### Executable File Sizes

GCC stripped executable sizes comparing aarch64, riscv32, riscv64, x86-32 and x86-64:

![benchmark filesizes -O3]({{ site.url }}/plots/filesize-O3.svg)
_Figure 23: Compiled file sizes -O3_

**Compiled File Size (bytes) -O3**

program | aarch64 | riscv32 | riscv64 | x86-32 | x86-64
:-- | --: | --: | --: | --: | --:
aes | 46400 | 54100 | 42280 | 41856 | 38192
bigint | 661792 | 571180 | 572440 | 669216 | 612736
dhrystone | 30032 | 37756 | 25968 | 25476 | 21816
miniz | 116272 | 103420 | 95800 | 132128 | 120368
norx | 42544 | 46064 | 34336 | 33824 | 30256
primes | 30016 | 33620 | 25896 | 21376 | 17712
qsort | 42304 | 37716 | 29992 | 33664 | 34096
sha512 | 30256 | 37872 | 26144 | 25632 | 22064
_(Sum)_ | 999616 | 921728 | 852856 | 983172 | 897240

![benchmark filesizes -O2]({{ site.url }}/plots/filesize-O2.svg)
_Figure 24: Compiled file sizes -O2_

**Compiled File Size (bytes) -O2**

program | aarch64 | riscv32 | riscv64 | x86-32 | x86-64
:-- | --: | --: | --: | --: | --:
aes | 46400 | 54100 | 42280 | 41856 | 38192
bigint | 649504 | 567084 | 568344 | 656928 | 604544
dhrystone | 30032 | 37756 | 25968 | 25476 | 21816
miniz | 99888 | 91132 | 79416 | 111648 | 99888
norx | 38448 | 41968 | 30240 | 29728 | 30256
primes | 30016 | 33620 | 25896 | 21376 | 17712
qsort | 30016 | 37716 | 25896 | 25472 | 21808
sha512 | 30256 | 37872 | 26144 | 25632 | 22064
_(Sum)_ | 954560 | 901248 | 824184 | 938116 | 856280

![benchmark filesizes -Os]({{ site.url }}/plots/filesize-Os.svg)
_Figure 25: Compiled file sizes -Os_

**Compiled File Size (bytes) -Os**

program | aarch64 | riscv32 | riscv64 | x86-32 | x86-64
:-- | --: | --: | --: | --: | --:
aes | 46400 | 50004 | 42280 | 41856 | 38192
bigint | 641312 | 562988 | 564248 | 648736 | 592256
dhrystone | 30032 | 37756 | 25968 | 25520 | 21816
miniz | 87600 | 87036 | 75320 | 95264 | 83504
norx | 38448 | 41968 | 30240 | 29728 | 30256
primes | 30016 | 33620 | 25896 | 21376 | 17712
qsort | 30016 | 37716 | 25896 | 21376 | 21808
sha512 | 30256 | 37872 | 26144 | 25632 | 22064
_(Sum)_ | 934080 | 888960 | 815992 | 909488 | 827608


### Dynamic Register Usage

Dynamic register usage results comparing riscv64 -O3, -O2, -Os

![aes register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-aes-rv64-1.svg)
_Figure 26: Dynamic register usage - aes -O3, -O2, -Os (sorted by frequency)_

![aes register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-aes-rv64-2.svg)
_Figure 27: Dynamic register usage - aes -O3, -O2, -Os (sorted by alphabetically)_

![bigint register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-bigint-rv64-1.svg)
_Figure 28: Dynamic register usage - bigint -O3, -O2, -Os (sorted by frequency)_

![bigint register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-bigint-rv64-2.svg)
_Figure 29: Dynamic register usage - bigint -O3, -O2, -Os (sorted by alphabetically)_

![dhrystone register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-dhrystone-rv64-1.svg)
_Figure 30: Dynamic register usage - dhrystone -O3, -O2, -Os (sorted by frequency)_

![dhrystone register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-dhrystone-rv64-2.svg)
_Figure 31: Dynamic register usage - dhrystone -O3, -O2, -Os (sorted by alphabetically)_

![miniz register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-miniz-rv64-1.svg)
_Figure 32: Dynamic register usage - miniz -O3, -O2, -Os (sorted by frequency)_

![miniz register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-miniz-rv64-2.svg)
_Figure 33: Dynamic register usage - miniz -O3, -O2, -Os (sorted by alphabetically)_

![norx register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-norx-rv64-1.svg)
_Figure 34: Dynamic register usage - norx -O3, -O2, -Os (sorted by frequency)_

![norx register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-norx-rv64-2.svg)
_Figure 35: Dynamic register usage - norx -O3, -O2, -Os (sorted by alphabetically)_

![primes register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-primes-rv64-1.svg)
_Figure 36: Dynamic register usage - primes -O3, -O2, -Os (sorted by frequency)_

![primes register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-primes-rv64-2.svg)
_Figure 37: Dynamic register usage - primes -O3, -O2, -Os (sorted by alphabetically)_

![qsort register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-qsort-rv64-1.svg)
_Figure 38: Dynamic register usage - qsort -O3, -O2, -Os (sorted by frequency)_

![qsort register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-qsort-rv64-2.svg)
_Figure 39: Dynamic register usage - qsort -O3, -O2, -Os (sorted by alphabetically)_

![sha512 register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-sha512-rv64-1.svg)
_Figure 40: Dynamic register usage - sha512 -O3, -O2, -Os (sorted by frequency)_

![sha512 register usage -O3, -O2, -Os]({{ site.url }}/plots/registers-sha512-rv64-2.svg)
_Figure 41: Dynamic register usage - sha512 -O3, -O2, -Os (sorted by alphabetically)_


### Dynamic Instruction Usage

Dynamic instruction usage results comparing riscv64 -O3, -O2, -Os

![aes instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-aes-rv64-1.svg)
_Figure 42: Dynamic instruction usage - aes -O3, -O2, -Os (sorted by frequency)_

![aes instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-aes-rv64-2.svg)
_Figure 43: Dynamic instruction usage - aes -O3, -O2, -Os (sorted by alphabetically)_

![bigint instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-bigint-rv64-1.svg)
_Figure 44: Dynamic instruction usage - bigint -O3, -O2, -Os (sorted by frequency)_

![bigint instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-bigint-rv64-2.svg)
_Figure 45: Dynamic instruction usage - bigint -O3, -O2, -Os (sorted by alphabetically)_

![dhrystone instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-dhrystone-rv64-1.svg)
_Figure 46: Dynamic instruction usage - dhrystone -O3, -O2, -Os (sorted by frequency)_

![dhrystone instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-dhrystone-rv64-2.svg)
_Figure 47: Dynamic instruction usage - dhrystone -O3, -O2, -Os (sorted by alphabetically)_

![miniz instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-miniz-rv64-1.svg)
_Figure 48: Dynamic instruction usage - miniz -O3, -O2, -Os (sorted by frequency)_

![miniz instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-miniz-rv64-2.svg)
_Figure 49: Dynamic instruction usage - miniz -O3, -O2, -Os (sorted by alphabetically)_

![norx instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-norx-rv64-1.svg)
_Figure 50: Dynamic instruction usage - norx -O3, -O2, -Os (sorted by frequency)_

![norx instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-norx-rv64-2.svg)
_Figure 51: Dynamic instruction usage - norx -O3, -O2, -Os (sorted by alphabetically)_

![primes instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-primes-rv64-1.svg)
_Figure 52: Dynamic instruction usage - primes -O3, -O2, -Os (sorted by frequency)_

![primes instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-primes-rv64-2.svg)
_Figure 53: Dynamic instruction usage - primes -O3, -O2, -Os (sorted by alphabetically)_

![qsort instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-qsort-rv64-1.svg)
_Figure 54: Dynamic instruction usage - qsort -O3, -O2, -Os (sorted by frequency)_

![qsort instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-qsort-rv64-2.svg)
_Figure 55: Dynamic instruction usage - qsort -O3, -O2, -Os (sorted by alphabetically)_

![sha512 instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-sha512-rv64-1.svg)
_Figure 56: Dynamic instruction usage - sha512 -O3, -O2, -Os (sorted by frequency)_

![sha512 instruction usage -O3, -O2, -Os]({{ site.url }}/plots/instructions-sha512-rv64-2.svg)
_Figure 57: Dynamic instruction usage - sha512 -O3, -O2, -Os (sorted by alphabetically)_
