`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:22:17 11/19/2012
// Design Name:   FPAddSub
// Module Name:   P:/FPProject/FP_AddSub/FPAddSub_tb.v
// Project Name:  FP_AddSub
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FPAddSub
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FPAddSub_tb;

	// Inputs
	reg clk;
	reg rst;
	reg [31:0] a;
	reg [31:0] b;
	reg operation;

	// Outputs
	wire [31:0] result;
	wire [4:0] flags;
	
	// Loop variable
	integer i;

	// Instantiate the Unit Under Test (UUT)
	FPAddSub uut (
		.clk(clk), 
		.rst(rst), 
		.a(a), 
		.b(b), 
		.operation(operation), 
		.result(result), 
		.flags(flags)
	);

	// Set up clock
	always begin
		#5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		a = 0;
		b = 0;
		operation = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		// TEST #1
		// 8.53158062524 - 3.11224834289 = 5.41933228235
		// Expected Z = 01000000101011010110101100101100
		#10 a = 32'b01000001000010001000000101011011; b = 32'b01000000010001110010111100010100; operation = 1'b1; $display("%b", result);

		// TEST #2
		// -8.94699830093 + 2.40949324703 = -6.5375050539
		// Expected Z = 11000000110100010011001100111110
		#10 a = 32'b11000001000011110010011011101000; b = 32'b01000000000110100011010100100011; operation = 1'b0; $display("%b", result);

		// TEST #3
		// -5.82217162291 + 4.7532367122 = -1.06893491072
		// Expected Z = 10111111100010001101001011011100
		#10 a = 32'b11000000101110100100111100111011; b = 32'b01000000100110000001101010000100; operation = 1'b0; $display("%b", result);

		// TEST #4
		// 2.36803721918 - -2.82064050634 = 5.18867772552
		// Expected Z = 01000000101001100000100110100110
		#10 a = 32'b01000000000101111000110111101100; b = 32'b11000000001101001000010101100000; operation = 1'b1; $display("%b", result);

		// TEST #5
		// 3.76646645081 - 8.54622987974 = -4.77976342893
		// Expected Z = 11000000100110001111001111010010
		#10 a = 32'b01000000011100010000110111001001; b = 32'b01000001000010001011110101011100; operation = 1'b1; $display("%b", result);

		// TEST #6
		// -2.4498318859 + 5.11827801472 = 2.66844612882
		// Expected Z = 01000000001010101100011111010010
		#10 a = 32'b11000000000111001100101000001100; b = 32'b01000000101000111100100011101111; operation = 1'b0; $display("%b", result);

		// TEST #7
		// -3.2982604628 - 7.97307781549 = -11.2713382783
		// Expected Z = 11000001001101000101011101100111
		#10 a = 32'b11000000010100110001011010110011; b = 32'b01000000111111110010001101110100; operation = 1'b1; $display("%b", result);

		// TEST #8
		// 6.76606508537 + 0.854623693731 = 7.6206887791
		// Expected Z = 01000000111100111101110010101111
		#10 a = 32'b01000000110110001000001110011011; b = 32'b00111111010110101100100010011110; operation = 1'b0; $display("%b", result);

		// TEST #9
		// 9.19157019368 - -4.20144876977 = 13.3930189634
		// Expected Z = 01000001010101100100100111001110
		#10 a = 32'b01000001000100110001000010101100; b = 32'b11000000100001100111001001000101; operation = 1'b1; $display("%b", result);

		// TEST #10
		// 1.83567358255 + -8.17750207328 = -6.34182849073
		// Expected Z = 11000000110010101111000001000010
		#10 a = 32'b00111111111010101111011101011010; b = 32'b11000001000000101101011100001100; operation = 1'b0; $display("%b", result);

		for(i=0; i<=10; i=i+1) begin
			#10 $display("%b", result); 
		end 

		#100 

		#10 $finish; 

	end
      
endmodule

