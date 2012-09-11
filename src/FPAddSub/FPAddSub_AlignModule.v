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
		Exp,
		Mmax,
		Mmin,
		G,
		R,
		S,
		MaxAB
   );

	// Input ports
	input [31:0] A ;								// Input A, a 32-bit floating point number
	input [31:0] B ;								// Input B, a 32-bit floating point number
	 
	// Output ports
	output [7:0] Exp ;							// The (after alignment) common exponent
	output [24:0] Mmax ;							// The larger mantissa
	output [24:0] Mmin ;							// The smaller mantissa
	
	//  G,R,S bits (see IEEE754 standard)
	output G ;										// Guard bit (retained from shifted out bits)
	output R ;										// Round bit (retained from shifted out bits)
	output S ;										// Sticky bit (OR of shifted out bits)
	output MaxAB ;									// Indicates the larger of A and B(0/A, 1/B)
	
	// Internal signals
	wire [7:0] Ea ;								// A's exponent
	wire [7:0] Eb ;								// B's exponent
	wire [7:0] Emax ;								// The larger of the exponents
	wire [7:0] Emin ;								// The smaller of the exponents
	
	//wire [7:0] d ;								// The difference between exponents
	
	wire AEx ;										// A is an exception: denormalized, underflow or infinity
	wire BEx ;										// B is an exception: denormalized, underflow or infinity
	
	wire SFlag ;									// Shift overflow flag (for 25 bits)
	wire [4:0] Shift ;							// Number of steps that Emin needs to be shifted
	wire [24:0] Ma ;								// A's mantissa (explicit 1)
	wire [24:0] Mb ;								// B's mantissa (explicit 1)
	
	// TODO: Add error checking and exception handling!
	
	assign AEx = ~|(A[30:23]);					// Check for all-zero exponents in A (for exception case)
	assign BEx = ~|(B[30:23]);					// Check for all-zero exponents in A (for exception case)

	// Not yet implemented, handling exceptions
	//assign Ea = (AEx ? 8'b1 : A[30:23]);	// Store A's exponent in Ea, unless A is an exception
	//assign Eb = (BEx ? 8'b1 : B[30:23]);	// Store B's exponent in Eb, unless B is an exception

	// Take input numbers apart
	assign Ea	 = A[30:23] ;					// Store A's exponent in Ea
	assign Eb	 = B[30:23] ;					// Store B's exponent in Eb
	assign Ma 	 = {~AEx, A[22:0], 1'b0} ;	// Prepend implicit 1 to A's mantissa and append 0 (unless exception)
	assign Mb 	 = {~BEx, B[22:0], 1'b0} ;	// Prepend implicit 1 to B's mantissa and append 0 (unless exception)
	
	// DSP48E1: Comparator
	assign MaxAB = (A[30:0] < B[30:0]) ;	// Determine the larger of A and B. 0/A, 1/B

	assign Emax  = (MaxAB ? Eb : Ea) ; 		// Store larger exponent in Emax
	assign Emin  = (MaxAB ? Ea	: Eb) ; 		// Store smaller exponent in Emin
	
	// DSP48E1: ALU
	assign d  = Emax - Emin ;					// Compute exponent difference (= shift amount)
	
	// DSP48E1: Comparator
	assign SFlag = d < 26 ;						// Cannot shift more than 25 steps to avoid overflow
	assign Shift = (SFlag ? d[4:0] : 25) ;	// Determine final shift value

	assign MminP = {(MaxAB ? Ma[24:0] : Mb[24:0]), 25'b0} ;	// Take out smaller mantissa and append shift space

	// DSP48E1: Shift
	assign MminS = (MminP[49:0] >> Shift) ;		// Perform right shift on smaller mantissa
	
	// DSP48E1: ALU
	assign G  = MminS[24] ;						// Buffer bit from smaller mantissa
	assign R = MminS[23]	;						// Round bit
	assign S = (|MminS[22:0]) ;				// Check for lost bits from rounding	
	assign Mmin = MminS[49:25] ;				// Take out smaller mantissa
	assign Mmax = (MaxAB ? Mb[24:0]:Ma[24:0]) ;		// Take out larger mantissa			
	assign Exp = Emax ;							// Common exponent
	
endmodule
