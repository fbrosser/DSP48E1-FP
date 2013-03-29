//`timescale 1ns / 1ps

module FPDSP (
		// Inputs
	 	input clk,
		input rst,
		input [31:0] A,
		input [31:0] B,
		input [1:0] operation,
		input run,
		// Outputs
		output [31:0] result,
		output [4:0] result,
		output ready
    );
	
	wire [31:0] RAM_DSP_B; 
	wire [31:0] RAM_DSP_B;
	wire [31:0] RAM_DSP_C;
	wire [31:0] DSP_RAM_Res;
	wire [31:0] DSP_Res_Fwd;
	
	wire P [17:0] ;
	wire ShAmt [4:0] ;
	wire MaxAB ;

	wire [2:0] opCode1;
	wire [2:0] opCode1;
	wire [31:0] DSPRes;
	wire RoundUp;
	wire DivZero;
	wire ResLoad;
	wire ResLoadResLoadCtrl;
	wire [29:0] DSP_A;
	wire [17:0] DSP_B;
	wire [47:0] DSP_C;
	wire [47:0] DSP_P;
	wire [31:0] PostRoundRes;
	wire [31:0] PostRoundOp;
	
	reg [31:0] CReg;
		
	always @ (posedge clk) begin
		CReg = {1'b1, A, 1'b1, B};
	end
	
	always @ * begin
		MaxAB = P[17];
		if(P[17] == 1'b1) begin
			ShAmt = P[16:9];
		end else begin
			ShAmt = P[7:0];
		end
	end
	
	always @ * begin
		Result = DSPRes;
		ResLoad = ResLoadCtrl;
	end
	
	// Result MUXes from DSP48E1
	assign Result = ResLoad ? DSPRes : DSP_Res_Fwd;

	// Non iterative Prealign Stage
	PrealignModule Prealign (
	// Inputs
		.PA_A(A),
		.PA_B(B),
		.PA_operation(operation),
	// Outputs
		.PA_Sa(Sa),
		.PA_Sb(Sb),
		.PA_ShiftDet(ShiftDet),
		.PA_InputExc(InputExc),
		.PA_Aout(Aout),
		.PA_Bout(Bout),
		.PA_Opout(Opout)
   );
	
	// Control
	ControlModule Control (
	 // Inputs
	 .clk(clk),
	 .rst(rst),
	 .operation(operation),
	 .run(run), 
	 .A2D(A2D);
	 .B2D(B2D);
	 .C2D(C2D);
	 .RAMSel(RAMSel),
	 .DoRAMRead(DoRAMRead),
	 .StoreSkip(StoreSkip),
	 .ready(ready)
   );
	
	
	// RAM32M Instantiation
	RAMModule RAM (
	.Clk(Clk), 
	.Rst(Rst),
	 .InSel(InSel),
	 .RAMSel(RAMSel),
	 .A(A),
	 .B(B),
	 .C(C),
	 .W(W)
   );
	
	
	// DSP48E1 Instantiation
	DSPModule DSP (
	// Inputs
	.Clk(Clk), 
	.Rst(Rst),
	.A(A);
	.B(B);
	.C(C);
	 
	.ALUMode(ALUMode);
	.OpMode(OpMode);
	.InMode(InMode);
	.P(P);
   );
	
	// Non iterative Exception Checking Stage
	ExceptionModule Exceptions (
		.Z(Z),					// Final product
		.NegE(NegE),						// Negative exponent?
		.R(R),							// Round bit
		.S(S),							// Sticky bit
		.InputExc(InputExc),			// Exceptions in inputs A and B
		.EOF(EOF),
		// Outputs
		.P(P),					// Final result
		.Flags(Flags),				// Exception flags
   );

endmodule
