# ECE 327 Labs – Digital Systems Design

This repository hosts lab projects for **ECE 327: Digital Systems Design** at the University of Waterloo. Each lab explores core topics in hardware design using SystemVerilog and Xilinx Vivado, ranging from arithmetic circuits and finite state machines to deep learning accelerator components. All projects target FPGA implementation and emphasize best practices in hardware engineering.

---

## Lab Summaries

### Lab 1 – Arithmetic Circuits and RTL Design
**Goal:** Implement and test a parameterized adder and multiplier circuit using SystemVerilog.

- Designed a configurable-width adder and multiplier using combinational logic.
- Validated designs using simulation in Vivado and confirmed correctness with provided testbenches.
- Learned to work with Vivado projects, analyze simulation waveforms, and understand the basics of RTL synthesis.
- Emphasized clean modular design and use of generate blocks for scalability.

### Lab 2 – Controller Design and Finite State Machines
**Goal:** Design a sequential controller to interact with arithmetic datapath units.

- Built a finite state machine (FSM) that sequences operand loading, multiplication, and result output.
- Created a datapath consisting of registers and ALU-like components interfaced with the FSM.
- Integrated control and datapath modules for proper handshaking and operation sequencing.
- Used simulations to verify control logic, debug state transitions, and validate correct end-to-end operation.

### Lab 3 – Pipelined Fixed-Point Tanh Circuit
**Goal:** Implement and pipeline a tanh(x) function using a fixed-point Taylor approximation.

- Implemented an 11th-degree Taylor series approximation of tanh(x) using Q2.12 fixed-point format.
- Designed a datapath with multipliers and adders, using ready-valid latency-insensitive interfaces.
- Pipelined the circuit to achieve ≥180 MHz clock frequency, optimizing throughput and reducing critical path delays.
- Verified functionality with an error-tolerant testbench and evaluated accuracy against floating-point references.

### Lab 4 – Matrix-Vector Multiplication Engine (Based on Brainwave Architecture)
**Goal:** Build a configurable matrix-vector multiplication unit inspired by Microsoft’s Brainwave DNN accelerator.

- Designed a systolic array-like compute engine for low-latency, batch-1 inference—mirroring the approach in cloud-scale deep learning accelerators.
- Utilized SIMD-style datapaths for parallel multiply-accumulate operations across input vectors, significantly increasing computational throughput.
- Implemented instruction decoding, flexible control sequencing, and highly configurable datapath elements, allowing the engine to be tuned for different matrix and vector sizes.
- Focused on real-time DNN workload processing, with optimization for FPGA implementation to achieve both high performance and resource efficiency.
- Explored memory interfacing, dataflow scheduling, and pipeline balancing to ensure seamless operation under varying workloads and to minimize stalls.
- The resulting design is representative of industry-grade FPGA-based neural network accelerators and is excellent material for technical interviews or portfolio demonstrations.

---

## How to Use

1. **Clone the repository:**
   ```sh
   git clone https://github.com/A2J2123/ECE-327-Labs.git
   ```
2. **Explore each lab folder** for source code, testbenches, and project files.
3. **Open the Vivado project** in the desired lab directory to simulate, synthesize, and implement the designs.

---

## Requirements

- **Vivado Design Suite** (recommended version: 2020.2 or later)
- Basic familiarity with SystemVerilog
- FPGA development board (if you wish to deploy designs)

---

## About

These labs are designed to build practical expertise in modern digital system design, preparing students for advanced coursework, research, and industry roles in hardware engineering and machine learning acceleration.

---

**Author:** [A2J2123](https://github.com/A2J2123)  
For educational use.
