`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    14:33:48 09/12/2012 
// Module Name:    FPAddSub_PreAlignModule 
// Project Name: 	 CHiPES Project
// Author:			 Fredrik Brosser
//
// Description:	 The pre-alignment module is responsible for taking the inputs
//							apart, checking the parts for exceptions and feeding them to
//							the alignment module.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_PreAlignModule(
		A,
		B,
		Sa,
		Sb,
		Ea,
		Eb,
		Ma,
		Mb
	);
	
	// Input ports
	input [31:0] A ;								// Input A, a 32-bit floating point number
	input [31:0] B ;								// Input B, a 32-bit floating point number
	
	// Output ports
	output Sa ;										// A's sign
	output Sb ;										// B's sign
	output [7:0] Ea ;								// A's exponent
	output [7:0] Eb ;								// B's exponent
	output [24:0] Ma ;							// A's mantissa (explicit 1)
	output [24:0] Mb ;							// B's mantissa (explicit 1)
	
	// Internal signals
	wire AEx ;										// A is an exception: denormalized, underflow or infinity
	wire BEx ;										// B is an exception: denormalized, underflow or infinity
	
	// Exception checking
	assign AEx = ~|(A[30:23]);					// Check for all-zero exponents in A (for exception case)
	assign BEx = ~|(B[30:23]);					// Check for all-zero exponents in B (for exception case)

	// Take input numbers apart
	assign Sa = A[31] ;							// A's sign
	assign Sb = B[31] ;							// B's sign
	assign Ea = (AEx ? 8'b1 : A[30:23]);	// Store A's exponent in Ea, unless A is an exception
	assign Eb = (BEx ? 8'b1 : B[30:23]);	// Store B's exponent in Eb, unless B is an exception	
	assign Ma = {~AEx, A[22:0], 1'b0} ;		// Prepend implicit 1 to A's mantissa and append 0 (unless exception)
	assign Mb = {~BEx, B[22:0], 1'b0} ;		// Prepend implicit 1 to B's mantissa and append 0 (unless exception)
    
endmodule
