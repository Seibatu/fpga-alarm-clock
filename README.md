# Alarm Clock ⏰

## Overview
This project implements an **FPGA-based Alarm Clock Controller** using **Verilog and a finite state machine (FSM)** approach. The alarm clock allows users to **set time, set an alarm, and activate/deactivate the alarm**. The system features a **7-segment display**, LED indicators, and a buzzer for alarm notifications.

## Features
✅ **Finite State Machine (FSM)** for clock and alarm control  
✅ **Clock Divider Module** for FPGA timing adjustments from 100MHz to 1Hz  
✅ **Seven-Segment Display Driver** to show time and alarm settings  
✅ **Alarm Control** – Set, Activate, Mute, and Stop the alarm    

---

## 📌 System Architecture
This project consists of the following Verilog modules:

1. **FSM Control Module (`fsmClockCtrl.v`)**  
   - Manages clock operation, state transitions, and alarm logic.  
   - Handles user inputs for setting time and alarm activation.

2. **Clock Divider (`clkDivider.v`)**  
   - Adjusts the FPGA clock frequency from 100MHz to 1Hz to ensure correct timing.  

3. **Binary to BCD Converter (`binaryBCD.v`)**  
   - Converts binary time values into BCD format for display.

4. **Seven-Segment Display Driver (`sevenSegment.v`)**  
   - Drives the 7-segment displays to show the current time and alarm.

5. **Top-Level Module (`topModule.v`)**  
   - Integrates all submodules and manages inputs/outputs.

---

## 🛠️ How to Run It
### 1️⃣ Simulation
To verify the design before FPGA implementation:
1. Open  **Vivado Simulator**.
2. Load `topModule.v` and include all submodules (`fsmClockCtrl.v`, `clkDivider.v`, `binaryBCD.v`, `sevenSegment.v`).
3. Compile and run the testbench (`testbench.v` if available).
4. Observe the waveform in the simulator’s waveform viewer.

### 2️⃣ FPGA Implementation
1. Open **Xilinx Vivado**.
2. Create a new project and add all Verilog files.
3. Configure FPGA pin assignments using `contraints.xdc`.
4. Synthesize, implement, and generate the bitstream.
5. Upload to FPGA and test using switches and buttons.

---

## 📂 Repository Structure
```
📂 src/            # Verilog source files
  ├── binaryBCD.v       # Binary to BCD converter
  ├── clkDivider.v      # Clock divider   
  ├── fsmClockCtrl.v    # FSM controller   
  ├── sevenSegment.v    # Seven-segment display driver  
  ├── topModule.v       # Top-level module  

📂 testbench/      # Testbenches and simulations  
📂 waveforms/      # Simulation waveform images  
📂 docs/           # Documentation  
  ├── schematic_top_l.pdf	  # Top-level schematic
  ├── schematic_top_synth.pdf	  # Top-level synthesis schematic
```

---

## 📸 Simulation Waveform

---

## ✉️ Contact
For any questions or improvements or collaborations, feel free to connect:
- **GitHub:** [Seibatu](https://github.com/Seibatu)
- **LinkedIn:** [Seiba Abdul Rahman](https://www.linkedin.com/in/seiba-abdul-rahman)
