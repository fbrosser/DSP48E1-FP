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
		E,
		S,
		C,
		Z
    );

	// Input ports
	input [24:0] M ;
	input [7:0] E ;
	input S ;
	input C ;
	
	// Output ports
	output [31:0] Z ;
	
	wire [5:0] Sh ;
	wire [24:0] PSS ;
	wire [7:0] Exp = (C ? (E[7:0])+1 : E[7:0]) ;

	FPAddSub_LNCModule LNCModule(M[24:0], Sh) ;
	
	assign PSS = M[24:0] << Sh ;
	
	assign Z = {S, Exp[7:0], PSS[24:2]} ;

endmodule
