//PC → [Instruction Memory] → instruction bits → [Decoder]
//[15:13] — opcode    (3 bits — 8 possible instructions)
// [12:10] — dest reg  (3 bits — Rd)
// [9:7]   — src reg1  (3 bits — Rs1)
// [6:4]   — src reg2  (3 bits — Rs2)
// [3:0]   — unused / immediate (4 bits)

module instruction_memory(
    input [7:0] addr,
    output reg [15:0] instruction
);
    //Memory - 256 locations of 16 bits each (256 x 16 bits)
    reg [15:0] memory [255:0];
    integer i;
    //Preload the instruction memory with some instructions
    initial begin
        // Format: opcode(3) | Rd(3) | Rs1(3) | Rs2(3) | unused(4)
        // ADD R1, R2, R3 → opcode=000, Rd=001, Rs1=010, Rs2=011
        
        for(i=0; i<256; i=i+1) begin
            memory[i] = 16'b0000000000000000; // Initialize all memory to NOP(No operation) (or 0)
        end
        // For your CPU to execute anything, there has to be something already sitting at memory[0] before the simulation even starts ticking.
        // A real CPU has the same problem — that's literally what "bootstrapping" means. 
        // On real hardware this is solved by things like a BIOS/bootloader burned into ROM, or a .hex/.mem file loaded by a programmer before power-on. 
        memory[0] = 16'b000_001_010_011_0000;
        memory[1] = 16'b001_100_001_011_0000;
        memory[2] = 16'b010_101_010_011_0000;
        memory[3] = 16'b011_110_001_010_0000;
        memory[4] = 16'b100_111_001_000_0000;
        memory[5] = 16'b101_001_010_000_0000;
        memory[6] = 16'b111_000_00_00000100; //JMP to address 4 (Here '111' is the opcode for JMP, and '00000100' is the address to jump to)

    end

    always @(*) begin
        instruction = memory[addr];
    end
endmodule




