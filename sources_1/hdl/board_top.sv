`include "define.vh"
module board_top #(
	parameter	BUILD_DATE		=	32'h20241231,
	parameter	SIMULATION		=	0,
	parameter	CH_NUM			=	32,			//	vx1	channel	number
	parameter	DW				=	32,			//	vx1	link	data	width
	parameter   STRM_DW         =   144, // Added on 2023/12/15 by jihan
    parameter   DEC_STRM_DW     =   128, // Added on 2023/12/16 by jihan
	parameter	CW				=	16,
	parameter	RX_RVS			=	1,
//	parameter	VIDEO_TIMING		=	"4K_60")
	parameter	VIDEO_TIMING		=	"4K")
//	parameter	VIDEO_TIMING		=	"8K")
(	
    input	FPGA_50MHz	,
    input   gty_clk_p , // Added on 2023/12/22 by jihan
    input   gty_clk_n , // Added on 2023/12/22 by jihan
    output	UART0_TXD	,	
    input	UART0_RXD,
    output	FAN_ON	,
    output	reg	[2:0]	LED,

    output	PLL1_CSn	,	
    output	PLL1_SCLK	,	
    output	PLL1_SDIO	,
    input	PLL1_SDO	,
    output	PLL1_RSTn	,	
    output	PLL1_PDNn	,	
    output	PLL1_OEn	,	
    output	PLL1_SYNCn	,
    input	PLL1_LOCK	,

    output	PLL2_CSn	,	
    output	PLL2_SCLK	,	
    output	PLL2_SDIO	,
    input	PLL2_SDO	,
    output	PLL2_RSTn	,	
    output	PLL2_PDNn	,	
    output	PLL2_OEn	,	
    output	PLL2_SYNCn	,
    input	PLL2_LOCK	,

    input	[CH_NUM-1:0]	gthrxn_in	,	gthrxp_in	,
    output	[CH_NUM-1:0]	gthtxn_out,	gthtxp_out	,

    input	mgtrefclk0_226_p,	mgtrefclk0_226_n	,
    input	mgtrefclk0_230_p,	mgtrefclk0_230_n	,
    output	REFCLK1_P,	REFCLK1_N,
    output	REFCLK2_P,	REFCLK2_N,
    output	reg	RX_LOCKN,	RX_HPDN	,
    input	TX_LOCKN	,	TX_HPDN,

    inout	[1:3]	RX_RSVD,	//	[1:2]	PCLK	FREQ	MODE	CONFIG

    input	[1:0]	RX_DATA_FORMAT,
    input	[1:5]	RX_OPTION,
    input			RX_RO_BYPASS,
    input			RX_VX1_MODE,
    input			RX_QSMEN,
    input			RX_WP_IN,
    input			RX_3D_EN,
    input			RX_AC_DET,

    input	[1:5]	TX_OPTION,
    input			TX_RO_BYPASS,
    input			TX_VX1_MODE,
    output			TX_QSMEN,
    input			TX_WP_IN,
    input			TX_3D_EN,
    output			TX_AC_DET,
    inout	[1:3]	TX_RSVD,

    output	[1:0]	TX_DATA_FORMAT, 

    //	UNSUED	PIN	INPUT	MODE	CONFIG
    input	RX_C_SDA,
    input	RX_C_SCL,
    input	RX_V_SDA,
    input	RX_V_SCL,
    input	TX_C_SDA,
    input	TX_C_SCL,
    input	TX_V_SDA,
    input	TX_V_SCL,
    input	RX_RF_DONE,

    //	TO	RX(PG)	STATUS	OUT	(DIP	SW	OFF)
    input	RX_RS_DONE,
    input	RX_ERR_DET,    

`ifdef GTY
    input         gty_rxn_in,
    input         gty_rxp_in,
    output wire   gty_txn_out,
    output wire   gty_txp_out,
`else
    output wire [31:0] m_axis_tdata_phy,
    output wire [3:0] m_axis_tkeep_phy,
    output wire m_axis_tvalid_phy,
    input wire m_axis_tready_phy,
    output wire m_axis_tlast_phy,

    input wire [31:0] s_axis_tdata_phy,
    input wire [3:0] s_axis_tkeep_phy,
    input wire s_axis_tvalid_phy,
    output wire s_axis_tready_phy,
    input wire s_axis_tlast_phy,      
`endif
    output wire   tmc_enc_init_out,

    input bclk_in, // input, serial clock
    input lrclk_in, // input, word select
    input sdata_in // input, serial data     
	);

//	*******	ACTIVE	LANE	NUMBER	CONFIG	***********
localparam	AL	=	VIDEO_TIMING	==	"4K_60"	?	8:
					VIDEO_TIMING	==	"4K"	?	16:
					32;

//	******	PCLK	FREQ	MODE	CONFIG	***************
//BOARD	DIP	SW2	[1:2]	-->	FPGA	RX_RSVD[1:2]	-->	SI5386	PLL	CONFIG
//MODE		RX_RSVD[1:2]	:	PCLK_FREQ_MODE;
//	0		00	[OFF:OFF]	:	PCLK	74.25	Mhz	(PLL	MGT	REF	CLK	145.50	Mhz);
//	1		01	[OFF:ON	]	:	PCLK	84.24	Mhz	(PLL	MGT	REF	CLK	168.48	Mhz);
//	2		10	[ON	:OFF]	:	PCLK	89.10	Mhz	(PLL	MGT	REF	CLK	178.20	Mhz);
//	3		11	[0N	:ON	]	:	PCLK	84.94	Mhz	(PLL	MGT	REF	CLK	169.88	Mhz);

assign	TX_DATA_FORMAT[0]	=	RX_DATA_FORMAT[0]	?	1	:	1'bZ;
assign	TX_DATA_FORMAT[1]	=	RX_DATA_FORMAT[1]	?	1	:	1'bZ;
//assign  TX_OPTION[1]		=   RX_OPTION[1]		?   1   :   1'bZ;
//assign  TX_OPTION[2]		=   RX_OPTION[2]		?   1   :   1'bZ;	//AGC
//assign  TX_WP_IN			=   RX_WP_IN			?	1	:	1'bZ;
//assign	TX_3D_EN			=	RX_3D_EN			?	1	:	1'bZ;
assign  RX_RSVD[3]			=	TX_RSVD[3]			?	1	:	1'bZ;  //EVDD_DET ?? INPUT OR OUTPUT
assign  TX_AC_DET			= 	RX_AC_DET			?   1   :   1'bZ;
assign	TX_QSMEN			=	RX_QSMEN			?   1   :   1'bZ;
//assign  TX_RO_BYPASS        =   RX_RO_BYPASS        ?   1   :   1'bZ;
//assign  TX_VX1_MODE         =   RX_VX1_MODE         ?	1	:	1'bZ;

wire clk_168_48;
wire nclk_168_48; // Added on 2023/12/14 by jihan
wire clk_84_24;
wire clk_42_12;
wire clk_42_12_p;
wire clk_21_06;
wire pos_84_24, sel_phase; // Added on 2023/12/06 by jihan

//
wire [575:0] vx1_tx_data_1; // vx1_debug 576 bit output

wire [127:0] str_out      ;
wire [127:0] str_out_f      ; //Added on 2024/02/06 by dykim
wire [127:0] str_out_s      ; //Added on 2024/02/06 by dykim
wire [127:0] str_out_dec_f,str_out_dec_s;

// Modified *********************************
// gty signals
    wire		gty_str_valid_f;
    wire		gty_str_valid_s;
    wire  [127:0]	gty_str_out_f;
    wire  [127:0]	gty_str_out_s;
    wire             	str_ready_f    ;
    wire             	str_ready_s    ;

// time stamp
    wire  [31:0]	time_stamp_f_ILA;
    wire  [31:0]	time_stamp_s_ILA;
    wire  [31:0]	time_stamp_vs_ILA;

// gty userdata tx
    wire  [31:0]	gty_userdata_tx_ila;
    wire  [31:0]	gty_userdata_tx_l0;
    wire  [31:0]	gty_userdata_tx_l0_b0;
    wire  [31:0]	gty_userdata_tx_l0_b1;
    wire  [31:0]	gty_userdata_tx_l1;
    wire  [31:0]	gty_userdata_tx_l1_b0;
    wire  [31:0]	gty_userdata_tx_l1_b1;
 
    wire  [7:0]		gty_wr_cnt_mem_ila;
    wire  [9:0]		gty_rd_cnt_mem_ila;
    wire  [127:0]	gty_din_int_rev_ila;
    wire  		gty_wr_en_b0_l0_ila;
    wire  		gty_wr_en_b1_l0_ila;
    wire  		gty_wr_en_b0_l1_ila;
    wire  		gty_wr_en_b1_l1_ila;
    wire  [7:0]		gty_wr_cnt_l0_ila;
    wire  [7:0]		gty_wr_cnt_l1_ila;
    wire            gty_txpmaresetdone_int_ILA;
// Encoder data in, out count debug
    wire  [31:0]	enc_in_cnt_s_ila;
    wire  [31:0]	enc_in_cnt_f_ila;
    wire  [31:0]	enc_out_cnt_s_ila;
    wire  [31:0]	enc_out_cnt_f_ila;
    wire  [12:0]        enc_vcnt_s_ila;
    wire  [12:0]        enc_vcnt_f_ila;

// line sel debugger
    wire  		line_sel_de_line_ila;
    wire		line_sel_vs_1d_ila;
    wire		line_sel_hs_1d_ila;
    wire [575:0]    	line_sel_vx1_data_ila;
    wire [578:0]	line_sel_data_in_ila;
    wire [11:0]		line_sel_DE_cnt_2d_ila;
    wire [10:0]		line_sel_cnt1920_2d_ila;
    wire 		line_sel_de_out_ila;
    wire 		line_sel_op_en_ila;
    wire [9:0]		line_sel_address_12_ila;
    wire [9:0]		line_sel_address_34_ila;
    wire [290:0]	line_sel_data_in1_ila;
    wire [290:0]	line_sel_data_out1_ila;
    wire 		line_sel_we1_ila;

    reg [31:0]		fail_cnt;
    reg [31:0]		frame_cnt;
    wire [31:0] set_tgt_size_ila;

    wire [15:0] 	line_num_int;
    wire		enc_sw_rst_ILA;
    wire [288:0] 	rpt_ts_ILA;
    reg [31:0]		int_f_cnt;
    reg [31:0]		int_s_cnt;

    wire		gty_alm_full_b0_l0_ila;
    wire		gty_alm_full_b1_l0_ila;
    wire		gty_alm_full_b0_l1_ila;
    wire		gty_alm_full_b1_l1_ila;
    wire		gty_empty_b0_l0_ila;
    wire		gty_empty_b1_l0_ila;
    wire		gty_empty_b0_l1_ila;
    wire		gty_empty_b1_l1_ila;
    wire [7:0]		gty_wr_data_count_b0_l0_ila;
    wire [7:0]		gty_wr_data_count_b1_l0_ila;
    wire [7:0]		gty_wr_data_count_b0_l1_ila;
    wire [7:0]		gty_wr_data_count_b1_l1_ila;
    wire [9:0]		gty_rd_data_count_b0_l0_ila;
    wire [9:0]		gty_rd_data_count_b1_l0_ila;
    wire [9:0]		gty_rd_data_count_b0_l1_ila;
    wire [9:0]		gty_rd_data_count_b1_l1_ila;
    wire [31:0]     gty_userdata_tx_int_ila;
    wire            dout_valid_ILA;
    wire [31:0]     dout_ILA;
    wire		param_change_ILA;

    //wire 		m_axis_video_tvalid		; // Used for 1 codec
    wire 		m_axis_video_tvalid_f		; // Added on 2024/01/26 by KDY
    wire 		m_axis_video_tvalid_s		; // Added on 2024/01/26 by KDY

    wire 		m_axis_video_tuser_f		; // SOF for ENC_0
    wire 		m_axis_video_tuser_s		; // SOF for ENC_1

    wire 		m_axis_video_tlast_f		; // EOL for ENC_0
    wire 		m_axis_video_tlast_s		; // EOL for ENC_1

    //wire [143:0] 	m_axis_video_tdata		; // Used for 1 codec : Modified on 2023/12/02 by jihan
    wire [143:0] 	m_axis_video_tdata_f		; // Added on 2024/01/24 by KDY
    wire [143:0] 	m_axis_video_tdata_s		; // Added on 2024/01/24 by KDY

    wire		m_axis_video_tready_f		; // Slave ready signals for ENC_0
    wire		m_axis_video_tready_s		; // Slave ready signals for ENC_1
    
wire	[15:0]	M_AVALON_0_address;
wire			M_AVALON_0_read;
wire	[31:0]	M_AVALON_0_readdata;
wire			M_AVALON_0_readdatavalid;
wire			M_AVALON_0_waitrequest;
wire			M_AVALON_0_write;
wire	[31:0]	M_AVALON_0_writedata;
wire			axi_clk	;
wire			axi_resetn	;
wire			ddr_cal_done;
wire	[31:0]	RX_PCLK_FREQ,TX_PCLK_FREQ;
wire	[31:0]	CLK_110M_FREQ,CLK_220M_FREQ,RXOUTCLK_FREQ;
wire	[31:0]	CLK_110M_JITTER,CLK_220M_JITTER,RXOUTCLK_JITTER;

reg	[1:2]	RX_RSVD_R 	= 0;
reg [1:2]	RX_RSVD_R1	= 0;
 reg vid_rstn_f;
 reg vid_rstn_s;
 reg vid_in_en_f;
 reg vid_in_en_s;

wire [2:0] vio_tgt_sel;
wire [1:0] vio_nl_sel ;
wire 	   vio_pdepth_sel ;
wire [31:0] vio_tgt_val;
wire [31:0] vio_outc;
wire	   vio_sw_rst_en;
wire	   vio_set_tgt;
wire	   vio_param_rst_en;
wire	   vio_str_ready;
wire       vio_sync_inv;
// TMC Encoder IP -----------------------------------------------------------------------
wire hclk = axi_clk;
wire nrst = axi_resetn;
//wire jxse_int; // encoder interrupt

/////////////////////////////////////////////////////////////
// interrupt divide because of using two Encoders, Decoders
/////////////////////////////////////////////////////////////
wire jxse_int_f;
wire jxse_int_s;

wire jxsd_int_f;
wire jxsd_int_s; // decoder interrupt

wire hsel_hw_enc;
wire hsel_hw_enc_f;
wire hsel_hw_enc_s;
wire hwr_hw_enc;
wire hwr_hw_enc_f;
wire hwr_hw_enc_s;
wire [ 31:0] haddr_hw_enc;
wire [ 31:0] haddr_hw_enc_f;
wire [ 31:0] haddr_hw_enc_s;
wire [ 31:0] hwdata_hw_enc;
wire [ 31:0] hwdata_hw_enc_f;
wire [ 31:0] hwdata_hw_enc_s;
wire [  1:0] htrans_hw_enc;
wire [  1:0] htrans_hw_enc_f;
wire [  1:0] htrans_hw_enc_s;
wire   	     HREADY_OUT_enc;
wire   	     HREADY_OUT_enc_f;
wire   	     HREADY_OUT_enc_s;
wire [ 31:0] HRDATA_enc;
wire [ 31:0] HRDATA_enc_f;
wire [ 31:0] HRDATA_enc_s;

wire ind_debug; // Added on 2024/01/15 by jihan
wire ind_enc_pic_end; // Added on 2024/01/15 by jihan

wire hsel_hw_dec_f,hsel_hw_dec_s;
wire hwr_hw_dec_f, hwr_hw_dec_s;
wire [ 31:0] haddr_hw_dec_f,haddr_hw_dec_s;
wire [ 31:0] hwdata_hw_dec_f,hwdata_hw_dec_s;
wire [  1:0] htrans_hw_dec_f,htrans_hw_dec_s;
wire   	     HREADY_OUT_dec_f;
wire   	     HREADY_OUT_dec_s;
wire [ 31:0] HRDATA_dec_f;
wire [ 31:0] HRDATA_dec_s;

wire	     str_valid_f, str_valid_dec_f;
wire	     str_valid_s, str_valid_dec_s;	
//wire	     str_ready = 1'b1;	
//wire [127:0] str_out;
wire mod_pix_in_valid; // Added on 2023/12/30 by jihan
wire mod_pix_in_valid_f; // Added on 2023/12/30 by jihan
wire mod_pix_in_valid_s; // Added on 2023/12/30 by jihan
wire [STRM_DW-1:0] mod_pix_in_data; // Added on 2023/12/15 by jihan
wire [STRM_DW-1:0] mod_pix_in_data_f; // Added on 2024/01/24 by KDY
wire [STRM_DW-1:0] mod_pix_in_data_s; // Added on 2024/01/24 by KDY
wire mod_video_tvalid; // Added on 2023/12/30 by jihan
wire mod_video_tvalid_f; // Added on 2023/12/30 by jihan
wire mod_video_tvalid_s; // Added on 2023/12/30 by jihan
wire [STRM_DW-1:0] mod_video_tdata; // Added on 2023/12/15 by jihan
wire [STRM_DW-1:0] mod_video_tdata_f; // Added on 2024/01/24 by KDY
wire [STRM_DW-1:0] mod_video_tdata_s; // Added on 2024/01/24 by KDY

wire [31:0] enc_dsize;
wire gty_init_l0;
wire gty_init_l1;

// in, out data count debugging
   reg  [31:0] enc_in_cnt_s;
   reg  [31:0] enc_in_cnt_f;
   reg  [31:0] enc_out_cnt_s;
   reg  [31:0] enc_out_cnt_f;
    reg			tmc_enc_init;

	logic [7:0] vio_tx_tpg_en;

assign	FAN_ON	=	1;					//activ	high	FAN	allways	on

reg	[31:0]	FPGA_BUILD	=	BUILD_DATE	;

localparam	LED_ON		=	0;
localparam	LED_OFF		=	1;

wire	tgl_1sec;
wire	LED_BLINK	=	tgl_1sec;
wire	RX_NG;
always	@(posedge	FPGA_50MHz)begin
	FPGA_BUILD	<=	BUILD_DATE;
	RX_LOCKN	<=	rx_lockn;
	RX_HPDN		<=	rx_hpdn;
	LED[0]		<=	rx_hpdn		?	LED_OFF	:	!rx_lockn		?	LED_ON	:	LED_BLINK;	//active	low,	lock		:	on,	hpd	:	1sec	blinking
	LED[1]		<=	rx_trn_done	?	LED_ON	:	LED_OFF;									//active	low,	trn	done	:	on,	trn	not	done	:	1sec	blinking
	LED[2]		<=	tx_hpdn		?	LED_OFF	:	!tx_lockn		?	LED_ON	:	LED_BLINK;	//active	low,	lock		:	on,	hpd	:	1sec	blinking
end


reg		PLL1_LOCK_S	=	0;
always @(posedge	FPGA_50MHz)	PLL1_LOCK_S	<=	PLL1_LOCK;
//assign	RX_RS_DONE	=	!ddr_rst	&	PLL1_LOCK_S	?	1	:	1'bz;
//assign	RX_ERR_DET	=	RX_NG						?	1	:	1'bz;

pwr_on_rst	#(.SIMULATION	(SIMULATION))	pwr_on_rst	(
	.freerunclk	(FPGA_50MHz),				//	freerun	clock
	.resetn_out	(pwr_on_rstn_int));				//active	low

assign pwr_on_rstn = pwr_on_rstn_int ;

//Added on 2024/07/10 by dykim
wire mclk_168_48;
wire clkwiz_lock;

clk_wiz_0 u_clk_wiz_0(
    .clk_out1(mclk_168_48),
    .locked(clkwiz_lock),
    .clk_in1(vx1_pclk));

`ifdef SIM
`else

CPU_block	CPU_block	(
	.M_AVALON_0_address			(M_AVALON_0_address),
	.M_AVALON_0_read			(M_AVALON_0_read),
	.M_AVALON_0_readdata		(M_AVALON_0_readdata),
	.M_AVALON_0_readdatavalid	(M_AVALON_0_readdatavalid),
	.M_AVALON_0_waitrequest		(M_AVALON_0_waitrequest),
	.M_AVALON_0_write			(M_AVALON_0_write),
	.M_AVALON_0_writedata		(M_AVALON_0_writedata),
	.UART_0_rxd					(UART0_RXD),
	.UART_0_txd					(UART0_TXD),
	.axi_clk					(axi_clk),				//	axi	cpu	interface	clok	out	100Mhz
	.axi_resetn					(axi_resetn),			//	aci	cpu	integerfac	reset	out	active	low
	.ext_clk					(FPGA_50MHz),			//	freerun	clock	input
	.clk_74p25					(pll_refclk_74p25),		//	pll	refclk	74.25Mhz	out
	.clk_84p24					(pll_refclk_84p24),		//	pll	refclk	74.25Mhz	out
	.clk_89p10					(pll_refclk_89p10),		//	pll	refclk	74.25Mhz	out
	.ext_resetn_in				(pwr_on_rstn));			//	reset	input	for	cpu	reset	active	low
`endif
amm_regfile	#(.BUILD_DATE(BUILD_DATE))	pll_spi(
	.nreset					(axi_resetn),				//	mcu	I/F	reset	active	low
	.aclk					(axi_clk),					//	mcu	I/F	clock
	.M_AVALON_address		(M_AVALON_0_address[13:0]),
	.M_AVALON_read			(M_AVALON_0_read),
	.M_AVALON_readdata		(M_AVALON_0_readdata),
	.M_AVALON_readdatavalid	(M_AVALON_0_readdatavalid),
	.M_AVALON_waitrequest	(M_AVALON_0_waitrequest),
	.M_AVALON_write			(M_AVALON_0_write),
	.M_AVALON_writedata		(M_AVALON_0_writedata),
	.RX_RSVD				(RX_RSVD[1:2]),
	.PCLK_FREQ				(RX_PCLK_FREQ),
	.SI5386_1ST_cs			(PLL1_CSn),
	.SI5386_1ST_sck			(PLL1_SCLK),
	.SI5386_1ST_sdi			(PLL1_SDIO),
	.SI5386_1ST_sdo			(PLL1_SDO),
	.SI5386_1ST_rstn		(PLL1_RSTn),				//	active	low	,	noraml	operation	high
	.SI5386_1ST_pdn			(PLL1_PDNn),				//	acitve	low	,	normal	operation	high
	.SI5386_1ST_LOCK		(PLL1_LOCK),				//	active	high
	.SI5386_1ST_oen			(PLL1_OEn),					//	active	low	,	noraml	operation	low
	.SI5386_1ST_sync		(PLL1_SYNCn),				//	active	low	,	normal	operation	high
	.SI5386_2ND_cs			(PLL2_CSn),
	.SI5386_2ND_sck			(PLL2_SCLK),
	.SI5386_2ND_sdi			(PLL2_SDIO),
	.SI5386_2ND_sdo			(PLL2_SDO),
	.SI5386_2ND_rstn		(PLL2_RSTn),
	.SI5386_2ND_pdn			(PLL2_PDNn),
	.SI5386_2ND_LOCK		(PLL2_LOCK),
	.SI5386_2ND_oen			(PLL2_OEn),
	.SI5386_2ND_sync		(PLL2_SYNCn));
	
reg [31:0] tgt_size_tbl [7:0];
integer i;

// Added on 20240710 by dykim
always @(posedge clk_168_48 or posedge vx1_rst)
begin
	if (vx1_rst) begin
`ifdef CONF_3GBPS
	        tgt_size_tbl[0] <= 1080000; //17
	        tgt_size_tbl[1] <= 1036800; //18
	        tgt_size_tbl[2] <= 933120;  //20
	        tgt_size_tbl[3] <= 848290;  //22
	        tgt_size_tbl[4] <= 746500; //25
	        tgt_size_tbl[5] <= 622000; //30
	        tgt_size_tbl[6] <= 533210; //35
	        tgt_size_tbl[7] <= 466600; //40
`else
	        tgt_size_tbl[0] <= 1800000; //10.5
	        tgt_size_tbl[1] <= 1555000; //12
	        tgt_size_tbl[2] <= 1333000; //14
	        tgt_size_tbl[3] <= 1166400; //16
	        tgt_size_tbl[4] <= 933100;  //20
	        tgt_size_tbl[5] <= 746500; //25
	        tgt_size_tbl[6] <= 622000; //30
	        tgt_size_tbl[7] <= 466600; //40
`endif
	end
    	else if (vio_set_tgt) begin
	    for (i=0; i < 8; i=i+1) begin 
	    	if ( i == vio_tgt_sel)
	    	    tgt_size_tbl[i] <= vio_tgt_val;
    	    end
	end
end

wire	[4:0]	vio_rx_ch_sel;
wire	[15:0]	hact,htotal,vact,vtotal,frate;
wire	mmcm_lock;

wire	[2:0]	gt_loopback;

assign	gt_loopback	=	vio_gt_loopback	?	2	:	0;
//assign	RX_NG		=	!rx_trn_done	|	rx_lockn	|	rx_hpdn;
assign	tx_lockn	=	vio_gt_loopback	?	rx_lockn	:	TX_LOCKN;
assign	tx_hpdn		=	vio_gt_loopback	?	rx_hpdn		:	TX_HPDN;
wire	ref_clk_74p25;
wire	rx_usrclk;
wire	tx_usrclk;

reg 	ref_clk_sel = 1;
reg		RX_NG_R = 1;
reg		[1:0] tpg_en_i = 0;
reg		TPG_EN  = 0;
wire	tick_1sec;
always @(posedge axi_clk)begin
	tpg_en_i[0]	<= vio_tx_tpg_en[0];
	if(tick_1sec)begin
		RX_NG_R		<= RX_NG;
		RX_RSVD_R	<= RX_RSVD[1:2];
		ref_clk_sel <= vio_cable_loopback;
		tpg_en_i[1]	<= tpg_en_i[0];
	end
	TPG_EN		<= |tpg_en_i;
end

`ifdef SIM
assign pll_ref_clk=0;
assign ref_clk=0;
assign vx1_pclk	=	tx_usrclk;
`else
assign	pll_ref_clk	=	RX_RSVD_R[1:2]	==	0	?	pll_refclk_74p25:
						RX_RSVD_R[1:2]	==	2	?	pll_refclk_89p10:
						pll_refclk_84p24;

assign	ref_clk		=	ref_clk_sel ? pll_ref_clk : rx_usrclk;
assign	vx1_pclk	=	rx_usrclk;
`endif

refclkm	pll_refclk(
	.refclk1_in	(ref_clk),							//	vx1	pll	refclk
	.refclk2_in	(pll_refclk_74p25),					//	user	app	refclk
	.REFCLK1_P	(REFCLK1_P),	.REFCLK1_N	(REFCLK1_N),
	.REFCLK2_P	(REFCLK2_P),	.REFCLK2_N	(REFCLK2_N));

wire	[CH_NUM/4-1:0]	gt_qpll1lock;
wire	[CH_NUM-1:0]	gt_rxbyteisaligned,	gt_rxreset;
wire	[CH_NUM*DW-1:0]	gtwiz_userdata_tx,	gtwiz_userdata_rx;
wire	[CH_NUM*4-1:0]	gt_txcharisk,		gt_rxcharisk,		gt_rxdisperr,	gt_rxnotintable	;

assign	gt_err	=	|gt_rxdisperr[AL*4-1:0]	|	|gt_rxnotintable[AL*4-1:0];

wire vx1_rst_rx;
wire vx1_rst_tx;

g_reset	vx1_reset(
		.freerun			(FPGA_50MHz),
		.reset				(~pwr_on_rstn),							//	active	high
		.c0_ddr_init_done	(emul_ddr_cal_done),					//	ddr	cal	done	check
		.c1_ddr_init_done	(emul_ddr_cal_done),					//	ddr	cal	done	check
		.gterr              (RX_NG ? tx_lockn :VIDEO_TIMING== "4K" ? gt_rxdisperr[16*4-1:0]     :gt_rxdisperr ),
        .gtnit              (RX_NG ? 0        :VIDEO_TIMING== "4K" ? gt_rxnotintable[16*4-1:0]  :gt_rxnotintable ),
		.tx_lockn			(tx_lockn),

        .o_sysrst           (vx1_rst),      // active high reset for system, Added on 2023/12/27 by jihan 
		//.o_vx1rst			(vx1_rst),		//	active	high	reset	for	vx1_phy
		.o_vx1rst			(tmp_vx1_rst),		//	active	high	reset	for	vx1_phy, Modified on 2023/12/27 by jihan
		.o_frcrst			(frc_rst),		//	active	high	reset	for	frc
		.o_ddrrst			(ddr_rst),		//	active	high	reset	for	ddr	frame	buffer	reset
		.o_vx1rsttx			(vx1_rst_tx));

ddr_emul	ddr_rst_emul(
		.ddr_rst		(ddr_rst),
		.ddr_cal_done	(emul_ddr_cal_done),
		.ddr_clk		(FPGA_50MHz));

assign vx1_rst_rx	=  | gt_rxreset[AL-1:0];

wire [4:0] VIO_CURSOR;
wire [4:0] VIO_DIFF;

(*mark_debug = "true"*)wire	[	CH_NUM-1:0]	vx1_rx_de,	vx1_rx_hs,	vx1_rx_vs;
(*mark_debug = "true"*)wire	[DW*CH_NUM-1:0]	vx1_rx_data;

wire	[	CH_NUM-1:0]	vx1_tx_de,	vx1_tx_hs,	vx1_tx_vs;
wire	[DW*CH_NUM-1:0]	vx1_tx_data;

wire	VIO_VSYNC_INV;
wire	[	CH_NUM-1:0]	VX1_TX_IN_VS	= VIO_VSYNC_INV ? 	~vx1_tx_vs	: vx1_tx_vs;

`ifdef SIM
logic rx_hpdn;
logic rx_lockn;

assign rx_hpdn = 'h0;
assign rx_lockn = 'h0;
`else
vx1_phy_wrapper	#(
		.CH_NUM(CH_NUM),
		.RX_RVS(RX_RVS))vx1_phy	(
		.mgtrefclk0_226_p			(mgtrefclk0_226_p),
		.mgtrefclk0_226_n			(mgtrefclk0_226_n),
		.mgtrefclk0_230_p			(mgtrefclk0_230_p),
		.mgtrefclk0_230_n			(mgtrefclk0_230_n),

		.freerun					(FPGA_50MHz		),	//	freerun	clock
		.reset						(tmp_vx1_rst	),		//	activ	high
		.reset_rx					(vx1_rst_rx		),
		.reset_tx					(vx1_rst_tx		),
		.gt_loopback				(gt_loopback	),
		.VIO_CURSOR					(VIO_CURSOR		),
		.VIO_DIFF					(VIO_DIFF		),

		.gthrxn_in					(gthrxn_in		),
		.gthrxp_in					(gthrxp_in		),
		.gthtxn_out					(gthtxn_out		),
		.gthtxp_out					(gthtxp_out		),

		.qpll1lock_out				(gt_qpll1lock	),

		.tx_usrclk					(tx_usrclk		),
		.rx_usrclk					(rx_usrclk		),

		.gtwiz_reset_tx_done_out	(gtwiz_reset_tx_done	),
		.gtwiz_reset_rx_done_out	(gtwiz_reset_rx_done	),
		.rxbyteisaligned_out		(gt_rxbyteisaligned		),

		.gtwiz_userdata_tx_in		(gtwiz_userdata_tx		),
		.txcharisk					(gt_txcharisk			),

		.gtwiz_userdata_rx_out		(gtwiz_userdata_rx		),
		.rxcharisk					(gt_rxcharisk			),
		.rxdisperr					(gt_rxdisperr			),
		.rxnotintable				(gt_rxnotintable		));

vx1_link#(
		.SIMULATION	(SIMULATION),
		.CH_NUM(CH_NUM),
		.DW(DW),
	.AL(AL))	vx1_link(
		.FPGA_50MHz					(FPGA_50MHz)	,	//	freerun	clock

		.gt_qpll1lock_in			(gt_qpll1lock	),
		.tx_usrclk					(tx_usrclk		),
		.rx_usrclk					(rx_usrclk		),

		.vx1_rst					(rx_rst	),
		.ddr_rst					(ddr_rst |rx_rst2),
		.frc_rst					(frc_rst	),
		.vx1_rst_tx					(vx1_rst_tx	),

		.gtwiz_reset_tx_done_in		(gtwiz_reset_tx_done	),
		.gtwiz_reset_rx_done_in		(gtwiz_reset_rx_done	),
		.gt_rxbyteisaligned_in		(gt_rxbyteisaligned		),

		.gtwiz_userdata_tx_out		(gtwiz_userdata_tx		),
		.gt_txcharisk_out			(gt_txcharisk			),

		.gtwiz_userdata_rx_in		(gtwiz_userdata_rx	),
		.gt_rxcharisk_in			(gt_rxcharisk		),
		.gt_rxdisperr_in			(gt_rxdisperr		),
		.gt_rxnotintable_in			(gt_rxnotintable	),
		.gt_rxreset_out				(gt_rxreset			),

		.PLL_LOCK					(1'b1		),
		.SYNC_LOCK					(SYNC_LOCK		),
		.RX_LOCKN					(rx_lockn		),
		.RX_HPDN					(rx_hpdn		),
		.RX_TRN_DONE				(rx_trn_done	),
		.TX_LOCKN					(tx_lockn		),
		.TX_HPDN					(tx_hpdn		),

		.vx1_rx_out_de	(vx1_rx_de),	.vx1_rx_out_hs	(vx1_rx_hs),	.vx1_rx_out_vs	(vx1_rx_vs),	.vx1_rx_out_data	(vx1_rx_data),
		.vx1_tx_in_de	(vx1_tx_de),	.vx1_tx_in_hs	(vx1_tx_hs),	.vx1_tx_in_vs	(VX1_TX_IN_VS),	.vx1_tx_in_data		(vx1_tx_data),
		.vx1_pclk		(vx1_pclk),		
		//.vx1_pclk		(clk_84_24),		
        .vx1_rx_vs_ref	(vx1_rx_vs_ref),	.vx1_rx_de_ref	(vx1_rx_de_ref));
`endif



integer PCLK_DIFF_PPM[0:2];
reg				PCLK_LOCK = 0;
wire	[31:0]	RX_PCLK_JITTER,TX_PCLK_JITTER;
localparam	KHZ	=	1000;
localparam  PPM_RANGE = 100/2;

reg [31:0] rx_rst_cnt = 1000*1000*1000;
reg 	   rx_rst  = 0;
reg 	   rx_rst2 = 0;
assign 	RX_NG = rx_rst_cnt < 100*1000*1000;
always @(posedge axi_clk) begin
	rx_rst_cnt	<= rx_rst_cnt < 1000*1000*1000 ? rx_rst_cnt + 1 : rx_hpdn  ? 0 : rx_lockn | VIO_VSYNC_INV ? 0 : rx_rst_cnt;
	rx_rst		<= rx_rst_cnt < 64 	? 1 : 0; 
	rx_rst2		<= rx_rst_cnt < 256 ? 1 : 0;  
	
	PCLK_DIFF_PPM[0] 	<=	tick_1sec ? RX_PCLK_FREQ - TX_PCLK_FREQ :PCLK_DIFF_PPM[0];
	PCLK_DIFF_PPM[1]	<=  tick_1sec ? PCLK_DIFF_PPM[0] : PCLK_DIFF_PPM[1];
	PCLK_DIFF_PPM[2]	<=  PCLK_DIFF_PPM[0]- PCLK_DIFF_PPM[1];
	PCLK_LOCK 		<= PCLK_DIFF_PPM[2] < PPM_RANGE && PCLK_DIFF_PPM[2] > 0-PPM_RANGE ? 1 : 0;
	
end





wire [31:0] 	rx_vtotal;
wire [31:0] 	rx_vback_porch;

vid_sa	vid_sa(vx1_rx_vs_ref,vx1_rx_de_ref,rx_usrclk,rx_vtotal,rx_vback_porch);

wire [31:0] VIO_HT;
wire [31:0] VIO_VT;
wire [31:0] VIO_HF;
wire [31:0] VIO_VF;
wire [31:0] VIO_HB;
wire [31:0] VIO_VS;
wire [15:0] vfp;
wire [15:0] vsw;
wire [15:0] vbp;
wire [15:0] vblk;

vx1_debug	#(
.VIDEO_TIMING(VIDEO_TIMING),
.AL(AL))
vx1_debug(
		.VIO_HT(VIO_HT),	.VIO_VT(VIO_VT),
		.VIO_HF(VIO_HF),	.VIO_VF(VIO_VF),
		.VIO_HB(VIO_HB),	.VIO_VS(VIO_VS),
		.vio_gt_loopback(vio_gt_loopback),	.vio_tx_tpg_en	((TPG_EN)),	.vio_rx_ch_sel(vio_rx_ch_sel),
		.vx1_rx_de	(vx1_rx_de),	.vx1_rx_hs	(vx1_rx_hs),	.vx1_rx_vs	(vx1_rx_vs),	.vx1_rx_data	(vx1_rx_data),
		.vx1_tx_de	(vx1_tx_de),	.vx1_tx_hs	(vx1_tx_hs),	.vx1_tx_vs	(vx1_tx_vs),	.vx1_tx_data	(vx1_tx_data), .vx1_tx_data_1  (vx1_tx_data_1),
		.htotal		(htotal),		.hact		(hact),
		.vtotal		(vtotal),		.vact		(vact),			.frate		(frate),
		.vfp		(vfp),			.vsw		(vsw),			.vbp		(vbp),		.vblk		(vblk),
		.SYNC_LOCK(SYNC_LOCK),		.vx1_pclk	(vx1_pclk),		.axi_clk	(axi_clk),  .vio_sync_inv(vio_sync_inv),
		
		.line_num_out(line_num_int),
        // Frame fin
        .tmc_enc_init(tmc_enc_init), // Added on 2023/12/25 by jihan
        .enc_sw_rst(enc_sw_rst_ILA), // Added on 2023/12/25 by jihan

        // Vcnt
        .enc_vcnt_f(enc_vcnt_f_ila),
        .enc_vcnt_s(enc_vcnt_s_ila),

        // Clock
        //.vx1_pclk(clk_wiz_74_25), // modified 24/05/17 hkkim
        //.vx1_pclk(clk_84_24), // modified on 240710 by dykim
        .clk_168_48(clk_168_48), // modified on 240710 by dykim
        // Added on 2023/12/24 by hk kim
        //.gty_tx_userdata_ILA(gty_tx_userdata_out_ILA),
        //.ENC_INPUT_DATA(mod_video_tdata), //input
        .m_axis_video_tready_f(m_axis_video_tready_f),	// modified 24/05/17 hkkim
        .m_axis_video_tready_s(m_axis_video_tready_s),	// modified 24/05/17 hkkim
        
        // TMC data debugging
        .ENC_INPUT_DATA_f(m_axis_video_tdata_f),	// modified 24/05/17 hkkim
        .ENC_INPUT_DATA_s(m_axis_video_tdata_s),	// modified 24/05/17 hkkim
        .ENC_OUTPUT_DATA_f(str_out_f), //input
        .ENC_OUTPUT_DATA_s(str_out_s),
        .JXSE_INTERRUPT_f(jxse_int_f),
        .JXSE_INTERRUPT_s(jxse_int_s),

        // GTY data debugging
        .gty_init_l0(gty_init_l0),
        .gty_init_l1(gty_init_l1),
        .enc_dsize(enc_dsize),
        .gty_str_valid_f(gty_str_valid_f),
        .gty_str_valid_s(gty_str_valid_s),
        .gty_str_out_f(gty_str_out_f),
        .gty_str_out_s(gty_str_out_s),
        .gty_din_ready_f(str_ready_f),
        .gty_din_ready_s(str_ready_s),

        // Frame count debugging
        .time_stamp_f_ILA(time_stamp_f_ILA),
        .time_stamp_s_ILA(time_stamp_s_ILA),
        .time_stamp_vs_ILA(time_stamp_vs_ILA),

        .enc_in_cnt_s_ila(enc_in_cnt_s_ila),
        .enc_in_cnt_f_ila(enc_in_cnt_f_ila),
        .enc_out_cnt_s_ila(enc_out_cnt_s_ila),
        .enc_out_cnt_f_ila(enc_out_cnt_f_ila),

        // line selector data in debugging
        .line_sel_de_line_ila(line_sel_de_line_ila),
        .line_sel_vs_1d_ila(line_sel_vs_1d_ila),
        .line_sel_hs_1d_ila(line_sel_hs_1d_ila),
        .line_sel_vx1_data_ila(line_sel_vx1_data_ila),
        .line_sel_data_in_ila(line_sel_data_in_ila),
        .line_sel_DE_cnt_2d_ila(line_sel_DE_cnt_2d_ila),
        .line_sel_cnt1920_2d_ila(line_sel_cnt1920_2d_ila),
        .line_sel_de_out_ila(line_sel_de_out_ila),
        .line_sel_op_en_ila(line_sel_op_en_ila),
        .line_sel_address_12_ila(line_sel_address_12_ila),
        .line_sel_address_34_ila(line_sel_address_34_ila),
        .line_sel_data_in1_ila(line_sel_data_in1_ila),
        .line_sel_data_out1_ila(line_sel_data_out1_ila),
        .line_sel_we1_ila(line_sel_we1_ila),

        .tgt_size_tbl0(tgt_size_tbl[0]),
        .tgt_size_tbl1(tgt_size_tbl[1]),
        .tgt_size_tbl2(tgt_size_tbl[2]),
        .tgt_size_tbl3(tgt_size_tbl[3]),
        .tgt_size_tbl4(tgt_size_tbl[4]),
        .tgt_size_tbl5(tgt_size_tbl[5]),
        .tgt_size_tbl6(tgt_size_tbl[6]),
        .tgt_size_tbl7(tgt_size_tbl[7]),

        .frame_cnt(frame_cnt),
        .fail_cnt(fail_cnt),
        .int_f_cnt(int_f_cnt),
        .int_s_cnt(int_s_cnt),
        // TGT size change
        .gty_wr_en_b0_l0_ila(gty_wr_en_b0_l0_ila),	
        .gty_wr_en_b1_l0_ila(gty_wr_en_b1_l0_ila),	
        .gty_wr_en_b0_l1_ila(gty_wr_en_b0_l1_ila),	
        .gty_wr_en_b1_l1_ila(gty_wr_en_b1_l1_ila),	
        .gty_wr_cnt_l0_ila(gty_wr_cnt_l0_ila),	
        .gty_wr_cnt_l1_ila(gty_wr_cnt_l1_ila),	
        .gty_alm_full_b0_l0_ila(gty_alm_full_b0_l0_ila),	
        .gty_alm_full_b1_l0_ila(gty_alm_full_b1_l0_ila),	
        .gty_alm_full_b0_l1_ila(gty_alm_full_b0_l1_ila),	
        .gty_alm_full_b1_l1_ila(gty_alm_full_b1_l1_ila),	
        .gty_empty_b0_l0_ila(gty_empty_b0_l0_ila),	
        .gty_empty_b1_l0_ila(gty_empty_b1_l0_ila),	
        .gty_empty_b0_l1_ila(gty_empty_b0_l1_ila),	
        .gty_empty_b1_l1_ila(gty_empty_b1_l1_ila),	
        .gty_wr_data_count_b0_l0_ila(gty_wr_data_count_b0_l0_ila),	
        .gty_wr_data_count_b1_l0_ila(gty_wr_data_count_b1_l0_ila),	
        .gty_wr_data_count_b0_l1_ila(gty_wr_data_count_b0_l1_ila),	
        .gty_wr_data_count_b1_l1_ila(gty_wr_data_count_b1_l1_ila),	
        .gty_rd_data_count_b0_l0_ila(gty_rd_data_count_b0_l0_ila),	
        .gty_rd_data_count_b1_l0_ila(gty_rd_data_count_b1_l0_ila),	
        .gty_rd_data_count_b0_l1_ila(gty_rd_data_count_b0_l1_ila),	
        .gty_rd_data_count_b1_l1_ila(gty_rd_data_count_b1_l1_ila),
        .gty_userdata_tx_int_ila(gty_userdata_tx_int_ila),
        .dout_ILA(dout_ILA),
        .dout_valid_ILA(dout_valid_ILA),
        .gty_txpmaresetdone_int_ILA(gty_txpmaresetdone_int_ILA),	
        .param_change_ILA(param_change_ILA)
		);


clk_freq	#(100*1000*1000)	rx_usrclk_freq_0	(axi_clk,	rx_usrclk,	RX_PCLK_FREQ,	tgl_1sec, 	tick_1sec	,vx1_rst,RX_PCLK_JITTER);
clk_freq	#(100*1000*1000)	tx_usrclk_freq_1	(axi_clk,	tx_usrclk,	TX_PCLK_FREQ,	tgl_1sec0,				,vx1_rst,TX_PCLK_JITTER);


clk_handler clk_handler(
    .refclk     (mclk_168_48), // Modified on 2023/12/23 by jihan
    .resetn     (~vx1_rst), 
    .de_in(vtg_active_video), // input (Org)
    .pos_74_25  (pos_84_24), // Added on 2023/12/06 by jihan
    .sel_phase  (sel_phase), // Added on 2023/12/06 by jihan    
    .clk148_5   (clk_168_48), 
    .nclk148_5  (nclk_168_48), // Added on 2023/12/14 by jihan
    .clk74_25   (clk_84_24), 
    .clk37_125  (clk_42_12),
    .clk_37_125 (clk_42_12_p), 
    .clk18_5625 (clk_21_06)
    );


vx1_vio_0	vx1_vio	(
	.clk		(axi_clk),
	.probe_in0	(rx_lockn),
	.probe_in1	(rx_trn_done),
	.probe_in2	(tx_lockn),
	.probe_in3	(ddr_rst),
	.probe_in4	(frc_rst),
	.probe_in5	(vx1_rst),
	.probe_in6	(gt_err),
	.probe_in7	(PCLK_LOCK),
	.probe_in8	(SYNC_LOCK),
	.probe_in9	(FPGA_BUILD),
	.probe_in10	(hact),
	.probe_in11	(htotal),
	.probe_in12	(vact),
	.probe_in13	(vtotal),
	.probe_in14	(frate),
	.probe_in15	(RX_PCLK_FREQ),
	.probe_in16	(gt_qpll1lock),
	.probe_in17	(vx1_rst_rx),
	.probe_in18	(vfp),
	.probe_in19	(vsw),
	.probe_in20	(vbp),
	.probe_in21	(vblk),
	.probe_in22	(TX_PCLK_FREQ),
	.probe_in23	(RX_PCLK_JITTER),
	.probe_in24	(TX_PCLK_JITTER),
	.probe_in25	(PCLK_DIFF_PPM[0]),
	.probe_in26	(rx_vtotal),
	.probe_in27	(rx_vback_porch),
	.probe_in28	(ref_clk_sel),
	.probe_in29	(TPG_EN),
//	.probe_in30 (CLK_110M_FREQ),
//	.probe_in31 (CLK_110M_JITTER),
//	.probe_in32 (CLK_220M_FREQ),
//	.probe_in33 (CLK_220M_JITTER),
    //
    .probe_in30 (PLL1_LOCK),
	.probe_in31 (PLL2_LOCK),
	.probe_in32(gty_txpmaresetdone_int_ILA),
	.probe_in33(hb_gtwiz_reset_all_int),
	//
	.probe_in34 (RXOUTCLK_FREQ),
	.probe_in35 (RXOUTCLK_JITTER),
	.probe_in36 (RX_VX1_MODE),
	.probe_in37 (TX_QSMEN),
	.probe_in38 (TX_AC_DET),
	.probe_in39 (TX_RSVD[3]),
	.probe_in40(0),
	.probe_in41(0),
	
	.probe_out0	(vio_gt_loopback),
	.probe_out1	(vio_rx_ch_sel),
	.probe_out2	(vio_tx_tpg_en),
	.probe_out3	(vio_cable_loopback),
	.probe_out4	(VIO_HT),
	.probe_out5 (VIO_VT),
	.probe_out6	(VIO_HF),
	.probe_out7 (VIO_VF),
	.probe_out8	(VIO_HB),
	.probe_out9 (VIO_VS),
	.probe_out10(VIO_DIFF),
	.probe_out11(VIO_CURSOR),
	.probe_out12(VIO_VSYNC_INV),
	//
	.probe_out13(vio_nl_sel),
	.probe_out14(vio_pdepth_sel),
	.probe_out15(vio_board_reset),
	.probe_out16(vio_set_tgt),
	.probe_out17(vio_tgt_sel),
	.probe_out18(vio_tgt_val),
	.probe_out19(vio_outc),
	.probe_out20(vio_param_rst_en),
	.probe_out21(vio_str_ready),
	.probe_out22(vio_sw_rst_en),
	.probe_out23(vio_gtwiz_reset_all_int),
	.probe_out24(vio_sync_inv)
	);

//////////////////////////////////////////////////////////
// signals for board reset generator
/////////////////////////////////////////////////////////
// reset generator Added on 2023/12/18 by hkkim
wire nrst_tmc;
wire nrst_gty;
wire set_prm;
wire [31:0] rst_cnt_out_ILA;
//wire tmp_nrst_tmc;
//wire tmp_nrst_gty;
//wire tmp_set_prm;

   reg enc_sw_rst;
   reg [31:0] enc_sw_rst_cnt;

   assign enc_sw_rst_ILA = enc_sw_rst;


   // ************** Modified
   // Timer reset logic
   wire en_mask;

   reg [31:0] 	wtchdog_stamp	;
   reg		wtchdog_rst	;

   always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	if (!nrst_tmc) begin
		wtchdog_stamp <= 0;
	end
	else if (tmc_enc_init | enc_sw_rst) begin
		wtchdog_stamp <= 0;
	end
	else begin
		wtchdog_stamp <= wtchdog_stamp + 1;
	end
   end

   always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	if (!nrst_tmc) begin
		wtchdog_rst <= 1;
	end
	else if (wtchdog_stamp == 2000000000) begin
		wtchdog_rst <= 0;
	end
	else if (wtchdog_stamp == 2100000000) begin
		wtchdog_rst <= 1;
	end
   end

   always @(posedge clk_168_48 or posedge vx1_rst)
   begin
	if (vx1_rst) begin
		fail_cnt <= 0;
	end
	else if (enc_sw_rst & (enc_sw_rst_cnt == 0) ) begin
		fail_cnt <= fail_cnt + 1;
	end
   end

// ************** Modified
   // Board reset gen with vio_board_reset
   // Should modify Board_reset_gen file
board_reset_gen u_board_reset_gen(
    .clk148_5	(clk_168_48			),
    .pwr_on_rstn(vio_board_reset & wtchdog_rst  ),
    .freeclk	(FPGA_50MHz			),
    .nrst_tmc	(nrst_tmc			),
    .nrst_gty	(nrst_gty			),
    .set_prm	(set_prm			),
    .en_mask	(en_mask			),
    .rst_cnt_out(rst_cnt_out_ILA		));
    
// Added on 2023/12/02 by jihan
 reg vx1_tx_de_74_1d, vx1_tx_vs_74_1d, vx1_tx_hs_74_1d;
 //always @ (posedge clk_wiz_74_25) begin
 always @ (posedge vx1_pclk) begin
	vx1_tx_de_74_1d <= vx1_tx_de[0];
	vx1_tx_vs_74_1d <= vx1_tx_vs[0];
	vx1_tx_hs_74_1d <= vx1_tx_hs[0];

 end
 reg vx1_tx_de_148_1d, vx1_tx_vs_148_1d, vx1_tx_hs_148_1d;
 always @ (posedge clk_168_48) begin
	vx1_tx_de_148_1d <= vx1_tx_de_74_1d;
	vx1_tx_vs_148_1d <= vx1_tx_vs_74_1d;
	vx1_tx_hs_148_1d <= vx1_tx_hs_74_1d;
 end
 
 reg vx1_tx_de_148_2d; // added on 2024/02/06 by KDY
  always @ (posedge clk_168_48) begin
	vx1_tx_de_148_2d <= vx1_tx_de_148_1d;
 end
 reg vx1_tx_vs_148_2d; // added on 2024/02/06 by KDY
  always @ (posedge clk_168_48) begin
	vx1_tx_vs_148_2d <= vx1_tx_vs_148_1d;
 end

 wire [143:0] dec_m_axis_video_tdata_f; // Added on 2023/12/08 by jihan
 wire [143:0] dec_m_axis_video_tdata_s;
 //wire m_axis_video_tvalid;
 wire dec_m_axis_video_tvalid_f; // Added on 2023/12/08 by jihan
 wire dec_m_axis_video_tvalid_s;
 //wire m_axis_video_tuser;
 wire dec_m_axis_video_tuser_f; // Added on 2023/12/08 by jihan
 wire dec_m_axis_video_tuser_s; 
 wire m_axis_video_tlast;
 wire dec_m_axis_video_tlast_f; // Added on 2023/12/08 by jihan
 wire dec_m_axis_video_tlast_s;
 wire vtd_active_video;
 wire vtd_active_video_f;
 wire vtd_active_video_s;
 wire vtd_vblank;
 wire vtd_vblank_f;
 wire vtd_vblank_s;
 wire vtd_hblank;
 wire vtd_hblank_f;
 wire vtd_hblank_s;
 wire vtd_vsync;
 wire vtd_vsync_f;
 wire vtd_vsync_s;
 wire vtd_hsync;
 wire vtd_hsync_f;
 wire vtd_hsync_s;
 wire vtd_field_id;
 wire vtd_field_id_f;
 wire vtd_field_id_s;
 wire fid;
 wire fid_f;
 wire fid_s;
 wire overflow;
 wire overflow_f;
 wire overflow_s;
 wire underflow;
 wire underflow_f;
 wire underflow_s;

 // Added on 2024/01/18 by KDY
////////////////////////////////////////////////////////
// line selector instantiation and signals
////////////////////////////////////////////////////////
 //wire [143:0] data_out;
 wire [143:0] data_out_f;
 wire [143:0] data_out_s;
 wire [2:0]   data_out_h;

 wire [146:0] data_out_f_all;
 wire [146:0] data_out_s_all;

 reg [2:0] data_out_f_all_1d;
 reg [2:0] data_out_f_all_2d;
 reg [2:0] data_out_f_all_3d;
 
 wire DE_line;
 
   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
		data_out_f_all_1d <= 0;
	else 
		data_out_f_all_1d <= data_out_h;
   end

   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
		data_out_f_all_2d <= 0;
	else 
		data_out_f_all_2d <= data_out_f_all_1d;
   end

   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
		data_out_f_all_3d <= 0;
	else 
		data_out_f_all_3d <= data_out_f_all_2d;
   end

 assign DE_line = vx1_tx_de[0];
 
 reg DE_1d;
 reg DE_2d;
 reg DE_3d;
 
  always @ (posedge clk_168_48) begin
        DE_1d <= DE_line;
    end
    
  always @ (posedge clk_168_48) begin
        DE_2d <= DE_1d;
    end
    
  always @ (posedge clk_168_48) begin
        DE_3d <= DE_2d;
    end
    
    
 //----------------------------------------------------------------------------------------------------------------
 // 2 line delay model
 wire first_de_st_tr_74_25;
 reg DE_line_74_25_1delay;
 reg DE_line_74_25_2delay;
 
 reg DE_st_tr = 0;
 reg [15:0] DE_cnt;
 reg DE_st_enb;
 wire DE_2line_d;

 //------------------------------------------------------------------------------------------------------
   //2line delay model (37.125MHz)
   DE_line_550_delay u0_DE_line_550_delay(
   //.clk_74_25(clk_wiz_74_25),
   .clk_74_25(vx1_pclk),
   .DE_line(DE_line), 
   .DE_2line_delay(DE_2line_d)
   );
   

 line_selector u_line_selctor(
    .clk(clk_168_48),
    //.clk_74_25(clk_wiz_74_25),
    .clk_div2(vx1_pclk),
    .resetn(nrst_tmc & ~enc_sw_rst), 
    .DE(DE_line),
    .DE_2line_d(DE_2line_d),
    .VSYNC(vx1_tx_vs_148_1d), 
    .HSYNC(vx1_tx_hs_148_1d), 
    .data_in({DE_line, 1'b0, 1'b0 ,vx1_tx_data_1}),  
    .cnt1920_2d_out(line_sel_cnt1920_2d_ila),
    .DE_1d_out(line_sel_DE_1d_ila),
    .DE_cnt_2d_out(line_sel_DE_cnt_2d_ila),
    .op_en_out(line_sel_op_en_ila),
    .address_12_out(line_sel_address_12_ila),
    .address_34_out(line_sel_address_34_ila),
    .we1_out(line_sel_we1_ila),
    .data_in1_out(line_sel_data_in1_ila),
    .data_out1_out(line_sel_data_out1_ila),
    .data_out_f(data_out_f), 
    .data_out_s(data_out_s),
    .data_out_h(data_out_h)
    //.data_out_f_all(data_out_f_all),
    //.data_out_s_all(data_out_s_all)
    );   

    assign line_sel_de_line_ila = DE_line;
    assign line_sel_vs_1d_ila = vx1_tx_vs_148_1d;
    assign line_sel_hs_1d_ila = vx1_tx_hs_148_1d;
    assign line_sel_vx1_data_ila = vx1_tx_data_1;
    assign line_sel_data_in_ila = {DE_line, vx1_tx_vs_148_1d, vx1_tx_hs_148_1d, vx1_tx_data_1};
    assign line_sel_de_out_ila = data_out_f_all_3d[2];



always @(posedge clk_168_48 or negedge nrst_tmc) begin //Modified on 2024/02/19 by hsyoo 
 if (!nrst_tmc) 
     vid_rstn_f <= 0;
 else if (enc_sw_rst) 
     vid_rstn_f <= 0;
 else if (m_axis_video_tready_f)
     vid_rstn_f <= 1;
end

always @(posedge clk_168_48 or negedge nrst_tmc) begin //Modified on 2024/02/19 by hsyoo 
 if (!nrst_tmc) 
     vid_in_en_f <= 0;
 else if (enc_sw_rst) 
     vid_in_en_f <= 0;
 else if (vx1_tx_vs_148_1d & m_axis_video_tready_f)
     vid_in_en_f <= 1;
end

always @(posedge clk_168_48 or negedge nrst_tmc) begin //Modified on 2024/02/19 by hsyoo 
 if (!nrst_tmc) 
     vid_rstn_s <= 0;
 else if (enc_sw_rst) 
     vid_rstn_s <= 0;
 else if (m_axis_video_tready_s)
     vid_rstn_s <= 1;
end

always @(posedge clk_168_48 or negedge nrst_tmc) begin //Modified on 2024/02/19 by hsyoo 
 if (!nrst_tmc) 
     vid_in_en_s <= 0;
 else if (enc_sw_rst) 
     vid_in_en_s <= 0;
 else if (vx1_tx_vs_148_1d & m_axis_video_tready_s)
     vid_in_en_s <= 1;
end

v_vid_in_axi4s_0 u0_v_vid_in_axi4s_0 (
  		// video input signals
  		.vid_io_in_ce		( 1'b1			), // input, Modified on 2023/12/02 by jihan
  		.vid_active_video	( data_out_h[2] & vid_in_en_f), // input, Modified on 2023/12/02 by jihan // Modified on 2024/02/06 by KDY
  		.vid_vblank		( 1'b0			), // input
  		.vid_hblank		( 1'b0			), // input
  		.vid_vsync		( vx1_tx_vs_148_1d & vid_in_en_f	), // input, Modified on 2023/12/02 by jihan
  		.vid_hsync		( vx1_tx_hs_148_1d & vid_in_en_f	), // input, Modified on 2023/12/02 by jihan
  		.vid_field_id		( 1'b0			), // input
  		.vid_data		( data_out_f), // input , 144bit  Fr.line_selector

  		// main signals (clk, rst, en)
  		.aclk			( clk_168_48		), // input
  		.aclken			( 1'b1			), // input
  		//.aresetn		( ~vx1_rst		), // input
  		.aresetn		( vid_rstn_f		), // input

  		// AXI4-Stream Interface
  		.m_axis_video_tdata	( m_axis_video_tdata_f	), // o
  		.m_axis_video_tvalid	( m_axis_video_tvalid_f	), // o
  		.m_axis_video_tready	( m_axis_video_tready_f	), // i
  		.m_axis_video_tuser	( m_axis_video_tuser_f	), // o
  		.m_axis_video_tlast	( m_axis_video_tlast_f	), // o

  		// for video timing controller(just wiring)
  		.fid			( fid_f			), // output
  		.vtd_active_video	( vtd_active_video_f	), // output
  		.vtd_vblank		( vtd_vblank_f		), // output
  		.vtd_hblank		( vtd_hblank_f		), // output
  		.vtd_vsync		( vtd_vsync_f		), // output
  		.vtd_hsync		( vtd_hsync_f		),  // output
  		.vtd_field_id		( vtd_field_id_f	), // output
  		.overflow		( overflow_f		), // output
  		.underflow		( underflow_f		), // output
  		.axis_enable  		( 1'b1			) // inpt
 		);
 
 	v_vid_in_axi4s_0 u1_v_vid_in_axi4s_0 (
  		// video input signals
  		.vid_io_in_ce		( 1'b1			), // input, Modified on 2023/12/02 by jihan
  		.vid_active_video	( data_out_h[2] & vid_in_en_s), // input, Modified on 2023/12/02 by jihan // Modified on 2024/02/06 by KDY
  		.vid_vblank		( 1'b0			), // input
  		.vid_hblank		( 1'b0			), // input
  		.vid_vsync		( vx1_tx_vs_148_1d & vid_in_en_s	), // input, Modified on 2023/12/02 by jihan
  		.vid_hsync		( vx1_tx_hs_148_1d & vid_in_en_s	), // input, Modified on 2023/12/02 by jihan
  		.vid_field_id		( 1'b0			), // input
  		.vid_data		( data_out_s		), // input , 144bit  Second.line_selector

  		// main signals (clk, rst, en)
  		.aclk			( clk_168_48		), // input
  		.aclken			( 1'b1			), // input
  		//.aresetn		( ~vx1_rst		), // input
  		.aresetn		( vid_rstn_s		), // input

  		// AXI4-Stream Interface
  		.m_axis_video_tdata	( m_axis_video_tdata_s	), // o
  		.m_axis_video_tvalid	( m_axis_video_tvalid_s	), // o
  		.m_axis_video_tready	( m_axis_video_tready_s	), // i
  		.m_axis_video_tuser	( m_axis_video_tuser_s	), // o
  		.m_axis_video_tlast	( m_axis_video_tlast_s	), // o

  		// for video timing controller(just wiring)
  		.fid			( fid_s			), // output
  		.vtd_active_video	( vtd_active_video_s	), // output
  		.vtd_vblank		( vtd_vblank_s		), // output
  		.vtd_hblank		( vtd_hblank_s		), // output
  		.vtd_vsync		( vtd_vsync_s		), // output
  		.vtd_hsync		( vtd_hsync_s		),  // output
  		.vtd_field_id		( vtd_field_id_s	), // output
  		.overflow		( overflow_s		), // output
  		.underflow		( underflow_s		), // output
  		.axis_enable  		( 1'b1			) // inpt
 		);

///////////////////////////////////////////////////////////////////////
// Video Timing Controller for enc_0, enc_1
///////////////////////////////////////////////////////////////////////
   reg  [143:0] 	m_axis_video_tdata_1d		;
   reg  [143:0] 	m_axis_video_tdata_f_1d		;
   reg  [143:0] 	m_axis_video_tdata_s_1d		;

   reg 			m_axis_video_tlast_f_1d		;
   reg			m_axis_video_tlast_s_1d		;

   reg 			m_axis_video_tlast_f_2d		; 
   reg			m_axis_video_tlast_s_2d		;

   reg 			m_axis_video_tlast_f_3d		; 
   reg			m_axis_video_tlast_s_3d		; 

   reg 			m_axis_video_tlast_f_4d		; 
   reg			m_axis_video_tlast_s_4d		;

   reg 			m_axis_video_tvalid_f_1d	; 
   reg			m_axis_video_tvalid_s_1d	;

   reg 			m_axis_video_tuser_f_1d		;
   reg			m_axis_video_tuser_s_1d		;

always @(posedge clk_168_48 or negedge nrst_tmc) begin  
	if (!nrst_tmc) begin
            m_axis_video_tdata_f_1d <= 0;
            m_axis_video_tlast_f_1d <= 0;
            m_axis_video_tlast_f_2d <= 0;
            m_axis_video_tlast_f_3d <= 0;
            m_axis_video_tlast_f_4d <= 0;
            m_axis_video_tvalid_f_1d <= 0;
            m_axis_video_tuser_f_1d <= 0;
	end
 	else begin
            m_axis_video_tdata_f_1d <= m_axis_video_tdata_f; // Modified on 2024/01/26 bt KDY : m_axis_video_tdata -> m_axis_video_tdata_f

            m_axis_video_tlast_f_1d <= m_axis_video_tlast_f;
            m_axis_video_tlast_f_2d <= m_axis_video_tlast_f_1d;
            m_axis_video_tlast_f_3d <= m_axis_video_tlast_f_2d;
            m_axis_video_tlast_f_4d <= m_axis_video_tlast_f_3d;
            m_axis_video_tvalid_f_1d <= m_axis_video_tvalid_f;
            m_axis_video_tuser_f_1d <= m_axis_video_tuser_f;
 	end
   end

always @(posedge clk_168_48 or negedge nrst_tmc) begin  
	if (!nrst_tmc) begin
            m_axis_video_tdata_s_1d <= 0;
            m_axis_video_tlast_s_1d <= 0;
            m_axis_video_tlast_s_2d <= 0;
            m_axis_video_tlast_s_3d <= 0;
            m_axis_video_tlast_s_4d <= 0;
            m_axis_video_tvalid_s_1d <= 0;
            m_axis_video_tuser_s_1d <= 0;
	end
 	else begin
            m_axis_video_tdata_s_1d <= m_axis_video_tdata_s; // Modified on 2024/01/26 bt KDY : m_axis_video_tdata -> m_axis_video_tdata_s

            m_axis_video_tlast_s_1d <= m_axis_video_tlast_s;
            m_axis_video_tlast_s_2d <= m_axis_video_tlast_s_1d;
            m_axis_video_tlast_s_3d <= m_axis_video_tlast_s_2d;
            m_axis_video_tlast_s_4d <= m_axis_video_tlast_s_3d;
            m_axis_video_tvalid_s_1d <= m_axis_video_tvalid_s;
            m_axis_video_tuser_s_1d <= m_axis_video_tuser_s;
 	end
   end

////////////////////////////////////////////////////////////////
// Modified for each encdoer IP (708 ~ 740 lane)
////////////////////////////////////////////////////////////////
   reg jxse_int_f_1d;
   reg jxse_int_f_st_1d;
   wire jxse_int_st_f;

   reg jxse_int_s_1d;
   reg jxse_int_s_st_1d;
   wire jxse_int_st_s;

   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
	if (!nrst_tmc) begin 
		jxse_int_f_1d <= 0;
		jxse_int_f_st_1d <= 0;
	end
	else begin
		jxse_int_f_1d <= jxse_int_f;
		jxse_int_f_st_1d <= jxse_int_st_f;
	end
   end

   assign jxse_int_st_f = jxse_int_f & (~jxse_int_f_1d);

   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
	if (!nrst_tmc) begin 
		jxse_int_s_1d <= 0;
		jxse_int_s_st_1d <= 0;
	end
	else begin
		jxse_int_s_1d <= jxse_int_s;
		jxse_int_s_st_1d <= jxse_int_st_s;
	end
   end

   assign jxse_int_st_s = jxse_int_s & (~jxse_int_s_1d);

////////////////////////////////////////////////////////////////
// Modified for each encdoer IP : enc_vcnt (760 ~ 740 lane)
////////////////////////////////////////////////////////////////
   reg [12:0] enc_vcnt_f;
   reg [12:0] enc_vcnt_s;

  // encoder vcnt counting
   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
        	enc_vcnt_f <= 0;
 	else if (enc_sw_rst) 
        	enc_vcnt_f <= 0;
 	else begin
  	if (m_axis_video_tuser_f) 
        	enc_vcnt_f <= 0;
  	else if (m_axis_video_tlast_f & (~m_axis_video_tlast_f_1d))  // for TMC encoder 
  	//else if (m_axis_video_tlast)  // for TMC decoder 
	    	enc_vcnt_f <= enc_vcnt_f + 1;
 	end
   end

  // encoder vcnt counting
   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
        	enc_vcnt_s <= 0;
 	else if (enc_sw_rst) 
        	enc_vcnt_s <= 0;
 	else begin
  	if (m_axis_video_tuser_s) 
        	enc_vcnt_s <= 0;
  	else if (m_axis_video_tlast_s & (~m_axis_video_tlast_s_1d))  // for TMC encoder 
  	//else if (m_axis_video_tlast)  // for TMC decoder 
	    	enc_vcnt_s <= enc_vcnt_s + 1;
 	end
   end

assign enc_vcnt_s_ila = enc_vcnt_s;
assign enc_vcnt_f_ila = enc_vcnt_f;

////////////////////////////////////////////////////////////////
// TMC Enc init (pic enc)
////////////////////////////////////////////////////////////////
   reg tmp_tmc_enc_init_f;
   reg tmp_tmc_enc_init_s;
  
   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
        	tmp_tmc_enc_init_f <= 0;
 	else if (enc_sw_rst) 
        	tmp_tmc_enc_init_f <= 0;
 	else begin
  	if (m_axis_video_tuser_f) 
        	tmp_tmc_enc_init_f <= 0;
  	//else if (m_axis_video_tlast_1d & (~m_axis_video_tlast_2d) & enc_vcnt==13'd2160)  // for TMC encoder 
 	//else if ((jxse_int_st==1) & (enc_vcnt==13'd2160))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x2160)
  	//else if ((jxse_int_st==1) & (enc_vcnt==13'd270))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x270)
  	else if ((jxse_int_st_f==1) & (enc_vcnt_f==13'd2160))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x540)
  	//else if ((jxse_int_st_f==1) & (enc_in_cnt_f==1036800))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x540)
        	tmp_tmc_enc_init_f <= 1;
  	//else if (m_axis_video_tlast_3d & (~m_axis_video_tlast_4d) & enc_vcnt==13'd2160)  // for TMC encoder 
  	else if ((jxse_int_f_st_1d==1) && (enc_vcnt_f==13'd2160))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x2160)
  	//else if ((jxse_int_st_1d==1) && (enc_vcnt==13'd270))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x270)
  	//else if ((jxse_int_f_st_1d==1) && (enc_in_cnt_f==1036800))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x540)
        	tmp_tmc_enc_init_f <= 0;
 	end
   end

always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
        	tmp_tmc_enc_init_s <= 0;
 	else if (enc_sw_rst) 
        	tmp_tmc_enc_init_s <= 0;
 	else begin
  	if (m_axis_video_tuser_s) 
        	tmp_tmc_enc_init_s <= 0;
  	//else if (m_axis_video_tlast_1d & (~m_axis_video_tlast_2d) & enc_vcnt==13'd2160)  // for TMC encoder 
 	//else if ((jxse_int_st==1) & (enc_vcnt==13'd2160))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x2160)
  	//else if ((jxse_int_st==1) & (enc_vcnt==13'd270))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x270)
  	else if ((jxse_int_st_s==1) & (enc_vcnt_s==13'd2160))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x540)
  	//else if ((jxse_int_st_s==1) & (enc_in_cnt_s==1036800))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x540)
        	tmp_tmc_enc_init_s <= 1;
  	//else if (m_axis_video_tlast_3d & (~m_axis_video_tlast_4d) & enc_vcnt==13'd2160)  // for TMC encoder 
  	else if ((jxse_int_s_st_1d==1) && (enc_vcnt_s==13'd2160))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x2160)
  	//else if ((jxse_int_st_1d==1) && (enc_vcnt==13'd270))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x270)
  	//else if ((jxse_int_s_st_1d==1) && (enc_vcnt_s==13'd2160))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x540)
  	//else if ((jxse_int_s_st_1d==1) && (enc_in_cnt_s==1036800))  // for TMC encoder, Modified on 2023/12/25 by jihan (1920x540)
        	tmp_tmc_enc_init_s <= 0;
 	end
   end

 // Added on 2023/12/27 by jihan
   reg tmp_tmc_enc_init_f_en;
   reg tmp_tmc_enc_init_s_en;

   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
        	tmp_tmc_enc_init_f_en <= 0;
 	else if (enc_sw_rst) 
        	tmp_tmc_enc_init_f_en <= 0;
 	else begin
  		if (m_axis_video_tuser_f) 
        		tmp_tmc_enc_init_f_en <= 0;
  		else if (tmp_tmc_enc_init_f) 
        		tmp_tmc_enc_init_f_en <= 1;
 	end
   end

   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
        	tmp_tmc_enc_init_s_en <= 0;
 	else if (enc_sw_rst) 
        	tmp_tmc_enc_init_s_en <= 0;
 	else begin
  		if (m_axis_video_tuser_s) 
        		tmp_tmc_enc_init_s_en <= 0;
  		else if (tmp_tmc_enc_init_s) 
        		tmp_tmc_enc_init_s_en <= 1;
 	end
   end

   reg 	[17:0] 	tmc_enc_cnt_f;
   reg  [17:0]	tmc_enc_cnt_s;	

always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
		tmc_enc_cnt_f <= 0; 
 	else if (enc_sw_rst) 
		tmc_enc_cnt_f <= 0; 
 	else if (tmp_tmc_enc_init_f) begin
		tmc_enc_cnt_f <= 0; 
 	end
 	else if (~tmp_tmc_enc_init_f_en) begin 
		tmc_enc_cnt_f <= 0; 
 	end
 	else if (tmp_tmc_enc_init_f_en) begin 
  	//if (tmc_enc_cnt == 16'd8192)
  		if (tmc_enc_cnt_f == 18'd32768) // Modified on 2024/01/02 by jihan
			//tmc_enc_cnt <= 16'd8192;
			tmc_enc_cnt_f <= 18'd32768; // Modified on 2024/01/02 by jihan
  		else 
			tmc_enc_cnt_f <= tmc_enc_cnt_f + 1;
 	end
   end

   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
		tmc_enc_cnt_s <= 0; 
 	else if (enc_sw_rst) 
		tmc_enc_cnt_s <= 0; 
 	else if (tmp_tmc_enc_init_s) begin
		tmc_enc_cnt_s <= 0; 
 	end
 	else if (~tmp_tmc_enc_init_s_en) begin 
		tmc_enc_cnt_s <= 0; 
 	end
 	else if (tmp_tmc_enc_init_s_en) begin 
  	//if (tmc_enc_cnt == 16'd8192)
  		if (tmc_enc_cnt_s == 18'd32768) // Modified on 2024/01/02 by jihan
			//tmc_enc_cnt <= 16'd8192;
			tmc_enc_cnt_s <= 18'd32768; // Modified on 2024/01/02 by jihan
  		else 
			tmc_enc_cnt_s <= tmc_enc_cnt_s + 1;
 	end
   end
///////////////////////////////////////////////////////////
// For next frame
///////////////////////////////////////////////////////////
   reg 			tmc_enc_init_f		;
   reg 			tmc_enc_init_s		;
 
   reg			tmc_enc_init_or	;
   reg			tmc_enc_init_or_d	;
   reg			tmc_enc_init_and	;

    


   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
        	tmc_enc_init_f <= 0;
 	else if (enc_sw_rst) 
        	tmc_enc_init_f <= 0;
 	else if (tmp_tmc_enc_init_f_en) begin
  		//if (tmc_enc_cnt == 16'd8000)
  		//if (tmc_enc_cnt_f == 18'd3200) // Modified on 2024/01/02 by jihan
  		if (tmc_enc_cnt_f == 18'd13200) // Modified on 240717 dykim
        		tmc_enc_init_f <= 1;
  		//else  if (enc_init_cnt == 2'b11)
        else
        		tmc_enc_init_f <= 0;
 		end
   end

   always @(posedge clk_168_48 or negedge nrst_tmc) begin  
 	if (!nrst_tmc) 
        	tmc_enc_init_s <= 0;
 	else if (enc_sw_rst) 
        	tmc_enc_init_s <= 0;
 	else if (tmp_tmc_enc_init_s_en) begin
  	//if (tmc_enc_cnt == 16'd8000)
  		//if (tmc_enc_cnt_s == 18'd3200) // Modified on 2024/01/02 by jihan
  		if (tmc_enc_cnt_f == 18'd13200) // Modified on 240717 dykim
        		tmc_enc_init_s <= 1;
  		//else if (enc_init_cnt == 2'b11)
          else	
        		tmc_enc_init_s <= 0;
 		end
   end

always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	   if (!nrst_tmc) 
		   tmc_enc_init_and <= 0;
	   else
		   tmc_enc_init_and <= tmc_enc_init_f & tmc_enc_init_s;
   end   
   always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	   if (!nrst_tmc) 
		   tmc_enc_init_or <= 0;
	   else if (tmc_enc_init_or == 0) begin
		if (tmc_enc_init_f | tmc_enc_init_s)
		   tmc_enc_init_or <= 1;
   	   end
	   else if (tmc_enc_init_or == 1) begin
		if (tmc_enc_init_f | tmc_enc_init_s | tmc_enc_init_and)
		   tmc_enc_init_or <= 0;
   	   end
   end   
   always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	   if (!nrst_tmc) 
		   tmc_enc_init_or_d <= 0;
	   else
		   tmc_enc_init_or_d <= tmc_enc_init_or;
   end   

   always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	   if (!nrst_tmc) 
		   tmc_enc_init <= 0;
	   else
		   tmc_enc_init <= (!tmc_enc_init_or & tmc_enc_init_or_d);
   end   



   always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	if (!nrst_tmc) begin
		enc_in_cnt_s <= 0;
	end
	else if (enc_sw_rst) begin
		enc_in_cnt_s <= 0;
	end
	else if (tmc_enc_init_s) begin
		enc_in_cnt_s <= 0;
	end
	else if (m_axis_video_tready_s & m_axis_video_tvalid_s) begin
		enc_in_cnt_s <= enc_in_cnt_s + 1;
	end
   end
   
always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	if (!nrst_tmc) begin
		enc_in_cnt_f <= 0;
	end
	else if (enc_sw_rst) begin
		enc_in_cnt_f <= 0;
	end
	else if (tmc_enc_init_f) begin
		enc_in_cnt_f <= 0;
	end
	else if (m_axis_video_tready_f & m_axis_video_tvalid_f) begin
		enc_in_cnt_f <= enc_in_cnt_f + 1;
	end
   end

   always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	if (!nrst_tmc) begin
		enc_out_cnt_s <= 0;
	end
	else if (enc_sw_rst) begin
		enc_out_cnt_s <= 0;
	end
	else if (tmc_enc_init_s) begin
		enc_out_cnt_s <= 0;
	end
	else if (str_valid_s & str_ready_s) begin
		enc_out_cnt_s <= enc_out_cnt_s + 1;
	end
   end

always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	if (!nrst_tmc) begin
		enc_out_cnt_f <= 0;
	end
	else if (enc_sw_rst) begin
		enc_out_cnt_f <= 0;
	end
	else if (tmc_enc_init_f) begin
		enc_out_cnt_f <= 0;
	end
	else if (str_valid_f & str_ready_f) begin
		enc_out_cnt_f <= enc_out_cnt_f + 1;
	end
   end

   assign enc_in_cnt_s_ila = enc_in_cnt_s;
   assign enc_in_cnt_f_ila = enc_in_cnt_f;
   assign enc_out_cnt_s_ila = enc_out_cnt_s;
   assign enc_out_cnt_f_ila = enc_out_cnt_f;

TMC_JXSE_TOP  u0_TMC_JXSE_TOP(
     .CCLK                    ( clk_168_48        )  //
    ,.VCLK                    ( clk_168_48        )  //
    //,.HCLK                    ( hclk             )  //
    ,.HCLK		      ( clk_168_48	 )
    //,.RSTN                    ( nrst             )  //
    ,.RSTN                    ( nrst_tmc & ~enc_sw_rst             )  // Modified for tmc_test on 2023/12/11 by jihan
    //,.RSTN                    ( ~vx1_rst         )  // Modified for tmc_test on 2023/12/20 by jihan

    ///////////////////////////////////////////////////////////////////
    // Modified on 2024.02.01 by hk kim because of using two encoders
    ///////////////////////////////////////////////////////////////////
    ,.JXSE_INT                ( jxse_int_f         )  //

    ,.SHSEL                   ( hsel_hw_enc_f          )  // i select
    ,.SHREADYIN               ( 1'b1             )  // i ready
    ,.SHADDR                  ( haddr_hw_enc_f         )  // i address
    ,.SHSIZE                  ( 3'h0             )  // i data size
    ,.SHBURST                 ( 3'h0             )  // i burst type
    ,.SHPROT                  ( 4'h0             )  // i protect type
    ,.SHMASTLOCK              ( 1'h0             )  // i lock type
    ,.SHWDATA                 ( hwdata_hw_enc_f        )  // i write data
    ,.SHWRITE                 ( hwr_hw_enc_f           )  // i write
    ,.SHTRANS                 ( htrans_hw_enc_f        )  // i transfer type
    ,.SHREADYOUT              ( HREADY_OUT_enc_f       )  // o ready
    ,.SHRESP                  (                  )  // o responce
    ,.SHRDATA                 ( HRDATA_enc_f           )  // o read data

    `ifdef TMC_STRM
     ,.S_AXIS_VIDEO_DATA       ( mod_pix_in_data_f      )  // i, FR.strm_dat_conv, Modified for tmc_test on 2023/12/15 by jihan
     ,.S_AXIS_VIDEO_VALID      ( pix_en           )  // i, Modified for tmc_test on 2023/12/11 by jihan
    `else
     //,.S_AXIS_VIDEO_DATA       ( m_axis_video_tdata      )  // i 
     ,.S_AXIS_VIDEO_DATA       ( m_axis_video_tdata_f	)    // i, FR.strm_dat_conv, Modified on 2023/12/15 by jihan //modified on 2024/02/20 by KDY
     ,.S_AXIS_VIDEO_VALID      ( m_axis_video_tvalid_f	)  // i 
     //,.S_AXIS_VIDEO_VALID      ( mod_video_tvalid	)  // i, Added on 2023/12/30 by jihan
    `endif

    ,.S_AXIS_VIDEO_STRB       ( 18'h3FFFF        )  // i 
    ,.S_AXIS_VIDEO_EOL        ( 1'b0             )  // i 
    ,.S_AXIS_VIDEO_KEEP       ( 18'h3FFFF        )  // i 
    ,.S_AXIS_VIDEO_ID         ( 1'b0             )  // i 
    ,.S_AXIS_VIDEO_DEST       ( 1'b0             )  // i 
    `ifdef TMC_STRM
     ,.S_AXIS_VIDEO_READY      ( pix_ready        )  // o, Modified for tmc_test on 2023/12/11 by jihan
    `else
     ,.S_AXIS_VIDEO_READY      ( m_axis_video_tready_f     )  // o 
    `endif

    ,.S_AXIS_VIDEO_SOF        ( 1'b0             )  // i 

    ,.M_AXIS_STRM_DATA        ( str_out_f        )  // o 
    ,.M_AXIS_STRM_VALID       ( str_valid_f       )  // o 
    ,.M_AXIS_STRM_STRB        (                  )  // o 
    ,.M_AXIS_STRM_EOL         (                  )  // o 
    ,.M_AXIS_STRM_KEEP        (                  )  // o 
    ,.M_AXIS_STRM_ID          (                  )  // o 
    ,.M_AXIS_STRM_DEST        (                  )  // o 
    //,.M_AXIS_STRM_READY       ( str_ready        )  // i
    ,.M_AXIS_STRM_READY       ( str_ready_f | vio_str_ready      )  // i // modified on 2024/02/06 by YHS (1 -> str_ready_s)
    ,.M_AXIS_STRM_SOF         (                  )  // o 

);

TMC_JXSE_TOP  u1_TMC_JXSE_TOP(
     .CCLK                    ( clk_168_48        )  //
    ,.VCLK                    ( clk_168_48        )  //
    //,.HCLK                    ( hclk             )  //
    ,.HCLK	 	      ( clk_168_48	 )
    //,.RSTN                    ( nrst           )  //
    ,.RSTN                    ( nrst_tmc & ~enc_sw_rst         )  // Modified for tmc_test on 2023/12/11 by jihan
    //,.RSTN                    ( ~vx1_rst         )  // Modified for tmc_test on 2023/12/20 by jihan
   
    ///////////////////////////////////////////////////////////////////
    // Modified on 2024.02.01 by hk kim because of using two encoders
    ///////////////////////////////////////////////////////////////////
    ,.JXSE_INT                ( jxse_int_s         ) 

    ,.SHSEL                   ( hsel_hw_enc_s      )  // i select
    ,.SHREADYIN               ( 1'b1             )  // i ready
    ,.SHADDR                  ( haddr_hw_enc_s     )  // i address
    ,.SHSIZE                  ( 3'h0             )  // i data size
    ,.SHBURST                 ( 3'h0             )  // i burst type
    ,.SHPROT                  ( 4'h0             )  // i protect type
    ,.SHMASTLOCK              ( 1'h0             )  // i lock type
    ,.SHWDATA                 ( hwdata_hw_enc_s        )  // i write data
    ,.SHWRITE                 ( hwr_hw_enc_s           )  // i write
    ,.SHTRANS                 ( htrans_hw_enc_s        )  // i transfer type
    ,.SHREADYOUT              ( HREADY_OUT_enc_s       )  // o ready
    ,.SHRESP                  (                  )  // o responce
    ,.SHRDATA                 ( HRDATA_enc_s           )  // o read data

    `ifdef TMC_STRM
     ,.S_AXIS_VIDEO_DATA       ( mod_pix_in_data_s      )  // i, Modified for tmc_test on 2023/12/15 by jihan
     ,.S_AXIS_VIDEO_VALID      ( pix_en           )  // i, Modified for tmc_test on 2023/12/11 by jihan
    `else
     //,.S_AXIS_VIDEO_DATA       ( m_axis_video_tdata      )  // i 
     ,.S_AXIS_VIDEO_DATA       ( m_axis_video_tdata_s	)    // i, Modified on 2023/12/15 by jihan //modified on 2024/02/20 by KDY
     ,.S_AXIS_VIDEO_VALID      ( m_axis_video_tvalid_s	)  // i 
     //,.S_AXIS_VIDEO_VALID      ( mod_video_tvalid	)  // i, Added on 2023/12/30 by jihan
    `endif

    ,.S_AXIS_VIDEO_STRB       ( 18'h3FFFF        )  // i 
    ,.S_AXIS_VIDEO_EOL        ( 1'b0             )  // i 
    ,.S_AXIS_VIDEO_KEEP       ( 18'h3FFFF        )  // i 
    ,.S_AXIS_VIDEO_ID         ( 1'b0             )  // i 
    ,.S_AXIS_VIDEO_DEST       ( 1'b0             )  // i 
    `ifdef TMC_STRM
     ,.S_AXIS_VIDEO_READY      ( pix_ready        )  // o, Modified for tmc_test on 2023/12/11 by jihan
    `else
     ,.S_AXIS_VIDEO_READY      ( m_axis_video_tready_s     )  // o 
    `endif

    ,.S_AXIS_VIDEO_SOF        ( 1'b0             )  // i 

    ,.M_AXIS_STRM_DATA        ( str_out_s        )  // o 
    ,.M_AXIS_STRM_VALID       ( str_valid_s        )  // o 
    ,.M_AXIS_STRM_STRB        (                  )  // o 
    ,.M_AXIS_STRM_EOL         (                  )  // o 
    ,.M_AXIS_STRM_KEEP        (                  )  // o 
    ,.M_AXIS_STRM_ID          (                  )  // o 
    ,.M_AXIS_STRM_DEST        (                  )  // o 
    //,.M_AXIS_STRM_READY       ( str_ready        )  // i
    ,.M_AXIS_STRM_READY       ( str_ready_s | vio_str_ready      )  // i // modified on 2024/02/06 by YHS (1 -> str_ready_s)
    ,.M_AXIS_STRM_SOF         (                  )  // o 

); 

// AHB MASTER IP for encoder_f -----------------------------------------------------------------------
Simple_AHB_Master_enc  
#(
        /*
    	.TGT_SIZE		 (`TGT_SIZE)
    	,.PIC_WIDTH		 (`PIC_WIDTH)
    	,.PIC_HEIGHT		 (`PIC_HEIGHT)
    	,.PIC_FMT		 (`PIC_FMT)
    	,.BIT_DEPTH		 (`BIT_DEPTH)
    	,.NL_Y			 (`NL_Y)
    	,.Q_SEL			 (`Q_SEL)
    	,.ENC_PROF		 (`ENC_PROF)
    	,.ENC_LEVEL		 (`ENC_LEVEL)
    	,.ENC_SUBLEVEL		 (`ENC_SUBLEVEL)
    	*/
    	//  .TGT_SIZE     (2351250)
	 .TGT_SIZE	(1800000)
        ,.PIC_WIDTH     (3840)
        ,.PIC_HEIGHT    (1080)
        ,.PIC_FMT       (4)
        ,.BIT_DEPTH     (12)
    	
	)
U_AMBM_enc_0(
     .CLK                    ( clk_168_48        )  //
    //,.HCLK                   ( hclk             )  //
    ,.HCLK		     ( clk_168_48	)
    ,.RSTN                   ( nrst_tmc & (~enc_sw_rst) )  // Modified for tmc_test on 2023/12/24 by jihan
    ,.TMC_INIT               (tmc_enc_init )  // Modified for tmc_test on 2023/12/24 by jihan

//    ,.HRDATA_IN              ( HRDATA_enc_f         )  // i read data, Added on 2024/01/15 by jihan (TMC debug)
    ,.HREADY_OUT             ( HREADY_OUT_enc_f     )  // i ready
 
    ///////////////////////////////////////////////////////////////////
    // Modified on 2024.02.01 by hk kim because of using two encoders
    ///////////////////////////////////////////////////////////////////
    ,.INTR_IN	             ( jxse_int_f         )  // i ready
    ,.TGT_SEL	             ( vio_tgt_sel       )  // i target size
    ,.TGT_SIZE_TBL0           ( tgt_size_tbl[0]      )  // i target size
    ,.TGT_SIZE_TBL1           ( tgt_size_tbl[1]      )  // i target size
    ,.TGT_SIZE_TBL2           ( tgt_size_tbl[2]      )  // i target size
    ,.TGT_SIZE_TBL3           ( tgt_size_tbl[3]      )  // i target size
    ,.TGT_SIZE_TBL4           ( tgt_size_tbl[4]      )  // i target size
    ,.TGT_SIZE_TBL5           ( tgt_size_tbl[5]      )  // i target size
    ,.TGT_SIZE_TBL6           ( tgt_size_tbl[6]      )  // i target size
    ,.TGT_SIZE_TBL7           ( tgt_size_tbl[7]      )  // i target size
    ,.NL_SEL	             ( vio_nl_sel       )  // i target size
    ,.DEPTH_SEL	             ( vio_pdepth_sel   )  // i target size
    ,.DSIZE	             ( enc_dsize        )  // o data size
    ,.GTY_INIT	             ( gty_init_l0         )  // o init gty

    ,.HSEL                   (hsel_hw_enc_f )  // o select
    ,.HREADYIN               ()  // o ready
    ,.HADDR                  (haddr_hw_enc_f )  // o address
    ,.HSIZE                  ( )  // o data size
    ,.HBURST                 ( )  // o burst type
    ,.HPROT                  ( )  // o protect type
    ,.HMASTLOCK              ( )  // o lock type
    ,.HWDATA                 (hwdata_hw_enc_f )  // o write data
    ,.HWRITE                 (hwr_hw_enc_f )  // o write
    ,.HTRANS                 (htrans_hw_enc_f )  // o transfer type

);

// AHB MASTER IP for encoder_s -----------------------------------------------------------------------
Simple_AHB_Master_enc  
#(
/*
    	.TGT_SIZE		 (`TGT_SIZE)
    	,.PIC_WIDTH		 (`PIC_WIDTH)
    	,.PIC_HEIGHT		 (`PIC_HEIGHT)
    	,.PIC_FMT		 (`PIC_FMT)
    	,.BIT_DEPTH		 (`BIT_DEPTH)
    	,.NL_Y			 (`NL_Y)
    	,.Q_SEL			 (`Q_SEL)
    	,.ENC_PROF		 (`ENC_PROF)
    	,.ENC_LEVEL		 (`ENC_LEVEL)
    	,.ENC_SUBLEVEL		 (`ENC_SUBLEVEL)
    	*/
	 .TGT_SIZE	(1800000)
    	,.PIC_WIDTH     (3840)
    	,.PIC_HEIGHT    (1080)
    	,.PIC_FMT       (4)
    	,.BIT_DEPTH     (12)
	)
U_AMBM_enc_1(
     .CLK                    ( clk_168_48        )  //
    //,.HCLK                   ( hclk             )  //
    ,.HCLK		     ( clk_168_48	)
    ,.RSTN                   ( nrst_tmc & (~enc_sw_rst) )  // Modified for tmc_test on 2023/12/24 by jihan
    ,.TMC_INIT               (tmc_enc_init )  // Modified for tmc_test on 2023/12/24 by jihan

//    ,.HRDATA_IN              ( HRDATA_enc_s         )  // i read data, Added on 2024/01/15 by jihan (TMC debug)
    ,.HREADY_OUT             ( HREADY_OUT_enc_s     )  // i ready
    
    ///////////////////////////////////////////////////////////////////
    // Modified on 2024.02.01 by hk kim because of using two encoders
    ///////////////////////////////////////////////////////////////////
    ,.INTR_IN	             ( jxse_int_s         )  // i ready
    ,.TGT_SEL	             ( vio_tgt_sel       )  // i target size
    ,.TGT_SIZE_TBL0           ( tgt_size_tbl[0]      )  // i target size
    ,.TGT_SIZE_TBL1           ( tgt_size_tbl[1]      )  // i target size
    ,.TGT_SIZE_TBL2           ( tgt_size_tbl[2]      )  // i target size
    ,.TGT_SIZE_TBL3           ( tgt_size_tbl[3]      )  // i target size
    ,.TGT_SIZE_TBL4           ( tgt_size_tbl[4]      )  // i target size
    ,.TGT_SIZE_TBL5           ( tgt_size_tbl[5]      )  // i target size
    ,.TGT_SIZE_TBL6           ( tgt_size_tbl[6]      )  // i target size
    ,.TGT_SIZE_TBL7           ( tgt_size_tbl[7]      )  // i target size
    ,.NL_SEL	             ( vio_nl_sel       )  // i target size
    ,.DEPTH_SEL	             ( vio_pdepth_sel   )  // i target size
    ,.DSIZE	             ( )  // o data size
    ,.GTY_INIT	             ( gty_init_l1 )  // o init gty


    ,.HSEL                   (hsel_hw_enc_s )  // o select
    ,.HREADYIN               ( )  // o ready
    ,.HADDR                  (haddr_hw_enc_s )  // o address
    ,.HSIZE                  ( )  // o data size
    ,.HBURST                 ( )  // o burst type
    ,.HPROT                  ( )  // o protect type
    ,.HMASTLOCK              ( )  // o lock type
    ,.HWDATA                 (hwdata_hw_enc_s )  // o write data
    ,.HWRITE                 (hwr_hw_enc_s )  // o write
    ,.HTRANS                 (htrans_hw_enc_s )  // o transfer type

);

// Added on 2023/12/24 by hk kim for ILA
wire [31:0] gty_tx_userdata_out_ILA;
wire mask_encoder_ILA;
//assign mask_encoder_ILA = mask_encoder;
// DIP Switch masking
// Added on 2023/12/26 by hk kim

    wire 		gty_str_valid;
    wire [127:0] 	gty_str_out;
    reg 		mask_encoder_f;
    reg 		mask_encoder_s;
    always @(posedge clk_168_48 or negedge nrst_gty)
    begin
	if(!nrst_gty) begin
	   mask_encoder_f <= 0;
	end
	else if(enc_sw_rst) begin
	   mask_encoder_f <= 0;
	end
	//else if(jxse_int_f & vio_mask) begin
	else if(jxse_int_f) begin
	   mask_encoder_f <= 1;
    	end
    end
    always @(posedge clk_168_48 or negedge nrst_gty)
    begin
	if(!nrst_gty) begin
	   mask_encoder_s <= 0;
	end
	else if(enc_sw_rst) begin
	   mask_encoder_s <= 0;
	end
	//else if(jxse_int_s & vio_mask) begin
	else if(jxse_int_s) begin
	   mask_encoder_s <= 1;
    	end
    end
    //assign gty_str_out  = mask_encoder ? (str_out) : 0;
    //assign gty_str_valid = mask_encoder ? (str_valid) : 0;
    
 // **************** modified 24/05/17
    assign gty_str_valid_f = mask_encoder_f ? (str_valid_f) : 0;
    assign gty_str_valid_s = mask_encoder_s ? (str_valid_s) : 0;
    assign gty_str_out_f = mask_encoder_f ? (str_out_f) : 0;
    assign gty_str_out_s = mask_encoder_s ? (str_out_s) : 0;

// TMC IP to MAC to GTY connect ----------------------------------------------------------------------
wire [31:0] tmc2mac_dout;
wire tmc2mac_valid;

wire m_axis_tvalid_enc;
wire m_axis_tready_enc;
wire [3:0] m_axis_tkeep_enc;
wire m_axis_tlast_enc;
wire [31:0] m_axis_tdata_enc;

`ifdef GTY
wire [31:0] m_axis_tdata_phy;
wire [3:0] m_axis_tkeep_phy;
wire m_axis_tvalid_phy;
wire m_axis_tready_phy;
wire m_axis_tlast_phy;
wire m_axis_sof;

wire [31:0] s_axis_tdata_phy;
wire [3:0] s_axis_tkeep_phy;
wire s_axis_tvalid_phy;
wire s_axis_tready_phy;
wire s_axis_tlast_phy;
`else
`endif 
wire gty_reset_tx_done;
wire gty_reset_rx_done;
wire gty_txusrclk;
wire gty_rxusrclk;

wire mac_trans_ready;
wire mac_trans_ready_sync;

wire [19:0] mac_payload_size;
wire [19:0] mac_frame_size; // from mac_if

`ifdef MCU_AHB
wire enc_start_sync;
bit_sync #(.INITIALIZE(5'b00000)) i_bit_sync_cpu_gpo (
    .clk_in (clk_168_48),
    .i_in (cpu_gpo[0]),
    .o_out (enc_start_sync)
);
`else
`endif

tmc2mac i_tmc2mac (
    .nrst(nrst_tmc), 
    .frst(~nrst_tmc), 
    `ifdef MCU_AHB
    .init(enc_start_sync), 
    `else    
    //.init(m_axis_video_tuser_f), 
    .init(gty_init_l0), 
    `endif
    .dmax(enc_dsize), 
    .clk(clk_168_48), 
    .rclk(clk_168_48), 
    .din_valid_l0(str_valid_f), 
    .din_l0(str_out_f), 
    .din_valid_l1(str_valid_s), 
    .din_l1(str_out_s), 
    .din_ready_l0(str_ready_f), 
    .din_ready_l1(str_ready_s), 
    .dout(tmc2mac_dout), 
    .dout_valid(tmc2mac_valid)
    );
    

//-------------------------------------------------------------------
// Audio
//-------------------------------------------------------------------
`ifdef AUD
clk_wiz_2 u_clk_wiz_2(
	.clk_out1(i2s_clk), // 61.44MHz
  .clk_in1(axi_clk)); // 100MHz

i2s_reset i2s_reset_0(
  .clk24_576(i2s_clk),
	.freeclk(FPGA_50Mhz),
	.vio_i2s_resetn(vio_i2s_resetn), // 05.30 by kmch

	.nrst_i2s(nrst_i2s), // 05.30 by kmch
	.i2s_rst_cnt_out()
);  

always @(posedge clk_168_48 or negedge nrst_gty) begin
    
    if (!nrst_gty) begin
        in_rd_en_aud <= 0;
        in_rd_en_aud_cnt <= 0;
    end
    else begin
        `ifdef MCU_AHB 
        if (enc_start_sync) begin
        `else
        if (gty_init_l0) begin
        `endif
            in_rd_en_aud_cnt <= 0;
            in_rd_en_aud <= 1;
        end
        else if(in_rd_en_aud_cnt == 'd6) begin
            in_rd_en_aud_cnt <= in_rd_en_aud_cnt;
        end
        else
            in_rd_en_aud_cnt <= in_rd_en_aud_cnt + 1;
        
        if (in_rd_en_aud_cnt == 'd5)
            in_rd_en_aud <= 0;
    
    end
end

bit_sync #(.INITIALIZE(5'b00000)) i_bit_aud_rd_en (
    .clk_in (i2s_clk),
    .i_in (in_rd_en_aud),
    .o_out (in_rd_en_aud_sync)
);

myI2S_Rx_gty #(
    .DATA_WIDTH(32),
    .DEPTH(8),
    .PTR_WIDTH(3)
    )
    myI2S_Rx_0 (
        .mclk(i2s_clk),
        .rst(!nrst_i2s),

        .bclk(bclk_in), // input, serial clock
        .lrclk(lrclk_in), // input, word select
        .sdata(sdata_in), // input, serial data        
        
        .in_wr_en_aud(in_rd_en_aud_sync),
        .wr_fifo_en(aud_do_en),
        .wr_fifo_data(aud_do),
        .init_i2s(init_aud),
        .rst_2(rst_aud_tx)      
);

`else
assign i2s_clk = 1'b0;
assign aud_do_en = 1'b0;
assign aud_do = 32'h0;
`endif

//-------------------------------------------------------------------
// MAC interface
//-------------------------------------------------------------------
//wire [11:0] video_fifo_rd_count;

mac_tx_if i_mac_tx_if (
  .clk (gty_txusrclk),
  .rstn (nrst_tmc),
  .mac_trans_ready (mac_trans_ready),
  .mac_payload_size (mac_payload_size), // should be greater than 8bytes 
  .mac_frame_size (mac_frame_size),
  .tgt_size (enc_dsize[23:0]),

  .audio_tp_en (vio_tx_tpg_en[1]), 
  .frame_start (m_axis_video_tuser_f), // clk_vid domain
  .frame_end (jxse_int_f), // clk_vid domain
  //.video_fifo_rd_count (video_fifo_rd_count),

  .clk_vid (clk_168_48),
  .video_di_en (tmc2mac_valid),
  .video_di (tmc2mac_dout),

  .clk_aud (i2s_clk),
  .audio_di_en (aud_do_en),
  .audio_di (aud_do),

  .m_axis_tvalid (m_axis_tvalid_enc),
  .m_axis_tdata (m_axis_tdata_enc),
  .m_axis_tkeep (m_axis_tkeep_enc),
  .m_axis_tlast (m_axis_tlast_enc),
  .m_axis_tready (m_axis_tready_enc)

);

bit_sync #(.INITIALIZE(5'b00000)) i_bit_sync_mac_ready (
    .clk_in (clk_168_48),
    .i_in (mac_trans_ready),
    .o_out (mac_trans_ready_sync)
);

// wigig_mac_top_encoder ----------------------------------  
  wigig_mac_top #(
.DATA_WIDTH (32)) i_wigig_mac_top (

    .clk (gty_txusrclk),
    .rstn (nrst_gty),

    .mac_trans_ready (mac_trans_ready),
    //.payload_fifo_rcnt (axis_rd_data_count[19:0]),
    .mac_payload_size (mac_payload_size),
    .mac_frame_size (mac_frame_size),    
    
    // from Encoder
    .tx_s_axis_tdata (m_axis_tdata_enc),
    .tx_s_axis_tkeep (m_axis_tkeep_enc),
    .tx_s_axis_tvalid (m_axis_tvalid_enc),
    .tx_s_axis_tlast (m_axis_tlast_enc),
    .tx_s_axis_tready (m_axis_tready_enc),
  
    // to Decoder
    .rx_m_axis_tdata (),
    .rx_m_axis_tkeep (),
    .rx_m_axis_tvalid (),
    .rx_m_axis_tlast (),
    .rx_m_axis_tready (0),

    // to PHY or GTY
    .tx_m_axis_tdata (m_axis_tdata_phy),
    .tx_m_axis_tkeep (m_axis_tkeep_phy),
    .tx_m_axis_tvalid (m_axis_tvalid_phy),
    .tx_m_axis_tlast (m_axis_tlast_phy),
    .tx_m_axis_tready (m_axis_tready_phy), // if simulation system has no decoder, ready signal should be '1'
    .tx_m_axis_sof (m_axis_sof),

    // from PHY or GTY
    .rx_s_axis_tdata (s_axis_tdata_phy),
    .rx_s_axis_tkeep (s_axis_tkeep_phy),
    .rx_s_axis_tvalid (s_axis_tvalid_phy),
    .rx_s_axis_tlast (s_axis_tlast_phy),
    .rx_s_axis_tready (s_axis_tready_phy),   
  
    // AXI4-Lite
    .s_axi_clk (axi_clk),
    .s_axi_resetn (axi_resetn),

    .s_axi_awaddr (mac_axi_awaddr),
    .s_axi_awvalid (mac_axi_awvalid),
    .s_axi_awready (mac_axi_awready),
    .s_axi_awprot (mac_axi_awprot),

    .s_axi_wdata (mac_axi_wdata),
    .s_axi_wvalid (mac_axi_wvalid),
    .s_axi_wready (mac_axi_wready),
    .s_axi_wstrb (mac_axi_wstrb),

    .s_axi_bresp (mac_axi_bresp),
    .s_axi_bvalid (mac_axi_bvalid),
    .s_axi_bready (mac_axi_bready),

    .s_axi_araddr (mac_axi_araddr),
    .s_axi_arvalid (mac_axi_arvalid),
    .s_axi_arready (mac_axi_arready),
    .s_axi_arprot (mac_axi_arprot),

    .s_axi_rdata (mac_axi_rdata),
    .s_axi_rresp (mac_axi_rresp),
    .s_axi_rvalid (mac_axi_rvalid),
    .s_axi_rready (mac_axi_rready),

    .rf_beam_set_req_sync (rf_beam_set_req)

);
`ifdef GTY 
gty_top u_gty_top (
    .nrst(nrst_gty),
    .pclk(gty_clk_p),    
    .nclk(gty_clk_n),    
    .fclk(FPGA_50MHz),    

    .gtytxp(gty_txp_out), // output
    .gtytxn(gty_txn_out),
    .gtyrxp(gty_rxp_in), // input
    .gtyrxn(gty_rxn_in), // input  

    .gty_txusrclk (gty_txusrclk),
    .gty_rxusrclk (gty_rxusrclk),

    .gtwiz_reset_tx_done_int (gty_reset_tx_done),
    .gtwiz_reset_rx_done_int (gty_reset_rx_done),

    .m_axis_tdata_phy (m_axis_tdata_phy),
    .m_axis_tkeep_phy (m_axis_tkeep_phy),
    .m_axis_tvalid_phy (m_axis_tvalid_phy),
    .m_axis_tlast_phy (m_axis_tlast_phy),
    .m_axis_tready_phy (m_axis_tready_phy),    

    .m_axis_tdata_dec (s_axis_tdata_phy),
    .m_axis_tkeep_dec (s_axis_tkeep_phy),
    .m_axis_tvalid_dec (s_axis_tvalid_phy),
    .m_axis_tlast_dec (s_axis_tlast_phy),
    .m_axis_tready_dec (s_axis_tready_phy)
  
  );
`else
`endif 
assign tmc_enc_init_out = tmc_enc_init;

// Frame count debugging
   reg time_stamp_en_f;

   always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	if (!nrst_tmc) begin
		time_stamp_en_f	<= 0;
	end
	else if (enc_sw_rst) begin
		time_stamp_en_f	<= 0;
	end
	else if (tmc_enc_init_f) begin
		time_stamp_en_f 	<= 1;
	end
   end
   reg  [31:0] time_stamp_f;

   always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	if (!nrst_tmc) begin
		time_stamp_f	<= 0;
	end
	else if (enc_sw_rst) begin
		time_stamp_f	<= 0;
	end
	else if (time_stamp_en_f) begin
		if (tmc_enc_init_f)
			time_stamp_f 	<= 0;
		else 
			time_stamp_f	<= time_stamp_f + 1;
	end
   end

   reg time_stamp_en_s;
   
   always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	if (!nrst_tmc) begin
		time_stamp_en_s	<= 0;
	end
	else if (enc_sw_rst) begin
		time_stamp_en_s	<= 0;
	end
	else if (tmc_enc_init_s) begin
		time_stamp_en_s 	<= 1;
	end
   end
   reg  [31:0] time_stamp_s;

   always @(posedge clk_168_48 or negedge nrst_tmc)
   begin
	if (!nrst_tmc) begin
		time_stamp_s	<= 0;
	end
	else if (enc_sw_rst) begin
		time_stamp_s	<= 0;
	end
	else if (time_stamp_en_s) begin
		if (tmc_enc_init_s)
			time_stamp_s 	<= 0;
		else 
			time_stamp_s	<= time_stamp_s + 1;
	end
   end


   reg time_stamp_en_vs;

always @(posedge clk_168_48 or posedge vx1_rst)
   begin
	if (vx1_rst) begin
		time_stamp_en_vs	<= 0;
	end
	else if (vx1_tx_vs_148_1d) begin
		time_stamp_en_vs 	<= 1;
	end
   end
   reg  [31:0] time_stamp_vs;

   always @(posedge clk_168_48 or posedge vx1_rst)
   begin
	if (vx1_rst) begin
		time_stamp_vs	<= 0;
	end
	else if (time_stamp_en_vs) begin
		if (vx1_tx_vs_148_1d & !vx1_tx_vs_148_2d)
			time_stamp_vs 	<= 0;
		else 
			time_stamp_vs	<= time_stamp_vs + 1;
	end
   end

reg [31:0] rpt_incntf_ts;
   reg [31:0] rpt_incnts_ts;
   reg [31:0] rpt_outcntf_ts;
   reg [31:0] rpt_outcnts_ts;
   reg [31:0] rpt_intf_ts;
   reg [31:0] rpt_ints_ts;
   reg [31:0] rpt_gtyinit_ts;
   always @(posedge clk_168_48 or posedge vx1_rst)
   begin
	if (vx1_rst) begin
		rpt_incntf_ts	<= 0;
		rpt_incnts_ts	<= 0;
		rpt_outcntf_ts	<= 0;
		rpt_outcnts_ts	<= 0;
		rpt_gtyinit_ts	<= 0;
		rpt_intf_ts	<= 0;
		rpt_ints_ts	<= 0;
	end
	else begin
		if ((enc_in_cnt_f == 1) & m_axis_video_tready_f) 
			rpt_incntf_ts 	<= time_stamp_vs;
		if ((enc_in_cnt_s == 1) & m_axis_video_tready_s) 
			rpt_incnts_ts 	<= time_stamp_vs;
		if ((enc_out_cnt_f == vio_outc) & str_out_f) 
			rpt_outcntf_ts 	<= time_stamp_vs;
		if ((enc_out_cnt_s == vio_outc) & str_out_s) 
			rpt_outcnts_ts 	<= time_stamp_vs;
		if (gty_init_l0) 
			rpt_gtyinit_ts 	<= time_stamp_vs;
		if (jxse_int_f) 
			rpt_intf_ts 	<= time_stamp_vs;
		if (jxse_int_s) 
			rpt_ints_ts 	<= time_stamp_vs;
	end
   end
   assign time_stamp_f_ILA = time_stamp_f;
   assign time_stamp_s_ILA = time_stamp_s;
   assign time_stamp_vs_ILA = time_stamp_vs;
   assign rpt_ts_ILA	= {14'd0, tmc_enc_cnt_s, 14'd0, tmc_enc_cnt_f, rpt_gtyinit_ts, rpt_ints_ts,
	   			rpt_intf_ts, rpt_outcnts_ts, rpt_outcntf_ts,
				rpt_incnts_ts, rpt_incntf_ts};
				
always @(posedge clk_168_48 or posedge vx1_rst)
   begin
	if (vx1_rst) begin
		frame_cnt	<= 0;
	end
	else if (vx1_tx_vs_148_1d & !vx1_tx_vs_148_2d) begin
		frame_cnt 	<= frame_cnt + 1;
	end
   end

   always @(posedge clk_168_48 or negedge nrst_tmc ) begin // Modified on 2024/01/06 by jihan
	    if (!nrst_tmc)
		enc_sw_rst_cnt <= 0;
	    else if (enc_sw_rst)
		enc_sw_rst_cnt <= enc_sw_rst_cnt + 1;
	    else
		enc_sw_rst_cnt <= 0;
   end
    

   reg [2:0] tgt_sel_1d;
   reg [2:0] tgt_sel_2d;
   reg param_change;

   always @(posedge clk_168_48 or negedge nrst_tmc ) begin // Modified on 2024/01/06 by jihan
	   if (!nrst_tmc) begin
		tgt_sel_1d <= 0;
		tgt_sel_2d <= 0;
		param_change <= 0;
	   end
	   else begin
		tgt_sel_1d <= vio_tgt_sel;
		tgt_sel_2d <= tgt_sel_1d;
		if (vio_param_rst_en & (tgt_sel_1d != tgt_sel_2d))
		    param_change <= 1;
	        else
		    param_change <= 0;
	   end
   end
	
   assign param_change_ILA = param_change;
   
   always @(posedge clk_168_48 or negedge nrst_tmc ) begin // Modified on 2024/01/06 by jihan
	    if (!nrst_tmc)
		enc_sw_rst <= 0;
	    //else if ((enc_in_cnt_f == 8) & (!str_ready_f | !str_ready_s)) 
	    else if (vio_sw_rst_en) begin
		   if  (param_change | ((time_stamp_f > 1240000) | (time_stamp_s > 1240000))) 
		   //if  ((int_f_cnt > 1200000) | (int_s_cnt > 1200000)) 
			enc_sw_rst <= 1;
	    	   else if (enc_sw_rst_cnt == 10000)
			enc_sw_rst <= 0;
	    end
	    else
		enc_sw_rst <= 0;
    end

   always @(posedge clk_168_48 or negedge nrst_tmc ) begin // Modified on 2024/01/06 by jihan
	    if (!nrst_tmc)
		int_f_cnt <= 0;
	    else if (enc_in_cnt_f == 1 & int_f_cnt == 0)
		int_f_cnt <= 1;
	    else if (int_f_cnt > 0) begin
	    	if (jxse_int_f == 1)
			int_f_cnt <= 0;
		else
			int_f_cnt <= int_f_cnt + 1;
	    end
   end
   always @(posedge clk_168_48 or negedge nrst_tmc ) begin // Modified on 2024/01/06 by jihan
	    if (!nrst_tmc)
		int_s_cnt <= 0;
	    else if (enc_in_cnt_s == 1 & int_s_cnt == 0)
		int_s_cnt <= 1;
	    else if (int_s_cnt > 0) begin
	    	if (jxse_int_s == 1)
			int_s_cnt <= 0;
		else
			int_s_cnt <= int_s_cnt + 1;
	    end
   end


endmodule