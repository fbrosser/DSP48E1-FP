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
	input [23:0] Ma ;
	input [23:0] Mb ;
	
	// Output ports
	output [47:0] Mp ;
	
	assign Mp = Ma * Mb ;
	
endmodule
