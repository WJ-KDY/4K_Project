`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2024 01:00:30 PM
// Design Name: 
// Module Name: clk_freq
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


module clk_freq #(
	parameter ref_freq = 100*1000*1000
	)
	(
	ref,
	clk,
	freq,
	tgl_1sec,
	tick_1sec,
	rst,
	jitt
    );

input ref,clk;
output [31:0] freq;
output [31:0] jitt;
output tgl_1sec;
output tick_1sec;
input rst;

reg [31:0]	cnt_ref = 0;
reg			tgl_ref = 0;
reg			tick_ref = 0;
reg			tgl_cdc = 0;
(* ASYNC_REG="true" *)
reg [31:0] freq_cdc	= 0;
wire	[31:0]		freq_s;
always @(posedge ref)begin
	cnt_ref 	<= cnt_ref <  ref_freq-1 ? cnt_ref + 1 : 0;
	tick_ref	<= cnt_ref == ref_freq-1 ? 1 : 0;
	tgl_ref		<= tick_ref	? ~tgl_ref: tgl_ref;
	tgl_cdc		<= tgl_ref;
	freq_cdc	<= freq_s;
end

assign freq = freq_cdc;

(* ASYNC_REG="true" *)
reg [31:0] cnt_clk	= 0;
(* ASYNC_REG="true" *)
reg [2:0]  cdc_ref	= 0;
reg 	   tick_cdc = 0;
reg [31:0] freq_clk	= 0;
reg [31:0] freq_clk1= 0;
integer		jitt_r	= 0;
reg			tick_1sec_r;
always @(posedge clk)begin
	cdc_ref 	<= {cdc_ref[1:0],tgl_cdc};
	tick_cdc	<= cdc_ref[2:1] == 1 ?	1	: 0 ;
	cnt_clk 	<= tick_cdc == 1 ?	0 		: cnt_clk + 1;
	freq_clk	<= tick_cdc == 1 ?	cnt_clk	: freq_clk;
	freq_clk1	<= tick_cdc == 1 ?	freq_clk: freq_clk1;
	tick_1sec_r	<= tick_cdc == 1 ?	1 		: 0;
	jitt_r		<= tick_cdc == 1 ?	freq_clk - freq_clk1	: jitt_r;
end
assign freq_s 		= freq_clk%2 < 1 ? freq_clk/2 : freq_clk/2+1;
assign tgl_1sec 	= tgl_ref;
assign jitt			= jitt_r;
assign tick_1sec	= tick_ref;
endmodule
