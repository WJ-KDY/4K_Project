`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: wise-jet
// Engineer: yj
// 
// Create Date: 2024/09/23
// Design Name: MAC Interface
// Module Name: mac_rx_if
// Project Name: vx1
// Target Devices: xcku15p-ffve1517-3-e

// Tool Versions: vivado 2022.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////
//`define AUD
module mac_rx_if (

    input clk,
    input rstn,
    input mac_trans_ready,
    input dec_start,
    input pic_end,
    output logic [3:0] frame_start_cnt,

    input [31:0] s_axis_tdata,
    input [3:0] s_axis_tkeep,
    input s_axis_tvalid,
    input s_axis_tlast,
    output logic s_axis_tready,

    output logic [127:0] vid_do0,
    output logic [127:0] vid_do1,
    output logic vid_do_valid0,
    output logic vid_do_valid1,
    input decoder_ready0,
    input decoder_ready1,

    input clk_aud,
    input aud_rst,
    output logic [31:0] aud_do,
    output logic aud_valid,
    input aud_rd_en,
    output logic aud_fifo_empty
);

(*mark_debug = "true"*)enum logic [3:0] {IDLE, RX_RDY, RX_VID, WAIT_PIC_END, RX_DUMMY, RX_AUD} state;

logic [17:0] di_cnt;
logic [7:0] packet_format;
logic [15:0] block_id;
logic [31:0] packet_id;


(*mark_debug = "true"*)logic vid_en;
(*mark_debug = "true"*)logic aud_en;
(*mark_debug = "true"*)logic frame_start;
(*mark_debug = "true"*)logic preamble;

(*mark_debug = "true"*)logic vid_fifo0_empty, vid_fifo1_empty;
(*mark_debug = "true"*)logic vid_fifo0_full, vid_fifo1_full;
(*mark_debug = "true"*)logic vid_fifo0_rd_busy, vid_fifo1_rd_busy;
(*mark_debug = "true"*)logic [1:0] vid_wcnt;
(*mark_debug = "true"*)logic wr_sel;

(*mark_debug = "true"*)logic vid_fifo0_wr_en;
(*mark_debug = "true"*)logic vid_fifo1_wr_en;
(*mark_debug = "true"*)logic fifo_rst;
logic [3:0] dec_start_cnt;
logic [3:0] pic_end_cnt;

(*mark_debug = "true"*)logic [11:0] aud_fifo_rd_count;
(*mark_debug = "true"*)logic aud_fifo_wr_rst_busy, aud_fifo_rd_rst_busy;
(*mark_debug = "true"*)logic aud_fifo_full;
(*mark_debug = "true"*)logic [15:0] aud_en_cnt;
(*mark_debug = "true"*)logic [31:0] frame_cnt;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        dec_start_cnt <= 'h0;
    end
    else if (dec_start) begin
        dec_start_cnt <= 'h1;
    end
    else if (|dec_start_cnt) begin
        dec_start_cnt <= dec_start_cnt + 1'b1;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        pic_end_cnt <= 'h0;
    end
    else if (pic_end) begin
        pic_end_cnt <= 'h1;
    end
    else if (|pic_end_cnt) begin
        pic_end_cnt <= pic_end_cnt + 1'b1;
    end
end

//assign fifo_rst = ~mac_trans_ready | ~rstn ;
//assign fifo_rst = ~rstn | (|dec_start_cnt) | (|pic_end_cnt);
assign fifo_rst = ~rstn | (|frame_start_cnt);

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        di_cnt <= 'h0;
    end
    else if (s_axis_tlast & s_axis_tready) begin
        di_cnt <= 'h0;
    end
    else if (s_axis_tvalid & s_axis_tready) begin
        di_cnt <= di_cnt + 1'b1;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        packet_format <= 'h0;
    end
    else if (s_axis_tvalid & di_cnt == 18'h0) begin
        packet_format <= s_axis_tdata[0+:8];
    end
end

assign frame_start = (s_axis_tvalid & di_cnt == 18'h1) &
        ((s_axis_tdata == 32'h0) & (packet_format == 8'h1));

//logic [3:0] frame_start_cnt;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        frame_start_cnt <= 'h0;
    end
    else if (frame_start) begin
        frame_start_cnt <= 4'h1;
    end
    else if (|frame_start_cnt) begin
        frame_start_cnt <= frame_start_cnt + 1'b1;
    end
end

(*mark_debug = "true"*)logic [31:0] frame_start_interval;
always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        frame_start_interval <= 'h0;
    end
    else if (frame_start) begin
        frame_start_interval <= 4'h1;
    end
    else begin
        frame_start_interval <= frame_start_interval + 1'b1;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        block_id <= 'h0;
    end
    else if (s_axis_tvalid & di_cnt == 18'h0) begin
        block_id <= s_axis_tdata[16+:16];
    end
end

(*mark_debug = "true"*)logic packet_id_err;
always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        packet_id <= 'h0;
        packet_id_err <= 'h0;
    end
    else if (s_axis_tvalid & di_cnt == 18'h1) begin
        packet_id <= s_axis_tdata;

        if ((s_axis_tdata != 'h0) & ((s_axis_tdata - packet_id) > 32'h1)) begin
            packet_id_err <= 1'b1;
        end
        else packet_id_err <= 1'b0;
    end
end

//assign preamble = (packet_id == 'h0) & ((di_cnt >= 18'h2) & (di_cnt <= 18'h9));
assign preamble = (packet_id == 'h1) & ((di_cnt >= 18'h2) & (di_cnt <= 18'h9));


assign vid_en = (packet_format <= 8'd3) & (state == RX_VID) & ~preamble & (di_cnt >= 18'h2);

`ifdef AUD
assign aud_en = (packet_format == 8'ha) & (di_cnt >= 18'h2);
`else
assign aud_en = 1'b0;
`endif

logic [2:0] wait_cnt;
//assign s_axis_tready = ~(state == WAIT_PIC_END) ;
assign s_axis_tready = ~(|wait_cnt);

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        wait_cnt <= 'h0;
    end
    else if (|wait_cnt) begin
        wait_cnt <= wait_cnt + 1'b1;
    end
    else if (s_axis_tvalid & s_axis_tlast) begin
        wait_cnt <= 3'd1;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        vid_wcnt <= 'h0;
    end
    else if (frame_start) begin
        vid_wcnt <= 'h0; 
    end
    else if (s_axis_tvalid & vid_en) begin
        vid_wcnt <= vid_wcnt + 1'b1;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        wr_sel <= 'h0;
    end
    else if (frame_start) begin
        wr_sel <= 'h0; 
    end
    else if (s_axis_tvalid & vid_en & (vid_wcnt == 2'h3)) begin
        wr_sel <= ~wr_sel;
    end
end

assign vid_fifo0_wr_en = ~wr_sel & s_axis_tvalid & vid_en;
assign vid_fifo1_wr_en =  wr_sel & s_axis_tvalid & vid_en;

(*mark_debug = "true"*)logic [31:0] vid_di_cnt;
always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        vid_di_cnt <= 'h0;
    end
    else if (frame_start) begin
        vid_di_cnt <= 'h0;
    end
    else if (s_axis_tvalid & vid_en) begin
        vid_di_cnt <= vid_di_cnt + 1'b1;
    end
end

(*mark_debug = "true"*)logic vid_rd_sel;
assign vid_do_valid0 = decoder_ready0 & ~vid_fifo0_empty & ~vid_fifo0_rd_busy & ~vid_rd_sel;
assign vid_do_valid1 = decoder_ready1 & ~vid_fifo1_empty & ~vid_fifo1_rd_busy &  vid_rd_sel;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        vid_rd_sel <= 'h0;
    end
    //else if (state == IDLE) begin
    else if (pic_end) begin
        vid_rd_sel <= 'h0;
    end
    else if (vid_do_valid0) begin
        vid_rd_sel <= 1'b1;
    end
    else if (vid_do_valid1) begin
        vid_rd_sel <= 1'b0;
    end    
end

(*mark_debug = "true"*)logic [31:0] vid_do_cnt0;
(*mark_debug = "true"*)logic [31:0] vid_do_cnt1;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        vid_do_cnt0 <= 'h0;
    end
    else if (frame_start) begin
        vid_do_cnt0 <= 'h0;
    end
    else if (vid_do_valid0) begin
        vid_do_cnt0 <= vid_do_cnt0 + 1'b1;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        vid_do_cnt1 <= 'h0;
    end
    else if (frame_start) begin
        vid_do_cnt1 <= 'h0;
    end
    else if (vid_do_valid1) begin
        vid_do_cnt1 <= vid_do_cnt1 + 1'b1;
    end
end

// for DP source
logic [3:0] dummy_cnt;
logic dummy_en;

// state machine
always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        state <= IDLE;
        frame_cnt <= 'h0;

        dummy_cnt <= 'h0;
        dummy_en <= 'h0;        
    end
    else begin
        case (state) 
        IDLE: begin
            dummy_cnt <= 'h0;
            dummy_en <= 'h0;                 
            if ((|dec_start_cnt) | (|pic_end_cnt)) begin
                state <= RX_RDY;
            end
            else if (frame_start) begin
                state <= RX_VID;
            end
        end
        RX_RDY: begin
            if (frame_start) begin
                state <= RX_VID;
            end
        end
        RX_VID: begin
            if ((packet_format == 8'h2) & s_axis_tlast) begin
                //state <= WAIT_PIC_END;
                //state <= IDLE;
                state <= RX_DUMMY;
                dummy_en <= 1'b1;
                dummy_cnt <= 4'h0;                
                frame_cnt <= frame_cnt + 1'b1;
            end
        end
        RX_DUMMY: begin
            dummy_cnt <= dummy_cnt + 1'b1;
            if (dummy_cnt == 4'h7) begin
                dummy_en <= 1'b0;
                dummy_cnt <= 4'h0;
                state <= IDLE;
            end

        end        
        WAIT_PIC_END: begin
            if (pic_end) begin
                state <= IDLE;
            end
        end
        default: state <= IDLE;
        endcase
    end
end

(*mark_debug = "true"*)logic vid_overflow;
always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        vid_overflow <= 'h0;
    end
    else if (state == WAIT_PIC_END & frame_start) begin
        vid_overflow <= 1'h1; 
    end
    else if (state == IDLE & frame_start) begin
        vid_overflow <= 1'b0;
    end
end

afifo_32to128 i_vid_fifo_0 (
    .rst (fifo_rst),
    .wr_clk (clk),
    .rd_clk (clk),
    .din (s_axis_tdata),
    .wr_en (vid_fifo0_wr_en),
    .rd_en (vid_do_valid0),
    .dout (vid_do0),
    .full (vid_fifo0_full),
    .empty (vid_fifo0_empty),
    .wr_rst_busy (vid_fifo0_wr_busy),
    .rd_rst_busy (vid_fifo0_rd_busy)
);

afifo_32to128 i_vid_fifo_1 (
    .rst (fifo_rst),
    .wr_clk (clk),
    .rd_clk (clk),
    .din (s_axis_tdata),
    .wr_en (vid_fifo1_wr_en),
    .rd_en (vid_do_valid1),
    .dout (vid_do1),
    .full (vid_fifo1_full),
    .empty (vid_fifo1_empty),
    .wr_rst_busy (vid_fifo1_wr_busy),
    .rd_rst_busy (vid_fifo1_rd_busy)
);

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        aud_en_cnt <= 'h0;
    end
    else if (frame_start) begin
        aud_en_cnt <= 'h0; 
    end
    else if (aud_en & s_axis_tvalid) begin
        aud_en_cnt <= aud_en_cnt + 1'b1;
    end
end

afifo_32x4096_l1 i_audio_fifo (
    .rst (~rstn | aud_rst),
    .wr_clk (clk),
    .rd_clk (clk_aud),
    .din (s_axis_tdata),
    .wr_en (aud_en & s_axis_tvalid),
    .rd_en (aud_rd_en),
    .dout (aud_do),
    .full (aud_fifo_full),
    .empty (aud_fifo_empty),
    .valid (aud_valid),
    .wr_rst_busy (aud_fifo_wr_rst_busy),
    .rd_rst_busy (aud_fifo_rd_rst_busy),
    .rd_data_count (aud_fifo_rd_count)
);

(*mark_debug = "true"*)logic [31:0] aud_do_ff;
(*mark_debug = "true"*)logic aud_do_err;

always_ff @(posedge clk_aud or negedge rstn) begin
    if (~rstn) begin
        aud_do_ff <= 'h0;
    end
    else if (aud_valid) begin
        aud_do_ff <= aud_do;
    end
end

assign aud_do_err = (aud_valid) & (aud_do_ff != aud_do - 1);

endmodule