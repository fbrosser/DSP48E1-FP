`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:50:05 10/16/2012 
// Module Name:    FPAddSub_Pipelined_Simplified_2_0_AlignModule3 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 The pre-alignment module is responsible for taking the inputs
//							apart, checking the parts for exceptions and feeding them to
//							the alignment module.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_Pipelined_Simplified_2_0_AlignModule3(
		MminP,
		Shift,
		Mmin,
		G,
		PS
	);
	
	// Input ports
	input [31:0] MminP ;						// Smaller mantissa after 16|12|8|4 shift
	input [4:0] Shift ;						// Shift amount
	// Output ports
	output [24:0] Mmin ;						// The smaller mantissa
	output G ;									// Guard bit (retained from shifted out bits)
	output PS ;									// Pre-Sticky bit (OR of shifted out bits)
	
	reg	  [31:0]		Lvl3 = 0;
	wire    [63:0]    Stage2;	
	integer           j;               // loop variables
	
	assign Stage2 = {MminP, MminP};

	always @(*) begin    // rotate {0 | 1 | 2 | 3} bits
	  case (Shift[1:0])
		  2'b00:  Lvl3 <= Stage2[31:0];       											// rotate by 0?
		  2'b01:  begin for (j=0; j<=31; j=j+1)  begin Lvl3[j] <= Stage2[j+1]; end Lvl3[31] <= 0; end //(j < 30 ? Stage2[j+1] : 1'b0); 
		  2'b10:  begin for (j=0; j<=31; j=j+1)  begin Lvl3[j] <= Stage2[j+2]; end Lvl3[31:30] <= 0; end 
		  2'b11:  begin for (j=0; j<=31; j=j+1)  begin Lvl3[j] <= Stage2[j+3]; end Lvl3[31:29] <= 0; end 	  
	  endcase
	end
	
	// Assign G and PS bits
	assign G  = Lvl3[6] ;								// Buffer bit from smaller mantissa
	assign PS = |Lvl3[5:0] ;							// Check for lost bits from rounding	
	
	// Assign outputs
	assign Mmin = {Lvl3[31:7]};						// Take out smaller mantissa				

endmodule
