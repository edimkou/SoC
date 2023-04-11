set search_path "."
set target_library {./Desktop/soc/NangateOpenCellLibrary_worst_low_ccs.db}
set synthetic_library {/opt/synopsys/2018-19/RHELx86/SYN_2018.06-SP4/libraries/syn/dw_foundation.sldb}
set link_library [list $target_library $synthetic_library ]


# HDL In #
analyze -f Verilog {./Desktop/SOC/src/calculator.v
./Desktop/SOC/src/root.v
./Desktop/SOC/src/qadd.v
./Desktop/SOC/src/qmults.v
./Desktop/SOC/src/fsm.v
}

# Elaborate Design #
elaborate calculator
# Set Top Module #
current_design calculator

create_clock "clk" -name clk -period 8
set auto_wire_load_selection true
set_max_fanout 25 [all_inputs]
set_max_area 0
set_max_dynamic_power 0 mW
set_max_leakage_power 0 mW

# Link Design #
link

# Check Warnings and Errors #
check_design

# Synthesize #
compile -map_effort high
#compile_ultra 

# Check Warnings and Errors #
check_design > Desktop/post_synthesis/checkdesign_calculator_td.log
report_timing > Desktop/post_synthesis/timing_td.txt
report_area > Desktop/post_synthesis/area_td.txt

report_area -hierarchy

# Write DDC File - Synopsys Design AND Library binary format #
write -h -f ddc -output ./Desktop/post_synthesis/calculator_postsynthesis_td.ddc

# Write Verilog Netlist #
write -h -f verilog -output ./Desktop/post_synthesis/calculator_postsynthesis_td.v

# Write SDC #
write_sdc ./Desktop/post_synthesis/calculator_postsynthesis_td.sdc

# Write SDF #
write_sdf ./Desktop/post_synthesis/calculator_postsynthesis_td.sdf

quit
 
