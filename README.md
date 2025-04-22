# AXI4-Stream Protocol Implementation Example (Verilog)

This repository contains a simple, beginner-friendly Verilog implementation of the **AXI4-Stream protocol**. The design demonstrates how to model streaming data transfer between modules using AXI4-Stream handshaking signals such as `TVALID`, `TREADY`, and `TDATA`.

---

## 🚀 Overview

AXI4-Stream is a lightweight, high-speed data streaming protocol widely used in FPGA designs and IP cores. This repository shows a practical, minimal example of:

- Creating an AXI4-Stream **data producer**.
- Implementing an AXI4-Stream **data consumer**.
- Managing the handshaking mechanism using `TVALID` and `TREADY`.
- Transmitting `TDATA` when both ends are ready.

---

## 📂 Repository Structure

```
AXI4-Stream-Protocol-Implementaion-Example-Verilog/
├── AXIS_MASTER_FILES/
│   ├── async_fifo.v            # Data producer module
│   └── axis_master_adc.v        
├── AXIS_MASTER_tb/
│   └── adc_model.v              
│   └── t_axis_master_adc.v   
│   └── t_axis_master_adc_bd.v  # Testbench for simulation
├── AXIS_MASTER_SIM/
│   └── AXIS_MASTER_BD.PNG             
│   └── AXIS_Master.PNG         # Simulation
├── AXIS_SLAVE_FILES/
│   └── axis_slave_mem.v        # Data consumer module
├── AXIS_SLAVE_tb/
│   └── t_axis_slave_mem.v      # Testbench for simulation
├── AXIS_SLAVE_SIM/
│   └── AXIS_Slave.PNG          # Simulation
└── README.md                   # Project documentation
```

---

## 🛠️ How to Run

1. Clone the repository:

```bash
git clone https://github.com/engrbilal992/AXI4-Stream-Protocol-Implementaion-Example-Verilog.git
cd AXI4-Stream-Protocol-Implementaion-Example-Verilog
```

2. Open the testbench files in your Verilog simulator (ModelSim, Vivado, Icarus Verilog, etc).

3. Run the simulation to observe the AXI4-Stream handshaking mechanism in action.

---

## 💡 Notes

- The implementation is purely for educational purposes.
- This example focuses on clear signal flow and logic understanding rather than synthesis optimization.
- Easily extendable for more advanced AXI4-Stream designs.

---

## 📘 References

- [AMBA® AXI4-Stream Protocol Specification](https://developer.arm.com/documentation/ihi0051/latest/)
- Xilinx and ARM documentation on AXI interfaces.

---

## 📫 Contact

For questions, feedback, or contributions:

**Muhammad Bilal**  
GitHub: [engrbilal992](https://github.com/engrbilal992)

---