module VbyOne_TX_161212 #( 
	parameter SIMULATION		= 0,
	parameter PIXCBITWIDTH		= 4,
	parameter PIXDBITWIDTH 		= 32,
	parameter PHYCBITWIDTH 		= 4,
	parameter PHYDBITWIDTH 		= 32,
	parameter CTLDBITWIDTH      = 16
) (

	input							PCLK_RESET,
	input							PHYCLK_RESET,
	input							LCLK_RESET,
	output							GT_TXRESET_OUT,

	input							TXPHYCLK,
	input							TXPCLK,
	input							FREERUN_CLK,
	input							SCRAM_BYPASS,

	input							VSYNC_IN,
	input							HSYNC_IN,
	input							DE_IN,
	output							CTLDATA_ENOUT,
	input [PIXDBITWIDTH-1:0]		PIXDATA_IN,
	input [CTLDBITWIDTH-1:0]		CTLDATA_IN,

	input							HTPDN,
	input							LOCKN,

	// output[15:0]					DEBUG_OUT,
	input							TXRESETDONE_IN,
	input							TXPLLLOCK_IN,
	output [PHYDBITWIDTH-1:0]		TXPHYDATA_OUT,
	output [PHYCBITWIDTH-1:0] 		TXPHYCDATA_OUT
);
endmodule

module VbyOne_RX_161212 #
(  
	parameter SIMULATION		= 0,	
	parameter PIXCBITWIDTH 		= 4,	
	parameter PIXDBITWIDTH 		= 32,	
	parameter PHYCBITWIDTH 		= 4,	
	parameter PHYDBITWIDTH 		= 32,	
	parameter CTLDBITWIDTH     	= 16	
)
(
	output							COMMA_ENABLE,
	input							PCLK_RESET,
	input							PHYCLK_RESET,
	input							LCLK_RESET,
	output							GT_RXRESET_OUT,

	input							RXPHYCLK,
	input							RXPCLK,
	input							FREERUN_CLK,
	input							SCRAM_BYPASS,
		
	input 							thine_lockn,

	output reg						VSYNC_OUT,
	output reg						HSYNC_OUT,
	output reg						DE_OUT,
	output reg [PIXDBITWIDTH-1:0]	PIXDATA_OUT,
	output reg [CTLDBITWIDTH-1:0]	CTLDATA_OUT,
	output reg						TRN_ALIGN_DONE,
	output reg						CTLDATA_ENOUT,

	output							HTPDN_OUT,
	output							LOCKN_OUT,

	input[2:0]						RXBUFSTATUS_IN,
	output 							RXBUFRESET_OUT,

	input							RXRESETDONE_IN,
	input							RXPLLLOCK_IN,
	input							RXBYTEISALIGNED_IN,
	input [PHYCBITWIDTH-1 :0]		RXNOTINTABLE_IN,
	input [PHYCBITWIDTH-1 :0]		RXDISPERR_IN,
	input [PHYCBITWIDTH-1 :0]  	    RXPHYCDATA_IN,
	input [PHYDBITWIDTH-1 :0]  	    RXPHYDATA_IN
);

endmodule