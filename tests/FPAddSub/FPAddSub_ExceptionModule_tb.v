`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:53:36 09/13/2012
// Design Name:   FPAddSub_ExceptionModule
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FPAddSub_ExceptionModule_tb.v
// Project Name:  FPAddSub_Fred
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPAddSub_ExceptionModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPAddSub_ExceptionModule_tb;

	// Inputs
	reg [8:0] RoundE;
	reg [22:0] RoundM;
	reg Sa;
	reg Sb;
	reg MaxAB;
	reg [6:0] InputExc;
	reg [22:0] MqNaN;
	reg PInexact;
	reg ZeroSum;
	reg NegE;
	reg Opr;
	reg [2:0] Ctrl;

	// Outputs
	wire [31:0] Z;
	wire [4:0] Flags;

	// Instantiate the Unit Under Test (UUT)
	FPAddSub_ExceptionModule uut (
		.RoundE(RoundE), 
		.RoundM(RoundM), 
		.Sa(Sa), 
		.Sb(Sb), 
		.MaxAB(MaxAB), 
		.InputExc(InputExc), 
		.MqNaN(MqNaN),
		.PInexact(PInexact), 
		.ZeroSum(ZeroSum), 
		.NegE(NegE), 
		.Opr(Opr), 
		.Ctrl(Ctrl), 
		.Z(Z), 
		.Flags(Flags)
	);

	initial begin
		// Initialize Inputs
		RoundE = 0;
		RoundM = 0;
		Sa = 0;
		Sb = 0;
		MaxAB = 0;
		InputExc = 0;
		MqNaN = 0;
		PInexact = 0;
		ZeroSum = 0;
		NegE = 0;
		Opr = 0;
		Ctrl = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 RoundE = 9'b0_1000_0000; RoundM = 23'b000_0000_0000_0000_0000_0000; Sa = 0; Sb = 0; MaxAB = 0; InputExc = 5'b00000;
				PInexact = 0; ZeroSum = 0; NegE = 0; Opr = 0; Ctrl = 3'b000;
		#10 RoundE = 9'b0_0111_1111; RoundM = 23'b100_1000_0000_0000_0000_0000; Sa = 1; Sb = 0; MaxAB = 0; InputExc = 5'b00000;
				PInexact = 0; ZeroSum = 1; NegE = 0; Opr = 0; Ctrl = 3'b000;
		#10 RoundE = 9'b0_1000_0000; RoundM = 23'b011_0000_0000_0000_0000_0000; Sa = 0; Sb = 1; MaxAB = 1; InputExc = 5'b00000;
				PInexact = 0; ZeroSum = 0; NegE = 0; Opr = 0; Ctrl = 3'b111;
		#10 RoundE = 9'b0_1000_0001; RoundM = 23'b110_0000_0000_0000_0000_0000; Sa = 0; Sb = 0; MaxAB = 0; InputExc = 5'b00000;
				PInexact = 0; ZeroSum = 0; NegE = 0; Opr = 0; Ctrl = 3'b011;
		#10 RoundE = 9'b0_0111_1111; RoundM = 23'b100_0000_0000_0000_0000_0000; Sa = 0; Sb = 0; MaxAB = 1; InputExc = 5'b10100;
				PInexact = 0; ZeroSum = 0; NegE = 1; Opr = 0; Ctrl = 3'b000;
		#10 RoundE = 9'b0_0111_0001; RoundM = 23'b110_0000_0011_0000_0000_0000; Sa = 1; Sb = 1; MaxAB = 0; InputExc = 5'b11000;
				PInexact = 0; ZeroSum = 0; NegE = 0; Opr = 0; Ctrl = 3'b100;
		#10 RoundE = 9'b0_0111_0001; RoundM = 23'b110_0000_0011_0000_0000_0000; Sa = 1; Sb = 1; MaxAB = 0; InputExc = 5'b10000;
				PInexact = 0; ZeroSum = 0; NegE = 0; Opr = 0; Ctrl = 3'b100;
		#10 RoundE = 9'b0_1000_0000; RoundM = 23'b000_0000_0000_0000_0000_0000; Sa = 0; Sb = 0; MaxAB = 0; InputExc = 5'b00000;
				PInexact = 1; ZeroSum = 0; NegE = 0; Opr = 0; Ctrl = 3'b000;
		#10 $finish;
	end
      
endmodule

