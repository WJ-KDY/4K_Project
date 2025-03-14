`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2023 10:07:06 PM
// Design Name: 
// Module Name: power_on_reset
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


module pwr_on_rst #(
    parameter   SIMULATION = 0)
(   input       freerunclk,     // freerun clock input
    output  reg resetn_out);    //activ low out

reg [15:0] rst_cnt = 0;
always @ (posedge freerunclk)    
    begin
      if(rst_cnt < 2000) rst_cnt <= rst_cnt + 1 ;
      if(SIMULATION)
      if(rst_cnt < 150) resetn_out <= 0 ;
          else resetn_out <= 1 ;
      else
      	  if(rst_cnt >= 1000 && rst_cnt < 1500)  resetn_out <= 0 ;
   		  else                                   resetn_out <= 1 ;
	end
endmodule
