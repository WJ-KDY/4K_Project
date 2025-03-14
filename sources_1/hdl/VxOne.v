//`define DEBUG
module vx1_link #(
    parameter SIMULATION    = 0,
    parameter PIXCBITWIDTH	= 4,
    parameter PIXDBITWIDTH  = 32,
    parameter PHYCBITWIDTH  = 4,
    parameter PHYDBITWIDTH  = 32,
    parameter CTLDBITWIDTH  = 16,
    parameter CH_NUM = 32,
    parameter DW     = 32,
    parameter SYNC_POLARITY = 0,
    parameter AL            = 16)(
    FPGA_50MHz , // freerun clock

    gt_qpll1lock_in,
    tx_usrclk,  rx_usrclk,
    vx1_rst,   ddr_rst,	frc_rst,vx1_rst_tx,
    gtwiz_reset_tx_done_in,    gtwiz_reset_rx_done_in,    gt_rxbyteisaligned_in,
    gtwiz_userdata_tx_out,     gt_txcharisk_out,
    gtwiz_userdata_rx_in,      gt_rxcharisk_in,    gt_rxdisperr_in,    gt_rxnotintable_in,  gt_rxreset_out,

    PLL_LOCK,SYNC_LOCK,
    RX_LOCKN,           RX_HPDN,    RX_TRN_DONE,    TX_LOCKN,    TX_HPDN,
    vx1_rx_out_de,  vx1_rx_out_hs,  vx1_rx_out_vs,  vx1_rx_out_data,
    vx1_tx_in_de,   vx1_tx_in_hs,   vx1_tx_in_vs,    vx1_tx_in_data,
    vx1_pclk,vx1_rx_vs_ref,vx1_rx_de_ref);

localparam CN = CH_NUM;
localparam MC = 0;

input  FPGA_50MHz ; 

input [CH_NUM/4-1:0]    gt_qpll1lock_in;
input                   tx_usrclk;
input                   rx_usrclk;
input                   vx1_rst;
input                   ddr_rst;
input					frc_rst;
input					vx1_rst_tx;

input                   gtwiz_reset_tx_done_in;
input                   gtwiz_reset_rx_done_in;
input   [CH_NUM-1:0]    gt_rxbyteisaligned_in;

output  [DW*CH_NUM-1:0]             gtwiz_userdata_tx_out;
output  [PIXCBITWIDTH*CH_NUM-1:0]   gt_txcharisk_out;

input   [DW*CH_NUM-1:0]               gtwiz_userdata_rx_in;
input   [PIXCBITWIDTH*CH_NUM-1:0]     gt_rxcharisk_in;
input   [PIXCBITWIDTH*CH_NUM-1:0]     gt_rxdisperr_in;
input   [PIXCBITWIDTH*CH_NUM-1:0]     gt_rxnotintable_in;
output	[CH_NUM-1:0]	              gt_rxreset_out;
input   PLL_LOCK ;
input   SYNC_LOCK ;
output  RX_LOCKN ;
output  RX_HPDN ;
output  RX_TRN_DONE ;
input   TX_LOCKN ;
input   TX_HPDN;

output  [   CH_NUM-1:0] vx1_rx_out_de;
output  [   CH_NUM-1:0] vx1_rx_out_hs;
output  [   CH_NUM-1:0] vx1_rx_out_vs;
output  [DW*CH_NUM-1:0] vx1_rx_out_data;

input   [   CH_NUM-1:0] vx1_tx_in_de;
input   [   CH_NUM-1:0] vx1_tx_in_hs;
input   [   CH_NUM-1:0] vx1_tx_in_vs;
input   [DW*CH_NUM-1:0] vx1_tx_in_data;
input                   vx1_pclk;
output					vx1_rx_vs_ref;
output 					vx1_rx_de_ref;

wire  [   CH_NUM-1:0]   vx1_rx_de;
wire  [   CH_NUM-1:0]   vx1_rx_hs;
wire  [   CH_NUM-1:0]   vx1_rx_vs;
wire  [DW*CH_NUM-1:0]   vx1_rx_data;
wire  [   CH_NUM-1:0]   vx1_tx_de;
wire  [   CH_NUM-1:0]   vx1_tx_hs;
wire  [   CH_NUM-1:0]   vx1_tx_vs;
wire  [DW*CH_NUM-1:0]   vx1_tx_data;

wire  [   CH_NUM-1:0]   vx1_rx_buf_de;
wire  [   CH_NUM-1:0]   vx1_rx_buf_hs;
wire  [   CH_NUM-1:0]   vx1_rx_buf_vs;
wire  [DW*CH_NUM-1:0]   vx1_rx_buf_data;

wire  [   CH_NUM-1:0]   vx1_tx_buf_de;
wire  [   CH_NUM-1:0]   vx1_tx_buf_hs;
wire  [   CH_NUM-1:0]   vx1_tx_buf_vs;
wire  [DW*CH_NUM-1:0]   vx1_tx_buf_data;

assign vx1_rx_vs_ref =	vx1_rx_vs[0];
assign vx1_rx_de_ref =  vx1_rx_de[0];

genvar i;
generate for (i=0; i<CH_NUM; i=i+1) begin : tx_sync_loop
assign vx1_tx_buf_hs[i]   =  0;    
assign vx1_tx_buf_vs[i]   =  vx1_tx_in_vs[i];    
end
endgenerate
assign vx1_tx_buf_de    =  vx1_tx_in_de;
assign vx1_tx_buf_data  =  vx1_tx_in_data;

generate for (i=0; i<CH_NUM; i=i+1) begin : rx_sync_loop
assign vx1_rx_out_hs[i]    =  vx1_rx_buf_hs[i];
assign vx1_rx_out_vs[i]    =  vx1_rx_buf_vs[i];    
end
endgenerate
assign vx1_rx_out_de    =  vx1_rx_buf_de;
assign vx1_rx_out_data  =  vx1_rx_buf_data;

reg     PLL_LOCK_S         = 0;
always @ (posedge FPGA_50MHz)
begin
   PLL_LOCK_S<= PLL_LOCK;
end

wire [CH_NUM-1	:0]		o_htpdn;
wire [CH_NUM-1	:0]		o_lockn;
wire [CH_NUM-1	:0]		o_trn_align_doen;
wire [CH_NUM-1  :0]     i_plllock;

wire	rx_mmcm_lock	; // activ low
assign  rx_mmcm_lock = ~vx1_rst;
generate for (i=0; i<CH_NUM; i=i+1) begin : plllock_loop
	assign i_plllock[i] = gt_qpll1lock_in[i/4];
end 
endgenerate

vx1_rx_sub #(   
    .SIMULATION     (SIMULATION     ),
    .PIXCBITWIDTH   (PIXCBITWIDTH   ),
    .PIXDBITWIDTH   (PIXDBITWIDTH   ),
    .PHYDBITWIDTH   (PHYDBITWIDTH   ),
    .PHYCBITWIDTH   (PHYCBITWIDTH   ),
    .CTLDBITWIDTH   (CTLDBITWIDTH   ),
    .RX_CH_NUM      (CH_NUM         )) 
vx1_rx_link(
    .EXT_PLL_LOCKN      (~PLL_LOCK_S	),    //active low
    .RXMMCM_LOCK        (rx_mmcm_lock	),     //actvie low
    .GT_RXRESET_OUT     (gt_rxreset_out	),
    
    .RXPHYCLK           (rx_usrclk		),
    .RXPCLK             (rx_usrclk   	),
    .FREERUN_CLK        (FPGA_50MHz	    ),
    
    .VSYNC_OUT          (vx1_rx_vs  ),
    .HSYNC_OUT          (vx1_rx_hs  ),
    .DE_OUT             (vx1_rx_de	),
    .PIXDATA_OUT        (vx1_rx_data),
    
    .HTPDN_OUT          (o_htpdn		  ),
    .LOCKN_OUT          (o_lockn		  ),
    .TRN_ALIGN_DONE     (o_trn_align_doen ),
    
    .RXRESETDONE_IN     (gtwiz_reset_rx_done_in),		
    .RXPLLLOCK_IN       (i_plllock			    ),		
    .RXBYTEISALIGNED_IN (gt_rxbyteisaligned_in	),
    .RXNOTINTABLE_IN    (gt_rxnotintable_in		),
    .RXDISPERR_IN       (gt_rxdisperr_in		),
    .RXPHYCDATA_IN      (gt_rxcharisk_in		),
    .RXPHYDATA_IN       (gtwiz_userdata_rx_in	)
    );

rx_align_buff #(
.DW(32),.DP(16),.CN(32),.MC(0))
vx1_rx_align_buff(
    .vid_i_e        (vx1_rx_de),
    .vid_i_h        (vx1_rx_hs),
    .vid_i_v        (vx1_rx_vs),
    .vid_i_d        (vx1_rx_data),
    .vid_o_e        (vx1_rx_buf_de),
    .vid_o_h        (vx1_rx_buf_hs),
    .vid_o_v        (vx1_rx_buf_vs),
    .vid_o_d        (vx1_rx_buf_data),
    .wr_clk         (rx_usrclk),
    .rd_clk         (vx1_pclk),
    .rst            (ddr_rst)); 


//reg  [   CH_NUM-1:0]   vx1_rx_buf_de_s;
//reg  [   CH_NUM-1:0]   vx1_rx_buf_hs_s;
//reg  [   CH_NUM-1:0]   vx1_rx_buf_vs_s;
//reg  [DW*CH_NUM-1:0]   vx1_rx_buf_data_s;

//always @(posedge vx1_pclk)begin
//	vx1_rx_buf_de_s		<= vx1_rx_de;
//	vx1_rx_buf_hs_s		<= vx1_rx_hs;
//	vx1_rx_buf_vs_s		<= vx1_rx_vs;
//	vx1_rx_buf_data_s	<= vx1_rx_data;
//end

//assign	vx1_rx_buf_de	= vx1_rx_buf_de_s;
//assign	vx1_rx_buf_hs	= vx1_rx_buf_hs_s;
//assign	vx1_rx_buf_vs	= vx1_rx_buf_vs_s;
//assign	vx1_rx_buf_data	= vx1_rx_buf_data_s;


reg     RX_HTPDN_S      = 0;
reg     RX_LOCKN_S      = 0;
reg     RX_TRN_DONE_S   = 0;
always @ (posedge FPGA_50MHz) 
begin 	
    RX_HTPDN_S      <= |o_htpdn[AL-1:0];
    RX_LOCKN_S      <= |o_lockn[AL-1:0];
    RX_TRN_DONE_S   <= &o_trn_align_doen[AL-1:0];
end 
assign RX_LOCKN     =   RX_LOCKN_S ;
assign RX_HPDN 	    =   RX_HTPDN_S ;
assign RX_TRN_DONE  =   RX_TRN_DONE_S;

reg     TX_HTPDN        = 1;

always @ (posedge FPGA_50MHz)
begin
    TX_HTPDN   <= TX_HPDN;
end

wire	tx_mmcm_lock; // activ low
assign  tx_mmcm_lock = ~(vx1_rst | ~gtwiz_reset_tx_done_in) & PLL_LOCK;

assign vx1_tx_de    =  ~vx1_tx_in_de[MC]	?	0	:	{CN{1'b1}};
assign vx1_tx_hs    =  0;
assign vx1_tx_vs    =  vx1_tx_in_de[MC]	?	0	:	{CN{vx1_tx_in_vs[MC]}};
assign vx1_tx_data  =  ~vx1_tx_in_de[MC] 	?	0	:	vx1_tx_in_data;


vx1_tx_sub #( 
    .SIMULATION					(SIMULATION					),
    .PIXCBITWIDTH				(PIXCBITWIDTH				),
    .PIXDBITWIDTH 				(PIXDBITWIDTH				),
    .PHYDBITWIDTH 				(PHYDBITWIDTH				),
    .PHYCBITWIDTH 				(PHYCBITWIDTH				),
    .CTLDBITWIDTH				(CTLDBITWIDTH				),
    .TX_CH_NUM     			    (CH_NUM                     )) 
vx1_tx_link(
    .TXMMCM_LOCK                (tx_mmcm_lock               ),
    
    .TXPHYCLK					(tx_usrclk					),
    .TXPCLK						(tx_usrclk         			),
    .FREERUN_CLK				(FPGA_50MHz                 ),
    
    .VSYNC_IN					(vx1_tx_vs               ),
    .HSYNC_IN					(vx1_tx_hs               ),
    .DE_IN						(vx1_tx_de	            ),
    .PIXDATA_IN					(vx1_tx_data             ),
    
    .CTLDATA_IN					(0                          ),
    
    .HTPDN						({CN{TX_HTPDN}}              ),
    .LOCKN						({CN{TX_LOCKN}}              ),
    
    .TXRESETDONE_IN				(gtwiz_reset_tx_done_in     ),
    .TXPLLLOCK_IN				(i_plllock				    ),
    
    .TXPHYDATA_OUT              (gtwiz_userdata_tx_out       ),
    .TXPHYCDATA_OUT				(gt_txcharisk_out            )
    );


endmodule
