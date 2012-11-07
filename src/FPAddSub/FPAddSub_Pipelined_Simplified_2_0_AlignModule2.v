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

module FPAddSub_Pipelined_Simplified_2_0_AlignModule2(
		MminP,
		Shift,
		Mmin
	);
	
	// Input ports
	input [31:0] MminP ;						// Smaller mantissa after 16|12|8|4 shift
	input [4:0] Shift ;						// Shift amount
	
	// Output ports
	output [31:0] Mmin ;						// The smaller mantissa
	
	reg	  [31:0]		Lvl2 = 0;
	wire    [63:0]    Stage1;	
	integer           i;               // loop variables
	
	assign Stage1 = {MminP, MminP};

	always @(*) begin    // rotate {0 | 1 | 2 | 3} bits
	  case (Shift[3:2])
		  2'b00:  Lvl2 <= Stage1[31:0];       											// rotate by 0?
		  2'b01:  begin for (i=0; i<=31; i=i+1) begin Lvl2[i] <= Stage1[i+4]; end Lvl2[31:27] <= 0; end 	//(i < 27 ? Stage1[i+4] : 1'b0); 
		  2'b10:  begin for (i=0; i<=31; i=i+1) begin Lvl2[i] <= Stage1[i+8]; end Lvl2[31:23] <= 0; end 	//(i < 23 ? Stage1[i+8] : 1'b0); 
		  2'b11:  begin for (i=0; i<=31; i=i+1) begin Lvl2[i] <= Stage1[i+12]; end Lvl2[31:19] <= 0; end 	//(i < 19 ? Stage1[i+12] : 1'b0); 
	  endcase
	end
	
	// Assign outputs
	assign Mmin = Lvl2;						// Take out smaller mantissa				

endmodule

