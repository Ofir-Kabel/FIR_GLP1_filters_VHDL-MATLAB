# FIR GLP1 Filter Project

## Description

This project involves the design and simulation of Finite Impulse Response (FIR) General Linear Phase 1 (GLP1) filters using MATLAB and VHDL. The project aims to explore digital filter design techniques and simulate their effects on signals with various frequencies.

### Project Highlights

- **Filter Design in MATLAB**: FIR GLP1 filters were designed from scratch using MATLAB. The design process did not rely on built-in MATLAB functions, allowing for a deeper understanding of the filter design principles.
  
- **Coefficient Conversion**: The filter coefficients were converted to hexadecimal format and saved in a text file. This conversion was crucial for the subsequent implementation in VHDL.

- **Signal Simulation**: A signal with three different frequencies was simulated in MATLAB to test the filters. The simulated signal and filter coefficients were then used in the VHDL simulation.

- **VHDL Implementation**: The filter coefficients and input signals were integrated into a VHDL script in Xilinx Vivado. This script was used to run source and testbench simulations to verify the filter's performance.

- **Simulation-Only Approach**: The project was conducted entirely through simulation and was not implemented on a physical FPGA board.

## Features

- Custom design of FIR GLP1 filters in MATLAB.
- Conversion of filter coefficients and test signals to hexadecimal format for VHDL implementation.
- Simulation of the filter's response to input signals with three different frequencies.
- Verification of filter performance through VHDL simulation using testbench files.

## Usage

### MATLAB

1. **Design Filters**

   - Open `FIR_FPGA_Blackman.m` in MATLAB.
   - Run the script to generate FIR GLP1 filter coefficients signal with three different frequencies.
   - Coefficients are saved in `FIR_GLP1_coeff.txt`.

   - Open `generate_signal.m` in MATLAB.
   - Run the script to generate signals with three different frequencies.

### Vivado

1. **Set Up Project**

   - Open Xilinx Vivado and create a new project.
   - Import the VHDL files from the `vhdl/` directory.
   - Add `FIR_GLP1_coeff.txt` and test signals as source files.

2. **Run Simulations**

   - Open the simulation environment in Vivado.
   - Add the testbench files from `testbench/`.
   - Run the simulation to verify the filter's behavior with input signals.

## Results

### Signal Before and After Filtering

- **FREQ Domain Filtering**: The signal with three different frequencies before applying the FIR filters.

![output signals freq domain](https://github.com/user-attachments/assets/18278219-7ac0-45e9-a045-234592be8ebd)


- **TIME Domain Filtering**: The signal after applying the FIR filters, showing the effect of the filters.
 
![output signals time domain ](https://github.com/user-attachments/assets/3410267e-a87f-404a-8585-3ef03faa0c51)


### Filter Response

- **Filter in Time Domain**: The time domain representation of the FIR GLP1 filters.

![filters time domain](https://github.com/user-attachments/assets/4e917938-34fb-4cc3-b366-d293e78f5937)


- **Filter in Frequency Domain**: The frequency domain representation of the FIR GLP1 filters.

![filters freq domain  db](https://github.com/user-attachments/assets/9b057016-0f7c-470c-8bc7-6446e170deaf)


### Vivado Simulation

- **Vivado Simulation Output**: The results of the VHDL simulation in Vivado, demonstrating the filter's performance.

![vivado_FIR_sim](https://github.com/user-attachments/assets/2e037690-8b9b-4d28-b935-cefb89f7aa70)


## Acknowledgments

- The filter design principles were learned during a DSP laboratory course at my university.
- Special thanks to [VHDLwhiz](https://www.vhdlwhiz.com) for providing insights into convolution function implementation and DSP slice usage in VHDL.


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

