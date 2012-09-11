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
		Sa,
		Sb,
		MaxAB,
		OpMode,
		G,
		S,
		Sum,
		Sgn
    );

	// Input ports
	input [24:0] Mmax ;					// The larger mantissa
	input [24:0] Mmin ;					// The smaller mantissa
	input Sa ;								// Sign bit of larger number
	input Sb ;								// Sign bit of smaller number
	input MaxAB ;							// Indicates the larger number (0/A, 1/B)
	input OpMode ;							// Operation to be performed (0/Add, 1/Sub)
	input G ;								// Guard bit
	input S ;								// Sticky bit
	
	// Output ports
	output [25:0] Sum ;					// The result of the operation
	output Sgn ;							// The sign for the result
	
	// Internal signals
	wire [24:0] OpA ;						// Operand A for add/sub
	wire [26:0] OpB ;						// Operand B for add/sub
	wire OpC ;								// Operand C (carry)
	wire Opr ;								// The effective operation
	
	assign Opr = (OpMode^Sa^Sb); 		// Resolve sign to determine operation
	assign OpA = Mmax;					// Operand A is simply the larger mantissa
	
	// DSP48E1: ALU
	assign OpB = (Opr ? (~({1'b0, Mmin[24:0]})) : Mmin[24:0]) ; // Determine Operand B
	
	assign OpC	= Opr & ~(G | S) ;	// Compute carry to compensate for 1's complement
	
	// DSP48E1: ALU
	assign Sum 	= (OpA + OpB + OpC) ;	// Compute actual sum
	
	assign Sgn = (MaxAB ? Sb : Sa) ;		// Assign result sign

endmodule
