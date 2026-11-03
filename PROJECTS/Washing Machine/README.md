# Washing Machine

## Project description
A project specification area for a simplified washing-machine controller. No Verilog implementation or testbench is currently present.

## Objective
Define and verify sequencing for a simplified wash cycle, including only the phases and control outputs explicitly implemented by the design.

## Hardware/design concept
The controller can be modeled as a finite-state machine whose states represent cycle phases and whose transitions depend on clocking, timers, or input conditions. The actual phases, timing model, interlocks, and outputs must be determined from the HDL; this documentation does not claim a functional appliance controller.

## Verilog module details
No Verilog modules are included yet. Once source is added, document the real module name, clock/reset behavior, inputs, outputs, state sequence, and how any delays or timers are modeled in simulation.

## Testbench details
No testbench is included. A future testbench should drive start/reset and any implemented conditions, then check the documented sequence and control outputs, including reset and interruption behavior where supported.

## Simulation instructions
After adding HDL and a testbench, compile the actual files in ModelSim, select the testbench as the simulation top, run through the modeled cycle, and inspect its transcript and waveforms. There are no HDL files to compile yet.

## Expected output
The controller should traverse the documented cycle states and assert only the control outputs specified by its implementation. No design or simulation results are currently available.
