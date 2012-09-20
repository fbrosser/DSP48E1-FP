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
		M,
		E,
		NormM,
		NormE,
		G,
		R,
		S
    );

	// Input ports
	input [47:0] M ;
	input [8:0] E ;
	
	// Output ports
	output [47:0] NormM ;
	output [8:0] NormE ;
	output G ;
	output R ;
	output S ;
	
	reg [47:0] NormM ;
	reg [7:0] NormE ;	
	
	always @(M) begin
		if(M[47]) begin
			NormM = M >> 1 ;
			NormE = E + 1 ;
		end
		else begin
			NormM = M ;
			NormE = E ;
		end
	end
	
	assign G =  NormM[24] ;
	assign R =  NormM[23] ;
	assign S = |NormM[22:0] ;

endmodule
