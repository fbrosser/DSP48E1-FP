`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:58:42 09/07/2012
// Design Name:   FPAddSub_NormalizeModule
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FPAddSub_NormalizeModule_tb.v
// Project Name:  FPAddSub_Fred
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPAddSub_NormalizeModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPAddSub_NormalizeModule_tb;

	// Inputs
	reg [25:0] Sum;
	reg [7:0] CExp;
	reg G;
	reg PS;
	reg Opr;

	// Outputs
	wire [22:0] NormM;
	wire [8:0] NormE;
	wire ZeroSum;
	wire NegE;
	wire R;
	wire S;

	// Instantiate the Unit Under Test (UUT)
	FPAddSub_NormalizeModule uut (
		.Sum(Sum), 
		.CExp(CExp), 
		.G(G), 
		.PS(PS),
		.Opr(Opr),
		.NormM(NormM),
		.NormE(NormE),
		.ZeroSum(ZeroSum),
		.NegE(NegE),
		.R(R),
		.S(S)
	);

	initial begin
		// Initialize Inputs
		Sum = 0;
		CExp = 0;
		G = 0;
		PS = 0;
		Opr = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#10 Sum = 26'b01000000000000000000000000; CExp = 8'b0111_1111;
		#10 Sum = 26'b11000000000000000000000000; CExp = 8'b0111_1111;
		#10 Sum = 26'b10000000000000000000000000; CExp = 8'b0000_0000;
		#10 Sum = 26'b00000010000000000000000000; CExp = 8'b0111_1111;
		#10 Sum = 26'b10000000100000000000000001; CExp = 8'b1000_0000;
		#10 Sum = 26'b10000000100001000000000000; CExp = 8'b1000_0001;
		#10 Sum = 26'b10000000100000000000000000; CExp = 8'b1000_0000;
		#10 $finish;
		
	end
      
endmodule

