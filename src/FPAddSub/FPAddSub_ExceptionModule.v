`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    22:37:05 09/12/2012  
// Module Name:    FPAddSub_ExceptionModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Module checking for exceptions in the final result and setting
//							flags accordingly. Also, check for exceptions and special cases
//							affecting sign, exponent and mantissa. Finalizes the result.
//							Note : This module needs some cleaning, it is a bit messy
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_ExceptionModule(
			RoundE,
			RoundM,
			Sa,
			Sb,
			MaxAB,
			InputExc,
			MqNaN,
			PInexact,
			ZeroSum,
			NegE,
			Opr,
			Ctrl,
			Z,
			Flags
    );

	// Input ports
	input [8:0] RoundE ;				// Rounded exponent
	input [22:0] RoundM ;			// Rounded mantissa
	input Sa ;							// A's sign
	input Sb ;							// B's sign
	input MaxAB ;						// Largest of A and B (0/A, 1/B)
	input [6:0] InputExc ;			// Flags indicating exceptions in inputs
	input [22:0] MqNaN ;				// Mantisas for NaN result
	input PInexact ;					// Preliminary inexact flag
	input ZeroSum ;					// Mantissa add sum zero flag
	input NegE ;						// Negative exponent flag
	input Opr ;							// Effective performed operation
	input [2:0] Ctrl ;				// Control signals (rounding mode and operation)
			
	// Output ports
	output [31:0] Z ;					// Final result
	output [4:0] Flags ;				// Final exception flags
	
	// Internal signals
	wire [7:0] AExp ;					// Adjusted exponent (for exception)
	wire ExpOF ;						// Indicates exponent overflow
	wire Overflow ;					// Overflow flag
	wire Underflow ;					// Underflow flag
	wire DivideByZero ;				// Divide-by-Zero flag (always 0 in Add/Sub)
	wire Invalid ;						// Invalid inputs or result
	wire Inexact ;						// Result is inexact because of rounding
	wire PFSgn ;						// Preliminary final sign
	wire S ;								// The final result sign
	wire [22:0] MOF ;					// Indicates mantissa overflow
	wire [22:0] NaN ;					// NaN representation of mantissa
	wire [22:0] M ;					// Final result mantissa
	wire [8:0] EE ;					// Exception exponent
	wire [7:0] E ;						// Final result exponent
	
	assign AExp = RoundE[7:0] + (Overflow ? -192 : 192) ;	
	assign ExpOF = RoundE[8] | &RoundE[7:0] ;

	// Exception flags
	assign Overflow = (ExpOF & ~NegE & ~ZeroSum & ~InputExc[0]) ;
	assign Underflow = NegE ;
	assign DivideByZero = 1'b0 ;
	assign Invalid = InputExc[3] | InputExc[4] | (InputExc[5] & InputExc[6] & Opr)  ;
	assign Inexact = PInexact | (Overflow & ~InputExc[0]) ;

	// Determine final result sign
	// If zero, need to determine sign according to rounding
	assign PFSgn = ZeroSum ? (Sa & Sb & ~Ctrl[0]) : (~MaxAB & Sa) | ((Ctrl[0] ^ Sb) & (MaxAB | Sa)) ;
	// Set result sign
	assign S = (ZeroSum & (Ctrl[1] & Ctrl[2]) & (Sa ^ Sb)) | PFSgn ;
	
	// Determine final result mantissa
	// Mantissa Overflow
	assign MOF = (((~Ctrl[1] & Ctrl[2]) & Overflow & S) | ((Ctrl[1] & ~Ctrl[2]) & Overflow) | 
	((Ctrl[1] & Ctrl[2]) & Overflow & ~S)) ? 23'b11111111111111111111111 : 23'b00000000000000000000000 ;
	// If inputs are NaN or invalid, result will be NaN
	assign NaN = (InputExc[1] | InputExc[2] | Invalid) ? MqNaN : MOF ;
	// The result mantissa
	assign M = (InputExc[0] | Overflow | Underflow | Invalid) ? NaN : RoundM ;
	
	// Determine final result exponent
	// Exponent in case of exception
	assign EE = ((Underflow | ZeroSum) & ~Invalid) ? 8'b0 :
	(((Ctrl[1] & ~Ctrl[2]) & Overflow & S) | ((Ctrl[1] & ~Ctrl[2]) & Overflow) | 
	((Ctrl[1] & Ctrl[2]) & Overflow & ~S)) ? 8'b11111110 : 8'b11111111 ;
	// Result exponent
	assign E = (Overflow | Underflow) ? AExp : (InputExc[0] | Overflow | Underflow | ZeroSum) ? EE : RoundE[7:0] ;
	
	// Assign outputs
	assign Z = {S, E[7:0], M[22:0]} ;													// Put pieces together to form final result
	assign Flags = {Overflow, Underflow, DivideByZero, Invalid, Inexact} ; 	// Collect exception flags
	
endmodule
