# ########################## 
# Vivado simulation script
# ##########################
# Using project mode.
#
# Arguments
# argv[0]: path to test top
# argv[1]: test top name

# Defining default value for parameters.
set test_file [lindex $argv 0]
set test_top_name [lindex $argv 1]

# Creating a temp project.
# Command line args have to be passed in this goofy way sadly.
set argc 2
set argv [list ./build/vivado sim_temp]
source ./vivado/create_project.tcl

# Setting up test-specific sources.
read_verilog $test_file

set_property top $test_top_name [get_fileset sim_1]
launch_simulation -simset sim_1 -mode behavioral
# Restart is needed to dump VCDs properly.
restart
open_vcd sim.vcd
# Log everything.
log_vcd -level 0 [ get_scopes /* ]
run
flush_vcd
close_vcd
quit

# This command can be used to check whether is the constants.vh correctly set as global include.
# report_property [ get_files constants.vh ]
# Or we can simple open the GUI.