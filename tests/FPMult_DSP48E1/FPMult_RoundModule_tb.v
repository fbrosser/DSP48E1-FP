`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:12:39 09/21/2012
// Design Name:   FPMult_RoundModule
// Module Name:   P:/VerilogTraining/FPMult/FPMult_RoundModule_tb.v
// Project Name:  FPMult
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPMult_RoundModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPMult_RoundModule_tb;

	// Inputs
	reg [22:0] NormM;
	reg [8:0] NormE;
	reg G;
	reg R;
	reg S;

	// Outputs
	wire [22:0] RoundM;
	wire [8:0] RoundE;

	// Instantiate the Unit Under Test (UUT)
	FPMult_RoundModule uut (
		.NormM(NormM), 
		.NormE(NormE), 
		.G(G), 
		.R(R), 
		.S(S), 
		.RoundM(RoundM), 
		.RoundE(RoundE)
	);

	initial begin
		// Initialize Inputs
		NormM = 0;
		NormE = 0;
		G = 0;
		R = 0;
		S = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 NormM = 48'b1100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0111; NormE = 8'b1000_0000; G = 0; R = 0; S = 0;
		#10 NormM = 48'b0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0001; NormE = 8'b1000_0000; G = 0; R = 0; S = 0;
		#10 NormM = 48'b0111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_1000; NormE = 8'b1000_0000; G = 0; R = 0; S = 0;
		#10 NormM = 48'b1000_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_1000; NormE = 8'b1000_0000; G = 0; R = 0; S = 0;
		#10 NormM = 48'b0101_0000_0000_0000_0000_0000_1000_0000_0000_0000_0000_1111; NormE = 8'b1000_0000; G = 0; R = 0; S = 1;
		#10 NormM = 48'b0100_0000_0000_0000_0000_0000_0100_0000_0000_0000_0000_1111; NormE = 8'b1000_0000; G = 0; R = 1; S = 0;
		#10 NormM = 48'b0100_0000_0000_0000_0000_0001_0000_0000_0000_0000_0000_1111; NormE = 8'b1000_0000; G = 1; R = 0; S = 0;
		#10 NormM = 48'b1100_0000_0000_0000_0000_0001_0100_0000_0000_0000_0000_1111; NormE = 8'b1000_0000; G = 0; R = 1; S = 1;
		#10 $finish;
	end
      
endmodule

