`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/14/2024 11:53:31 PM
// Design Name: 
// Module Name: vid_sa
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


module vid_sa(
	vs,de,rx_usrclk,vt,vb
    );

input	vs,de,rx_usrclk;
output	[31:0]	vt,vb;

wire  vx1_rx_vs_ref,vx1_rx_de_ref;
assign vx1_rx_vs_ref 	= vs;
assign vx1_rx_de_ref	= de;

reg [31:0] 	pixel_cnt_rx 		= 0;
reg [31:0] 	vtotal1 		= 0;
reg [31:0] 	vback_porch1 	= 0;
reg			vx1_rx_vs_ref1 	= 0;
reg			vx1_rx_de_ref1	= 0;
wire 		vx1_rx_vs_tick;
wire 		vx1_rx_de_tick;
reg			vde = 0;

assign 	vx1_rx_vs_tick  = vx1_rx_vs_ref & !vx1_rx_vs_ref1;
assign 	vx1_rx_de_tick  = vx1_rx_de_ref & !vx1_rx_de_ref1;

always @(posedge rx_usrclk)begin
	vx1_rx_vs_ref1 <= vx1_rx_vs_ref;
	vx1_rx_de_ref1 <= vx1_rx_de_ref;

	if(vx1_rx_vs_tick)	pixel_cnt_rx	<= 1;else pixel_cnt_rx <= pixel_cnt_rx + 1;
	if(vx1_rx_vs_tick)	vtotal1 		<= pixel_cnt_rx;
	if(vx1_rx_vs_tick)	vde				<= 0;
	if(vx1_rx_de_tick)	vde 			<= 1;
	if(vx1_rx_de_tick)	vback_porch1	<= vde ? vback_porch1 : pixel_cnt_rx ;
end

assign vt = vtotal1;
assign vb = vback_porch1;
    
endmodule
