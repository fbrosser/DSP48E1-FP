`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    11:33:28 09/11/2012 
// Module Name:    FPAddSub_RoundModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Rounding a normalized floating point number according to 
//							user specified rounding mode and G,R,S bits from earlier stages.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_Pipelines_Simplified_2_0_RoundModule(
		ZeroSum,
		Sgn,
		NegE,
		NormE,
		NormM,
		R,
		S,
		Sa,
		Sb,
		InputExc,
		Ctrl,
		MaxAB,
		Z,
		Flags
    );

	// Input ports
	input ZeroSum ;					// Sum is zero
	input Sgn ;							// Final sign
	input NegE ;						// Negative exponent?
	input [8:0] NormE ;				// Normalized exponent
	input [22:0] NormM ;				// Normalized mantissa
	input R ;							// Round bit
	input S ;							// Sticky bit
	input Sa ;							// A's sign bit
	input Sb ;							// B's sign bit
	input [4:0] InputExc ;			// Exceptions in inputs A and B
	input Ctrl ;						// Control bit (operation)
	input MaxAB ;
	
	output [31:0] Z ;					// Final result
	output [4:0] Flags ;				// Exception flags
	
	// Internal signals
	wire [23:0] RoundUpM ;			// Rounded up sum with room for overflow
	wire [22:0] RoundM ;				// The final rounded sum
	wire [8:0] RoundE ;				// Rounded exponent (note extra bit due to poential overflow	)
	wire RoundUp ;						// Flag indicating that the sum should be rounded up
	wire ExpAdd ;						// May have to add 1 to compensate for overflow 
	wire RoundOF ;						// Rounding overflow
	
	// The cases where we need to round upwards (= adding one) in Round to nearest, tie to even
	assign RoundUp = 	(R & (S | NormM[0])) ;
	
	// Note that in the other cases (rounding down), the sum is already 'rounded'
	assign RoundUpM = (NormM + 1) ;								// The sum, rounded up by 1
	assign RoundOF = RoundUp & RoundUpM[23] ; 				// Check for overflow when rounding up
	assign RoundM = (RoundUp ? RoundUpM[22:0] : NormM) ; 	// Compute final mantissa	

	assign ExpAdd = (RoundOF ? 1'b1 : 1'b0) ; 						// Add 1 to exponent to compensate for overflow
	assign RoundE = (NormE + ExpAdd) ; 							// Final exponent

	// Internal signals
	wire FSgn ;
	wire Overflow ;					// Overflow flag
	wire Underflow ;					// Underflow flag
	wire DivideByZero ;				// Divide-by-Zero flag (always 0 in Add/Sub)
	wire Invalid ;						// Invalid inputs or result
	wire Inexact ;						// Result is inexact because of rounding

	// Exception flags
	assign Overflow = ((RoundE[8] | &RoundE[7:0]) & ~NegE & ~ZeroSum & ~InputExc[0]) ;
	assign Underflow = NegE ;
	assign DivideByZero = 1'b0 ;
	assign Invalid = InputExc[3] | InputExc[4]  ;
	assign Inexact = (R | S) | (Overflow & ~InputExc[0]) ;

	// If zero, need to determine sign according to rounding
	assign FSgn = (ZeroSum & (Sa ^ Sb)) | (ZeroSum ? (Sa & Sb & ~Ctrl) : (~MaxAB & Sa) | ((Ctrl ^ Sb) & (MaxAB | Sa))) ;
	// Put pieces together to form final result
	assign Z = {FSgn, RoundE[7:0], RoundM[22:0]} ;
	// Collect exception flags	
	assign Flags = {Overflow, Underflow, DivideByZero, Invalid, Inexact} ; 	
	
endmodule
