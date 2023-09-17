
module full_adder (
    input a, b, c_in, 
    output sum , c_out 
);

assign sum = a^b^c_in;
assign c_out = ((a&b)|(c_in & (a^b)));

endmodule
