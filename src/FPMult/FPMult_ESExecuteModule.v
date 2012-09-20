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
	input [7:0] Ea ;
	input [7:0] Eb ;
	input Sa ;
	input Sb ;
	
	// Output ports
	output [8:0] E ;
	output Sp ;
	
	assign E = (Ea + Eb - 127) ;
	
	assign Sp = (Sa ^ Sb) ;

endmodule
