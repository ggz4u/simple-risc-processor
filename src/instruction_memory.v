//Instruction Memory: ROM/Flash memory; stroes bootloader and program instructions(fixed size); CANNOT be OVERWRITTEN(NON VOLATILE)
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
    //Memory - 256 locations of 16 bits each (256 x 16 bits)[512B instruction memory]
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
        memory[0] = 16'b000_010_000_000_0000; // ADD R1, R0, R0 — R1 = 0 (MOV replacement)
        memory[1] = 16'b101_000_001_1000010; // STORE R1, addr 66 — Rs=R1 now in rs1 field [9:7]
        memory[2] = 16'b110_010_00_01000010;    // LOAD R2, addr 66 — read it back into R2
        memory[3] = 16'b000_100_010_001_0000;   // ADD R3, R2, R1
        memory[4] = 16'b111_00000_00000000;     // JMP to 0   // JMP to address  //JMP to address 4 (Here '111' is the opcode for JMP, and '00000100' is the address to jump to)

    end

    always @(*) begin
        instruction = memory[addr];
    end
endmodule




