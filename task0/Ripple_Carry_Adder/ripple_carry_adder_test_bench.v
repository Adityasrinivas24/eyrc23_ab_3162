
module tb_ripple_carry_adder;
reg [1:0] a; // Define all I/O ports
reg [1:0] b;
reg cin;
wire [1:0] sum;
wire c_out;
// Map all th I/O ports with DUT
ripple_carry_adder uut (.a(a), .b(b), .cin(cin), .sum(sum), .c_out(c_out));

initial begin // Initialize the pins with different combination of inputs .
    a=2'b00 ; b=2'b00; cin =1'b0; # 100;
    a =2'b01; b=2'b11; cin =1'b0; # 100;
    a =2'b11; b=2'b11; cin =1'b1; # 100;
    a =2'b10; b=2'b01; cin =1'b1; # 100;
end // End of initial block

endmodule
