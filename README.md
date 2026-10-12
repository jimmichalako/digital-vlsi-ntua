# NTUA ECE Digital VLSI Systems Course

This repository contains the laboratory assignments, digital circuit designs, and project implementations completed during the Digital VLSI Systems course at the National Technical University of Athens (NTUA), School of Electrical and Computer Engineering. 

The coursework covers digital design methodologies ranging from basic combinational and sequential building blocks to pipelined systolic arrays, custom AXI4-Lite IP packaging, and hardware-accelerated image demosaicing on the Xilinx Zynq-7000 SoC (Zybo) platform.

## Laboratory Exercises

### Lab 1: Combinational Logic & Sequential Registers
*Design, simulation, and RTL verification of decoders, bidirectional shift registers, and synchronous counters.*

* **Key Tasks:**
  * **Part A (3-to-8 Binary Decoder):** Implemented a 3-to-8 binary decoder (`dec8`) in VHDL comparing behavioral (`case` statement) and dataflow (concurrent conditional assignment) architectures. Verified output correctness across all 8 input combinations via a dedicated testbench.
  * **Part B (4-bit Bidirectional Shift Register):** Designed a 4-bit universal shift register with parallel load (`pl`), directional shifting (`dir` for left/right), serial in/out (`si`/`so`), and asynchronous active-low reset (`rst`). Verified shift patterns and synchronous data latching.
  * **Part C (3-bit Synchronous Up/Down Counter):** Implemented a 3-bit up/down counter with count enable (`count_en`), carry/terminal count flags, and verified behavior under dynamic control signals.
* **Tech Stack:** VHDL, ModelSim / Vivado Simulator, RTL Synthesis.

### Lab 2: Hierarchical Arithmetic Adders & BCD Units
*Structural modeling and critical path timing analysis of binary adders and decimal arithmetic units.*

* **Key Tasks:**
  * **Part A (Half & Full Adders):** Modeled a Half Adder in dataflow VHDL and hierarchically constructed a 1-bit Full Adder (`FA`) using two Half Adders and an OR gate. Evaluated critical path propagation delays (5.377 ns).
  * **Part B (4-bit Parallel Ripple-Carry Adder):** Cascaded four 1-bit Full Adders into a 4-bit parallel adder (`PA4bit`). Verified carry propagation across multiple test vectors and analyzed critical path timing (5.970 ns).
  * **Part C (1-Digit & 4-bit BCD Adders):** Designed a 1-digit BCD Full Adder with overflow detection and correction logic (+6 binary correction when sum > 9). Hierarchically expanded the design to a 4-digit BCD parallel adder (`BCD4bit`).
* **Tech Stack:** VHDL, Structural / Hierarchical Modeling, Timing & Critical Path Analysis.

### Lab 3: Pipelining & Systolic Hardware Architectures
*Design and performance evaluation of clock-synchronized arithmetic units, pipelined adders, and 2D systolic multipliers.*

* **Key Tasks:**
  * **Part A (Synchronous Full Adder):** Implemented a clock-synchronized 1-bit Full Adder registering inputs and outputs on the rising clock edge (critical path: 4.076 ns).
  * **Part B (4-bit Pipelined Ripple-Carry Adder):** Implemented a 4-stage pipelined ripple adder using 18 D flip-flops to isolate intermediate sum and carry stages. Achieved a higher maximum clock frequency with an initial latency of $T_{\text{latency}} = 3$ clock cycles, evaluating the speed vs. resource trade-off against Lab 2's combinational design.
  * **Part C (4-bit Systolic Multiplier):** Constructed a 4-bit synchronous multiplier utilizing a 2D systolic array of Multiply-Accumulate (MAC) processing elements and skewing registers. Verified cycle-by-cycle multiplication streaming.
* **Tech Stack:** VHDL, Pipelining Techniques, Systolic Arrays, Hardware Timing Trade-offs.

### Lab 4: 8-Tap FIR Digital Filter Architecture
*Design and cycle-accurate implementation of a parameterizable 8-tap Finite Impulse Response (FIR) digital filter.*

* **Key Tasks:**
  * **Part A (Sub-module Design):** Developed individual building blocks:
    * **Control Unit:** An 8-state counter-based FSM controlling address generation, accumulator initialization (`mac_init`), and write-enable lines.
    * **ROM:** Stores the 8 fixed filter impulse response coefficients.
    * **RAM:** Sliding-window circular shift buffer storing the current sample $x[n]$ and the 7 preceding input samples.
    * **MAC Unit:** Multiplier-Accumulator calculating $y[n] = \sum_{k=0}^{7} h[k]x[n-k]$ with 19-bit dynamic range to prevent overflow.
  * **Part B (Integration & Delay Alignment):** Assembled the top-level FIR architecture, incorporating synchronization delays to align memory read cycles with MAC operations and output valid flags (`valid_out`).
  * **Part C (Synthesis & Timing Analysis):** Verified filter impulse response against theoretical test vectors, evaluated FPGA slice utilization, and identified the critical path (6.215 ns, corresponding to a maximum operating frequency of 160.9 MHz).
* **Tech Stack:** VHDL, Digital Signal Processing (DSP), Memory Architectures, RTL Synthesis.

### Lab 5: Custom AXI4-Lite FIR Filter on Zynq-7000 SoC
*Packaging custom digital hardware into an AXI4-Lite slave IP and building an embedded software driver for the ARM Cortex-A9.*

* **Key Tasks:**
  * **Part A (Custom AXI IP Packaging):** Packaged the 8-tap FIR filter into a memory-mapped AXI4-Lite peripheral in Vivado IP Packager. Mapped control/data registers (`slv_reg0` for $x$, `valid_in`, and reset; `slv_reg1` for output $y$ and `valid_out`).
  * **Part B (Zynq PS-PL Integration):** Built the Vivado Block Design connecting the Zynq Processing System (PS) with the custom FIR IP via the AXI Interconnect, synthesized the bitstream, and exported the hardware platform (`.hdf`).
  * **Part C (Standalone Embedded Software Driver):** Authored an embedded C application in Xilinx SDK (`Master.c`) running on ARM Cortex-A9. Implemented polling-based handshaking over AXI to send sample inputs, poll completion flags, and retrieve processed filter outputs over UART serial.
* **Tech Stack:** Xilinx Vivado IP Packager, Zynq-7000 SoC (ARM + FPGA), AXI4-Lite Protocol, C (Xilinx SDK).

### Lab 6: Hardware-Accelerated Bayer-to-RGB Debayering Filter
*Real-time image demosaicing pipeline utilizing Line Buffers, AXI DMA streaming, and hardware/software profiling.*

* **Key Tasks:**
  * **Part A (Debayering Computation Core):** Designed the datapath for GBRG Bayer mosaic demosaicing, interpolating missing color channels via $3 \times 3$ pixel neighborhood averages.
  * **Part B (Serial-to-Parallel Line Buffering):** Implemented an S2P line buffer architecture utilizing three dual-port RAM FIFOs (depth 1024) and nine D-registers to provide continuous sliding $3 \times 3$ pixel access for streaming inputs.
  * **Part C (AXI DMA & System Profiling):** Integrated the accelerator with AXI DMA engines (PS-to-PL transmission and PL-to-PS reception). Developed a C driver in Xilinx SDK to stream raw Bayer image frames, execute the hardware accelerated debayering, and profile execution speed against a pure software C implementation.
* **Tech Stack:** VHDL, Image Processing / Demosaicing, Block RAM / FIFO IP, AXI DMA, Embedded C (Xilinx SDK).

---

## Technologies & Tools Used

* **Hardware Description Language:** VHDL
* **Embedded Software:** C (Xilinx SDK standalone BSP)
* **EDA & Toolchain:** Xilinx Vivado Design Suite, Xilinx SDK, Vivado Simulator, ModelSim
* **Target Hardware:** Digilent Zybo / Xilinx Zynq-7000 All-Programmable SoC (XC7Z010 / XC7Z020)
* **Buses & Protocols:** AXI4-Lite, AXI DMA, UART Serial Communication
* **Core Concepts:** RTL Synthesis, Pipelined & Systolic Architectures, Digital Filter Design (FIR), Image Demosaicing (Debayering), Hardware/Software Co-design, FIFO Line Buffers
