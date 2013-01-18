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
	wire [23:0] Ma ;					// A's mantissa
	wire [23:0] Mb ;					// B's mantissa
	wire [47:0] Mp ;					// Product mantissa
	wire [4:0] InputExc ;			// Exceptions in inputs
	wire [22:0] NormM ;				// Normalized mantissa
	wire [8:0] NormE ;				// Normalized exponent
	wire G ;								// Guard bit
	wire R ;								// Round bit
	wire S ;								// Sticky bit

	reg [63:0] pipe_0;			// Pipeline register Input->Prep
	reg [70:0] pipe_1;			// Pipeline register Prep->Execute
	reg [62:0] pipe_2;			// Pipeline register Execute->Normalize
	reg [40:0] pipe_3;			// Pipeline register Normalize->Round
	reg [36:0] pipe_4;			// Pipeline register Round->Output
	
	assign result = pipe_4[36:5] ;
	assign flags = pipe_4[4:0] ;
	
	// Prepare the operands for alignment and check for exceptions
	FPMult_PrepModule PrepModule(pipe_0[63:32], pipe_0[31:0], Sa, Sb, Ea[7:0], Eb[7:0], Ma[23:0], Mb[23:0], InputExc[4:0]) ;
	
	// Compute new exponent and product sign
	//FPMult_ESExecuteModule ESExecuteModule(Ea[7:0], Eb[7:0], Sa, Sb, Ep[8:0], Sp) ;
	
	// Perform (unsigned) mantissa multiplication
	//FPMult_ExecuteModule ExecuteModule(Ma[23:0], Mb[23:0], Ea[7:0], Eb[7:0], Sa, Sb, Mp[47:0], Ep[8:0], Sp) ;
	FPMult_ExecuteModule ExecuteModule(clk, rst, pipe_1[52:29], pipe_1[28:5], pipe_1[68:61], pipe_1[60:53], pipe_1[70], pipe_1[69], Mp[47:0], Ep[8:0], Sp) ;
	
	// Normalize the result if there is overflow (MSB of mantissa set)
	//FPMult_NormalizeModule NormalizeModule(Mp[47:0], Ep[8:0], NormM[22:0], NormE[8:0], G, R, S) ;
	FPMult_NormalizeModule NormalizeModule(pipe_2[57:10], pipe_2[9:1], NormM[22:0], NormE[8:0], G, R, S) ;
	
	// Round result and if necessary, perform a second (post-rounding) normalization step
	//FPMult_RoundModule RoundModule(NormM[22:0], NormE[8:0], G, R, S, RoundM[22:0], RoundE[8:0]) ;
	FPMult_RoundModule RoundModule(pipe_3[34:12], pipe_3[11:3], pipe_3[2], pipe_3[1], pipe_3[0], pipe_3[35], pipe_3[40:36], Z_int[31:0], Flags_int[4:0]) ;		
			
	// Put the pieces together and check for exceptions
	//FPMult_ExceptionModule ExceptionModule(RoundM[22:0], RoundE[8:0], Sp, P_pipe[31:0]) ;
	
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
				[52:29] Ma
				[28:5] Mb
				[4:0] InputExc
			*/
			pipe_1 <= {Sa, Sb, Ea[7:0], Eb[7:0], Ma[23:0], Mb[23:0], InputExc[4:0]} ;
			/* PIPE 2
				[62:58] InputExc
				[57:10] Mp
				[9:1] Ep
				[0] Sp
			*/
			pipe_2 <= {pipe_1[4:0], Mp[47:0], Ep[8:0], Sp} ;
			/* PIPE 3
				[40:36] InputExc
				[35] Sp
				[34:12] NormM
				[11:3] NormE
				[2] G
				[1] R
				[0] S
			*/			
			pipe_3 <= {pipe_2[62:58], pipe_2[0], NormM[22:0], NormE[8:0], G, R, S} ;
			/* PIPE 4
				[36:5] Z
				[4:0] Flags
			*/				
			pipe_4 <= {Z_int[31:0], Flags_int[4:0]} ;
		end
	end
		
endmodule
