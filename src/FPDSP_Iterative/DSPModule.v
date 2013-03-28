`timescale 1ns / 1ps

module DSPModule(clk, rst, A, B, C, P);

	 input clk;
	 input rst;
	 
	 input [29:0] A;
	 input [17:0] B;
	 input [47:0] C;
	 
	 input [3:0] ALUMode;
	 input [6:0] OpMode;
	 input [4:0] InMode;
		
	 output reg [47:0] P;
	 
	 reg [47:0] CReg;

	// Extra register on C-input on DSP Side
	always @ (posedge clk) begin
		CReg = C;
	end
	
   // DSP48E1: 48-bit Multi-Functional Arithmetic Block
   //          Virtex-6
   // Xilinx HDL Language Template, version 13.2
	
   DSP48E1 #(
      // Feature Control Attributes: Data Path Selection
      .A_INPUT("DIRECT"),             	// Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
      .B_INPUT("DIRECT"),              // Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
      .USE_DPORT("FALSE"),             // Select D port usage (TRUE or FALSE)
      .USE_MULT("MULTIPLY"),           // Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")

      // Pattern Detector Attributes: Pattern Detection Configuration
      .AUTORESET_PATDET("NO_RESET"),   // "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
      .USE_PATTERN_DETECT("NO_PATDET"),// Enable pattern detect ("PATDET" or "NO_PATDET")

      // Register Control Attributes: Pipeline Register Configuration
		.ACASCREG(2),                    // Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
      .ADREG(1),                      	// Number of pipeline stages for pre-adder (0 or 1)
      .ALUMODEREG(1),                  // Number of pipeline stages for ALUMODE (0 or 1)
		.AREG(2),                        // Number of pipeline stages for A (0, 1 or 2)
		.BCASCREG(2),                    // Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
		.BREG(2),                        // Number of pipeline stages for B (0, 1 or 2)
      .CARRYINREG(1),                  // Number of pipeline stages for CARRYIN (0 or 1)
      .CARRYINSELREG(1),               // Number of pipeline stages for CARRYINSEL (0 or 1)
      .CREG(1),                        // Number of pipeline stages for C (0 or 1)
      .DREG(1),                        // Number of pipeline stages for D (0 or 1)
      .INMODEREG(1),                   // Number of pipeline stages for INMODE (0 or 1)
      .MREG(1),                        // Number of multiplier pipeline stages (0 or 1)
      .OPMODEREG(1),                   // Number of pipeline stages for OPMODE (0 or 1)
      .PREG(1),                        // Number of pipeline stages for P (0 or 1)
      .USE_SIMD("ONE48")               // SIMD selection ("ONE48", "TWO24", "FOUR12")
   )
   DSP48E1_1 (
      .P(P),                       		// 48-bit output: Primary data output

      // Cascade: 30-bit (each) input: Cascade Ports
      .ACIN(30'h0000),                 // 30-bit input: A cascade data input
      .BCIN(18'h000),                  // 18-bit input: B cascade input
      .CARRYCASCIN(1'h0),       			// 1-bit input: Cascade carry input
      .MULTSIGNIN(1'h0),         		// 1-bit input: Multiplier sign input
      .PCIN(48'h00000),                // 48-bit input: P cascade input

      // Control: 4-bit (each) input: Control Inputs/Status Bits
      .ALUMODE(ALUMode),               // 4-bit input: ALU control input
      .CARRYINSEL(3'h0),         		// 3-bit input: Carry select input
      .CEINMODE(1'h0),             		// 1-bit input: Clock enable input for INMODEREG
      .CLK(clk),                       // 1-bit input: Clock input
      .INMODE(InMode),               // 5-bit input: INMODE control input
      .OPMODE(OpMode),             // 7-bit input: Operation mode input
      .RSTINMODE(rst),           		// 1-bit input: Reset input for INMODEREG

      // Data: 30-bit (each) input: Data Ports
      .A(A),            					// 30-bit input: A data input
		.B(B),             					// 18-bit input: B data input
      .C(CReg),                   		// 48-bit input: C data input
      .CARRYIN(0),               		// 1-bit input: Carry input signal
      .D(25'b0),                       // 25-bit input: D data input

		//.PCOUT(),

      // Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
      .CEA1(1),                     	// 1-bit input: Clock enable input for 1st stage AREG
      .CEA2(1),                     	// 1-bit input: Clock enable input for 2nd stage AREG
      .CEAD(1),                     	// 1-bit input: Clock enable input for ADREG
      .CEALUMODE(1),           			// 1-bit input: Clock enable input for ALUMODERE
      .CEB1(1),                     	// 1-bit input: Clock enable input for 1st stage BREG
      .CEB2(1),                     	// 1-bit input: Clock enable input for 2nd stage BREG
      .CEC(1),                       	// 1-bit input: Clock enable input for CREG
      .CECARRYIN(1),           			// 1-bit input: Clock enable input for CARRYINREG
      .CECTRL(1),                 		// 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
      .CED(1),                       	// 1-bit input: Clock enable input for DREG
      .CEM(1),                       	// 1-bit input: Clock enable input for MREG
      .CEP(1),                       	// 1-bit input: Clock enable input for PREG
      .RSTA(rst),                     	// 1-bit input: Reset input for AREG
      .RSTALLCARRYIN(rst),   				// 1-bit input: Reset input for CARRYINREG
      .RSTALUMODE(rst),         			// 1-bit input: Reset input for ALUMODEREG
      .RSTB(rst),                     	// 1-bit input: Reset input for BREG
      .RSTC(rst),                     	// 1-bit input: Reset input for CREG
      .RSTCTRL(rst),               		// 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
      .RSTD(rst),                     	// 1-bit input: Reset input for DREG and ADREG
      .RSTM(rst),                     	// 1-bit input: Reset input for MREG
      .RSTP(rst)                      	// 1-bit input: Reset input for PREG
   );

endmodule
