`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:19:26 09/21/2012
// Design Name:   FPMult_PrepModule
// Module Name:   P:/VerilogTraining/FPMult/FBMult_PrepModule_tb.v
// Project Name:  FPMult
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPMult_PrepModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FBMult_PrepModule_tb;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;

	// Outputs
	wire Sa;
	wire Sb;
	wire [7:0] Ea;
	wire [7:0] Eb;
	wire [23:0] Ma;
	wire [23:0] Mb;
	wire [6:0] InputExc;

	// Instantiate the Unit Under Test (UUT)
	FPMult_PrepModule uut (
		.A(A), 
		.B(B), 
		.Sa(Sa), 
		.Sb(Sb), 
		.Ea(Ea), 
		.Eb(Eb), 
		.Ma(Ma), 
		.Mb(Mb), 
		.InputExc(InputExc)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 A = 32'b0__1000_0000__0100_0000_0000_0000_0000_000; B = 32'b0__1000_0001__0011_0000_0000_0000_0000_000;
		#10 A = 32'b0__0111_1111__0000_0000_0000_0000_0000_000; B = 32'b0__0111_1111__0000_0000_0000_0000_0000_000;
		#10 A = 32'b0__1000_0000__1000_0000_0000_0000_0000_000; B = 32'b0__1000_0000__0000_0000_0000_0000_0000_000;
		#10 A = 32'b0__1000_0000__1000_0000_0000_0000_0000_000; B = 32'b1__1000_0000__0000_0000_0000_0000_0000_000;
		#10 $finish;
	end
      
endmodule

