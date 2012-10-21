`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    11:35:05 09/05/2012 
// Module Name:    FPAddSub_ExecuteModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Module that executes the addition or subtraction on mantissas.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_Pipelined_Simplified_2_0_ExecutionModule(
		Mmax,
		Mmin,
		Sa,
		Sb,
		MaxAB,
		OpMode,
		G,
		PS,
		Sum,
		PSgn,
		Opr
    );

	// Input ports
	input [24:0] Mmax ;					// The larger mantissa
	input [24:0] Mmin ;					// The smaller mantissa
	input Sa ;								// Sign bit of larger number
	input Sb ;								// Sign bit of smaller number
	input MaxAB ;							// Indicates the larger number (0/A, 1/B)
	input OpMode ;							// Operation to be performed (0/Add, 1/Sub)
	input G ;								// Guard bit
	input PS ;								// Pre-Sticky bit
	
	// Output ports
	output [25:0] Sum ;					// The result of the operation
	output PSgn ;							// The sign for the result
	output Opr ;							// The effective (performed) operation

	assign Opr = (OpMode^Sa^Sb); 		// Resolve sign to determine operation

	// Operand A is simply the larger mantissa
	// Operand B is positive if the effective operation is addition, otherwise negated
	// Operand C is the effective operation performed, compensated for 2's complement
	assign Sum 	= (Mmax + 
						((OpMode^Sa^Sb) ? (~({1'b0, Mmin[24:0]})) : Mmin[24:0]) + 
						(Opr & ~(G | PS))) ;	// Compute actual sum
	
	assign PSgn = (MaxAB ? Sb : Sa) ;		// Assign result sign

endmodule
