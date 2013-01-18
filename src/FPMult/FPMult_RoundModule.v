`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    17:14:54 09/20/2012 
// Module Name:    FPMult_RoundModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult_RoundModule(
		RoundM,
		RoundMP,
		RoundE,
		RoundEP,
		Sp,
		GRS,
		InputExc,
		Z,
		Flags
    );

	// Input Ports
	input [23:0] RoundM ;									// Normalized mantissa
	input [23:0] RoundMP ;									// Normalized exponent
	input [8:0] RoundE ;									// Normalized mantissa + 1
	input [8:0] RoundEP ;									// Normalized exponent + 1
	input Sp ;												// Product sign
	input GRS ;
	input [4:0] InputExc ;
	
	// Output Ports
	output [31:0] Z ;										// Final product
	output [4:0] Flags ;
	
	// Internal Signals
	wire [8:0] FinalE ;									// Rounded exponent
	wire [23:0] FinalM;
	wire [23:0] PreShiftM;
	
	assign PreShiftM = GRS ? RoundMP : RoundM ;	// Round up if R and (G or S)
	
	// Post rounding normalization (potential one bit shift> use shifted mantissa if there is overflow)
	assign FinalM = (PreShiftM[23] ? {1'b0, PreShiftM[23:1]} : PreShiftM[23:0]) ;
	
	assign FinalE = (PreShiftM[23] ? RoundEP : RoundE) ; // Increment exponent if a shift was done
	
	assign Z = {Sp, FinalE[7:0], FinalM[22:0]} ;   // Putting the pieces together
	assign Flags = InputExc[4:0];

endmodule
