![Verilog](https://img.shields.io/badge/Language-Verilog-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Simulator](https://img.shields.io/badge/Simulator-Icarus%20Verilog-orange)

# Simple 8-bit RISC Processor

A simple **8-bit Reduced Instruction Set Computer (RISC) Processor** implemented in **Verilog HDL**. This project demonstrates the design and simulation of a basic processor architecture consisting of an Arithmetic Logic Unit (ALU), Register File, Program Counter, Instruction Memory, Data Memory, Instruction Decoder, and Control Unit.

The processor supports a custom instruction set and is intended as an educational project for learning **Digital Design**, **Computer Architecture**, and **Hardware Description Languages (HDLs)**.

---

# Features

* 8-bit datapath architecture
* Custom 16-bit instruction format
* Register-based ALU operations
* Separate Instruction and Data Memories
* Hardwired Control Unit
* Program Counter with Jump support
* Modular Verilog implementation
* Individual testbenches for each module
* Compatible with **Icarus Verilog** and **GTKWave**

---

---

# Processor Architecture

The processor is composed of the following hardware modules:

| Module             | Description                                |
| ------------------ | ------------------------------------------ |
| ALU                | Performs arithmetic and logical operations |
| Register File      | Stores processor outputs                   |
| Program Counter    | Holds the address of the next instruction  |
| Instruction Memory | Stores program instructions                |
| Decoder            | Decodes instruction fields                 |
| Data Memory        | Stores data for LOAD operations            |
| Control Unit       | Generates processor control signals        |
| Top Module*         | Integrates all processor modules           |


*Top Module: Conatins a MUX which selects from where the write data is arriving, the ALU or Data Memory 
by using wb_select (writeback data select line).
---

# Instruction Set Architecture (ISA)

| Instruction | Opcode | Operation         | Description            |
| ----------- | ------ | ----------------- | ---------------------- |
| ADD         | 000    | Rd = Rs1 + Rs2    | Add two registers      |
| SUB         | 001    | Rd = Rs1 − Rs2    | Subtract two registers |
| AND         | 010    | Rd = Rs1 & Rs2    | Bitwise AND            |
| OR          | 011    | Rd = Rs1 or Rs2    | Bitwise OR             |
| NOT         | 100    | Rd = ~Rs1         | Bitwise NOT            |
| MOV         | 101    | Rd = Rs1          | Copy register value    |
| LOAD        | 110    | Rd = Mem[address] | Load data from memory  |
| JMP         | 111    | PC = address      | Jump to instruction    |

---

# Instruction Formats

## R-Type Instructions

| Bits  | Field                     |
| ----- | ------------------------- |
| 15:13 | Opcode                    |
| 12:10 | Destination Register (Rd) |
| 9:7   | Source Register 1 (Rs1)   |
| 6:4   | Source Register 2 (Rs2)   |
| 3:0   | Unused                    |

---

## LOAD Instruction

| Bits  | Field                     |
| ----- | ------------------------- |
| 15:13 | Opcode                    |
| 12:10 | Destination Register (Rd) |
| 9:8   | Unused                    |
| 7:0   | Memory Address            |

---

## JMP Instruction

| Bits  | Field        |
| ----- | ------------ |
| 15:13 | Opcode       |
| 12:8  | Unused       |
| 7:0   | Jump Address |

---

# Control Signals

| Instruction | Opcode | alu_op | reg_write | mem_read | mem_write | jump_enable | wb_select |
| ----------- | ------ | ------ | --------- | -------- | --------- | ----------- | --------- |
| ADD         | 000    | 000    | 1         | 0        | 0         | 0           | 0         |
| SUB         | 001    | 001    | 1         | 0        | 0         | 0           | 0         |
| AND         | 010    | 010    | 1         | 0        | 0         | 0           | 0         |
| OR          | 011    | 011    | 1         | 0        | 0         | 0           | 0         |
| NOT         | 100    | 100    | 1         | 0        | 0         | 0           | 0         |
| MOV         | 101    | 101    | 1         | 0        | 0         | 0           | 0         |
| LOAD        | 110    | xxx    | 1         | 1        | 0         | 0           | 1         |
| JMP         | 111    | xxx    | 0         | 0        | 0         | 1           | 0         |

---

# Control Signal Definitions

| Signal      | Width  | Description                                        |
| ----------- | ------ | -------------------------------------------------- |
| alu_op      | 3 bits | Selects the ALU operation                          |
| reg_write   | 1 bit  | Enables writing into the register file             |
| mem_read    | 1 bit  | Enables reading from data memory                   |
| mem_write   | 1 bit  | Enables writing into data memory                   |
| jump_enable | 1 bit  | Loads Program Counter with jump address            |
| wb_select   | 1 bit  | Selects ALU result or memory output for write-back |

---

# Block Diagrams

> Add your block diagrams inside the **block diagrams/** folder and update the filenames below.

## Top-Level Processor

```markdown
![Top Block Diagram](block%20diagrams/top_block_diagram.png)
```

## ALU

```markdown
![ALU Block Diagram](block%20diagrams/alu_block_diagram.png)
```

## Register File

```markdown
![Register File](block%20diagrams/register_file_block_diagram.png)
```

## Control Unit

```markdown
![Control Unit](block%20diagrams/control_unit_block_diagram.png)
```

---

# Simulation

Compile the processor:

```bash
iverilog -o top_tb.vvp tb/top_tb.v src/*.v
```

Run the simulation:

```bash
vvp top_tb.vvp
```

View the generated waveform:

```bash
gtkwave wave.vcd
```

---

# Testbenches

Each hardware module has an independent testbench located in the **tb/** directory.

| Testbench               | Purpose                         |
| ----------------------- | ------------------------------- |
| alu_tb.v                | ALU verification                |
| register_file_tb.v      | Register File verification      |
| program_counter_tb.v    | Program Counter verification    |
| instruction_memory_tb.v | Instruction Memory verification |
| decoder_tb.v            | Decoder verification            |
| data_memory_tb.v        | Data Memory verification        |
| control_unit_tb.v       | Control Unit verification       |
| top_tb.v                | Complete processor verification |

---

# Development Tools

| Tool               | Purpose                       |
| ------------------ | ----------------------------- |
| Verilog HDL        | Hardware Description Language |
| Icarus Verilog     | Simulation                    |
| GTKWave            | Waveform Viewer               |
| Visual Studio Code | Code Editor                   |
| Git                | Version Control               |
| GitHub             | Repository Hosting            |

---

# 🔮 Future Improvements

* Add STORE instruction
* Add Immediate arithmetic instructions
* Implement Conditional Branch instructions
* Add Pipeline architecture
* Introduce Interrupt handling
* Implement Hazard Detection Unit
* Support external HEX/BIN program loading
* Extend processor to 16-bit or 32-bit architecture

---

# License

This project is intended for educational and learning purposes.

---

## Author

**Gautam Gupta**

B.Tech Electronics and Communication Engineering
Visvesvaraya National Institute of Technology (VNIT), Nagpur

GitHub: https://github.com/ggz4u

- GitHub — version control
