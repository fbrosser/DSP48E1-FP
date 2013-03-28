`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    01:56:20 09/07/2012 
// Module Name:    FPAddSub
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Top Module for a 32-bit floating point adder/subtractor.
//						 Follows the IEEE754 Single Precision standard.
//						 Supports only the default rounding mode.
//
//	Inputs:
//				a (32 bits)			: Single precision IEEE754 floating point number
//				b (32 bits)			: Single precision IEEE754 floating point number
//				operation (1 bit)	: Single control bit. 0/Addition, 1/Subtraction
//
//
// Outputs:
//				result (32 bits)	: Result of the operation, in IEEE754 Single format
//				flags	 (5 bits)	: Flags indicating exceptions:
//											Bit 4: Overflow
//											Bit 3: Underflow
//											Bit 2: Divide by Zero
//											Bit 1: Invalid/NaN
//											Bit 0: Inexact
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub(
		clk,
		rst,
		a,
		b,
		operation,
		result,
		flags
	);
	
	// Clock and reset
	input clk ;										// Clock signal
	input rst ;										// Reset (active high, resets pipeline registers)
	
	// Input ports
	input [31:0] a ;								// Input A, a 32-bit floating point number
	input [31:0] b ;								// Input B, a 32-bit floating point number
	input operation ;								// Operation select signal
	
	// Output ports
	output [31:0] result ;						// Result of the operation
	output [4:0] flags ;							// Flags indicating exceptions according to IEEE754
	
	// Pipeline Registers
	reg [79:0] pipe_1;							// Pipeline register PreAlign->Align1
	reg [67:0] pipe_2;							// Pipeline register Align1->Align3
	reg [76:0] pipe_3;							// Pipeline register Align1->Align3
	reg [69:0] pipe_4;							// Pipeline register Align3->Execute
	reg [51:0] pipe_5;							// Pipeline register Execute->Normalize
	reg [56:0] pipe_6;							// Pipeline register Nomalize->NormalizeShift1
	reg [56:0] pipe_7;							// Pipeline register NormalizeShift2->NormalizeShift3
	reg [54:0] pipe_8;							// Pipeline register NormalizeShift3->Round
	reg [40:0] pipe_9;							// Pipeline register NormalizeShift3->Round
	
	// Internal wires between modules
	wire [30:0] Aout_0 ;							// A - sign
	wire [30:0] Bout_0 ;							// B - sign
	wire Opout_0 ;									// A's sign
	wire Sa_0 ;										// A's sign
	wire Sb_0 ;										// B's sign
	wire MaxAB_1 ;									// Indicates the larger of A and B(0/A, 1/B)
	wire [7:0] CExp_1 ;							// Common Exponent
	wire [4:0] Shift_1 ;							// Number of steps to smaller mantissa shift right (align)
	wire [22:0] Mmax_1 ;							// Larger mantissa
	wire [4:0] InputExc_0 ;						// Input numbers are exceptions
	wire [9:0] ShiftDet_0 ;
	wire [22:0] MminS_1 ;						// Smaller mantissa after 0/16 shift
	wire [23:0] MminS_2 ;						// Smaller mantissa after 0/4/8/12 shift
	wire [23:0] Mmin_3 ;							// Smaller mantissa after 0/1/2/3 shift
	wire [32:0] Sum_4 ;
	wire PSgn_4 ;
	wire Opr_4 ;
	wire [4:0] Shift_5 ;							// Number of steps to shift sum left (normalize)
	wire [32:0] SumS_5 ;							// Sum after 0/16 shift
	wire [32:0] SumS_6 ;							// Sum after 0/16 shift
	wire [32:0] SumS_7 ;							// Sum after 0/16 shift
	wire [22:0] NormM_8 ;						// Normalized mantissa
	wire [8:0] NormE_8;							// Adjusted exponent
	wire ZeroSum_8 ;								// Zero flag
	wire NegE_8 ;									// Flag indicating negative exponent
	wire R_8 ;										// Round bit
	wire S_8 ;										// Final sticky bit
	wire FG_8 ;										// Final sticky bit
	wire [31:0] P_int ;
	wire EOF ;
	
	// Prepare the operands for alignment and check for exceptions
	FPAddSub_PrealignModule PrealignModule
	(	// Inputs
		a, b, operation,
		// Outputs
		Sa_0, Sb_0, ShiftDet_0[9:0], InputExc_0[4:0], Aout_0[30:0], Bout_0[30:0], Opout_0) ;
		
	// Prepare the operands for alignment and check for exceptions
	FPAddSub_AlignModule AlignModule
	(	// Inputs
		pipe_1[78:48], pipe_1[47:17], pipe_1[14:5],
		// Outputs
		CExp_1[7:0], MaxAB_1, Shift_1[4:0], MminS_1[22:0], Mmax_1[22:0]) ;	

	// Alignment Shift Stage 1
	FPAddSub_AlignShift1 AlignShift1
	(  // Inputs
		pipe_2[22:0], pipe_2[55:53],
		// Outputs
		MminS_2[23:0]) ;

	// Alignment Shift Stage 3 and compution of guard and sticky bits
	FPAddSub_AlignShift2 AlignShift2  
	(  // Inputs
		pipe_3[23:0], pipe_3[53:52],
		// Outputs
		Mmin_3[23:0]) ;
						
	// Perform mantissa addition
	FPAddSub_ExecutionModule ExecutionModule
	(  // Inputs
		pipe_4[51:29], pipe_4[23:0], pipe_4[67], pipe_4[66], pipe_4[65], pipe_4[68],
		// Outputs
		Sum_4[32:0], PSgn_4, Opr_4) ;
	
	// Prepare normalization of result
	FPAddSub_NormalizeModule NormalizeModule
	(  // Inputs
		pipe_5[32:0], 
		// Outputs
		SumS_5[32:0], Shift_5[4:0]) ;
					
	// Normalization Shift Stage 1
	FPAddSub_NormalizeShift1 NormalizeShift1
	(  // Inputs
		pipe_6[32:0], pipe_6[54:51],
		// Outputs
		SumS_7[32:0]) ;
		
	// Normalization Shift Stage 3 and final guard, sticky and round bits
	FPAddSub_NormalizeShift2 NormalizeShift2
	(  // Inputs
		pipe_7[32:0], pipe_7[45:38], pipe_7[55:51],
		// Outputs
		NormM_8[22:0], NormE_8[8:0], ZeroSum_8, NegE_8, R_8, S_8, FG_8) ;

	// Round and put result together
	FPAddSub_RoundModule RoundModule
	(  // Inputs
		 pipe_8[3], pipe_8[12:4], pipe_8[35:13], pipe_8[1], pipe_8[0], pipe_8[54], pipe_8[51], pipe_8[50], pipe_8[53], pipe_8[49], 
		// Outputs
		P_int[31:0], EOF) ;
	
	// Check for exceptions
	FPAddSub_ExceptionModule Exceptionmodule
	(  // Inputs
		pipe_9[40:9], pipe_9[8], pipe_9[7], pipe_9[6], pipe_9[5:1], pipe_9[0], 
		// Outputs
		result[31:0], flags[4:0]) ;			
	
	always @ (posedge clk) begin	
		if(rst) begin
			pipe_1 <= 0;
			pipe_2 <= 0;
			pipe_3 <= 0;
			pipe_4 <= 0;
			pipe_5 <= 0;
			pipe_6 <= 0;
			pipe_7 <= 0;
			pipe_8 <= 0;
			pipe_9 <= 0;
		end 
		else begin
		
			pipe_1 <= {Opout_0, Aout_0[30:0], Bout_0[30:0], Sa_0, Sb_0, ShiftDet_0[9:0], InputExc_0[4:0]} ;	
			/* PIPE_2 :
				[67] operation
				[66] Sa_0
				[65] Sb_0
				[64] MaxAB_0
				[63:56] CExp_0
				[55:51] Shift_0
				[50:28] Mmax_0
				[27:23] InputExc_0
				[22:0] MminS_1
			*/
			pipe_2 <= {pipe_1[79], pipe_1[16:15], MaxAB_1, CExp_1[7:0], Shift_1[4:0], Mmax_1[22:0], pipe_1[4:0], MminS_1[22:0]} ;	
			/* PIPE_3 :
				[68] operation
				[67] Sa_0
				[66] Sb_0
				[65] MaxAB_0
				[64:57] CExp_0
				[56:52] Shift_0
				[51:29] Mmax_0
				[28:24] InputExc_0
				[23:0] MminS_1
			*/
			pipe_3 <= {pipe_2[67:23], MminS_2[23:0]} ;	
			/* PIPE_4 :
				[68] operation
				[67] Sa_0
				[66] Sb_0
				[65] MaxAB_0
				[64:57] CExp_0
				[56:52] Shift_0
				[51:29] Mmax_0
				[28:24] InputExc_0
				[23:0] Mmin_3
			*/					
			pipe_4 <= {pipe_3[68:24], Mmin_3[23:0]} ;	
			/* PIPE_5 :
				[51] operation
				[50] PSgn_4
				[49] Opr_4
				[48] Sa_0
				[47] Sb_0
				[46] MaxAB_0
				[45:38] CExp_0
				[37:33] InputExc_0
				[32:0] Sum_4
			*/					
			pipe_5 <= {pipe_4[68], PSgn_4, Opr_4, pipe_4[67:57], pipe_4[28:24], Sum_4[32:0]} ;
			/* PIPE_6 :
				[56] operation
				[55:51] Shift_5
				[50] PSgn_4
				[49] Opr_4
				[48] Sa_0
				[47] Sb_0
				[46] MaxAB_0
				[45:38] CExp_0
				[37:33] InputExc_0
				[32:0] Sum_4
			*/					
			pipe_6 <= {pipe_5[51], Shift_5[4:0], pipe_5[50:33], SumS_5[32:0]} ;	
			/* pipe_7 :
				[56] operation
				[55:51] Shift_5
				[50] PSgn_4
				[49] Opr_4
				[48] Sa_0
				[47] Sb_0
				[46] MaxAB_0
				[45:38] CExp_0
				[37:33] InputExc_0
				[32:0] Sum_4
			*/						
			pipe_7 <= {pipe_6[56:33], SumS_7[32:0]} ;	
			/* pipe_8:
				[54] FG_8 
				[53] operation
				[52] PSgn_4
				[51] Sa_0
				[50] Sb_0
				[49] MaxAB_0
				[48:41] CExp_0
				[40:36] InputExc_8
				[35:13] NormM_8 
				[12:4] NormE_8
				[3] ZeroSum_8
				[2] NegE_8
				[1] R_8
				[0] S_8
			*/				
			pipe_8 <= {FG_8, pipe_7[56], pipe_7[50], pipe_7[48:33], NormM_8[22:0], NormE_8[8:0], ZeroSum_8, NegE_8, R_8, S_8} ;	
			/* pipe_9:
				[40:9] P_int
				[8] NegE_8
				[7] R_8
				[6] S_8
				[5:1] InputExc_8
				[0] EOF
			*/				
			pipe_9 <= {P_int[31:0], pipe_8[2], pipe_8[1], pipe_8[0], pipe_8[40:36], EOF} ;	
		end
	end		
	
endmodule
