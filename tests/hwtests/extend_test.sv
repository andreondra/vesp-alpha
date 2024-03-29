`include "rtl/components/extend.sv"
`include "rtl/constants.vh"

module extend_test();
	logic uext;
    logic [7:0] data8;
    logic [15:0] data16;
    logic [31:0] res8, res16;

	module_extend #(8, 32) ext8_32
    (
        .data(data8),
        .uext(uext),
        .res(res8)
    );
    module_extend #(16, 32) ext16_32
    (
        .data(data16),
        .uext(uext),
        .res(res16)
    );

	initial begin
        #2;
        data8 = 8'b00001111;
        data16 = data8;
        uext = 1;

		#2;
        data8 = 8'b00001111;
        data16 = data8;
        uext = 0;

        #2;
        data8 = 8'b10001111;
        data16 = { data8[7:4], 8'b0, data8[3:0] };
        uext = 1;

        #2;
        data8 = 8'b10001111;
        data16 = { data8[7:4], 8'b0, data8[3:0] };
        uext = 0;

		#1; $display(`ASSERT_SUCCESS); $finish;
	end

	always @ (*) #1 $display ("data8=%b, uext=%b, res8=%b\ndata16=%b, uext=%b, res16=%b\n", data8, uext, res8, data16, uext, res16);

endmodule