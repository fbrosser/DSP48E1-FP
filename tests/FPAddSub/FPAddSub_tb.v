`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:00:37 09/10/2012
// Design Name:   FPAddSub
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FPAddSub_tb.v
// Project Name:  FPAddSub_Fred
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPAddSub
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPAddSub_tb;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg [2:0] Ctrl ;

	// Outputs
	wire [31:0] Z;
	wire [4:0] Flags;

	// Instantiate the Unit Under Test (UUT)
	FPAddSub uut (
		.A(A), 
		.B(B), 
		.Ctrl(Ctrl),
		.Z(Z),
		.Flags(Flags)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		Ctrl = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 A = 32'b0_01111111_00000000000000000000000; B = 32'b0_01111111_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_10000000_10000000000000000000000; B = 32'b0_01111111_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_01111111_10000000000000000000000; B = 32'b0_01111111_01000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_01111111_10000000000000000000000; B = 32'b0_01111111_10000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_01111111_10000000000000000000000; B = 32'b1_01111111_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_10000001_01100000000000000000000; B = 32'b0_01111110_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_10000001_01000000000000000000000; B = 32'b0_10000001_10000000000000000000000; Ctrl = 3'b001;
		#10 A = 32'b0_01111111_00000000000000000000000; B = 32'b0_01111111_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_01111111_00000000000000000000000; B = 32'b0_01111111_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_01111111_00000000000000000000000; B = 32'b0_01111111_00000000000000000000000; Ctrl = 3'b000;
		#10 $finish;
		
	end
      
endmodule
