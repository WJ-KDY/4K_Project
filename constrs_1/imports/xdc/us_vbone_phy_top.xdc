set_property PACKAGE_PIN AG12 [get_ports mgtrefclk0_226_p]
set_property PACKAGE_PIN W12 [get_ports mgtrefclk0_230_p]
#set_property PACKAGE_PIN AF10 [get_ports mgtrefclk1_226_p]
#set_property PACKAGE_PIN V10 [get_ports mgtrefclk1_230_p]

create_clock -period 11.871 -name mgtrefclk0_226_p [get_ports mgtrefclk0_226_p]
create_clock -period 11.871 -name mgtrefclk0_230_p [get_ports mgtrefclk0_230_p]
#create_clock -period 6.734 -name mgtrefclk1_226_p [get_ports mgtrefclk1_226_p]
#create_clock -period 6.734 -name mgtrefclk1_230_p [get_ports mgtrefclk1_230_p]

#set_false_path -to [get_cells -hierarchical -filter {NAME =~ *bit_synchronizer*inst/i_in_meta_reg}]
#set_false_path -to [get_cells -hierarchical -filter {NAME =~ *reset_synchronizer*inst/rst_in_*_reg}]






