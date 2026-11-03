# ATM_Controller

## Project description
A project specification area for modeling the control flow of a simplified automated teller machine (ATM). No implementation files are currently present.

## Objective
Describe and verify a controller that sequences a clearly defined set of ATM transaction states and responds correctly to user inputs and transaction outcomes.

## Hardware/design concept
A typical controller can be represented as a finite-state machine with states for idle, input/selection, processing, and completion or error handling. The actual state set, transitions, timing, reset behavior, and transaction scope must be decided by the implementation. This project is a digital-design exercise, not a connection to banking systems or real payment infrastructure.

## Verilog module details
No Verilog modules are included yet. Document the actual module name, clock/reset interface, inputs, outputs, state encoding if relevant, and supported transaction sequence after adding the source.

## Testbench details
No testbench is included. A future testbench should drive valid and invalid sequences, check state/output progression and reset behavior, and verify any implemented success or failure paths. Avoid representing undocumented behavior as supported.

## Simulation instructions
After adding HDL and a testbench, compile the actual files in ModelSim, set the testbench as the simulation top, run through the transaction scenarios, and inspect transcript and waveforms. There are no HDL files in this folder yet.

## Expected output
The controller should produce the documented control outputs and state progression for each tested sequence. No implementation or simulation results are currently available.
