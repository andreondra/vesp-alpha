
module counter #(
    parameter COUNTER_LENGTH = 4
) (
    input  logic reset,
    input  logic clk,
    input  logic en,
    input  logic max,
    output logic top
);

    logic [COUNTER_LENGTH-1:0] counter;

    always_ff @(posedge clk) begin : counter_proc
        if (reset)
            counter <= 0;
        else if (en)
            counter <= counter + 1;
    end
    assign top = (counter == max);

endmodule