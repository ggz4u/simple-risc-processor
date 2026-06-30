module top_tb;

    reg clk;
    reg rst;

    top uut(
        .clk(clk),
        .rst(rst)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $monitor("Time=%0t | PC=%0d | opcode=%b | rd=%b rs1=%b rs2=%b | read_data1=%0d read_data2=%0d | alu_result=%0d carry=%b",
                  $time,
                  uut.pc,
                  uut.opcode,
                  uut.rd, uut.rs1, uut.rs2,
                  uut.read_data1, uut.read_data2,
                  uut.alu_result, uut.carry);
    end

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        rst = 1; #10;
        rst = 0;

        // memory[0] = "MOV R2, R1" -> reads R1 as the source.
        // Everything downstream (R3=R1+R2, R4=R3-R1, ...) traces back to
        // R1's value, so R1 is the register that actually needs seeding -
        // poking R2/R3 directly does nothing useful since R2 gets
        // overwritten by the MOV anyway, and R3 isn't read until later.
        uut.rf_inst.registers[1] = 8'd12;  // R1 = 12 (Random value)- To verify the operations stored in the instruction memory
        
        #200;

        $finish;
    end

endmodule