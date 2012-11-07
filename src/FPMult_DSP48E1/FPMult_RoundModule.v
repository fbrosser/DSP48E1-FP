`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    17:14:54 09/20/2012 
// Module Name:    FPMult_RoundModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult_RoundModule(
		NormM,
		NormE,
		Sp,
		G,
		R,
		S,
		InputExc,
		Z,
		Flags
    );

	// Input Ports
	input [22:0] NormM ;									// Normalized mantissa
	input [8:0] NormE ;									// Normalized exponent
	input Sp ;												// Product sign
	input G ;												// Guard bit
	input R ;												// Round bit
	input S ;												// Sticky bit
	input [4:0] InputExc ;
	
	// Output Ports
	output [31:0] Z ;										// Final product
	output [4:0] Flags ;
	
	// Internal Signals
	wire [22:0] RoundM ;									// Rounded mantissa
	wire [8:0] RoundE ;									// Rounded exponent
	wire [8:0] RoundEP;
	wire [23:0] PreShiftM;
	wire [23:0] NormMP;								// Mantissa before shifting
	wire MOz;
	
	assign MOz = &NormM;
	assign RoundEP = NormE + 1'b1;
	assign NormMP = NormM + 1'b1;
	
	assign PreShiftM = ((R&(G|S)) ? NormMP : NormM) ;	// Round up if R and (G or S)
	
	// Post rounding normalization (potential one bit shift> use shifted mantissa if there is overflow)
	assign RoundM = (MOz ? PreShiftM[23:1] : PreShiftM[22:0]) ;
	
	assign RoundE = (MOz ? RoundEP : NormE) ; // Increment exponent if a shift was done
	
	assign Z = {Sp, RoundE[7:0], RoundM[22:0]} ;   // Putting the pieces together
	assign Flags = InputExc[4:0];

endmodule
