`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
// Create Date:    11:35:05 09/05/2012 
// Module Name:    FPAddSub_ExecutionModule 
// Project Name: 	 Floating Point Project
// Author:			 Fredrik Brosser
//
// Description:	 Module that executes the addition or subtraction on mantissas.
//
//////////////////////////////////////////////////////////////////////////////////

module FPAddSub_ExecutionModule(
		Mmax,
		Mmin,
		Sa,
		Sb,
		MaxAB,
		OpMode,
		Sum,
		PSgn,
		Opr
    );

	// Input ports
	input [22:0] Mmax ;					// The larger mantissa
	input [23:0] Mmin ;					// The smaller mantissa
	input Sa ;								// Sign bit of larger number
	input Sb ;								// Sign bit of smaller number
	input MaxAB ;							// Indicates the larger number (0/A, 1/B)
	input OpMode ;							// Operation to be performed (0/Add, 1/Sub)
	
	// Output ports
	output [32:0] Sum ;					// The result of the operation
	output PSgn ;							// The sign for the result
	output Opr ;							// The effective (performed) operation

	// Internal signals
	wire [47:0] Pout ;
	
	assign Opr = (OpMode^Sa^Sb); 		// Resolve sign to determine operation

	// Perform effective operation
	assign Sum = Pout[32:0];
	
	   DSP48E1 #(
      // Feature Control Attributes: Data Path Selection
      .A_INPUT("DIRECT"),               // Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
      .B_INPUT("DIRECT"),               // Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
      .USE_DPORT("FALSE"),              // Select D port usage (TRUE or FALSE)
      .USE_MULT("MULTIPLY"),            // Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
		
      // Pattern Detector Attributes: Pattern Detection Configuration
      .AUTORESET_PATDET("NO_RESET"),    // "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH" 
      .USE_PATTERN_DETECT("NO_PATDET"), // Enable pattern detect ("PATDET" or "NO_PATDET")
		
      // Register Control Attributes: Pipeline Register Configuration
		.ACASCREG(2'b10),                     // Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
      .ADREG(1'b1),                        // Number of pipeline stages for pre-adder (0 or 1)
      .ALUMODEREG(1'b1),                   // Number of pipeline stages for ALUMODE (0 or 1)
		.AREG(2'b10),                         // Number of pipeline stages for A (0, 1 or 2)
		.BCASCREG(2'b10),                     // Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
		.BREG(2'b10),                         // Number of pipeline stages for B (0, 1 or 2)
      .CARRYINREG(1'b1),                   // Number of pipeline stages for CARRYIN (0 or 1)
      .CARRYINSELREG(1'b1),                // Number of pipeline stages for CARRYINSEL (0 or 1)
      .CREG(1'b1),                         // Number of pipeline stages for C (0 or 1)
      .DREG(1'b1),                         // Number of pipeline stages for D (0 or 1)
      .INMODEREG(1'b1),                    // Number of pipeline stages for INMODE (0 or 1)
      .MREG(1'b1),                         // Number of multiplier pipeline stages (0 or 1)
      .OPMODEREG(1'b1),                    // Number of pipeline stages for OPMODE (0 or 1)
      .PREG(1'b1),                         // Number of pipeline stages for P (0 or 1)
      .USE_SIMD("ONE48")                // SIMD selection ("ONE48", "TWO24", "FOUR12")
   )
   DSP48E1_1 (
      .P(Pout),                           // 48-bit output: Primary data output
		
      // Cascade: 30-bit (each) input: Cascade Ports
      .ACIN(30'h0000),                     // 30-bit input: A cascade data input
      .BCIN(18'h000),                     // 18-bit input: B cascade input
      .CARRYCASCIN(1'h0),       // 1-bit input: Cascade carry input
      .MULTSIGNIN(1'h0),         // 1-bit input: Multiplier sign input
      .PCIN(48'h00000),                     // 48-bit input: P cascade input
		
      // Control: 4-bit (each) input: Control Inputs/Status Bits
      .ALUMODE(4'b0000),               // 4-bit input: ALU control input
      .CARRYINSEL(3'h0),         // 3-bit input: Carry select input
      .CEINMODE(1'h0),             // 1-bit input: Clock enable input for INMODEREG
      .CLK(clk),                       // 1-bit input: Clock input
      .INMODE(5'b00000),                 // 5-bit input: INMODE control input
      .OPMODE(7'b0001111),                 // 7-bit input: Operation mode input
      .RSTINMODE(rst),           // 1-bit input: Reset input for INMODEREG

      // Data: 30-bit (each) input: Data Ports
		.A({17'b00000000000000001, Mmax[22:10]}),                           // 30-bit input: A data input
      .B({Mmax[9:0], 8'b00000000}),                           // 18-bit input: B data input
      .C({16'b0000000000000000, Mmin, 8'b0}),                           // 48-bit input: C data input
      .CARRYIN(0),               // 1-bit input: Carry input signal
      .D(25'b0),                           // 25-bit input: D data input
		
		.PCOUT(PCOUT1),
		
      // Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
      .CEA1(1'b1),                     // 1-bit input: Clock enable input for 1st stage AREG
      .CEA2(1'b1),                     // 1-bit input: Clock enable input for 2nd stage AREG
      .CEAD(1'b1),                     // 1-bit input: Clock enable input for ADREG
      .CEALUMODE(1'b1),           // 1-bit input: Clock enable input for ALUMODERE
      .CEB1(1'b1),                     // 1-bit input: Clock enable input for 1st stage BREG
      .CEB2(1'b1),                     // 1-bit input: Clock enable input for 2nd stage BREG
      .CEC(1'b1),                       // 1-bit input: Clock enable input for CREG
      .CECARRYIN(1'b1),           // 1-bit input: Clock enable input for CARRYINREG
      .CECTRL(1'b1),                 // 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
      .CED(1'b1),                       // 1-bit input: Clock enable input for DREG
      .CEM(1'b1),                       // 1-bit input: Clock enable input for MREG
      .CEP(1'b1),                       // 1-bit input: Clock enable input for PREG
      .RSTA(rst),                     // 1-bit input: Reset input for AREG
      .RSTALLCARRYIN(rst),   // 1-bit input: Reset input for CARRYINREG
      .RSTALUMODE(rst),         // 1-bit input: Reset input for ALUMODEREG
      .RSTB(rst),                     // 1-bit input: Reset input for BREG
      .RSTC(rst),                     // 1-bit input: Reset input for CREG
      .RSTCTRL(rst),               // 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
      .RSTD(rst),                     // 1-bit input: Reset input for DREG and ADREG
      .RSTM(rst),                     // 1-bit input: Reset input for MREG
      .RSTP(rst)                      // 1-bit input: Reset input for PREG
   );

	// Assign result sign
	assign PSgn = (MaxAB ? Sb : Sa) ;

endmodule
