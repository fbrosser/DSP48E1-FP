`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    11:33:28 09/11/2012 
// Module Name:    FPAddSub_RoundModule 
// Project Name: 	 CHiPES Project
// Author:			 Fredrik Brosser
//
// Description:	 Rounding a normalized floating point number according to 
//							user specified rounding mode and G,R,S bits from earlier stages.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_RoundModule(
		Sgn,
		NormE,
		NormM,
		R,
		S,
		RoundMode,
		Z,
		Inexact
    );

	// Input ports
	input Sgn ;							// Final sign
	input [7:0] NormE ;				// Normalized exponent
	input [22:0] NormM ;				// Normalized mantissa
	input R ;							// Round bit
	input S ;							// Sticky bit
	input [1:0] RoundMode ;			// Rounding mode (according to IEEE754)
											// 00 - Even rounding (nearest even)
											// 01 - Round up (towards +inf)
											// 10 - Symmetric rounding (towards +/- 0)
											// 11 - Round down (towards -inf)
	
	// Output ports
	output [31:0] Z ;					// Final result
	output Inexact ;					// Flag indicating inexact result due to rounding
	
	// Internal signals
	wire [23:0] RoundUpM ;			// Rounded up sum with room for overflow
	wire [22:0] RoundM ;				// The final rounded sum
	wire RoundUp ;						// Flag indicating that the sum should be rounded up
	wire RoundOF ;						// Flag indicating that the rounding caused overflow
	wire ExpAdd ;						// May have to add 1 to compensate for overflow 
	wire [7:0] Exp ;					// The final exponent
	
	// The cases and rounding modes where we need to round upwards (adding one)
	assign RoundUp = 	(RoundMode == 2'b00 & R & (S | NormM[0])) |	// Round to even number
						   (RoundMode == 2'b01 & (R | S) & ~Sgn) |	// Round upwards
							(RoundMode == 2'b11 & (R | S) & Sgn)  ;	// Round downwards
	// Note that in the other cases (rounding down), the sum is already 'rounded'
	
	assign Inexact = (R | S);				// Lost information in shifted out bits, result inexact
	
	assign RoundUpM = (NormM + 1) ;		// The sum, rounded up by 1
	assign RoundOF = RoundUp & RoundUpM[23] ; // Check for overflow when rounding up
	assign RoundM = (RoundUp ? RoundUpM[22:0] : NormM) ; // Compute final mantissa
	
	assign ExpAdd = (RoundOF ? 1 : 0) ; // Add 1 to exponent to compensate for overflow
	assign Exp = (NormE + ExpAdd) ; 		// Final exponent
	
	assign Z = {Sgn, Exp[7:0], RoundM[22:0]} ;	// Put pieces together to form final result
	
endmodule
