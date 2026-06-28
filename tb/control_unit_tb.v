module control_unit_tb;
    
    reg [2:0] opcode;
    wire [2:0] alu_op;
    wire mem_read;
    wire mem_write;
    wire reg_write;
    wire jump_enable;
    wire wb_select;

    // Instantiate the control unit
    control_unit uut(
        .opcode(opcode),
        .alu_op(alu_op),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .jump_enable(jump_enable),
        .wb_select(wb_select)
    );
    
    initial begin
        $monitor("Time=%0t | opcode=%b | alu_op=%b | mem_read=%b | mem_write=%b | reg_write=%b | jump_enable=%b | wb_select=%b",
                 $time, opcode, alu_op, mem_read, mem_write, reg_write, jump_enable, wb_select);
    end

    initial begin
        $dumpfile("control_unit_tb.vcd");
        $dumpvars(0, control_unit_tb);

        // Applying test vectors
        opcode = 3'b000; #10;
        opcode = 3'b001; #10;
        opcode = 3'b010; #10;
        opcode = 3'b011; #10;
        opcode = 3'b100; #10;
        opcode = 3'b101; #10;
        opcode = 3'b110; #10;
        opcode = 3'b111; #10;
        opcode = 3'bxxx; #10; // Invalid opcode test
        $finish;
    end
endmodule
