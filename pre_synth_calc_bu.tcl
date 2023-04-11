set search_path "."
set results_path "Home/Desktop/soc/postsynthesis"
set target_library {./Desktop/soc/NangateOpenCellLibrary_worst_low_ccs.db}
# exec mkdir $results_path

set synthetic_library {/opt/synopsys/2016-17/RHELx86/SYN_2016.12/libraries/syn/dw_foundation.sldb}

set link_library [ list $target_library $synthetic_library ]

analyze -f Verilog { ./Desktop/soc/calculator.v
./Desktop/soc/root.v
./Desktop/soc/qadd.v
./Desktop/soc/qmults.v
./Desktop/soc/fsm.v
}



#//////////////////////////      ADD      ////////////////////////////////////////

# Elaborate Design #
elaborate qadd
# Set Top Module #
current_design qadd

link

compile -map_effort high -incremental

write -h -f ddc -output ./Desktop/soc/qaddbu.ddc




#//////////////////////////      MULT      ////////////////////////////////////////

# Elaborate Design #
elaborate qmults
# Set Top Module #
current_design qmults

link

create_clock "i_clk" -name clk -period 15
set auto_wire_load_selection true

compile -map_effort high -incremental

write -h -f ddc -output ./Desktop/soc/qmultsbu.ddc




#//////////////////////////      FSM      ////////////////////////////////////////

# Elaborate Design #
elaborate fsm
# Set Top Module #
current_design fsm

link

create_clock "clock" -name clk -period 15
set auto_wire_load_selection true

compile -map_effort high -incrementalScreenshot_20220515_143829

write -h -f ddc -output ./Desktop/soc/fsmbu.ddc




#//////////////////////////      ROOT      ////////////////////////////////////////

# Elaborate Design #
elaborate root
# Set Top Module #
current_design root

link

create_clock "clk" -name clk -period 15
set auto_wire_load_selection true

compile -map_effort high -incremental

write -h -f ddc -output ./Desktop/soc/rootbu.ddc





#//////////////////////////      TOP      ////////////////////////////////////////

set search_path "."
set results_path "Home/Desktop/soc/postsynthesis"
set target_library {./Desktop/soc/NangateOpenCellLibrary_worst_low_ccs.db}
set synthetic_library {/opt/synopsys/2016-17/RHELx86/SYN_2016.12/libraries/syn/dw_foundation.sldb}

set link_library [ list $target_library $synthetic_library 
    ./Desktop/soc/fsmbu.ddc
    ./Desktop/soc/qaddbu.ddc
    ./Desktop/soc/qmultsbu.ddc
    ./Desktop/soc/rootbu.ddc *]


# Elaborate Design #
elaborate calculator
# Set Top Module #
current_design calculator

report_area -hierarchy

link

create_clock "clk" -name clk -period 15
set auto_wire_load_selection true

set_max_fanout 25 [all_inputs]
set_max_area 0

compile -map_effort high -incremental

check_design > Desktop/soc/postsynthesischeckdesign_calculator_bu.log


report_timing > Desktop/soc/timing_bu.txt
report_area > Desktop/soc/area_bu.txt

write -h -f ddc -output ./Desktop/soc/calculatorbu.ddc

# Write Verilog Netlist #
write -h -f verilog -output ./Desktop/soc/calculator_postsynthesis_bu.v

# Write SDC #
write_sdc ./Desktop/soc/calculator_postsynthesis_bu.sdc

# Write SDF #
write_sdf ./Desktop/soc/calculator_postsynthesis_bu.sdf

quit
 





 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 



