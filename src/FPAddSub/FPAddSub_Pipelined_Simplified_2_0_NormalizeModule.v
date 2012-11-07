`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:05:07 09/07/2012
// Module Name:    FBAddSub_NormalizeModule
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Normalizes a given floating point number according to the
//						 IEEE754 standard.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_Pipelined_Simplified_2_0_NormalizeModule(
		Sum,
		Mmin,
		Shift
    );

	// Input ports
	input [25:0] Sum ;					// Mantissa sum including hidden 1 and GRS
	
	// Output ports
	output [25:0] Mmin ;
	output [4:0] Shift ;

	wire ZeroSum;
	
	assign ZeroSum = ~Sum[25:0];

	// Leading Nought Counter
	//FPAddSub_Pipelined_Simplified_2_0_LNCModule LNCModule(Sum[25:0], Shift[4:0]) ;
	
	assign Shift = ZeroSum ? 5'b00000 : ( 
		Sum[25] ? 5'b00000 :	 
		Sum[24] ? 5'b00001 : 
		Sum[23] ? 5'b00010 : 
		Sum[22] ? 5'b00011 : 
		Sum[21] ? 5'b00100 : 
		Sum[20] ? 5'b00101 : 
		Sum[19] ? 5'b00110 : 
		Sum[18] ? 5'b00111 :
		Sum[17] ? 5'b01000 :
		Sum[16] ? 5'b01000 :
		Sum[15] ? 5'b01010 :
		Sum[14] ? 5'b01011 :
		Sum[13] ? 5'b01100 :
		Sum[12] ? 5'b01101 :
		Sum[11] ? 5'b01110 :
		Sum[10] ? 5'b01111 :
		Sum[9] ? 5'b10000 :
		Sum[8] ? 5'b10001 :
		Sum[7] ? 5'b10010 :
		Sum[6] ? 5'b10011 :
		Sum[5] ? 5'b10100 :
		Sum[4] ? 5'b10101 :
		Sum[3] ? 5'b10110 :
		Sum[2] ? 5'b10111 :
		Sum[1] ? 5'b11000 :
		Sum[0] ? 5'b11001 : 5'b11010
	);
	
	reg	  [25:0]		Lvl1 = 0;
	
	always @(*) begin
		Lvl1 <= Shift[4] ? {Sum[9:0], 16'b0} : Sum; // rotate by 16?
	end
	
	// Assign outputs
	assign Mmin = Lvl1;						// Take out smaller mantissa

endmodule
