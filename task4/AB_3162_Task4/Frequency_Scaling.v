/*
Module - Frequency_Scaling

This Module will scale down 50 MHz clock signal to 3.125 MHz clock signal for ADC Controller, RISC_V CPU, Algorithm and some other modules of your design.

Frequency Scaling Design

Input  - clk_50M  - 50 Mhz FPGA Oscillator

Output - adc_sclk - 3.125Mhz Output Frequency to ADC Module
*/

// Module Declaration
module Frequency_Scaling(
    input clk_50M,
    output reg adc_clk_out
);

// Declaring registers
reg [2:0] s_clk_counter = 0;

// For ADC Module 50Mhz to 3.125Mhz
always @(negedge clk_50M) begin
    if (s_clk_counter < 8) adc_clk_out = ~adc_clk_out;
    s_clk_counter = s_clk_counter + 1'b1;
end

endmodule
