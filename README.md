# simple-risc-processor
 simple 8-bit RISC processor implemented in Verilog HDL from scratch — custom ISA, RTL design, and full simulation with testbenches.

## Instruction Set Architecture

| Instruction | Opcode | Operation |
|-------------|--------|-----------|
| ADD Rd, Rs1, Rs2 | 000 | Rd = Rs1 + Rs2 |
| SUB Rd, Rs1, Rs2 | 001 | Rd = Rs1 - Rs2 |
| AND Rd, Rs1, Rs2 | 010 | Rd = Rs1 & Rs2 |
| OR Rd, Rs1, Rs2  | 011 | Rd = Rs1 | Rs2 |
| NOT Rd, Rs1      | 100 | Rd = ~Rs1 |
| MOV Rd, imm      | 101 | Rd = immediate |
| LOAD Rd, addr    | 110 | Rd = Mem[addr] |
| JMP addr         | 111 | PC = addr |

## Modules
- ALU
- Register File
- Program Counter
- Instruction Memory
- Instruction Decoder
- Data Memory
- Control Unit
- Top Level Module

## Tools Used
- Icarus Verilog
- GTKWave / EDA Playground

## Instruction Memory 
PC → [Instruction Memory] → instruction bits → [Decoder]
- [15:13] — opcode    (3 bits — 8 possible instructions)
- [12:10] — dest reg  (3 bits — Rd)
- [9:7]   — src reg1  (3 bits — Rs1)
- [6:4]   — src reg2  (3 bits — Rs2)
- [3:0]   — unused / immediate (4 bits)
