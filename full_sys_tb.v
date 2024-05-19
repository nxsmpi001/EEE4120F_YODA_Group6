`timescale 100ns / 1ns

module integrated_sys_tb;
   // File descriptor
  int fp;
  
  // Signals
  reg clk;
  reg clk_enable;
  reg reset;
  reg [1:0] wave_def;
  reg [15:0] freq;
  reg [9:0] amp;
  wire [9:0] signal;
  wire pwm_out;
  wire signed [15:0] filter_in; // sfix16_En15
  wire signed [35:0] filter_out; // sfix36_En35
  wire signed [15:0] pwm_fixed_point;
  wire [9:0] int_out;

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

  // Instantiate the module that converts pwm_out to fixed-point
  bit_to_sfix16_En15 pwmToFixedPoint (
    .clk(clk),
    .in(pwm_out),
    .out(pwm_fixed_point)
  );

  // Instantiate the new filter module
  LowPass filterDUT  (
    .clk(clk),
    .clk_enable(clk_enable),
    .reset(reset),
    .filter_in(pwm_fixed_point),
    .filter_out(filter_out)
  );

  // Instantiate the module that multiplies filter_out by 1023 and converts to 10-bit integer
  sfix36_En35_to_10bit multTo10bit (
    .clk(clk),
    .sfix36_En35_in(filter_out),
    .int_out(int_out)
  );

  // Clock generation
  always #0.5 clk = ~clk;
  
  // Stimulus
  initial begin
    // Open csv file
    fp = $fopen("filter_out.csv","a");
    
    $dumpfile("full_sys_tb.vcd");
    $dumpvars(0, clk);
    $dumpvars(0, wave_def);
    $dumpvars(0, freq);
    $dumpvars(0, amp);
    $dumpvars(0, signal);
    $dumpvars(0, pwm_out);
    $dumpvars(0, pwm_fixed_point);
    $dumpvars(0, filter_out);
    $dumpvars(0, int_out);
    
    // Initialize inputs
    clk = 0;
    clk_enable = 1;
    reset = 0; // Active high reset
    wave_def = 2'b00; // SINE
    freq = 16'd2000; // 2kHz
    amp = 10'd1023; // 511
    
    #5000 $finish; // Stop simulation after 5000 time units
  end
  
  always @(posedge clk) begin
    $fwrite(fp, "%0t,%d\n", $time, int_out);
  end
  
  // Close the file at the end of the simulation
  final begin
    $fclose(fp);
  end
  
endmodule
