<a href="https://rv8.io/"><img style="float: right;" src="/images/rv8.svg"></a>

## rv8 benchmarks

This document contains [rv8-bench](https://github.com/rv8-io/rv8-bench/)
benchmark results using [GCC 7.1.0 and musl libc](https://github.com/rv8-io/musl-riscv-toolchain/):

- rv8-bench: [https://github.com/rv8-io/rv8-bench/](https://github.com/rv8-io/rv8-bench/)
- musl-riscv-toolchain: [https://github.com/rv8-io/musl-riscv-toolchain/](https://github.com/rv8-io/musl-riscv-toolchain/)

The following results have been plotted:

- [Runtimes](#runtimes)
- [File Sizes](#file-sizes)
- [Dynamic Micro-ops](#dynamic-micro-ops)
- [Register allocation](#register-allocation)

### [Runtimes](#runtimes)

Runtime results comparing qemu, rv-jit and native x86:

![benchmark runtimes -O3 64-bit]({{ site.url }}/plots/runtime-O3-64.svg)
![benchmark runtimes -Os 64-bit]({{ site.url }}/plots/runtime-Os-64.svg)
![benchmark runtimes -O3 32-bit]({{ site.url }}/plots/runtime-O3-32.svg)
![benchmark runtimes -Os 32-bit]({{ site.url }}/plots/runtime-Os-32.svg)

### [File Sizes](#file-sizes)

GCC filesize results comparing aarch64, riscv32, riscv64, x86-32 and x86-64:

![benchmark filesizes -O3]({{ site.url }}/plots/filesize-O3.svg)
![benchmark filesizes -Os]({{ site.url }}/plots/filesize-Os.svg)

### [Dynamic Micro-ops](#dynamic-micro-ops)

Dynamic micro-op/instruction counts comparing RISC-V and x86:

![operation counts -O3 64-bit]({{ site.url }}/plots/operations-O3-64.svg)
![operation counts -Os 64-bit]({{ site.url }}/plots/operations-Os-64.svg)
![operation counts -O3 32-bit]({{ site.url }}/plots/operations-O3-32.svg)
![operation counts -Os 32-bit]({{ site.url }}/plots/operations-Os-32.svg)

### [Register allocation](#register-allocation)

GCC register allocation results comparing riscv64 -O3 vs -Os

![aes registers -O3 vs -Os]({{ site.url }}/plots/registers-aes-rv64-1.svg)
![aes registers -O3 vs -Os]({{ site.url }}/plots/registers-aes-rv64-2.svg)

![dhrystone registers -O3 vs -Os]({{ site.url }}/plots/registers-dhrystone-rv64-1.svg)
![dhrystone registers -O3 vs -Os]({{ site.url }}/plots/registers-dhrystone-rv64-2.svg)

![miniz registers -O3 vs -Os]({{ site.url }}/plots/registers-miniz-rv64-1.svg)
![miniz registers -O3 vs -Os]({{ site.url }}/plots/registers-miniz-rv64-2.svg)

![norx registers -O3 vs -Os]({{ site.url }}/plots/registers-norx-rv64-1.svg)
![norx registers -O3 vs -Os]({{ site.url }}/plots/registers-norx-rv64-2.svg)

![primes registers -O3 vs -Os]({{ site.url }}/plots/registers-primes-rv64-1.svg)
![primes registers -O3 vs -Os]({{ site.url }}/plots/registers-primes-rv64-2.svg)

![qsort registers -O3 vs -Os]({{ site.url }}/plots/registers-qsort-rv64-1.svg)
![qsort registers -O3 vs -Os]({{ site.url }}/plots/registers-qsort-rv64-2.svg)

![sha512 registers -O3 vs -Os]({{ site.url }}/plots/registers-sha512-rv64-1.svg)
![sha512 registers -O3 vs -Os]({{ site.url }}/plots/registers-sha512-rv64-2.svg)
