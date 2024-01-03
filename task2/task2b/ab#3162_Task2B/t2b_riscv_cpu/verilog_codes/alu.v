
// alu.v - ALU module

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [2:0] alu_ctrl,         // ALU control
    input       op7b5,                   // bit 5 of funct7
	input       unsign,                  // unsigned
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero                    // zero flag
);

always @(a, b, alu_ctrl) begin
    case (alu_ctrl)
        3'b000:  alu_out <= a + b;       // ADD
        3'b001:  alu_out <= a + ~b + 1;  // SUB
        3'b010:  alu_out <= a & b;       // AND
        3'b011:  alu_out <= a | b;       // OR
        3'b100:  alu_out <= a ^ b;       // XOR
        3'b101:  begin                   // SLT
                    if (a[31] != b[31] && !unsign) alu_out <= a[31] ? 0 : 1;
                    else alu_out <= a < b ? 1 : 0;
                 end
        3'b110:  alu_out <= a << b[4:0];      // SLL
        3'b111:  begin if(op7b5) alu_out <= a >>> b[4:0]; // SRA
                    else alu_out <= a >> b[4:0];      // SRL
                 end
        default: alu_out <= 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule
