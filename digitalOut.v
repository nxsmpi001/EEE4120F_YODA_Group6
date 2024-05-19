//--------------------------------------------------
// Design Name: Digital Out
// File Name : digitalOut.v
// Function : Outputs PWM signal to csv file
// Coder : Mpilo
//---------------------------------------------------
`timescale 100ns / 1ns

module DigitalOut (
    input wire clk,
    input wire in
);
    // File descriptor
    int file;
    
    initial begin
        // Open the CSV file for writing
       file = $fopen("pwm_output.csv", "a");
      
    end

    // Write pwm_out value to the CSV file on every clock cycle
    always @(posedge clk) begin
      $fwrite(file, "%0t,%b\n", $time, in);
    end

    // Close the file at the end of the simulation
    final begin
        $fclose(file);
    end
  
endmodule
