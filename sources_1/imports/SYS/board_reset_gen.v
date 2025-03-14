`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/18 15:49:33
// Design Name: 
// Module Name: board_reset_gen
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


module board_reset_gen(
	clk148_5	,
	freeclk		,
	pwr_on_rstn	,
	nrst_tmc	,
	nrst_gty	,
	set_prm		,
	en_mask		,
	rst_cnt_out
    );
    
   input	clk148_5	;
   input	freeclk		;
   input	pwr_on_rstn	;

   output	nrst_tmc	;
   output	nrst_gty	;
   output	set_prm		;
   output	en_mask		;
   output [31:0]rst_cnt_out	;

   // PWR_ON_RESET parameter
   parameter 			PWR_SCHEME_RISE	= 50000000 * 10 ;
   parameter			PWR_SCHEME_FIN	= 50000000 * 20	;

   // IP RESETN parameter
   parameter			IP_SCHEME_RISE	= 50000000 			;
   parameter			IP_SCHEME_FIN	= 2000000000			;
   parameter			IP_TMC_NRST	= IP_SCHEME_RISE		;
   parameter			IP_GTY_NRST	= IP_SCHEME_RISE - 500000	;
   parameter			IP_SETPRM_RISE  = IP_SCHEME_RISE + 10500	;
   parameter			IP_SETPRM_FALL  = IP_SCHEME_RISE + 10501	;
   parameter			IP_EN_MASK	= IP_SCHEME_RISE + 550000	;

   // Signals
   reg 	[31:0]	pwr_on_rst_cnt = 0	;
   reg		pwr_on_rst_int		;

   reg 	[31:0]	ip_rst_cnt		;

   reg		nrst_tmc = 1'b1		;
   reg		nrst_gty = 1'b1		;
   reg		set_prm	 = 1'b0		;
   reg		en_mask	 = 1'b0		;

   wire		ip_resetn		;

   // PWR_ON_RESET clock PLL 50MHz
   always @(posedge freeclk)
   begin
	if (pwr_on_rst_cnt < PWR_SCHEME_FIN) begin
		pwr_on_rst_cnt <= pwr_on_rst_cnt + 1;
	end
	else begin
		pwr_on_rst_cnt <= pwr_on_rst_cnt;
	end
   end

   always @(posedge freeclk)
   begin
	if (pwr_on_rst_cnt < PWR_SCHEME_RISE) begin
		pwr_on_rst_int <= 0;
	end
	else begin
		pwr_on_rst_int <= 1;
	end
   end

   assign ip_resetn = pwr_on_rst_int & pwr_on_rstn;

   always @(posedge freeclk or negedge ip_resetn)
   begin
	if (!ip_resetn) begin
		ip_rst_cnt <= 0;
	end
	else if (ip_rst_cnt < IP_SCHEME_FIN) begin
		ip_rst_cnt <= ip_rst_cnt + 1;
	end
	else begin
		ip_rst_cnt <= ip_rst_cnt;
	end
   end

   always @(posedge freeclk or negedge ip_resetn)
   begin
	if (!ip_resetn) begin
		nrst_tmc <= 0;
		nrst_gty <= 0;
		set_prm  <= 0;
		en_mask  <= 0;
	end
	else if (ip_rst_cnt == IP_TMC_NRST) begin
		nrst_tmc <= 1;
	end
	else if (ip_rst_cnt == IP_GTY_NRST) begin
		nrst_gty <= 1;
	end
	else if (ip_rst_cnt == IP_SETPRM_RISE) begin
		set_prm <= 1;
	end
	else if (ip_rst_cnt == IP_SETPRM_FALL) begin
		set_prm <= 0;
	end
	else if (ip_rst_cnt == IP_EN_MASK) begin
		en_mask <= 1;
	end
   end

   // ila
   assign rst_cnt_out = ip_rst_cnt;

   (*mark_debug = "true"*) wire [31:0] 	ip_rst_cnt_dbg;
   (*mark_debug = "true"*) wire 	pwr_on_rst_int_dbg;
   (*mark_debug = "true"*) wire	[31:0]	pwr_on_rst_cnt_dbg;
   (*mark_debug = "true"*) wire		nrst_tmc_dbg;
   (*mark_debug = "true"*) wire		nrst_gty_dbg;
   (*mark_debug = "true"*) wire		set_prm_dbg;
   (*mark_debug = "true"*) wire		en_mask_dbg;

   assign ip_rst_cnt_dbg = ip_rst_cnt;
   assign pwr_on_rst_int_dbg = pwr_on_rst_int;
   assign pwr_on_rst_cnt_dbg = pwr_on_rst_cnt;
   assign nrst_tmc_dbg = nrst_tmc;
   assign nrst_gty_dbg = nrst_gty;
   assign en_mask_dbg = en_mask;

endmodule

