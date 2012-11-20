`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:49:36 10/16/2012 
// Module Name:    FPAddSub_AlignShift1
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Alignment shift stage 1, performs 16|12|8|4 shift
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_AlignShift1(
		MminP,
		Shift,
		Mmin
	);
	
	// Input ports
	input [31:0] MminP ;						// Smaller mantissa after 16|12|8|4 shift
	input [4:0] Shift ;						// Shift amount
	
	// Output ports
	output [31:0] Mmin ;						// The smaller mantissa
	
	// Internal signals
	reg	  [31:0]		Lvl1 = 0;
	reg	  [31:0]		Lvl2 = 0;
	wire    [63:0]    Stage1;	
	integer           i;                // Loop variable
	
	always @(*) begin						
		// Rotate by 16?
		Lvl1 <= Shift[4] ? {16'b0, MminP[31:16]} : MminP; 
	end
	
	assign Stage1 = {Lvl1, Lvl1};
	
	always @(*) begin    					// Rotate {0 | 4 | 8 | 12} bits
	  case (Shift[3:2])
			// Rotate by 0	
			2'b00:  Lvl2 <= Stage1[31:0];       			
			// Rotate by 4	
			2'b01:  begin for (i=0; i<=31; i=i+1) begin Lvl2[i] <= Stage1[i+4]; end Lvl2[31:28] <= 0; end
			// Rotate by 8
			2'b10:  begin for (i=0; i<=31; i=i+1) begin Lvl2[i] <= Stage1[i+8]; end Lvl2[31:24] <= 0; end
			// Rotate by 12	
			2'b11:  begin for (i=0; i<=31; i=i+1) begin Lvl2[i] <= Stage1[i+12]; end Lvl2[31:20] <= 0; end
	  endcase
	end
	
	// Assign output to next shift stage
	assign Mmin = Lvl2;
	
endmodule
