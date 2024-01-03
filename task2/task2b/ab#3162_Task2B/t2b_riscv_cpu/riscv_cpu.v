
// riscv_cpu.v - single-cycle RISC-V CPU Processor

module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWrite,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData
);

wire        ALUSrc, RegWrite, Jump, Zero, Jalr, CmpResult;
wire [1:0]  ResultSrc;
wire [2:0]  ImmSrc;
wire [2:0]  ALUControl;

controller  c (Instr[6:0], Instr[14:12], Instr[30], Zero, CmpResult,
                ResultSrc, MemWrite, PCSrc, ALUSrc, RegWrite, Jump,
                Jalr, unsign, ImmSrc, ALUControl);

datapath    dp (clk, reset, ResultSrc, PCSrc,
                ALUSrc, RegWrite, Jalr, unsign, ImmSrc, ALUControl,
                Zero, CmpResult, PC, Instr, Mem_WrAddr, Mem_WrData, ReadData);

endmodule
