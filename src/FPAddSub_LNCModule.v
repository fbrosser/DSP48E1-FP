`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    15:18:29 09/07/2012
// Module Name:    FBAddSub_LNCModule 
// Project Name: 	 CHiPES Project
// Author:			 Fredrik Brosser
//
// Description:	 Leading Nought Counter - Module for counting the number of leading
//						 noughts in a bit vector, i.e. #bits until first 1, starting from MSB
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_LNCModule(
		A,
		Z
    );

	// Input ports
	input [31:0] A ;						// 32-bit input bit vector
	
	// Output ports
	output [5:0] Z ;						// Outputs number of leading noughts

	// Mapping to number of leading noughts (Ugly way to do this)
	assign Z = ( 
		A[31] ? 0 : 
		A[30] ? 1 : 
		A[29] ? 2 : 
		A[28] ? 3 : 
		A[27] ? 4 : 
		A[26] ? 5 : 
		A[25] ? 6 : 
		A[24] ? 7 : 
		A[23] ? 8 : 
		A[22] ? 9 : 
		A[21] ? 10 : 
		A[20] ? 11 : 
		A[19] ? 12 : 
		A[18] ? 13 :
		A[17] ? 14 :
		A[16] ? 15 :
		A[15] ? 16 :
		A[14] ? 17 :
		A[13] ? 18 :
		A[12] ? 19 :
		A[11] ? 20 :
		A[10] ? 21 :
		A[9] ? 22 :
		A[8] ? 23 :
		A[7] ? 24 :
		A[6] ? 25 :
		A[5] ? 26 :
		A[4] ? 27 :
		A[3] ? 28 :
		A[2] ? 29 :
		A[1] ? 30 :
		A[0] ? 31 : 32
	);

endmodule
