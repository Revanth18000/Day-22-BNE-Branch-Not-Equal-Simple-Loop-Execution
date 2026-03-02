module tb_risc_bne_cpu;

    reg clk = 0;
    reg reset = 1;

    wire [7:0] R0, R1, R2, R3;

    // Instantiate DUT
    risc_bne_cpu DUT (
        .clk(clk),
        .reset(reset),
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .R3(R3)
    );

    // Clock generation (10 time unit period)
    always #5 clk = ~clk;

    initial begin
        #10 reset = 0;

        // Let CPU run long enough for loop to finish
        #200;

        $display("---- Final Register Values ----");
        $display("R0 = %d", R0);
        $display("R1 = %d", R1);
        $display("R2 = %d", R2);
        $display("R3 = %d", R3);

        $finish;
    end

endmodule