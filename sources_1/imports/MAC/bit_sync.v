`timescale 1ps/1ps

// *********************************************************************************************************************
// IMPORTANT
// This block is delivered within the example design. If you wish to modify its behavior, be careful to understand the
// existing behavior and the effects of any modifications you may choose to make.
// *********************************************************************************************************************

module bit_sync # (

  parameter INITIALIZE = 5'b00000,
  parameter FREQUENCY  = 512

)(

  input  wire clk_in,
  input  wire i_in,
  output wire o_out

);

  // Use 5 flip-flops as a single synchronizer, and tag each declaration with the appropriate synthesis attribute to
  // enable clustering. Their GSR default values are provided by the INITIALIZE parameter.

  (* ASYNC_REG = "TRUE" *) reg i_in_meta  = INITIALIZE[0];
  (* ASYNC_REG = "TRUE" *) reg i_in_sync1 = INITIALIZE[1];
  (* ASYNC_REG = "TRUE" *) reg i_in_sync2 = INITIALIZE[2];
  (* ASYNC_REG = "TRUE" *) reg i_in_sync3 = INITIALIZE[3];
                           reg i_in_out   = INITIALIZE[4];

  always @(posedge clk_in) begin
    i_in_meta  <= i_in;
    i_in_sync1 <= i_in_meta;
    i_in_sync2 <= i_in_sync1;
    i_in_sync3 <= i_in_sync2;
    i_in_out   <= i_in_sync3;
  end

  assign o_out = i_in_out;


endmodule
