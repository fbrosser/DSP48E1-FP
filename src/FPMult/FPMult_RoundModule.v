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
		NormM,
		NormE,
		G,
		R,
		S,
		RoundM,
		RoundE
    );

	// Input Ports
	input [22:0] NormM ;									// Normalized mantissa
	input [8:0] NormE ;									// Normalized exponent
	input G ;												// Guard bit
	input R ;												// Round bit
	input S ;												// Sticky bit
	
	// Output Ports
	output [22:0] RoundM ;								// Rounded mantissa
	output [8:0] RoundE ;								// Rounded exponent
	
	// Internal Signals
	wire [23:0] PreShiftM;								// Mantissa before shifting
	wire [23:0] ShiftedM ;								// The shifted mantissa
	
	assign PreShiftM = NormM + ((R&(G|S)) ? 1 : 0) ;	// Round up if R and (G or S)
	
	// Post rounding normalization (potential one bit shift)
	assign ShiftedM = PreShiftM >> 1;				// Shift mantissa right
	
	assign RoundM = (PreShiftM[23] ? ShiftedM[22:0] : PreShiftM[22:0]) ; // Use shifted mantissa if there is overflow
	assign RoundE = NormE + (PreShiftM[23] ? 1 : 0) ; // Increment exponent if a shift was done

endmodule
