module program_counter(
    input clk,
    input rst,
    input jump_enable,
    input [7:0] jump_addr,
    output reg [7:0] pc
);

    always @(posedge clk, posedge rst) begin
        if(rst) 
            pc <= 8'b0;
        else if(jump_enable)
            pc <= jump_addr;
        else
            pc <= pc + 1;

    end
endmodule