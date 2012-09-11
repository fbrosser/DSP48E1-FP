`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:58:42 09/07/2012
// Design Name:   FPAddSub_NormalizeModule
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FPAddSub_NormalizeModule_tb.v
// Project Name:  FPAddSub_Fred
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPAddSub_NormalizeModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPAddSub_NormalizeModule_tb;

	// Inputs
	reg [25:0] M;
	reg [7:0] E;
	reg S;

	// Outputs
	wire [31:0] Z;

	// Instantiate the Unit Under Test (UUT)
	FPAddSub_NormalizeModule uut (
		.M(M), 
		.E(E), 
		.S(S), 
		.Z(Z)
	);

	initial begin
		// Initialize Inputs
		M = 0;
		E = 0;
		S = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

