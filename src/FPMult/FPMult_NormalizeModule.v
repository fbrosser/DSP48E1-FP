`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    12:47:06 09/20/2012 
// Module Name:    FPMult_NormalizeModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult_NormalizeModule(
		M,
		E,
		NormM,
		NormE,
		G,
		R,
		S
    );

	// Input ports
	input [47:0] M ;													// Unnormalized mantissa
	input [8:0] E ;													// Unnormalized exponent
	
	// Output ports
	output [22:0] NormM ;											// Normalized mantissa
	output [8:0] NormE ;												// Normalized exponent
	output G ;															// Guard bit (M0)
	output R ;															// Round bit
	output S ;															// Sticky bit
	
	// Internal signals
	wire [47:0] ShiftedM ;											// The shifted mantissa
	
	assign ShiftedM = M >> 1 ;										// Perform right shift
	assign NormM = (M[47] ? ShiftedM[45:23] : M [45:23]); // Check for overflow
	assign NormE = E + (M[47] ? 1 : 0) ;						// If so, increment exponent
	
	assign G =  M[24] ;												// Pick out guard bit
	assign R =  M[23] ;												// Round bit (at cutoff)
	assign S = |M[22:0] ;											// Sticky, OR of all the cutoff bits

endmodule
