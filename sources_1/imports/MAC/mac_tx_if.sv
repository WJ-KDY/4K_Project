`include "define.vh"
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: wise-jet
// Engineer: yj
// 
// Create Date: 2024/09/19
// Design Name: MAC Interface
// Module Name: mac_if
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

module mac_tx_if (

    input clk,
    input rstn,
    input mac_trans_ready,
    input [19:0] mac_payload_size,
    input [23:0] tgt_size,

    (*mark_debug = "true"*)output logic [19:0] mac_frame_size,
    (*mark_debug = "true"*)input audio_tp_en,

    input frame_start,
    input frame_end,
    //output logic [11:0] video_fifo_rd_count,

    input clk_vid,
    (*mark_debug = "true"*)input video_di_en,
    (*mark_debug = "true"*)input [31:0] video_di,

    (*mark_debug = "true"*)input clk_aud,
    (*mark_debug = "true"*)input audio_di_en,
    (*mark_debug = "true"*)input [31:0] audio_di,

    (*mark_debug = "true"*)output m_axis_tvalid,
    (*mark_debug = "true"*)output [31:0] m_axis_tdata,
    (*mark_debug = "true"*)output [3:0] m_axis_tkeep,
    (*mark_debug = "true"*)output m_axis_tlast,
    (*mark_debug = "true"*)input m_axis_tready

);
(*mark_debug = "true"*)enum logic [3:0] {IDLE, TX_LEADER, TX_RDY, TX_VID, TX_AUD_RDY, TX_AUD, TX_BLANK} state;

logic frame_end_ff0, frame_end_ff1;
logic frame_end_r;
logic frame_start_ff0, frame_start_ff1;
logic frame_start_r;

(*mark_debug = "true"*)logic vid_last;

(*mark_debug = "true"*)logic [17:0] wcnt;
logic vid_last_ff0, vid_last_ff1;
logic vid_last_r;
(*mark_debug = "true"*)logic vid_last_pkt;
(*mark_debug = "true"*)logic vid_tlast;

logic video_rd_en;
logic [31:0] video_do;
(*mark_debug = "true"*)logic video_fifo_full, video_fifo_empty;
(*mark_debug = "true"*)logic video_fifo_wr_rst_busy;
(*mark_debug = "true"*)logic video_fifo_rd_rst_busy;
(*mark_debug = "true"*)logic [12:0] video_fifo_rd_count;

(*mark_debug = "true"*)logic frame_start_sync;
(*mark_debug = "true"*)logic frame_end_sync;

(*mark_debug = "true"*)logic [7:0] packet_format;
// Sequential and incrementing starting at 1.
(*mark_debug = "true"*)logic [15:0] block_id; 
// packet counter, reset to 0 at the start of each data block
(*mark_debug = "true"*)logic [31:0] packet_id; 

logic aud_wr_0;
logic aud_wr_1;
(*mark_debug = "true"*)logic aud_rd_en_0;
(*mark_debug = "true"*)logic aud_rd_en_1;
(*mark_debug = "true"*)logic [31:0] aud_dout_0;
logic [31:0] aud_dout_1;
(*mark_debug = "true"*)logic aud_rd_en;
(*mark_debug = "true"*)logic aud_fifo0_full;
(*mark_debug = "true"*)logic aud_fifo1_full;
(*mark_debug = "true"*)logic aud_fifo0_empty;
(*mark_debug = "true"*)logic aud_fifo1_empty;
logic aud_fifo0_wr_rst_busy;
logic aud_fifo1_wr_rst_busy;
logic aud_fifo0_rd_rst_busy;
logic aud_fifo1_rd_rst_busy;
(*mark_debug = "true"*)logic [12:0] aud_fifo0_rd_count;
(*mark_debug = "true"*)logic [12:0] aud_fifo1_rd_count;
(*mark_debug = "true"*)logic aud_last;
(*mark_debug = "true"*)logic [12:0] aud_size;
(*mark_debug = "true"*)logic wr_mem_sel, rd_mem_sel;
(*mark_debug = "true"*)logic [31:0] aud_do;
logic [4:0] aud_read_delay;
logic aud_en;
logic audio_tp_en_sync;
logic [1:0] tx_blank_cnt;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        frame_start_ff0 <= 'h0;
        frame_start_ff1 <= 'h0;
    end
    else begin
        frame_start_ff0 <= frame_start_sync;
        frame_start_ff1 <= frame_start_ff0;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        frame_end_ff0 <= 'h0;
        frame_end_ff1 <= 'h0;
    end
    else begin
        frame_end_ff0 <= frame_end_sync;
        frame_end_ff1 <= frame_end_ff0;
    end
end

assign frame_start_r = ~frame_start_ff1 & frame_start_ff0;
assign frame_end_r = ~frame_end_ff1 & frame_end_ff0;

reg [3:0] frame_start_cnt;
always_ff @(posedge clk_vid or negedge rstn) begin
    if (~rstn) begin
        frame_start_cnt <= 'h0;
    end
    else if (|frame_start_cnt) begin
        frame_start_cnt <= frame_start_cnt + 1'b1;
    end
    else if (frame_start) begin
        frame_start_cnt <= 4'h1;
    end
end

bit_sync #(.INITIALIZE(5'b00000)) i_bit_sync_frame_start (
    .clk_in (clk),
    .i_in (|frame_start_cnt),
    .o_out (frame_start_sync) 
);

bit_sync #(.INITIALIZE(5'b00000)) i_bit_sync_frame_end (
    .clk_in (clk),
    .i_in (frame_end), 
    .o_out (frame_end_sync)
);

bit_sync #(.INITIALIZE(5'b00000)) i_bit_sync_aud_tp (
    .clk_in (clk_aud),
    .i_in (audio_tp_en),
    .o_out (audio_tp_en_sync) 
);
//-------------------------------------------------------------------
// Calculating the number of packets and the size of the final packet 
// in bytes. 
//-------------------------------------------------------------------
logic [25:0] tot_size;
(*mark_debug = "true"*)logic [31:0] vid_di_cnt;
logic video_di_valid;

assign video_di_valid = video_di_en & (state != IDLE);
assign tot_size = (|tgt_size[3:0]) ? ((tgt_size + (16-tgt_size[3:0])) << 1) + 32 : (tgt_size << 1) + 32; // preamble 32

always_ff @(posedge clk_vid or negedge rstn) begin
    if (~rstn) begin
        vid_di_cnt <= 'h0;
    end
    else if (frame_start) begin
        vid_di_cnt <= 'h0;
    end
    else if (video_di_valid) begin
        vid_di_cnt <= vid_di_cnt + 1'b1;
    end
end

// divider (latency = 34)
logic div_dout_valid;
logic [31:0] div_dout_q;
logic [31:0] div_dout_r;
logic [31:0] tot_packet_num;
logic [31:0] last_byte_num;

div_gen_32x32 i_div_padding_size (
    .aclk (clk),
    .s_axis_divisor_tvalid (frame_start_r),
    .s_axis_divisor_tdata ({12'h0, mac_payload_size-8}), // header 8 bytes
    .s_axis_dividend_tvalid (frame_start_r),
    .s_axis_dividend_tdata ({6'h0, tot_size}), // 2 codec    
    .m_axis_dout_tdata ({div_dout_q, div_dout_r}),
    .m_axis_dout_tvalid (div_dout_valid)

);

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        tot_packet_num <= 'h0;
    end
    else if (div_dout_valid) begin
        tot_packet_num <= (|div_dout_r) ? 
                          (mac_payload_size - 8 < div_dout_r) ? div_dout_q + 3 : 
                            div_dout_q + 2 : div_dout_q + 1; // +1 (leader packet)
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        last_byte_num <= 'h0;
    end
    else if (div_dout_valid) begin
        last_byte_num <= div_dout_r;
    end
end

// 32x4096
afifo_32x4096_l0 i_video_fifo (
    .rst (~rstn | (|frame_start_cnt)),
    .wr_clk (clk_vid),
    .rd_clk (clk),
    .din (video_di),
    .wr_en (video_di_valid),
    .rd_en (video_rd_en),
    .dout (video_do),
    .full (video_fifo_full),
    .empty (video_fifo_empty),
    .wr_rst_busy (video_fifo_wr_rst_busy),
    .rd_rst_busy (video_fifo_rd_rst_busy),
    .rd_data_count (video_fifo_rd_count)
);

logic wr_mem_sel_sync;
bit_sync #(.INITIALIZE(5'b00000)) i_bit_sync_wr_mem_sel (
    .clk_in (clk),
    .i_in (wr_mem_sel),
    .o_out (wr_mem_sel_sync) 
);


// Audio BRAM, 96khz
assign aud_wr_0 = ~wr_mem_sel & audio_di_en & aud_en;
assign aud_wr_1 =  wr_mem_sel & audio_di_en & aud_en;

always_ff @(posedge clk_aud or negedge rstn) begin
    if (~rstn) begin
        wr_mem_sel <= 'h0;
        rd_mem_sel <= 'h0;
    end
    else if (vid_last_r) begin
        wr_mem_sel <= ~wr_mem_sel;
        rd_mem_sel <= ~rd_mem_sel;
    end

end

logic rd_mem_sel_sync;
bit_sync #(.INITIALIZE(5'b00000)) i_bit_sync_rd_mem_sel (
    .clk_in (clk),
    .i_in (rd_mem_sel),
    .o_out (rd_mem_sel_sync) 
);

assign aud_do = (rd_mem_sel_sync) ? aud_dout_0 : aud_dout_1;

// latency 2 clock
assign aud_rd_en_0 = aud_rd_en & rd_mem_sel_sync & aud_en; 
assign aud_rd_en_1 = aud_rd_en & ~rd_mem_sel_sync & aud_en;

(*mark_debug = "true"*)logic [31:0] audio_m_di;
(*mark_debug = "true"*)logic [31:0] audio_tp_di;

always_ff @(posedge clk_aud or negedge rstn)
    if (~rstn) begin
        audio_tp_di <= 'h0;
    end
    else if (audio_di_en) begin
        audio_tp_di <= audio_tp_di + 1'b1;
    end

assign audio_m_di = (audio_tp_en_sync) ? audio_tp_di : audio_di;

afifo_32x4096_l0 i_aud_fifo_0 (
    .rst (~rstn),
    .wr_clk (clk_aud),
    .rd_clk (clk),
    .din (audio_m_di),
    .wr_en (aud_wr_0),
    .rd_en (aud_rd_en_0),
    .dout (aud_dout_0),
    .full (aud_fifo0_full),
    .empty (aud_fifo0_empty),
    .wr_rst_busy (aud_fifo0_wr_rst_busy),
    .rd_rst_busy (aud_fifo0_rd_rst_busy),
    .rd_data_count (aud_fifo0_rd_count)
);

afifo_32x4096_l0 i_aud_fifo_1 (
    .rst (~rstn),
    .wr_clk (clk_aud),
    .rd_clk (clk),
    .din (audio_m_di),
    .wr_en (aud_wr_1),
    .rd_en (aud_rd_en_1),
    .dout (aud_dout_1),
    .full (aud_fifo1_full),
    .empty (aud_fifo1_empty),
    .wr_rst_busy (aud_fifo1_wr_rst_busy),
    .rd_rst_busy (aud_fifo1_rd_rst_busy),
    .rd_data_count (aud_fifo1_rd_count)
);

bit_sync #(.INITIALIZE(5'b00000)) i_bit_sync_vid_last (
    .clk_in (clk_aud),
    .i_in (vid_last),
    .o_out (vid_last_sync) 
);

always_ff @(posedge clk_aud or negedge rstn) begin
    if (~rstn) begin
        vid_last_ff0 <= 'h0;
        vid_last_ff1 <= 'h0;
    end
    else begin
        vid_last_ff0 <= vid_last_sync;
        vid_last_ff1 <= vid_last_ff0;
    end
end

assign vid_last_r = ~vid_last_ff1 & vid_last_ff0;


always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        wcnt <= 'h0;
    end
    else if (m_axis_tlast) begin
        wcnt <= 'h0;
    end
    else if (m_axis_tvalid & m_axis_tready) begin
        wcnt <= wcnt + 1'b1;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        block_id <= 'h1;
    end
    // `ifdef AUD
    // else if (aud_last) begin
    // `else
    else if ((state == TX_VID) & vid_last_pkt & vid_tlast) begin
    //`endif
        if (block_id == 'hffff) // wraps-around
            block_id <= 'h1;
        else block_id <= block_id + 1'b1;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        packet_id <= 'h0;
    end
    else if (state == IDLE) begin
        packet_id <= 'h0;
    end
    else if (((state == TX_LEADER) | (state == TX_VID) | (state == TX_AUD)) & m_axis_tlast) begin
        packet_id <= packet_id + 1'b1;
    end
end

assign vid_last_pkt = (tot_packet_num-1 == packet_id);
assign vid_tlast = vid_last_pkt & m_axis_tlast;



// state machine
always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        state <= IDLE;
        aud_size <= 'h0;
        vid_last <= 'h0;
        aud_last <= 'h0;
        aud_read_delay <= 'h0;
        aud_en <= 'h0;
        tx_blank_cnt <= 'h0;
    end
    else begin
        case (state) 
        IDLE: begin
            vid_last <= 'h0;
            aud_last <= 'h0;
            tx_blank_cnt <= 'h0;
            `ifdef SIM
            if (frame_start_r) begin
            `else
            if (frame_start_r & mac_trans_ready) begin
            `endif
                //state <= TX_RDY;
                state <= TX_LEADER;
            end
        end
        TX_LEADER: begin
            if (m_axis_tlast) begin
                state <= TX_RDY;
            end
        end
        TX_RDY: begin
            if ({6'h0, video_fifo_rd_count} >= ((mac_frame_size >> 2)-2-1)) begin
                state <= TX_VID;
            end
        end
        TX_VID: begin
            if (vid_last_pkt & vid_tlast) begin
                vid_last <= 1'b1;                
                `ifdef AUD
                state <= TX_AUD_RDY;
                aud_read_delay <= 'h0;
                `ifdef SIM
                if (block_id >= 16'd1) begin
                `else
                if (block_id >= 16'd10) begin
                `endif
                    aud_en <= 1'b1;
                end
                
                `else
                state <= IDLE;
                `endif
            end
            else if (m_axis_tlast) begin
                tx_blank_cnt <= 'h0;
                state <= TX_BLANK;
            end
        end
        TX_AUD_RDY: begin
            aud_read_delay <= aud_read_delay + 1'b1; 
            if (aud_read_delay == 5'h1f) begin // CDC delay
                aud_read_delay <= 'h0;
                

                if (wr_mem_sel_sync)begin 
                    aud_size <= aud_fifo0_rd_count;
                    if (aud_fifo0_rd_count<='h0)
                        state <= IDLE;
                    else
                        state <= TX_AUD;
                end
                else if (~wr_mem_sel_sync) begin
                    aud_size <= aud_fifo1_rd_count;   
                    if (aud_fifo1_rd_count=='h0)
                        state <= IDLE;
                    else
                        state <= TX_AUD;                                 
                end
            end            
        end
        TX_AUD: begin
            if (m_axis_tlast) begin 
                aud_last <= 1'b1;
                state <= IDLE;
            end

        end
        TX_BLANK: begin
            tx_blank_cnt <= tx_blank_cnt + 1'b1;
            if (tx_blank_cnt == 2'h3) begin
                tx_blank_cnt <= 'h0;
                state <= TX_RDY;
            end
        end
        default: state <= IDLE;
        endcase
    end
end

// packet_format
// 1: data leader
// 2: data trailer
// 3~7: packet format (h.264..)
// 10: audio

assign packet_format = (packet_id == 'h0) ? 8'h1 : // leader
                       (vid_last_pkt) ? 8'h2 : // trailer
                       (state == TX_AUD) ? 8'ha : // audio
                       8'h3 ; // video ..

assign m_axis_tdata = (wcnt == 'h0) ? {block_id, 8'h0, packet_format} : // packet header
                      (wcnt == 'h1) ? packet_id : 
                      (state == TX_VID) ? video_do : aud_do; 
assign m_axis_tvalid = (state == TX_LEADER) | (state == TX_VID) | (state == TX_AUD) ;
assign m_axis_tkeep = 4'hf;
assign m_axis_tlast = m_axis_tvalid & (wcnt == (mac_frame_size >> 2) - 1);
        //m_axis_tvalid & (video_rd_en | aud_rd_en) & (wcnt == (mac_frame_size >> 2) - 1);

assign video_rd_en = (wcnt > 'h1) & m_axis_tready & (state == TX_VID);
assign aud_rd_en = (wcnt > 'h1) & m_axis_tready & (state == TX_AUD);
assign mac_frame_size = (state == TX_LEADER) ? 20'd8 :
                        (state == TX_AUD) ? (aud_size << 2) + 8 :
                        vid_last_pkt ? last_byte_num[19:0] + 8 : mac_payload_size;

endmodule