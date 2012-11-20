`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    16:50:05 10/16/2012 
// Module Name:    FPAddSub_AlignShift2
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Alignment shift stage 2, performs 3|2|1 shift
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_AlignShift2(
		MminP,
		Shift,
		Mmin
	);
	
	// Input ports
	input [31:0] MminP ;						// Smaller mantissa after 16|12|8|4 shift
	input [4:0] Shift ;						// Shift amount
	
	// Output ports
	output [24:0] Mmin ;						// The smaller mantissa
	
	// Internal Signal
	reg	  [31:0]		Lvl3 = 0;
	wire    [63:0]    Stage2;	
	integer           j;               // Loop variable
	
	assign Stage2 = {MminP, MminP};

	always @(*) begin    // Rotate {0 | 1 | 2 | 3} bits
	  case (Shift[1:0])
			// Rotate by 0
			2'b00:  Lvl3 <= Stage2[31:0];   
			// Rotate by 1
			2'b01:  begin for (j=0; j<=31; j=j+1)  begin Lvl3[j] <= Stage2[j+1]; end Lvl3[31] <= 0; end 
			// Rotate by 2
			2'b10:  begin for (j=0; j<=31; j=j+1)  begin Lvl3[j] <= Stage2[j+2]; end Lvl3[31:30] <= 0; end 
			// Rotate by 3
			2'b11:  begin for (j=0; j<=31; j=j+1)  begin Lvl3[j] <= Stage2[j+3]; end Lvl3[31:29] <= 0; end 	  
	  endcase
	end
	
	// Assign output
	assign Mmin = {Lvl3[31:7]};						// Take out smaller mantissa				

endmodule
