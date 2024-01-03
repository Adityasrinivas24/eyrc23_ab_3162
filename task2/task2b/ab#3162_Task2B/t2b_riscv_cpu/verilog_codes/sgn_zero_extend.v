module sgn_zero_extend(
    input  [31:0] read_data_mem,
    input  [ 2:0] funct3,
    output reg [31:0] ext_out
);

always @(*) begin
    case(funct3)
        // lb
        2'b000: ext_out = {{24{read_data_mem[7]}}, read_data_mem[7:0]};
        // lh
        2'b001: ext_out = {{16{read_data_mem[15]}}, read_data_mem[15:0]};
        // lbu
        2'b100: ext_out = {24'b0, read_data_mem[7:0]};
        // lhu
        2'b101: ext_out = {16'b0, read_data_mem[15:0]};
        // lw
        2'b010: ext_out = read_data_mem;
        default: ext_out = read_data_mem; // undefined
    endcase
end

endmodule
