`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:49:15 10/16/2012 
// Module Name:    FPAddSub_Pipelined_Simplified_2_0_PreAlignModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 The pre-alignment module is responsible for taking the inputs
//							apart, checking the parts for exceptions and feeding them to
//							the alignment module.
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult_PrepModule (
		A,
		B,
		Sa,
		Sb,
		Ea,
		Eb,
		Ma,
		Mb,
		InputExc
	);
	
	// Input ports
	input [31:0] A ;								// Input A, a 32-bit floating point number
	input [31:0] B ;								// Input B, a 32-bit floating point number
	
	// Output ports
	output Sa ;										// A's sign
	output Sb ;										// B's sign
	output [7:0] Ea ;								// A's exponent
	output [7:0] Eb ;								// B's exponent
	output [23:0] Ma ;							// A's mantissa (explicit 1)
	output [23:0] Mb ;							// B's mantissa (explicit 1)
	output [4:0] InputExc ;						// Input numbers are exceptions
	
	// Internal signals							// If signal is high...
	wire ANaN ;										// A is a signalling NaN
	wire BNaN ;										// B is a signalling NaN
	wire AInf ;										// A is infinity
	wire BInf ;										// B is infinity
	
	assign ANaN = &(A[30:23]) & |(A[30:23]) ;			// All one exponent and not all zero mantissa - NaN
	assign BNaN = &(B[30:23]) & |(B[22:0]);			// All one exponent and not all zero mantissa - NaN
	assign AInf = &(A[30:23]) & ~|(A[30:23]) ;		// All one exponent and all zero mantissa - Infinity
	assign BInf = &(B[30:23]) & ~|(B[30:23]) ;		// All one exponent and all zero mantissa - Infinity
	
	// Check for any exceptions and put all flags into exception vector
	assign InputExc = {(ANaN | BNaN | AInf | BInf), ANaN, BNaN, AInf, BInf} ;

	// Take input numbers apart
	assign Sa = A[31] ;							// A's sign
	assign Sb = B[31] ;							// B's sign
	assign Ea = (A[30:23]);						// Store A's exponent in Ea, unless A is an exception
	assign Eb = (B[30:23]);						// Store B's exponent in Eb, unless B is an exception	
	assign Ma = {1'b1, A[22:0]} ;				// Prepend implicit 1 to A's mantissa
	assign Mb = {1'b1, B[22:0]} ;				// Prepend implicit 1 to B's mantissa
    
endmodule
