# alu and flipflop

## Project description
An introductory project area for exploring combinational arithmetic logic alongside sequential storage. No implementation files are currently present.

## Objective
Document and verify the distinction between logic that computes directly from current inputs and flip-flop logic that stores state across clock edges.

## Hardware/design concept
The intended design combines or compares a small arithmetic/logic datapath with one or more clocked storage elements. The exact operations, widths, reset behavior, and datapath-to-register connections must be defined by the eventual design.

## Verilog module details
No Verilog modules are included yet. Add documentation here for each actual module's name, ports, widths, clocking, reset polarity, and behavior once the source is added. Do not infer an interface from this README.

## Testbench details
No testbench is included. A future testbench should check representative arithmetic/logic input combinations and verify stored values across clock edges, including any implemented reset or enable behavior.

## Simulation instructions
After adding the design and testbench, compile the actual `.v`/`.sv` files in ModelSim, select the testbench as the simulation top, run the test, and inspect its transcript and waveforms. There are no source files to compile in the current folder.

## Expected output
When implemented, combinational results should agree with the selected operation and operands, while registered values should update only according to the implemented clock and control behavior. These are verification expectations, not measured simulation results.
