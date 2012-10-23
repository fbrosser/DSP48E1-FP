`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:49:45 10/16/2012
// Module Name:    FPAddSub_Pipelined_Simplified_2_0_AlignModule2 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 The pre-alignment module is responsible for taking the inputs
//							apart, checking the parts for exceptions and feeding them to
//							the alignment module.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_Pipelined_Simplified_2_0_NormalizeShiftModule2(
		MminP,
		Shift,
		Mmin
	);
	
	// Input ports
	input [25:0] MminP ;						// Smaller mantissa after 16|12|8|4 shift
	input [4:0] Shift ;						// Shift amount
	// Output ports
	output [25:0] Mmin ;						// The smaller mantissa
	
	reg	  [25:0]		Lvl3 = 0;
	wire    [51:0]    Stage2;	
	integer           i;               // loop variables
	
	assign Stage2 = {MminP, MminP};

	always @(*) begin    // rotate {0 | 1 | 2 | 3} bits
	  case (Shift[1:0])
		  2'b00:  Lvl3 <= Stage2[25:0];       											// rotate by 0?
		  2'b01: begin for (i=51; i>=26; i=i-1) begin Lvl3[(i-26)] <= Stage2[i-1]; end Lvl3[0] <= 0; end //Lvl3[i] <= (i < 24 ? Stage2[i+1] : 1'b0); 
		  2'b10: begin for (i=51; i>=26; i=i-1) begin Lvl3[i-26] <= Stage2[i-2]; end Lvl3[1:0] <= 0; end //Lvl3[i] <= (i < 23 ? Stage2[i+2] : 1'b0); 
		  2'b11: begin for (i=51; i>=26; i=i-1) begin Lvl3[i-26] <= Stage2[i-3]; end Lvl3[2:0] <= 0; end //Lvl3[i] <= (i < 22 ? Stage2[i+3] : 1'b0); 
	  endcase
	end
	
	// Assign outputs
	assign Mmin = Lvl3;						// Take out smaller mantissa						

endmodule

