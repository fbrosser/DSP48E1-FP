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
		Z
    );

	input [25:0] M ;
	input [7:0] E ;
	input S ;
	
	output [31:0] Z ;
	
	wire [31:0] ACnt ;
	wire [5:0] ZCnt ;

	FPAddSub_LNCModule LNCModule(ACnt, ZCnt) ;

endmodule
