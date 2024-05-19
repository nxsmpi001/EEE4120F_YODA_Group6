`timescale 100ns / 1ns

module bit_to_sfix16_En15 (
    input wire clk,
    input wire in,
    output reg signed [15:0] out
);

always @(posedge clk) begin
    if (in == 1'b0) begin
        out <= 16'b0;  // 0.000000000000000 in sfix16_En15 format
    end else begin
        out <= 16'd65535 >> 1;  // 1.000000000000000 in sfix16_En15 format
    end
end

endmodule
