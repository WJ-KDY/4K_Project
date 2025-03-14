`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2023 08:26:41 PM
// Design Name: 
// Module Name: rx_align_buff
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

//module rx_align_buff_ng0 #(
//    parameter DW = 32,
//    parameter DP = 16,
//    parameter CN = 16,
//    parameter MC = 0,
//    parameter MX = 240+9
//)(
//    input       [CN-1:0]    vid_i_e,
//    input       [CN-1:0]    vid_i_h,
//    input       [CN-1:0]    vid_i_v,
//    input    [DW*CN-1:0]    vid_i_d,
//    output      [CN-1:0]    vid_o_e,
//    output      [CN-1:0]    vid_o_h,
//    output      [CN-1:0]    vid_o_v,
//    output   [DW*CN-1:0]    vid_o_d,
//    input wr_clk,
//    input rd_clk,
//    input rst
//    );

//wire [CN-1:0] fifo_full;
//wire [CN-1:0] fifo_empty,fifo_valid,prog_empty;
//reg [CN-1:0] fifo_wr_en = 0;
//reg [CN-1:0] fifo_rd_en = 0;
//reg [DW*CN-1:0]fifo_din = 0;
//reg [CN-1:0] fifo_i_h,fifo_i_v,fifo_i_e;
//wire [DW*CN-1:0]fifo_dout;
//wire [CN-1:0] fifo_o_h,fifo_o_v,fifo_o_e;
//reg vid_x_v;
//reg vid_x_h;
//reg [15:0] vid_i_c;
//reg rst_v;
//integer i;
//always @(posedge wr_clk)begin
//	vid_i_c <= vid_i_e[MC] ? 0 : vid_i_c < 512 ? vid_i_c+1 : vid_i_c;
//	rst_v   <= vid_i_c > 512-64 && vid_i_c < 512 ? 1 : 0;
//	fifo_din   <= vid_i_d;
//	fifo_i_e   <= vid_i_e;
//	for(i=0;i<CN;i=i+1)begin
//		fifo_wr_en[i] <= rst_v ? 0 : vid_i_v[i] != fifo_i_v[i] ? 1 : fifo_wr_en[i];
//		fifo_i_h[i]   <= ~vid_i_e[i] ? vid_i_h[i] : fifo_i_h[i];
//		fifo_i_v[i]   <= ~vid_i_e[i] ? vid_i_v[i] : fifo_i_v[i];
//	end
//	vid_x_v    <= ~vid_i_e[MC] ? vid_i_v[MC] : vid_x_v;
//	vid_x_h    <= ~vid_i_e[MC] ? vid_i_h[MC] : vid_x_h;
//end

//reg [31:0] rd_cnt = MX;

//reg [31:0] vid_xx_v;
//reg [31:0] vid_xx_h;
//always @(posedge rd_clk)
//begin
////	rd_cnt      <= rst ? MX : rd_cnt < MX ? rd_cnt+1 : ~&prog_empty ? 0 : MX; 
////	fifo_rd_en 	<= rst ? 0  : rd_cnt < MX ? 2**CN-1 : 0;
//	fifo_rd_en	<= rst_v ? 0  : ~&prog_empty? {CN{1'b1}} : fifo_rd_en;
//	vid_xx_v	<= {vid_xx_v[30:0],vid_x_v};
//	vid_xx_h	<= {vid_xx_h[30:0],vid_x_h};
//end

//genvar g;
//generate for(g=0;g<CN;g=g+1)begin: buff
//    rx_fifo
//    rx_fifo (
//    .prog_empty(prog_empty[g]),
//    .empty(fifo_empty[g]),
//    .full(fifo_full[g]),
//    .valid(fifo_valid[g]),
//    .din    ({fifo_i_h[g],fifo_i_v[g],fifo_i_e[g],fifo_din[(g+1)*DW-1:g*DW]}),
//    .dout   ({fifo_o_h[g],fifo_o_v[g],fifo_o_e[g],fifo_dout[(g+1)*DW-1:g*DW]}),
//    .wr_en  (fifo_wr_en[g]),
//    .rd_en  (fifo_rd_en[g]),
//    .wr_clk (wr_clk),
//    .rd_clk (rd_clk),
//    .rst    (rst_v));
//end
//endgenerate 

//assign  vid_o_d = 	fifo_dout;
//assign  vid_o_e =   fifo_o_e;
//assign  vid_o_h =   fifo_o_h;
//assign  vid_o_v =   fifo_o_v;

//endmodule


module rx_align_buff #(
    parameter DW = 32,
    parameter DP = 16,
    parameter CN = 16,
    parameter MC = 0,
    parameter MX = 240+9
)(
    input       [CN-1:0]    vid_i_e,
    input       [CN-1:0]    vid_i_h,
    input       [CN-1:0]    vid_i_v,
    input    [DW*CN-1:0]    vid_i_d,
    output      [CN-1:0]    vid_o_e,
    output      [CN-1:0]    vid_o_h,
    output      [CN-1:0]    vid_o_v,
    output   [DW*CN-1:0]    vid_o_d,
    input wr_clk,
    input rd_clk,
    input rst
    );

wire [CN-1:0] fifo_full;
wire [CN-1:0] fifo_empty,fifo_valid,prog_empty;
reg [CN-1:0] fifo_wr_en = 0;
reg [CN-1:0] fifo_rd_en = 0;
reg [DW*CN-1:0]fifo_din = 0;
(*mark_debug = "true"*)reg [CN-1:0] fifo_vld;
(*mark_debug = "true"*)wire [DW*CN-1:0]fifo_dout;
(*mark_debug = "true"*)wire [CN-1:0] fifo_oe;
reg vid_x_v;
reg vid_x_h;
integer j;
reg [15:0] vid_i_c;
reg rst_v;
always @(posedge wr_clk)begin
	vid_i_c <= vid_i_e[MC] ? 0 : vid_i_c < 512 ? vid_i_c+1 : vid_i_c;
	rst_v   <= vid_i_c > 512-64 && vid_i_c < 512 ? 1 : 0;
	fifo_din   <= vid_i_d;
	fifo_vld   <= vid_i_e;
	for(j=0;j<CN;j=j+1)begin
		fifo_wr_en[j] <= rst_v ? 0 : ~fifo_full[j] & vid_i_e[j];
	end
	vid_x_v    <= ~vid_i_e[MC] ? vid_i_v[MC] : vid_x_v;
	vid_x_h    <= ~vid_i_e[MC] ? vid_i_h[MC] : vid_x_h;
end

reg [31:0] rd_cnt = MX;

reg [31:0] vid_xx_v;
reg [31:0] vid_xx_h;
always @(posedge rd_clk)
begin
	rd_cnt      <= rst_v ? MX : rd_cnt < MX ? rd_cnt+1 : ~&prog_empty ? 0 : MX; 
	fifo_rd_en 	<= rst_v ? 0  : rd_cnt < MX ? 2**CN-1 : 0;
	vid_xx_v	<= {vid_xx_v[30:0],vid_x_v};
	vid_xx_h	<= {vid_xx_h[30:0],vid_x_h};
end

genvar i;
generate for(i=0;i<CN;i=i+1)begin: buff
    rx_fifo
    rx_fifo (
    .prog_empty(prog_empty[i]),
    .empty(fifo_empty[i]),
    .full(fifo_full[i]),
    .valid(fifo_valid[i]),
    .din    ({fifo_vld[i],fifo_din[(i+1)*DW-1:i*DW]}),
    .wr_en  (fifo_wr_en[i]),
    .dout   ({fifo_oe[i],fifo_dout[(i+1)*DW-1:i*DW]}),
    .rd_en  (fifo_rd_en[i]),
    .wr_clk (wr_clk),
    .rd_clk (rd_clk),
    .wr_rst_busy (),
    .rd_rst_busy (),
    .rst    (rst_v));
end
endgenerate 

assign  vid_o_d = 	fifo_dout;
assign  vid_o_e =   fifo_valid & fifo_oe;
assign  vid_o_h =   {CN{vid_xx_h[12]}};
assign  vid_o_v =   {CN{vid_xx_v[12]}};

endmodule



//module rx_align_buff_ng1 #(
//    parameter DW = 32,
//    parameter DP = 16,
//    parameter CN = 32,
//    parameter MC = 0
//)(
//    input       [CN-1:0]    vid_i_e,
//    input       [CN-1:0]    vid_i_h,
//    input       [CN-1:0]    vid_i_v,
//    input    [DW*CN-1:0]    vid_i_d,
//    output      [CN-1:0]    vid_o_e,
//    output      [CN-1:0]    vid_o_h,
//    output      [CN-1:0]    vid_o_v,
//    output   [DW*CN-1:0]    vid_o_d,
//    input wr_clk,
//    input rd_clk,
//    input rst
//    );

//reg [31:0] 	rst_x = 32'hffffffff;
//reg [CN-1:0]wr_str = 0;

//always @(posedge wr_clk)begin
//	if(rst)			wr_str <= 0;else
//	if(&vid_i_e==0) wr_str <= {CN{1'b1}};
//end

//always @(posedge rd_clk)begin
//    if(rst) rst_x <= 32'hffffffff;else
//    rst_x <= {rst_x[30:0],1'b0};
//end
//reg [CN*3-1:0] ehv [0:DP/2];
//integer j;
//always @(posedge rd_clk)begin
//    if(rst_x == 0) begin
//        ehv[0]<= {{CN{vid_i_e[MC]}},{CN{vid_i_h[MC]}},{CN{vid_i_v[MC]}}};
//        for(j=0;j<DP/2;j=j+1)begin
//            ehv[j+1]<=ehv[j];
//         end
//    end
//    else begin 
//        ehv[0]<= 0;
//        for(j=0;j<DP/2;j=j+1)begin
//            ehv[j+1]<=ehv[j];
//        end
//    end 
//end

//wire [CN-1:0] wr_en,fifo_full;
//assign wr_en = (rst_x != 0) ? 0 : vid_i_e & ~fifo_full & wr_str;

//wire [CN-1:0] rd_en,fifo_empty,fifo_valid;
//assign rd_en = (rst_x != 0) ? 0  : ehv[DP/2-1][CN*3-1:CN*2] & {CN{~fifo_empty}};
//wire [CN-1:0] oe_en;
//wire [DW*CN-1:0] dout;
//genvar i;
//generate for(i=0;i<CN;i=i+1)begin: buff
//    rx_fifo
//    rx_fifo (
//    .empty(fifo_empty[i]),
//    .full(fifo_full[i]),
//    .valid(fifo_valid[i]),
//    .rd_rst_busy(),
//    .wr_rst_busy(),
//    .din    ({vid_i_e[i],vid_i_d[(i+1)*DW-1:i*DW]}),
//    .wr_en  (wr_en[i]),
//    .dout   ({oe_en[i],dout[(i+1)*DW-1:i*DW]}),
//    .rd_en  (rd_en[i]),
//    .wr_clk (wr_clk),
//    .rd_clk (rd_clk),
//    .rst    (rst_x[31]));
//end
//endgenerate 

//assign  vid_o_d = ( fifo_valid[MC]) ? dout :  0;
//assign  vid_o_e =   fifo_valid & oe_en;
//assign  vid_o_h =   ehv[DP/2][CN*2-1:CN*1];
//assign  vid_o_v =   ehv[DP/2][CN*1-1:CN*0];

//endmodule 


//module rx_align_buff_ng2 #(
//    parameter DW = 32,
//    parameter DP = 128,
//    parameter CN = 16,
//    parameter MC = 0
//)(
//    input       [CN-1:0]    vid_i_e,
//    input       [CN-1:0]    vid_i_h,
//    input       [CN-1:0]    vid_i_v,
//    input    [DW*CN-1:0]    vid_i_d,
//    output      [CN-1:0]    vid_o_e,
//    output      [CN-1:0]    vid_o_h,
//    output      [CN-1:0]    vid_o_v,
//    output   [DW*CN-1:0]    vid_o_d,
//    input wr_clk,
//    input rd_clk,
//    input rst
//    );
//reg [31:0] 	rst_x = 32'hffffffff;
//reg [CN-1:0]wr_str = 0;

//always @(posedge wr_clk)begin
//	if(rst)			wr_str <= 0;else
//	if(&vid_i_e==0) wr_str <= {CN{1'b1}};
//end

//always @(posedge rd_clk)begin
//    if(rst) rst_x <= 32'hffffffff;else
//    rst_x <= {rst_x[30:0],1'b0};
//end
//reg [CN*3-1:0] ehv [0:DP/2];
//integer j;
//always @(posedge rd_clk)begin
//    if(rst_x == 0) begin
//        ehv[0]<= {{CN{vid_i_e[MC]}},{CN{vid_i_h[MC]}},{CN{vid_i_v[MC]}}};
//        for(j=0;j<DP/2;j=j+1)begin
//            ehv[j+1]<=ehv[j];
//         end
//    end
//    else begin 
//        ehv[0]<= 0;
//        for(j=0;j<DP/2;j=j+1)begin
//            ehv[j+1]<=ehv[j];
//        end
//    end 
//end

//wire [CN-1:0] wr_en,fifo_full;
//assign wr_en = (rst_x != 0) ? 0 : vid_i_e & ~fifo_full & wr_str;

//wire [CN-1:0] rd_en,fifo_empty,fifo_valid;
//assign rd_en = (rst_x != 0) ? 0  : ehv[DP/2-1][CN*3-1:CN*2] & ~fifo_empty;
//wire [CN-1:0] oe_en;
//wire [DW*CN-1:0] dout;
//genvar i;
//generate for(i=0;i<CN;i=i+1)begin: buff
//    rx_fifo
//    rx_fifo (
//    .empty(fifo_empty[i]),
//    .full(fifo_full[i]),
//    .valid(fifo_valid[i]),
//    .rd_rst_busy(),
//    .wr_rst_busy(),
//    .din    ({vid_i_e[i],vid_i_d[(i+1)*DW-1:i*DW]}),
//    .wr_en  (wr_en[i]),
//    .dout   ({oe_en[i],dout[(i+1)*DW-1:i*DW]}),
//    .rd_en  (rd_en[i]),
//    .wr_clk (wr_clk),
//    .rd_clk (rd_clk),
//    .rst    (rst_x[31]));
//end
//endgenerate 

//assign  vid_o_d = ( fifo_valid[MC]) ? dout :  0;
//assign  vid_o_e =   {CN{fifo_valid[MC] & oe_en[MC]}};
//assign  vid_o_h =   ehv[DP/2][CN*2-1:CN*1];
//assign  vid_o_v =   ehv[DP/2][CN*1-1:CN*0];

//endmodule
