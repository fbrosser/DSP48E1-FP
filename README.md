DSP48E1-FP
======

A floating point unit written in Verilog for a Virtex-6 FPGA. The goal is to use the DSP48E1 DSP slice for as many of the computations as possible,
and to create a lean implementation of a floating point core running at 400 MHz with reasonable accuracy for single precision IEEE754 floating point numbers.

Current pipelined implementation has a latency of 10 clock cycles and is running at a clock frequency of 380 MHz (Post-PAR). The implementation follows the
IEEE754 Single precision standard and supports the default IEEE754 rounding modes (round to nearest, tie to even) and all the exception flags apart from signalling NaNs, 
which have been omitted in order to reduce complexity.

The project includes test fixtures for all individual modules. 

###Structure
======
	+ FPU/									-- Top Module
		- FPU_PrepModule					-- Pre-Alignment, exception checking and splitting of input.
		+ FPMult/                           -- Multiplier top module
			- FPAddSub_ESExecuteModule      -- Exponent and sign execution module
			- FPAddSub_ExecuteModule        -- Mantissa Multiplication Module
			- FPAddSub_NormalizeModule      -- Normalization Module
			- FPAddSub_RoundMoudle			-- Rounding and postrounding normalization module
			- FPAddSub_ExceptionMoudle		-- Exception checking and flag raising module
		+ FPAddSub/                         -- Top Module
			- FPAddSub_AlignModule          -- Mantissa Alignment Module
			- FPAddSub_ExecuteModule        -- Mantissa Addition Module
			+ FPAddSub_NormalizeModule/     -- Normalization Module
				- FPAddSub_LNCModule        -- Leading Nought Counter
			- FPAddSub_RoundMoudle			-- Rounding Module
			- FPAddSub_ExceptionMoudle		-- Exception checking and flag raising module
		+ FPAddSub_Pipelined_Simplified_2_0/
			- FPAddSub_Pipelined_Simplified_2_0_PrelignModule          -- Mantissa Prelignment and Exponent Logic Module
			- FPAddSub_Pipelined_Simplified_2_0_AlignShiftModule1      -- Mantissa Shift Stage 1 Module
			- FPAddSub_Pipelined_Simplified_2_0_AlignShiftModule2      -- Mantissa Shift Stage 2 Module
			- FPAddSub_Pipelined_Simplified_2_0_AlignShiftModule3      -- Mantissa Shift Stage 3 Module
			- FPAddSub_Pipelined_Simplified_2_0_ExecuteModule          -- Mantissa Addition Module
			+ FPAddSub_Pipelined_Simplified_2_0_NormalizeModule/       -- Normalization Module
				- FPAddSub_Pipelined_Simplified_2_0_LNCModule          -- Leading Nought Counter Module
			- FPAddSub_Pipelined_Simplified_2_0_NormShiftModule1       -- Normalization Shift Stage 3 Module
			- FPAddSub_Pipelined_Simplified_2_0_NormShiftModule2       -- Normalization Shift Stage 3 Module
			- FPAddSub_Pipelined_Simplified_2_0_NormShiftModule3       -- Normalization Shift Stage 3 Module
			- FPAddSub_Pipelined_Simplified_2_0_RoundMoudle			   -- Rounding Module and error checking