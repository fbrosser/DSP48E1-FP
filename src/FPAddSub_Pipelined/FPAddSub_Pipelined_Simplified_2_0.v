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
//
//	Inputs:
//						 A (32 bit)		: Single precision IEEE754 floating point number
//						 B (32 bit)		: Single precision IEEE754 floating point number
//						 Ctrl (1 bit)	: Control signals, consisting of the following fields (from MSB to LSB):
//												Bit 0: 	Operation mode (1 bit): 0 	- Addition
//																							1 	- Subtraction
//
//
// Outputs:
//						Z (32 bit)		: Result of the operation, in IEEE754 Single format
//						Flags (5 bit)	: Flags indicating exceptions according to IEEE754 (from MSB to LSB):
//													Bit 4: Overflow
//													Bit 3: Underflow
//													Bit 2: Divide by Zero
//													Bit 1: Invalid/NaN
//													Bit 0: Inexact
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub(
		clk,
		rst,
		A,
		B,
		Ctrl,
		Z,
		Flags
	);
	
	// Clock and reset
	input clk ;						// Clock signal
	input rst ;						// Reset (active high, resets pipeline registers)
	
	// Input ports
	input [31:0] A ;				// Input A, a 32-bit floating point number
	input [31:0] B ;				// Input B, a 32-bit floating point number
	input Ctrl ;					// Control signal
	
	// Output ports
	output [31:0] Z ;				// Result of the operation
	output [4:0] Flags ;			// Flags indicating exceptions according to IEEE754
	
	// Pipeline Registers
	reg [64:0] pipe_0;// = 0;			// Pipeline register Input->PreAlign
	reg [78:0] pipe_1;// = 0;			// Pipeline register PreAlign->Align1
	reg [78:0] pipe_2;// = 0;			// Pipeline register Align1->Align2
	reg [78:0] pipe_3;// = 0;			// Pipeline register Align2->Align3
	reg [78:0] pipe_4;// = 0;			// Pipeline register Align3->Execute
	reg [46:0] pipe_5;// = 0;			// Pipeline register Execute->Normalize
	reg [51:0] pipe_6;// = 0;			// Pipeline register Nomalize->NormalizeShift1
	reg [51:0] pipe_7;// = 0;			// Pipeline register NormalizeShift1->NormalizeShift2
	reg [51:0] pipe_8;// = 0;			// Pipeline register NormalizeShift2->NormalizeShift3
	reg [63:0] pipe_9;// = 0;			// Pipeline register NormalizeShift3->Round
	reg [36:0] pipe_10;// = 0;			// Pipeline register NormalizeShift3->Round
	
	// Internal wires between modules
	wire Sa_0 ;										// A's sign
	wire Sb_0 ;										// B's sign
	wire MaxAB_0 ;									// Indicates the larger of A and B(0/A, 1/B)
	wire [7:0] CExp_0 ;							// Common Exponent
	wire [4:0] Shift_0 ;							// Number of steps to smaller mantissa shift right (align)
	wire [24:0] Mmax_0 ;							// Larger mantissa
	wire [4:0] InputExc_0 ;						// Input numbers are exceptions
	
	wire [31:0] MminS_0 ;						// Smaller mantissa after 0/16 shift
	
	wire [31:0] MminS_1 ;						// Smaller mantissa after 0/16 shift
	
	wire [31:0] MminS_2 ;						// Smaller mantissa after 0/4/8/12 shift
	
	wire [24:0] Mmin_3 ;							// Smaller mantissa after 0/1/2/3 shift
	wire G_3 ;										//Guard bit
	wire PS_3 ;										// Pre-sticky bit
	
	wire [25:0] Sum_4 ;
	wire PSgn_4 ;
	wire Opr_4 ;
	
	wire [4:0] Shift_5 ;							// Number of steps to shift sum left (normalize)
	wire [25:0] SumS_5 ;							// Sum after 0/16 shift

	wire [25:0] SumS_6 ;							// Sum after 0/16 shift
	
	wire [25:0] SumS_7 ;							// Sum after 0/16 shift
	
	wire [22:0] NormM_8 ;							// Normalized mantissa
	//wire [8:0] NormE_8;							// Adjusted exponent
	wire [8:0] ExpOK_8 ;							//  exponent
	wire [8:0] ExpOF_8 ;							//  exponent
	wire MSBShift_8 ;
	
	wire ZeroSum_8 ;								// Zero flag
	wire NegE_8 ;									// Flag indicating negative exponent
	wire R_8 ;										// Round bit
	wire S_8 ;										// Final sticky bit
	
	wire [31:0] Z_int ;
	wire [4:0] Flags_int ;
	
	assign Z = pipe_10[31:0] ;
	assign Flags = pipe_10[36:32] ;
	
	// Prepare the operands for alignment and check for exceptions
	FPAddSub_Pipelined_Simplified_2_0_PreAlignModule PreAlignModule
	(	
		// Inputs
		pipe_0[63:32], pipe_0[31:0],
		// Outputs
		Sa_0, Sb_0, CExp_0[7:0], MaxAB_0, Shift_0[4:0], MminS_0[31:0], Mmax_0[24:0], InputExc_0[4:0]
	) ;

	// Alignment Shift Stage 1
	FPAddSub_Pipelined_Simplified_2_0_AlignModule1 AlignShiftStage1
	(
		// Inputs
		pipe_1[31:0], pipe_1[66:62],
		// Outputs
		MminS_1[31:0]
	) ;

	// Alignment Shift Stage 2
	FPAddSub_Pipelined_Simplified_2_0_AlignModule2 AlignShiftStage2
	(
		// Inputs
		pipe_2[31:0], pipe_2[66:62],
		// Outputs
		MminS_2[31:0]	
	) ;

	// Alignment Shift Stage 3 and compution of guard and sticky bits
	FPAddSub_Pipelined_Simplified_2_0_AlignModule3 AlignShiftStage3
	(
		// Inputs
		pipe_3[31:0], pipe_3[66:62],
		// Outputs
		Mmin_3[24:0], G_3, PS_3
	) ;
	
	// Perform mantissa addition
	FPAddSub_Pipelined_Simplified_2_0_ExecutionModule ExecutionModule
	(
		// Inputs
		pipe_4[61:37], pipe_4[24:0], pipe_4[77], pipe_4[76], pipe_4[75], pipe_4[78], pipe_4[26], pipe_4[25],
		// Outputs
		Sum_4[25:0], PSgn_4, Opr_4
	) ;
	
	// Prepare normalization of result
	FPAddSub_Pipelined_Simplified_2_0_NormalizeModule NormalizeModule
	(
		// Inputs
		pipe_5[25:0], 
		// Outputs
		SumS_5[25:0], Shift_5[4:0]
		) ;
		
	// Normalization Shift Stage 1
	FPAddSub_Pipelined_Simplified_2_0_NormalizeShiftModule1 NormalizeShiftStage1
	(
		// Inputs
		pipe_6[25:0], pipe_6[50:46],
		// Outputs
		SumS_6[25:0]
	) ;
	
	// Normalization Shift Stage 2
	FPAddSub_Pipelined_Simplified_2_0_NormalizeShiftModule2 NormalizeShiftStage2
	(
		// Inputs
		pipe_7[25:0], pipe_7[50:46],
		// Outputs
		SumS_7[25:0]
	) ;
	
	// Normalization Shift Stage 3 and final guard, sticky and round bits
	FPAddSub_Pipelined_Simplified_2_0_NormalizeShiftModule3 NormalizeShiftStage3
	(
		// Inputs
		pipe_8[25:0],
		pipe_8[27],
		pipe_8[26],
		pipe_8[40:33],
		pipe_8[44],
		pipe_8[50:46],
		// Outputs
		NormM_8[22:0],					// Normalized mantissa
		//NormE_8[8:0],					// Adjusted exponent
		ExpOK_8[8:0], 
		ExpOF_8[8:0],
		MSBShift_8,
		ZeroSum_8,						// Zero flag
		NegE_8,							// Flag indicating negative exponent
		R_8,								// Round bit
		S_8								// Final sticky bit
	) ;
		
					/* PIPE_9 NEW:
				[63] MSBShift_8
				[62] Ctrl
				[61] PSgn_4
				[60] Sa_0
				[59] Sb_0
				[58] MaxAB_0
				[57:50] CExp_0
				[49:45] InputExc_8
				[44:22] NormM_8
				[21:13] ExpOK 
				[12:4] ExpOF
				[3] ZeroSum_8
				[2] NegE_8
				[1] R_8
				[0] S_8
			*/		
	// Round and put result together and check for exceptions
	FPAddSub_Pipelines_Simplified_2_0_RoundModule RoundModule
	(
		// Inputs
		pipe_9[63], pipe_9[21:13], pipe_9[12:4], pipe_9[3], pipe_9[52], pipe_9[2], pipe_9[35:13], pipe_9[1], pipe_9[0], pipe_9[51], pipe_9[50], pipe_9[40:36], pipe_9[53], pipe_9[49],
		// Outputs
		Z_int[31:0],
		Flags_int[4:0]	
	) ;
	
	always @ (posedge clk) begin	
		if(rst) begin
			pipe_0 <= 0;
			//pipe_1 <= 0;
			///pipe_2 <= 0;
			//pipe_3 <= 0;
			//pipe_4 <= 0;
			//pipe_5 <= 0;
			//pipe_6 <= 0;
			//pipe_7 <= 0;
			//pipe_8 <= 0;
			//pipe_9 <= 0;
		end 
		else begin
		
			/* PIPE_0 :
				[64] Ctrl
				[63:32] A
				[31:0] B
			*/
			pipe_0 <= {Ctrl, A, B} ;	
			/* PIPE_1 :
				[78] Ctrl
				[77] Sa_0
				[76] Sb_0
				[75] MaxAB_0
				[74:67] CExp_0
				[66:62] Shift_0
				[61:37] Mmax_0
				[36:32] InputExc_0
				[31:0] MminS_0
			*/
			pipe_1 <= {pipe_0[64], Sa_0, Sb_0, MaxAB_0, CExp_0[7:0], Shift_0[4:0], Mmax_0[24:0], InputExc_0[4:0], MminS_0[31:0]} ;	
			/* PIPE_2 :
				[78] Ctrl
				[77] Sa_0
				[76] Sb_0
				[75] MaxAB_0
				[74:67] CExp_0
				[66:62] Shift_0
				[61:37] Mmax_0
				[36:32] InputExc_0
				[31:0] MminS_1
			*/
			pipe_2 <= {pipe_1[78:32], MminS_1[31:0]} ;			
			/* PIPE_3 :
				[78] Ctrl
				[77] Sa_0
				[76] Sb_0
				[75] MaxAB_0
				[74:67] CExp_0
				[66:62] Shift_0
				[61:37] Mmax_0
				[36:32] InputExc_0
				[31:0] MminS_2
			*/			
			pipe_3 <= {pipe_2[78:32], MminS_2[31:0]} ;	
			/* PIPE_4 :
				[78] Ctrl
				[77] Sa_0
				[76] Sb_0
				[75] MaxAB_0
				[74:67] CExp_0
				[66:62] Shift_0
				[61:37] Mmax_0
				[36:32] InputExc_0
				[31:27] 00000
				[26] G_3
				[25] PS_3
				[24:0] Mmin_3
			*/					
			pipe_4 <= {pipe_3[78:32], 5'b0, G_3, PS_3, Mmin_3[24:0]} ;	
			/* PIPE_5 :
				[46] Ctrl
				[45] PSgn_4
				[44] Opr_4
				[43] Sa_0
				[42] Sb_0
				[41] MaxAB_0
				[40:33] CExp_0
				[32:28] InputExc_0
				[27] G_3
				[26] PS_3
				[25:0] Sum_4
			*/					
			pipe_5 <= {pipe_4[78], PSgn_4, Opr_4, pipe_4[77:67], pipe_4[36:32], pipe_4[26:25], Sum_4[25:0]} ;	
			/* PIPE_6 :
				[51] Ctrl
				[50:46] Shift_5
				[45] PSgn_4
				[44] Opr_4
				[43] Sa_0
				[42] Sb_0
				[41] MaxAB_0
				[40:33] CExp_0
				[32:28] InputExc_0
				[27] G_3
				[26] PS_3
				[25:0] Sum_5
			*/					
			pipe_6 <= {pipe_5[46], Shift_5[4:0], pipe_5[45:26], SumS_5[25:0]} ;	
			/* PIPE_7 :
				[51] Ctrl
				[50:46] Shift_5
				[45] PSgn_4
				[44] Opr_4
				[43] Sa_0
				[42] Sb_0
				[41] MaxAB_0
				[40:33] CExp_0
				[32:28] InputExc_0
				[27] G_3
				[26] PS_3
				[25:0] Sum_6
			*/					
			pipe_7 <= {pipe_6[51:26], SumS_6[25:0]} ;	
			/* PIPE_8 :
				[51] Ctrl
				[50:46] Shift_5
				[45] PSgn_4
				[44] Opr_4
				[43] Sa_0
				[42] Sb_0
				[41] MaxAB_0
				[40:33] CExp_0
				[32:28] InputExc_0
				[27] G_3
				[26] PS_3
				[25:0] Sum_7
			*/				
		
			pipe_8 <= {pipe_7[51:26], SumS_7[25:0]} ;	
			/* PIPE_9 OLD:
				[53] Ctrl
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
			/* PIPE_9 NEW:
				[63] MSBShift_8
				[62] Ctrl
				[61] PSgn_4
				[60] Sa_0
				[59] Sb_0
				[58] MaxAB_0
				[57:50] CExp_0
				[49:45] InputExc_8
				[44:22] NormM_8
				[21:13] ExpOK 
				[12:4] ExpOF
				[3] ZeroSum_8
				[2] NegE_8
				[1] R_8
				[0] S_8
			*/							
			pipe_9 <= {MSBShift_8, pipe_8[51], pipe_8[45], pipe_8[43:28], NormM_8[22:0], ExpOK_8[8:0], ExpOF_8[8:0], ZeroSum_8, NegE_8, R_8, S_8} ;	
		
			pipe_10 <= {Flags_int[4:0], Z_int[31:0]} ;	
		end
	end		

endmodule
