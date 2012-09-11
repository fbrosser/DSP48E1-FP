`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:05:07 09/07/2012
// Module Name:    FBAddSub_NormalizeModule
// Project Name: 	 CHiPES Project
// Author:			 Fredrik Brosser
//
// Description:	 Normalizes a given floating point number according to the
//						 IEEE754 standard.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_NormalizeModule(
		M,
		Z
    );

	// Input ports
	input [23:0] M ;
	
	// Output ports
	output [31:0] Z ;
	
	// Internal wires
	wire [5:0] Sh ;
	wire [23:0] PSS ;

	// Leading Nought Counter
	FPAddSub_LNCModule LNCModule(M[24:0], Sh) ;
	
	// Perform Shift
	assign PSS = M[23:0] << Sh ;

endmodule
