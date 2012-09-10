DSP48E1-FP
======

A floating point adder/subtractor, written in Verilog for a Virtex-6 FPGA. The goal is to use the DSP48E1 DSP slice for all computations. The purpose of this project is mainly as a test and for verilog training.

###Structure
======
    + FPAddSub/                               -- Top Module
         - FPAddSub_AlignModule               -- Mantissa Alignment Module
         - FPAddSub_ExecuteModule             -- Mantissa Addition Module
         + FPAddSub_NormalizeModule/          -- Normalization Module
              - FPAddSub_LNCModule            -- Leading Nought Counter