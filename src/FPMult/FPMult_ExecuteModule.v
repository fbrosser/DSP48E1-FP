`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    12:39:21 09/20/2012 
// Module Name:    FPMult_ExecuteModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult_ExecuteModule(
		a,
		b,
		MpC,
		Ea,
		Eb,
		Sa,
		Sb,
		Sp,
		NormE,
		NormM,
		GRS
    );

	// Input ports
	input [22:0] a ;
	input [16:0] b ;
	input [47:0] MpC ;
	input [7:0] Ea ;						// A's exponent
	input [7:0] Eb ;						// B's exponent
	input Sa ;								// A's sign
	input Sb ;								// B's sign
	
	// Output ports
	output Sp ;								// Product sign
	output [8:0] NormE ;													// Normalized exponent
	output [22:0] NormM ;												// Normalized mantissa
	output GRS ;
	
	wire [47:0] Mp ;
	
	assign Sp = (Sa ^ Sb) ;												// Equal signs give a positive product
	
	assign Mp = (MpC<<17) + ({7'b0000001, a[22:0]}*{1'b0, b[16:0]}) ;
	
	assign NormM = (Mp[47] ? Mp[46:24] : Mp[45:23]); // Check for overflow
	assign NormE = (Ea + Eb + Mp[47]);								// If so, increment exponent
	
	assign GRS = ((Mp[23]&(Mp[24]))|(|Mp[22:0])) ;
	
endmodule
