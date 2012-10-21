`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    15:18:29 09/07/2012
// Module Name:    FBAddSub_LNCModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Leading Nought Counter - Module for counting the number of leading
//						 noughts in a bit vector, i.e. #bits until first 1, starting from MSB
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_Pipelined_Simplified_2_0_LNCModule(
		A,
		Z
    );

	// Input ports
	input [25:0] A ;				// 32-bit input bit vector
	
	// Output ports
	output [4:0] Z ;				// Outputs number of leading noughts

	// Mapping to number of leading noughts (Ugly way to do this)
	assign Z = ( 
		A[25] ? 5'b00000 : 
		A[24] ? 5'b00001 : 
		A[23] ? 5'b00010 : 
		A[22] ? 5'b00011 : 
		A[21] ? 5'b00100 : 
		A[20] ? 5'b00101 : 
		A[19] ? 5'b00110 : 
		A[18] ? 5'b00111 :
		A[17] ? 5'b01000 :
		A[16] ? 5'b01000 :
		A[15] ? 5'b01010 :
		A[14] ? 5'b01011 :
		A[13] ? 5'b01100 :
		A[12] ? 5'b01101 :
		A[11] ? 5'b01110 :
		A[10] ? 5'b01111 :
		A[9] ? 5'b10000 :
		A[8] ? 5'b10001 :
		A[7] ? 5'b10010 :
		A[6] ? 5'b10011 :
		A[5] ? 5'b10100 :
		A[4] ? 5'b10101 :
		A[3] ? 5'b10110 :
		A[2] ? 5'b10111 :
		A[1] ? 5'b11000 :
		A[0] ? 5'b11001 : 5'b11010
	);

endmodule