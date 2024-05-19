//--------------------------------------------------
// Design Name: PWM Generator
// File Name : PWM_gen.v
// Function : Creates pwm signal from generated waves
// Coder : Nathanael
//---------------------------------------------------
`timescale 100ns / 1ns

module PWM_Generator (
    input wire clk,
    input wire [9:0] value,  // 10-bit input signal
    output reg pwm_out
);
//--------------Constants--------------------
parameter [31:0] CLKFREQ = 32'd10000000;	//clock frequency	
parameter [31:0] FREQ = 32'd200000;			//PWM frequency

//----------Internal Connections-------------
reg [7:0] clk_cycles = 0;
reg [7:0] clk_period = CLKFREQ/FREQ;
reg [7:0] clk_on;
//---------------Code Start------------------
  always @(value) begin
    clk_on = value*clk_period/1023;
  end
  
  always @(posedge clk) begin
    clk_cycles += 1;
    
    pwm_out = (clk_cycles < clk_on) ? 1 : 0;
    
    if(clk_cycles >= clk_period)
      clk_cycles = 0;
      
  end
  
  
  
endmodule