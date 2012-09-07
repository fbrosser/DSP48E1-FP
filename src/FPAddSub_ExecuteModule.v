`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    11:35:05 09/05/2012 
// Module Name:    FPAddSub_ExecuteModule 
// Project Name: 	 CHiPES Project
// Author:			 Fredrik Brosser
//
// Description:	 Module that executes the addition or subtraction on mantissas.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_ExecuteModule(
		Mmax,
		Mmin,
		Smax,
		Smin,
		OpMode,
		Cout,
		StickyBit,
		RoundBit,
		GuardBit,
		Sum,
		Opr,
		OpA,
		OpB,
		OpC
    );

	// Input ports
	input [24:0] Mmax ;											// The larger mantissa
	input [49:0] Mmin ;											// The smaller mantissa
	input Smax ;													// Sign bit of larger number
	input Smin ;													// Sign bit of smaller number
	input OpMode ;													// Operation to be performed (0/Add, 1/Sub)
	
	// Output ports. Note G,R,S bits (IEEE standard)
	output Cout ;													// Carry out bit
	output StickyBit ;											// Used
	output RoundBit ;												// Used in rounding
	output GuardBit ;												// Used to guard against overflow
	output [25:0] Sum ;											// The result of the operation
	output Opr ;													// The effective (performed) operation
	
	// Internal signals
	output [25:0] OpA ;											// Operand A for add/sub
	output [25:0] OpB ;											// Operand B for add/sub
	output OpC ;													// Operand C (carry)
	
	// DSP48E1: ALU
	assign StickyBit = (|Mmin[23:0]) ;						// Check for lost bits from rounding
	assign GuardBit  = Mmin[24] ;								// Buffer bit from smaller mantissa
	
	assign Opr 		  = (OpMode ^ Smax ^ Smin) ;			// Resolve sign to determine operation
	assign OpA		  = Mmax;									// Operand A is simply the larger mantissa
	
	// DSP48E1: ALU
	assign OpB = (Opr ? (~({1'b0, Mmin[49:25]})) : Mmin[49:25]) ; // Determine Operand B
	
	assign OpC	= Opr & ~(GuardBit | StickyBit) ;		// Compute carry to compensate for 1's complement
	
	assign Cout	= OpC ;											// Assign Carry out bit

	// DSP48E1: ALU
	assign Sum 	= (OpA + OpB + OpC) ;						// Compute actual sum

endmodule
