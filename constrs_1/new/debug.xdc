


create_clock -period 10.000 -name vs_s_BUFG -waveform {0.000 5.000} [get_pins {vx1_debug/vs_s_BUFG[1]_inst/O}]



set_false_path -from [get_clocks -of_objects [get_pins u_gty_top_tx/example_wrapper_inst/gtwiz_userclk_tx_inst/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O] -filter {IS_GENERATED && MASTER_CLOCK == txoutclk_out[0]}] -to [get_clocks -of_objects [get_pins u_gty_top_tx/example_wrapper_inst/gtwiz_userclk_tx_inst/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O] -filter {IS_GENERATED && MASTER_CLOCK == txoutclk_out[0]_1}]









set_false_path -from [get_clocks clk_168_48] -to [get_clocks -of_objects [get_pins u_gty_top_tx/example_wrapper_inst/gtwiz_userclk_tx_inst/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O] -filter {IS_GENERATED && MASTER_CLOCK == txoutclk_out[0]}]
set_false_path -from [get_clocks -of_objects [get_pins u_gty_top_tx/example_wrapper_inst/gtwiz_userclk_tx_inst/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O] -filter {IS_GENERATED && MASTER_CLOCK == txoutclk_out[0]}] -to [get_clocks clk_168_48]
set_false_path -from [get_clocks clk_168_48] -to [get_clocks -of_objects [get_pins u_gty_top_tx/example_wrapper_inst/gtwiz_userclk_tx_inst/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O] -filter {IS_GENERATED && MASTER_CLOCK == txoutclk_out[0]_1}]
set_false_path -from [get_clocks -of_objects [get_pins u_gty_top_tx/example_wrapper_inst/gtwiz_userclk_tx_inst/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O] -filter {IS_GENERATED && MASTER_CLOCK == txoutclk_out[0]_1}] -to [get_clocks clk_168_48]
set_false_path -from [get_clocks clk_168_48] -to [get_clocks clk_84_24]
set_false_path -from [get_clocks clk_84_24] -to [get_clocks clk_168_48]
#connect_debug_port u_ila_0/clk [get_nets [list {u_ila_0_txusrclk2_in[0]}]]

connect_debug_port u_ila_0/clk [get_nets [list {u_gty_top_tx/example_wrapper_inst/gtwiz_userclk_tx_inst/txusrclk2_in[0]}]]
connect_debug_port u_ila_0/probe0 [get_nets [list {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[0]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[1]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[2]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[3]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[4]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[5]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[6]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[7]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[8]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[9]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[10]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[11]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[12]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[13]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[14]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[15]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[16]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[17]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[18]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[19]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[20]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[21]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[22]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[23]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[24]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[25]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[26]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[27]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[28]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[29]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[30]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_dbg[31]}]]
connect_debug_port u_ila_0/probe1 [get_nets [list {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[0]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[1]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[2]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[3]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[4]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[5]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[6]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[7]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[8]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[9]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[10]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[11]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[12]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[13]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[14]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[15]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[16]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[17]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[18]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[19]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[20]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[21]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[22]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[23]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[24]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[25]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[26]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[27]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[28]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[29]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[30]} {u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_dbg[31]}]]
connect_debug_port u_ila_0/probe2 [get_nets [list u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/dout_valid_dbg]]
connect_debug_port u_ila_0/probe3 [get_nets [list u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/dout_valid_dbg]]
connect_debug_port u_ila_0/probe4 [get_nets [list u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/empty_b0_dbg]]
connect_debug_port u_ila_0/probe5 [get_nets [list u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/empty_b1_dbg]]
connect_debug_port u_ila_0/probe6 [get_nets [list u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/flush_b0_cdc_dbg]]
connect_debug_port u_ila_0/probe7 [get_nets [list u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/flush_b0_cdc_dbg]]
connect_debug_port u_ila_0/probe8 [get_nets [list u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/flush_b1_cdc_dbg]]
connect_debug_port u_ila_0/probe9 [get_nets [list u_gty_top_tx/U_TX_BURST/U_TX_BURST_L1/flush_b1_cdc_dbg]]
connect_debug_port u_ila_0/probe10 [get_nets [list u_gty_top_tx/U_TX_BURST/U_TX_BURST_L0/op_en_cdc_dbg]]
connect_debug_port u_ila_0/probe11 [get_nets [list u_gty_top_tx/txpmaresetdone_int_dbg]]

connect_debug_port u_ila_1/probe0 [get_nets [list u_gty_top_tx/nrst_dbg]]


connect_debug_port u_ila_1/probe11 [get_nets [list {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[0]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[1]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[2]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[3]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[4]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[5]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[6]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[7]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[8]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[9]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[10]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[11]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[12]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[13]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[14]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[15]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[16]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[17]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[18]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[19]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[20]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[21]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[22]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[23]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[24]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[25]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[26]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[27]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[28]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[29]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[30]} {i_wigig_mac_top/i_mac_ctrl_rx/p_2_in[31]}]]

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list u_clk_wiz_0/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 10 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {u_line_selctor/address_W[0]} {u_line_selctor/address_W[1]} {u_line_selctor/address_W[2]} {u_line_selctor/address_W[3]} {u_line_selctor/address_W[4]} {u_line_selctor/address_W[5]} {u_line_selctor/address_W[6]} {u_line_selctor/address_W[7]} {u_line_selctor/address_W[8]} {u_line_selctor/address_W[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 12 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {u_line_selctor/DE_cnt[0]} {u_line_selctor/DE_cnt[1]} {u_line_selctor/DE_cnt[2]} {u_line_selctor/DE_cnt[3]} {u_line_selctor/DE_cnt[4]} {u_line_selctor/DE_cnt[5]} {u_line_selctor/DE_cnt[6]} {u_line_selctor/DE_cnt[7]} {u_line_selctor/DE_cnt[8]} {u_line_selctor/DE_cnt[9]} {u_line_selctor/DE_cnt[10]} {u_line_selctor/DE_cnt[11]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 10 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {u_line_selctor/address_R[0]} {u_line_selctor/address_R[1]} {u_line_selctor/address_R[2]} {u_line_selctor/address_R[3]} {u_line_selctor/address_R[4]} {u_line_selctor/address_R[5]} {u_line_selctor/address_R[6]} {u_line_selctor/address_R[7]} {u_line_selctor/address_R[8]} {u_line_selctor/address_R[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 10 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {u_line_selctor/address_34[0]} {u_line_selctor/address_34[1]} {u_line_selctor/address_34[2]} {u_line_selctor/address_34[3]} {u_line_selctor/address_34[4]} {u_line_selctor/address_34[5]} {u_line_selctor/address_34[6]} {u_line_selctor/address_34[7]} {u_line_selctor/address_34[8]} {u_line_selctor/address_34[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 10 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {u_line_selctor/DE_int_cnt[0]} {u_line_selctor/DE_int_cnt[1]} {u_line_selctor/DE_int_cnt[2]} {u_line_selctor/DE_int_cnt[3]} {u_line_selctor/DE_int_cnt[4]} {u_line_selctor/DE_int_cnt[5]} {u_line_selctor/DE_int_cnt[6]} {u_line_selctor/DE_int_cnt[7]} {u_line_selctor/DE_int_cnt[8]} {u_line_selctor/DE_int_cnt[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 10 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {u_line_selctor/address_12[0]} {u_line_selctor/address_12[1]} {u_line_selctor/address_12[2]} {u_line_selctor/address_12[3]} {u_line_selctor/address_12[4]} {u_line_selctor/address_12[5]} {u_line_selctor/address_12[6]} {u_line_selctor/address_12[7]} {u_line_selctor/address_12[8]} {u_line_selctor/address_12[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 144 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {u_line_selctor/data_out_f[0]} {u_line_selctor/data_out_f[1]} {u_line_selctor/data_out_f[2]} {u_line_selctor/data_out_f[3]} {u_line_selctor/data_out_f[4]} {u_line_selctor/data_out_f[5]} {u_line_selctor/data_out_f[6]} {u_line_selctor/data_out_f[7]} {u_line_selctor/data_out_f[8]} {u_line_selctor/data_out_f[9]} {u_line_selctor/data_out_f[10]} {u_line_selctor/data_out_f[11]} {u_line_selctor/data_out_f[12]} {u_line_selctor/data_out_f[13]} {u_line_selctor/data_out_f[14]} {u_line_selctor/data_out_f[15]} {u_line_selctor/data_out_f[16]} {u_line_selctor/data_out_f[17]} {u_line_selctor/data_out_f[18]} {u_line_selctor/data_out_f[19]} {u_line_selctor/data_out_f[20]} {u_line_selctor/data_out_f[21]} {u_line_selctor/data_out_f[22]} {u_line_selctor/data_out_f[23]} {u_line_selctor/data_out_f[24]} {u_line_selctor/data_out_f[25]} {u_line_selctor/data_out_f[26]} {u_line_selctor/data_out_f[27]} {u_line_selctor/data_out_f[28]} {u_line_selctor/data_out_f[29]} {u_line_selctor/data_out_f[30]} {u_line_selctor/data_out_f[31]} {u_line_selctor/data_out_f[32]} {u_line_selctor/data_out_f[33]} {u_line_selctor/data_out_f[34]} {u_line_selctor/data_out_f[35]} {u_line_selctor/data_out_f[36]} {u_line_selctor/data_out_f[37]} {u_line_selctor/data_out_f[38]} {u_line_selctor/data_out_f[39]} {u_line_selctor/data_out_f[40]} {u_line_selctor/data_out_f[41]} {u_line_selctor/data_out_f[42]} {u_line_selctor/data_out_f[43]} {u_line_selctor/data_out_f[44]} {u_line_selctor/data_out_f[45]} {u_line_selctor/data_out_f[46]} {u_line_selctor/data_out_f[47]} {u_line_selctor/data_out_f[48]} {u_line_selctor/data_out_f[49]} {u_line_selctor/data_out_f[50]} {u_line_selctor/data_out_f[51]} {u_line_selctor/data_out_f[52]} {u_line_selctor/data_out_f[53]} {u_line_selctor/data_out_f[54]} {u_line_selctor/data_out_f[55]} {u_line_selctor/data_out_f[56]} {u_line_selctor/data_out_f[57]} {u_line_selctor/data_out_f[58]} {u_line_selctor/data_out_f[59]} {u_line_selctor/data_out_f[60]} {u_line_selctor/data_out_f[61]} {u_line_selctor/data_out_f[62]} {u_line_selctor/data_out_f[63]} {u_line_selctor/data_out_f[64]} {u_line_selctor/data_out_f[65]} {u_line_selctor/data_out_f[66]} {u_line_selctor/data_out_f[67]} {u_line_selctor/data_out_f[68]} {u_line_selctor/data_out_f[69]} {u_line_selctor/data_out_f[70]} {u_line_selctor/data_out_f[71]} {u_line_selctor/data_out_f[72]} {u_line_selctor/data_out_f[73]} {u_line_selctor/data_out_f[74]} {u_line_selctor/data_out_f[75]} {u_line_selctor/data_out_f[76]} {u_line_selctor/data_out_f[77]} {u_line_selctor/data_out_f[78]} {u_line_selctor/data_out_f[79]} {u_line_selctor/data_out_f[80]} {u_line_selctor/data_out_f[81]} {u_line_selctor/data_out_f[82]} {u_line_selctor/data_out_f[83]} {u_line_selctor/data_out_f[84]} {u_line_selctor/data_out_f[85]} {u_line_selctor/data_out_f[86]} {u_line_selctor/data_out_f[87]} {u_line_selctor/data_out_f[88]} {u_line_selctor/data_out_f[89]} {u_line_selctor/data_out_f[90]} {u_line_selctor/data_out_f[91]} {u_line_selctor/data_out_f[92]} {u_line_selctor/data_out_f[93]} {u_line_selctor/data_out_f[94]} {u_line_selctor/data_out_f[95]} {u_line_selctor/data_out_f[96]} {u_line_selctor/data_out_f[97]} {u_line_selctor/data_out_f[98]} {u_line_selctor/data_out_f[99]} {u_line_selctor/data_out_f[100]} {u_line_selctor/data_out_f[101]} {u_line_selctor/data_out_f[102]} {u_line_selctor/data_out_f[103]} {u_line_selctor/data_out_f[104]} {u_line_selctor/data_out_f[105]} {u_line_selctor/data_out_f[106]} {u_line_selctor/data_out_f[107]} {u_line_selctor/data_out_f[108]} {u_line_selctor/data_out_f[109]} {u_line_selctor/data_out_f[110]} {u_line_selctor/data_out_f[111]} {u_line_selctor/data_out_f[112]} {u_line_selctor/data_out_f[113]} {u_line_selctor/data_out_f[114]} {u_line_selctor/data_out_f[115]} {u_line_selctor/data_out_f[116]} {u_line_selctor/data_out_f[117]} {u_line_selctor/data_out_f[118]} {u_line_selctor/data_out_f[119]} {u_line_selctor/data_out_f[120]} {u_line_selctor/data_out_f[121]} {u_line_selctor/data_out_f[122]} {u_line_selctor/data_out_f[123]} {u_line_selctor/data_out_f[124]} {u_line_selctor/data_out_f[125]} {u_line_selctor/data_out_f[126]} {u_line_selctor/data_out_f[127]} {u_line_selctor/data_out_f[128]} {u_line_selctor/data_out_f[129]} {u_line_selctor/data_out_f[130]} {u_line_selctor/data_out_f[131]} {u_line_selctor/data_out_f[132]} {u_line_selctor/data_out_f[133]} {u_line_selctor/data_out_f[134]} {u_line_selctor/data_out_f[135]} {u_line_selctor/data_out_f[136]} {u_line_selctor/data_out_f[137]} {u_line_selctor/data_out_f[138]} {u_line_selctor/data_out_f[139]} {u_line_selctor/data_out_f[140]} {u_line_selctor/data_out_f[141]} {u_line_selctor/data_out_f[142]} {u_line_selctor/data_out_f[143]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 144 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {u_line_selctor/data_out_s[0]} {u_line_selctor/data_out_s[1]} {u_line_selctor/data_out_s[2]} {u_line_selctor/data_out_s[3]} {u_line_selctor/data_out_s[4]} {u_line_selctor/data_out_s[5]} {u_line_selctor/data_out_s[6]} {u_line_selctor/data_out_s[7]} {u_line_selctor/data_out_s[8]} {u_line_selctor/data_out_s[9]} {u_line_selctor/data_out_s[10]} {u_line_selctor/data_out_s[11]} {u_line_selctor/data_out_s[12]} {u_line_selctor/data_out_s[13]} {u_line_selctor/data_out_s[14]} {u_line_selctor/data_out_s[15]} {u_line_selctor/data_out_s[16]} {u_line_selctor/data_out_s[17]} {u_line_selctor/data_out_s[18]} {u_line_selctor/data_out_s[19]} {u_line_selctor/data_out_s[20]} {u_line_selctor/data_out_s[21]} {u_line_selctor/data_out_s[22]} {u_line_selctor/data_out_s[23]} {u_line_selctor/data_out_s[24]} {u_line_selctor/data_out_s[25]} {u_line_selctor/data_out_s[26]} {u_line_selctor/data_out_s[27]} {u_line_selctor/data_out_s[28]} {u_line_selctor/data_out_s[29]} {u_line_selctor/data_out_s[30]} {u_line_selctor/data_out_s[31]} {u_line_selctor/data_out_s[32]} {u_line_selctor/data_out_s[33]} {u_line_selctor/data_out_s[34]} {u_line_selctor/data_out_s[35]} {u_line_selctor/data_out_s[36]} {u_line_selctor/data_out_s[37]} {u_line_selctor/data_out_s[38]} {u_line_selctor/data_out_s[39]} {u_line_selctor/data_out_s[40]} {u_line_selctor/data_out_s[41]} {u_line_selctor/data_out_s[42]} {u_line_selctor/data_out_s[43]} {u_line_selctor/data_out_s[44]} {u_line_selctor/data_out_s[45]} {u_line_selctor/data_out_s[46]} {u_line_selctor/data_out_s[47]} {u_line_selctor/data_out_s[48]} {u_line_selctor/data_out_s[49]} {u_line_selctor/data_out_s[50]} {u_line_selctor/data_out_s[51]} {u_line_selctor/data_out_s[52]} {u_line_selctor/data_out_s[53]} {u_line_selctor/data_out_s[54]} {u_line_selctor/data_out_s[55]} {u_line_selctor/data_out_s[56]} {u_line_selctor/data_out_s[57]} {u_line_selctor/data_out_s[58]} {u_line_selctor/data_out_s[59]} {u_line_selctor/data_out_s[60]} {u_line_selctor/data_out_s[61]} {u_line_selctor/data_out_s[62]} {u_line_selctor/data_out_s[63]} {u_line_selctor/data_out_s[64]} {u_line_selctor/data_out_s[65]} {u_line_selctor/data_out_s[66]} {u_line_selctor/data_out_s[67]} {u_line_selctor/data_out_s[68]} {u_line_selctor/data_out_s[69]} {u_line_selctor/data_out_s[70]} {u_line_selctor/data_out_s[71]} {u_line_selctor/data_out_s[72]} {u_line_selctor/data_out_s[73]} {u_line_selctor/data_out_s[74]} {u_line_selctor/data_out_s[75]} {u_line_selctor/data_out_s[76]} {u_line_selctor/data_out_s[77]} {u_line_selctor/data_out_s[78]} {u_line_selctor/data_out_s[79]} {u_line_selctor/data_out_s[80]} {u_line_selctor/data_out_s[81]} {u_line_selctor/data_out_s[82]} {u_line_selctor/data_out_s[83]} {u_line_selctor/data_out_s[84]} {u_line_selctor/data_out_s[85]} {u_line_selctor/data_out_s[86]} {u_line_selctor/data_out_s[87]} {u_line_selctor/data_out_s[88]} {u_line_selctor/data_out_s[89]} {u_line_selctor/data_out_s[90]} {u_line_selctor/data_out_s[91]} {u_line_selctor/data_out_s[92]} {u_line_selctor/data_out_s[93]} {u_line_selctor/data_out_s[94]} {u_line_selctor/data_out_s[95]} {u_line_selctor/data_out_s[96]} {u_line_selctor/data_out_s[97]} {u_line_selctor/data_out_s[98]} {u_line_selctor/data_out_s[99]} {u_line_selctor/data_out_s[100]} {u_line_selctor/data_out_s[101]} {u_line_selctor/data_out_s[102]} {u_line_selctor/data_out_s[103]} {u_line_selctor/data_out_s[104]} {u_line_selctor/data_out_s[105]} {u_line_selctor/data_out_s[106]} {u_line_selctor/data_out_s[107]} {u_line_selctor/data_out_s[108]} {u_line_selctor/data_out_s[109]} {u_line_selctor/data_out_s[110]} {u_line_selctor/data_out_s[111]} {u_line_selctor/data_out_s[112]} {u_line_selctor/data_out_s[113]} {u_line_selctor/data_out_s[114]} {u_line_selctor/data_out_s[115]} {u_line_selctor/data_out_s[116]} {u_line_selctor/data_out_s[117]} {u_line_selctor/data_out_s[118]} {u_line_selctor/data_out_s[119]} {u_line_selctor/data_out_s[120]} {u_line_selctor/data_out_s[121]} {u_line_selctor/data_out_s[122]} {u_line_selctor/data_out_s[123]} {u_line_selctor/data_out_s[124]} {u_line_selctor/data_out_s[125]} {u_line_selctor/data_out_s[126]} {u_line_selctor/data_out_s[127]} {u_line_selctor/data_out_s[128]} {u_line_selctor/data_out_s[129]} {u_line_selctor/data_out_s[130]} {u_line_selctor/data_out_s[131]} {u_line_selctor/data_out_s[132]} {u_line_selctor/data_out_s[133]} {u_line_selctor/data_out_s[134]} {u_line_selctor/data_out_s[135]} {u_line_selctor/data_out_s[136]} {u_line_selctor/data_out_s[137]} {u_line_selctor/data_out_s[138]} {u_line_selctor/data_out_s[139]} {u_line_selctor/data_out_s[140]} {u_line_selctor/data_out_s[141]} {u_line_selctor/data_out_s[142]} {u_line_selctor/data_out_s[143]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {i_mac_tx_if/video_di[0]} {i_mac_tx_if/video_di[1]} {i_mac_tx_if/video_di[2]} {i_mac_tx_if/video_di[3]} {i_mac_tx_if/video_di[4]} {i_mac_tx_if/video_di[5]} {i_mac_tx_if/video_di[6]} {i_mac_tx_if/video_di[7]} {i_mac_tx_if/video_di[8]} {i_mac_tx_if/video_di[9]} {i_mac_tx_if/video_di[10]} {i_mac_tx_if/video_di[11]} {i_mac_tx_if/video_di[12]} {i_mac_tx_if/video_di[13]} {i_mac_tx_if/video_di[14]} {i_mac_tx_if/video_di[15]} {i_mac_tx_if/video_di[16]} {i_mac_tx_if/video_di[17]} {i_mac_tx_if/video_di[18]} {i_mac_tx_if/video_di[19]} {i_mac_tx_if/video_di[20]} {i_mac_tx_if/video_di[21]} {i_mac_tx_if/video_di[22]} {i_mac_tx_if/video_di[23]} {i_mac_tx_if/video_di[24]} {i_mac_tx_if/video_di[25]} {i_mac_tx_if/video_di[26]} {i_mac_tx_if/video_di[27]} {i_mac_tx_if/video_di[28]} {i_mac_tx_if/video_di[29]} {i_mac_tx_if/video_di[30]} {i_mac_tx_if/video_di[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {i_mac_tx_if/vid_di_cnt[0]} {i_mac_tx_if/vid_di_cnt[1]} {i_mac_tx_if/vid_di_cnt[2]} {i_mac_tx_if/vid_di_cnt[3]} {i_mac_tx_if/vid_di_cnt[4]} {i_mac_tx_if/vid_di_cnt[5]} {i_mac_tx_if/vid_di_cnt[6]} {i_mac_tx_if/vid_di_cnt[7]} {i_mac_tx_if/vid_di_cnt[8]} {i_mac_tx_if/vid_di_cnt[9]} {i_mac_tx_if/vid_di_cnt[10]} {i_mac_tx_if/vid_di_cnt[11]} {i_mac_tx_if/vid_di_cnt[12]} {i_mac_tx_if/vid_di_cnt[13]} {i_mac_tx_if/vid_di_cnt[14]} {i_mac_tx_if/vid_di_cnt[15]} {i_mac_tx_if/vid_di_cnt[16]} {i_mac_tx_if/vid_di_cnt[17]} {i_mac_tx_if/vid_di_cnt[18]} {i_mac_tx_if/vid_di_cnt[19]} {i_mac_tx_if/vid_di_cnt[20]} {i_mac_tx_if/vid_di_cnt[21]} {i_mac_tx_if/vid_di_cnt[22]} {i_mac_tx_if/vid_di_cnt[23]} {i_mac_tx_if/vid_di_cnt[24]} {i_mac_tx_if/vid_di_cnt[25]} {i_mac_tx_if/vid_di_cnt[26]} {i_mac_tx_if/vid_di_cnt[27]} {i_mac_tx_if/vid_di_cnt[28]} {i_mac_tx_if/vid_di_cnt[29]} {i_mac_tx_if/vid_di_cnt[30]} {i_mac_tx_if/vid_di_cnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list u_line_selctor/DE_1d]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list u_line_selctor/DE_1d_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list u_line_selctor/DE_2d]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list u_line_selctor/DE_3d]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list u_line_selctor/DE_int]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list u_line_selctor/HSYNC]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list u_line_selctor/op_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list u_line_selctor/op_en_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list u_line_selctor/toggle]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list i_mac_tx_if/video_di_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list i_mac_tx_if/video_fifo_full]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list i_mac_tx_if/video_fifo_wr_rst_busy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list u_line_selctor/VSYNC]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list u_line_selctor/VSYNC_1d]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list u_line_selctor/we1_out]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list u_line_selctor/WE_1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list u_line_selctor/WE_2]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list u_line_selctor/WE_3]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list u_line_selctor/WE_4]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list {u_gty_top/example_wrapper_inst/gtwiz_userclk_tx_inst/gtwiz_userclk_tx_usrclk2_out[0]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 32 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[0]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[1]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[2]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[3]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[4]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[5]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[6]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[7]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[8]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[9]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[10]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[11]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[12]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[13]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[14]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[15]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[16]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[17]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[18]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[19]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[20]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[21]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[22]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[23]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[24]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[25]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[26]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[27]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[28]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[29]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[30]} {i_wigig_mac_top/i_mac_ctrl_rx/fcs_error_cnt[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 4 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tkeep[0]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tkeep[1]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tkeep[2]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tkeep[3]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 32 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[0]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[1]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[2]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[3]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[4]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[5]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[6]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[7]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[8]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[9]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[10]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[11]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[12]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[13]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[14]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[15]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[16]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[17]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[18]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[19]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[20]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[21]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[22]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[23]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[24]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[25]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[26]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[27]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[28]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[29]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[30]} {i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tdata[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 20 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[0]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[1]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[2]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[3]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[4]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[5]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[6]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[7]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[8]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[9]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[10]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[11]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[12]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[13]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[14]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[15]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[16]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[17]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[18]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_cnt[19]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 20 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[0]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[1]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[2]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[3]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[4]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[5]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[6]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[7]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[8]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[9]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[10]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[11]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[12]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[13]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[14]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[15]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[16]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[17]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[18]} {i_wigig_mac_top/i_mac_ctrl_rx/rx_length[19]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 32 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list {i_wigig_mac_top/tx_m_axis_tdata[0]} {i_wigig_mac_top/tx_m_axis_tdata[1]} {i_wigig_mac_top/tx_m_axis_tdata[2]} {i_wigig_mac_top/tx_m_axis_tdata[3]} {i_wigig_mac_top/tx_m_axis_tdata[4]} {i_wigig_mac_top/tx_m_axis_tdata[5]} {i_wigig_mac_top/tx_m_axis_tdata[6]} {i_wigig_mac_top/tx_m_axis_tdata[7]} {i_wigig_mac_top/tx_m_axis_tdata[8]} {i_wigig_mac_top/tx_m_axis_tdata[9]} {i_wigig_mac_top/tx_m_axis_tdata[10]} {i_wigig_mac_top/tx_m_axis_tdata[11]} {i_wigig_mac_top/tx_m_axis_tdata[12]} {i_wigig_mac_top/tx_m_axis_tdata[13]} {i_wigig_mac_top/tx_m_axis_tdata[14]} {i_wigig_mac_top/tx_m_axis_tdata[15]} {i_wigig_mac_top/tx_m_axis_tdata[16]} {i_wigig_mac_top/tx_m_axis_tdata[17]} {i_wigig_mac_top/tx_m_axis_tdata[18]} {i_wigig_mac_top/tx_m_axis_tdata[19]} {i_wigig_mac_top/tx_m_axis_tdata[20]} {i_wigig_mac_top/tx_m_axis_tdata[21]} {i_wigig_mac_top/tx_m_axis_tdata[22]} {i_wigig_mac_top/tx_m_axis_tdata[23]} {i_wigig_mac_top/tx_m_axis_tdata[24]} {i_wigig_mac_top/tx_m_axis_tdata[25]} {i_wigig_mac_top/tx_m_axis_tdata[26]} {i_wigig_mac_top/tx_m_axis_tdata[27]} {i_wigig_mac_top/tx_m_axis_tdata[28]} {i_wigig_mac_top/tx_m_axis_tdata[29]} {i_wigig_mac_top/tx_m_axis_tdata[30]} {i_wigig_mac_top/tx_m_axis_tdata[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe6]
set_property port_width 20 [get_debug_ports u_ila_1/probe6]
connect_debug_port u_ila_1/probe6 [get_nets [list {i_wigig_mac_top/i_mlme_ctrl/payload_size[0]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[1]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[2]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[3]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[4]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[5]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[6]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[7]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[8]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[9]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[10]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[11]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[12]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[13]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[14]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[15]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[16]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[17]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[18]} {i_wigig_mac_top/i_mlme_ctrl/payload_size[19]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe7]
set_property port_width 5 [get_debug_ports u_ila_1/probe7]
connect_debug_port u_ila_1/probe7 [get_nets [list {i_wigig_mac_top/i_mlme_ctrl/state[0]} {i_wigig_mac_top/i_mlme_ctrl/state[1]} {i_wigig_mac_top/i_mlme_ctrl/state[2]} {i_wigig_mac_top/i_mlme_ctrl/state[3]} {i_wigig_mac_top/i_mlme_ctrl/state[4]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe8]
set_property port_width 13 [get_debug_ports u_ila_1/probe8]
connect_debug_port u_ila_1/probe8 [get_nets [list {i_mac_tx_if/video_fifo_rd_count[0]} {i_mac_tx_if/video_fifo_rd_count[1]} {i_mac_tx_if/video_fifo_rd_count[2]} {i_mac_tx_if/video_fifo_rd_count[3]} {i_mac_tx_if/video_fifo_rd_count[4]} {i_mac_tx_if/video_fifo_rd_count[5]} {i_mac_tx_if/video_fifo_rd_count[6]} {i_mac_tx_if/video_fifo_rd_count[7]} {i_mac_tx_if/video_fifo_rd_count[8]} {i_mac_tx_if/video_fifo_rd_count[9]} {i_mac_tx_if/video_fifo_rd_count[10]} {i_mac_tx_if/video_fifo_rd_count[11]} {i_mac_tx_if/video_fifo_rd_count[12]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe9]
set_property port_width 32 [get_debug_ports u_ila_1/probe9]
connect_debug_port u_ila_1/probe9 [get_nets [list {i_mac_tx_if/packet_id[0]} {i_mac_tx_if/packet_id[1]} {i_mac_tx_if/packet_id[2]} {i_mac_tx_if/packet_id[3]} {i_mac_tx_if/packet_id[4]} {i_mac_tx_if/packet_id[5]} {i_mac_tx_if/packet_id[6]} {i_mac_tx_if/packet_id[7]} {i_mac_tx_if/packet_id[8]} {i_mac_tx_if/packet_id[9]} {i_mac_tx_if/packet_id[10]} {i_mac_tx_if/packet_id[11]} {i_mac_tx_if/packet_id[12]} {i_mac_tx_if/packet_id[13]} {i_mac_tx_if/packet_id[14]} {i_mac_tx_if/packet_id[15]} {i_mac_tx_if/packet_id[16]} {i_mac_tx_if/packet_id[17]} {i_mac_tx_if/packet_id[18]} {i_mac_tx_if/packet_id[19]} {i_mac_tx_if/packet_id[20]} {i_mac_tx_if/packet_id[21]} {i_mac_tx_if/packet_id[22]} {i_mac_tx_if/packet_id[23]} {i_mac_tx_if/packet_id[24]} {i_mac_tx_if/packet_id[25]} {i_mac_tx_if/packet_id[26]} {i_mac_tx_if/packet_id[27]} {i_mac_tx_if/packet_id[28]} {i_mac_tx_if/packet_id[29]} {i_mac_tx_if/packet_id[30]} {i_mac_tx_if/packet_id[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe10]
set_property port_width 4 [get_debug_ports u_ila_1/probe10]
connect_debug_port u_ila_1/probe10 [get_nets [list {i_mac_tx_if/state[0]} {i_mac_tx_if/state[1]} {i_mac_tx_if/state[2]} {i_mac_tx_if/state[3]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe11]
set_property port_width 20 [get_debug_ports u_ila_1/probe11]
connect_debug_port u_ila_1/probe11 [get_nets [list {i_mac_tx_if/mac_frame_size[0]} {i_mac_tx_if/mac_frame_size[1]} {i_mac_tx_if/mac_frame_size[2]} {i_mac_tx_if/mac_frame_size[3]} {i_mac_tx_if/mac_frame_size[4]} {i_mac_tx_if/mac_frame_size[5]} {i_mac_tx_if/mac_frame_size[6]} {i_mac_tx_if/mac_frame_size[7]} {i_mac_tx_if/mac_frame_size[8]} {i_mac_tx_if/mac_frame_size[9]} {i_mac_tx_if/mac_frame_size[10]} {i_mac_tx_if/mac_frame_size[11]} {i_mac_tx_if/mac_frame_size[12]} {i_mac_tx_if/mac_frame_size[13]} {i_mac_tx_if/mac_frame_size[14]} {i_mac_tx_if/mac_frame_size[15]} {i_mac_tx_if/mac_frame_size[16]} {i_mac_tx_if/mac_frame_size[17]} {i_mac_tx_if/mac_frame_size[18]} {i_mac_tx_if/mac_frame_size[19]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe12]
set_property port_width 32 [get_debug_ports u_ila_1/probe12]
connect_debug_port u_ila_1/probe12 [get_nets [list {i_mac_tx_if/p_0_in[0]} {i_mac_tx_if/p_0_in[1]} {i_mac_tx_if/p_0_in[2]} {i_mac_tx_if/p_0_in[3]} {i_mac_tx_if/p_0_in[4]} {i_mac_tx_if/p_0_in[5]} {i_mac_tx_if/p_0_in[6]} {i_mac_tx_if/p_0_in[7]} {i_mac_tx_if/p_0_in[8]} {i_mac_tx_if/p_0_in[9]} {i_mac_tx_if/p_0_in[10]} {i_mac_tx_if/p_0_in[11]} {i_mac_tx_if/p_0_in[12]} {i_mac_tx_if/p_0_in[13]} {i_mac_tx_if/p_0_in[14]} {i_mac_tx_if/p_0_in[15]} {i_mac_tx_if/p_0_in[16]} {i_mac_tx_if/p_0_in[17]} {i_mac_tx_if/p_0_in[18]} {i_mac_tx_if/p_0_in[19]} {i_mac_tx_if/p_0_in[20]} {i_mac_tx_if/p_0_in[21]} {i_mac_tx_if/p_0_in[22]} {i_mac_tx_if/p_0_in[23]} {i_mac_tx_if/p_0_in[24]} {i_mac_tx_if/p_0_in[25]} {i_mac_tx_if/p_0_in[26]} {i_mac_tx_if/p_0_in[27]} {i_mac_tx_if/p_0_in[28]} {i_mac_tx_if/p_0_in[29]} {i_mac_tx_if/p_0_in[30]} {i_mac_tx_if/p_0_in[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe13]
set_property port_width 18 [get_debug_ports u_ila_1/probe13]
connect_debug_port u_ila_1/probe13 [get_nets [list {i_mac_tx_if/wcnt[0]} {i_mac_tx_if/wcnt[1]} {i_mac_tx_if/wcnt[2]} {i_mac_tx_if/wcnt[3]} {i_mac_tx_if/wcnt[4]} {i_mac_tx_if/wcnt[5]} {i_mac_tx_if/wcnt[6]} {i_mac_tx_if/wcnt[7]} {i_mac_tx_if/wcnt[8]} {i_mac_tx_if/wcnt[9]} {i_mac_tx_if/wcnt[10]} {i_mac_tx_if/wcnt[11]} {i_mac_tx_if/wcnt[12]} {i_mac_tx_if/wcnt[13]} {i_mac_tx_if/wcnt[14]} {i_mac_tx_if/wcnt[15]} {i_mac_tx_if/wcnt[16]} {i_mac_tx_if/wcnt[17]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe14]
set_property port_width 8 [get_debug_ports u_ila_1/probe14]
connect_debug_port u_ila_1/probe14 [get_nets [list {i_mac_tx_if/packet_format[0]} {i_mac_tx_if/packet_format[1]} {i_mac_tx_if/packet_format[2]} {i_mac_tx_if/packet_format[3]} {i_mac_tx_if/packet_format[4]} {i_mac_tx_if/packet_format[5]} {i_mac_tx_if/packet_format[6]} {i_mac_tx_if/packet_format[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe15]
set_property port_width 16 [get_debug_ports u_ila_1/probe15]
connect_debug_port u_ila_1/probe15 [get_nets [list {i_mac_tx_if/block_id[0]} {i_mac_tx_if/block_id[1]} {i_mac_tx_if/block_id[2]} {i_mac_tx_if/block_id[3]} {i_mac_tx_if/block_id[4]} {i_mac_tx_if/block_id[5]} {i_mac_tx_if/block_id[6]} {i_mac_tx_if/block_id[7]} {i_mac_tx_if/block_id[8]} {i_mac_tx_if/block_id[9]} {i_mac_tx_if/block_id[10]} {i_mac_tx_if/block_id[11]} {i_mac_tx_if/block_id[12]} {i_mac_tx_if/block_id[13]} {i_mac_tx_if/block_id[14]} {i_mac_tx_if/block_id[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe16]
set_property port_width 32 [get_debug_ports u_ila_1/probe16]
connect_debug_port u_ila_1/probe16 [get_nets [list {i_mac_tx_if/m_axis_tdata[0]} {i_mac_tx_if/m_axis_tdata[1]} {i_mac_tx_if/m_axis_tdata[2]} {i_mac_tx_if/m_axis_tdata[3]} {i_mac_tx_if/m_axis_tdata[4]} {i_mac_tx_if/m_axis_tdata[5]} {i_mac_tx_if/m_axis_tdata[6]} {i_mac_tx_if/m_axis_tdata[7]} {i_mac_tx_if/m_axis_tdata[8]} {i_mac_tx_if/m_axis_tdata[9]} {i_mac_tx_if/m_axis_tdata[10]} {i_mac_tx_if/m_axis_tdata[11]} {i_mac_tx_if/m_axis_tdata[12]} {i_mac_tx_if/m_axis_tdata[13]} {i_mac_tx_if/m_axis_tdata[14]} {i_mac_tx_if/m_axis_tdata[15]} {i_mac_tx_if/m_axis_tdata[16]} {i_mac_tx_if/m_axis_tdata[17]} {i_mac_tx_if/m_axis_tdata[18]} {i_mac_tx_if/m_axis_tdata[19]} {i_mac_tx_if/m_axis_tdata[20]} {i_mac_tx_if/m_axis_tdata[21]} {i_mac_tx_if/m_axis_tdata[22]} {i_mac_tx_if/m_axis_tdata[23]} {i_mac_tx_if/m_axis_tdata[24]} {i_mac_tx_if/m_axis_tdata[25]} {i_mac_tx_if/m_axis_tdata[26]} {i_mac_tx_if/m_axis_tdata[27]} {i_mac_tx_if/m_axis_tdata[28]} {i_mac_tx_if/m_axis_tdata[29]} {i_mac_tx_if/m_axis_tdata[30]} {i_mac_tx_if/m_axis_tdata[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe17]
set_property port_width 1 [get_debug_ports u_ila_1/probe17]
connect_debug_port u_ila_1/probe17 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/assoc_req]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe18]
set_property port_width 1 [get_debug_ports u_ila_1/probe18]
connect_debug_port u_ila_1/probe18 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/assoc_resp_req]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe19]
set_property port_width 1 [get_debug_ports u_ila_1/probe19]
connect_debug_port u_ila_1/probe19 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/data_req]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe20]
set_property port_width 1 [get_debug_ports u_ila_1/probe20]
connect_debug_port u_ila_1/probe20 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/fcs_match]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe21]
set_property port_width 1 [get_debug_ports u_ila_1/probe21]
connect_debug_port u_ila_1/probe21 [get_nets [list i_mac_tx_if/frame_end_sync]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe22]
set_property port_width 1 [get_debug_ports u_ila_1/probe22]
connect_debug_port u_ila_1/probe22 [get_nets [list i_mac_tx_if/frame_start_sync]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe23]
set_property port_width 1 [get_debug_ports u_ila_1/probe23]
connect_debug_port u_ila_1/probe23 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/keep_alive_req]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe24]
set_property port_width 1 [get_debug_ports u_ila_1/probe24]
connect_debug_port u_ila_1/probe24 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/keep_alive_resp_req]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe25]
set_property port_width 1 [get_debug_ports u_ila_1/probe25]
connect_debug_port u_ila_1/probe25 [get_nets [list i_mac_tx_if/m_axis_tlast]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe26]
set_property port_width 1 [get_debug_ports u_ila_1/probe26]
connect_debug_port u_ila_1/probe26 [get_nets [list i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tlast]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe27]
set_property port_width 1 [get_debug_ports u_ila_1/probe27]
connect_debug_port u_ila_1/probe27 [get_nets [list i_mac_tx_if/m_axis_tready]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe28]
set_property port_width 1 [get_debug_ports u_ila_1/probe28]
connect_debug_port u_ila_1/probe28 [get_nets [list i_wigig_mac_top/i_mac_ctrl_rx/m_axis_tvalid]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe29]
set_property port_width 1 [get_debug_ports u_ila_1/probe29]
connect_debug_port u_ila_1/probe29 [get_nets [list i_mac_tx_if/m_axis_tvalid]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe30]
set_property port_width 1 [get_debug_ports u_ila_1/probe30]
connect_debug_port u_ila_1/probe30 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/mac_trans_ready]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe31]
set_property port_width 1 [get_debug_ports u_ila_1/probe31]
connect_debug_port u_ila_1/probe31 [get_nets [list i_mac_tx_if/n_0_9]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe32]
set_property port_width 1 [get_debug_ports u_ila_1/probe32]
connect_debug_port u_ila_1/probe32 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/op_mode]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe33]
set_property port_width 1 [get_debug_ports u_ila_1/probe33]
connect_debug_port u_ila_1/probe33 [get_nets [list i_mac_tx_if/p_0_in10_in]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe34]
set_property port_width 1 [get_debug_ports u_ila_1/probe34]
connect_debug_port u_ila_1/probe34 [get_nets [list i_mac_tx_if/rd_mem_sel]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe35]
set_property port_width 1 [get_debug_ports u_ila_1/probe35]
connect_debug_port u_ila_1/probe35 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/rx_last]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe36]
set_property port_width 1 [get_debug_ports u_ila_1/probe36]
connect_debug_port u_ila_1/probe36 [get_nets [list i_wigig_mac_top/i_mac_ctrl_rx/s_axis_tlast]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe37]
set_property port_width 1 [get_debug_ports u_ila_1/probe37]
connect_debug_port u_ila_1/probe37 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/s_axis_tvalid]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe38]
set_property port_width 1 [get_debug_ports u_ila_1/probe38]
connect_debug_port u_ila_1/probe38 [get_nets [list i_wigig_mac_top/i_mac_ctrl_rx/s_axis_tvalid]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe39]
set_property port_width 1 [get_debug_ports u_ila_1/probe39]
connect_debug_port u_ila_1/probe39 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/scan_req]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe40]
set_property port_width 1 [get_debug_ports u_ila_1/probe40]
connect_debug_port u_ila_1/probe40 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/scan_resp_req]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe41]
set_property port_width 1 [get_debug_ports u_ila_1/probe41]
connect_debug_port u_ila_1/probe41 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/ssw_ack_req]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe42]
set_property port_width 1 [get_debug_ports u_ila_1/probe42]
connect_debug_port u_ila_1/probe42 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/ssw_fd_req]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe43]
set_property port_width 1 [get_debug_ports u_ila_1/probe43]
connect_debug_port u_ila_1/probe43 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/ssw_req]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe44]
set_property port_width 1 [get_debug_ports u_ila_1/probe44]
connect_debug_port u_ila_1/probe44 [get_nets [list i_wigig_mac_top/i_mlme_ctrl/tx_last]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe45]
set_property port_width 1 [get_debug_ports u_ila_1/probe45]
connect_debug_port u_ila_1/probe45 [get_nets [list i_wigig_mac_top/tx_m_axis_tlast]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe46]
set_property port_width 1 [get_debug_ports u_ila_1/probe46]
connect_debug_port u_ila_1/probe46 [get_nets [list i_wigig_mac_top/tx_m_axis_tready]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe47]
set_property port_width 1 [get_debug_ports u_ila_1/probe47]
connect_debug_port u_ila_1/probe47 [get_nets [list i_wigig_mac_top/tx_m_axis_tvalid]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe48]
set_property port_width 1 [get_debug_ports u_ila_1/probe48]
connect_debug_port u_ila_1/probe48 [get_nets [list i_mac_tx_if/vid_last]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe49]
set_property port_width 1 [get_debug_ports u_ila_1/probe49]
connect_debug_port u_ila_1/probe49 [get_nets [list i_mac_tx_if/vid_last_pkt]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe50]
set_property port_width 1 [get_debug_ports u_ila_1/probe50]
connect_debug_port u_ila_1/probe50 [get_nets [list i_mac_tx_if/vid_tlast]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe51]
set_property port_width 1 [get_debug_ports u_ila_1/probe51]
connect_debug_port u_ila_1/probe51 [get_nets [list i_mac_tx_if/video_fifo_empty]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe52]
set_property port_width 1 [get_debug_ports u_ila_1/probe52]
connect_debug_port u_ila_1/probe52 [get_nets [list i_mac_tx_if/video_fifo_rd_rst_busy]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe53]
set_property port_width 1 [get_debug_ports u_ila_1/probe53]
connect_debug_port u_ila_1/probe53 [get_nets [list i_mac_tx_if/wr_mem_sel]]
create_debug_core u_ila_2 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_2]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_2]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_2]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_2]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_2]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_2]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_2]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_2]
set_property port_width 1 [get_debug_ports u_ila_2/clk]
connect_debug_port u_ila_2/clk [get_nets [list {vx1_phy/vx1_phy/inst/gen_gtwizard_gthe4_top.vx1_phy_gtwizard_gthe4_inst/gen_gtwizard_gthe4.gen_tx_user_clocking_internal.gen_single_instance.gtwiz_userclk_tx_inst/gtwiz_userclk_tx_usrclk2_out[0]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe0]
set_property port_width 480 [get_debug_ports u_ila_2/probe0]
connect_debug_port u_ila_2/probe0 [get_nets [list {u_line_selctor/data_in[2]} {u_line_selctor/data_in[3]} {u_line_selctor/data_in[4]} {u_line_selctor/data_in[5]} {u_line_selctor/data_in[6]} {u_line_selctor/data_in[7]} {u_line_selctor/data_in[8]} {u_line_selctor/data_in[9]} {u_line_selctor/data_in[10]} {u_line_selctor/data_in[11]} {u_line_selctor/data_in[14]} {u_line_selctor/data_in[15]} {u_line_selctor/data_in[16]} {u_line_selctor/data_in[17]} {u_line_selctor/data_in[18]} {u_line_selctor/data_in[19]} {u_line_selctor/data_in[20]} {u_line_selctor/data_in[21]} {u_line_selctor/data_in[22]} {u_line_selctor/data_in[23]} {u_line_selctor/data_in[26]} {u_line_selctor/data_in[27]} {u_line_selctor/data_in[28]} {u_line_selctor/data_in[29]} {u_line_selctor/data_in[30]} {u_line_selctor/data_in[31]} {u_line_selctor/data_in[32]} {u_line_selctor/data_in[33]} {u_line_selctor/data_in[34]} {u_line_selctor/data_in[35]} {u_line_selctor/data_in[38]} {u_line_selctor/data_in[39]} {u_line_selctor/data_in[40]} {u_line_selctor/data_in[41]} {u_line_selctor/data_in[42]} {u_line_selctor/data_in[43]} {u_line_selctor/data_in[44]} {u_line_selctor/data_in[45]} {u_line_selctor/data_in[46]} {u_line_selctor/data_in[47]} {u_line_selctor/data_in[50]} {u_line_selctor/data_in[51]} {u_line_selctor/data_in[52]} {u_line_selctor/data_in[53]} {u_line_selctor/data_in[54]} {u_line_selctor/data_in[55]} {u_line_selctor/data_in[56]} {u_line_selctor/data_in[57]} {u_line_selctor/data_in[58]} {u_line_selctor/data_in[59]} {u_line_selctor/data_in[62]} {u_line_selctor/data_in[63]} {u_line_selctor/data_in[64]} {u_line_selctor/data_in[65]} {u_line_selctor/data_in[66]} {u_line_selctor/data_in[67]} {u_line_selctor/data_in[68]} {u_line_selctor/data_in[69]} {u_line_selctor/data_in[70]} {u_line_selctor/data_in[71]} {u_line_selctor/data_in[74]} {u_line_selctor/data_in[75]} {u_line_selctor/data_in[76]} {u_line_selctor/data_in[77]} {u_line_selctor/data_in[78]} {u_line_selctor/data_in[79]} {u_line_selctor/data_in[80]} {u_line_selctor/data_in[81]} {u_line_selctor/data_in[82]} {u_line_selctor/data_in[83]} {u_line_selctor/data_in[86]} {u_line_selctor/data_in[87]} {u_line_selctor/data_in[88]} {u_line_selctor/data_in[89]} {u_line_selctor/data_in[90]} {u_line_selctor/data_in[91]} {u_line_selctor/data_in[92]} {u_line_selctor/data_in[93]} {u_line_selctor/data_in[94]} {u_line_selctor/data_in[95]} {u_line_selctor/data_in[98]} {u_line_selctor/data_in[99]} {u_line_selctor/data_in[100]} {u_line_selctor/data_in[101]} {u_line_selctor/data_in[102]} {u_line_selctor/data_in[103]} {u_line_selctor/data_in[104]} {u_line_selctor/data_in[105]} {u_line_selctor/data_in[106]} {u_line_selctor/data_in[107]} {u_line_selctor/data_in[110]} {u_line_selctor/data_in[111]} {u_line_selctor/data_in[112]} {u_line_selctor/data_in[113]} {u_line_selctor/data_in[114]} {u_line_selctor/data_in[115]} {u_line_selctor/data_in[116]} {u_line_selctor/data_in[117]} {u_line_selctor/data_in[118]} {u_line_selctor/data_in[119]} {u_line_selctor/data_in[122]} {u_line_selctor/data_in[123]} {u_line_selctor/data_in[124]} {u_line_selctor/data_in[125]} {u_line_selctor/data_in[126]} {u_line_selctor/data_in[127]} {u_line_selctor/data_in[128]} {u_line_selctor/data_in[129]} {u_line_selctor/data_in[130]} {u_line_selctor/data_in[131]} {u_line_selctor/data_in[134]} {u_line_selctor/data_in[135]} {u_line_selctor/data_in[136]} {u_line_selctor/data_in[137]} {u_line_selctor/data_in[138]} {u_line_selctor/data_in[139]} {u_line_selctor/data_in[140]} {u_line_selctor/data_in[141]} {u_line_selctor/data_in[142]} {u_line_selctor/data_in[143]} {u_line_selctor/data_in[146]} {u_line_selctor/data_in[147]} {u_line_selctor/data_in[148]} {u_line_selctor/data_in[149]} {u_line_selctor/data_in[150]} {u_line_selctor/data_in[151]} {u_line_selctor/data_in[152]} {u_line_selctor/data_in[153]} {u_line_selctor/data_in[154]} {u_line_selctor/data_in[155]} {u_line_selctor/data_in[158]} {u_line_selctor/data_in[159]} {u_line_selctor/data_in[160]} {u_line_selctor/data_in[161]} {u_line_selctor/data_in[162]} {u_line_selctor/data_in[163]} {u_line_selctor/data_in[164]} {u_line_selctor/data_in[165]} {u_line_selctor/data_in[166]} {u_line_selctor/data_in[167]} {u_line_selctor/data_in[170]} {u_line_selctor/data_in[171]} {u_line_selctor/data_in[172]} {u_line_selctor/data_in[173]} {u_line_selctor/data_in[174]} {u_line_selctor/data_in[175]} {u_line_selctor/data_in[176]} {u_line_selctor/data_in[177]} {u_line_selctor/data_in[178]} {u_line_selctor/data_in[179]} {u_line_selctor/data_in[182]} {u_line_selctor/data_in[183]} {u_line_selctor/data_in[184]} {u_line_selctor/data_in[185]} {u_line_selctor/data_in[186]} {u_line_selctor/data_in[187]} {u_line_selctor/data_in[188]} {u_line_selctor/data_in[189]} {u_line_selctor/data_in[190]} {u_line_selctor/data_in[191]} {u_line_selctor/data_in[194]} {u_line_selctor/data_in[195]} {u_line_selctor/data_in[196]} {u_line_selctor/data_in[197]} {u_line_selctor/data_in[198]} {u_line_selctor/data_in[199]} {u_line_selctor/data_in[200]} {u_line_selctor/data_in[201]} {u_line_selctor/data_in[202]} {u_line_selctor/data_in[203]} {u_line_selctor/data_in[206]} {u_line_selctor/data_in[207]} {u_line_selctor/data_in[208]} {u_line_selctor/data_in[209]} {u_line_selctor/data_in[210]} {u_line_selctor/data_in[211]} {u_line_selctor/data_in[212]} {u_line_selctor/data_in[213]} {u_line_selctor/data_in[214]} {u_line_selctor/data_in[215]} {u_line_selctor/data_in[218]} {u_line_selctor/data_in[219]} {u_line_selctor/data_in[220]} {u_line_selctor/data_in[221]} {u_line_selctor/data_in[222]} {u_line_selctor/data_in[223]} {u_line_selctor/data_in[224]} {u_line_selctor/data_in[225]} {u_line_selctor/data_in[226]} {u_line_selctor/data_in[227]} {u_line_selctor/data_in[230]} {u_line_selctor/data_in[231]} {u_line_selctor/data_in[232]} {u_line_selctor/data_in[233]} {u_line_selctor/data_in[234]} {u_line_selctor/data_in[235]} {u_line_selctor/data_in[236]} {u_line_selctor/data_in[237]} {u_line_selctor/data_in[238]} {u_line_selctor/data_in[239]} {u_line_selctor/data_in[242]} {u_line_selctor/data_in[243]} {u_line_selctor/data_in[244]} {u_line_selctor/data_in[245]} {u_line_selctor/data_in[246]} {u_line_selctor/data_in[247]} {u_line_selctor/data_in[248]} {u_line_selctor/data_in[249]} {u_line_selctor/data_in[250]} {u_line_selctor/data_in[251]} {u_line_selctor/data_in[254]} {u_line_selctor/data_in[255]} {u_line_selctor/data_in[256]} {u_line_selctor/data_in[257]} {u_line_selctor/data_in[258]} {u_line_selctor/data_in[259]} {u_line_selctor/data_in[260]} {u_line_selctor/data_in[261]} {u_line_selctor/data_in[262]} {u_line_selctor/data_in[263]} {u_line_selctor/data_in[266]} {u_line_selctor/data_in[267]} {u_line_selctor/data_in[268]} {u_line_selctor/data_in[269]} {u_line_selctor/data_in[270]} {u_line_selctor/data_in[271]} {u_line_selctor/data_in[272]} {u_line_selctor/data_in[273]} {u_line_selctor/data_in[274]} {u_line_selctor/data_in[275]} {u_line_selctor/data_in[278]} {u_line_selctor/data_in[279]} {u_line_selctor/data_in[280]} {u_line_selctor/data_in[281]} {u_line_selctor/data_in[282]} {u_line_selctor/data_in[283]} {u_line_selctor/data_in[284]} {u_line_selctor/data_in[285]} {u_line_selctor/data_in[286]} {u_line_selctor/data_in[287]} {u_line_selctor/data_in[290]} {u_line_selctor/data_in[291]} {u_line_selctor/data_in[292]} {u_line_selctor/data_in[293]} {u_line_selctor/data_in[294]} {u_line_selctor/data_in[295]} {u_line_selctor/data_in[296]} {u_line_selctor/data_in[297]} {u_line_selctor/data_in[298]} {u_line_selctor/data_in[299]} {u_line_selctor/data_in[302]} {u_line_selctor/data_in[303]} {u_line_selctor/data_in[304]} {u_line_selctor/data_in[305]} {u_line_selctor/data_in[306]} {u_line_selctor/data_in[307]} {u_line_selctor/data_in[308]} {u_line_selctor/data_in[309]} {u_line_selctor/data_in[310]} {u_line_selctor/data_in[311]} {u_line_selctor/data_in[314]} {u_line_selctor/data_in[315]} {u_line_selctor/data_in[316]} {u_line_selctor/data_in[317]} {u_line_selctor/data_in[318]} {u_line_selctor/data_in[319]} {u_line_selctor/data_in[320]} {u_line_selctor/data_in[321]} {u_line_selctor/data_in[322]} {u_line_selctor/data_in[323]} {u_line_selctor/data_in[326]} {u_line_selctor/data_in[327]} {u_line_selctor/data_in[328]} {u_line_selctor/data_in[329]} {u_line_selctor/data_in[330]} {u_line_selctor/data_in[331]} {u_line_selctor/data_in[332]} {u_line_selctor/data_in[333]} {u_line_selctor/data_in[334]} {u_line_selctor/data_in[335]} {u_line_selctor/data_in[338]} {u_line_selctor/data_in[339]} {u_line_selctor/data_in[340]} {u_line_selctor/data_in[341]} {u_line_selctor/data_in[342]} {u_line_selctor/data_in[343]} {u_line_selctor/data_in[344]} {u_line_selctor/data_in[345]} {u_line_selctor/data_in[346]} {u_line_selctor/data_in[347]} {u_line_selctor/data_in[350]} {u_line_selctor/data_in[351]} {u_line_selctor/data_in[352]} {u_line_selctor/data_in[353]} {u_line_selctor/data_in[354]} {u_line_selctor/data_in[355]} {u_line_selctor/data_in[356]} {u_line_selctor/data_in[357]} {u_line_selctor/data_in[358]} {u_line_selctor/data_in[359]} {u_line_selctor/data_in[362]} {u_line_selctor/data_in[363]} {u_line_selctor/data_in[364]} {u_line_selctor/data_in[365]} {u_line_selctor/data_in[366]} {u_line_selctor/data_in[367]} {u_line_selctor/data_in[368]} {u_line_selctor/data_in[369]} {u_line_selctor/data_in[370]} {u_line_selctor/data_in[371]} {u_line_selctor/data_in[374]} {u_line_selctor/data_in[375]} {u_line_selctor/data_in[376]} {u_line_selctor/data_in[377]} {u_line_selctor/data_in[378]} {u_line_selctor/data_in[379]} {u_line_selctor/data_in[380]} {u_line_selctor/data_in[381]} {u_line_selctor/data_in[382]} {u_line_selctor/data_in[383]} {u_line_selctor/data_in[386]} {u_line_selctor/data_in[387]} {u_line_selctor/data_in[388]} {u_line_selctor/data_in[389]} {u_line_selctor/data_in[390]} {u_line_selctor/data_in[391]} {u_line_selctor/data_in[392]} {u_line_selctor/data_in[393]} {u_line_selctor/data_in[394]} {u_line_selctor/data_in[395]} {u_line_selctor/data_in[398]} {u_line_selctor/data_in[399]} {u_line_selctor/data_in[400]} {u_line_selctor/data_in[401]} {u_line_selctor/data_in[402]} {u_line_selctor/data_in[403]} {u_line_selctor/data_in[404]} {u_line_selctor/data_in[405]} {u_line_selctor/data_in[406]} {u_line_selctor/data_in[407]} {u_line_selctor/data_in[410]} {u_line_selctor/data_in[411]} {u_line_selctor/data_in[412]} {u_line_selctor/data_in[413]} {u_line_selctor/data_in[414]} {u_line_selctor/data_in[415]} {u_line_selctor/data_in[416]} {u_line_selctor/data_in[417]} {u_line_selctor/data_in[418]} {u_line_selctor/data_in[419]} {u_line_selctor/data_in[422]} {u_line_selctor/data_in[423]} {u_line_selctor/data_in[424]} {u_line_selctor/data_in[425]} {u_line_selctor/data_in[426]} {u_line_selctor/data_in[427]} {u_line_selctor/data_in[428]} {u_line_selctor/data_in[429]} {u_line_selctor/data_in[430]} {u_line_selctor/data_in[431]} {u_line_selctor/data_in[434]} {u_line_selctor/data_in[435]} {u_line_selctor/data_in[436]} {u_line_selctor/data_in[437]} {u_line_selctor/data_in[438]} {u_line_selctor/data_in[439]} {u_line_selctor/data_in[440]} {u_line_selctor/data_in[441]} {u_line_selctor/data_in[442]} {u_line_selctor/data_in[443]} {u_line_selctor/data_in[446]} {u_line_selctor/data_in[447]} {u_line_selctor/data_in[448]} {u_line_selctor/data_in[449]} {u_line_selctor/data_in[450]} {u_line_selctor/data_in[451]} {u_line_selctor/data_in[452]} {u_line_selctor/data_in[453]} {u_line_selctor/data_in[454]} {u_line_selctor/data_in[455]} {u_line_selctor/data_in[458]} {u_line_selctor/data_in[459]} {u_line_selctor/data_in[460]} {u_line_selctor/data_in[461]} {u_line_selctor/data_in[462]} {u_line_selctor/data_in[463]} {u_line_selctor/data_in[464]} {u_line_selctor/data_in[465]} {u_line_selctor/data_in[466]} {u_line_selctor/data_in[467]} {u_line_selctor/data_in[470]} {u_line_selctor/data_in[471]} {u_line_selctor/data_in[472]} {u_line_selctor/data_in[473]} {u_line_selctor/data_in[474]} {u_line_selctor/data_in[475]} {u_line_selctor/data_in[476]} {u_line_selctor/data_in[477]} {u_line_selctor/data_in[478]} {u_line_selctor/data_in[479]} {u_line_selctor/data_in[482]} {u_line_selctor/data_in[483]} {u_line_selctor/data_in[484]} {u_line_selctor/data_in[485]} {u_line_selctor/data_in[486]} {u_line_selctor/data_in[487]} {u_line_selctor/data_in[488]} {u_line_selctor/data_in[489]} {u_line_selctor/data_in[490]} {u_line_selctor/data_in[491]} {u_line_selctor/data_in[494]} {u_line_selctor/data_in[495]} {u_line_selctor/data_in[496]} {u_line_selctor/data_in[497]} {u_line_selctor/data_in[498]} {u_line_selctor/data_in[499]} {u_line_selctor/data_in[500]} {u_line_selctor/data_in[501]} {u_line_selctor/data_in[502]} {u_line_selctor/data_in[503]} {u_line_selctor/data_in[506]} {u_line_selctor/data_in[507]} {u_line_selctor/data_in[508]} {u_line_selctor/data_in[509]} {u_line_selctor/data_in[510]} {u_line_selctor/data_in[511]} {u_line_selctor/data_in[512]} {u_line_selctor/data_in[513]} {u_line_selctor/data_in[514]} {u_line_selctor/data_in[515]} {u_line_selctor/data_in[518]} {u_line_selctor/data_in[519]} {u_line_selctor/data_in[520]} {u_line_selctor/data_in[521]} {u_line_selctor/data_in[522]} {u_line_selctor/data_in[523]} {u_line_selctor/data_in[524]} {u_line_selctor/data_in[525]} {u_line_selctor/data_in[526]} {u_line_selctor/data_in[527]} {u_line_selctor/data_in[530]} {u_line_selctor/data_in[531]} {u_line_selctor/data_in[532]} {u_line_selctor/data_in[533]} {u_line_selctor/data_in[534]} {u_line_selctor/data_in[535]} {u_line_selctor/data_in[536]} {u_line_selctor/data_in[537]} {u_line_selctor/data_in[538]} {u_line_selctor/data_in[539]} {u_line_selctor/data_in[542]} {u_line_selctor/data_in[543]} {u_line_selctor/data_in[544]} {u_line_selctor/data_in[545]} {u_line_selctor/data_in[546]} {u_line_selctor/data_in[547]} {u_line_selctor/data_in[548]} {u_line_selctor/data_in[549]} {u_line_selctor/data_in[550]} {u_line_selctor/data_in[551]} {u_line_selctor/data_in[554]} {u_line_selctor/data_in[555]} {u_line_selctor/data_in[556]} {u_line_selctor/data_in[557]} {u_line_selctor/data_in[558]} {u_line_selctor/data_in[559]} {u_line_selctor/data_in[560]} {u_line_selctor/data_in[561]} {u_line_selctor/data_in[562]} {u_line_selctor/data_in[563]} {u_line_selctor/data_in[566]} {u_line_selctor/data_in[567]} {u_line_selctor/data_in[568]} {u_line_selctor/data_in[569]} {u_line_selctor/data_in[570]} {u_line_selctor/data_in[571]} {u_line_selctor/data_in[572]} {u_line_selctor/data_in[573]} {u_line_selctor/data_in[574]} {u_line_selctor/data_in[575]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe1]
set_property port_width 1 [get_debug_ports u_ila_2/probe1]
connect_debug_port u_ila_2/probe1 [get_nets [list u_line_selctor/DE]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe2]
set_property port_width 1 [get_debug_ports u_ila_2/probe2]
connect_debug_port u_ila_2/probe2 [get_nets [list u_line_selctor/DE_2line_d]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe3]
set_property port_width 1 [get_debug_ports u_ila_2/probe3]
connect_debug_port u_ila_2/probe3 [get_nets [list u_line_selctor/de_err]]
create_debug_core u_ila_3 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_3]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_3]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_3]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_3]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_3]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_3]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_3]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_3]
set_property port_width 1 [get_debug_ports u_ila_3/clk]
connect_debug_port u_ila_3/clk [get_nets [list {u_gty_top/example_wrapper_inst/gtwiz_userclk_rx_inst/gtwiz_userclk_rx_usrclk2_out[0]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe0]
set_property port_width 4 [get_debug_ports u_ila_3/probe0]
connect_debug_port u_ila_3/probe0 [get_nets [list {u_gty_top/s_axis_tkeep_rx[0]} {u_gty_top/s_axis_tkeep_rx[1]} {u_gty_top/s_axis_tkeep_rx[2]} {u_gty_top/s_axis_tkeep_rx[3]}]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe1]
set_property port_width 56 [get_debug_ports u_ila_3/probe1]
connect_debug_port u_ila_3/probe1 [get_nets [list {u_gty_top/rx_buf[0]} {u_gty_top/rx_buf[1]} {u_gty_top/rx_buf[2]} {u_gty_top/rx_buf[3]} {u_gty_top/rx_buf[4]} {u_gty_top/rx_buf[5]} {u_gty_top/rx_buf[6]} {u_gty_top/rx_buf[7]} {u_gty_top/rx_buf[8]} {u_gty_top/rx_buf[9]} {u_gty_top/rx_buf[10]} {u_gty_top/rx_buf[11]} {u_gty_top/rx_buf[12]} {u_gty_top/rx_buf[13]} {u_gty_top/rx_buf[14]} {u_gty_top/rx_buf[15]} {u_gty_top/rx_buf[16]} {u_gty_top/rx_buf[17]} {u_gty_top/rx_buf[18]} {u_gty_top/rx_buf[19]} {u_gty_top/rx_buf[20]} {u_gty_top/rx_buf[21]} {u_gty_top/rx_buf[22]} {u_gty_top/rx_buf[23]} {u_gty_top/rx_buf[24]} {u_gty_top/rx_buf[25]} {u_gty_top/rx_buf[26]} {u_gty_top/rx_buf[27]} {u_gty_top/rx_buf[28]} {u_gty_top/rx_buf[29]} {u_gty_top/rx_buf[30]} {u_gty_top/rx_buf[31]} {u_gty_top/rx_buf[32]} {u_gty_top/rx_buf[33]} {u_gty_top/rx_buf[34]} {u_gty_top/rx_buf[35]} {u_gty_top/rx_buf[36]} {u_gty_top/rx_buf[37]} {u_gty_top/rx_buf[38]} {u_gty_top/rx_buf[39]} {u_gty_top/rx_buf[40]} {u_gty_top/rx_buf[41]} {u_gty_top/rx_buf[42]} {u_gty_top/rx_buf[43]} {u_gty_top/rx_buf[44]} {u_gty_top/rx_buf[45]} {u_gty_top/rx_buf[46]} {u_gty_top/rx_buf[47]} {u_gty_top/rx_buf[48]} {u_gty_top/rx_buf[49]} {u_gty_top/rx_buf[50]} {u_gty_top/rx_buf[51]} {u_gty_top/rx_buf[52]} {u_gty_top/rx_buf[53]} {u_gty_top/rx_buf[54]} {u_gty_top/rx_buf[55]}]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe2]
set_property port_width 3 [get_debug_ports u_ila_3/probe2]
connect_debug_port u_ila_3/probe2 [get_nets [list {u_gty_top/rx_sum[0]} {u_gty_top/rx_sum[1]} {u_gty_top/rx_sum[2]}]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe3]
set_property port_width 8 [get_debug_ports u_ila_3/probe3]
connect_debug_port u_ila_3/probe3 [get_nets [list {u_gty_top/rxctrl2_ff[0]} {u_gty_top/rxctrl2_ff[1]} {u_gty_top/rxctrl2_ff[2]} {u_gty_top/rxctrl2_ff[3]} {u_gty_top/rxctrl2_ff[4]} {u_gty_top/rxctrl2_ff[5]} {u_gty_top/rxctrl2_ff[6]} {u_gty_top/rxctrl2_ff[7]}]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe4]
set_property port_width 8 [get_debug_ports u_ila_3/probe4]
connect_debug_port u_ila_3/probe4 [get_nets [list {u_gty_top/rxctrl2_int[0]} {u_gty_top/rxctrl2_int[1]} {u_gty_top/rxctrl2_int[2]} {u_gty_top/rxctrl2_int[3]} {u_gty_top/rxctrl2_int[4]} {u_gty_top/rxctrl2_int[5]} {u_gty_top/rxctrl2_int[6]} {u_gty_top/rxctrl2_int[7]}]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe5]
set_property port_width 32 [get_debug_ports u_ila_3/probe5]
connect_debug_port u_ila_3/probe5 [get_nets [list {u_gty_top/gtwiz_userdata_rx_int[0]} {u_gty_top/gtwiz_userdata_rx_int[1]} {u_gty_top/gtwiz_userdata_rx_int[2]} {u_gty_top/gtwiz_userdata_rx_int[3]} {u_gty_top/gtwiz_userdata_rx_int[4]} {u_gty_top/gtwiz_userdata_rx_int[5]} {u_gty_top/gtwiz_userdata_rx_int[6]} {u_gty_top/gtwiz_userdata_rx_int[7]} {u_gty_top/gtwiz_userdata_rx_int[8]} {u_gty_top/gtwiz_userdata_rx_int[9]} {u_gty_top/gtwiz_userdata_rx_int[10]} {u_gty_top/gtwiz_userdata_rx_int[11]} {u_gty_top/gtwiz_userdata_rx_int[12]} {u_gty_top/gtwiz_userdata_rx_int[13]} {u_gty_top/gtwiz_userdata_rx_int[14]} {u_gty_top/gtwiz_userdata_rx_int[15]} {u_gty_top/gtwiz_userdata_rx_int[16]} {u_gty_top/gtwiz_userdata_rx_int[17]} {u_gty_top/gtwiz_userdata_rx_int[18]} {u_gty_top/gtwiz_userdata_rx_int[19]} {u_gty_top/gtwiz_userdata_rx_int[20]} {u_gty_top/gtwiz_userdata_rx_int[21]} {u_gty_top/gtwiz_userdata_rx_int[22]} {u_gty_top/gtwiz_userdata_rx_int[23]} {u_gty_top/gtwiz_userdata_rx_int[24]} {u_gty_top/gtwiz_userdata_rx_int[25]} {u_gty_top/gtwiz_userdata_rx_int[26]} {u_gty_top/gtwiz_userdata_rx_int[27]} {u_gty_top/gtwiz_userdata_rx_int[28]} {u_gty_top/gtwiz_userdata_rx_int[29]} {u_gty_top/gtwiz_userdata_rx_int[30]} {u_gty_top/gtwiz_userdata_rx_int[31]}]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe6]
set_property port_width 32 [get_debug_ports u_ila_3/probe6]
connect_debug_port u_ila_3/probe6 [get_nets [list {u_gty_top/s_axis_tdata_rx[0]} {u_gty_top/s_axis_tdata_rx[1]} {u_gty_top/s_axis_tdata_rx[2]} {u_gty_top/s_axis_tdata_rx[3]} {u_gty_top/s_axis_tdata_rx[4]} {u_gty_top/s_axis_tdata_rx[5]} {u_gty_top/s_axis_tdata_rx[6]} {u_gty_top/s_axis_tdata_rx[7]} {u_gty_top/s_axis_tdata_rx[8]} {u_gty_top/s_axis_tdata_rx[9]} {u_gty_top/s_axis_tdata_rx[10]} {u_gty_top/s_axis_tdata_rx[11]} {u_gty_top/s_axis_tdata_rx[12]} {u_gty_top/s_axis_tdata_rx[13]} {u_gty_top/s_axis_tdata_rx[14]} {u_gty_top/s_axis_tdata_rx[15]} {u_gty_top/s_axis_tdata_rx[16]} {u_gty_top/s_axis_tdata_rx[17]} {u_gty_top/s_axis_tdata_rx[18]} {u_gty_top/s_axis_tdata_rx[19]} {u_gty_top/s_axis_tdata_rx[20]} {u_gty_top/s_axis_tdata_rx[21]} {u_gty_top/s_axis_tdata_rx[22]} {u_gty_top/s_axis_tdata_rx[23]} {u_gty_top/s_axis_tdata_rx[24]} {u_gty_top/s_axis_tdata_rx[25]} {u_gty_top/s_axis_tdata_rx[26]} {u_gty_top/s_axis_tdata_rx[27]} {u_gty_top/s_axis_tdata_rx[28]} {u_gty_top/s_axis_tdata_rx[29]} {u_gty_top/s_axis_tdata_rx[30]} {u_gty_top/s_axis_tdata_rx[31]}]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe7]
set_property port_width 1 [get_debug_ports u_ila_3/probe7]
connect_debug_port u_ila_3/probe7 [get_nets [list u_gty_top/fifo_rstn]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe8]
set_property port_width 1 [get_debug_ports u_ila_3/probe8]
connect_debug_port u_ila_3/probe8 [get_nets [list u_gty_top/gtpowergood_int]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe9]
set_property port_width 1 [get_debug_ports u_ila_3/probe9]
connect_debug_port u_ila_3/probe9 [get_nets [list u_gty_top/rxbyteisaligned_int]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe10]
set_property port_width 1 [get_debug_ports u_ila_3/probe10]
connect_debug_port u_ila_3/probe10 [get_nets [list u_gty_top/rxbyterealign_int]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe11]
set_property port_width 1 [get_debug_ports u_ila_3/probe11]
connect_debug_port u_ila_3/probe11 [get_nets [list u_gty_top/rxpmaresetdone_int]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe12]
set_property port_width 1 [get_debug_ports u_ila_3/probe12]
connect_debug_port u_ila_3/probe12 [get_nets [list u_gty_top/s_axis_tlast_rx]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe13]
set_property port_width 1 [get_debug_ports u_ila_3/probe13]
connect_debug_port u_ila_3/probe13 [get_nets [list u_gty_top/s_axis_tready_rx]]
create_debug_port u_ila_3 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_3/probe14]
set_property port_width 1 [get_debug_ports u_ila_3/probe14]
connect_debug_port u_ila_3/probe14 [get_nets [list u_gty_top/s_axis_tvalid_rx]]
create_debug_core u_ila_4 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_4]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_4]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_4]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_4]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_4]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_4]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_4]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_4]
set_property port_width 1 [get_debug_ports u_ila_4/clk]
connect_debug_port u_ila_4/clk [get_nets [list u_gty_top/drpclk_int]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_4/probe0]
set_property port_width 16 [get_debug_ports u_ila_4/probe0]
connect_debug_port u_ila_4/probe0 [get_nets [list {u_gty_top/rxcommadet_check_cnt[0]} {u_gty_top/rxcommadet_check_cnt[1]} {u_gty_top/rxcommadet_check_cnt[2]} {u_gty_top/rxcommadet_check_cnt[3]} {u_gty_top/rxcommadet_check_cnt[4]} {u_gty_top/rxcommadet_check_cnt[5]} {u_gty_top/rxcommadet_check_cnt[6]} {u_gty_top/rxcommadet_check_cnt[7]} {u_gty_top/rxcommadet_check_cnt[8]} {u_gty_top/rxcommadet_check_cnt[9]} {u_gty_top/rxcommadet_check_cnt[10]} {u_gty_top/rxcommadet_check_cnt[11]} {u_gty_top/rxcommadet_check_cnt[12]} {u_gty_top/rxcommadet_check_cnt[13]} {u_gty_top/rxcommadet_check_cnt[14]} {u_gty_top/rxcommadet_check_cnt[15]}]]
create_debug_port u_ila_4 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_4/probe1]
set_property port_width 1 [get_debug_ports u_ila_4/probe1]
connect_debug_port u_ila_4/probe1 [get_nets [list u_gty_top/gt_rx_rst]]
create_debug_port u_ila_4 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_4/probe2]
set_property port_width 1 [get_debug_ports u_ila_4/probe2]
connect_debug_port u_ila_4/probe2 [get_nets [list u_gty_top/hb_gtwiz_reset_all_init_int]]
create_debug_port u_ila_4 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_4/probe3]
set_property port_width 1 [get_debug_ports u_ila_4/probe3]
connect_debug_port u_ila_4/probe3 [get_nets [list u_gty_top/hb_gtwiz_reset_all_int]]
create_debug_port u_ila_4 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_4/probe4]
set_property port_width 1 [get_debug_ports u_ila_4/probe4]
connect_debug_port u_ila_4/probe4 [get_nets [list u_gty_top/hb_gtwiz_reset_rx_datapath_init_int]]
create_debug_port u_ila_4 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_4/probe5]
set_property port_width 1 [get_debug_ports u_ila_4/probe5]
connect_debug_port u_ila_4/probe5 [get_nets [list u_gty_top/hb_gtwiz_reset_rx_datapath_int]]
create_debug_port u_ila_4 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_4/probe6]
set_property port_width 1 [get_debug_ports u_ila_4/probe6]
connect_debug_port u_ila_4/probe6 [get_nets [list u_gty_top/rxcommadet_int]]
create_debug_port u_ila_4 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_4/probe7]
set_property port_width 1 [get_debug_ports u_ila_4/probe7]
connect_debug_port u_ila_4/probe7 [get_nets [list u_gty_top/txpmaresetdone_int]]
create_debug_core u_ila_5 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_5]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_5]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_5]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_5]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_5]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_5]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_5]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_5]
set_property port_width 1 [get_debug_ports u_ila_5/clk]
connect_debug_port u_ila_5/clk [get_nets [list FPGA_50MHz_IBUF_BUFG]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_5/probe0]
set_property port_width 1 [get_debug_ports u_ila_5/probe0]
connect_debug_port u_ila_5/probe0 [get_nets [list u_board_reset_gen/en_mask_dbg]]
create_debug_port u_ila_5 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_5/probe1]
set_property port_width 1 [get_debug_ports u_ila_5/probe1]
connect_debug_port u_ila_5/probe1 [get_nets [list u_board_reset_gen/nrst_gty_dbg]]
create_debug_port u_ila_5 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_5/probe2]
set_property port_width 1 [get_debug_ports u_ila_5/probe2]
connect_debug_port u_ila_5/probe2 [get_nets [list u_board_reset_gen/nrst_tmc_dbg]]
create_debug_port u_ila_5 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_5/probe3]
set_property port_width 1 [get_debug_ports u_ila_5/probe3]
connect_debug_port u_ila_5/probe3 [get_nets [list u_board_reset_gen/pwr_on_rst_int_dbg]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets axi_clk]
