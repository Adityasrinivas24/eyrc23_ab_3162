module uart_tx_tb;

    // Define constants
    parameter CLKS_PER_BIT = 434; // Define the same value as in the module
    
    // Define signals
    reg clk_50M;
    reg [7:0] data;
    wire tx;

    // Instantiate the module under test
    uart_tx uut (
        .clk_50M(clk_50M),
        .data(data),
        .tx(tx)
    );

    // Clock generation
    always begin
        #5 clk_50M = ~clk_50M; // Toggle the clock every 5 time units
    end

    // Test stimulus
    initial begin
        // Initialize signals
        clk_50M = 0;
        data = 8'b11011011; // Set a non-zero value to trigger transmission

        // Wait for a few clock cycles before checking output
        #10;

        // Monitor tx signal
        $display("Time = %t, tx = %b", $time, tx);

        // Finish simulation after a while
        #100;
        $finish;
    end

endmodule
