DSP48E1-FP
======

A floating point unit written in Verilog for a Virtex-6 FPGA. The goal is to use the DSP48E1 DSP slice for as many of the computations as possible,
and to create a lean implementation of a floating point core running at 400 MHz with reasonable accuracy for single precision IEEE754 floating point numbers.

Current pipelined implementation has a latency of 9 clock cycles and is running at a clock frequency of 400 MHz (Post-PAR). The implementation follows the
IEEE754 Single precision standard and supports the default IEEE754 rounding modes (round to nearest, tie to even) and all the exception flags apart from signalling NaNs, 
which have been omitted in order to reduce complexity.

The project includes test fixtures for all individual modules and for the unit as a whole. 

###Project Structure
======
	+ FPU/										
		+ FPMult/                          	 	-- Multiplier top module
			- FPMult_ESExecuteModule     	 	-- Exponent and sign execution module
			- FPMult_ExecuteModule        		-- Mantissa Multiplication module
			- FPMult_NormalizeModule      		-- Normalization Module
			- FPMult_RoundMoudle				-- Rounding and postrounding normalization module
			- FPMult_ExceptionMoudle			-- Exception checking and flag raising module
		+ FPMult_DSP48E1/                       -- Multiplier top module
			- FPMult_DSP48E1_PrepModule			-- Operand preparation module
			+ FPMult_ExecuteModule        		-- Mantissa Multiplication module
				- DSP48E1_1						-- Instantiation of two DSP48E1 slices
				- DSP48E1_2						-- Combined for a 35x18 bit multiplier
			- FPMult_NormalizeModule      		-- Normalization module
			- FPMult_RoundMoudle				-- Rounding and postrounding normalization module
		+ FPAddSub/								-- Adder/Subtractor top module					
			- FPAddSub_PrelignModule          	-- Mantissa Prelignment and Exponent Logic module
			- FPAddSub_AlignShiftModule1      	-- Mantissa Shift Stage 1 module
			- FPAddSub_AlignShiftModule2      	-- Mantissa Shift Stage 2 module
			- FPAddSub_AlignShiftModule3      	-- Mantissa Shift Stage 3 module
			- FPAddSub_ExecuteModule          	-- Mantissa Addition module
			- FPAddSub_NormalizeModule/       	-- Normalization module
			- FPAddSub_NormShiftModule1       	-- Normalization Shift Stage 3 module
			- FPAddSub_NormShiftModule2       	-- Normalization Shift Stage 3 module
			- FPAddSub_NormShiftModule3       	-- Normalization Shift Stage 3 module
			- FPAddSub_RoundMoudle			  	-- Rounding module and error checking