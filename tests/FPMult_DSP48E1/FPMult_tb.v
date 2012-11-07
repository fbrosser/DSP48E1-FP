`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   06:46:52 10/31/2012
// Design Name:   FPMult
// Module Name:   P:/VerilogTrAing/FPMult_Simple_Pipe/FPMult_tb.v
// Project Name:  FPMult_Simple_Pipe
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPMult
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPMult_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] A;
	reg [31:0] B;

	// Outputs
	wire [31:0] Z;
	wire [4:0] Flags;

	// Instantiate the Unit Under Test (UUT)
	FPMult uut (
		.clk(clk), 
		.rst(rst), 
		.A(A), 
		.B(B), 
		.Z(Z), 
		.Flags(Flags)
	);

	always begin
		#5 clk = ~clk;
	end
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		A = 0;
		B = 0;

		// Wait 10 ns for global reset to finish
		#100;
        
		// Add stimulus here

		#100 A = 32'b0_01111111_00000000000000000000000000000000; B = 32'b0_01111111_00000000000000000000000000000000;
		#100 A = 32'b0_01111111_00000000000000000000000000000000; B = 32'b0_01111111_00000000000000000000000000000000;
		#100 A = 32'b0_01111111_00000000000000000000000000000000; B = 32'b0_01111111_00000000000000000000000000000000;
		#100 A = 32'b0_01111111_00000000000000000000000000000000; B = 32'b0_01111111_00000000000000000000000000000000;
		#100 A = 32'b0_01111111_00000000000000000000000000000000; B = 32'b0_01111111_00000000000000000000000000000000;
		#100 A = 32'b0_01111111_00000000000000000000000000000000; B = 32'b0_01111111_00000000000000000000000000000000;
		#100 A = 32'b0_01111111_00000000000000000000000000000000; B = 32'b0_01111111_00000000000000000000000000000000;
		#100 A = 32'b0_01111111_00000000000000000000000000000000; B = 32'b0_01111111_00000000000000000000000000000000;

		#100 $finish;

	end
      
endmodule

