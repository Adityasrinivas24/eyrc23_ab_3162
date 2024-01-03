`timescale 1 ns/1 ns

module tb;

reg clk_50M;
reg reset;

wire trigger;
reg exp_trigger;
reg error_trigger;

reg echo_rx;

wire out;
reg exp_out;
reg error_out;

wire [21:0] pulses;
wire [1:0] state;
integer error_count;

reg [2:0] i;
integer fw;

localparam integer cycle = 1000000;

t1c_pulse_gen_detect uut (clk_50M, reset, echo_rx, trigger, out, pulses, state);

initial begin
    clk_50M = 0; reset = 1; exp_trigger = 0; error_trigger = 0; i = 0;
    exp_out = 0; error_count = 0; fw = 0; echo_rx = 0; error_out = 0;
end

always begin
    clk_50M = ~clk_50M; #10;
end

always @(posedge clk_50M) begin
    #20; exp_out <= 0; reset = 0;

    exp_trigger <= 0; #1000;
    exp_trigger <= 1; #10000;
    exp_trigger <= 0;

    echo_rx = 1; #294200;
    echo_rx = 0; #(cycle-294200);
    i = 0;

    #20; exp_out <= 0; reset = 1; #20;
    reset = 0;

    exp_trigger <= 0; #1000;
    exp_trigger <= 1; #10000;
    exp_trigger <= 0;

    echo_rx = 1; #588200;
    echo_rx = 0; #(cycle-588200);
    exp_out <= 1; i = 1; #20;

    exp_trigger <= 0; #1000;
    exp_trigger <= 1; #10000;
    exp_trigger <= 0;

    echo_rx = 1; #980600;
    echo_rx = 0; #(cycle-980600);
    i = 2;

    exp_out <= 1; reset = 0; #20;

    exp_trigger <= 0; #1000;
    exp_trigger <= 1; #10000;
    exp_trigger <= 0;

    echo_rx = 1; #294200;
    echo_rx = 0; #(cycle-294200);
    i = 3;

    #20; exp_out <= 0; reset = 1; #20;
    reset = 0;

    exp_trigger <= 0; #1000;
    exp_trigger <= 1; #10000;
    exp_trigger <= 0;

    echo_rx = 1; #588200;
    echo_rx = 0; #(cycle-588200);
    exp_out <= 1; #20;

    #200; exp_out <= 0; reset = 1; #20;

    i = 4; #1000;

end

always @(clk_50M) begin
    if (exp_trigger !== trigger) begin
        error_trigger <= 1; error_count = error_count + 1'b1;
    end
    else error_trigger <= 0;
    if (exp_out !== out) begin
        error_out <= 1; error_count = error_count + 1'b1;
    end
    else error_out <= 0;
    if (i == 4) begin
        if (error_count !== 0) begin
            fw = $fopen("results.txt","w");
            $fdisplay(fw, "%02h","Errors");
            $display("Error(s) encountered, please check your design!");
            $fclose(fw);
        end
        else begin
            fw = $fopen("results.txt","w");
            $fdisplay(fw, "%02h","No Errors");
            $display("No errors encountered, congratulations!");
            $fclose(fw);
        end
        i = 0;
        //$stop;
    end
end

endmodule
