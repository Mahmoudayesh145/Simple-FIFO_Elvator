# Simple FIFO Elevator System

Welcome to the Simple FIFO Elevator System! This project implements a robust elevator controller written in Verilog, designed to handle multiple floors efficiently using a First-In-First-Out (FIFO) queue for request scheduling.

## Overview

Traditional elevators can sometimes feel inefficient when multiple people request rides simultaneously. This hardware design solves that by organizing floor requests in a FIFO buffer, ensuring fairness and preventing starvation for any single request.

## Key Features

- **Verilog Implementation:** Entirely written in Verilog for easy integration into FPGA or ASIC designs.
- **FIFO Request Queue:** Guarantees that the first person to press the button is the first one served.
- **Modular Design:** Split into separate, manageable modules including the main elevator logic, the FIFO buffer, and the top-level system wrapper.
- **Simulation Ready:** Includes a comprehensive testbench to verify logic and timing in a simulation environment.

## File Structure

- elevator_system.v - The top-level module connecting the elevator and the FIFO buffer.
- elevator.v - The core state machine and movement logic for the elevator.
- FIFO.v - The queue data structure for storing and retrieving floor requests.
- main.v - A wrapper/instantiation point for system integration.
- testbench_elevator.v - Testbench for running simulation and verifying behavior.

## How It Works

1. A user presses a call button on a floor or a destination button inside the elevator.
2. The request is pushed into the FIFO queue.
3. The elevator checks the queue. If it's not empty, it pops the oldest request.
4. The elevator state machine moves the cabin to the requested floor, opens the doors, and then proceeds to the next request in the queue.

## Getting Started

To simulate this design, you can use ModelSim, Vivado, or any standard Verilog simulator:

1. Add all the `.v` files to your simulation project.
2. Set `testbench_elevator.v` as the top-level simulation module.
3. Run the simulation and observe the waveforms to see the elevator navigate through the requested floors.

## License

This project is open-source and available for educational and personal use. Feel free to explore, modify, and simulate!
