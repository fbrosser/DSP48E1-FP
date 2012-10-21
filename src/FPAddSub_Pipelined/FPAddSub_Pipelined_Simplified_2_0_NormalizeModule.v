`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:05:07 09/07/2012
// Module Name:    FBAddSub_NormalizeModule
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Normalizes a given floating point number according to the
//						 IEEE754 standard.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_Pipelined_Simplified_2_0_NormalizeModule(
		Sum,
		Mmin,
		Shift
    );

	// Input ports
	input [25:0] Sum ;					// Mantissa sum including hidden 1 and GRS
	
	// Output ports
	output [25:0] Mmin ;
	output [4:0] Shift ;

	// Internal signals
	wire [25:0] PSSum ;					// The Pre-Shift-Sum
	wire MSBShift ;						// Flag indicating that a second shift is needed
	wire [8:0] ExpOF ;					// MSB set in sum indicates overflow
	wire [8:0] ExpOK ;					// MSB not set, no adjustment
	wire [4:0] Shift ;					// Amount to be shifted
	
	// Leading Nought Counter
	FPAddSub_Pipelined_Simplified_2_0_LNCModule LNCModule(Sum[25:0], Shift[4:0]) ;
	
	reg	  [25:0]		Lvl1 = 0;
	
	always @(*) begin
		Lvl1 <= Shift[4] ? {Sum[9:0], 16'b0} : Sum; // rotate by 16?
	end
	
	// Assign outputs
	assign Mmin = Lvl1;						// Take out smaller mantissa			
	

endmodule
