`timescale 10ns/1ns

`define OPCODE_PASS         32'b1
`define OPCODE_FAIL         32'b0
`define PC_STOP             'ha4

module uartTopTest();
    
    reg clk, reset;
    wire tx, rx;

    top dut(
        .clk(clk),
        .reset(reset),
        .tx(tx),
        .rx(rx)
    );

    initial begin
        reset <= 0;
        #5;
        reset <= 1;
        #5;
        reset <= 0;
    end

    always begin
		clk <= 1; #1;
        clk <= 0; #1;
	end

    always @(posedge clk) begin
        if (dut.iRead === `OPCODE_PASS) begin
            $display(`ASSERT_SUCCESS);
            $finish;
        end

        if (dut.iRead === `OPCODE_FAIL) begin
            $display(`ASSERT_FAIL);
            $finish;
        end

        /* stop on certain PC for debugging purposes */
        // if (dut.cpuInst.PC === `PC_STOP) begin
        //     $display(`ASSERT_DEBUG_STOP);
        //     $finish;
        // end
    end
    
endmodule