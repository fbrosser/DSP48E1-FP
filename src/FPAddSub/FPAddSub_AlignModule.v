`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    10:43:14 09/05/2012 
// Module Name:    FPAddSub_AlignModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Alignment module for a floating point adder using IEEE754
//						 single precision. Aligns mantissas for further execution.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_AlignModule(
		Ea,
		Eb,
		Ma,
		Mb,
		CExp,
		Mmax,
		Mmin,
		G,
		PS,
		MaxAB
   );

	// Input ports
	input [7:0] Ea ;								// A's exponent
	input [7:0] Eb ;								// B's exponent	
	input [24:0] Ma ;								// A's mantissa (explicit 1)
	input [24:0] Mb ;								// B's mantissa (explicit 1)
	
	// Output ports
	output [7:0] CExp ;							// The (after alignment) common exponent
	output [24:0] Mmax ;							// The larger mantissa
	output [24:0] Mmin ;							// The smaller mantissa
	
	//  G,R,S bits (see IEEE754 standard)
	output G ;										// Guard bit (retained from shifted out bits)
	output PS ;										// Pre-Sticky bit (OR of shifted out bits)
	output MaxAB ;									// Indicates the larger of A and B(0/A, 1/B)
	
	// Internal signals
	
	wire [7:0] Emax ;								// The larger of the exponents
	wire [7:0] Emin ;								// The smaller of the exponents
	wire [7:0] D ;									// The difference between exponents
	
	wire SFlag ;									// Shift overflow flag (for 25 bits)
	wire [4:0] Shift ;							// Number of steps that Emin needs to be shifted

	wire [49:0] MminP ;
	wire [49:0] MminS ;
	
	// DSP48E1: Comparator
	assign MaxAB = ({Ea, Ma} < {Eb, Mb}) ;	// Determine the larger of A and B. 0/A, 1/B

	assign Emax  = (MaxAB ? Eb : Ea) ; 		// Store larger exponent in Emax
	assign Emin  = (MaxAB ? Ea	: Eb) ; 		// Store smaller exponent in Emin
	
	// DSP48E1: ALU
	assign D  = Emax - Emin ;					// Compute exponent difference (= shift amount)
	
	// DSP48E1: Comparator
	assign SFlag = D < 26 ;						// Cannot shift more than 25 steps to avoid overflow
	assign Shift = (SFlag ? D[4:0] : 25) ;	// Determine final shift value

	assign MminP = {(MaxAB ? Ma[24:0] : Mb[24:0]), 25'b0} ;	// Take out smaller mantissa and append shift space

	// DSP48E1: Shift
	assign MminS = (MminP[49:0] >> Shift); // Perform right shift on smaller mantissa

	// Assign G,R,S bits
	assign G  = MminS[24] ;						// Buffer bit from smaller mantissa
	assign PS = |MminS[23:0] ;					// Check for lost bits from rounding	
	
	// Assign outputs
	assign Mmin = {MminS[49:25]};				// Take out smaller mantissa
	assign Mmax = (MaxAB ? Mb[24:0]:Ma[24:0]) ;	// Take out larger mantissa			
	assign CExp = Emax ;							// Common exponent
	
endmodule
