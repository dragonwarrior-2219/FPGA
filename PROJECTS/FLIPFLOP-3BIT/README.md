# FLIPFLOP-3BIT

## Project description
A project specification area for a three-bit storage element or three-bit register built from flip-flops. No design or testbench source files are currently present.

## Objective
Specify and verify how a three-bit value is captured and retained according to the implemented clock, reset, and any optional control signals.

## Hardware/design concept
Flip-flops store state and typically update on a selected clock edge. Reset type and polarity, edge sensitivity, and any enable behavior are implementation choices that must be confirmed from the HDL; they are not assumed here.

## Verilog module details
No Verilog module is included yet. Once implemented, document the actual module name, three-bit data interface, clock and control ports, reset behavior, and whether the design is a single three-bit register or three explicitly instantiated flip-flops.

## Testbench details
No testbench is included. A future testbench should apply multiple data patterns, verify capture on the active edge, confirm retention between edges, and check reset/enable behavior if present.

## Simulation instructions
When the HDL and testbench are added, compile the actual files in ModelSim, select the testbench as the simulation top, run it, and inspect the waveform around clock and control transitions. No source files are currently available to compile.

## Expected output
The stored output should follow the actual design's clock and control semantics and represent the captured three-bit input when updates occur. This is an expected behavior to verify, not a reported simulation result.
