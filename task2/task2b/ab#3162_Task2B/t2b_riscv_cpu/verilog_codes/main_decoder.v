
// main_decoder.v - logic for main decoder

module main_decoder (
    input  [6:0] op,
    input [2:0]  funct3, 
    output [2:0] Branch,
    output [1:0] ResultSrc,
    output       MemWrite , ALUSrc,
    output       RegWrite, Jump, Jalr, unsign,
    output [2:0] ImmSrc,
    output [1:0] ALUOp
);

reg [15:0] controls;


always @(*) begin
    case (op)
        // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump_jalr_unsign
        7'b0000011: controls = 16'b1_000_1_0_01_000_00_0_0_0; // lw
        7'b0100011: controls = 16'b0_001_1_1_00_000_00_0_0_0; // sw
        7'b0110011: controls = 16'b1_xxx_0_0_00_000_10_0_0_0; // R–type
        7'b1100011: begin
            case(funct3)
                3'b000: controls = 16'b0_010_0_0_00_100_01_0_0_0; // beq
                3'b001: controls = 16'b0_010_0_0_00_101_01_0_0_0; // bne
                3'b100: controls = 16'b0_010_0_0_00_110_11_0_0_0; // blt
                3'b101: controls = 16'b0_010_0_0_00_111_11_0_0_0; // bge
                3'b110: controls = 16'b0_010_0_0_00_001_11_0_0_1; // bltu
                3'b111: controls = 16'b0_010_0_0_00_011_11_0_0_1; // bgeu
            endcase
        end  // beq
        7'b0010011: begin // I–type ALU
            case (funct3[1:0])
                2'b01:controls = 16'b1_101_1_0_00_000_10_0_0_0; // shift
                2'b11:controls = 16'b1_000_1_0_00_000_10_0_0_1; // unsigned I–type ALU
                default:controls = 16'b1_000_1_0_00_000_10_0_0_0; // I–type ALU
            endcase
        end
        7'b1101111: controls = 16'b1_011_0_0_10_000_00_1_0_0; // jal
        7'b1100111: controls = 16'b1_000_1_0_10_000_00_1_1_0; // jalr
        7'b0110111: controls = 16'b1_100_1_0_00_000_00_0_0_0; // lui
        7'b0010111: controls = 16'b1_100_1_0_11_000_00_0_0_0; // auipc
        default:    controls = 16'bx_xxx_x_x_xx_xxx_xx_x_x_0; // ???
    endcase
end



assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr, unsign} = controls;

endmodule
