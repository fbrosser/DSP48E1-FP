`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:49:36 10/16/2012 
// Module Name:    FPAddSub_Pipelined_Simplified_2_0_AlignModule1 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Shift Stage 1
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_Pipelined_Simplified_2_0_NormalizeShiftModule1(
		MminP,
		Shift,
		Mmin
	);
	
	// Input ports
	input [25:0] MminP ;						// Smaller mantissa after 16|12|8|4 shift
	input [4:0] Shift ;						// Shift amount
	// Output ports
	output [25:0] Mmin ;						// The smaller mantissa
	
	reg	  [25:0]		Lvl2 = 0;
	wire    [51:0]    Stage1;	
	integer           i;               // loop variables
	
	assign Stage1 = {MminP, MminP};

	always @(*) begin    // rotate {0 | 4 | 8 | 12} bits
	  case (Shift[3:2])
		  2'b00: Lvl2 <= Stage1[25:0];       											// rotate by 0?
		  2'b01: begin for (i=51; i>=26; i=i-1) begin Lvl2[i-26] <= Stage1[i-4]; end Lvl2[3:0] <= 0; end //Lvl2[i] <= (i < 21 ? Stage1[i+4] : 1'b0); 
		  2'b10: begin for (i=51; i>=26; i=i-1) begin Lvl2[i-26] <= Stage1[i-8]; end Lvl2[7:0] <= 0; end //Lvl2[i] <= (i < 17 ? Stage1[i+8] : 1'b0); 
		  2'b11: begin for (i=51; i>=26; i=i-1) begin Lvl2[i-26] <= Stage1[i-12]; end Lvl2[11:0] <= 0; end //Lvl2[i] <= (i < 13 ? Stage1[i+12] : 1'b0); 
	  endcase
	end
	
	// Assign outputs
	assign Mmin = Lvl2;						// Take out smaller mantissa							

endmodule

