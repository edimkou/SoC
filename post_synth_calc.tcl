
set power_enable_analysis true
set target_library "/local/Desktop/SOC/NangateOpenCellLibrary_worst_low_ccs.db"
set link_library "/local/Desktop/SOC/NangateOpenCellLibrary_worst_low_ccs.db *"

read_db $target_library

read_verilog /local/Desktop/SOC/calculator.v


# Set Top Module #
current_design calculator

# Link Design #
link

# READ SDC File
read_sdc /local/Desktop/SOC/calculator_postsynthesis_td.sdc -version 2.0
read_parasitics /local/Desktop/SOC/calculator.spef

create_clock "clk" -name clk -period 8
set auto_link_disable false
set auto_wire_load_selection true

report_timing > ./Desktop/SOC/reports/timing.txt
read_saif /local/Desktop/SOC/calculator.saif -strip_path post_synth_calc/calculator
report_switching_activity > ./Desktop/SOC/reports/switching_activity.txt
report_power > ./Desktop/SOC/reports/power.txt

exit
 





 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 



