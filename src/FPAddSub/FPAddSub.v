`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    01:56:20 09/07/2012 
// Module Name:    FPAddSub
// Project Name: 	 CHiPES Project
// Author:			 Fredrik Brosser
//
// Description:	 Top Module for a floating point adder/subtractor
//
//////////////////////////////////////////////////////////////////////////////////

//`include "FPAddSub.v"

module FPAddSub(
		A,
		B,
		OpMode,
		Z
	);
	
	// Input ports
	input [31:0] A ;												// Input A, a 32-bit floating point number
	input [31:0] B ;												// Input B, a 32-bit floating point number
	input OpMode ;													// Operation to be performed, +/0 or -/1
	
	// Output ports
	output [31:0] Z ;

	// Internal wires between modules
	wire [7:0] Es ;												// Align->Execute: The (after alignment) common exponent
	wire MaxAB ;													// Align->Execute: Indicates the larger of A and B(0/A, 1/B)
	wire [24:0] Mmax ;											// Align->Execute: The larger mantissa
	wire [49:0] Mmin ;											// Align->Execute: The smaller mantissa
	wire Sa ;														// Align->Execute: A's sign bit
	wire Sb ;	
	wire Carry ;
	wire StickyBit ;
	wire RoundBit ;
	wire GuardBit ;
	wire [25:0] Sum ;
	wire Opr ;
	wire OpC ;
	wire Sgn ;
	wire [25:0] OpA ;
	wire [25:0] OpB ;
	
	FPAddSub_AlignModule		AlignModule(A[31:0], B[31:0], Es[7:0], MaxAB, Mmax[23:0], Mmin[48:0], Sa, Sb) ;

	FPAddSub_ExecuteModule 	ExecuteModule(Mmax[23:0], Mmin[48:0], Sa, Sb, OpMode, Carry, StickyBit, RoundBit, GuardBit, Sum[24:0], Opr, OpA[25:0], OpB[25:0], OpC) ;

	FPAddSub_NormalizeModule NormalizeModule(Sum[25:0], Es[7:0], Sgn, Carry, Z[31:0]) ;

endmodule
