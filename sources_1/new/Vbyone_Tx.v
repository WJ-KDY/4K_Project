`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2023 06:20:48 PM
// Design Name: 
// Module Name: Vbyone_Tx
// Project Name: 
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


module vx1_tx_sub #( 
	parameter SIMULATION		= 0,
	parameter PIXCBITWIDTH		= 4,
	parameter PIXDBITWIDTH 		= 32,
	parameter PHYCBITWIDTH 		= 4,
	parameter PHYDBITWIDTH 		= 32,
	parameter CTLDBITWIDTH      = 16,
	parameter TX_CH_NUM         = 32
) (

    input                                  TXMMCM_LOCK,

	input							       TXPHYCLK,
	input							       TXPCLK,
	input							       FREERUN_CLK,

	input  [             TX_CH_NUM-1:0]    VSYNC_IN,
	input  [             TX_CH_NUM-1:0]    HSYNC_IN,
	input  [             TX_CH_NUM-1:0]    DE_IN,
	output [             TX_CH_NUM-1:0]    CTLDATA_ENOUT,
	input  [PIXDBITWIDTH*TX_CH_NUM-1:0]    PIXDATA_IN,
	input  [CTLDBITWIDTH*TX_CH_NUM-1:0]    CTLDATA_IN,

	input	[            TX_CH_NUM-1:0]		HTPDN,
	input	[            TX_CH_NUM-1:0]		LOCKN,

	input							       TXRESETDONE_IN,
	input  [             TX_CH_NUM-1:0]    TXPLLLOCK_IN,
	output [PHYDBITWIDTH*TX_CH_NUM-1:0]    TXPHYDATA_OUT,
	output [PHYCBITWIDTH*TX_CH_NUM-1:0]    TXPHYCDATA_OUT
);

wire 	tx_sysreset_i	;
wire 	txpclk_reset	;
wire 	txphyclk_reset	;
Reset_Gen # (
	.SIMULATION				(SIMULATION)
) Reset_Blk (
	.MMCM_LOCK				(TXMMCM_LOCK	),
	.PCLK					(TXPCLK  ),
	.PHYCLK					(TXPHYCLK),
	.LCLK					(FREERUN_CLK),//freerun			),
	
	.SYSRESET				(tx_sysreset_i	),
	.PCLK_RESET				(txpclk_reset	),
	.PHYCLK_RESET			(txphyclk_reset	)
);

genvar t;
generate for (t=0; t<TX_CH_NUM; t=t+1) 
  begin : t_loop
    VbyOne_TX_161212
	Vbyone_Tx_Link_i(
		.PCLK_RESET					(txpclk_reset			),
		.PHYCLK_RESET				(txphyclk_reset			),
		.LCLK_RESET					(tx_sysreset_i			),
		.GT_TXRESET_OUT				(						),

		.TXPHYCLK					(TXPHYCLK					),
		.TXPCLK						(TXPCLK         			),
		.FREERUN_CLK				(FREERUN_CLK                ),
		.SCRAM_BYPASS				(1'b0						),

		.VSYNC_IN					(VSYNC_IN		[t]			),
		.HSYNC_IN					(HSYNC_IN		[t]			),
		.DE_IN						(DE_IN			[t]			),
		.PIXDATA_IN					(PIXDATA_IN	    [(t+1)*PIXDBITWIDTH-1:t*PIXDBITWIDTH]),

		.CTLDATA_ENOUT				(CTLDATA_ENOUT	[t]			),
		.CTLDATA_IN					(CTLDATA_IN	    [(t+1)*CTLDBITWIDTH-1:t*CTLDBITWIDTH]),

		.HTPDN						(HTPDN			[t]),
		.LOCKN						(LOCKN			[t]),

		// .DEBUG_OUT				(							),
		.TXRESETDONE_IN				(TXRESETDONE_IN            	),
		.TXPLLLOCK_IN				(TXPLLLOCK_IN		[t]		),

		.TXPHYDATA_OUT				(TXPHYDATA_OUT		[(t+1)*PHYDBITWIDTH-1:t*PHYDBITWIDTH]		),
		.TXPHYCDATA_OUT				(TXPHYCDATA_OUT	    [(t+1)*PHYCBITWIDTH-1:t*PHYCBITWIDTH]		)
    );
  end 
endgenerate

endmodule

