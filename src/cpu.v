`include "constants.vh"
`include "components/controller.v"
`include "components/alu.v"
`include "components/immDecoder.v"
`include "components/registerFile32.v"
`include "components/extend.v"

module cpu (
    input             clk,
    input             reset,
    input      [31:0] instruction,
    input      [31:0] memOut,
    output            memWr,  // write enable to data memory
    output            except, // exception TODO: type of exception
    output     [3:0]  wrMask,
    output reg [31:0] PC,
    output     [31:0] memAddr,
    output     [31:0] memIn
);

    // wire/reg declarations
    wire nextPC, ALUZero, ALUImm, ALUToPC, branch, branchTarget,
         memToReg, regWr, rs2ShiftSel, uext, PC4, immPC;
    wire [1:0] loadSel, maskSel, regDataSel;
    wire [3:0] ALUCtrl;
    wire [4:0] rs2Shift;
    wire [15:0] dataLH;
    wire [31:0] src1, src2, rs1, rs2, ALURes, imm, regRes, dataExtLB,
                dataExtLH;
    reg [3:0] mask;
    reg [7:0] dataLB;
    reg [31:0] regData, memData;

    // module instantiations
    controller ctrler (instruction,
                       memAddr,
                       ALUZero,
                       ALUCtrl,
                       ALUImm,
                       ALUToPC,
                       branch,
                       loadSel,
                       maskSel,
                       memToReg,
                       memWr,
                       regDataSel,
                       regWr,
                       rs2ShiftSel,
                       uext);

    alu #(`XLEN) ALU (src1, src2, ALUCtrl, ALUZero, ALURes);

    immDecoder immDcder (instruction, imm);

    registerFile32 #(`XLEN) regfile (instruction[19:15],
                                     instruction[24:20],
                                     instruction[11:7],
                                     regRes,
                                     regWr,
                                     clk,
                                     rs1,
                                     rs2);

    extend #(8, `XLEN) ext8to32 (dataLB, uext, dataExtLB);

    extend #(16, `XLEN) ext16to32 (dataLH, uext, dataExtLH);

    // assignments (including 1bit muxes)
    assign PC4 = PC + 4;
    assign immPC = imm + PC;
    assign branchTarget = ALUToPC ? ALURes : immPC;
    assign nextPC = branch ? branchTarget : PC4;
    assign src1 = rs1;
    assign src2 = ALUImm ? imm : rs2;
    assign rs2Shift = rs2ShiftSel ? {ALURes[1], 4'b0} : {ALURes[1:0], 3'b0};
    assign memIn = rs2 << rs2Shift;
    assign memAddr = ALURes;
    assign wrMask = mask << ALURes[1:0];
    assign dataLH = ALURes[1] ? memOut[31:16] : memOut[15:0];
    assign regRes = memToReg ? memData : regData;

    // PCREG
    always @(posedge clk) begin
        if (reset) begin
            PC <= 0;
        end else begin
            PC <= nextPC;
        end
    end

    // maskSel mux
    always @(*) begin
        case (maskSel)
            2'b00:   mask = 4'b0001;
            2'b01:   mask = 4'b0011;
            default: mask = 4'b1111;
        endcase
    end

    // regDataSel mux
    always @(*) begin
        case (regDataSel)
            2'b00:   regData = ALURes;
            2'b01:   regData = immPC;
            2'b10:   regData = imm;
            default: regData = PC4;
        endcase
    end

    // dataLB mux
    always @(*) begin
        case (ALURes[1:0])
            2'b00:   dataLB = memOut[7:0];
            2'b01:   dataLB = memOut[15:8];
            2'b10:   dataLB = memOut[23:16];
            default: dataLB = memOut[31:24];
        endcase
    end

    // loadSel mux
    always @(*) begin
        case (loadSel)
            2'b00:   memData = dataExtLB;
            2'b01:   memData = dataExtLH;
            default: memData = memOut;
        endcase
    end

endmodule