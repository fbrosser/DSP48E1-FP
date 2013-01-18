`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    08:40:21 09/19/2012 
// Module Name:    FPMult
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
//////////////////////////////////////////////////////////////////////////////////

module FPMult(
		clk,
		rst,
		a,
		b,
		result,
		flags
    );
	
	// Input Ports
	input clk ;							// Clock
	input rst ;							// Reset signal
	input [31:0] a;					// Input A, a 32-bit floating point number
	input [31:0] b;					// Input B, a 32-bit floating point number
	
	// Output ports
	output [31:0] result ;					// Product, result of the operation, 32-bit FP number
	output [4:0] flags ;				// Flags indicating exceptions according to IEEE754
	
	// Internal signals
	wire [31:0] Z_int ;				// Product, result of the operation, 32-bit FP number
	wire [4:0] Flags_int ;			// Flags indicating exceptions according to IEEE754
	
	wire Sa ;							// A's sign
	wire Sb ;							// B's sign
	wire Sp ;							// Product sign
	wire [7:0] Ea ;					// A's exponent
	wire [7:0] Eb ;					// B's exponent
	wire [8:0] Ep ;					// Product exponent
	wire [47:0] Mp ;					// Product mantissa
	wire [4:0] InputExc ;			// Exceptions in inputs
	wire [22:0] NormM ;				// Normalized mantissa
	wire [8:0] NormE ;				// Normalized exponent
	wire [23:0] RoundM ;				// Normalized mantissa
	wire [8:0] RoundE ;				// Normalized exponent
	wire [23:0] RoundMP ;				// Normalized mantissa
	wire [8:0] RoundEP ;				// Normalized exponent
	wire GRS ;

	reg [63:0] pipe_0;			// Pipeline register Input->Prep
	reg [92:0] pipe_1;			// Pipeline register Prep->Execute
	reg [38:0] pipe_2;			// Pipeline register Execute->Normalize
	reg [72:0] pipe_3;			// Pipeline register Normalize->Round
	reg [36:0] pipe_4;			// Pipeline register Round->Output
	
	assign result = pipe_4[36:5] ;
	assign flags = pipe_4[4:0] ;
	
	// Prepare the operands for alignment and check for exceptions
	FPMult_PrepModule PrepModule(clk, rst, pipe_0[63:32], pipe_0[31:0], Sa, Sb, Ea[7:0], Eb[7:0], Mp[47:0], InputExc[4:0]) ;
	
	// Perform (unsigned) mantissa multiplication
	FPMult_ExecuteModule ExecuteModule(pipe_1[92:70], pipe_1[69:53], pipe_1[52:5], pipe_1[68:61], pipe_1[60:53], pipe_1[70], pipe_1[69], Sp, NormE[8:0], NormM[22:0], GRS) ;

	// Round result and if necessary, perform a second (post-rounding) normalization step
	FPMult_NormalizeModule NormalizeModule(pipe_2[22:0], pipe_2[31:23], RoundE[8:0], RoundEP[8:0], RoundM[23:0], RoundMP[23:0]) ;		

	// Round result and if necessary, perform a second (post-rounding) normalization step
	FPMult_RoundModule RoundModule(pipe_3[47:24], pipe_3[23:0], pipe_3[65:57], pipe_3[56:48], pipe_3[66], pipe_3[67], pipe_3[72:68], Z_int[31:0], Flags_int[4:0]) ;		

	always @ (posedge clk) begin	
		if(rst) begin
			pipe_0 <= 0;
			pipe_1 <= 0;
			pipe_2 <= 0; 
			pipe_3 <= 0;
			pipe_4 <= 0;
		end 
		else begin		
			/* PIPE 0
				[63:32] A
				[31:0] B
			*/
			pipe_0 <= {a, b} ;
			/* PIPE 1
				[70] Sa
				[69] Sb
				[68:61] Ea
				[60:53] Eb
				[52:5] Mp
				[4:0] InputExc
			*/
			pipe_1 <= {pipe_0[54:32], pipe_0[16:0], Sa, Sb, Ea[7:0], Eb[7:0], Mp[47:0], InputExc[4:0]} ;
			/* PIPE 2
				[38:34] InputExc
				[33] GRS
				[32] Sp
				[31:23] NormE
				[22:0] NormM
			*/
			pipe_2 <= {pipe_1[4:0], GRS, Sp, NormE[8:0], NormM[22:0]} ;
			/* PIPE 3
				[72:68] InputExc
				[67] GRS
				[66] Sp	
				[65:57] RoundE
				[56:48] RoundEP
				[47:24] RoundM
				[23:0] RoundMP
			*/
			pipe_3 <= {pipe_2[38:32], RoundE[8:0], RoundEP[8:0], RoundM[23:0], RoundMP[23:0]} ;
			/* PIPE 4
				[36:5] Z
				[4:0] Flags
			*/				
			pipe_4 <= {Z_int[31:0], Flags_int[4:0]} ;
		end
	end
		
endmodule
