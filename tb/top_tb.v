module top_tb;

    reg clk;
    reg rst;

    top uut(
        .clk(clk),
        .rst(rst)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    // Monitor — watch PC and instruction every cycle
    initial begin
        $monitor("Time=%0t | PC=%0d | instr=%b | opcode=%b",$time,
                  uut.pc,
                  uut.instruction,
                  uut.opcode);
    end

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        // Reset processor
        rst = 1; #20;
        rst = 0;
        
        #200;

        $finish;
    end

endmodule