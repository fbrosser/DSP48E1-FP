

module regfile (
	input clk,
	input InSel,
	input RAMSel,
	input [31:0] A,
	input [31:0] B,
	input [31:0] C,
	input [31:0] W
);

    RAM32M_Block : for I in 0 to 15 generate
    begin
      ram32m_i : RAM32M
        port map (
          WCLK  => Clk,
          WE    => WB_GPR_Wr_std,
          ADDRD =>W,
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

endmodule