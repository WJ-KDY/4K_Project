//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
//Date        : Fri Oct  6 15:43:04 2023
//Host        : mob-System-Product-Name running 64-bit HamoniKR
//Command     : generate_target spi_fifo_wrapper.bd
//Design      : spi_fifo_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module spi_fifo_wrapper
   (FIFO_READ_empty,
    FIFO_READ_rd_data,
    FIFO_READ_rd_en,
    FIFO_WRITE_full,
    FIFO_WRITE_wr_data,
    FIFO_WRITE_wr_en,
    rd_clk,
    rd_data_count,
    rst,
    wr_clk,
    wr_data_count);
  output FIFO_READ_empty;
  output [23:0]FIFO_READ_rd_data;
  input FIFO_READ_rd_en;
  output FIFO_WRITE_full;
  input [23:0]FIFO_WRITE_wr_data;
  input FIFO_WRITE_wr_en;
  input rd_clk;
  output [3:0]rd_data_count;
  input rst;
  input wr_clk;
  output [3:0]wr_data_count;

  wire FIFO_READ_empty;
  wire [23:0]FIFO_READ_rd_data;
  wire FIFO_READ_rd_en;
  wire FIFO_WRITE_full;
  wire [23:0]FIFO_WRITE_wr_data;
  wire FIFO_WRITE_wr_en;
  wire rd_clk;
  wire [3:0]rd_data_count;
  wire rst;
  wire wr_clk;
  wire [3:0]wr_data_count;
fifos #(.DW(24),.DP(16),.CW(4))
    spi_fifo_i
       (.empty  (FIFO_READ_empty),
        .dout   (FIFO_READ_rd_data),
        .rd_en  (FIFO_READ_rd_en),
        .full   (FIFO_WRITE_full),
        .din    (FIFO_WRITE_wr_data),
        .wr_en  (FIFO_WRITE_wr_en),
//        .rd_clk (rd_clk),
        .rcnt   (rd_data_count),
        .rst    (rst),
        .wr_clk (wr_clk),
        .wcnt   (wr_data_count));

//  spi_fifo spi_fifo_i
//       (.FIFO_READ_empty(FIFO_READ_empty),
//        .FIFO_READ_rd_data(FIFO_READ_rd_data),
//        .FIFO_READ_rd_en(FIFO_READ_rd_en),
//        .FIFO_WRITE_full(FIFO_WRITE_full),
//        .FIFO_WRITE_wr_data(FIFO_WRITE_wr_data),
//        .FIFO_WRITE_wr_en(FIFO_WRITE_wr_en),
//        .rd_clk(rd_clk),
//        .rd_data_count(rd_data_count),
//        .rst(rst),
//        .wr_clk(wr_clk),
//        .wr_data_count(wr_data_count));
endmodule
