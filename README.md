DSP48E1-FP
======

A floating point unit written in Verilog for a Virtex-6 FPGA. The goal is to use the DSP48E1 DSP slice for as many of the computations as possible.

The project includes test fixtures for all individual modules. 

###Structure
======
	+ FPAddSub/                             -- Top Module
		- FPAddSub_PreAlignModule			-- Pre-Alignment Module
		- FPAddSub_AlignModule              -- Mantissa Alignment Module
		- FPAddSub_ExecuteModule            -- Mantissa Addition Module
		+ FPAddSub_NormalizeModule/         -- Normalization Module
			- FPAddSub_LNCModule            -- Leading Nought Counter
		- FPAddSub_RoundMoudle				-- Rounding Module