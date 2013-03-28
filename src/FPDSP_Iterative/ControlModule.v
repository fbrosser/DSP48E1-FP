

module ControlModule(clk, rst, operation, run);

	 // Inputs
	 input clk;
	 input rst;

	 input [1:0] operation;
	 input run;
	 
	 // Registered Outputs
	 output reg [31:0] INSel;
	 output reg [3:0] ALUMODE;
	 output reg [6:0] OPMODE;
	 output reg [4:0] INMODE;
	 output reg MemWrite;
	 output reg WriteBack;
	 output reg FwdDSP;
	 output reg ReadData;
	 output reg A2D;
	 output reg B2D;
	 output reg C2D;
	 
	 // One cycle earlier!
	 output RAMSel;
	 
	 // Unregistered Outputs
	 output DoRAMRead;
	 output StoreSkip;
	 output ready;
	 
	// States
	parameter 	Start			= 3'b000,
					Prealign 	= 3'b001, 
					Align 		= 3'b010,
					Execute 		= 3'b011,
					Normalize 	= 3'b100,
					Round 		= 3'b101,
					Exception 	= 3'b110; 
					
	// State registers
	reg [3:0] nextState;
	reg [3:0] state;
	
	// Internal registers
	reg [17:0] K;
	// C Buffer register
	reg [47:0] CReg;
	
	reg [1:0] It;
	
	reg [1:0] doOp;
	
	// Synchronous (clocked) process
	// Synchronous reset
	always @ (posedge clk) begin
		if(rst) begin
			state <= Start;
		end
		else begin
			state <= nextState;
		end
	end
	
	// Combinatorial process
	// Outputs and next-state-generation
	always @ * begin
	
		// Default selector signals
		It = 2'b00;		// no it
		CReg = 32'b0;
		K = 18'b111111111111111111;	
		state = 1'b0;	
		RAMSel = 1'b0;
		DoRAMRead = 1'b0;
		StoreSkip = 1'b0;
		ready = 1'b0;
			
		// Default: stay in current state
		nextState = state;
		
		case (state)
			Start : begin
				nextState = PreAlign;
				doOp[1] = operation[0] & ~(run);
				doOp[0] = operation[1] & ~(run);
				DSP_A = 30'b0;
				DSP_B = {1'b0, B[30:23], 1'b0, A[30:23]};
				DSP_C = {30'b0, 1'b1, A[30:23], 1'b1, B[30:23]};
			end
			
			PreAlign : begin
				DSP_A = 30'b0;
				DSP_B = {1'b0, B[30:23], 1'b0, A[30:23]};
				DSP_C = {30'b0, 1'b1, A[30:23], 1'b1, B[30:23]};
				RAMSel = 1'b0;
				DoRAMRead = 1'b1;
			end	
		
			Align : begin
				if(^operation) begin
					ALUMODE = {4'b00101};
					INMODE = {5'b00111};
					OPMODE = {7'b00000};
				end else begin
					ALUMODE = {4'b1111};
					INMODE = {5'b000101};
					OPMODE = {7'b00011};				
				end				
				StoreSkip = 1'b0;
				nextState = ^it ? Align : Execute;
			end	
			
			Execute : begin
				DSP_A = 30'b0;
				DSP_B = {1'b0, B[30:23], 1'b0, A[30:23]};
				DSP_C = {30'b0, 1'b1, A[30:23], 1'b1, B[30:23]};
				if(^operation) begin
					ALUMODE = {4'b00011};
					INMODE = {5'b000101};
					OPMODE = {7'b00000};
				end else begin
					ALUMODE = {4'b1111};
					INMODE = {5'b000101};
					OPMODE = {7'b00011};				
				end
				StoreSkip = 1'b0;
				nextState = ^it ? Execute : Normalize;
			end	
			
			Normalize : begin
				DSP_A = 30'b0;
				DSP_B = {1'b0, B[30:23], 1'b0, A[30:23]};
				DSP_C = {30'b0, 1'b1, A[30:23], 1'b1, B[30:23]};
				// Same for both operations
				ALUMODE = {4'b0000};
				INMODE = {5'b00000};
				OPMODE = {7'b11000};	
				RAMSel = 1'b1;
				ready = 1'b1; // Registered
				nextState = ^it ? Normalize  : Start;
			end
			
			default: begin		
			end
				
		endcase
	end
			
endmodule		// End of Control module
