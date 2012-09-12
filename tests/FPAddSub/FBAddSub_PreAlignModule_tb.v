`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:35:57 09/12/2012
// Design Name:   FPAddSub_PreAlignModule
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FBAddSub_PreAlignModule_tb.v
// Project Name:  FPAddSub_Fred
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPAddSub_PreAlignModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FBAddSub_PreAlignModule_tb;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;

	// Outputs
	wire Sa;
	wire Sb;
	wire [7:0] Ea;
	wire [7:0] Eb;
	wire [24:0] Ma;
	wire [24:0] Mb;

	// Instantiate the Unit Under Test (UUT)
	FPAddSub_PreAlignModule uut (
		.A(A), 
		.B(B), 
		.Sa(Sa), 
		.Sb(Sb), 
		.Ea(Ea), 
		.Eb(Eb), 
		.Ma(Ma), 
		.Mb(Mb)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#10 A = 32'b0_01111111_00000000000000000000000; B = 32'b0_01111111_00000000000000000000000;
		#10 A = 32'b0_01111111_10000000000000000000000; B = 32'b0_01111111_00000000000000000000000;
		#10 A = 32'b0_10000000_00000000000000000000000; B = 32'b0_01111111_01000000000000000000000;
		#10 A = 32'b0_10000001_01000000000000000000000; B = 32'b0_01111111_11101000000000000000000;
		#10 A = 32'b0_10000000_01000100000000000000000; B = 32'b0_10001000_00000000000000000000000;
		#10 A = 32'b0_01111111_10000000000000000000000; B = 32'b0_01111111_00010000000000000000000;
		#10 A = 32'b0_10000010_00000000000000000000000; B = 32'b0_00000000_00000000000000000000000;
		#10 A = 32'b0_11000111_11000000000000000000000; B = 32'b0_00000001_00000000000000001000000;
		
	end
      
endmodule

