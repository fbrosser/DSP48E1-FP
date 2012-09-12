`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    01:56:20 09/07/2012 
// Module Name:    FPAddSub
// Project Name: 	 CHiPES Project
// Author:			 Fredrik Brosser
//
// Description:	 Top Module for a 32-bit floating point adder/subtractor.
//						 Follows the IEEE754 Single Precision standard.
//
//	Inputs:
//						 A (32 bit)		: Single precision IEEE754 floating point number
//						 B (32 bit)		: Single precision IEEE754 floating point number
//						 Ctrl (3 bit)	: Control signals, consisting of the following fields (from MSB to LSB):
//												Bit 2-1: Rounding mode (2 bit): 	00 - Round to nearest, ties to even 
// 																						01 - Round up (towards +inf)
// 																						10 - Symmetric rounding (towards +/- 0)
// 																						11 - Round down (towards -inf)
//												Bit 0: 	Operation mode (1 bit): 0 	- Addition
//																							1 	- Subtraction
//
//
// Outputs:
//						Z (32 bit)		: Result of the operation, in IEEE754 Single format
//						Flags (5 bit)	: Flags indicating exceptions according to IEEE754 (from MSB to LSB):
//													Bit 4: Overflow
//													Bit 3: Underflow
//													Bit 2: Divide by Zero
//													Bit 1: Invalid/NaN
//													Bit 0: Inexact
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub(
		A,
		B,
		Ctrl,
		Z,
		Flags
	);
	
	// Input ports
	input [31:0] A ;				// Input A, a 32-bit floating point number
	input [31:0] B ;				// Input B, a 32-bit floating point number
	input [2:0] Ctrl ;			// Control signals
	
	// Output ports
	output [31:0] Z ;				// Result of the operation
	output [4:0] Flags ;			// Flags indicating exceptions according to IEEE754

	// Internal wires between modules
	wire Sa ;						// PreAlign->Execute: A's sign bit
	wire Sb ;						// PreAlign->Execute: B's sign bit
	wire [7:0] Ea ;				// PreAlign->Align: A's expnent
	wire [7:0] Eb ;				// PreAlign->Align: B's exponent
	wire [24:0] Ma ;				// PreAlign->Align: A's mantissa
	wire [24:0] Mb ;				// PreAlign->Align: B's mantissa
	wire [22:0] MqNaN ;			// PreAlign->Exception: Mantissa for a NaN result
	wire [6:0] InputExc ;		// PreAlign->Exception: Exceptions in Inputs
	wire [7:0] CExp ;				// Align->Round: The (after alignment) common exponent
	wire [24:0] Mmax ;			// Align->Execute: The larger mantissa
	wire [24:0] Mmin ;			// Align->Execute: The smaller mantissa
	wire G ;							// Align->Execute/Normalize: Guard bit
	wire PS ;						// Align->Execute/Normalize: Pre-sticky bit
	wire R ;							// Normalize->Round : Round bit
	wire S ;							// Normalize->Round : Final sticky bit
	wire MaxAB ;					// Align->Execute: Indicates the larger of A and B(0/A, 1/B)
	wire [25:0] Sum ;				// Execute->Normalize: Sum of the mantissas of A and B
	wire PSgn ;						// Execute->Round: Preliminary Sign of the result
	wire Opr ;						// Execute->Normalize: The effective operation performed
	wire [22:0] NormM ;			// Normalize->Round: The normalized result mantissa
	wire [8:0] NormE ;			// Normalize->Round: The result exponent after normalization
	wire ZeroSum;					// Normalize->Exception: Normalized sum is zero
	wire NegE;						// Normalize->Exception: Adjusted exponent is negative
	wire PInexact ;				// Round->Exception: Inexact after rounding
	wire [22:0] RoundM ;			// Round->Exception: Rounded mantissa
	wire [8:0] RoundE ;			// Round->Exception: Rounded exponent
	
	// Prepare the operands for alignment and check for exceptions
	FPAddSub_PreAlignModule PreAlignModule(A[31:0], B[31:0], Sa, Sb, Ea[7:0], Eb[7:0], Ma[24:0], Mb[24:0], InputExc[6:0], MqNaN[22:0]) ;
	
	// Align mantissas for execution and generate guard and presticky
	FPAddSub_AlignModule	AlignModule(Ea[7:0], Eb[7:0], Ma[24:0], Mb[24:0], CExp[7:0], Mmax[24:0], Mmin[24:0], G, PS, MaxAB) ;

	// Determine effective operation and execute addition or subtraction accordingly
	FPAddSub_ExecuteModule ExecuteModule(Mmax[24:0], Mmin[24:0], Sa, Sb, MaxAB, Ctrl[0], G, PS, Sum[25:0], PSgn, Opr) ;

	// Normalize the result and generate final round and sticky
	FPAddSub_NormalizeModule NormalizeModule(Sum[25:0], CExp[7:0], G, PS, Opr, NormM[22:0], NormE[8:0], ZeroSum, NegE, R, S) ;
	
	// Round the result according to input, adjust for overflow and check for rounding errors 
	FPAddSub_RoundModule RoundModule (PSgn, NormE[8:0], NormM[22:0], R, S, Ctrl[2:1], RoundM[22:0], RoundE[8:0], PInexact) ;
	
	// Adjust for exception cases, set exception flags and put together final result
	FPAddSub_ExceptionModule ExceptionModule(RoundE[8:0], RoundM[22:0], Sa, Sb, MaxAB, 
		InputExc[6:0], MqNaN[22:0], PInexact, ZeroSum, NegE, Opr, Ctrl[2:0], Z[31:0], Flags[4:0]) ;
	
endmodule
