-------------------------------------------------------------------------
-- Fredrik Brosser
-- Embedded Systems
--
-- FILE
-- TemperatureModule.vhd
-- Last Updated: 2012-08-13
--
-- VERSION
-- Simulation v1.0
--
-- HARDWARE
-- Target Device: -
-- I/O Pins Used: N/A
-- Macrocells Used: N/A
-- Product Terms Used: N/A
--
-- DESCRIPTION
-- Implementation of the FFT algorithm in a FPGA,
-- for comparision with programmable DSP
-------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

Entity FFTFPGA is
	port(	
		-- Global clock
		clk 	:	in 	std_logic;
		-- Global reset (internal)
		rst 	:	in 	std_logic
	);
end FFTFPGA;

Architecture Behavioral of FFTFPGA is
	-- Internal signal declarations
	signal 	dummy			:	std_logic;
	signal 	dummy_vector_4 	:	std_logic_vector(3 downto 0);  	
	-- State variable (as integer)
	signal state 			 	: integer range 0 to 3;
	signal nextState 		 	: integer range 0 to 3;
	-- Constant delcrations
	constant dummy_const 	: std_logic_vector := "1010";

	-- Begin architecture
	begin
	
-------------------------------------------------------------------------
-- SyncP, synchronous process responsible for the system clock
--
-- NB! : This is the only clocked process
--
-------------------------------------------------------------------------
	SyncP : process(clk, rstInt)
	begin
		if(not(rstInt) = '1') then 
			state 		<= 0;
		elsif(clk'Event and clk = '1') then
			state 		<= nextState;
		end if;
	end process;
	
-------------------------------------------------------------------------
-- ComP, State Machine handling all combinatorics, setting output signals and responding properly to incoming inputs
--
-------------------------------------------------------------------------
	ComP : process(state)
	begin
		-- Defaults
		nextState 		<= state;

		case state is
			when 0 =>
				nextState 	<= 0;
			when 1 =>
				nextState 	<= 0;
			when 2 =>
				nextState 	<= 0;
			when 3 =>
				nextState 	<= 0;
			when others =>
				nextState 	<= 0;
				
		end case;	
	end process;
end Behavioral;
