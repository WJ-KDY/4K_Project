`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: wise-jet
// Engineer: yj
// 
// Create Date: 2024/07/03
// Design Name: 802.11ad MAC
// Module Name: mac_ctrl
// Project Name: 802.11ad 
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
module mac_ctrl_tx #(
    parameter DATA_WIDTH = 128
)
(

    input clk,
    input rstn,
    input op_mode,

    // AXI Stream Input
    input [DATA_WIDTH-1:0] s_axis_tdata,
    input [DATA_WIDTH/8-1:0] s_axis_tkeep,
    input s_axis_tvalid,
    input s_axis_tlast,
    output logic s_axis_tready,

    // AXI Stream Output
    output logic [DATA_WIDTH-1:0] m_axis_tdata,
    output logic [DATA_WIDTH/8-1:0] m_axis_tkeep,
    output logic m_axis_tvalid,
    output logic m_axis_tlast,
    input m_axis_tready,
    output logic m_axis_sof,

    // management request
    input scan_req,
    input assoc_req,
    input data_req,
    input keep_alive_req,

    input scan_resp_req,
    input assoc_resp_req,
    input keep_alive_resp_req,
    
    input ssw_req,
    input ssw_fd_req,
    input ssw_ack_req,
    input [23:0] ssw_field,
    input [23:0] ssw_fd_field,   
    input [23:0] ssw_fd_field_rsp, 

    input [19:0] tx_length



);

enum logic [0:0]    {IDLE, TX_EN} state;

// frame control field (16bit)
logic [1:0] protocol_version; // 00
logic [1:0] frame_type; // 00: management, 01: control, 10: data, 11: reserved 
logic [3:0] frame_subtype;
logic [3:0] frame_ctrl_ext;
//logic to_ds; // Distribution System
//logic from_ds;
//logic more_fragments;
//logic retry;
//logic power_mgmt;
//logic more_data;
//logic protected_frame;
//logic order;

// sequence control
logic [3:0] frag_num;
logic [11:0] seq_num;

// FCS Field 
logic [31:0] fcs_out;
logic fcs_out_valid;

// FC(2)+D/I(2)+Address1(6)+Address2(6)+SC(2)+Address3(6)+Frame body(x)+CRC(4)
// scan_req, assoc_req: frame_control(2)+dst_addr(6)+src_addr(6)+sequence_num(2)+CRC(4)= 20
// data: frame_control(2)+dst_addr(6)+src_addr(6)+sequence_num(2)+frame_body(x)+CRC(4)= 20 + x 
logic [19:0] tx_cnt;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        state <= IDLE;
        tx_cnt <= 'h0;

        // frame control field
        protocol_version <= 2'h1;
        frame_type <= 'h0;
        frame_subtype <= 'h0;   
        frame_ctrl_ext <= 'h0;
//        to_ds <= 0;
//        from_ds <= 0;
//        more_fragments <= 0;
//        retry <= 0;
//        power_mgmt <= 0;
//        more_data <= 0;
//        protected_frame <= 0;
//        order <= 0; 
        
        // sequence control
        seq_num <= 12'h0; // to start the sequence number from 0 for the initial packet
        frag_num <= 'h0;
        
    end
    else begin
        case (state)
        IDLE: begin
            if (scan_req) begin 
                frame_type <= 'h0;
                frame_subtype <= 4'b0100;
                seq_num <= seq_num + 1'b1;
                frag_num <= 'h0;  
                tx_cnt <= 'h0;              
                state <= TX_EN;
            end
            else if (assoc_req) begin
                frame_type <= 'h0;
                frame_subtype <= 4'b0000;
                seq_num <= seq_num + 1'b1;
                frag_num <= 'h0; 
                state <= TX_EN;                                   
            end
            else if (scan_resp_req) begin
                frame_type <= 'h0;
                frame_subtype <= 4'b0101;
                seq_num <= seq_num + 1'b1;
                frag_num <= 'h0;                    
                state <= TX_EN;                
            end
            else if (assoc_resp_req) begin
                frame_type <= 'h0;
                frame_subtype <= 4'b0001;
                seq_num <= seq_num + 1'b1;
                frag_num <= 'h0;                    
                state <= TX_EN;                
            end
            else if (keep_alive_req) begin
                frame_type <= 2'b00; 
                frame_subtype <= 4'b1000; 
                frame_ctrl_ext <= 4'b0000; 
                seq_num <= seq_num + 1'b1; 
                frag_num <= 'h0;              
                state <= TX_EN;
            end    
            else if (keep_alive_resp_req) begin
                frame_type <= 2'b00; 
                frame_subtype <= 4'b1001; 
                frame_ctrl_ext <= 4'b0000; 
                seq_num <= seq_num + 1'b1; 
                frag_num <= 'h0;              
                state <= TX_EN;
            end                       
            else if (ssw_req) begin
                frame_type <= 2'b01;
                frame_subtype <= 4'b0110;
                frame_ctrl_ext <= 4'b1000;
                seq_num <= seq_num + 1'b1;
                frag_num <= 'h0; 
                state <= TX_EN;                    
            end
            else if (ssw_fd_req) begin
                frame_type <= 2'b01;
                frame_subtype <= 4'b0110;
                frame_ctrl_ext <= 4'b1001;                
                seq_num <= seq_num + 1'b1;
                frag_num <= 'h0;
                state <= TX_EN;                     
            end
            else if (ssw_ack_req) begin
                frame_type <= 2'b01;
                frame_subtype <= 4'b0110;
                frame_ctrl_ext <= 4'b1010;                
                seq_num <= seq_num + 1'b1;
                frag_num <= 'h0;
                state <= TX_EN;                  
            end
            else if (data_req) begin
                frame_type <= 2'b10; //data
                frame_subtype <= 4'b0000; //data
                frame_ctrl_ext <= 4'b0000; 
                frag_num <= frag_num + 1'b1;              
                state <= TX_EN;
            end

            tx_cnt <= 'h0;

        end
        TX_EN: begin
            if (m_axis_tvalid & m_axis_tready) begin
                if (tx_cnt < tx_length) begin
                    if (tx_cnt == tx_length -4) begin
                        state <= IDLE;
                    end
                    tx_cnt <= tx_cnt + 4;     
                end
            end
        end
        
        endcase
    end
end

assign s_axis_tready = (state == TX_EN) & (tx_cnt >= 8) & (tx_cnt < tx_length - 4) & s_axis_tvalid & m_axis_tready;

logic tx_ssw;
logic tx_ssw_fd;
logic tx_ssw_ack;

logic [23:0] ssw_fd_frame;
assign ssw_fd_frame = (op_mode) ? ssw_fd_field_rsp : ssw_fd_field;

assign tx_ssw = (frame_subtype == 4'b0110) & (frame_ctrl_ext == 4'b1000);
assign tx_ssw_fd = (frame_subtype == 4'b0110) & (frame_ctrl_ext == 4'b1001);
assign tx_ssw_ack = (frame_subtype == 4'b0110) & (frame_ctrl_ext == 4'b1010);

assign m_axis_tkeep = 4'hf;
assign m_axis_tvalid = (state == TX_EN)  & m_axis_tready;
assign m_axis_sof = m_axis_tvalid & (tx_cnt == 'h0);
assign m_axis_tlast = m_axis_tvalid & (tx_cnt >= tx_length - 4);
assign m_axis_tdata = (tx_cnt == 20'h0) ? {tx_length[3:0], seq_num, frag_num, frame_ctrl_ext, 
                                           frame_subtype, frame_type, protocol_version} :
                      (tx_cnt == 20'h4) ? {ssw_field[15:0], tx_length[19:4]} :
                      (tx_ssw_fd) & (tx_cnt == 20'h4) ? {ssw_fd_frame[15:0], tx_length[19:4]} :
                      (tx_ssw) & (tx_cnt == 20'h8) ? {ssw_fd_frame, ssw_field[23:16]} :
                      (tx_ssw_fd) & (tx_cnt == 20'h8) ? {24'h0, ssw_fd_frame[23:16]} :
                      //(tx_ssw_fd) & (tx_cnt == 20'h8) ? {brp_request[23:0], ssw_fd_field[31:24]} :
                      //(tx_ssw_fd) & (tx_cnt == 20'h12) ? {16'h0, beam_link_maintenance, brp_request[31:24]} :
                      (tx_cnt == tx_length -4) ? fcs_out : 
                                                 s_axis_tdata;

logic fcs_di_valid;
assign fcs_di_valid = m_axis_tvalid & (tx_cnt < tx_length -4);

mac_fcs i_mac_fcs (
    .clk (clk),
    .rstn (rstn),

    .crc_init ((state == IDLE)),
    .di (m_axis_tdata),
    .di_valid (fcs_di_valid),
    .crc_out (fcs_out),
    .crc_out_valid (fcs_out_valid)

);

endmodule