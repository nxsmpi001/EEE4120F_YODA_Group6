`timescale 100ns / 1ns

module integrated_sys_tb;
  // Signals
  reg clk;
  reg [1:0] wave_def;
  reg [15:0] freq;
  reg [9:0] amp;
  wire [9:0] signal;
  wire pwm_out;

  // Instantiate the wave_gen DUT
  WaveformGenerator waveDUT (
    .clk(clk),
    .wave_def(wave_def),
    .freq(freq),
    .amp(amp),
    .signal(signal)
  );

  // Instantiate the PWM_gen DUT
  PWM_Generator pwmDUT (
    .clk(clk), 
    .value(signal), 
    .pwm_out(pwm_out)
  );

  // Instantiate the CSVWriter
  DigitalOut outDUT (
    .clk(clk),
    .in(pwm_out)
  );

  // Clock generation
  always #0.5 clk = ~clk;
  
  // Stimulus
  initial begin
     $dumpfile("integrated_sys_tb.vcd");
     $dumpvars(0, integrated_sys_tb);
    
    // Initialize inputs
    clk = 0;
    wave_def = 2'b00; // SINE
    freq = 16'd2000; // 2kHz
    amp = 10'd1023; // 1023
    #5000 $finish; // Stop simulation after 2500 time units
  end

  // Monitor
  always @(posedge clk) begin
//    $display("Time = %t, clk = %b, wave_def = %b, freq = %d, amp = %d, signal = %d, pwm_out = %b",
//              $time, clk, wave_def, freq, amp, signal, pwm_out);
  end
  
endmodule
