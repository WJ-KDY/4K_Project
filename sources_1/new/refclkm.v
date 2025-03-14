`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 10:12:25 AM
// Design Name: 
// Module Name: refclkm
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


module refclkm
(   input   refclk1_in,
    input   refclk2_in,
    output  REFCLK1_P,          REFCLK1_N,          REFCLK2_P,          REFCLK2_N);

OBUFDS REFCLK1_inst (
  .O(REFCLK1_P),    // 1-bit output: Diff_p output (connect directly to top-level port)
  .OB(REFCLK1_N),   // 1-bit output: Diff_n output (connect directly to top-level port)
  .I(refclk1_in)      // 1-bit input: Buffer input
);

OBUFDS REFCLK2_inst (
  .O(REFCLK2_P),    // 1-bit output: Diff_p output (connect directly to top-level port)
  .OB(REFCLK2_N),   // 1-bit output: Diff_n output (connect directly to top-level port)
  .I(refclk2_in)      // 1-bit input: Buffer input
);

endmodule
