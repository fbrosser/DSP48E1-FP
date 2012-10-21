`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:34:18 10/16/2012 
// Design Name: 
// Module Name:    FPAddSub_Pipelined_Simplified_2_0_NormalizeShiftModule3 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FPAddSub_Pipelined_Simplified_2_0_NormalizeShiftModule3(
		PSSum,
		G,
		PS,
		CExp,
		Opr,
		Shift,
		NormM,
		NormE,
		ZeroSum,
		NegE,
		R,
		S
	);
	
	// Input ports
	input [25:0] PSSum ;					// The Pre-Shift-Sum
	input G ;								// Guard bit
	input PS ;								// Pre-sticky bit
	input [7:0] CExp ;
	input Opr;
	input [4:0] Shift ;					// Amount to be shifted

	// Output ports
	output [22:0] NormM ;				// Normalized mantissa
	output [8:0] NormE ;					// Adjusted exponent
	output ZeroSum ;						// Zero flag
	output NegE ;							// Flag indicating negative exponent
	output R ;								// Round bit
	output S ;								// Final sticky bit

	// Internal signals
	
	wire MSBShift ;						// Flag indicating that a second shift is needed
	wire [8:0] ExpOF ;					// MSB set in sum indicates overflow
	wire [8:0] ExpOK ;					// MSB not set, no adjustment
	
	assign ZeroSum = ~|PSSum ;		// Check for all zero sum
	assign ExpOK = CExp - Shift ;	// Adjust exponent for new normalized mantissa
	assign NegE = ExpOK[8] ;		// Check for exponent overflow
	assign ExpOF = ExpOK + 1'b1 ;		// If MSB set, add one to exponent(x2)
	assign MSBShift = PSSum[25] ;	// Check MSB in unnormalized sum
	assign NormM = PSSum[24:2] ;	// The new, normalized mantissa
	
	assign NormE = (MSBShift ? ExpOF : ExpOK) ;	// Determine final exponent
	
	// Also need to compute sticky and round bits for the rounding stage
	assign CheckNorm = (Opr & (~|Shift[4:2]) & Shift[1] & ~Shift[0]);	// Really Normalized?
	assign R = CheckNorm ? (PS^G) :(NormM[1] & ~(|Shift[4:1] & Opr)); // Round bit
	assign S = CheckNorm ? PS :(NormM[0] | G | PS);							// Set final sticky bit


endmodule
