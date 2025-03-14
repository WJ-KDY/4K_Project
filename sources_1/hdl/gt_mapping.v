`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/12/09 22:07:36
// Design Name: 
// Module Name: gt_mapping
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


module vx1_phy_refclk(
		input			   mgtrefclk0_226_p,
		input			   mgtrefclk0_226_n,
		input			   mgtrefclk0_230_p,
		input			   mgtrefclk0_230_n,
		output	[3:0]	QREFCLK0,
		output	[3:0]	QREFCLK1);
	
	wire	refclk_vx1;
	wire 	refclk_framer;
	
	assign QREFCLK0[0] = refclk_vx1;
	assign QREFCLK0[1] = refclk_vx1;
	assign QREFCLK0[2] = refclk_vx1;
	assign QREFCLK0[3] = refclk_vx1;
	
	assign QREFCLK1[0] = refclk_framer;
	assign QREFCLK1[1] = refclk_framer;
	assign QREFCLK1[2] = refclk_framer;
	assign QREFCLK1[3] = refclk_framer;
	
   IBUFDS_GTE4 #(
      .REFCLK_EN_TX_PATH   (1'b0),     // Refer to Transceiver User Guide
      .REFCLK_HROW_CK_SEL  (2'b00),    // Refer to Transceiver User Guide
      .REFCLK_ICNTL_RX     (2'b00)     // Refer to Transceiver User Guide
   )   IBUFDS_GTE4_inst0 (
      .O       (refclk_framer    ),    // 1-bit output: Refer to Transceiver User Guide
      .ODIV2   (refclk_pclk      ),    // 1-bit output: Refer to Transceiver User Guide
      .CEB     (1'b0             ) ,   // 1-bit input: Refer to Transceiver User Guide
      .I       (mgtrefclk0_230_p ),    // 1-bit input: Refer to Transceiver User Guide
      .IB      (mgtrefclk0_230_n )     // 1-bit input: Refer to Transceiver User Guide
   );
      
   IBUFDS_GTE4 #(
      .REFCLK_EN_TX_PATH   (1'b0),     // Refer to Transceiver User Guide
      .REFCLK_HROW_CK_SEL  (2'b00),    // Refer to Transceiver User Guide
      .REFCLK_ICNTL_RX     (2'b00)     // Refer to Transceiver User Guide
   )   IBUFDS_GTE4_inst1 (
      .O       (refclk_vx1       ),    // 1-bit output: Refer to Transceiver User Guide
      .ODIV2   (                 ),    // 1-bit output: Refer to Transceiver User Guide
      .CEB     (1'b0             ),    // 1-bit inputx_usrclk: Refer to Transceiver User Guide
      .I       (mgtrefclk0_226_p ),    // 1-bit input: Refer to Transceiver User Guide
      .IB      (mgtrefclk0_226_n )     // 1-bit input: Refer to Transceiver User Guide
   );
   
endmodule

