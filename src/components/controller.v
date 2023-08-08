module controller (
    input      [31:0] instruction,
    input      [31:0] memAddr,
    input             ALUZero,
    output reg [3:0]  ALUCtrl,
    output reg        ALUImm,
    output reg        ALUToPC,
    output reg        branch,
    output reg [1:0]  loadSel,
    output reg [1:0]  maskSel,
    output reg        memToReg,
    output reg        memWr,
    output reg [1:0]  regDataSel,
    output reg        regWr,
    output reg        rs2ShiftSel,
    output reg        uext
);

    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];
    wire [4:0] rs1    = instruction[19:15];
    wire [4:0] rs2    = instruction[24:20];
    wire [4:0] rd     = instruction[11:7];
    wire [6:0] opcode = instruction[6:0];
    wire [31:0] imm;

    // decode instructions and set control signals
    always @(*) begin
        // init control signals to default values
        ALUCtrl     = 0;
        ALUImm      = 0;
        ALUToPC     = 0;
        branch      = 0;
        loadSel     = funct3[1:0];
        maskSel     = funct3[1:0];
        memToReg    = 0;
        memWr       = 0;
        regDataSel  = 0;
        regWr       = 0;
        rs2ShiftSel = funct3[0];
        uext        = funct3[2];

        casez (opcode[6:2]) // omit the lowest two bits of opcode - they are always 11
            5'b01100: begin // R-type
                // set matching signals
                regWr = 1;

                case (funct3)
                    3'b000: ALUCtrl = {3'b000, funct7[5]}; // ADD or SUB
                    3'b001: ALUCtrl = 4'b0101; // SLL
                    3'b010: ALUCtrl = 4'b1000; // SLT
                    3'b011: ALUCtrl = 4'b1001; // SLTU
                    3'b100: ALUCtrl = 4'b0100; // XOR
                    3'b101: ALUCtrl = {3'b011, funct7[5]}; // SRA or SRL
                    3'b110: ALUCtrl = 4'b0011; // OR
                    3'b111: ALUCtrl = 4'b0010; // AND
                endcase
            end
            
            5'b00x00: begin // I-type without JALR
                // set matching signals
                ALUImm = 1;
                regWr  = 1;

                if (opcode[4]) begin // immediate register-register
                    case (funct3)
                        3'b001: ALUCtrl = 4'b0101; // SLLI
                        3'b010: ALUCtrl = 4'b1000; // SLTI
                        3'b011: ALUCtrl = 4'b1001; // SLTIU
                        3'b100: ALUCtrl = 4'b0100; // XORI
                        3'b101: ALUCtrl = {3'b011, funct7[5]}; // SRAI or SRLI
                        3'b110: ALUCtrl = 4'b0011; // ORI
                        3'b111: ALUCtrl = 4'b0010; // ANDI
                    endcase
                end else begin // memory-register
                    memToReg = 1;
                end
            end

            5'b11001: begin // JALR
                ALUImm     = 1;
                ALUToPC    = 1;
                branch     = 1;
                regDataSel = 2'b11;
                regWr      = 1;
            end

            5'b01000: begin // S-type
                ALUImm = 1;
                memWr  = 1;
            end

            5'b11000: begin // B-type
                case (funct3)
                    3'b000: begin // BEQ
                        ALUCtrl = 4'b0001;
                        branch  = ALUZero;
                    end
                    3'b001: begin // BNE
                        ALUCtrl = 4'b0001;
                        branch  = ~ALUZero;
                    end
                    3'b100: begin // BLT
                        ALUCtrl = 4'b1000;
                        branch  = ~ALUZero;
                    end
                    3'b101: begin // BGE
                        ALUCtrl = 4'b1000;
                        branch  = ALUZero;
                    end
                    3'b110: begin // BLTU
                        ALUCtrl = 4'b1001;
                        branch  = ~ALUZero;
                    end
                    3'b111: begin // BGEU
                        ALUCtrl = 4'b1001;
                        branch  = ALUZero;
                    end
                endcase
            end

            5'b0x101: begin // U-type
                regDataSel = opcode[5] ? 2'b10 : 2'b01;
                regWr      = 1;
            end

            5'b11011: begin // J-type
                branch     = 1;
                regDataSel = 2'b11;
                regWr      = 1;
            end

            5'b00011: begin end // FENCE or Zifencei standard extension

            5'b11100: begin // ECALL, EBREAK or Zicsr standard extension
                case (funct3)
                    3'b000: begin end // ECALL or EBREAK
                endcase
            end
        endcase
    end

endmodule