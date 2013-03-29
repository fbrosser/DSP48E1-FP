

module RAMModule (
	input clk,
	input InSel,
	input RAMSel,
	input [31:0] A,
	input [31:0] B,
	input [31:0] C,
	input [31:0] W
);


  wire   [1:0] DOA ;
  wire   [1:0] DOB ; 
  wire   [1:0] DOC  ;  
  wire   [1:0] DOD  ;  

  wire   [4:0] ADDRA ;
  wire   [4:0] ADDRB ;
  wire   [4:0] ADDRC ;
  wire  [1:0] ADDRD ;
  wire  [1:0] DIA    ;
  wire  [1:0] DIB    ;
  wire  [1:0] DIC    ;
  wire  [1:0] DID    ;

    RAM32M_Block : for I in 0 to 15 generate
    begin
      ram32m_i : RAM32M
        port map (
          WCLK  => Clk,
          WE    => WB_GPR_Wr_std,
          ADDRD => W,
          ADDRA => A,
          ADDRB => B,
          ADDRC => C,
          DIA => Rd(I*2 to I*2+1),
          DIB => Rd(I*2 to I*2+1),
          DIC => Rd(I*2 to I*2+1),
          DID => Rd(I*2 to I*2+1),
          DOA => RAMOp(I*2 to I*2+1),
          DOB => RAMOp(I*2 to I*2+1),
          DOC => RAMOp(I*2 to I*2+1)
         );
    end generate RAM32M_Block;

  parameter (
      INIT_A = 18'b0000000000000000;
      INIT_B = 18'b0000000000000000;
      INIT_C = 18'b0000000000000000;
      INIT_D = 18'b0000000000000000
    );

  always @( ADDRA, MEM_a) 
  begin
    integer Index_a = 2 * SLV_TO_INT(SLV => ADDRA);
    DOA [0] = MEM_a(Index_a);
    DOA [1] = MEM_a(Index_a + 1);
  end 

  always @ ( ADDRB, MEM_b) 
  begin
    integer Index_b = 2 * SLV_TO_INT(SLV => ADDRB);
    DOB[0] = MEM_b(Index_b);
    DOB[1] = MEM_b(Index_b + 1);
  end 

  always @ ( ADDRC, MEM_c) 
  begin
    integer Index_c := 2 * SLV_TO_INT(SLV => ADDRC);
    DOC[0] <= MEM_c(Index_c);
    DOC[1] <= MEM_c(Index_c + 1);
  end

  always @ ( ADDRD, MEM_d) 
  begin
    integer Index_d := 2 * SLV_TO_INT(SLV => ADDRD);
    DOD[0] <= MEM_d(Index_d);
    DOD[1] <= MEM_d(Index_d + 1);
  end

  always @ (posedge clk)
  begin
      if (InSel = 1'b1) begin
       integer Index = 2 * SLV_TO_INT(SLV => ADDRD);
       MEM_a(Index) <= DIA(0)  ;
       MEM_a(Index+1) <= DIA(1);
       MEM_b(Index) <= DIB(0)  ;
       MEM_b(Index+1) <= DIB(1);
       MEM_c(Index) <= DIC(0)  ;
       MEM_c(Index+1) <= DIC(1);
       MEM_d(Index) <= DID(0)  ;
       MEM_d(Index+1) <= DID(1);
     end
  end

endmodule
