`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:05:07 09/07/2012
// Module Name:    FBAddSub_NormalizeModule
// Project Name: 	 CHiPES Project
// Author:			 Fredrik Brosser
//
// Description:	 Normalizes a given floating point number according to the
//						 IEEE754 standard.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_NormalizeModule(
		Sum,
		CExp,
		G,
		PS,
		Opr,
		NormM,
		NormE,
		Shift,
		R,
		S
    );

	// Input ports
	input [25:0] Sum ;					// Mantissa sum including hidden 1 and GRS
	input [7:0] CExp ;					// Preliminary common exponent
	input G ;								// Guard bit
	input PS ;								// Pre-Sticky bit
	input Opr ;								// Effective operation
	
	// Output ports
	output [22:0] NormM ;				// Normalized mantissa
	output [7:0] NormE ;					// Adjusted exponent
	output [5:0] Shift ;					// Amount shifted
	output R ;								// Round bit
	output S ;								// Final sticky bit
	
	// Internal signals
	wire [25:0] PSSum ;					// The Pre-Shift-Sum
	wire MSBShift ;						// Flag indicating that a second shift is needed
	wire [7:0] ExpOF ;					// MSB set in sum indicates overflow
	wire [7:0] ExpOK ;					// MSB not set, no adjustment
	
	// Leading Nought Counter
	FPAddSub_LNCModule LNCModule(Sum[25:0], Shift[5:0]) ;
	
	// Note that we might have to do another round of shifting
	assign PSSum = Sum << Shift ;			// Perform right shift

	assign ExpOK = CExp - Shift ;	// Adjust exponent for new normalized mantissa
	assign ExpOF = ExpOK + 1 ;		// If MSB set, add one to exponent(x2)
	assign MSBShift = PSSum[25] ;	// Check MSB in unnormalized sum
	assign NormM = PSSum[24:2] ;	// The new, normalized mantissa
	
	assign NormE = (MSBShift ? ExpOF : ExpOK) ;	// Determine final exponent
	
	// Also need to compute sticky and round bits for the rounding stage
	assign CheckNorm = (Opr & (~|Shift[4:2]) & Shift[1] & ~Shift[0]);	// Really Normalized?
	assign R = CheckNorm ? (PS^G) :(NormM[1] & ~(|Shift[4:1] & Opr)); // Round bit
	assign S = CheckNorm ? PS :(NormM[0] | G | PS);							// Set final sticky bit

endmodule
