module alu_tb;
    reg [7:0] a, b;
    reg [2:0] opcode;
    wire [7:0] result;
    wire carry, zero_flag;

    // Instantiate ALU
    alu uut(
        .a(a), .b(b),
        .opcode(opcode),
        .result(result),
        .carry(carry),
        .zero_flag(zero_flag)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // Test ADD — normal
        a = 8'd10; b = 8'd5; opcode = 3'b000; #10;
        // Test ADD — with carry
        a = 8'd200; b = 8'd100; opcode = 3'b000; #10;
        // Test SUB — normal
        a = 8'd10; b = 8'd5; opcode = 3'b001; #10;
        // Test SUB — with borrow
        a = 8'd5; b = 8'd10; opcode = 3'b001; #10;
        // Test AND
        a = 8'b11001100; b = 8'b10101010; opcode = 3'b010; #10;
        // Test OR
        a = 8'b11001100; b = 8'b10101010; opcode = 3'b011; #10;
        // Test NOT
        a = 8'b10101010; b = 8'b0; opcode = 3'b100; #10;
        // Test MOV
        a = 8'd42; b = 8'b0; opcode = 3'b101; #10;
        // Test zero flag
        a = 8'd0; b = 8'd0; opcode = 3'b000; #10;

        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t a=%d b=%d opcode=%b result=%d carry=%b zero=%b",
                  $time, a, b, opcode, result, carry, zero_flag);
    end

endmodule