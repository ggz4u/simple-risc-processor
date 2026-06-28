`timescale 1ns/1ps

module instruction_memory_tb;

    reg  [7:0]  addr;
    wire [15:0] instruction;

    // Bit-field views of the fetched instruction, purely for readability
    // in the waveform viewer / $monitor output. These are NOT part of the
    // DUT — just testbench-side decoding so we can sanity-check fields
    // without doing bit-slicing math in our heads every time.
    wire [2:0] opcode = instruction[15:13];
    wire [2:0] rd     = instruction[12:10];
    wire [2:0] rs1    = instruction[9:7];
    wire [2:0] rs2    = instruction[6:4];
    wire [3:0] unused = instruction[3:0];

    integer errors = 0; // running tally — nonzero at the end means something's wrong
    integer i;           // loop variable for the address sweep test, module scope

    // Instantiate the DUT (Design Under Test)
    instruction_memory uut (
        .addr(addr),
        .instruction(instruction)
    );

    // Reusable check task: compares the DUT's instruction output against
    // an expected value, prints PASS/FAIL, and increments the error count
    // on mismatch. Doing this as a task instead of copy-pasting if-checks
    // 9 times means the comparison logic only has to be correct once.
    task check_instruction(input [7:0] test_addr, input [15:0] expected);
        begin
            addr = test_addr;
            #5; // let the combinational always@(*) block settle
            if (instruction !== expected) begin
                errors = errors + 1;
                $display("FAIL: addr=%0d  expected=%b  got=%b",
                          test_addr, expected, instruction);
            end else begin
                $display("PASS: addr=%0d  instruction=%b  (opcode=%b rd=%b rs1=%b rs2=%b unused=%b)",
                          test_addr, instruction, opcode, rd, rs1, rs2, unused);
            end
        end
    endtask

    initial begin
        $dumpfile("instruction_memory_tb.vcd");
        $dumpvars(0, instruction_memory_tb);

        $display("---- Test 1: ADD  (addr 0) ----");
        check_instruction(8'd0, 16'b000_001_010_011_0000);

        $display("---- Test 2: opcode=001 (addr 1) ----");
        check_instruction(8'd1, 16'b001_100_001_011_0000);

        $display("---- Test 3: opcode=010 (addr 2) ----");
        check_instruction(8'd2, 16'b010_101_010_011_0000);

        $display("---- Test 4: opcode=011 (addr 3) ----");
        check_instruction(8'd3, 16'b011_110_001_010_0000);

        $display("---- Test 5: opcode=100 (addr 4) ----");
        check_instruction(8'd4, 16'b100_111_001_000_0000);

        $display("---- Test 6: opcode=101 (addr 5) ----");
        check_instruction(8'd5, 16'b101_001_010_000_0000);

        $display("---- Test 7: JMP encoding (addr 6) ----");
        check_instruction(8'd6, 16'b111_000_00_00000100);

        $display("---- Test 8: NOP region, lower boundary (addr 7) ----");
        check_instruction(8'd7, 16'b0000000000000000);

        $display("---- Test 9: NOP region, mid-range spot check (addr 128) ----");
        check_instruction(8'd128, 16'b0000000000000000);

        $display("---- Test 10: NOP region, upper boundary (addr 255) ----");
        check_instruction(8'd255, 16'b0000000000000000);

        $display("---- Test 11: re-read addr 0 after walking through full range ----");
        // Confirms reads are stateless / purely combinational — revisiting
        // an earlier address gives the same result, i.e. reading doesn't
        // mutate memory and addr decode has no hidden order-dependence.
        check_instruction(8'd0, 16'b000_001_010_011_0000);

        $display("---- Test 12: rapid address sweep (combinational responsiveness) ----");
        // Walk every address from 0 to 9 with only #1 between changes
        // (instead of the usual #5) to make sure the always@(*) block
        // reacts on EVERY addr change, not just ones we pause long enough
        // to "let settle." If sensitivity were wrong (e.g. someone had
        // mistakenly written always@(posedge addr[0]) or similar), this
        // is the kind of test that would expose it.
        for (i = 0; i < 10; i = i + 1) begin
            addr = i;
            #1;
            $display("  sweep addr=%0d -> instruction=%b", i, instruction);
        end

        $display("--------------------------------------------------");
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);
        $display("--------------------------------------------------");

        $finish;
    end

endmodule