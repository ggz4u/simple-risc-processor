module decoder_tb;

    reg [15:0] instruction;
    wire [2:0] opcode;
    wire [2:0] rd;
    wire [2:0] rs1;
    wire [2:0] rs2;
    wire [7:0] immediate_addr; 
    wire is_rtype;
    wire is_load;
    wire is_jmp;

    //INSTANTIATION
    decoder uut(
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .immediate_addr(immediate_addr),
        .is_jmp(is_jmp),
        .is_load(is_load),
        .is_rtype(is_rtype)
    );

    initial begin
        $monitor("Time=%0t | instruction=%b | opcode=%b | rd=%b | rs1=%b | rs2=%b | immediate_addr=%b | is_jmp=%b | is_load=%b | is_rtype=%b",
                 $time, instruction, opcode, rd, rs1, rs2, immediate_addr, is_jmp, is_load, is_rtype);
    end

    initial begin
        $dumpfile("decoder_tb.vcd");
        $dumpvars(0, decoder_tb);

        // Test case 1: R-type instruction
        instruction = 16'b000_001_010_011_0000; // opcode=000, rd=001, rs1=010, rs2=011
        #10;

        //Test case 2: AND instruction
        instruction = 16'b010_101_010_011_0000; // opcode=010, rd=101, rs1=010, rs2=011
        #10;

        // Test case 3: Load instruction
        instruction = 16'b110_011_00_00000101; #10;

        // Test case 4: Jump instruction
        instruction = 16'b111_00000_00000100; #10;

        //test case 5: NOP instruction
        instruction = 16'b000_000_000_000_0000; #10;

        //Rapidly change instruction and verify
        instruction = 16'b000_001_010_011_0000; #2;
        instruction = 16'b111_00000_00000100;   #2;
        instruction = 16'b110_011_00_00000101;  #2;
        instruction = 16'b000_001_010_011_0000; #2;

        $finish;
    end

endmodule