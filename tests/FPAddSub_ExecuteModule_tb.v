`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:43:26 09/05/2012
// Design Name:   FPAddSub_ExecuteModule
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FBAddSub_ExecuteModule_tb.v
// Project Name:  FPAddSub_Fred
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPAddSub_ExecuteModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPAddSub_ExecuteModule_tb;

	// Inputs
	reg [23:0] Mmax;
	reg [48:0] Mmin;
	reg Smax;
	reg Smin;
	reg OpMode;

	// Outputs
	wire Cout;
	wire StickyBit;
	wire RoundBit;
	wire GuardBit;
	wire [24:0] Sum;
	wire Opr;
	wire [23:0] OpA;
	wire [23:0] OpB;
	wire OpC;

	// Instantiate the Unit Under Test (UUT)
	FPAddSub_ExecuteModule uut (
		.Mmax(Mmax), 
		.Mmin(Mmin), 
		.Smax(Smax), 
		.Smin(Smin), 
		.OpMode(OpMode), 
		.Cout(Cout), 
		.StickyBit(StickyBit), 
		.RoundBit(RoundBit), 
		.GuardBit(GuardBit), 
		.Sum(Sum),
		.Opr(Opr),
		.OpA(OpA),
		.OpB(OpB),
		.OpC(OpC)
	);

	initial begin
		// Initialize Inputs
		Mmax = 0;
		Mmin = 0;
		Smax = 0;
		Smin = 0;
		OpMode = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 Mmax = 24'b1_0010_0000_0000_0000_0000_0000; Mmin = 49'b01_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_000;
				Smax = 1'b0; Smin = 1'b0; OpMode = 1'b0;
		#10 Mmax = 24'b1_1000_0000_0000_0000_0000_0000; Mmin = 49'b01_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_000;
				Smax = 1'b0; Smin = 1'b0; OpMode = 1'b0;
		#10 Mmax = 24'b1_0000_0000_0000_0000_0000_0000; Mmin = 49'b10_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_000;
				Smax = 1'b0; Smin = 1'b1; OpMode = 1'b0;
		#10 Mmax = 24'b1_0110_0000_0000_0000_0000_0000; Mmin = 49'b00_1000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_000;
				Smax = 1'b0; Smin = 1'b0; OpMode = 1'b1;
		#10 $finish;

	end
      
endmodule

