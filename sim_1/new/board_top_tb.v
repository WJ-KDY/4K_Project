`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2023 02:35:17 PM
// Design Name: 
// Module Name: board_top_tb
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
module board_top_tb # (
    parameter AW = 16,
    parameter DW = 16,
    parameter LW = 4,
    parameter BAUD = 16
)(

    );
reg     FPGA_50MHz  = 0;
reg     FPGA_100MHz = 0;
wire    UART0_TXD ;   
reg     UART0_RXD = 1;  
wire    PLL1_CSn ;
wire    PLL1_SCLK ;
wire    PLL1_SDO;
wire    PLL1_SDIO ;
wire    PLL1_RSTn ;
wire    PLL1_PDNn ;
reg     PLL1_LOCK = 1;
wire    PLL1_OEn ;
wire    PLL1_SYNCn ;
wire    PLL2_CSn ;
wire    PLL2_SCLK ;
wire    PLL2_SDO ;
wire    PLL2_SDIO ;
wire    PLL2_RSTn ;
wire    PLL2_PDNn ;
reg     PLL2_LOCK = 1;
wire    PLL2_OEn ;
wire    PLL2_SYNCn ;
wire	[0:31]	gthrxn_in ;
wire	[0:31]	gthrxp_in ;
wire	[31:0]	gthtxn_out ;
wire	[31:0]	gthtxp_out ;
reg		mgtrefclk0_226_p = 0;
reg		mgtrefclk0_226_n = 1;
reg		mgtrefclk0_230_p = 0;
reg		mgtrefclk0_230_n = 1;
wire	RX_LOCKN ;
wire	RX_HPDN ;
wire	TX_LOCKN;
wire    TX_HPDN;

always begin
    # 10 FPGA_50MHz <= ~ FPGA_50MHz;
end

always begin
    # 5 FPGA_100MHz <= ~ FPGA_100MHz;
end

 always begin
     # 3.367
     mgtrefclk0_226_p <= ~ mgtrefclk0_226_p;
     mgtrefclk0_226_n <= ~ mgtrefclk0_226_n;
     mgtrefclk0_230_p <= ~ mgtrefclk0_230_p;
     mgtrefclk0_230_n <= ~ mgtrefclk0_230_n;
 end

 assign gthrxn_in = gthtxn_out; 
 assign gthrxp_in = gthtxp_out;
 assign TX_LOCKN = RX_LOCKN;
 assign TX_HPDN = RX_HPDN;

board_top 
u_board_top
(
	.FPGA_50MHz(FPGA_50MHz),// freerun clock
	.UART0_TXD(UART0_TXD),// 100Mhz(logic clock),  for 100M(AXI clock) + 40M(DRP clock)
	.UART0_RXD(UART0_RXD),//
	.PLL1_CSn(PLL1_CSn),
	.PLL1_SCLK(PLL1_SCLK),
	.PLL1_SDO(PLL1_SDO),
	.PLL1_SDIO(PLL1_SDIO),
	.PLL1_RSTn(PLL1_RSTn),
	.PLL1_PDNn(PLL1_PDNn),
	.PLL1_LOCK(PLL1_LOCK),
	.PLL1_OEn(PLL1_OEn),
	.PLL1_SYNCn(PLL1_SYNCn),
	.PLL2_CSn(PLL2_CSn),
	.PLL2_SCLK(PLL2_SCLK),
	.PLL2_SDO(PLL2_SDO),
	.PLL2_SDIO(PLL2_SDIO),
	.PLL2_RSTn(PLL2_RSTn),
	.PLL2_PDNn(PLL2_PDNn),
	.PLL2_LOCK(PLL2_LOCK),
	.PLL2_OEn(PLL2_OEn),
	.PLL2_SYNCn(PLL2_SYNCn),
	.gthrxn_in(gthrxn_in),
	.gthrxp_in(gthrxp_in),
	.gthtxn_out(gthtxn_out),
	.gthtxp_out(gthtxp_out),
	.mgtrefclk0_226_p(mgtrefclk0_226_p),
	.mgtrefclk0_226_n(mgtrefclk0_226_n),
	.mgtrefclk0_230_p(mgtrefclk0_230_p),
	.mgtrefclk0_230_n(mgtrefclk0_230_n),
	.RX_LOCKN(RX_LOCKN),
	.RX_HPDN(RX_HPDN),
	.TX_LOCKN(TX_LOCKN),
	.TX_HPDN(TX_HPDN)
);
assign PLL1_SDO = 0;
assign PLL2_SDO = 0;

endmodule
