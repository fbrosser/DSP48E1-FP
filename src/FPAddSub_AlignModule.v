`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    10:43:14 09/05/2012 
// Module Name:    FPAddSub_AlignModule 
// Project Name: 	 CHiPES Project
// Author:			 Fredrik Brosser
//
// Description:	 Alignment module for a floating point adder using IEEE754
//						 single precision. Aligns mantissas for further execution.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_AlignModule(
		A,
		B,
		Es,
		MaxAB,
		Mmax,
		Mmin,
		Sa,
		Sb
   );

	// Input ports
	input [31:0] A ;								// Input A, a 32-bit floating point number
	input [31:0] B ;								// Input B, a 32-bit floating point number
	 
	// Output ports
	output [7:0] Es ;								// The (after alignment) common exponent
	output MaxAB ;									// Indicates the larger of A and B(0/A, 1/B)
	output [23:0] Mmax ;							// The larger mantissa
	output [48:0] Mmin ;							// The smaller mantissa
	output Sa ;										// A's sign bit
	output Sb ;										// B's sign bit
	
	// Internal signals
	wire [7:0] Ea ;								// A's exponent
	wire [7:0] Eb ;								// B's exponent
	wire [7:0] Emax ;								// The larger of the exponents
	wire [7:0] Emin ;								// The smaller of the exponents
	
	wire [7:0] Diff ;								// The difference between exponents
	
	wire AEx ;										// A is an exception: denormalized, 0 or infinity
	wire BEx ;										// B is an exception: denormalized, 0 or infinity
	
	wire [4:0] Shift ;							// Number of steps that Emin needs to be shifted
	wire SFlag ;									// Shift overflow flag (for 25 bits)
	wire [23:0] Ma ;								// A's mantissa (explicit 1)
	wire [23:0] Mb ;								// B's mantissa (explicit 1)
	wire [48:0]	MminP ;							// Temporary storage for smaller mantissa, preshift

	// TODO: Add error checking!				TODO: Add error checking!
	
	assign AEx = ~|(A[30:23]);					// Check for all-zero exponents in A (for exception case)
	assign BEx = ~|(B[30:23]);					// Check for all-zero exponents in A (for exception case)

	// Not yet implemented, handling exceptions
	//assign Ea = (AEx ? 8'b1 : A[30:23]);			// Store A's exponent in Ea, unless A is an exception
	//assign Eb = (BEx ? 8'b1 : B[30:23]);			// Store B's exponent in Eb, unless B is an exception

	assign Ea	 = A[30:23] ;					// Store A's exponent in Ea
	assign Eb	 = B[30:23] ;					// Store B's exponent in Eb
	assign Ma 	 = {~AEx, A[22:0]} ;			// Prepend implicit 1 to A's mantissa (unless exception)
	assign Mb 	 = {~BEx, B[22:0]} ;			// Prepend implicit 1 to B's mantissa (unless exception)
	assign Sa	 = A[31] ;						// Store A's sign bit in Sa
	assign Sb	 = B[31] ;						// Store B's sign bit in Sb
	
	// DSP48E1: Comparator
	assign MaxAB = (A[30:0] > B[30:0]) ;	// Determine the larger of A and B. 0/A, 1/B
	
	assign Emax  = (MaxAB ? Ea : Eb) ; 		// Store larger exponent in Emax
	assign Emin  = (MaxAB ? Eb	: Ea) ; 		// Store smaller exponent in Emin
	
	// DSP48E1: ALU
	assign Diff  = Emax - Emin ;				// Compute exponent difference (= shift amount)
	
	// DSP48E1: Comparator
	assign SFlag = Diff < 26 ;					// Cannot shift more than 25 steps to avoid overflow
	assign Shift = (SFlag ? Diff[4:0] : 25) ;		// Determine final shift value

	assign MminP = {(MaxAB ? Mb : Ma), 25'b0} ;	// Take out smaller mantissa and append shift space

	// DSP48E1: Shift
	assign Mmin = (MminP >> Shift) ;			// Perform right shift on smaller mantissa
	
	assign Mmax  = (MaxAB ? Ma : Mb) ;		// Take out larger mantissa
						
	assign Es	 = Emax ;						// Sum exponent will be the largest of A and B's exponents
	
endmodule
