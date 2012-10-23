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

module FPAddSub_Pipelined_Simplified_2_0_PreAlignModule(
		A,
		B,
		Sa,
		Sb,
		CExp,
		MaxAB,
		Shift,
		MminS,
		Mmax,
		InputExc
	);
	
	// Input ports
	input [31:0] A ;								// Input A, a 32-bit floating point number
	input [31:0] B ;								// Input B, a 32-bit floating point number
	
	// Output ports
	output Sa ;										// A's sign
	output Sb ;										// B's sign
	output [7:0] CExp ;									// Common Exponent
	output MaxAB ;									// Indicates the larger of A and B(0/A, 1/B)
	output [4:0] Shift ;							// Number of steps to smaller mantissa shift right
	output [31:0] MminS ;						// Smaller mantissa after 0/16 shift
	output [24:0] Mmax ;							// Larger mantissa
	output [4:0] InputExc ;						// Input numbers are exceptions
	
	// Internal signals							// If signal is high...
	wire ANaN ;									// A is a signalling NaN
	wire BNaN ;									// B is a signalling NaN
	wire AInf ;										// A is infinity
	wire BInf ;										// B is infinity
	
	assign ANaN = &(A[30:23]) & |(A[30:23]) ;			// All one exponent and not all zero mantissa - NaN
	assign BNaN = &(B[30:23]) & |(B[22:0]);			// All one exponent and not all zero mantissa - NaN
	assign AInf = &(A[30:23]) & ~|(A[30:23]) ;				// All one exponent and all zero mantissa - Infinity
	assign BInf = &(B[30:23]) & ~|(B[30:23]) ;				// All one exponent and all zero mantissa - Infinity
	
	// Check for any exceptions and put all flags into exception vector
	assign InputExc = {(ANaN | BNaN | AInf | BInf), ANaN, BNaN, AInf, BInf} ;
	
	// Internal signals
	// The difference between exponents
	wire [7:0] DA ;							
	wire [7:0] DB ;
	wire BOF ;
	wire AOF ;
	
	assign DA  = (A[30:23] - B[30:23]) ;
	assign DB  = (B[30:23] - A[30:23]) ;
	
	// A's sign bit
	assign Sa = A[31] ;		
	// B's sign	bit
	assign Sb = B[31] ;							
	// Determine the larger of A and B. 0/A, 1/B
	//assign MaxAB = (A[30:23] < B[30:23]) ;
	assign MaxAB = (DA < 0) ;
	assign BOF = DB < 26 ;
	assign AOF = DA < 26 ;	
	// Determine final shift value
	//assign Shift = MaxAB ? ((DB < 26) ? DB[4:0] : 5'b11001) : ((DA < 26) ? DA[4:0] : 5'b11001) ;
	
	assign Shift = MaxAB ? (BOF ? DB[4:0] : 5'b11001) : (AOF ? DA[4:0] : 5'b11001) ;
	
	// Take out smaller mantissa and append shift space
	assign MminS = {(MaxAB ? {1'b1, A[22:0], 1'b0} : {1'b1, B[22:0], 1'b0}), 7'b0} ; 
	// Take out larger mantissa	
	assign Mmax = (MaxAB ? {1'b1, B[22:0], 1'b0}: {1'b1, A[22:0], 1'b0}) ;	
	// Common exponent
	assign CExp = (MaxAB ? B[30:23] : A[30:23]) ;									
	
endmodule
