`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2023 03:33:42 AM
// Design Name: 
// Module Name: vx1_debug
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


module vx1_debug #(
    parameter DW = 32,
    parameter CN = 32,
    parameter VIDEO_TIMING  = "4K",
	parameter AL            = 8)(
	input	[31:0] VIO_HT,		VIO_VT,
	input	[31:0] VIO_HF,		VIO_VF,
	input	[31:0] VIO_HB,		VIO_VS,
    input   vio_gt_loopback,    vio_tx_tpg_en,  [4:0]vio_rx_ch_sel,
    input   [CN-1:0] vx1_rx_de,vx1_rx_hs,vx1_rx_vs,[CN*DW-1:0]vx1_rx_data,
    output  [CN-1:0] vx1_tx_de,vx1_tx_hs,vx1_tx_vs,[CN*DW-1:0]vx1_tx_data, [575:0]vx1_tx_data_1,
    output  reg [15:0] htotal,hact,vtotal,vact,frate,vfp,vsw,vbp,vblk,
    output  SYNC_LOCK,
    input   vx1_pclk,axi_clk,
    input   wire vio_sync_inv,
    //Added on 20240710 by dykim
    output reg [15:0] line_num_out,
    input   tmc_enc_init, 
    input   enc_sw_rst,
    input   clk_168_48, 
    input   m_axis_video_tready_f,
    input   m_axis_video_tready_s,
    // TMC data debugging
    input wire [143:0] ENC_INPUT_DATA_f,
    input wire [143:0] ENC_INPUT_DATA_s,
    input wire [127:0] ENC_OUTPUT_DATA_f,
    input wire [127:0] ENC_OUTPUT_DATA_s,
    input wire JXSE_INTERRUPT_f,
    input wire JXSE_INTERRUPT_s,
    input wire [12:0]  enc_vcnt_f,
    input wire [12:0]  enc_vcnt_s,

    // GTY data debugging
    input wire 		gty_init_l0,
    input wire 		gty_init_l1,
    input wire [31:0]	enc_dsize,
    input wire 		gty_str_valid_f,
    input wire 		gty_str_valid_s,
    input wire [127:0] 	gty_str_out_f,
    input wire [127:0]  gty_str_out_s,
    input wire		gty_din_ready_f,
    input wire		gty_din_ready_s,

    // time stamp ila
    input wire [31:0] time_stamp_f_ILA,
    input wire [31:0] time_stamp_s_ILA,
    input wire [31:0] time_stamp_vs_ILA,
	    
    // Encoder data count ila
    input wire [31:0] enc_in_cnt_s_ila,
    input wire [31:0] enc_in_cnt_f_ila,
    input wire [31:0] enc_out_cnt_s_ila,
    input wire [31:0] enc_out_cnt_f_ila,

    // Line selector ila
    input wire 		line_sel_de_line_ila,
    input wire 		line_sel_vs_1d_ila,
    input wire		line_sel_hs_1d_ila,
    input wire [575:0]	line_sel_vx1_data_ila,
    input wire [578:0]	line_sel_data_in_ila,
    input wire [10:0]	line_sel_cnt1920_2d_ila,
    input wire [11:0]	line_sel_DE_cnt_2d_ila,
    input wire		line_sel_de_out_ila,
    input wire		line_sel_op_en_ila,
    input wire [9:0]	line_sel_address_12_ila,
    input wire [9:0]	line_sel_address_34_ila,
    input wire [290:0]	line_sel_data_out1_ila,
    input wire [290:0]	line_sel_data_in1_ila,
    input wire		line_sel_we1_ila,
    input wire [2:0]	line_sel_data_out_h_ila,
    input wire		line_sel_DE_1d_ila,

    input wire [31:0]	tgt_size_tbl0,
    input wire [31:0]	tgt_size_tbl1,
    input wire [31:0]	tgt_size_tbl2,
    input wire [31:0]	tgt_size_tbl3,
    input wire [31:0]	tgt_size_tbl4,
    input wire [31:0]	tgt_size_tbl5,
    input wire [31:0]	tgt_size_tbl6,
    input wire [31:0]	tgt_size_tbl7,

    input wire [31:0]	frame_cnt,
    input wire [31:0]	fail_cnt,
    input wire [31:0]	int_f_cnt,
    input wire [31:0]	int_s_cnt,
    input wire 		param_change_ILA,

    input wire		gty_wr_en_b0_l0_ila,
    input wire		gty_wr_en_b1_l0_ila,
    input wire		gty_wr_en_b0_l1_ila,
    input wire		gty_wr_en_b1_l1_ila,
    input wire		gty_alm_full_b0_l0_ila,
    input wire		gty_alm_full_b1_l0_ila,
    input wire		gty_alm_full_b0_l1_ila,
    input wire		gty_alm_full_b1_l1_ila,
    input wire		gty_empty_b0_l0_ila,
    input wire		gty_empty_b1_l0_ila,
    input wire		gty_empty_b0_l1_ila,
    input wire		gty_empty_b1_l1_ila,
    input wire [7:0]	gty_wr_data_count_b0_l0_ila,
    input wire [7:0]	gty_wr_data_count_b1_l0_ila,
    input wire [7:0]	gty_wr_data_count_b0_l1_ila,
    input wire [7:0]	gty_wr_data_count_b1_l1_ila,
    input wire [9:0]	gty_rd_data_count_b0_l0_ila,
    input wire [9:0]	gty_rd_data_count_b1_l0_ila,
    input wire [9:0]	gty_rd_data_count_b0_l1_ila,
    input wire [9:0]	gty_rd_data_count_b1_l1_ila,
    input wire [7:0]	gty_wr_cnt_l0_ila,
    input wire [7:0]	gty_wr_cnt_l1_ila,
    input wire [31:0]   gty_userdata_tx_int_ila,
    input wire          dout_valid_ILA,
    input wire [31:0]   dout_ILA,
    input wire          gty_txpmaresetdone_int_ILA
    );

localparam CH_NUM = CN;

wire [DW*CH_NUM-1:0]   vx1_rx_data_rvs;
genvar j;
generate
    for (j=0 ;j< CH_NUM ;j=j+1 ) begin
        assign vx1_rx_data_rvs[(j+1)*DW-1:j*DW] =   vx1_rx_data[(CH_NUM-j)*DW-1:(CH_NUM-j-1)*DW];
    end
endgenerate
reg  [   CH_NUM-1:0]   vid_rx0_de,   vid_rx0_hs,  vid_rx0_vs;
reg  [DW*CH_NUM-1:0]   vid_rx0_data;

always @ (posedge vx1_pclk)begin
    vid_rx0_de    <= vx1_rx_de;  vid_rx0_hs    <= vio_sync_inv ? ~vx1_rx_hs : vx1_rx_hs;  vid_rx0_vs    <= vio_sync_inv ? ~vx1_rx_vs : vx1_rx_vs; 
    vid_rx0_data  <= (vio_gt_loopback == 0) ? vx1_rx_data : vx1_rx_data_rvs; 
end
assign tx_tpg_en = vio_tx_tpg_en;

wire  [   CH_NUM-1:0]   vid_tpg_de, vid_tpg_hs, vid_tpg_vs;
wire  [DW*CH_NUM-1:0]   vid_tpg_data;


localparam VDW = 10;
localparam HN     = VIDEO_TIMING == "8K" ? 4 : 2;
localparam VN     = VIDEO_TIMING == "8K" ? 4 : 2;
localparam HTOTAL = 2496*HN/(AL);
localparam HACT   = 1920*HN/(AL);
localparam VTOTAL = 1125*VN;
localparam VACT   = 1080*VN;

vid_tpg #(.CN(AL),.HN(HN),.VN(VN))vid_tpg(VIO_HT,VIO_HF,VIO_HB,VIO_VT,VIO_VF,VIO_VS,vid_tpg_de, vid_tpg_hs, vid_tpg_vs, vid_tpg_data,   vx1_pclk,   tx_tpg_en);

assign vx1_tx_de    = tx_tpg_en ? vid_tpg_de     : vid_rx0_de    ;
assign vx1_tx_hs    = tx_tpg_en ? vid_tpg_hs     : vid_rx0_hs    ;
assign vx1_tx_vs    = tx_tpg_en ? vid_tpg_vs     : vid_rx0_vs    ;
assign vx1_tx_data  = tx_tpg_en ? vid_tpg_data   : vid_rx0_data;


wire [ DW-1:0]  vid_rx_ch   [CH_NUM-1:0];
wire [VDW-1:0]  vid_rx_r    [CH_NUM-1:0];
wire [VDW-1:0]  vid_rx_g    [CH_NUM-1:0];
wire [VDW-1:0]  vid_rx_b    [CH_NUM-1:0];

wire [11:0]  vid_rx_r_0    [CH_NUM-1:0];
wire [11:0]  vid_rx_g_0    [CH_NUM-1:0];
wire [11:0]  vid_rx_b_0    [CH_NUM-1:0];
wire [35:0]  vid_rx_0      [CH_NUM-1:0];
wire [1151:0] vx1_tx_data_0;

generate
    for (j=0 ;j< CH_NUM ;j=j+1 ) begin
        //assign vid_rx_ch[j]     =  vid_rx0_data[(j+1)*DW-1:j*DW];
        assign vid_rx_ch[j]     =  tx_tpg_en ?  vid_tpg_data[(j+1)*DW-1:j*DW] : vid_rx0_data[(j+1)*DW-1:j*DW]; // Modified on 2023/12/04
        assign vid_rx_r [j]     = {vid_rx_ch[j][(VDW-2)*1-1:(VDW-2)*0],vid_rx_ch[j][DW-2],vid_rx_ch[j][DW-1]};
        assign vid_rx_g [j]     = {vid_rx_ch[j][(VDW-2)*2-1:(VDW-2)*1],vid_rx_ch[j][DW-4],vid_rx_ch[j][DW-3]};
        assign vid_rx_b [j]     = {vid_rx_ch[j][(VDW-2)*3-1:(VDW-2)*2],vid_rx_ch[j][DW-6],vid_rx_ch[j][DW-5]};
        
        assign vid_rx_r_0 [j]     = {vid_rx_ch[j][(VDW-2)*1-1:(VDW-2)*0],vid_rx_ch[j][DW-2],vid_rx_ch[j][DW-1],2'b00};
        assign vid_rx_g_0 [j]     = {vid_rx_ch[j][(VDW-2)*2-1:(VDW-2)*1],vid_rx_ch[j][DW-4],vid_rx_ch[j][DW-3],2'b00};
        assign vid_rx_b_0 [j]     = {vid_rx_ch[j][(VDW-2)*3-1:(VDW-2)*2],vid_rx_ch[j][DW-6],vid_rx_ch[j][DW-5],2'b00};
        assign vid_rx_0[j]        = {vid_rx_r_0 [j], vid_rx_b_0 [j], vid_rx_g_0 [j]};
    end
endgenerate

assign vx1_tx_data_0 = {vid_rx_0[31], vid_rx_0[30], vid_rx_0[29], vid_rx_0[28], vid_rx_0[27], vid_rx_0[26], vid_rx_0[25], vid_rx_0[24], 
vid_rx_0[23], vid_rx_0[22], vid_rx_0[21], vid_rx_0[20], vid_rx_0[19], vid_rx_0[18], vid_rx_0[17], vid_rx_0[16], vid_rx_0[15], vid_rx_0[14],
 vid_rx_0[13], vid_rx_0[12], vid_rx_0[11], vid_rx_0[10], vid_rx_0[9], vid_rx_0[8], vid_rx_0[7], vid_rx_0[6], vid_rx_0[5], vid_rx_0[4],
  vid_rx_0[3], vid_rx_0[2], vid_rx_0[1], vid_rx_0[0]} ;
  
assign vx1_tx_data_1 = vx1_tx_data_0 [575:0];  

reg     [ DW-1:0]   vid_rx_cd;
reg     [VDW-1:0]   vid_rx_rd,  vid_rx_gd,  vid_rx_bd;
reg  [   CH_NUM-1:0]   vid_rx_de,   vid_rx_hs,  vid_rx_vs;
reg  [DW*CH_NUM-1:0]   vid_rx_data;

always @ (posedge vx1_pclk)begin
	{vid_rx_de,   vid_rx_hs,  vid_rx_vs ,vid_rx_data}	<= {vid_rx0_de,   vid_rx0_hs,  vid_rx0_vs,	vid_rx0_data};
    vid_rx_cd <= vid_rx_ch[vio_rx_ch_sel];
    vid_rx_rd <= vid_rx_r [vio_rx_ch_sel];
    vid_rx_gd <= vid_rx_g [vio_rx_ch_sel];
    vid_rx_bd <= vid_rx_b [vio_rx_ch_sel];
end

reg [1:0] de_s, vs_s,de_f,vs_f;
reg [15:0] line_num,hs_cnt,pixel_num, fcnt,fly_cnt,hstr,vblank;
reg        hact_ok,fly_hs;
reg [31:0] sec_cnt;
always @ (posedge vx1_pclk)begin
    de_s <= {de_s[0],vx1_tx_de[0]};
    vs_s <= {vs_s[0],vx1_tx_vs[0]};

    if(de_s == 1)   line_num <= line_num + 1;else
    if(vs_s == 1)   line_num <= 0;else
                    line_num <= line_num;

    if(de_s == 1)           pixel_num <= 1;else
                            pixel_num <= pixel_num+1; 

    if(de_s == 1) 	htotal  <= pixel_num <  1000 	? pixel_num			: htotal;
	if(de_s == 1) 	vblank  <= pixel_num  > 1000	? pixel_num-hstr 	: vblank;
    if(de_s == 1)	hstr	<= pixel_num;
    if(de_s	== 2)	hact	<= pixel_num;
                    
    if(de_s == 1)           fly_cnt <= 1;else
    if(fly_cnt == htotal)   fly_cnt <= 1;else
                            fly_cnt <= fly_cnt+1;

    if(fly_cnt == 15)       fly_hs <= 1;else
                            fly_hs <= 0;
    
    if(vs_s == 1)   hs_cnt <= 0;else
    if(fly_hs == 1) hs_cnt <= hs_cnt + 1;else
                    hs_cnt <= hs_cnt;
                   
    if(vs_s == 1)   vtotal  <= hs_cnt;
    if(vs_s == 1)   vact    <= line_num;

    if(vs_s == 1)   vfp		<= pixel_num-(htotal);
    if(vs_s == 2)   vsw		<= pixel_num-(htotal+vfp);
    if(de_s == 1)   vbp		<= pixel_num > htotal+vfp+vsw ? pixel_num-(htotal+vfp+vsw)	: vbp;
    if(de_s == 1)   vblk	<= pixel_num > htotal+vfp+vsw ? pixel_num-htotal			: vblk;

    hact_ok   <= (hact   == HACT)    ? 1 : 0;
    sec_cnt <= de_s ? 0 : sec_cnt < 1023*100 ? sec_cnt + 1 : sec_cnt;
end

assign SYNC_LOCK = sec_cnt < 1023*100-1 ? hact_ok :0;

wire [31:0] vsync_freq;
clk_freq#(100*1000*1000)	vsync_freq_0 (axi_clk,vs_s[1],vsync_freq); 

always @(posedge axi_clk) frate <= vsync_freq[15:0];

vx1_vid_ila vx1_vid_ila (
	//.clk       (vx1_pclk),
	.clk       (clk_168_48), // Modified on 240710 by dykim
	.probe0    (vid_rx_vs),
	.probe1    (vid_rx_hs),
	.probe2    (vid_rx_de),
	.probe3    (vid_rx_data),
	.probe4    (line_num),
	.probe5    (pixel_num),
    .probe6    (vid_rx_cd),
	.probe7    (vid_rx_rd),
    .probe8    (vid_rx_gd),
	.probe9    (vid_rx_bd),
		//Added on 240710 by dykim
		// TMC Data Debugging port
	.probe10   (ENC_INPUT_DATA_f), //144
	.probe11   (ENC_OUTPUT_DATA_f), //128
	.probe12   (JXSE_INTERRUPT_f), //1

	// Frame Fin
	.probe13   (tmc_enc_init),  //1

        // enc vcnt f,s
	.probe14   (enc_vcnt_f), //13
	.probe15   (enc_vcnt_s), //13
	
	// TMC Data Debugging port
	.probe16   (ENC_INPUT_DATA_s), //144
	.probe17   (ENC_OUTPUT_DATA_s), //128
	.probe18   (JXSE_INTERRUPT_s), //1

	// GTY data debugging
	.probe19   (gty_din_ready_f), //1
	.probe20   (gty_din_ready_s), //1

	// time stamp
	.probe21   (time_stamp_f_ILA), //32

	// Encoder data count
	.probe22   (enc_in_cnt_s_ila), //32
	.probe23   (enc_in_cnt_f_ila), //32
	.probe24   (enc_out_cnt_s_ila), //32
	.probe25   (enc_out_cnt_f_ila), //32
	
	.probe26   (fail_cnt), //32
	.probe27   (frame_cnt),//32
	.probe28   (enc_sw_rst),//1
	.probe29   (time_stamp_s_ILA),//32
	.probe30   (time_stamp_vs_ILA),//32
	.probe31   (gty_init_l0),//1
	.probe32   (gty_init_l1),//1
	.probe33   (gty_str_valid_f),//1
	.probe34   (m_axis_video_tready_f),//1
	.probe35   (m_axis_video_tready_s),//1
	.probe36   (gty_str_valid_s),//1
	.probe37   (enc_dsize),//32
	.probe38   (param_change_ILA),//1
	.probe39   (gty_userdata_tx_int_ila),//32
	.probe40   (dout_valid_ILA),//1
	.probe41   (dout_ILA),//32
	.probe42   (gty_wr_en_b0_l0_ila),
	.probe43   (gty_wr_en_b0_l1_ila),
	.probe44   (gty_empty_b0_l0_ila),
	.probe45   (gty_empty_b0_l1_ila),
	.probe46   (gty_wr_data_count_b0_l0_ila),//8
	.probe47   (gty_wr_data_count_b0_l1_ila),//8
	.probe48   (gty_rd_data_count_b0_l0_ila),//10
	.probe49   (gty_rd_data_count_b0_l1_ila),//10
	.probe50   (gty_wr_cnt_l0_ila),//8
	.probe51   (gty_txpmaresetdone_int_ILA)//1
	 );

endmodule
