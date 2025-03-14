module gty_top_tx(nrst, enc_sw_rst, clk, pclk, nclk, fclk, init_l0, init_l1, dmax, din_valid_l0, din_valid_l1, din_l0, 
	din_l1, din_ready_l0, din_ready_l1, gtytxp, gtytxn,
	// userdata debug
	gty_wr_en_b0_l0_ila,
	gty_wr_en_b1_l0_ila,
	gty_wr_cnt_l0_ila,
	gty_wr_en_b0_l1_ila,
	gty_wr_en_b1_l1_ila,
	gty_wr_cnt_l1_ila,
	gty_alm_full_b0_l0_ila,
	gty_alm_full_b1_l0_ila,
	gty_alm_full_b0_l1_ila,
	gty_alm_full_b1_l1_ila,
	gty_empty_b0_l0_ila,
	gty_empty_b1_l0_ila,
	gty_empty_b0_l1_ila,
	gty_empty_b1_l1_ila,
	gty_wr_data_count_b0_l0_ila,
	gty_wr_data_count_b1_l0_ila,
	gty_wr_data_count_b0_l1_ila,
	gty_wr_data_count_b1_l1_ila,
	gty_rd_data_count_b0_l0_ila,
	gty_rd_data_count_b1_l0_ila,
	gty_rd_data_count_b0_l1_ila,
	gty_rd_data_count_b1_l1_ila,
	gty_userdata_tx_int_ila,
	dout_valid_ILA,
	dout_ILA,
	txpmaresetdone_int_ILA,
	vio_gtwiz_reset_all_int,
	vio_hb_gtwiz_reset_all_int,
	
	// for frequency counter
	axi_clk,
	gty_refclk_freq,
	gty_refclk_jitter
);
	

  input nrst;
  input enc_sw_rst;
  input clk;
  input pclk;
  input nclk;
  input fclk;
  input init_l0;
  input init_l1;
  input [31:0] dmax;
  input din_valid_l0;
  input [127:0] din_l0;
  output din_ready_l0;
  input din_valid_l1;
  input [127:0] din_l1;
  output din_ready_l1;
  output gtytxp;
  output gtytxn;
  output gty_wr_en_b0_l0_ila;
  output gty_wr_en_b1_l0_ila;
  output [7:0] gty_wr_cnt_l0_ila;
  output gty_wr_en_b0_l1_ila;
  output gty_wr_en_b1_l1_ila;
  output [7:0] gty_wr_cnt_l1_ila;
  output gty_alm_full_b0_l0_ila;
  output gty_alm_full_b1_l0_ila;
  output gty_alm_full_b0_l1_ila;
  output gty_alm_full_b1_l1_ila;
  output gty_empty_b0_l0_ila;
  output gty_empty_b1_l0_ila;
  output gty_empty_b0_l1_ila;
  output gty_empty_b1_l1_ila;
  output [7:0] gty_wr_data_count_b0_l0_ila;
  output [7:0] gty_wr_data_count_b1_l0_ila;
  output [7:0] gty_wr_data_count_b0_l1_ila;
  output [7:0] gty_wr_data_count_b1_l1_ila;
  output [9:0] gty_rd_data_count_b0_l0_ila;
  output [9:0] gty_rd_data_count_b1_l0_ila;
  output [9:0] gty_rd_data_count_b0_l1_ila;
  output [9:0] gty_rd_data_count_b1_l1_ila;
  output [31:0] gty_userdata_tx_int_ila;
  output wire dout_valid_ILA;
  output wire [31:0] dout_ILA;
  output txpmaresetdone_int_ILA;
  // for frequency counter
  input  axi_clk;
  output wire [31:0] gty_refclk_freq;
  output wire [31:0] gty_refclk_jitter;

  wire [31:0] gty_userdata_tx_l0_int;
  wire [31:0] gty_userdata_tx_l0_b0_int;
  wire [31:0] gty_userdata_tx_l0_b1_int;
  wire [31:0] gty_userdata_tx_l1_int;
  wire [31:0] gty_userdata_tx_l1_b0_int;
  wire [31:0] gty_userdata_tx_l1_b1_int;
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
  wire [0:0] hb0_gtwiz_userclk_tx_usrclk2_int;
  assign hb0_gtwiz_userclk_tx_usrclk2_int = gtwiz_userclk_tx_usrclk2_int[0:0];

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
  wire [0:0] gtwiz_reset_all_int;
  wire [0:0] hb0_gtwiz_reset_all_int = 1'b0;
  assign gtwiz_reset_all_int[0:0] = hb0_gtwiz_reset_all_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_tx_pll_and_datapath_int;
  wire [0:0] hb0_gtwiz_reset_tx_pll_and_datapath_int = 1'b0;
  assign gtwiz_reset_tx_pll_and_datapath_int[0:0] = hb0_gtwiz_reset_tx_pll_and_datapath_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_tx_datapath_int;
  wire [0:0] hb0_gtwiz_reset_tx_datapath_int = 1'b0;
  assign gtwiz_reset_tx_datapath_int[0:0] = hb0_gtwiz_reset_tx_datapath_int;

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
  wire [0:0] gtwiz_reset_tx_done_int;
  wire [0:0] hb0_gtwiz_reset_tx_done_int;
  assign hb0_gtwiz_reset_tx_done_int = gtwiz_reset_tx_done_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtwiz_reset_rx_done_int;
  wire [0:0] hb0_gtwiz_reset_rx_done_int;
  assign hb0_gtwiz_reset_rx_done_int = gtwiz_reset_rx_done_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [31:0] gtwiz_userdata_tx_int;
  //wire [31:0] userdata_tx_int;
  reg [31:0] userdata_tx_int;
  assign gtwiz_userdata_tx_int[31:0] = userdata_tx_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [31:0] gtwiz_userdata_rx_int;
  wire [31:0] hb0_gtwiz_userdata_rx_int;
  assign hb0_gtwiz_userdata_rx_int = gtwiz_userdata_rx_int[31:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] drpclk_int;
  wire [0:0] ch0_drpclk_int;
  assign drpclk_int[0:0] = ch0_drpclk_int;

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
  wire [15:0] ch0_txctrl0_int;
  assign txctrl0_int[15:0] = ch0_txctrl0_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [15:0] txctrl1_int;
  wire [15:0] ch0_txctrl1_int;
  assign txctrl1_int[15:0] = ch0_txctrl1_int;

//--------------------------------------------------------------------------------------------------------------------
  //wire [7:0] txctrl2_int;
  reg [7:0] txctrl2_int;
  //wire [7:0] ch0_txctrl2_int ;
  wire [7:0] ch0_txctrl2_int = 8'b0000_1111;
  //assign txctrl2_int[7:0] = ch0_txctrl2_int;

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] gtpowergood_int;
  wire [0:0] ch0_gtpowergood_int;
  assign ch0_gtpowergood_int = gtpowergood_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] rxbyteisaligned_int;
  wire [0:0] ch0_rxbyteisaligned_int;
  assign ch0_rxbyteisaligned_int = rxbyteisaligned_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] rxbyterealign_int;
  wire [0:0] ch0_rxbyterealign_int;
  assign ch0_rxbyterealign_int = rxbyterealign_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] rxcommadet_int;
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
  wire [7:0] rxctrl2_int;
  wire [7:0] ch0_rxctrl2_int;
  assign ch0_rxctrl2_int = rxctrl2_int[7:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [7:0] rxctrl3_int;
  wire [7:0] ch0_rxctrl3_int;
  assign ch0_rxctrl3_int = rxctrl3_int[7:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] rxpmaresetdone_int;
  wire [0:0] ch0_rxpmaresetdone_int;
  assign ch0_rxpmaresetdone_int = rxpmaresetdone_int[0:0];

//--------------------------------------------------------------------------------------------------------------------
  wire [0:0] txpmaresetdone_int;
  wire [0:0] ch0_txpmaresetdone_int;
  assign ch0_txpmaresetdone_int = txpmaresetdone_int[0:0];

    // Globally buffer the free-running input clock
  wire hb_gtwiz_reset_clk_freerun_buf_int;

  assign hb_gtwiz_reset_clk_freerun_in = fclk;
  BUFG bufg_clk_freerun_inst (
    .I (hb_gtwiz_reset_clk_freerun_in),
    .O (hb_gtwiz_reset_clk_freerun_buf_int)
  );

  // For gty core configurations which utilize the transceiver channel CPLL, the drpclk_in port must be driven by
  // the free-running clock at the exact frequency specified during core customization, for reliable bring-up
  assign ch0_drpclk_int = hb_gtwiz_reset_clk_freerun_buf_int;

  // Instantiate a differential reference clock buffer for each reference clock differential pair in this configuration,
  // and assign the single-ended output of each differential reference clock buffer to the appropriate PLL input signal

  // Differential reference clock buffer for MGTREFCLK0_X0Y0
  wire mgtrefclk0_x0y0_int ;
  wire mgtrefclk0_x0y0_int_odiv2;
    IBUFDS_GTE4 #(
    .REFCLK_EN_TX_PATH  (1'b0),
    .REFCLK_HROW_CK_SEL (2'b00),
    .REFCLK_ICNTL_RX    (2'b00)
  ) IBUFDS_GTE4_MGTREFCLK1_X0Y2_INST (
    .I     (pclk),
    .IB    (nclk),
    .CEB   (1'b0),
    .O     (mgtrefclk0_x0y0_int),
    .ODIV2 (mgtrefclk0_x0y0_int_odiv2)
  );

  wire hb_gtwiz_reset_all_in = ~nrst;
  wire hb_gtwiz_reset_all_int ;
  wire hb_gtwiz_reset_all_init_int = 0 ;
  wire hb_gtwiz_reset_all_vio_int = 0 ;


 assign ch0_gtrefclk0_int = mgtrefclk0_x0y0_int;

 IBUF ibuf_hb_gtwiz_reset_all_inst (
    .I (hb_gtwiz_reset_all_in),
    .O (hb_gtwiz_reset_all_buf_int)
  );

  assign hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_buf_int || hb_gtwiz_reset_all_init_int || hb_gtwiz_reset_all_vio_int;

  wire hb_gtwiz_reset_rx_pll_and_datapath_int = 1'b0;
  wire hb_gtwiz_reset_rx_datapath_int;

  // Declare signals which connect the VIO instance to the initialization module for debug purposes
  wire       init_done_int;
  wire [3:0] init_retry_ctr_int;

  // Combine the receiver reset signals form the initialization module and the VIO to drive the appropriate reset
  // controller helper block reset input
  wire hb_gtwiz_reset_rx_pll_and_datapath_vio_int = 0;
  wire hb_gtwiz_reset_rx_datapath_vio_int = 0;
  wire hb_gtwiz_reset_rx_datapath_init_int = 0;

  //assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath_init_int || hb_gtwiz_reset_rx_datapath_vio_int;

  /*
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
  */

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

  wire st_empty;
  wire [31:0] userdata_tx_fifo;
  wire [31:0] userdata_tx_tmp = 32'hBCBCBCBC;

  reg  fifo_rst_1st;

  always @(posedge clk or negedge nrst)
  begin
	  if (!nrst)
	     fifo_rst_1st <= 0;
	  else if (enc_sw_rst)
	     fifo_rst_1st <= 0;
          else if (txpmaresetdone_int)
	     fifo_rst_1st <= 1;
  end

  reg  fifo_rst_2nd;
  always @(posedge clk or negedge nrst)
  begin
	  if (!nrst)
	     fifo_rst_2nd <= 0;
	  else if (enc_sw_rst)
	     fifo_rst_2nd <= 0;
          else if (fifo_rst_1st & txpmaresetdone_int)
	     fifo_rst_2nd <= 1;
  end
		  
  reg  fifo_rst;
  always @(posedge clk or negedge nrst)
  begin
	  if (!nrst)
	     fifo_rst <= 1;
	  else if (enc_sw_rst)
	     fifo_rst <= 1;
          else if (fifo_rst_2nd & txpmaresetdone_int)
	     fifo_rst <= 0;
  end

  wire dout_valid;
  wire din_valid_int_l0 = din_ready_l0 & din_valid_l0;
  wire din_valid_int_l1 = din_ready_l1 & din_valid_l1;
  wire rd_clk = hb0_gtwiz_userclk_tx_usrclk2_int;



assign dout_valid_ILA = dout_valid;
assign dout_ILA = userdata_tx_fifo;

tx_burst_wrap U_TX_BURST (
  .enc_sw_rst(enc_sw_rst),
  .frst(fifo_rst),
  .init_l0(init_l0),
  .init_l1(init_l1),
  .dmax(dmax),
  .wclk(clk),    // input wire clka
  .rclk(rd_clk),    // input wire clkb
  .din_valid_l0(din_valid_int_l0),      // input wire [0 : 0] wea
  .din_l0(din_l0),    // input wire [127 : 0] dina
  .din_ready_l0(din_ready_l0),
  .din_valid_l1(din_valid_int_l1),      // input wire [0 : 0] wea
  .din_l1(din_l1),    // input wire [127 : 0] dina
  .din_ready_l1(din_ready_l1),
  .dout(userdata_tx_fifo),  // output wire [31 : 0] doutb
  .dout_valid(dout_valid),

  // debug ports
  .wr_en_b0_l0_ila(gty_wr_en_b0_l0_ila),
  .rd_en_b0_l0_ila(),
  .wr_en_b1_l0_ila(gty_wr_en_b1_l0_ila),
  .rd_en_b1_l0_ila(),
  .wr_cnt_l0_ila(gty_wr_cnt_l0_ila),
  .rd_cnt_l0_ila(),
  .dout_b0_l0_ila(),
  .full_b0_l0_ila(),
  .alm_full_b0_l0_ila(gty_alm_full_b0_l0_ila),
  .empty_b0_l0_ila(gty_empty_b0_l0_ila),
  .wr_data_count_b0_l0_ila(gty_wr_data_count_b0_l0_ila),
  .rd_data_count_b0_l0_ila(gty_rd_data_count_b0_l0_ila),
  .alm_full_b1_l0_ila(gty_alm_full_b1_l0_ila),
  .empty_b1_l0_ila(gty_empty_b1_l0_ila),
  .wr_data_count_b1_l0_ila(gty_wr_data_count_b1_l0_ila),
  .rd_data_count_b1_l0_ila(gty_rd_data_count_b1_l0_ila),

  .wr_en_b0_l1_ila(gty_wr_en_b0_l1_ila),
  .rd_en_b0_l1_ila(),
  .wr_en_b1_l1_ila(gty_wr_en_b1_l1_ila),
  .rd_en_b1_l1_ila(),
  .wr_cnt_l1_ila(gty_wr_cnt_l1_ila),
  .rd_cnt_l1_ila(),
  .dout_b0_l1_ila(),
  .full_b0_l1_ila(),
  .alm_full_b0_l1_ila(gty_alm_full_b0_l1_ila),
  .empty_b0_l1_ila(gty_empty_b0_l1_ila),
  .wr_data_count_b0_l1_ila(gty_wr_data_count_b0_l1_ila),
  .rd_data_count_b0_l1_ila(gty_rd_data_count_b0_l1_ila),
  .alm_full_b1_l1_ila(gty_alm_full_b1_l1_ila),
  .empty_b1_l1_ila(gty_empty_b1_l1_ila),
  .wr_data_count_b1_l1_ila(gty_wr_data_count_b1_l1_ila),
  .rd_data_count_b1_l1_ila(gty_rd_data_count_b1_l1_ila),

  .rbank_sel_d_l0_ila(),
  .full_b0_cdc_l0_ila(),
  .ext_full_b0_ila(),
  .comma_cnt_l0_ila(),
  .rbank_sel_d_l1_ila(),
  .full_b0_cdc_l1_ila(),
  .lane_ren_ila(),
  .comma_cnt_l1_ila()
);


  reg st_empty_d;

  always @(posedge rd_clk or negedge nrst)
  begin
	  if (!nrst)
	      st_empty_d <= 1;
          else 
	      //st_empty_d <= st_empty;
	      st_empty_d <= ~dout_valid;
  end

  reg st_empty_2d;

  always @(posedge rd_clk or negedge nrst)
  begin
	  if (!nrst)
	      st_empty_2d <= 1;
          else 
	      st_empty_2d <= st_empty_d;
  end

  reg st_init;
  always @(posedge rd_clk or negedge nrst)
  begin
	  if (!nrst)
	      st_init <= 0;
      	  else
	      st_init <= 1;
  end

  reg st_init_cdc;
  always @(posedge rd_clk or negedge nrst)
  begin
	  if (!nrst)
	      st_init_cdc <= 0;
          //else if (st_empty && !st_empty_d)
          else 
	      st_init_cdc <= st_init;
  end

  reg [13:0]  st_init_cnt;
  always @(posedge rd_clk or negedge nrst)
  begin
	  if (!nrst)
	      st_init_cnt <= 0;
          else if (st_init_cdc)
	      st_init_cnt <= st_init_cnt + 1;
  end

  reg st_init2;
  always @(posedge rd_clk or negedge nrst)
  begin
	  if (!nrst)
	      st_init2 <= 0;
          else if (st_init_cnt == 'd10)
	      st_init2 <= 1;
  end

  wire [31:0] hb0_gtwiz_userdata_tx_int;
  gtwizard_ultrascale_0_example_stimulus_8b10b example_stimulus_inst0 (
   .gtwiz_reset_all_in          (hb_gtwiz_reset_all_int || ~hb0_gtwiz_reset_rx_done_int ),
   .gtwiz_userclk_tx_usrclk2_in (hb0_gtwiz_userclk_tx_usrclk2_int),
   .gtwiz_userclk_tx_active_in  (hb0_gtwiz_userclk_tx_active_int),
   .txctrl0_out                 (ch0_txctrl0_int),
   .txctrl1_out                 (ch0_txctrl1_int),
   //.txctrl2_out                 (ch0_txctrl2_int),
   .txctrl2_out                 (),
   .txdata_out                  (hb0_gtwiz_userdata_tx_int)
  );

  //assign userdata_tx_int = (!st_init2 | ~dout_valid) ? userdata_tx_tmp : userdata_tx_fifo; // 2023/12/19
  //assign txctrl2_int[7:0] = (!st_init2 | ~dout_valid) ? ch0_txctrl2_int : 8'b0000_0000;
  always @(posedge rd_clk or negedge nrst)
  begin
	  if (!nrst)
	  	userdata_tx_int <= 0;
	  else if(!st_init2 | ~dout_valid)
	  	userdata_tx_int <= userdata_tx_tmp;
	  else
	  	userdata_tx_int <= userdata_tx_fifo;
  end

  always @(posedge rd_clk or negedge nrst)
  begin
	  if (!nrst)
	  	txctrl2_int <= 0;
	  else if(!st_init2 | ~dout_valid)
	  	txctrl2_int <= ch0_txctrl2_int;
	  else
	  	txctrl2_int <= 0;
  end
  
  assign txpmaresetdone_int_ILA = txpmaresetdone_int;

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
   ,.gtwiz_reset_tx_pll_and_datapath_in      (gtwiz_reset_tx_pll_and_datapath_int)
   ,.gtwiz_reset_tx_datapath_in              (gtwiz_reset_tx_datapath_int)
   ,.gtwiz_reset_rx_pll_and_datapath_in      ({1{1'b0}})
   //,.gtwiz_reset_rx_datapath_in              ({1{1'b0}})
   ,.gtwiz_reset_rx_datapath_in              (gtwiz_reset_tx_datapath_int)
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

 assign gty_userdata_tx_int_ila = userdata_tx_int;
 (*mark_debug ="true"*) wire [31:0] userdata_tx_int_dbg;
  assign userdata_tx_int_dbg = userdata_tx_int;


  (*mark_debug ="true"*) wire nrst_dbg;
  assign nrst_dbg = nrst;
  (*mark_debug ="true"*) wire txpmaresetdone_int_dbg;
  assign txpmaresetdone_int_dbg = txpmaresetdone_int[0:0];

  input wire vio_gtwiz_reset_all_int;
  assign hb_gtwiz_reset_all_vio_int = vio_gtwiz_reset_all_int;
  output wire vio_hb_gtwiz_reset_all_int;
  assign vio_hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_int;


//---- mgt reference clk counter

wire gty_refclk_odiv2;
BUFG_GT #() BUFG_GT_inst (
   .O(gty_refclk_odiv2),             // 1-bit output: Buffer
   .CE(1),           // 1-bit input: Buffer enable
   .CEMASK(0),   // 1-bit input: CE Mask
   .CLR(0),         // 1-bit input: Asynchronous clear
   .CLRMASK(0), // 1-bit input: CLR Mask
   .DIV(0),         // 3-bit input: Dynamic divide Value
   .I(mgtrefclk0_x0y0_int_odiv2)              // 1-bit input: Buffer
);

wire tgl_1sec;
wire tick_1sec;
clk_freq	#(100*1000*1000)	gty_refclk_freq_0	(axi_clk,	gty_refclk_odiv2,	gty_refclk_freq,	tgl_1sec, 	tick_1sec	,!nrst , gty_refclk_jitter);

endmodule
