`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: wise-jet
// Engineer: yj
// 
// Create Date: 2024/07/08
// Design Name: 802.11ad MAC
// Module Name: mac_ctrl_rx
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
module mac_ctrl_rx #(
    parameter DATA_WIDTH = 32
)
(

    input clk,
    input rstn,
    
    (*mark_debug = "true"*)input [DATA_WIDTH-1:0] s_axis_tdata,
    input [DATA_WIDTH/8-1:0] s_axis_tkeep,
    (*mark_debug = "true"*)input s_axis_tvalid,
    (*mark_debug = "true"*)input s_axis_tlast,
    output s_axis_tready,
    
    // Received MAC Header
    output logic [15:0] rx_frame_ctrl,
    output logic [11:0] rx_frag_num,
    output logic [3:0] rx_seq_num,
    output logic [23:0] rx_ssw_field,
    output logic [23:0] rx_ssw_fd_field,

    // Received MAC Payload
    (*mark_debug = "true"*)output logic [DATA_WIDTH-1:0] m_axis_tdata,
    (*mark_debug = "true"*)output logic [DATA_WIDTH/8-1:0] m_axis_tkeep,
    (*mark_debug = "true"*)output logic m_axis_tvalid,
    (*mark_debug = "true"*)output logic m_axis_tlast,
    input m_axis_tready,
    
    output logic rx_last, 
    output logic fcs_match,
    (*mark_debug = "true"*)output logic [31:0] fcs_error_cnt

);

(*mark_debug = "true"*)logic [19:0] rx_cnt;
(*mark_debug = "true"*)logic [19:0] rx_length;

logic [31:0] fcs_out;
//logic [31:0] fcs_error_cnt;
logic fcs_out_valid;

assign s_axis_tready = 1'b1;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        rx_length <= 'h0;

        rx_frame_ctrl <= 'h0;
        rx_frag_num <= 'h0;
        rx_seq_num <= 'h0;

        rx_ssw_field <= 'h0;
        rx_ssw_fd_field <= 'h0;

        m_axis_tdata <= 'h0;
        m_axis_tvalid <= 'h0;
        m_axis_tlast <= 1'b0;
        m_axis_tkeep <= 'hf;

        fcs_match <= 'h0;
        fcs_error_cnt <= 'h0;
        rx_last <= 1'b0;

        
    end
    else begin
        if (s_axis_tvalid) begin
            if (rx_cnt == 20'd0) begin
                rx_frame_ctrl <= s_axis_tdata[15:0];
                rx_seq_num <= s_axis_tdata[16+:12];
                rx_length[3:0] <= s_axis_tdata[28+:4];
            end  
            else if (rx_cnt == 20'd4) begin
                rx_length[19:4] <= s_axis_tdata[15:0];
                rx_ssw_field[15:0] <= s_axis_tdata[16+:16];
            end 
            else if (rx_cnt == rx_length - 8) begin             
                if (rx_frame_ctrl[2+:2] == 2'b10) begin
                    m_axis_tdata <= s_axis_tdata;
                    m_axis_tlast <= 1'b1;
                    m_axis_tvalid <= 1'b1;
                end                
            end
            else if (rx_cnt == rx_length - 4) begin
                fcs_match <= (fcs_out == s_axis_tdata) ? 1'b1 : 1'b0;
                fcs_error_cnt <= (fcs_out != s_axis_tdata) ? fcs_error_cnt + 1'b1 : fcs_error_cnt;
                m_axis_tvalid <= 1'b0;

                if (rx_frame_ctrl[2+:2] == 2'b10) begin
                    m_axis_tlast <= 1'b0;
                end
                rx_last <= 1'b1;

            end                    
            else if ((rx_frame_ctrl[2+:2] == 2'b01) & (rx_frame_ctrl[4+:4] == 4'b0110)) begin
                if (rx_cnt == 20'd8) begin
                    rx_ssw_field[23:16] <= s_axis_tdata[7:0];
                    rx_ssw_fd_field <= s_axis_tdata[8+:24];
                end
            end
            else if (rx_frame_ctrl[2+:2] == 2'b10) begin // data
                m_axis_tdata <= s_axis_tdata;
                m_axis_tvalid <= s_axis_tvalid;
            end  
            m_axis_tkeep <= s_axis_tkeep;  
            
        end
        else begin
            m_axis_tvalid <= 'h0;
            //m_axis_tlast <= 'h0;
            rx_last <= 1'b0;
        end        

    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        rx_cnt <= 'h0;
    end
    else if (s_axis_tlast) begin
        rx_cnt <= 'h0;
    end    
    //else if (s_axis_tvalid & (rx_cnt < rx_length- 4)) begin
    else if (s_axis_tvalid & s_axis_tready) begin
        rx_cnt <= rx_cnt + 4;
    end

end

mac_fcs i_mac_fcs (
    .clk (clk),
    .rstn (rstn),

    .crc_init (rx_last),
    .di (s_axis_tdata),
    .di_valid (s_axis_tvalid & ~s_axis_tlast),
    .crc_out (fcs_out),
    .crc_out_valid (fcs_out_valid)

);


endmodule