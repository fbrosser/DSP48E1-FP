`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:24:30 09/21/2012
// Design Name:   FPMult_ExecuteModule
// Module Name:   P:/VerilogTraining/FPMult/FPMult_ExecuteModule_tb.v
// Project Name:  FPMult
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPMult_ExecuteModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPMult_ExecuteModule_tb;

	// Inputs
	reg [23:0] Ma;
	reg [23:0] Mb;

	// Outputs
	wire [47:0] Mp;

	// Instantiate the Unit Under Test (UUT)
	FPMult_ExecuteModule uut (
		.Ma(Ma), 
		.Mb(Mb), 
		.Mp(Mp)
	);

	initial begin
		// Initialize Inputs
		Ma = 0;
		Mb = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 Ma = 24'b1000_0000_0000_0000_0000_0000; Mb = 24'b1000_0000_0000_0000_0000_0000;
		#10 Ma = 24'b1100_0000_0000_0000_0000_0000; Mb = 24'b1010_0000_0000_0000_0000_0000;
		#10 Ma = 24'b1001_0000_0000_0000_0000_0000; Mb = 24'b1001_1000_0000_0000_0000_0000;
		#10 Ma = 24'b1100_1111_0000_0111_0000_0000; Mb = 24'b1000_0000_0000_0000_0000_0000;
		#10 Ma = 24'b1100_0000_0000_0000_0000_0000; Mb = 24'b1100_0000_0000_0000_0000_0000;
		#10 $finish;
	end
      
endmodule

