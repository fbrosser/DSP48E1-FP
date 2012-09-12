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
	reg [24:0] Mmax;
	reg [24:0] Mmin;
	reg Sa;
	reg Sb;
	reg MaxAB;
	reg OpMode;
	reg G;
	reg PS;

	// Outputs
	wire [25:0] Sum;
	wire PSgn;
	wire Opr;

	// Instantiate the Unit Under Test (UUT)
	FPAddSub_ExecuteModule uut (
		.Mmax(Mmax), 
		.Mmin(Mmin), 
		.Sa(Sa), 
		.Sb(Sb), 
		.MaxAB(MaxAB),
		.OpMode(OpMode), 
		.G(G),
		.PS(PS),
		.Sum(Sum),
		.PSgn(PSgn),
		.Opr(Opr)
	);

	initial begin
		// Initialize Inputs
		Mmax = 0;
		Mmin = 0;
		Sa = 0;
		Sb = 0;
		MaxAB = 0;
		OpMode = 0;
		G = 0;
		PS = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 Mmax = 25'b1000_0000_0000_0000_0000_00000; Mmin = 25'b0100_0000_0000_0000_0000_00000;
				Sa = 1'b0; Sb = 1'b0; OpMode = 1'b0;
		#10 Mmax = 25'b1000_0000_0000_0000_0000_00000; Mmin = 25'b0110_0000_0000_0000_0000_00000;
				Sa = 1'b0; Sb = 1'b0; OpMode = 1'b0;
		#10 Mmax = 25'b1100_0000_0000_0000_0000_00000; Mmin = 25'b0100_0000_0000_0000_0000_00000;
				Sa = 1'b0; Sb = 1'b0; OpMode = 1'b0;
		#10 Mmax = 25'b1010_0000_0000_0000_0000_00000; Mmin = 25'b0101_0000_0000_0000_0000_00000;
				Sa = 1'b0; Sb = 1'b0; OpMode = 1'b0;
		#10 Mmax = 25'b1000_0000_0000_0000_0000_00000; Mmin = 25'b0100_0000_0000_0000_0000_00000;
				Sa = 1'b0; Sb = 1'b0; OpMode = 1'b1;
		#10 Mmax = 25'b1000_0000_0000_0000_0000_00000; Mmin = 25'b0010_0000_0000_0000_0000_00000;
				Sa = 1'b0; Sb = 1'b1; OpMode = 1'b0;
		#10 $finish;

	end
      
endmodule

