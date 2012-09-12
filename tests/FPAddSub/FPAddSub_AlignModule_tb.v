`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
//
// Create Date:   11:44:26 09/05/2012
// Design Name:   FPAddSub_AlignModule
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FBAddSub_AlignModule_tb.v
// Project Name:  FPAddSub_Fred
//
// Verilog Test Fixture created by ISE for module: FPAddSub_AlignModule
// 
////////////////////////////////////////////////////////////////////////////////

module FPAddSub_AlignModule_tb;

	// Inputs
	reg [7:0] Ea ;	
	reg [7:0] Eb ;	
	reg [24:0] Ma ;
	reg [24:0] Mb ;

	// Outputs
	wire [7:0] CExp;
	wire [24:0] Mmax;
	wire [24:0] Mmin;
	wire G ;
	wire PS ;
	wire MaxAB;
	
	// Instantiate the Unit Under Test (UUT)
	FPAddSub_AlignModule uut (
		.Ea(Ea), 
		.Eb(Eb), 
		.Ma(Ma),
		.Mb(Mb),
		.CExp(CExp),
		.Mmax(Mmax), 
		.Mmin(Mmin),
		.G(G),
		.PS(PS),
		.MaxAB(MaxAB)
	);

	initial begin
		// Initialize Inputs
		Ea = 0;
		Eb = 0;
		Ma = 0;
		Mb = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		#10 Ea = 8'b01111111; Ma = 25'b1_00000000000000000000000_0;
			 Eb = 8'b01111111; Mb = 25'b1_00000000000000000000000_0;
			 
		#10 Ea = 8'b01111111; Ma = 25'b1_10000000000000000000000_0;
			 Eb = 8'b01111111; Mb = 25'b1_00000000000000000000000_0;
			 
		#10 Ea = 8'b10000000; Ma = 25'b1_00000000000000000000000_0;
			 Eb = 8'b01111111; Mb = 25'b1_01000000000000000000000_0;
			 
		#10 Ea = 8'b10000001; Ma = 25'b1_01000000000000000000000_0;
			 Eb = 8'b01111111; Mb = 25'b1_11101000000000000000000_0;
			 
		#10 Ea = 8'b10000000; Ma = 25'b1_01000100000000000000000_0;
			 Eb = 8'b10001000; Mb = 25'b1_00000000000000000000000_0;

		#10 Ea = 8'b01111111; Ma = 25'b1_10000000000000000000000_0;
			 Eb = 8'b01111111; Mb = 25'b1_00010000000000000000000_0;

		#10 Ea = 8'b10000010; Ma = 25'b1_00000000000000000000000_0;
			 Eb = 8'b00000000; Mb = 25'b1_00000000000000000000000_0;

		#10 Ea = 8'b11000111; Ma = 25'b1_11000000000000000000000_0;
			 Eb = 8'b00000001; Mb = 25'b1_00000000000000000000000_0;
	
		#10 Ea = 8'b10000011; Ma = 25'b1_11000000000000000000000_0;
			 Eb = 8'b01111111; Mb = 25'b1_00000000000000000000110_0;
			 
		#10 $finish;
		
	end
      
endmodule

