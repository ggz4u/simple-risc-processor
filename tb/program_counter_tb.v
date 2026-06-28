module program_counter_tb;

    // Part 2 — signals
    reg clk;
    reg rst;
    reg jump_enable;
    reg [7:0] jump_addr;
    wire [7:0] pc;

    // Part 3 — instantiate
    program_counter uut(
        .clk(clk),
        .rst(rst),
        .jump_enable(jump_enable),
        .jump_addr(jump_addr),
        .pc(pc)
    );

    // Part 4 — clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Monitor — prints every time any signal changes
    initial begin
        $monitor("Time=%0t | rst=%b | jump_en=%b | jump_addr=%0d | pc=%0d",
                  $time, rst, jump_enable, jump_addr, pc);
    end

    // Part 5 — stimulus
    initial begin
        $dumpfile("pc_tb.vcd");
        $dumpvars(0, program_counter_tb);

        // Test 1 — Reset
        rst = 1; jump_enable = 0; jump_addr = 0;
        #10;
        // Expected: pc = 0

        // Test 2 — Normal increment
        rst = 0;
        #10; // Expected: pc = 1
        #10; // Expected: pc = 2
        #10; // Expected: pc = 3
        #10; // Expected: pc = 4

        // Test 3 — Jump
        jump_enable = 1; jump_addr = 8'd20;
        #10;
        // Expected: pc = 20
        jump_enable = 0;

        // Test 4 — Resume incrementing after jump
        #10; // Expected: pc = 21
        #10; // Expected: pc = 22
        #10; // Expected: pc = 23

        // Test 5 — Reset in the middle
        rst = 1;
        #10;
        // Expected: pc = 0
        rst = 0;
        #10; // Expected: pc = 1

        $finish;
    end

endmodule