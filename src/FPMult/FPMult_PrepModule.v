`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:49:15 10/16/2012 
// Module Name:    FPAddSub_Pipelined_Simplified_2_0_PreAlignModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 The pre-alignment module is responsible for taking the inputs
//							apart, checking the parts for exceptions and feeding them to
//							the alignment module.
//
//////////////////////////////////////////////////////////////////////////////////

 module FPMult_PrepModule (
		clk,
		rst,
		a,
		b,
		Sa,
		Sb,
		Ea,
		Eb,
		Mp,
		InputExc
	);
	
	// Input ports
	input clk ;
	input rst ;
	input [31:0] a ;								// Input A, a 32-bit floating point number
	input [31:0] b ;								// Input B, a 32-bit floating point number
	
	// Output ports
	output Sa ;										// A's sign
	output Sb ;										// B's sign
	output [7:0] Ea ;								// A's exponent
	output [7:0] Eb ;								// B's exponent
	output [47:0] Mp ;							// Mantissa product
	output [4:0] InputExc ;						// Input numbers are exceptions
	
	// Internal signals							// If signal is high...
	wire ANaN ;										// A is a signalling NaN
	wire BNaN ;										// B is a signalling NaN
	wire AInf ;										// A is infinity
	wire BInf ;										// B is infinity
	wire [47:0] PCOUT1 ;
	
	
	assign ANaN = &(a[30:23]) & |(a[30:23]) ;			// All one exponent and not all zero mantissa - NaN
	assign BNaN = &(b[30:23]) & |(b[22:0]);			// All one exponent and not all zero mantissa - NaN
	assign AInf = &(a[30:23]) & ~|(a[30:23]) ;		// All one exponent and all zero mantissa - Infinity
	assign BInf = &(b[30:23]) & ~|(b[30:23]) ;		// All one exponent and all zero mantissa - Infinity
	
	// Check for any exceptions and put all flags into exception vector
	assign InputExc = {(ANaN | BNaN | AInf | BInf), ANaN, BNaN, AInf, BInf} ;
	//assign InputExc = {(ANaN | ANaN | BNaN |BNaN), ANaN, ANaN, BNaN,BNaN} ;
	
	// Take input numbers apart
	assign Sa = a[31] ;							// A's sign
	assign Sb = b[31] ;							// B's sign
	assign Ea = (a[30:23]);						// Store A's exponent in Ea, unless A is an exception
	assign Eb = (b[30:23]);						// Store B's exponent in Eb, unless B is an exception	
	
	assign Mp = ({7'b0000001, a[22:0]}*{12'b0000000000001, b[22:17]}) ;

endmodule
