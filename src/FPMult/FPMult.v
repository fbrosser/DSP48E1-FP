`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    08:40:21 09/19/2012 
// Module Name:    FPMult
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult(
		A,
		B,
		Ctrl,
		P
    );
	
	// Input Ports
	input [31:0] A;					// Input A, a 32-bit floating point number
	input [31:0] B;					// Input B, a 32-bit floating point number
	input [1:0] Ctrl;					// Control signals
	
	// Output ports
	output [31:0] P ;					// Product, result of the operation, 32-bit FP number
	output [4:0] Flags ;				// Flags indicating exceptions according to IEEE754
	
	// Internal signals
	wire Sa ;							// A's sign
	wire Sb ;							// B's sign
	wire Sp ;							// Product sign
	wire [7:0] Ea ;					// A's exponent
	wire [7:0] Eb ;					// B's exponent
	wire [8:0] Ep ;					// Product exponent
	wire [23:0] Ma ;					// A's mantissa
	wire [23:0] Mb ;					// B's mantissa
	wire [47:0] Mp ;					// Product mantissa
	wire [6:0] InputExc ;			// Exceptions in inputs
	wire [22:0] NormM ;				// Normalized mantissa
	wire [8:0] NormE ;				// Normalized exponent
	wire G ;								// Guard bit
	wire R ;								// Round bit
	wire S ;								// Sticky bit
	wire [22:0] RoundM ;				// Rounded mantissa
	wire [8:0] RoundE ;				// Rounded exponent
	
	// Prepare the operands for alignment and check for exceptions
	FPMult_PrepModule PrepModule(A[31:0], B[31:0], Sa, Sb, Ea[7:0], Eb[7:0], Ma[23:0], Mb[23:0], InputExc[6:0]) ;
	
	// Compute new exponent and product sign
	FPMult_ESExecuteModule ESExecuteModule(Ea[7:0], Eb[7:0], Sa, Sb, Ep[8:0], Sp) ;
	
	// Perform (unsigned) mantissa multiplication
	FPMult_ExecuteModule ExecuteModule(Ma[23:0], Mb[23:0], Mp[47:0]) ;
	
	// Normalize the result if there is overflow (MSB of mantissa set)
	FPMult_NormalizeModule NormalizeModule(Mp[47:0], Ep[8:0], NormM[22:0], NormE[8:0], G, R, S) ;
	
	// Round result and if necessary, perform a second (post-rounding) normalization step
	FPMult_RoundModule RoundModule(NormM[22:0], NormE[8:0], G, R, S, RoundM[22:0], RoundE[8:0]) ;
	
	// Put the pieces together and check for exceptions
	FPMult_ExceptionModule ExceptionModule(RoundM[22:0], RoundE[8:0], Sp, P[31:0]) ;
		
endmodule
