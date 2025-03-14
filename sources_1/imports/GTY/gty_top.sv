`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: wise-jet
// Engineer: yj
// 
// Create Date: 2024/08/22
// Design Name: 802.11ad MAC
// Module Name: gty_top
// Project Name: 802.11ad 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////
module gty_top (
  input nrst,
  input fclk,
  input pclk,
  input nclk,

  output gtytxp,
  output gtytxn,
  input gtyrxp,
  input gtyrxn,

  output gty_txusrclk,
  output gty_rxusrclk,

  output logic gtwiz_reset_tx_done_int,
  output logic gtwiz_reset_rx_done_int,

  // to gty or phy
  input [31:0] m_axis_tdata_phy,
  input [3:0] m_axis_tkeep_phy,
  input m_axis_tvalid_phy,
  output m_axis_tready_phy,
  input m_axis_tlast_phy,

  // to MAC
  output logic [31:0] m_axis_tdata_dec,
  output logic [3:0] m_axis_tkeep_dec,
  output logic m_axis_tvalid_dec,
  output logic m_axis_tlast_dec,
  input logic m_axis_tready_dec
  
    );

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_tx_reset_int;
  wire [0:0] hb0_gtwiz_userclk_tx_reset_int;
  assign gtwiz_userclk_tx_reset_int[0:0] = hb0_gtwiz_userclk_tx_reset_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_tx_srcclk_int;
  wire [0:0] hb0_gtwiz_userclk_tx_srcclk_int;
  assign hb0_gtwiz_userclk_tx_srcclk_int = gtwiz_userclk_tx_srcclk_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_tx_usrclk_int;
  wire [0:0] hb0_gtwiz_userclk_tx_usrclk_int;
  assign hb0_gtwiz_userclk_tx_usrclk_int = gtwiz_userclk_tx_usrclk_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_tx_usrclk2_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_tx_active_int;
  wire [0:0] hb0_gtwiz_userclk_tx_active_int;
  assign hb0_gtwiz_userclk_tx_active_int = gtwiz_userclk_tx_active_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_rx_reset_int;
  wire [0:0] hb0_gtwiz_userclk_rx_reset_int;
  assign gtwiz_userclk_rx_reset_int[0:0] = hb0_gtwiz_userclk_rx_reset_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_rx_srcclk_int;
  wire [0:0] hb0_gtwiz_userclk_rx_srcclk_int;
  assign hb0_gtwiz_userclk_rx_srcclk_int = gtwiz_userclk_rx_srcclk_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_rx_usrclk_int;
  wire [0:0] hb0_gtwiz_userclk_rx_usrclk_int;
  assign hb0_gtwiz_userclk_rx_usrclk_int = gtwiz_userclk_rx_usrclk_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_rx_usrclk2_int;
  wire [0:0] hb0_gtwiz_userclk_rx_usrclk2_int;
  assign hb0_gtwiz_userclk_rx_usrclk2_int = gtwiz_userclk_rx_usrclk2_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_userclk_rx_active_int;
  wire [0:0] hb0_gtwiz_userclk_rx_active_int;
  assign hb0_gtwiz_userclk_rx_active_int = gtwiz_userclk_rx_active_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_clk_freerun_int;
  wire [0:0] hb0_gtwiz_reset_clk_freerun_int = 1'b0;
  assign gtwiz_reset_clk_freerun_int[0:0] = hb0_gtwiz_reset_clk_freerun_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_rx_pll_and_datapath_int;
  wire [0:0] hb0_gtwiz_reset_rx_pll_and_datapath_int = 1'b0;
  assign gtwiz_reset_rx_pll_and_datapath_int[0:0] = hb0_gtwiz_reset_rx_pll_and_datapath_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_rx_datapath_int;
  wire [0:0] hb0_gtwiz_reset_rx_datapath_int = 1'b0;
  assign gtwiz_reset_rx_datapath_int[0:0] = hb0_gtwiz_reset_rx_datapath_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_rx_cdr_stable_int;
  wire [0:0] hb0_gtwiz_reset_rx_cdr_stable_int;
  assign hb0_gtwiz_reset_rx_cdr_stable_int = gtwiz_reset_rx_cdr_stable_int[0:0];
 
//--------------------------------------------------------------------------------------------------------------------
  wire [31:0] gtwiz_userdata_tx_int;
  reg [31:0] userdata_tx_int;
  assign gtwiz_userdata_tx_int[31:0] = userdata_tx_int;
  
//--------------------------------------------------------------------------------------------------------------------
  (*mark_debug = "true"*)wire [31:0] gtwiz_userdata_rx_int;
  wire [31:0] hb0_gtwiz_userdata_rx_int;
  assign hb0_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[31:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] drpclk_int;
  assign drpclk_int[0:0] = hb_gtwiz_reset_clk_freerun_buf_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtrefclk0_int;
  wire [0:0] ch0_gtrefclk0_int;
  assign gtrefclk0_int[0:0] = ch0_gtrefclk0_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] rx8b10ben_int;
  wire [0:0] ch0_rx8b10ben_int = 1'b1;
  assign rx8b10ben_int[0:0] = ch0_rx8b10ben_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] rxcommadeten_int;
  wire [0:0] ch0_rxcommadeten_int = 1'b1;
  assign rxcommadeten_int[0:0] = ch0_rxcommadeten_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] rxmcommaalignen_int;
  wire [0:0] ch0_rxmcommaalignen_int = 1'b1;
  assign rxmcommaalignen_int[0:0] = ch0_rxmcommaalignen_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] rxpcommaalignen_int;
  wire [0:0] ch0_rxpcommaalignen_int = 1'b1;
  assign rxpcommaalignen_int[0:0] = ch0_rxpcommaalignen_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] tx8b10ben_int;
  wire [0:0] ch0_tx8b10ben_int = 1'b1;
  assign tx8b10ben_int[0:0] = ch0_tx8b10ben_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [15:0] txctrl0_int;
  wire [15:0] ch0_txctrl0_int = 16'b0;
  assign txctrl0_int[15:0] = ch0_txctrl0_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [15:0] txctrl1_int;
  wire [15:0] ch0_txctrl1_int = 16'b0;
  assign txctrl1_int[15:0] = ch0_txctrl1_int;

//--------------------------------------------------------------------------------------------------------------------
  reg [7:0] txctrl2_int;

//--------------------------------------------------------------------------------------------------------------------
  (*mark_debug = "true"*)wire [0:0] gtpowergood_int;
  wire [0:0] ch0_gtpowergood_int;
  assign ch0_gtpowergood_int = gtpowergood_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  (*mark_debug = "true"*)wire [0:0] rxbyteisaligned_int;

//--------------------------------------------------------------------------------------------------------------------
  (*mark_debug = "true"*)wire [0:0] rxbyterealign_int;
  wire [0:0] ch0_rxbyterealign_int;
  assign ch0_rxbyterealign_int = rxbyterealign_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  (*mark_debug = "true"*)wire [0:0] rxcommadet_int;
  wire [0:0] ch0_rxcommadet_int;
  assign ch0_rxcommadet_int = rxcommadet_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [15:0] rxctrl0_int;
  wire [15:0] ch0_rxctrl0_int;
  assign ch0_rxctrl0_int = rxctrl0_int[15:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [15:0] rxctrl1_int;
  wire [15:0] ch0_rxctrl1_int;
  assign ch0_rxctrl1_int = rxctrl1_int[15:0];

//--------------------------------------------------------------------------------------------------------------------
  (*mark_debug = "true"*)wire [7:0] rxctrl2_int;
  wire [7:0] ch0_rxctrl2_int;
  assign ch0_rxctrl2_int = rxctrl2_int[7:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [7:0] rxctrl3_int;
  wire [7:0] ch0_rxctrl3_int;
  assign ch0_rxctrl3_int = rxctrl3_int[7:0];

//--------------------------------------------------------------------------------------------------------------------
  (*mark_debug = "true"*)wire [0:0] rxpmaresetdone_int;
  wire [0:0] ch0_rxpmaresetdone_int;
  assign ch0_rxpmaresetdone_int = rxpmaresetdone_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  (*mark_debug = "true"*)wire [0:0] txpmaresetdone_int;
  wire [0:0] ch0_txpmaresetdone_int;
  assign ch0_txpmaresetdone_int = txpmaresetdone_int[0:0];

    // Globally buffer the free-running input clock
  wire hb_gtwiz_reset_clk_freerun_buf_int;

  BUFG bufg_clk_freerun_inst (
    .I (fclk),
    .O (hb_gtwiz_reset_clk_freerun_buf_int)
  );

  // Instantiate a differential reference clock buffer for each reference clock differential pair in this configuration,
  // and assign the single-ended output of each differential reference clock buffer to the appropriate PLL input signal

  // Differential reference clock buffer for MGTREFCLK0_X0Y0
    wire mgtrefclk0_x0y0_int ;
    IBUFDS_GTE4 #(
    .REFCLK_EN_TX_PATH  (1'b0),
    .REFCLK_HROW_CK_SEL (2'b00),
    .REFCLK_ICNTL_RX    (2'b00)
  ) IBUFDS_GTE4_MGTREFCLK1_X0Y2_INST (
    .I     (pclk),
    .IB    (nclk),
    .CEB   (1'b0),
    .O     (mgtrefclk0_x0y0_int),
    .ODIV2 ()
  );

 assign ch0_gtrefclk0_int = mgtrefclk0_x0y0_int;

assign gty_rxusrclk = gtwiz_userclk_rx_usrclk2_int;
assign gty_txusrclk = gtwiz_userclk_tx_usrclk2_int;

  wire [0:0] gtpowergood_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  gtwizard_ultrascale_0_example_bit_synchronizer bit_synchronizer_vio_gtpowergood_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtpowergood_int[0]),
    .o_out  (gtpowergood_vio_sync[0])
  );

  // Synchronize txpmaresetdone into the free-running clock domain for VIO usage
  wire [0:0] txpmaresetdone_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  gtwizard_ultrascale_0_example_bit_synchronizer bit_synchronizer_vio_txpmaresetdone_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (txpmaresetdone_int[0]),
    .o_out  (txpmaresetdone_vio_sync[0])
  );

  // Synchronize rxpmaresetdone into the free-running clock domain for VIO usage
  wire [0:0] rxpmaresetdone_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  gtwizard_ultrascale_0_example_bit_synchronizer bit_synchronizer_vio_rxpmaresetdone_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (rxpmaresetdone_int[0]),
    .o_out  (rxpmaresetdone_vio_sync[0])
  );

    // Synchronize gtwiz_reset_tx_done into the free-running clock domain for VIO usage
  wire gtwiz_reset_tx_done_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  gtwizard_ultrascale_0_example_bit_synchronizer bit_synchronizer_vio_gtwiz_reset_tx_done_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtwiz_reset_tx_done_int),
    .o_out  (gtwiz_reset_tx_done_vio_sync)
  );

  // Synchronize gtwiz_reset_rx_done into the free-running clock domain for VIO usage
  wire gtwiz_reset_rx_done_vio_sync;

  (* DONT_TOUCH = "TRUE" *)
  gtwizard_ultrascale_0_example_bit_synchronizer bit_synchronizer_vio_gtwiz_reset_rx_done_0_inst (
    .clk_in (hb_gtwiz_reset_clk_freerun_buf_int),
    .i_in   (gtwiz_reset_rx_done_int),
    .o_out  (gtwiz_reset_rx_done_vio_sync)
  );
//----------------------------------------------- gty vio
(*mark_debug = "true"*)logic hb_gtwiz_reset_all_int;
(*mark_debug = "true"*)logic hb_gtwiz_reset_all_init_int;
(*mark_debug = "true"*)logic hb_gtwiz_reset_rx_datapath_int;
(*mark_debug = "true"*)logic hb_gtwiz_reset_all_vio_int;
(*mark_debug = "true"*)logic init_done_int;
(*mark_debug = "true"*)logic [3:0] init_retry_ctr_int;
(*mark_debug = "true"*)logic hb0_gtwiz_reset_tx_pll_and_datapath_int;
(*mark_debug = "true"*)logic hb0_gtwiz_reset_tx_datapath_int;
(*mark_debug = "true"*)logic hb_gtwiz_reset_rx_pll_and_datapath_vio_int;
(*mark_debug = "true"*)logic hb_gtwiz_reset_rx_datapath_vio_int;
(*mark_debug = "true"*)logic hb_gtwiz_reset_rx_datapath_init_int;
logic link_down_latched_reset_vio_int;

  gtwizard_ultrascale_0_vio_0 gtwizard_ultrascale_0_vio_0_inst (
    .clk (hb_gtwiz_reset_clk_freerun_buf_int)
    ,.probe_in0 (1'b0)
    ,.probe_in1 (1'b0)
    ,.probe_in2 (init_done_int)
    ,.probe_in3 (init_retry_ctr_int)
    ,.probe_in4 (gtpowergood_vio_sync)
    ,.probe_in5 (txpmaresetdone_vio_sync)
    ,.probe_in6 (rxpmaresetdone_vio_sync)
    ,.probe_in7 (gtwiz_reset_tx_done_vio_sync)
    ,.probe_in8 (gtwiz_reset_rx_done_vio_sync)
    ,.probe_out0 (hb_gtwiz_reset_all_vio_int)
    ,.probe_out1 (hb0_gtwiz_reset_tx_pll_and_datapath_int)
    ,.probe_out2 (hb0_gtwiz_reset_tx_datapath_int)
    ,.probe_out3 (hb_gtwiz_reset_rx_pll_and_datapath_vio_int)
    ,.probe_out4 (hb_gtwiz_reset_rx_datapath_vio_int)
    ,.probe_out5 (link_down_latched_reset_vio_int)
  );

//----------------------------------------------- gty reset
logic hb_gtwiz_reset_all_buf_int;
 IBUF ibuf_hb_gtwiz_reset_all_inst (
    .I (~nrst),
    .O (hb_gtwiz_reset_all_buf_int)
  );

assign hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_buf_int || hb_gtwiz_reset_all_init_int || hb_gtwiz_reset_all_vio_int;
assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath_init_int || hb_gtwiz_reset_rx_datapath_vio_int || gt_rx_rst;

  gtwizard_ultrascale_0_example_init example_init_inst (
    .clk_freerun_in  (hb_gtwiz_reset_clk_freerun_buf_int),
    .reset_all_in    (hb_gtwiz_reset_all_int),
    .tx_init_done_in (gtwiz_reset_tx_done_int),
    .rx_init_done_in (gtwiz_reset_rx_done_int),
    .rx_data_good_in (1'b1),
    .reset_all_out   (hb_gtwiz_reset_all_init_int),
    .reset_rx_out    (hb_gtwiz_reset_rx_datapath_init_int),
    .init_done_out   (init_done_int),
    .retry_ctr_out   (init_retry_ctr_int)
  );

  // ===================================================================================================================
  // USER CLOCKING RESETS
  // ===================================================================================================================

  // The TX user clocking helper block should be held in reset until the clock source of that block is known to be
  // stable. The following assignment is an example of how that stability can be determined, based on the selected TX
  // user clock source. Replace the assignment with the appropriate signal or logic to achieve that behavior as needed.
  assign hb0_gtwiz_userclk_tx_reset_int = ~(&txpmaresetdone_int);

  // The RX user clocking helper block should be held in reset until the clock source of that block is known to be
  // stable. The following assignment is an example of how that stability can be determined, based on the selected RX
  // user clock source. Replace the assignment with the appropriate signal or logic to achieve that behavior as needed.
  assign hb0_gtwiz_userclk_rx_reset_int = ~(&rxpmaresetdone_int);

  always @(posedge gty_txusrclk or negedge nrst) begin
	  if (!nrst)
	  	userdata_tx_int <= 0;
    else if (~gtwiz_reset_tx_done_int) begin
      userdata_tx_int <= 'h0;
    end
	  else if(~m_axis_tvalid_phy) 
	  	userdata_tx_int <= 32'hBCBCBCBC;
	  else
	  	userdata_tx_int <= m_axis_tdata_phy;
  end

  always @(posedge gty_txusrclk or negedge nrst) begin
	  if (!nrst)
	  	txctrl2_int <= 8'hf;
    else if (~gtwiz_reset_tx_done_int) begin
      txctrl2_int <= 8'hf;
    end      
	  else if(~m_axis_tvalid_phy)
	  	txctrl2_int <= 8'hf;
	  else
	  	txctrl2_int <= 0;
  end


  gtwizard_ultrascale_0_example_wrapper example_wrapper_inst (
    .gtyrxn_in                               (gtyrxn)
   ,.gtyrxp_in                               (gtyrxp)
   ,.gtytxn_out                              (gtytxn)
   ,.gtytxp_out                              (gtytxp)

   ,.gtwiz_userclk_tx_reset_in               (gtwiz_userclk_tx_reset_int)
   ,.gtwiz_userclk_tx_srcclk_out             (gtwiz_userclk_tx_srcclk_int)
   ,.gtwiz_userclk_tx_usrclk_out             (gtwiz_userclk_tx_usrclk_int)
   ,.gtwiz_userclk_tx_usrclk2_out            (gtwiz_userclk_tx_usrclk2_int)
   ,.gtwiz_userclk_tx_active_out             (gtwiz_userclk_tx_active_int)

   ,.gtwiz_userclk_rx_reset_in               (gtwiz_userclk_rx_reset_int)
   ,.gtwiz_userclk_rx_srcclk_out             (gtwiz_userclk_rx_srcclk_int)
   ,.gtwiz_userclk_rx_usrclk_out             (gtwiz_userclk_rx_usrclk_int)
   ,.gtwiz_userclk_rx_usrclk2_out            (gtwiz_userclk_rx_usrclk2_int) 
   ,.gtwiz_userclk_rx_active_out             (gtwiz_userclk_rx_active_int)

   ,.gtwiz_reset_clk_freerun_in              ({1{hb_gtwiz_reset_clk_freerun_buf_int}})
   ,.gtwiz_reset_all_in                      ({1{hb_gtwiz_reset_all_int}})
   ,.gtwiz_reset_tx_pll_and_datapath_in      (hb0_gtwiz_reset_tx_pll_and_datapath_int)
   ,.gtwiz_reset_tx_datapath_in              (hb0_gtwiz_reset_tx_datapath_int)
   ,.gtwiz_reset_rx_pll_and_datapath_in ({1{hb_gtwiz_reset_rx_pll_and_datapath_vio_int}})
   ,.gtwiz_reset_rx_datapath_in ({1{hb_gtwiz_reset_rx_datapath_int}})
   ,.gtwiz_reset_rx_cdr_stable_out           (gtwiz_reset_rx_cdr_stable_int)
  
   ,.gtwiz_reset_tx_done_out                 (gtwiz_reset_tx_done_int)
   ,.gtwiz_reset_rx_done_out                 (gtwiz_reset_rx_done_int)

   ,.gtwiz_userdata_tx_in                    (gtwiz_userdata_tx_int)
   ,.gtwiz_userdata_rx_out                   (gtwiz_userdata_rx_int)
   ,.drpclk_in                               (drpclk_int)
   ,.gtrefclk0_in                            (gtrefclk0_int)
   ,.rx8b10ben_in                            (rx8b10ben_int)
   ,.rxcommadeten_in                         (rxcommadeten_int)
   ,.rxmcommaalignen_in                      (rxmcommaalignen_int)
   ,.rxpcommaalignen_in                      (rxpcommaalignen_int)
   ,.tx8b10ben_in                            (tx8b10ben_int)
   ,.txctrl0_in                              (txctrl0_int)
   ,.txctrl1_in                              (txctrl1_int)
   ,.txctrl2_in                              (txctrl2_int)
   ,.gtpowergood_out                         (gtpowergood_int)
   ,.rxbyteisaligned_out                     (rxbyteisaligned_int)
   ,.rxbyterealign_out                       (rxbyterealign_int)
   ,.rxcommadet_out                          (rxcommadet_int)
   ,.rxctrl0_out                             (rxctrl0_int)
   ,.rxctrl1_out                             (rxctrl1_int)
   ,.rxctrl2_out                             (rxctrl2_int)
   ,.rxctrl3_out                             (rxctrl3_int)
   ,.rxpmaresetdone_out                      (rxpmaresetdone_int)
   ,.txpmaresetdone_out                      (txpmaresetdone_int)
);

assign m_axis_tready_phy = gtwiz_reset_tx_done_int;

//---------------- Word Alignment 
(*mark_debug = "true"*)reg [55:0] rx_buf;
(*mark_debug = "true"*)reg [2:0] rx_sum;
(*mark_debug = "true"*)reg [7:0] rxctrl2_ff;

(*mark_debug = "true"*)logic [31:0] s_axis_tdata_rx;
(*mark_debug = "true"*)logic [3:0] s_axis_tkeep_rx;
(*mark_debug = "true"*)logic s_axis_tvalid_rx;
(*mark_debug = "true"*)logic s_axis_tlast_rx;
(*mark_debug = "true"*)logic s_axis_tready_rx;
(*mark_debug = "true"*)logic rx_fifo_full;

logic rx_en;
always @(posedge gty_rxusrclk or negedge nrst) begin
  if (~nrst) begin
    rx_en <= 'h0;
  end
  else if (gtwiz_reset_rx_done_int & rxbyteisaligned_int & ~rxbyterealign_int) begin
    if ((rxctrl2_int == 8'hf) & (gtwiz_userdata_rx_int== 32'hbcbcbcbc)) begin
      rx_en <= 1'b1;
    end

  end
  else rx_en <= 1'b0;
end


always @(posedge gty_rxusrclk or negedge nrst) begin
  if (~nrst) begin
    rx_buf <= 'h0;
    rx_sum <= 'h0;
  end
  else if (rx_en) begin
    if (rxctrl2_int[3:0] == 4'b0000) begin
      rx_buf <= {gtwiz_userdata_rx_int, rx_buf[32+:24]};
      rx_sum <= rx_sum[1:0] + 4;
    end
    else if (rxctrl2_int[3:0] == 4'b0001) begin
      rx_buf <= {gtwiz_userdata_rx_int[31:8], rx_buf[24+:32]};
      rx_sum <= rx_sum[1:0] + 3;
    end    
    else if (rxctrl2_int[3:0] == 4'b1000) begin
      rx_buf <= {gtwiz_userdata_rx_int[23:0], rx_buf[24+:32]};
      rx_sum <= rx_sum[1:0] + 3;
    end        
    else if (rxctrl2_int[3:0] == 4'b0011) begin
      rx_buf <= {gtwiz_userdata_rx_int[31:16], rx_buf[16+:40]};
      rx_sum <= rx_sum[1:0] + 2;
    end    
    else if (rxctrl2_int[3:0] == 4'b1100) begin
      rx_buf <= {gtwiz_userdata_rx_int[15:0], rx_buf[16+:40]};
      rx_sum <= rx_sum[1:0] + 2;
    end        
    else if (rxctrl2_int[3:0] == 4'b0111) begin
      rx_buf <= {gtwiz_userdata_rx_int[31:24], rx_buf[8+:48]};
      rx_sum <= rx_sum[1:0] + 1;
    end  
    else if (rxctrl2_int[3:0] == 4'b1110) begin
      rx_buf <= {gtwiz_userdata_rx_int[7:0], rx_buf[8+:48]};
      rx_sum <= rx_sum[1:0] + 1;
    end   
    else if (rxctrl2_int[3:0] == 4'b1111) begin
      //rx_sum <= rx_sum[1:0] + 0;
      rx_buf <= 'h0;
      rx_sum <= 'h0;
    end                 
  end
end

always @(posedge gty_rxusrclk or negedge nrst) begin
  if (~nrst) begin
    rxctrl2_ff <= 'h0;
  end    
  else if (gtwiz_reset_rx_done_int) begin
    rxctrl2_ff <= rxctrl2_int;       
  end  
end

always @(posedge gty_rxusrclk or negedge nrst) begin
  if (~nrst) begin
    s_axis_tdata_rx <= 'h0;
    s_axis_tvalid_rx <= 'h0;
    s_axis_tlast_rx <= 'h0;
  end    
  else if (~gtwiz_reset_rx_done_int) begin
    s_axis_tdata_rx <= 'h0;
    s_axis_tvalid_rx <= 'h0;
    s_axis_tlast_rx <= 'h0;    
  end
  else begin
    s_axis_tdata_rx <= (rx_sum[1:0] == 3) ? rx_buf[0+:32] :
             (rx_sum[1:0] == 2) ? rx_buf[8+:32] :
             (rx_sum[1:0] == 1) ? rx_buf[16+:32] : 
                                  rx_buf[24+:32] ;  
    s_axis_tvalid_rx <= rx_sum[2] & gtwiz_reset_rx_done_int;   
    s_axis_tlast_rx <= (rxctrl2_ff == 4'b1110) | (rxctrl2_ff == 4'b1100) | (rxctrl2_ff == 4'b1000) |
                 ((rxctrl2_ff == 4'b0000) & (rxctrl2_int == 4'b1111));                                 
  end   
end         

assign s_axis_tkeep_rx = 4'hf;

(*mark_debug = "true"*)logic fifo_rstn;
assign fifo_rstn = gtwiz_reset_rx_done_int & gtwiz_reset_tx_done_int;

axis_data_fifo_32x512 i_gty_rx_fifo (

    .s_axis_aresetn(fifo_rstn),
    .s_axis_aclk(gty_rxusrclk),
    
    .s_axis_tvalid(s_axis_tvalid_rx),
    .s_axis_tready(s_axis_tready_rx),
    .s_axis_tdata(s_axis_tdata_rx),
    .s_axis_tkeep(s_axis_tkeep_rx),
    .s_axis_tlast(s_axis_tlast_rx),
    
    .m_axis_aclk(gty_txusrclk),
    .m_axis_tvalid(m_axis_tvalid_dec),
    .m_axis_tready(m_axis_tready_dec), 
    .m_axis_tkeep(m_axis_tkeep_dec),
    .m_axis_tlast(m_axis_tlast_dec),
    .m_axis_tdata(m_axis_tdata_dec)
    
    //.almost_full (rx_fifo_full)

);

/////////////////////////////////////////////////////////////////////
//  GT reset
/////////////////////////////////////////////////////////////////////
(*mark_debug = "true"*)logic [15:0] rxcommadet_check_cnt;
(*mark_debug = "true"*)logic gt_rx_rst;

always @(posedge hb_gtwiz_reset_clk_freerun_buf_int or negedge nrst) begin
  if (~nrst) begin
    rxcommadet_check_cnt <= 'h0;
  end    
  else if (rxcommadet_int | ~gtwiz_reset_rx_done_int) begin
    rxcommadet_check_cnt <= 'h0;
  end   
  else if (rxcommadet_check_cnt == 16'd9999) begin
    rxcommadet_check_cnt <= 'h0;
  end
  else begin
    rxcommadet_check_cnt <= rxcommadet_check_cnt + 1'b1;
  end
end   

assign gt_rx_rst = (rxcommadet_check_cnt > 16'd9000);

endmodule
