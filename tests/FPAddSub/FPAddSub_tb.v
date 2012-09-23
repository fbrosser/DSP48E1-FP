`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:00:37 09/10/2012
// Design Name:   FPAddSub
// Module Name:   P:/VerilogTraining/FPAddSub_Fred/FPAddSub_tb.v
// Project Name:  FPAddSub_Fred
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
	reg [31:0] A;
	reg [31:0] B;
	reg [2:0] Ctrl ;

	// Outputs
	wire [31:0] Z;
	wire [4:0] Flags;
	wire [66:0] pipe_0;					// Pipeline register Input->PreAlign
	wire [100:0] pipe_1;					// Pipeline register PreAlign->Align
	wire [95:0] pipe_2;					// Pipeline register Align->Execute
	wire [75:0] pipe_3;					// Pipeline register Execute->Normalize
	wire [74:0] pipe_4;					// Pipeline register Normalize->Round
	wire [71:0] pipe_5;					// Pipeline register Round->Exception
	wire [36:0] pipe_6;					// Pipeline register Exception->Output
	
	// Instantiate the Unit Under Test (UUT)
	FPAddSub uut (
		.clk(clk),
		.rst(rst),
		.A(A), 
		.B(B), 
		.Ctrl(Ctrl),
		.Z(Z),
		.Flags(Flags),
		.pipe_0(pipe_0),
		.pipe_1(pipe_1),
		.pipe_2(pipe_2),
		.pipe_3(pipe_3),
		.pipe_4(pipe_4),
		.pipe_5(pipe_5),
		.pipe_6(pipe_6)
	);

	always begin
		#5 clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		clk = 0;
		Ctrl = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#10 rst = 1;
		#10 rst = 0;
        
		// Add stimulus here
		// 1+1 = 2
		#10 A = 32'b0_01111111_00000000000000000000000; B = 32'b0_01111111_00000000000000000000000; Ctrl = 3'b000;
		
		#10 A = 32'b0_10000000_10000000000000000000000; B = 32'b0_01111111_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_01111111_10000000000000000000000; B = 32'b0_01111111_01000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_01111111_10000000000000000000000; B = 32'b0_01111111_10000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_01111111_10000000000000000000000; B = 32'b1_01111111_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_10000001_01100000000000000000000; B = 32'b0_01111110_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_10000001_01000000000000000000000; B = 32'b0_10000001_10000000000000000000000; Ctrl = 3'b001;
		#10 A = 32'b0_01111111_00000000000000000000000; B = 32'b0_00000000_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_01111111_10000000000000000000000; B = 32'b1_00000000_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_01111111_00000000000000000000000; B = 32'b0_01111111_00000000000000000000000; Ctrl = 3'b000;
		#10 A = 32'b0_10000101_00001111111101011100001; B = 32'b1_10000001_10101111010111000010100; Ctrl = 3'b000;
		#10 A = 32'b0_01111111_00000000000000000000000; B = 32'b0_01111111_00000000000000000000000; Ctrl = 3'b000;
		
		// - 315.0 + -36.2	51 = -351.251 = 11000011101011111010000000100001
		#10 A = 32'b11000011100111011000000000000000 ; B = 32'b11000010000100010000000100000110 ; Ctrl = 3'b110;
		
		// 832.312 - 23.1 = 809.212 = 01000100010010100100110110010001
		#10 A = 32'b01000100010100000001001111111000 ; B = 32'b01000001101110001100110011001101 ; Ctrl = 3'b111;
		
		// 0.19 + 0.005 = 0.195 = 00111110010001111010111000010100
		#10 A = 32'b00111110010000101000111101011100 ; B = 32'b00111011101000111101011100001010 ; Ctrl = 3'b110;
		
		// 0.1 + 0 = 0.1 = 00111101110011001100110011001101
		#10 A = 32'b00111101110011001100110011001101 ; B = 32'b00000000000000000000000000000000 ; Ctrl = 3'b110;
		
		// 28.0 + 0.15 = 28.15 = 01000001111000010011001100110011
		#10 A = 32'b01000001111000000000000000000000 ; B = 32'b00111110000110011001100110011010 ; Ctrl = 3'b110;
		
		// - 12 - -0.07 = -11.93 = 11000001001111101110000101001000
		#10 A = 32'b11000001010000000000000000000000 ; B = 32'b10111101100011110101110000101001 ; Ctrl = 3'b111;
		
		#10;
		
		#10 $display("Z[1]: %b\n", Z);
		#10 $display("Z[2]: %b\n", Z);
		#10 $display("Z[3]: %b\n", Z);
		#10 $display("Z[4]: %b\n", Z);
		#10 $display("Z[5]: %b\n", Z);
		#10 $display("Z[6]: %b\n", Z);
		
		#10 $finish;
		
	end
      
endmodule
