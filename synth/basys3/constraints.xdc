create_clock -period 10.000 -name CLK -waveform {0.000 5.000} [get_ports clk]

set_property PACKAGE_PIN W5 [get_ports clk]
set_property PACKAGE_PIN T18 [get_ports reset]
set_property PACKAGE_PIN U16 [get_ports {gpio_ports[0]}]
set_property PACKAGE_PIN E19 [get_ports {gpio_ports[1]}]
set_property PACKAGE_PIN U19 [get_ports {gpio_ports[2]}]
set_property PACKAGE_PIN V19 [get_ports {gpio_ports[3]}]
set_property PACKAGE_PIN W18 [get_ports {gpio_ports[4]}]
set_property PACKAGE_PIN U15 [get_ports {gpio_ports[5]}]
set_property PACKAGE_PIN U14 [get_ports {gpio_ports[6]}]
set_property PACKAGE_PIN V14 [get_ports {gpio_ports[7]}]
set_property PACKAGE_PIN V13 [get_ports {gpio_ports[8]}]
set_property PACKAGE_PIN V3 [get_ports {gpio_ports[9]}]
set_property PACKAGE_PIN W3 [get_ports {gpio_ports[10]}]
set_property PACKAGE_PIN U3 [get_ports {gpio_ports[11]}]
set_property PACKAGE_PIN P3 [get_ports {gpio_ports[12]}]
set_property PACKAGE_PIN N3 [get_ports {gpio_ports[13]}]
set_property PACKAGE_PIN P1 [get_ports {gpio_ports[14]}]
set_property PACKAGE_PIN L1 [get_ports {gpio_ports[15]}]

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_ports[0]}]

set_property DRIVE 12 [get_ports {gpio_ports[15]}]
set_property DRIVE 12 [get_ports {gpio_ports[14]}]
set_property DRIVE 12 [get_ports {gpio_ports[13]}]
set_property DRIVE 12 [get_ports {gpio_ports[12]}]
set_property DRIVE 12 [get_ports {gpio_ports[11]}]
set_property DRIVE 12 [get_ports {gpio_ports[10]}]
set_property DRIVE 12 [get_ports {gpio_ports[9]}]
set_property DRIVE 12 [get_ports {gpio_ports[8]}]
set_property DRIVE 12 [get_ports {gpio_ports[7]}]
set_property DRIVE 12 [get_ports {gpio_ports[6]}]
set_property DRIVE 12 [get_ports {gpio_ports[5]}]
set_property DRIVE 12 [get_ports {gpio_ports[4]}]
set_property DRIVE 12 [get_ports {gpio_ports[3]}]
set_property DRIVE 12 [get_ports {gpio_ports[2]}]
set_property DRIVE 12 [get_ports {gpio_ports[1]}]
set_property DRIVE 12 [get_ports {gpio_ports[0]}]

set_property SLEW SLOW [get_ports {gpio_ports[15]}]
set_property SLEW SLOW [get_ports {gpio_ports[14]}]
set_property SLEW SLOW [get_ports {gpio_ports[13]}]
set_property SLEW SLOW [get_ports {gpio_ports[12]}]
set_property SLEW SLOW [get_ports {gpio_ports[11]}]
set_property SLEW SLOW [get_ports {gpio_ports[10]}]
set_property SLEW SLOW [get_ports {gpio_ports[9]}]
set_property SLEW SLOW [get_ports {gpio_ports[8]}]
set_property SLEW SLOW [get_ports {gpio_ports[7]}]
set_property SLEW SLOW [get_ports {gpio_ports[6]}]
set_property SLEW SLOW [get_ports {gpio_ports[5]}]
set_property SLEW SLOW [get_ports {gpio_ports[4]}]
set_property SLEW SLOW [get_ports {gpio_ports[3]}]
set_property SLEW SLOW [get_ports {gpio_ports[2]}]
set_property SLEW SLOW [get_ports {gpio_ports[1]}]
set_property SLEW SLOW [get_ports {gpio_ports[0]}]