`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:32:51 09/12/2012
// Design Name:   FPAddSub_RoundModule
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FPAddSub_RoundModule_tb.v
// Project Name:  FPAddSub_Fred
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPAddSub_RoundModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPAddSub_RoundModule_tb;

	// Inputs
	reg Sgn;
	reg [8:0] NormE;
	reg [22:0] NormM;
	reg R;
	reg S;
	reg [1:0] RoundMode;

	// Outputs
	wire [22:0] RoundM;
	wire [8:0] RoundE;
	wire Inexact;

	// Instantiate the Unit Under Test (UUT)
	FPAddSub_RoundModule uut (
		.Sgn(Sgn), 
		.NormE(NormE), 
		.NormM(NormM), 
		.R(R), 
		.S(S), 
		.RoundMode(RoundMode), 
		.RoundM(RoundM),
		.RoundE(RoundE),
		.Inexact(Inexact)
	);

	initial begin
		// Initialize Inputs
		Sgn = 0;
		NormE = 0;
		NormM = 0;
		R = 0;
		S = 0;
		RoundMode = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 Sgn = 1'b0; NormE = 8'b0111_1111; NormM = 23'b0000_0000_0000_0000_0000_0000; R = 1'b0; S = 1'b0; RoundMode = 2'b00;
		#10 Sgn = 1'b0; NormE = 8'b0111_1111; NormM = 23'b0000_0000_0000_0000_0000_0000; R = 1'b0; S = 1'b0; RoundMode = 2'b01;
		#10 Sgn = 1'b0; NormE = 8'b0111_1111; NormM = 23'b0000_0000_0000_0000_0000_0000; R = 1'b0; S = 1'b0; RoundMode = 2'b10;
		#10 Sgn = 1'b0; NormE = 8'b0111_1111; NormM = 23'b0000_0000_0000_0000_0000_0000; R = 1'b0; S = 1'b0; RoundMode = 2'b11;
		
		#10 Sgn = 1'b0; NormE = 8'b0111_1111; NormM = 23'b0000_0000_0000_0000_0000_0000; R = 1'b1; S = 1'b0; RoundMode = 2'b00;
		#10 Sgn = 1'b0; NormE = 8'b0111_1111; NormM = 23'b0000_0000_0000_0000_0000_0000; R = 1'b1; S = 1'b0; RoundMode = 2'b01;
		#10 Sgn = 1'b0; NormE = 8'b0111_1111; NormM = 23'b0000_0000_0000_0000_0000_0000; R = 1'b1; S = 1'b0; RoundMode = 2'b10;
		#10 Sgn = 1'b0; NormE = 8'b0111_1111; NormM = 23'b0000_0000_0000_0000_0000_0000; R = 1'b1; S = 1'b0; RoundMode = 2'b11;
		
		#10 Sgn = 1'b0; NormE = 8'b0000_0000; NormM = 23'b0000_0000_0000_0000_0000_0000; R = 1'b0; S = 1'b0; RoundMode = 2'b00;
		#10 Sgn = 1'b0; NormE = 8'b0000_0000; NormM = 23'b0000_0000_0000_0000_0000_0000; R = 1'b0; S = 1'b0; RoundMode = 2'b01;
		
		#10 Sgn = 1'b0; NormE = 8'b1000_0000; NormM = 23'b0000_0000_0000_0000_0000_0011; R = 1'b0; S = 1'b0; RoundMode = 2'b00;
		#10 Sgn = 1'b0; NormE = 8'b1000_0000; NormM = 23'b0000_0000_0000_0000_0000_0010; R = 1'b0; S = 1'b1; RoundMode = 2'b11;
		
		#10 Sgn = 1'b0; NormE = 8'b1000_0000; NormM = 23'b0000_0000_0000_0000_0000_0001; R = 1'b1; S = 1'b1; RoundMode = 2'b00;
		#10 Sgn = 1'b0; NormE = 8'b1000_0001; NormM = 23'b0000_0000_0000_0000_0000_0000; R = 1'b1; S = 1'b0; RoundMode = 2'b10;
	
		#10 $finish;
		
	end
      
endmodule

