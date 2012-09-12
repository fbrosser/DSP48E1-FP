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

module FPAddSub_LNCModule(
		A,
		Z
    );

	// Input ports
	input [25:0] A ;				// 32-bit input bit vector
	
	// Output ports
	output [5:0] Z ;				// Outputs number of leading noughts

	// Mapping to number of leading noughts (Ugly way to do this)
	assign Z = ( 
		A[25] ? 0 : 
		A[24] ? 1 : 
		A[23] ? 2 : 
		A[22] ? 3 : 
		A[21] ? 4 : 
		A[20] ? 5 : 
		A[19] ? 6 : 
		A[18] ? 7 :
		A[17] ? 8 :
		A[16] ? 9 :
		A[15] ? 10 :
		A[14] ? 11 :
		A[13] ? 12 :
		A[12] ? 13 :
		A[11] ? 14 :
		A[10] ? 15 :
		A[9] ? 16 :
		A[8] ? 17 :
		A[7] ? 18 :
		A[6] ? 19 :
		A[5] ? 20 :
		A[4] ? 21 :
		A[3] ? 22 :
		A[2] ? 23 :
		A[1] ? 24 :
		A[0] ? 25 : 26
	);

endmodule