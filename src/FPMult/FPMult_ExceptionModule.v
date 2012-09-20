`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    22:01:03 09/20/2012 
// Module Name:    FPMult_RoundModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult_ExceptionModule(
			RoundE,
			RoundM,
			Sgn,
			P
    );

	// Input ports
	input [23:0] RoundM ;
	input [8:0] RoundE ;
	input Sgn ;
	
	// Output ports
	output [31:0] P ;
	
	assign P = {Sgn & RoundE[7:0] & RoundM[22:0]} ;
	
endmodule
