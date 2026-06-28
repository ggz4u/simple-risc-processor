module top(
    input clk,
    input rst
);
    // Internal wires - connections between all the modules

    // Program Counter
    wire [7:0] pc;
    wire [7:0] jump_addr;

    // Instruction Memory
    wire [15:0] instruction;

    //Decoder outputs
    wire [2:0] opcode;
    wire [2:0] rd;
    wire [2:0] rs1;
    wire [2:0] rs2;
    wire [7:0] imm_addr;
    wire is_rtype;
    wire is_load;
    wire is_jmp;

    //jump address is the same as immediate address of the decoder/ instruction so:
    assign jump_addr = imm_addr;
    
    //Control Unit Outputs
    wire [2:0] alu_op;
    wire reg_write;
    wire mem_read;
    wire mem_write;
    wire jump_enable;
    wire wb_select;

    // Register File outputs
    wire [7:0] read_data1;
    wire [7:0] read_data2;

    // Data Memory outputs
    wire [7:0] mem_read_data;

    //ALU Outputs
    wire [7:0] alu_result;
    wire carry;
    wire Zero_flag;

    // Writeback mux output
    wire [7:0] writeback_data;
    //Writeback MUX
    assign writeback_data = wb_select ? mem_read_data : alu_result;


    //MODULE INSTANTIATIONS
    // 1. Program Counter
    program_counter pc_inst(
        .clk(clk),
        .rst(rst),
        .jump_enable(jump_enable),
        .jump_addr(jump_addr),
        .pc(pc)
    );

    // 2. Instruction Memory
    instruction_memory imem_inst(
        .addr(pc),
        .instruction(instruction)
    );

    // 3. Decoder
    decoder dec_inst(
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .immediate_addr(imm_addr),
        .is_jmp(is_jmp),
        .is_load(is_load),
        .is_rtype(is_rtype)
    );

    // 4. Control Unit
    control_unit cu_inst(
        .opcode(opcode),
        .alu_op(alu_op),
        .mem_read(mem_read),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .jump_enable(jump_enable),
        .wb_select(wb_select)
    );

    // 5. Register File
    register_file rf_inst(
        .clk(clk),
        .rst(rst),
        .write_enable(reg_write),
        .read_addr1(rs1),
        .read_addr2(rs2),
        .write_addr(rd),
        .write_data(writeback_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    //6. ALU
    alu alu_inst(
        .a(read_data1),
        .b(read_data2),
        .opcode(alu_op),
        .result(alu_result),
        .carry(carry),
        .zero_flag(zero_flag)
    );

    // 7. Data Memory
    data_memory dmem_inst(
        .clk(clk),
        .rst(rst),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(imm_addr),
        .write_data(read_data1),
        .read_data(mem_read_data)
    );

endmodule    