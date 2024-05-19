`timescale 100ns / 1ns

module WaveGen_tb;
  // File descriptor
  int fp;
  
  // Signals
  reg clk;
  reg [1:0] wave_def;
  reg [15:0] freq;
  reg [9:0] amp;
  wire [9:0] signal;

  // Instantiate the DUT
  WaveformGenerator DUT (
    .clk(clk),
    .wave_def(wave_def),
    .freq(freq),
    .amp(amp),
    .signal(signal)
  );

  // Clock generation
  always #0.5 clk = ~clk;

  // Stimulus
  initial begin
    // Open csv file
    fp = $fopen("signal.csv","a");
    
    // For signal waveforms
    $dumpfile("WaveGen_tb.vcd");
    $dumpvars(0, WaveGen_tb);
    
    // Initialize inputs
    clk = 0;
    wave_def = 2'b01; // SQUARE
    freq = 16'd20000; // 20kHz
    amp = 10'd256; // 256
    #1000 
    freq = 16'd10000; // After 100us change to 10kHz
    amp = 10'd1023; // 256
	#1500 
    wave_def = 2'b10; // After 150us change to SAWTOOTH
    #2500 
    $finish; // Stop simulation at 500 us
  end

  // Monitor
  always @(posedge clk) begin
  //  $display("Time = %t, clk = %b, Signal = %d", $time, clk,signal);
    $fwrite(fp, "%0t,%d\n", $time, signal);
  end
  
  // Close the file at the end of the simulation
  final begin
    $fclose(fp);
  end

endmodule
