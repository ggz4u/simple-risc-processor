![Verilog](https://img.shields.io/badge/Language-Verilog-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Simulator](https://img.shields.io/badge/Simulator-Icarus%20Verilog-orange)

# Simple RISC Processor — Control Signal Table

## Instruction Set Architecture

| Instruction | Opcode | Operation | Description |
|-------------|--------|-----------|-------------|
| ADD | 000 | Rd = Rs1 + Rs2 | Add two registers |
| SUB | 001 | Rd = Rs1 - Rs2 | Subtract two registers |
| AND | 010 | Rd = Rs1 & Rs2 | Bitwise AND |
| OR | 011 | Rd = Rs1 \| Rs2 | Bitwise OR |
| NOT | 100 | Rd = ~Rs1 | Bitwise NOT |
| MOV | 101 | Rd = Rs1 | Copy register value |
| LOAD | 110 | Rd = Mem[addr] | Load from data memory |
| JMP | 111 | PC = addr | Jump to address |

## Instruction Formats

| Type | Bits [15:13] | Bits [12:10] | Bits [9:7] | Bits [6:4] | Bits [3:0] |
|------|-------------|-------------|-----------|-----------|-----------|
| R-type (ADD/SUB/AND/OR/NOT/MOV) | opcode | Rd | Rs1 | Rs2 | unused |
| LOAD | opcode | Rd | unused | unused | — |
| JMP | opcode | unused | unused | unused | — |

| Type | Bits [15:13] | Bits [12:10] | Bits [9:8] | Bits [7:0] |
|------|-------------|-------------|-----------|-----------|
| LOAD | opcode | Rd | unused | mem_addr |
| JMP | opcode | unused | unused | jump_addr |

## Control Signals

| Instruction | Opcode | alu_op | reg_write | mem_read | mem_write | jump_enable | wb_select |
|-------------|--------|--------|-----------|----------|-----------|-------------|-----------|
| ADD | 000 | 000 | 1 | 0 | 0 | 0 | 0 |
| SUB | 001 | 001 | 1 | 0 | 0 | 0 | 0 |
| AND | 010 | 010 | 1 | 0 | 0 | 0 | 0 |
| OR | 011 | 011 | 1 | 0 | 0 | 0 | 0 |
| NOT | 100 | 100 | 1 | 0 | 0 | 0 | 0 |
| MOV | 101 | 101 | 1 | 0 | 0 | 0 | 0 |
| LOAD | 110 | xxx | 1 | 1 | 0 | 0 | 1 |
| JMP | 111 | xxx | 0 | 0 | 0 | 1 | 0 |

## Control Signal Definitions

| Signal | Width | Description |
|--------|-------|-------------|
| alu_op | 3 bits | Tells ALU which operation to perform |
| reg_write | 1 bit | Enables writing result back to register file |
| mem_read | 1 bit | Enables reading from data memory |
| mem_write | 1 bit | Enables writing to data memory |
| jump_enable | 1 bit | Tells PC to load jump address instead of incrementing |
| wb_select | 1 bit | 0 = write ALU result to register, 1 = write memory data to register |

## Module List

| Module | File |
|--------|------|
| ALU | alu.v |
| Register File | register_file.v |
| Program Counter | program_counter.v |
| Instruction Memory | instruction_memory.v |
| Decoder | decoder.v |
| Data Memory | data_memory.v |
| Control Unit | control_unit.v |
| Top Level | top.v |

## Tools Used
- Icarus Verilog — simulation
- GTKWave — waveform viewing
- EDA Playground — browser based simulation
- GitHub — version control
