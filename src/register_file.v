module register_file(
    input clk,
    input rst,
    input write_enable,
    input [2:0] read_addr1, // Address of first source register
    input [2:0] read_addr2, // Address of second source register
    input [2:0] write_addr, // Address of destination register
    input [7:0] write_data, // Data to be written to the destination register
    output reg[7:0] read_data1, // Data from first source register
    output reg[7:0] read_data2 // Data from second source register
);
    integer i;

    reg [7:0] registers [0:7];
    always @(*) begin

        read_data1 = (write_enable && (read_addr1 == write_addr)) ? write_data : registers[read_addr1]; // rectifying the read-before-write hazard
        read_data2 = (write_enable && (read_addr2 == write_addr)) ? write_data : registers[read_addr2];
    end

    always @(posedge clk or posedge rst) begin
        
        if(rst) begin
            for(i=0; i<8; i=i+1)begin
                registers[i] <= 8'b0;
            end

        end else if(write_enable) begin
            registers[write_addr] <= write_data;
        end
    end
endmodule
