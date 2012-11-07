`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:06:19 09/20/2012
// Design Name:   FPMult_NormalizeModule
// Module Name:   P:/VerilogTraining/FPMult/FPMult_NormalizeModule_tb.v
// Project Name:  FPMult
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPMult_NormalizeModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPMult_NormalizeModule_tb;

	// Inputs
	reg [47:0] M;
	reg [8:0] E;

	// Outputs
	wire [22:0] NormM;
	wire [8:0] NormE;
	wire G;
	wire R;
	wire S;

	// Instantiate the Unit Under Test (UUT)
	FPMult_NormalizeModule uut (
		.M(M), 
		.E(E), 
		.NormM(NormM), 
		.NormE(NormE), 
		.G(G), 
		.R(R), 
		.S(S)
	);

	initial begin
		// Initialize Inputs
		M = 0;
		E = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 M = 48'b1100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; E = 8'b0000_0000;
		#10 M = 48'b0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; E = 8'b0000_0000;
		#10 M = 48'b0111_1111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; E = 8'b0000_0000;
		#10 M = 48'b1000_0100_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000; E = 8'b0000_0000;
		#10 M = 48'b0101_0000_0000_0000_0000_0000_1000_0000_0000_0000_0000_0000; E = 8'b0000_0000;
		#10 M = 48'b0100_0000_0000_0000_0000_0000_0100_0000_0000_0000_0000_0000; E = 8'b0000_0000;
		#10 M = 48'b0100_0000_0000_0000_0000_0001_0000_0000_0000_0000_0000_0000; E = 8'b0000_0000;
		#10 M = 48'b1100_0000_0000_0000_0000_0001_0100_0000_0000_0000_0000_0000; E = 8'b0000_0000;
		#10 $finish;
	end
      
endmodule

