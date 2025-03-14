`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10/06/2023 06:20:48 PM
// Design Name:
// Module Name: Vbyone_Rx
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

module vx1_rx_sub #
(
parameter SIMULATION		= 0,
parameter PIXCBITWIDTH 		= 4,
parameter PIXDBITWIDTH 		= 32,
parameter PHYCBITWIDTH 		= 4,
parameter PHYDBITWIDTH 		= 32,
parameter CTLDBITWIDTH     	= 16,
parameter RX_CH_NUM         = 32
)
(
input                           EXT_PLL_LOCKN,
input                           RXMMCM_LOCK,
output			[RX_CH_NUM-1:0]	GT_RXRESET_OUT,

input							RXPHYCLK,
input							RXPCLK,
input							FREERUN_CLK,

output    		    [RX_CH_NUM-1:0]	VSYNC_OUT,
output    		    [RX_CH_NUM-1:0]	HSYNC_OUT,
output    		    [RX_CH_NUM-1:0]	DE_OUT,
output [PIXDBITWIDTH*RX_CH_NUM-1:0]	PIXDATA_OUT,
output [CTLDBITWIDTH*RX_CH_NUM-1:0]	CTLDATA_OUT,

output    			[RX_CH_NUM-1:0]	TRN_ALIGN_DONE,
output    			[RX_CH_NUM-1:0]	CTLDATA_ENOUT,
output				[RX_CH_NUM-1:0]	HTPDN_OUT,
output				[RX_CH_NUM-1:0]	LOCKN_OUT,

input				                   RXRESETDONE_IN,
input				[RX_CH_NUM-1:0]    RXPLLLOCK_IN,
input				[RX_CH_NUM-1:0]    RXBYTEISALIGNED_IN,
input [PHYCBITWIDTH*RX_CH_NUM-1 :0]    RXNOTINTABLE_IN,
input [PHYCBITWIDTH*RX_CH_NUM-1 :0]    RXDISPERR_IN,
input [PHYCBITWIDTH*RX_CH_NUM-1 :0]    RXPHYCDATA_IN,
input [PHYDBITWIDTH*RX_CH_NUM-1 :0]    RXPHYDATA_IN,
output              [RX_CH_NUM-1:0]    RXBUFRESET_OUT
);

localparam DP = 32;
localparam MC = 0;
wire 	rx_sysreset_i	;
wire 	rxpclk_reset	;
wire 	rxphyclk_reset	;
Reset_Gen #
(
.SIMULATION				(SIMULATION)
) Reset_Blk (
.MMCM_LOCK				(RXMMCM_LOCK),
.PCLK					(RXPCLK  ),
.PHYCLK					(RXPHYCLK),
.LCLK					(FREERUN_CLK), //freerun			),

.SYSRESET				(rx_sysreset	),
.PCLK_RESET				(rxpclk_reset	),
.PHYCLK_RESET			(rxphyclk_reset	)
);

genvar r;
generate for (r=0; r<RX_CH_NUM; r=r+1)
begin : r_loop
VbyOne_RX_161212
Vbyone_Rx_Link_i(
.COMMA_ENABLE				(		               		),
.PCLK_RESET					(rxpclk_reset  				),
.PHYCLK_RESET				(rxphyclk_reset				),
.LCLK_RESET					(rx_sysreset 				),
.GT_RXRESET_OUT				(GT_RXRESET_OUT[r]			),

.RXPHYCLK					(RXPHYCLK					),
.RXPCLK						(RXPCLK   					),
.FREERUN_CLK				(FREERUN_CLK				),
.SCRAM_BYPASS				(1'b0						),

.thine_lockn				(EXT_PLL_LOCKN              ),

.VSYNC_OUT					(VSYNC_OUT		[r]),
.HSYNC_OUT					(HSYNC_OUT		[r]),
.DE_OUT						(DE_OUT			[r]),
.PIXDATA_OUT				(PIXDATA_OUT    [(r+1)*PIXDBITWIDTH-1:r*PIXDBITWIDTH]),

.CTLDATA_OUT				(CTLDATA_OUT	[(r+1)*CTLDBITWIDTH-1:r*CTLDBITWIDTH]),
.CTLDATA_ENOUT				(CTLDATA_ENOUT	[r]),
.HTPDN_OUT					(HTPDN_OUT		[r]),
.LOCKN_OUT					(LOCKN_OUT		[r]),
.TRN_ALIGN_DONE				(TRN_ALIGN_DONE	[r]),

.RXBUFSTATUS_IN				(3'b000						),
.RXBUFRESET_OUT				(RXBUFRESET_OUT[r]          ),

.RXRESETDONE_IN	            (RXRESETDONE_IN            ),
.RXPLLLOCK_IN				(RXPLLLOCK_IN			[r]),
.RXBYTEISALIGNED_IN         (RXBYTEISALIGNED_IN   	[r]),
.RXNOTINTABLE_IN            (RXNOTINTABLE_IN		[(r+1)*PHYCBITWIDTH-1:r*PHYCBITWIDTH]),
.RXDISPERR_IN               (RXDISPERR_IN			[(r+1)*PHYCBITWIDTH-1:r*PHYCBITWIDTH]),
.RXPHYCDATA_IN				(RXPHYCDATA_IN			[(r+1)*PHYCBITWIDTH-1:r*PHYCBITWIDTH]),
.RXPHYDATA_IN				(RXPHYDATA_IN			[(r+1)*PHYDBITWIDTH-1:r*PHYDBITWIDTH])
);
end
endgenerate 
endmodule