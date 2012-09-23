`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:36:27 09/21/2012
// Design Name:   FPMult_ExceptionModule
// Module Name:   P:/VerilogTraining/FPMult/FPMult_ExceptionModule_tb.v
// Project Name:  FPMult
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPMult_ExceptionModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPMult_ExceptionModule_tb;

	// Inputs
	reg [22:0] RoundM;
	reg [8:0] RoundE;
	reg Sgn;

	// Outputs
	wire [31:0] P;

	// Instantiate the Unit Under Test (UUT)
	FPMult_ExceptionModule uut (
		.RoundM(RoundM), 
		.RoundE(RoundE), 
		.Sgn(Sgn), 
		.P(P)
	);

	initial begin
		// Initialize Inputs
		RoundM = 0;
		RoundE = 0;
		Sgn = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 Sgn = 1'b0; RoundE = 8'b1000_0000; RoundM = 23'b100_0000_0000_0000_0000_0000;
		#10 Sgn = 1'b0; RoundE = 8'b0111_1111; RoundM = 23'b110_0000_0000_0000_0000_0000;
		#10 Sgn = 1'b1; RoundE = 8'b0111_1111; RoundM = 23'b110_0000_0110_0110_0000_0000;
		#10 Sgn = 1'b0; RoundE = 8'b1000_0011; RoundM = 23'b000_0000_0010_0000_0000_0000;
		#10 Sgn = 1'b0; RoundE = 8'b0010_0001; RoundM = 23'b111_0000_0000_1111_0000_0011;
		#10 $finish;
	end
      
endmodule

