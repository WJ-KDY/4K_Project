`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/01 11:34:57
// Design Name: 
// Module Name: tmc2mac
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


module tmc2mac(nrst, frst, init, dmax, clk, rclk, din_valid_l0, din_l0, din_valid_l1, din_l1, 
	din_ready_l0, din_ready_l1, dout, dout_valid);
	
  input nrst;
  input frst;
  input init;
  input [31:0] dmax;
  input clk;
  input rclk;
  input din_valid_l0;
  input [127:0] din_l0;
  output din_ready_l0;
  input din_valid_l1;
  input [127:0] din_l1;
  output din_ready_l1;
  output [31:0] dout;
  output dout_valid;
  
  
  //make fifo rst ------------------------------------------------------------------------------
 wire fifo_rst;
 reg [127:0] nrst_d;
 
 always @ (posedge clk) begin
    nrst_d[0] <= nrst;
    nrst_d[127:1] <= nrst_d[126:0];
 end
 
 assign fifo_rst = ~nrst_d[127];
  
  // make rd_clk -------------------------------------------------------------------------
  
  wire din_valid_int_l0 = din_ready_l0 & din_valid_l0;
  wire din_valid_int_l1 = din_ready_l1 & din_valid_l1;
  
  tx_burst_wrap U_TX_BURST (
  .nrst(nrst),
  //.frst(fifo_rst),
  .frst(frst),
  .init(init),
  .dmax(dmax),
  .wclk(clk),    // input wire clka
  .rclk(rclk),    // input wire clkb
  .din_valid_l0(din_valid_int_l0),      // input wire [0 : 0] wea
  .din_l0(din_l0),    // input wire [127 : 0] dina
  .din_ready_l0(din_ready_l0),
  .din_valid_l1(din_valid_int_l1),      // input wire [0 : 0] wea
  .din_l1(din_l1),    // input wire [127 : 0] dina
  .din_ready_l1(din_ready_l1),
  .dout(dout),  // output wire [31 : 0] doutb
  .dout_valid(dout_valid)
);

endmodule
