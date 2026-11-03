# FPGA Projects

A collection of digital-design and FPGA learning projects written in Verilog and intended for simulation with ModelSim. The repository is organized by project under [`PROJECTS/`](PROJECTS/README.md).

> **Source status:** The project folders currently contain documentation only; no Verilog design or testbench source files were present when this README was prepared. Descriptions below document the intended project scope, not verified implementations or simulation results.

## Project catalog

| Project | Focus |
| --- | --- |
| [alu and flipflop](alu%20and%20flipflop/README.md) | Introductory arithmetic logic and sequential storage concepts. |
| [ALU-4BIT](ALU-4BIT/README.md) | Four-bit arithmetic and logic operations. |
| [ATM_Controller](ATM_Controller/README.md) | Transaction-control logic modeled as a finite-state machine. |
| [FLIPFLOP-3BIT](FLIPFLOP-3BIT/README.md) | Three-bit state storage using flip-flops. |
| [HALF-ADDER](HALF-ADDER/README.md) | One-bit binary addition. |
| [Washing Machine](Washing%20Machine/README.md) | Washing-cycle sequencing with a controller state machine. |

## Working with a project

1. Open the selected project folder and review its README for intended behavior and verification goals.
2. Add the corresponding Verilog design and testbench files before attempting simulation.
3. Compile the actual source files in ModelSim, run the testbench, and compare the observed waveforms or transcript with the documented expectations.

No FPGA device, board constraints, pin assignments, or synthesis target are specified in the repository at this time. Add those details when a project is prepared for hardware implementation.
