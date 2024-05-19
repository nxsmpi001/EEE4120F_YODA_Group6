//-----------------------------------------------------
// Design Name : WaveformGenerator
// File Name : wave_gen.v
// Function : Generates sine, square and sawtooth
// Coder : Mpilo & Kudzi
//-----------------------------------------------------
`timescale 100ns / 1ns

module WaveformGenerator (
  input wire clk,
  input wire [1:0] wave_def,
  input wire [15:0] freq,
  input wire [9:0] amp,
  output reg [9:0] signal
);
  
//--------State machine definitions----------
parameter SINE        = 2'b00;
parameter SQUARE      = 2'b01;
parameter SAWTOOTH    = 2'b10;

//--------------Constants--------------------
parameter [31:0] CLKFREQ = 32'd10000000;	//clock frequency
  
//----------Internal Connections-------------
reg [31:0] clk_cycles = 0;
reg [31:0] clk_period;
reg [7:0] angle; // Angle in degrees
  
//---------------Code Start------------------
  always @(freq) begin
    clk_period = CLKFREQ/freq; //clock cycles per wave cycle
  end
  
  always @(wave_def) begin
    clk_cycles = 0;
  end

  always @(posedge clk) begin
    clk_cycles += 1;
    
    case(wave_def)
      SINE: begin
        angle = (clk_cycles * 360) / clk_period; // Convert clock cycles to degrees
        if(clk_cycles < clk_period/2)
          signal = (4 * angle * (180 - angle) * amp/2) / (40500 - angle * (180 - angle)) + amp/2; //Bhaskara I's sine approximation
        else begin
          angle = angle - 180;
          signal = -((4 * angle * (180 - angle) * amp/2) / (40500 - angle * (180 - angle))) + amp/2;
        end

      end
      SQUARE: begin
        signal = (clk_cycles < clk_period/2) ? amp : 0;
      end
      
      SAWTOOTH: begin
        signal = clk_cycles*amp/clk_period;
      end
      
    endcase
    
    if(clk_cycles >= clk_period)
      clk_cycles = 0;
      
  end
      
endmodule
