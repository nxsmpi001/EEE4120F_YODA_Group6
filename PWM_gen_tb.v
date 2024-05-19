`timescale 100ns / 1ns

module PWM_gen_tb;

    // Inputs
    reg clk;
    reg [9:0] value;

    // Outputs
    wire pwm_out;

    // Instantiate the Unit Under Test (UUT)
    PWM_Generator uut (
        .clk(clk), 
        .value(value), 
        .pwm_out(pwm_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #0.5 clk = ~clk; // 100ns period clock => 10MHz clock
    end

    // Test sequence
    initial begin
      	$dumpfile("PWM_gen_tb.vcd");
     	$dumpvars(0, PWM_gen_tb);
      
        // Initialize Inputs
        value = 0;

        // Wait for global reset
        #500;

        // Apply test values
        value = 10'd0;  // 0% duty cycle
        #500;
      
      	value = 10'd256; // 25% duty cycle
        #500;

        value = 10'd512; // 50% duty cycle
        #500;
      
      	value = 10'd768; // 75% duty cycle
        #500;

        value = 10'd1023; // 100% duty cycle
        #500;
      
        // Finish simulation
        $finish;
    end

    // Monitor outputs
  	always @(posedge clk) begin
    //    $display("Time = %t, value = %d, pwm_out = %b", $time, value, pwm_out);
    end

endmodule
