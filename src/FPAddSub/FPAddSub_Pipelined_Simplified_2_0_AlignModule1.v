`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:49:36 10/16/2012 
// Module Name:    FPAddSub_Pipelined_Simplified_2_0_AlignModule1 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Shift Stage 1
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_Pipelined_Simplified_2_0_AlignModule1(
		MminP,
		Shift,
		Mmin
	);
	
	// Input ports
	input [31:0] MminP ;						// Smaller mantissa after 16|12|8|4 shift
	input [4:0] Shift ;						// Shift amount
	// Output ports
	output [31:0] Mmin ;						// The smaller mantissa
	
	reg	  [31:0]		Lvl1 = 0;

	always @(*) begin
		Lvl1 <= Shift[4] ? {16'b0, MminP[31:16]} : MminP; // rotate by 16?
	end
	
	// Assign outputs
	assign Mmin = Lvl1;						// Take out smaller mantissa				

endmodule
