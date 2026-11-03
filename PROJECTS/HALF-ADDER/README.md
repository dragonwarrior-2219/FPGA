# HALF-ADDER

## Project description
A project specification area for a one-bit half-adder. No Verilog implementation or testbench is currently present.

## Objective
Specify and verify binary addition of two one-bit inputs, producing a sum bit and carry bit.

## Hardware/design concept
A half-adder is combinational logic. For inputs `A` and `B`, the sum is `A XOR B` and the carry is `A AND B`. It has no carry-in input.

## Verilog module details
No Verilog module is included yet. Document the actual module name and port names when source is added; the expected logical interface is two one-bit inputs and one-bit sum and carry outputs, but no HDL interface is claimed to exist.

## Testbench details
No testbench is included. A future testbench should apply all four input combinations (`00`, `01`, `10`, `11`) and check both outputs against the half-adder truth table.

## Simulation instructions
After adding the HDL and testbench, compile the actual source files in ModelSim, select the testbench as the simulation top, run all four cases, and inspect transcript or waveforms. This folder currently contains no HDL files.

## Expected output
Expected truth table:

| A | B | Sum | Carry |
| --- | --- | --- | --- |
| 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 1 |

These are the standard half-adder expectations; no simulation has been run in this repository yet.
