`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    12:47:06 09/20/2012 
// Module Name:    FPMult_NormalizeModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult_NormalizeModule(
		NormM,
		NormE,
		RoundE,
		RoundEP,
		RoundM,
		RoundMP
    );

	// Input Ports
	input [22:0] NormM ;									// Normalized mantissa
	input [8:0] NormE ;									// Normalized exponent

	// Output Ports
	output [8:0] RoundE ;
	output [8:0] RoundEP ;
	output [23:0] RoundM ;
	output [23:0] RoundMP ; 
	
	assign RoundE = NormE - 127 ;
	assign RoundEP = NormE - 126 ;
	assign RoundM = NormM ;
	assign RoundMP = NormM + 1 ;

endmodule
