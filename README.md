# SoC

Creation of an ASIC that performs computations with vectors. 

Team members: Dimkou Eleni, Karagiannis Marios, Lianidis Theodorοs


# **Topic of Work:**

## Implementation of a digital integrated system with a specific application (ASIC), specifically the construction of a calculator for vectors. 

![image](https://user-images.githubusercontent.com/77272704/231000038-a07edc4a-c66e-4a45-aae5-6f568058bba9.png)
  
*For this project, we will be using the Design Compiler tool and Prime Time tool from Synopsys and INNOVUS from Cadence.

The process we followed to create our ASIC is shown in the Figure bellow.
![image](https://user-images.githubusercontent.com/77272704/231000261-748189ee-5de7-46e5-bbb3-a55e0c69ca0e.png)

Specifically, we have created a unit that performs two operations with vectors of 2, 3, or 4 dimensions: 
  
➢ **Inner product of two vectors**

➢ **Length of a vector**

To execute the inner product function, we used 2 pre-made modules (add, mult) and for the length function, we used 3 pre-made modules (add, mult, root). Additionally, we have created a finite state machine (FSM) that, based on our 4-bit func signal, performs the appropriate operation assigned to it through the test bench. Finally, we have created a top-level module that calls the aforementioned modules.

Some of the conventions we have implemented for creating our unit are:
1. All inputs and outputs are 32 bits long fixed point numbers, of which:
	 - 16 bits are for decimal digits
	 - 15 bits are for integer digits
	 - 1 bit (the most significant) is for sign indication (1 for <0, 0 for >0)
2. For each of the operations, we will take the 4 dimensions as inputs. However, if we want to calculate in the 2nd/3rd dimension, the inputs of the dimensions that are not used will be zeroed out through the FSM so as not to affect the result. In any case, all operations of each function will be performed regardless of the dimension of the vector.


## MODULES

#### Multiplication:

➢ Calculates the product of two inputs using the left shift & add algorithm. 

➢ Requires multiple clock cycles. 

➢ Includes an indicator for overflow.

#### Addition:

➢ Calculates the sum of two inputs.

➢ Fully combinational circuit.

#### Root:

➢ Calculates the square root of an input with an accuracy of 3 decimal digits. 

➢ Requires multiple clock cycles.

#### FSM: 

➢ Activated by the "func" signal received from the top-module, this module selects the appropriate operation (begin_l=1, begin_ip=0 or begin_ip=1, begin_l=0) and provides the necessary input values to execute our program.

#### Calculator:

➢ This is our top-module, which has 10 inputs (8 dimensions - 2 vectors, func, clock) and 3 outputs (length_final, ip_final, overflow). It calls all the modules mentioned above.


## **TESTING**

We tested 12 sets of inputs (2 vectors * 4 dimensions = 8 inputs in each case) and passed them through every possible combination of operation and number of dimensions (6 different possible combinations). The inputs cover positive and negative numbers, integers, and decimals. Finally, we tried to disable the calculator to check if the inputs actually freeze.

The waveforms that have emerged after the simulation process are the following:
![image](https://user-images.githubusercontent.com/77272704/231000486-871d5165-28f8-4e6c-a78d-7b8d68ad63b4.png)
It's worth noting the 8-bit signal overflow, where in case of overflow in one of our multiplications, it notifies us by setting the bit where the overflow occurred from (0→1).
  
  
## **LOGIC-SYNTHESIS**

At this stage, our goal is to convert the arithmetic operators into optimized gate-level netlist using the Nangate library. To accomplish this, we created TCL scripts in Design Compiler for both the **Top-Down and Bottom-Up approaches**.


### Top-down:

Following the philosophy of top-down compile, we elaborated the top-level module (calculator), which in turn will call the remaining modules and ultimately generate .sdf, .ddc, and .v files, as well as reports on timing and area reports.
![image](https://user-images.githubusercontent.com/77272704/231002186-1400dcb4-9ba5-4df1-a6cd-a4e5f3c6815d.png)

After generating a synthesizable Verilog file from the above script, the next step is to pass it through the Simulation process along with the provided Nangate library in order to generate new waveforms, which we will then compare to the original ones.

The waveforms that were generated are the following and as we can see, they are identical to our initial design.
![image](https://user-images.githubusercontent.com/77272704/231002261-8aebb0db-7f09-436a-a7f8-a14005478431.png)
  
Next, we change the clock period and record the results of the area report execution, in order to create a Pareto curve.
![image](https://user-images.githubusercontent.com/77272704/231002352-cd2b67fe-22d8-4c0a-8bef-c97ca8545e1d.png)
As we can see from the Pareto curve we generated for various clock values, we observe that firstly, the minimum clock period we can set for our top-down script clock is 5.8ns, so that our design can be completed with an area of 19804.4977. Secondly, as the clock period increases, the area is minimized and then stabilized at ≈19087.

### Bottom-Up:

According to the philosophy of Bottom-up compile, we have created a hierarchy for our project. We have determined that we have four modules (add, mult, fsm, root) which are at the same level of the hierarchy, and the top-level module (calculator) which calls all of the previous modules. Therefore, we have two levels of hierarchy.

We created separate TCL scripts for each of the lower-level modules, and from each of these scripts, we will export the corresponding ddc file as well as the timing-area reports and then we created the script for the top-level module (calculator), which “calls” all the .ddc files generated by the previous scripts and produces the final synthesized .v file.
Afterwards, we follow the same process as the top-down method to generate waveforms from the final synthesized .v file. The waveforms generated are:
![image](https://user-images.githubusercontent.com/77272704/231002963-1e9410e7-d236-45ad-ae54-9f4714990bcc.png)
 
We extract another Pareto curve of the Area as a function of period.
![image](https://user-images.githubusercontent.com/77272704/231003025-f175a9bd-bd9a-4079-a23c-d61f249e5c67.png)
As before, we observe that firstly the minimum period value that we can set for the clock in the Bottom-up script is 3.35ns with an area of 21432.6836, and as the period increases, the area is minimized and then stabilizes at ≈18558.


## **PHYSICAL-SYNTHESIS**

Using INNOVUS we will build our chip. 
  
Initially, we imported the synthesized top-down verilog file, the Nangate library lef file, and set up the design analysis by defining the libraries and timing constraints using Nangate's worst/best cases scenario.

![image](https://user-images.githubusercontent.com/77272704/231003335-7cdc62a1-39ad-4283-a6d7-1eca2fbb17f4.png)

Firstly, the first stage of back-end is **Floor Planning**. 

*Chip Outlining:* After defining (1) the aspect ratio ≈ 1 which defines the dimensions of the chip core as the ratio of height to width, (2) the core utilization ≈ 70% which determines the sizes of the core and units based on total-standard-cells and macros density, and the core I/O boundary distances at 8μm in all directions. 

*P/G Network Design:* We place the VDD, VSS rings around the perimeter of the chip and design power/ground stripes (vss-vdd stripes) to connect the P/G rings with the standard cells.

Next comes the Placement stage, where we place the instances cells after defining that our chip can use up to 10 metal layers.
![image](https://user-images.githubusercontent.com/77272704/231003615-96be6101-06bd-4d58-8d1a-4b5c113b15f9.png)
![image](https://user-images.githubusercontent.com/77272704/231003645-63611d6e-819d-4a0e-81cf-e4803f590df3.png)

The next step is **Clock Tree Synthesis (CTS)** where we created a clock tree that satisfies the defined timing, area, and power requirements. It helps to provide clock connection to the clock pin of a subsequent element at the required time and area, with low power consumption. 
Then, we inserted buffers and inverters and performed ccopt, which optimized the clock tree of our design and finally we ran post-CTS optimization.

**Filler cell placement.** We introduced filler cells to cover any “gaps” that our chip may have had.

**Design Routing.**  We created all the wires required to connect the cells according to our imported gate-level netlist and we ran a post-routing optimization-hold. 

Finally, we verified our chip for **Connectivity, Geometry, and DRC violations**.

After successfully completing all the above stages, the view of our chip is as follows:
![image](https://user-images.githubusercontent.com/77272704/231003948-3d3f02ef-cc7e-4e63-b0aa-b1c19066eb19.png)

After that we exported the .v, .sdf, .spef (calculator.v, calculator.sdf, calculator.spef) files to verify that the chip we created works correctly and as we initially intended. To verify this, we followed the following steps: 
    - We took the .v, .sdf files from Innovus and the .v file from Nangate, and we simulate our chip performance using Incisive and observed that it is the same as our original design.
    - We created a TCL script that reads the .v, .spef, .sdf, .saif files and generates the desired reports (Switching Activity, Area, Timing, Power). This process is done through Synopsys' Prime Time.
  
  
## For the completion of this project, we were assisted by the following links:

*Book - Teaching material through eclass*
[Traversy Media](https://eclass.uth.gr/modules/document/file.php/E-CE_U_141/Material/ug_asic_v18.pdf)
[Traversy Media](https://eclass.uth.gr/modules/document/file.php/E-CE_U_141/LabSoC_VLSI_Lec3A_rtl-to-netlist.pdf)
[Traversy Media](http://www.ids.item.uni-bremen.de/lectures/Intermediate_Tutorial/pr.html#sec-6)
[Traversy Media](https://www.einfochips.com/blog/asic-design-flow-in-vlsi-engineering-services-a-quick-guide/)
[Traversy Media](https://www.micro-ip.com/drchip.php?mode=2&cid=17)
