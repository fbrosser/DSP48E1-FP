`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
//
// Create Date:   11:44:26 09/05/2012
// Design Name:   FPAddSub_AlignModule
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FBAddSub_AlignModule_tb.v
// Project Name:  FPAddSub_Fred
//
// Verilog Test Fixture created by ISE for module: FPAddSub_AlignModule
// 
////////////////////////////////////////////////////////////////////////////////

module FPAddSub_AlignModule_tb;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;

	// Outputs
	wire [7:0] Exp;
	wire [24:0] Mmax;
	wire [24:0] Mmin;
	wire G ;
	wire R ;
	wire S ;
	wire MaxAB;
	
	// Instantiate the Unit Under Test (UUT)
	FPAddSub_AlignModule uut (
		.A(A), 
		.B(B), 
		.Exp(Exp), 
		.Mmax(Mmax), 
		.Mmin(Mmin),
		.G(G),
		.R(R),
		.S(S),
		.MaxAB(MaxAB)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 A = 32'b0_01111111_00000000000000000000000; B = 32'b0_01111111_00000000000000000000000;
		#10 A = 32'b0_01111111_10000000000000000000000; B = 32'b0_01111111_00000000000000000000000;
		#10 A = 32'b0_10000000_00000000000000000000000; B = 32'b0_01111111_01000000000000000000000;
		#10 A = 32'b0_10000001_01000000000000000000000; B = 32'b0_01111111_11101000000000000000000;
		#10 A = 32'b0_10000000_01000100000000000000000; B = 32'b0_10001000_00000000000000000000000;
		#10 A = 32'b0_01111111_10000000000000000000000; B = 32'b0_01111111_00010000000000000000000;
		#10 A = 32'b0_10000010_00000000000000000000000; B = 32'b0_00000000_00000000000000000000000;
		#10 A = 32'b0_11000111_11000000000000000000000; B = 32'b0_00000001_00000000000000001000000;
		#10 $finish;
		
	end
      
endmodule

