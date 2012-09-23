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
		Ma,
		Mb,
		Mp
    );

	// Input ports
	input [23:0] Ma ;				// A's mantissa
	input [23:0] Mb ;				// B's mantissa
	
	// Output ports
	output [47:0] Mp ;			// Mantissa product
	
	assign Mp = Ma * Mb ;		// Calculate product (24x24 bit multiplication)
	
endmodule
