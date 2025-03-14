`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 02:19:33 PM
// Design Name: 
// Module Name: ddr_emul
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


module ddr_emul(
    input   ddr_rst,
    output  ddr_cal_done,
    input   ddr_clk);

reg [7:0] cnt_256 = 0;

always @(posedge ddr_clk)begin
    if(ddr_rst)         cnt_256 <= 0;else
    if(cnt_256 < 255)   cnt_256 <= cnt_256 + 1;
end
assign ddr_cal_done = (cnt_256 == 255) ? 1 : 0;

endmodule
