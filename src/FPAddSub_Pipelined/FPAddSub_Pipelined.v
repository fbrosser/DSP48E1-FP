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
//						 Ctrl (3 bit)	: Control signals, consisting of the following fields (from MSB to LSB):
//												Bit 2-1: Rounding mode (2 bit): 	00 - Round to nearest, ties to even 
// 																						01 - Round up (towards +inf)
// 																						10 - Symmetric rounding (towards +/- 0)
// 																						11 - Round down (towards -inf)
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
	input [2:0] Ctrl ;			// Control signals
	
	// Output ports
	output [31:0] Z ;				// Result of the operation
	output [4:0] Flags ;			// Flags indicating exceptions according to IEEE754
	
	// Internal wires between modules
	wire Sa ;						// PreAlign->Execute: A's sign bit
	wire Sb ;						// PreAlign->Execute: B's sign bit
	wire [7:0] Ea ;				// PreAlign->Align: A's expnent
	wire [7:0] Eb ;				// PreAlign->Align: B's exponent
	wire [24:0] Ma ;				// PreAlign->Align: A's mantissa
	wire [24:0] Mb ;				// PreAlign->Align: B's mantissa
	wire [22:0] MqNaN ;			// PreAlign->Exception: Mantissa for a NaN result
	wire [6:0] InputExc ;		// PreAlign->Exception: Exceptions in Inputs
	wire [7:0] CExp ;				// Align->Round: The (after alignment) common exponent
	wire [24:0] Mmax ;			// Align->Execute: The larger mantissa
	wire [24:0] Mmin ;			// Align->Execute: The smaller mantissa
	wire G ;							// Align->Execute/Normalize: Guard bit
	wire PS ;						// Align->Execute/Normalize: Pre-sticky bit
	wire G2 ;						// Align->Execute/Normalize: Guard bit
	wire PS2 ;						// Align->Execute/Normalize: Pre-sticky bit
	wire R ;							// Normalize->Round : Round bit
	wire S ;							// Normalize->Round : Final sticky bit
	wire MaxAB ;					// Align->Execute: Indicates the larger of A and B(0/A, 1/B)
	wire [25:0] Sum ;				// Execute->Normalize: Sum of the mantissas of A and B
	wire PSgn ;						// Execute->Round: Preliminary Sign of the result
	wire Opr ;						// Execute->Normalize: The effective operation performed
	wire [22:0] NormM ;			// Normalize->Round: The normalized result mantissa
	wire [8:0] NormE ;			// Normalize->Round: The result exponent after normalization
	wire ZeroSum;					// Normalize->Exception: Normalized sum is zero
	wire NegE;						// Normalize->Exception: Adjusted exponent is negative
	wire PInexact ;				// Round->Exception: Inexact after rounding
	wire [22:0] RoundM ;			// Round->Exception: Rounded mantissa
	wire [8:0] RoundE ;			// Round->Exception: Rounded exponent
	wire [31:0] Z_pipe ;			// Pipeline result output
	wire [4:0] Flags_pipe ;		// Pipeline flags output
	
	// Pipeline Registers
	reg [66:0] pipe_0;			// Pipeline register Input->PreAlign
	reg [100:0] pipe_1;			// Pipeline register PreAlign->Align
	reg [95:0] pipe_2;			// Pipeline register Align->Execute
	reg [75:0] pipe_3;			// Pipeline register Execute->Normalize
	reg [74:0] pipe_4;			// Pipeline register Normalize->Round
	reg [71:0] pipe_5;			// Pipeline register Round->Exception
	reg [36:0] pipe_6;			// Pipeline register Exception->Output
	
	assign Z = pipe_6[36:5];
	assign Flags = pipe_6[4:0];

	/* 
		
	pipe_0
			31:0 	= A
			63:32 = B
			66:64 = Ctrl
			
	pipe_1
			22:0 	= MqNaN
			29:23 = InputExc
			54:30 = Mb
			79:55 = Ma
			87:80 = Eb
			88:95 = Ea
			96		= Sb
			97		= Sa
			100:98 = Ctrl
			
	pipe_2		
			0		= MaxAB
			1		= PS
			2		= G
			27:3	= Mmin
			52:28 = Mmax
			60:53 = CExp
			61		= Sb
			62		= Sa
			65:63 = Ctrl
			72:66 = InputExc
			95:73 = MqNaN
	
	pipe_3	
			0		= Opr
			1		= Psg
			27:2	= Sum
			28		= PS
			29		= G
			37:30	= CExp
			40:38	= Ctrl
			41		= Sb
			42		= Sa
			43		= MaxAB
			50:44	= InputExc
			63:51 = MqNaN
			
	pipe_4
			0		= S
			1		= R
			2		= NegE
			3		= ZeroSum
			12:4	= NormE
			35:13	= NormM
			36		= PSgn
			39:37 = Ctrl
			40		= Sb
			41		= Sa
			42		= MaxAB
			49:43	= InputExc
			72:50	= MqNaN
			73		= Opr
			
	pipe_5
			0		= PInexact
			9:1	= RoundE
			32:10 = RoundM
			33		= NegE
			34		= ZeroSum
			37:35	= Ctrl
			38		= Sb
			39		= Sa
			40		= MaxAB
			47:41	= InputExc
			70:48 = MqNaN
			71		= Opr
			
	*/

	// Prepare the operands for alignment and check for exceptions
	FPAddSub_PreAlignModule PreAlignModule(pipe_0[63:32], pipe_0[31:0], Sa, Sb, Ea[7:0], Eb[7:0], Ma[24:0], Mb[24:0], InputExc[6:0], MqNaN[22:0]) ;

	// Align mantissas for execution and generate guard and presticky
	FPAddSub_AlignModule	AlignModule(pipe_1[95:88], pipe_1[87:80], pipe_1[79:55], pipe_1[54:30], CExp[7:0], Mmax[24:0], Mmin[24:0], G, PS, MaxAB) ;

	// Determine effective operation and execute addition or subtraction accordingly
	FPAddSub_ExecuteModule ExecuteModule(pipe_2[52:28], pipe_2[27:3], pipe_2[62], pipe_2[61], pipe_2[0], pipe_2[63], pipe_2[2], pipe_2[1], Sum[25:0], PSgn, Opr) ;

	// Normalize the result and generate final round and sticky
	FPAddSub_NormalizeModule NormalizeModule(pipe_3[27:2], pipe_3[37:30], pipe_3[29], pipe_3[28], pipe_3[0], NormM[22:0], NormE[8:0], ZeroSum, NegE, R, S) ;
	
	// Round the result according to input, adjust for overflow and check for rounding errors 
	FPAddSub_RoundModule RoundModule (pipe_4[36], pipe_4[12:4], pipe_4[35:13], pipe_4[1], pipe_4[0], pipe_4[39:38], RoundM[22:0], RoundE[8:0], PInexact) ;
	
	// Adjust for exception cases, set exception flags and put together final result
	FPAddSub_ExceptionModule ExceptionModule(pipe_5[9:1], pipe_5[32:10], pipe_5[39], pipe_5[38], pipe_5[40], 
		pipe_5[47:41], pipe_5[70:48], pipe_5[0], pipe_5[34], pipe_5[33], pipe_5[71], pipe_5[37:35], Z_pipe[31:0], Flags_pipe[4:0]) ;
	
	always @ (posedge clk) begin	
		if(rst) begin
			pipe_0 <= 0;
			pipe_1 <= 0;
			pipe_2 <= 0;
			pipe_3 <= 0;
			pipe_4 <= 0;
			pipe_5 <= 0;
			pipe_6 <= 0;
		end 
		else begin
		
			// Input to PreAlign
				pipe_0 <= {Ctrl, A, B} ;	
			
			// PreAlign to Align
			pipe_1 <= {	pipe_0[66:64],			 	// Ctrl pipe_0[66:64]
							Sa, Sb, Ea[7:0], Eb[7:0], Ma[24:0], Mb[24:0], InputExc[6:0], MqNaN[22:0]} ;
			// Align to Execute
			pipe_2 <= {	pipe_1[22:0],				// MqNaN
							pipe_1[29:23],				// InputExc
							pipe_1[100:98],			// Ctrl 
							pipe_1[97:96], 			// Sa,Sb
							CExp[7:0], Mmax[24:0], Mmin[24:0], G, PS, MaxAB} ;
			// Execute to Normalize
			pipe_3 <= {	
							pipe_2[95:73],				// MqNaN
							pipe_2[72:66],				// InputExc
							pipe_2[0],					// MaxAB
							pipe_2[62:61], 			// Sa,Sb
							pipe_2[65:63], 			// Ctrl
							pipe_2[60:53], 			// CExp
							pipe_2[1], 					// G
							pipe_2[0],					// PS
							Sum[25:0], PSgn, Opr} ;
			// Normalize to Round
			pipe_4 <= {	pipe_3[0],					// Opr
							pipe_3[74:52],				// MqNaN
							pipe_3[51:44],				// InputExc
							pipe_3[43],					// MaxAB
							pipe_3[42:41], 			// Sa,Sb
							pipe_3[40:38], 			// Ctrl
							pipe_3[1], 					// PSgn
							NormM[22:0], NormE[8:0], ZeroSum, NegE, R, S} ;
			// Round to Exception
			pipe_5 <= {	pipe_4[74:37], 			// Opr, MqNaN, InputExc, MaxAB, Sa, Sb, Ctrl
							pipe_4[3:2], 				// ZeroSum, NegE
							RoundM[22:0], RoundE[8:0], PInexact} ;
			// Output
			pipe_6 <= {Z_pipe[31:0], Flags_pipe[4:0]} ;
			
		end
	end		

endmodule
