`timescale 1 ns/1 ns

// No Teams are allowed to edit this file.
module tb;

reg clk_50M;

wire clk_3125KHz;
reg exp_clk_out_1;
reg error_clk_1;

wire clk_195KHz;
reg exp_clk_out_2;
reg error_clk_2;

reg [3:0] duty_cycle;
wire pwm_signal;
reg exp_pwm_out;
reg error_pwm;
integer error_count;
reg [2:0] i;
integer fw;

t1a_fs_pwm_bdf uut (clk_50M, duty_cycle, pwm_signal, clk_195KHz, clk_3125KHz);

initial begin
    exp_clk_out_1 = 0; error_clk_1 = 0; exp_pwm_out = 1; error_pwm = 0; i = 0;
    exp_clk_out_2 = 0; error_clk_2 = 0; error_count = 0; clk_50M = 0;  fw = 0;
end

always begin
    clk_50M = ~clk_50M; #10;
end

always @(posedge clk_50M) begin
    exp_clk_out_1 <= ~exp_clk_out_1; #160;
end

always @(posedge clk_50M) begin
    exp_clk_out_2 <= ~exp_clk_out_2; #2560;
end

always @(posedge clk_50M) begin
	duty_cycle[3:0] = 4'd08; i = 0; #5120;
	duty_cycle[3:0] = 4'd11; i = 1; #5120;
    duty_cycle[3:0] = 4'd04; i = 2; #5120;
	duty_cycle[3:0] = 4'd12; i = 3; #5120;
	duty_cycle[3:0] = 4'd10; i = 4; #5120;
	duty_cycle[3:0] = 4'd05; i = 5; #5120;
	duty_cycle[3:0] = 4'd09; i = 6; #5120;
	duty_cycle[3:0] = 4'd11; i = 7; #5120;
end

always @(posedge clk_50M) begin
	exp_pwm_out <= 1; #(duty_cycle*320);
	exp_pwm_out <= 0; #((16-duty_cycle)*320);
end

always @(clk_50M) begin
    if (exp_pwm_out !== pwm_signal) begin
        error_pwm <= 1; error_count = error_count + 1'b1;
    end
    else begin
        error_pwm <= 0;
    end
    if (exp_clk_out_1 !== clk_3125KHz) begin
        error_clk_1 <= 1; error_count = error_count + 1'b1;
    end
    else begin
        error_clk_1 <= 0;
    end
    if (exp_clk_out_2 !== clk_195KHz) begin
        error_clk_2 <= 1; error_count = error_count + 1'b1;
    end
    else begin
        error_clk_2 <= 0;
    end
    if (i == 7) begin
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

