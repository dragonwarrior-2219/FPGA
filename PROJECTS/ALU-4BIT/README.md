# ALU-4BIT

## Project description
A project specification area for a four-bit arithmetic logic unit (ALU). No design or testbench source files are currently present.

## Objective
Define and verify a four-bit datapath that selects among documented arithmetic and/or logic operations and produces the corresponding result and any explicitly specified status flags.

## Hardware/design concept
An ALU is combinational logic: its result is determined by the operand inputs and operation select. The operation set, result width, carry/overflow semantics, and flag behavior must be established by the actual design before they can be documented as implemented.

## Verilog module details
No Verilog module is included yet. The future module documentation should state its real module name, operand and result widths, operation-select encoding, supported operations, and flag definitions. No interface is assumed here.

## Testbench details
No testbench is included. A future testbench should exercise each implemented operation using boundary and representative operand values, and check result and flag behavior against an independently specified expected value.

## Simulation instructions
Once source and testbench files exist, compile those files in ModelSim, set the testbench as the simulation top, run it, and inspect the transcript/waveforms. This folder currently has no HDL source to compile.

## Expected output
For each documented operation, the result should match that operation applied to the two four-bit operands, with flags following the design's stated definitions. No simulation output has yet been produced or verified.
