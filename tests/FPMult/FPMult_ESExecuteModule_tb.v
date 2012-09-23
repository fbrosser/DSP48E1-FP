`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:22:00 09/20/2012
// Design Name:   FPMult_ESExecuteModule
// Module Name:   P:/VerilogTraining/FPMult/FPMult_ESExecuteModule_tb.v
// Project Name:  FPMult
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPMult_ESExecuteModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPMult_ESExecuteModule_tb;

	// Inputs
	reg [7:0] Ea;
	reg [7:0] Eb;
	reg Sa;
	reg Sb;

	// Outputs
	wire [8:0] Ep;
	wire Sp;

	// Instantiate the Unit Under Test (UUT)
	FPMult_ESExecuteModule uut (
		.Ea(Ea), 
		.Eb(Eb), 
		.Sa(Sa), 
		.Sb(Sb), 
		.Ep(Ep), 
		.Sp(Sp)
	);

	initial begin
		// Initialize Inputs
		Ea = 0;
		Eb = 0;
		Sa = 0;
		Sb = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#10 Ea = 8'b1000_0000; Eb = 8'b0111_1111; Sa = 0; Sb = 0;
		$display("Testbench:  Ep = %d", Ep);
		#10 Ea = 8'b1000_0001; Eb = 8'b1000_0000; Sa = 0; Sb = 0;
		$display("Testbench:  Ep = %d", Ep);
		#10 Ea = 8'b0111_1100; Eb = 8'b1000_0000; Sa = 0; Sb = 0;
		$display("Testbench:  Ep = %d", Ep);
		#10 Ea = 8'b0111_0111; Eb = 8'b1000_0110; Sa = 0; Sb = 0;
		$display("Testbench:  Ep = %d", Ep);
		#10 Ea = 8'b1101_1111; Eb = 8'b1111_0111; Sa = 0; Sb = 0;
		$display("Testbench:  Ep = %d", Ep);
		#10 Ea = 8'b0110_0000; Eb = 8'b0000_0000; Sa = 1; Sb = 0;
		$display("Testbench:  Ep = %d", Ep);
		#10 Ea = 8'b0000_0111; Eb = 8'b0000_0000; Sa = 0; Sb = 1;
		$display("Testbench:  Ep = %d", Ep);
		#10 Ea = 8'b1110_0110; Eb = 8'b0000_0000; Sa = 1; Sb = 1;
		$display("Testbench:  Ep = %d", Ep);
		#10 $finish;
	end
      
endmodule

