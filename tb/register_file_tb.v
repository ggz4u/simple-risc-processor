module register_file_tb;

    // Inputs
    reg clk;
    reg rst;
    reg write_enable;
    reg [2:0] read_addr1;
    reg [2:0] read_addr2;
    reg [2:0] write_addr;
    reg [7:0] write_data;

    // Outputs
    wire [7:0] read_data1;
    wire [7:0] read_data2;

    // Instantiate register file
    register_file uut(
        .clk(clk),
        .rst(rst),
        .write_enable(write_enable),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation — 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Monitor
    initial begin
        $monitor("Time=%0t | rst=%b | we=%b | waddr=%0d | wdata=%0d | raddr1=%0d | rdata1=%0d | raddr2=%0d | rdata2=%0d",
                  $time, rst, write_enable, write_addr, write_data,
                  read_addr1, read_data1, read_addr2, read_data2);
    end

    initial begin
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, register_file_tb);

        // -------------------------
        // Test 1 — Reset
        // -------------------------
        rst = 1; write_enable = 0;
        read_addr1 = 0; read_addr2 = 0;
        write_addr = 0; write_data = 0;
        #10;
        rst = 0;
        #10;
        // Verify all registers are 0 after reset
        read_addr1 = 3'd0; read_addr2 = 3'd7; #10;

        // -------------------------
        // Test 2 — Write then Read
        // -------------------------
        // Write 42 to R3
        write_enable = 1;
        write_addr = 3'd3;
        write_data = 8'd42;
        #10;
        write_enable = 0;
        // Read R3 back
        read_addr1 = 3'd3;
        #10;
        // Expected: read_data1 = 42

        // -------------------------
        // Test 3 — Write to multiple registers
        // -------------------------
        // Write 99 to R1
        write_enable = 1;
        write_addr = 3'd1;
        write_data = 8'd99;
        #10;
        // Write 55 to R5
        write_addr = 3'd5;
        write_data = 8'd55;
        #10;
        write_enable = 0;
        // Read R1 and R5 simultaneously
        read_addr1 = 3'd1;
        read_addr2 = 3'd5;
        #10;
        // Expected: read_data1 = 99, read_data2 = 55

        // -------------------------
        // Test 4 — Write enable = 0
        // -------------------------
        // Try writing to R3 with write_enable off
        write_enable = 0;
        write_addr = 3'd3;
        write_data = 8'd255;
        #10;
        // Read R3 — should still be 42
        read_addr1 = 3'd3;
        #10;
        // Expected: read_data1 = 42, not 255

        // -------------------------
        // Test 5 — Data Forwarding
        // -------------------------
        // Write 77 to R2 and read R2 in the same cycle
        write_enable = 1;
        write_addr = 3'd2;
        write_data = 8'd77;
        read_addr1 = 3'd2; // Reading same address being written
        #10;
        // Expected: read_data1 = 77 (forwarded, not old value)
        write_enable = 0;

        // -------------------------
        // Test 6 — Reset clears everything
        // -------------------------
        rst = 1; #10;
        rst = 0;
        read_addr1 = 3'd3; // Was 42
        read_addr2 = 3'd1; // Was 99
        #10;
        // Expected: both read_data = 0

        $finish;
    end

endmodule