
// datapath.v - datapath for single-cycle RISC-V CPU

module datapath (
    input         clk, reset,
    input [1:0]   ResultSrc,
    input         PCSrc, ALUSrc,
    input         RegWrite,Jalr, unsign,
    input [2:0]   ImmSrc,
    input [2:0]   ALUControl,
    output        Zero, CmpResult,
    output [31:0] PC,
    input [31:0]  Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input [31:0]  ReadData
);

wire [31:0] PCNext, PCPlus4, PCTarget,PCNextTemp;
wire [31:0] ImmExt, SrcA, SrcB, Result, WriteData, ALUResult;
wire [31:0] auipcResult,ReadDataExt;
// wire [31:0] upimm = {Instr[31:12], 12'b0};

// next PC logic
reset_ff #(32) pcreg(clk, reset, PCNext, PC);
adder          pcadd4(PC, 32'd4, PCPlus4);
adder          pcaddbranch(PC, ImmExt, PCTarget);
mux2 #(32)     pcmux(PCPlus4, PCTarget, PCSrc, PCNextTemp);
mux2 #(32)     jalrmux(PCNextTemp, ALUResult, Jalr, PCNext);

// register file logic
reg_file       rf (clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, SrcA, WriteData);
sign_extend    ext (Instr[31:7], ImmSrc, ImmExt);

// ALU logic
mux2 #(32)      srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
alu             alu (SrcA, SrcB, ALUControl, Instr[30], unsign, ALUResult, Zero);
mux4 #(32)      resultmux(ALUResult, ReadDataExt, PCPlus4,auipcResult, ResultSrc, Result);

//load logic
sgn_zero_extend sgn_ext(ReadData,Instr[14:12] ,ReadDataExt);

// store logic
store_extend   store_ext(WriteData, Instr[13:12], Mem_WrData);

// auiPC logic
adder          auipc(PC,ImmExt, auipcResult);


assign CmpResult = ALUResult[0];

// assign Mem_WrData = WriteData;
assign Mem_WrAddr = ALUResult;

endmodule
