module data_memory_tb;
    reg clk;
    reg rst;
    reg mem_read;
    reg mem_write;
    reg [7:0] addr;
    reg [7:0] write_data;
    wire [7:0] read_data;

    data_memory uut(
        .clk(clk),
        .rst(rst),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    initial begin
    $dumpfile("data_memory_tb.vcd");   // names the output file
    $dumpvars(0, data_memory_tb);      // says WHAT to record into it
    end

    //Generating clock
    initial clk = 0;
    always #5 clk = ~clk; // Time Period = 10ns

    initial begin
        $monitor("Time: %0t | clk: %b | rst: %b | mem_read: %b | mem_write: %b | addr: %h | write_data: %h | read_data: %h", 
                  $time, clk, rst, mem_read, mem_write, addr, write_data, read_data);
    end

    initial begin
        rst = 1;
        mem_read = 0;
        mem_write = 0;
        addr = 0;
        write_data = 0;

        @(posedge clk) //Holding reset for 1 clock then releasing it
        #1;// Wait for a small delay to ensure reset is registered
        rst = 0;

        //Writing 0xAA to address 10
        addr = 8'd10;
        write_data = 8'hAA;
        mem_write = 1;
        @(posedge clk);
        #1;
        mem_write = 0;

        //Reading at address 10
        mem_read = 1;
        addr = 8'd10;
        #10;

        mem_read = 0;

        //Writing when mem_write = 0
        mem_write = 0;
        addr = 20;
        write_data = 8'hBB;
        @(posedge clk);
        #1;

        //Reading address 20
        mem_read = 1;
        addr = 20; // Address must have 0(reset value) since write was disabled
        #10;

        $finish;
    
    end


endmodule