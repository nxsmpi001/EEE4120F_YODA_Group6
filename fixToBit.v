`timescale 100ns / 1ns

module sfix36_En35_to_10bit (
    input wire clk,
    input wire signed [35:0] sfix36_En35_in,
    output reg [9:0] int_out
);

always @(posedge clk) begin
    // Multiplying by 1023 (1023 = 2^10 - 1)
    reg signed [45:0] intermediate_result;
    intermediate_result = (sfix36_En35_in <<< 10) - sfix36_En35_in;

    // Extracting the 10-bit integer part 
  int_out <= intermediate_result[45:36];
end

endmodule
