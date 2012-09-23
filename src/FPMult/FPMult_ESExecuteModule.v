`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    12:29:09 09/20/2012 
// Module Name:    FPMult_ESExecuteModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult_ESExecuteModule(
		Ea,
		Eb,
		Sa,
		Sb,
		Ep,
		Sp
    );

	// Input Ports
	input [7:0] Ea ;						// A's exponent
	input [7:0] Eb ;						// B's exponent
	input Sa ;								// A's sign
	input Sb ;								// B's sign
	
	// Output ports
	output [8:0] Ep ;						// The product exponent
	output Sp ;								// Product sign
	
	assign Ep = (Ea + Eb - 127) ;		// Adding the exponents (adjusting for double bias)
	
	assign Sp = (Sa ^ Sb) ;				// Equal signs give a positive product

endmodule
