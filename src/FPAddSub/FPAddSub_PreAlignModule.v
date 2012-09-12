`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    14:33:48 09/12/2012 
// Module Name:    FPAddSub_PreAlignModule 
// Project Name: 	 Floating Point Project
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
		Mb,
		InputExc,
		MqNaN
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
	output [6:0] InputExc ;						// Input numbers are exceptions
	output [22:0] MqNaN ;						// Used in exception handling later on
	
	// Internal signals							// If signal is high...
	wire InExc ;									// One of the inputs is an exception
	wire AEZEx ;									// All-zero exponent in A
	wire BEZEx ;									// All-zero exponent in B
	wire AEOEx ;									// All-one exponent in A
	wire BEOEx ;									// All-one exponent in B
	wire AMZEx ;									// All-zero mantissa in A
	wire BMZEx ;									// All-zero mantissa in B
	wire AqNaN ;									// A is a quiet NaN
	wire BqNaN ;									// B is a quiet NaN
	wire AsNaN ;									// A is a signalling NaN
	wire BsNaN ;									// B is a signalling NaN
	wire AInf ;										// A is infinity
	wire BInf ;										// B is infinity
	
	// Exception checking
	assign AEZEx = ~|(A[30:23]) ;				// Check for all-zero exponent in A
	assign BEZEx = ~|(B[30:23]) ;				// Check for all-zero exponent in B
	assign AEOEx = &(A[30:23]) ; 				// Check for all-one exponent in A
	assign BEOEx = &(B[30:23]) ;				// Check for all-one exponent in B
	assign AMZEx = ~|(A[22:0]) ;				// Check for all-zero mantissa in A
	assign BMZEx = ~|(A[22:0]) ;				// Check for all-zero mantissa in A
	
	assign AqNaN = AEOEx & ~AMZEx ;			// All one exponent and not all zero mantissa - Quiet NaN
	assign BqNaN = BEOEx & ~BMZEx ;			// All one exponent and not all zero mantissa - Quiet NaN
	assign AsNaN = AqNaN & ~A[22] ;			// All one exponent and not all zero mantissa and mantissa MSB zero- Signalling NaN
	assign BsNaN = BqNaN & ~B[22] ;			// All one exponent and not all zero mantissa and mantissa MSB zero - Signalling NaN
	assign AInf = AEOEx & AMZEx ;				// All one exponent and all zero mantissa - Infinity
	assign BInf = BEOEx & BMZEx ;				// All one exponent and all zero mantissa - Infinity
	
	// Quiet NaN flag used in the exception handling later on
	assign MqNaN = {1'b1, (AqNaN ? A[21:0] : B[21:0]) } ;
	
	// Check for any exceptions and put all flags into exception vector
	assign InExc = (AqNaN | BqNaN | AsNaN | BsNaN | AInf | BInf) ; 
	assign InputExc = {InExc, AqNaN, BqNaN, AsNaN, BsNaN, AInf, BInf} ;
	
	// Take input numbers apart
	assign Sa = A[31] ;							// A's sign
	assign Sb = B[31] ;							// B's sign
	assign Ea = (AEZEx ? 8'b1 : A[30:23]);	// Store A's exponent in Ea, unless A is an exception
	assign Eb = (BEZEx ? 8'b1 : B[30:23]);	// Store B's exponent in Eb, unless B is an exception	
	assign Ma = {~AEZEx, A[22:0], 1'b0} ;	// Prepend implicit 1 to A's mantissa and append 0 (unless exception)
	assign Mb = {~BEZEx, B[22:0], 1'b0} ;	// Prepend implicit 1 to B's mantissa and append 0 (unless exception)
    
endmodule
