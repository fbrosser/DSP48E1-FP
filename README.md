DSP48E1-FP
======

A floating point unit written in Verilog for a Virtex-6 FPGA. The goal is to use the DSP48E1 DSP slice for as many of the computations as possible.

The project includes test fixtures for all individual modules. 

###Structure
======
	+ FPU									-- Top Module
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