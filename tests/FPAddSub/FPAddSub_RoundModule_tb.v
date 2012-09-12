`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:32:51 09/12/2012
// Design Name:   FPAddSub_RoundModule
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FPAddSub_RoundModule_tb.v
// Project Name:  FPAddSub_Fred
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPAddSub_RoundModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPAddSub_RoundModule_tb;

	// Inputs
	reg Sgn;
	reg [7:0] NormE;
	reg [22:0] NormM;
	reg R;
	reg S;
	reg [1:0] RoundMode;

	// Outputs
	wire [31:0] Z;
	wire Inexact;

	// Instantiate the Unit Under Test (UUT)
	FPAddSub_RoundModule uut (
		.Sgn(Sgn), 
		.NormE(NormE), 
		.NormM(NormM), 
		.R(R), 
		.S(S), 
		.RoundMode(RoundMode), 
		.Z(Z), 
		.Inexact(Inexact)
	);

	initial begin
		// Initialize Inputs
		Sgn = 0;
		NormE = 0;
		NormM = 0;
		R = 0;
		S = 0;
		RoundMode = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

