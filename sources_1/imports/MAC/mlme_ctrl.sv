`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: wise-jet
// Engineer: yj
// 
// Create Date: 2024/07/05
// Design Name: 802.11ad MAC
// Module Name: mlme_ctrl
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

//`define SSW
module mlme_ctrl (

    input clk,
    input rstn,

    (*mark_debug = "true"*)input op_mode,

    //input [19:0] payload_fifo_rcnt,
    (*mark_debug = "true"*)input [19:0] payload_size,
    (*mark_debug = "true"*)input s_axis_tvalid,

    input [31:0] probe_delay, // delay to be used prior to transmitting a probe frame during active scanning
    input [31:0] min_channel_time, // The minimum time (in TU)to spend on each channel when scanning
    input [31:0] max_channel_time, // The maximum time (in TU)to spend on each channel when scanning
    input [31:0] time_out_thv, // connection timeout threshold
    input [31:0] sbifs, // short beamforming interface spacing (if same DMG antenna)
    input [31:0] lbifs, // long beamforming interface spacing (if switcing DMG antenna)
    input [7:0] packet_gap, 
    input [31:0] keep_alive_int, 
    input [31:0] keep_alive_timeout_thv,

    (*mark_debug = "true"*)output logic scan_req,
    (*mark_debug = "true"*)output logic assoc_req,
    (*mark_debug = "true"*)output logic data_req,
    (*mark_debug = "true"*)output logic scan_resp_req,
    (*mark_debug = "true"*)output logic assoc_resp_req,
    (*mark_debug = "true"*)output logic keep_alive_req,
    (*mark_debug = "true"*)output logic keep_alive_resp_req,

    output logic [7:0] scan_failed_cnt,
    output logic [7:0] assoc_failed_cnt,  
    output logic [7:0] ssw_failed_cnt,

    // beamforming
    (*mark_debug = "true"*)output logic ssw_req,
    (*mark_debug = "true"*)output logic ssw_fd_req,
    (*mark_debug = "true"*)output logic ssw_ack_req,
    output logic [23:0] ssw_field,
    output logic [23:0] ssw_fd_field,
    output logic [23:0] ssw_fd_field_rsp,
    //output logic [31:0] brp_req_field,

    output logic [19:0] mac_frame_length,

    input [15:0] rx_frame_ctrl,
    input [11:0] rx_frag_num,
    input [3:0] rx_seq_num,

    input [23:0] rx_ssw_field,
    input [23:0] rx_ssw_fd_field,

    input rf_beam_set_done, // from MCU
    output logic rf_beam_set_req, // to MCU

    // IPC interface
    output logic ipc_ren,
    output logic ipc_wen,
    output logic [9:0] ipc_addr,
    output logic [31:0] ipc_wdata,
    input [31:0] ipc_rdata,

    (*mark_debug = "true"*)input rx_last,
    (*mark_debug = "true"*)input fcs_match,

    (*mark_debug = "true"*)output logic mac_trans_ready,
    (*mark_debug = "true"*)input tx_last

);

(*mark_debug = "true"*)enum logic [4:0]    {IDLE, SCAN_REQ, SCAN_RESP_WAIT, SCAN_WAIT,
                    ASSOC_REQ, ASSOC_RESP_WAIT, ASSOC_WAIT, SSW, 
                    SSW_WAIT, IPC_RX_WRITE, IPC_TX_READ, SSW_BEAM_SET, TX_SSW,  
                    SSW_BEAM_SELECT, BEAM_REFINE, DATA_TRANS_RDY, DATA_TRANS, 
                    DATA_RX_RDY, DIASSO_REQ, PKT_BLANK, TX_KEEP_ALIVE, TX_KEEP_ALIVE_RESP} state;          

//logic [8*16-1:0] ssid;
logic [31:0] delay_timer;
logic [31:0] channel_timer;


logic ssw_dir; // 0: initiator, 1: responder
logic [1:0] ssw_dmg_antenna_id; // the DMG antenna the transmitters is currently using for thier transmission (array id)
logic [5:0] ssw_sector_id; // sector number 
logic [8:0] ssw_cdown; // remaining SSW frame transmissions
logic [5:0] ssw_rxss_length; // CBAP or reserved  

// SSW feedback (when transmitted as part of an ISS)
logic [8:0] tot_sector; // Sector ID that was received with best quality 
logic [1:0] number_of_rx_antennas; // Antenna ID that was received with best quality
logic [0:0] poll_req; // SNR value that was received with best quality

logic [5:0] sector_sel;
logic [1:0] dmg_antenna_sel;
logic [7:0] snr_report;


logic scan_complete;
logic assoc_complete;
logic scan_failed;
logic assoc_failed; 
logic ssw_complete;

logic probe_req_received;
logic assoc_req_received;
logic probe_resp_received;
logic assoc_resp_received;

logic keep_alive_req_received;
logic keep_alive_resp_received;

logic [8:0] rx_ssw_cdown;
logic [5:0] rx_sector_id;
logic [1:0] rx_dmg_anttena_id;

logic ipc_ren_ff;
logic ipc_rdata_valid;
logic [1:0] ipc_cnt;
logic [1:0] ipc_rcnt;

logic [3:0] rf_beam_set_req_cnt;
logic [7:0] blank_cnt;

logic [31:0] keep_alive_cnt;
logic keep_alive_en;

assign probe_req_received = rx_last & (rx_frame_ctrl[2+:2] == 2'b00) & (rx_frame_ctrl[4+:4] == 4'b0100) & fcs_match;
assign assoc_req_received = rx_last & (rx_frame_ctrl[2+:2] == 2'b00) & (rx_frame_ctrl[4+:4] == 4'b0000) & fcs_match;
assign probe_resp_received = rx_last & (rx_frame_ctrl[2+:2] == 2'b00) & (rx_frame_ctrl[4+:4] == 4'b0101) & fcs_match;
assign assoc_resp_received = rx_last & (rx_frame_ctrl[2+:2] == 2'b00) & (rx_frame_ctrl[4+:4] == 4'b0001) & fcs_match;
assign keep_alive_req_received = rx_last & (rx_frame_ctrl[2+:2] == 2'b00) & (rx_frame_ctrl[4+:4] == 4'b1000) & fcs_match;
assign keep_alive_resp_received = rx_last & (rx_frame_ctrl[2+:2] == 2'b00) & (rx_frame_ctrl[4+:4] == 4'b1001) & fcs_match;

assign ssw_received = rx_last & (rx_frame_ctrl[2+:2] == 2'b01) & (rx_frame_ctrl[4+:4] == 4'b0110) & (rx_frame_ctrl[8+:4] == 4'b1000) & fcs_match;
assign ssw_fd_received = rx_last & (rx_frame_ctrl[2+:2] == 2'b01) & (rx_frame_ctrl[4+:4] == 4'b0110) & (rx_frame_ctrl[8+:4] == 4'b1001) & fcs_match;
assign ssw_ack_received = rx_last & (rx_frame_ctrl[2+:2] == 2'b01) & (rx_frame_ctrl[4+:4] == 4'b0110) & (rx_frame_ctrl[8+:4] == 4'b1010) & fcs_match;
assign data_received = rx_last & (rx_frame_ctrl[2+:2] == 2'b10) & (rx_frame_ctrl[4+:4] == 4'b0000) & fcs_match;

assign rx_ssw_cdown = rx_ssw_field[1+:9];
assign rx_sector_id = rx_ssw_field[10+:6];
assign rx_dmg_anttena_id = rx_ssw_field[16+:2];

assign rx_sector_select = rx_ssw_fd_field[0+:6];
assign rx_dmg_antenna_select = rx_ssw_fd_field[6+:2];
assign rx_snr_report = rx_ssw_fd_field[8+:8];
assign rx_poll_req = rx_ssw_fd_field[16]; 


logic rf_beam_set_done_ff0, rf_beam_set_done_ff1;
logic rf_beam_set_done_r;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        rf_beam_set_done_ff0 <= 'h0;
        rf_beam_set_done_ff1 <= 'h0;
    end
    else begin
        rf_beam_set_done_ff0 <= rf_beam_set_done;
        rf_beam_set_done_ff1 <= rf_beam_set_done_ff0;
    end
end

assign rf_beam_set_done_r = ~rf_beam_set_done_ff1 & rf_beam_set_done_ff0;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        state <= IDLE;

        //ssid <= "wisejet_wigig";
        delay_timer <= 'h0;
        channel_timer <= 'h0;
        scan_failed_cnt <= 'h0;
        scan_complete <= 'h0;
        scan_failed <= 'h0;
        assoc_failed_cnt <= 'h0;
        assoc_failed <= 'h0;
        ssw_failed_cnt <= 'h0;

        scan_req <= 'h0;
        assoc_req <= 'h0;
        data_req <= 'h0;
        keep_alive_req <= 'h0;
        ssw_req <= 'h0;
        ssw_fd_req <= 'h0;
        ssw_ack_req <= 'h0;

        scan_resp_req <= 'h0;
        assoc_resp_req <= 'h0;
        keep_alive_resp_req <= 'h0;

        mac_frame_length <= 'h0;

        // SSW (sector sweep)
        ssw_dir <= 'h0;
        ssw_cdown <= 'h0;
        ssw_dmg_antenna_id <= 'h0;
        ssw_sector_id <= 'h0;
        ssw_rxss_length <= 'h0;

        tot_sector <= 'h0;
        number_of_rx_antennas <= 'h0;
        poll_req <= 'h0;
        sector_sel <= 'h0;
        dmg_antenna_sel <= 'h0;
        snr_report <= 'h0;

        rf_beam_set_req <= 'h0;
        rf_beam_set_req_cnt <= 'h0;
        ssw_complete <= 1'b0;
        assoc_complete <= 1'b0;

        blank_cnt <= 'h0;
        mac_trans_ready <= 'h0;

    end
    else begin
        case (state)
        IDLE: begin
            delay_timer <= 'h0;
            channel_timer <= 'h0;
            scan_complete <= 'h0;
            scan_failed <= 'h0;

            assoc_complete <= 'h0;
            assoc_failed <= 'h0;
            
            scan_req <= 'h0;
            assoc_req <= 'h0;
            data_req <= 'h0;
            keep_alive_req <= 'h0;

            scan_resp_req <= 'h0;
            assoc_resp_req <= 'h0;
            keep_alive_resp_req <= 'h0;

            if (~op_mode) begin
                state <= SCAN_REQ;
            end
            else begin
                state <= SCAN_WAIT;
            end

        end
        SCAN_REQ: begin  // scan_req

            //ssid <= "wisejet_wigig";
            if (delay_timer < probe_delay) begin
                delay_timer <= delay_timer + 1'b1;
            end
            else begin
                scan_req <= 1;
                mac_frame_length <= 12; // MAC header(4) + length (4) + FCS(4)
                state <= SCAN_RESP_WAIT;
                delay_timer <= 'h0;
            end
        
        end
        SCAN_RESP_WAIT: begin
            scan_req <= 0;
            if ((channel_timer >= min_channel_time) & (channel_timer < max_channel_time)) begin
                if (probe_resp_received) begin
                    $display("[%t] : probe_resp_received...", $realtime);
                    scan_complete <= 1;
                    state <= ASSOC_REQ;
                end
            end
            else if (channel_timer >= max_channel_time) begin
                scan_failed_cnt <= scan_failed_cnt + 1'b1;
                scan_failed <= 1'b1;
                state <= IDLE;

            end
            channel_timer <= channel_timer + 1'b1;
        end     
        SCAN_WAIT: begin // responder
            if (probe_req_received) begin
                state <= ASSOC_WAIT;
                scan_complete <= 1;
                $display("[%t] : probe_req_received...", $realtime);
                mac_frame_length <= 12;
                scan_resp_req <= 1'b1;
            end
            if (keep_alive_req_received) begin
                keep_alive_resp_req <= 1'b1;
                mac_frame_length <= 12;
                state <= TX_KEEP_ALIVE_RESP;
            end            

        end        
         
        ASSOC_REQ: begin // Notify Frame Format
            assoc_req <= 1;
            mac_frame_length <= 12; // MAC header
            state <= ASSOC_RESP_WAIT;

        end
        ASSOC_RESP_WAIT: begin
            assoc_req <= 'h0;

            if (delay_timer < time_out_thv) begin
                delay_timer <= delay_timer + 1'b1;
                if (assoc_resp_received) begin
                    $display("[%t] : assoc_resp_received...", $realtime);
                    assoc_complete <= 1'b1;
                    `ifdef SSW
                    state <= SSW;
                    `else
                    state <= DATA_TRANS_RDY;
                    mac_trans_ready <= 1'b1;
                    `endif 
                    
                    delay_timer <= 'h0;                        
                    
                end
            end
            else begin
                assoc_failed <= 1;
                assoc_failed_cnt <= assoc_failed_cnt + 1'b1;
                delay_timer <= 'h0;
                state <= IDLE;
            end
            
        end
        ASSOC_WAIT: begin // responder
            scan_resp_req <= 'h0;
            if (delay_timer < time_out_thv) begin
                delay_timer <= delay_timer + 1'b1;
                if (assoc_req_received) begin
                    `ifdef SSW
                    state <= SSW_WAIT;
                    `else
                    state <= DATA_RX_RDY;
                    mac_trans_ready <= 1'b1;
                    `endif
                    delay_timer <= 'h0;
                    
                    assoc_resp_req <= 1'b1;
                    mac_frame_length <= 12;
                    $display("[%t] : assoc_rep_received...", $realtime);
                    assoc_complete <= 1'b1;
                end
            end
            else begin
                state <= SCAN_WAIT;
                delay_timer <= 'h0;
            end
                
        end           

        SSW: begin // Sector Level Sweep (SLS), 
            rf_beam_set_req <= 1'b1;
            state <= SSW_BEAM_SET;
           
        end      
        SSW_BEAM_SET: begin
            
            if (rf_beam_set_req) begin
                rf_beam_set_req_cnt <= rf_beam_set_req_cnt + 1'b1;
            end
            
            if (rf_beam_set_req_cnt == 4'hf) begin
                rf_beam_set_req <= 1'b0;
                rf_beam_set_req_cnt <= 'h0;
            end

            if (rf_beam_set_done_r) begin
                

                if (ssw_complete) begin
                    state <= DATA_TRANS_RDY; 
                    mac_trans_ready <= 1'b1;                
                end
                else 
                    state <= IPC_TX_READ;
            end
        end
        IPC_TX_READ: begin

            if (ipc_rdata_valid) begin
                if (ipc_rcnt == 'h0) begin // ssw field
                    ssw_dir <= ipc_rdata[0];
                    ssw_cdown <= ipc_rdata[1+:9];
                    ssw_sector_id <= ipc_rdata[10+:6];
                    ssw_dmg_antenna_id <= ipc_rdata[16+:2];
                    ssw_rxss_length <= ipc_rdata[18+:6];

                end
                else if (ipc_rcnt == 2'h1) begin // ssw feedback field
                    // SSW feedback field of ISS
                    tot_sector <= ipc_rdata[0+:9];
                    number_of_rx_antennas <= ipc_rdata[9+:2];

                    poll_req <= ipc_rdata[16];
                    
                    // SSW feedbakc field of RSS
                    sector_sel <= ipc_rdata[0+:6];
                    dmg_antenna_sel <= ipc_rdata[6+:2];
                    snr_report <= ipc_rdata[8+:8];

                    
                    mac_frame_length <= 16;  

                    ssw_req <= 1'b1;
                    state <= TX_SSW;          

               
                end

            end             
        end
        TX_SSW: begin
            ssw_req <= 1'b0;
            if (tx_last) begin
                if ((ssw_cdown == 9'd0) & (rx_ssw_cdown == 'h0)) begin
                    if (op_mode) begin
                        state <= DATA_RX_RDY;
                        ssw_complete <= 1'b1;
                        mac_trans_ready <= 1'b1;
                    end
                    else state <= SSW_WAIT;
                end
                else begin
                    //if (op_mode) begin
                        state <= SSW_WAIT;
                    //end
                    //else state <= SSW;
                end
            end
        end
        SSW_WAIT: begin
            assoc_resp_req <= 1'b0;
            scan_resp_req <= 'h0;
            
            if (delay_timer < time_out_thv) begin
                delay_timer <= delay_timer + 1'b1;
                if (ssw_received) begin
                    state <= IPC_RX_WRITE;
                    delay_timer <= 'h0;
                end                

            end            
            else begin
                delay_timer <= 'h0;
                state <= IDLE;              
                ssw_failed_cnt <= ssw_failed_cnt + 1'b1;
                
            end            
        end
        IPC_RX_WRITE: begin
            if (ipc_cnt == 2'h2) begin
                rf_beam_set_req <= 1'b1;
                state <= SSW_BEAM_SELECT;
            end                                 
        end
        SSW_BEAM_SELECT: begin
            if (rf_beam_set_req) begin
                rf_beam_set_req_cnt <= rf_beam_set_req_cnt + 1'b1;
            end
            
            if (rf_beam_set_req_cnt == 4'hf) begin
                rf_beam_set_req <= 1'b0;
                rf_beam_set_req_cnt <= 'h0;
            end

            if (rf_beam_set_done_r) begin
                state <= SSW;

                if (~op_mode & (ssw_cdown == 'h0) & (rx_ssw_cdown == 'h0)) begin
                    ssw_complete <= 1'b1;
                end
            end

        end
        DATA_TRANS_RDY: begin
            //ssw_ack_req <= 1'b0;
            assoc_resp_req <= 'h0;
            //if (payload_fifo_rcnt >= payload_size/4) begin 
            if (keep_alive_timeout) begin
                state <= SCAN_REQ;
                mac_trans_ready <= 'h0;
            end
            else if (keep_alive_en) begin
                state <= TX_KEEP_ALIVE;
                keep_alive_req <= 1'b1;
                mac_frame_length <= 12;
            end
            else if (s_axis_tvalid) begin
                mac_frame_length <= payload_size + 12; // header 8 + crc 4
                data_req <= 1'b1;
                state <= DATA_TRANS;
                $display("[%t] : data_transffering...", $realtime);
            end
        end
        DATA_TRANS: begin
            data_req <= 1'b0;
            if (tx_last) begin
                state <= PKT_BLANK;
                blank_cnt <= 'h0;
            end
        end
        PKT_BLANK: begin
           blank_cnt <= blank_cnt + 1'b1;
           if (blank_cnt == packet_gap -1) begin
                state <= DATA_TRANS_RDY;
            end
        end
           
        DATA_RX_RDY: begin
            assoc_resp_req <= 1'b0;
        //     if (disassociation_req) begin
        //         state <= IDLE;
        //     end
            if (keep_alive_req_received) begin
                keep_alive_resp_req <= 1'b1;
                mac_frame_length <= 12;
                state <= TX_KEEP_ALIVE_RESP;
            end
            else if (probe_req_received) begin
                state <= ASSOC_WAIT;
                scan_complete <= 1;
                $display("[%t] : probe_req_received...", $realtime);
                mac_frame_length <= 12;
                scan_resp_req <= 1'b1;
            end        
            else if (assoc_req_received) begin
                `ifdef SSW
                state <= SSW_WAIT;
                `else
                state <= DATA_RX_RDY;
                `endif
                delay_timer <= 'h0;
                assoc_resp_req <= 1'b1;
                mac_frame_length <= 12;
                $display("[%t] : assoc_rep_received...", $realtime);
                assoc_complete <= 1'b1;
            end
     
        end
        TX_KEEP_ALIVE: begin
            keep_alive_req <= 0;
            state <= PKT_BLANK;
        end
        TX_KEEP_ALIVE_RESP: begin
            keep_alive_resp_req <= 0;
            state <= DATA_RX_RDY;            
        end

        DIASSO_REQ: begin
        end

        BEAM_REFINE: begin //Beam Refinement Protocol (BRP)
        end

        default: state <= IDLE;
        endcase
    end
end

// keep-alive
// 118.8MHz
always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        keep_alive_cnt <= 'h0;
        keep_alive_en <= 'h0;
    end
    else if (~op_mode) begin
        if (mac_trans_ready) begin
            if (keep_alive_en & state == TX_KEEP_ALIVE) begin
                keep_alive_en<= 'h0;
            end
            else if (keep_alive_cnt == keep_alive_int) begin
                keep_alive_en <= 1'b1;
                keep_alive_cnt <= 'h0;
            end
            else begin
                keep_alive_cnt <= keep_alive_cnt + 1'b1;
                keep_alive_en <= 'h0;
            end
        end
        else begin
            keep_alive_cnt <= 'h0;
            keep_alive_en <= 'h0;

        end        
    end
end

logic [31:0] keep_alive_timeout_cnt;
logic keep_alive_timeout;
always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        keep_alive_timeout_cnt <= 'h0;
        keep_alive_timeout <= 'h0;
    end
    else if (~mac_trans_ready) begin
        keep_alive_timeout_cnt <= 'h0;
        keep_alive_timeout <= 'h0;        
    end
    else if (keep_alive_resp_received) begin
        keep_alive_timeout_cnt <= 'h0;
        keep_alive_timeout <= 'h0;
    end
    else if (state == TX_KEEP_ALIVE) begin
        keep_alive_timeout_cnt <= 32'h1;
    end
    else if (keep_alive_timeout_cnt == keep_alive_timeout_thv) begin
        keep_alive_timeout <= 1'b1;
    end
    else if (|keep_alive_timeout_cnt) begin
        keep_alive_timeout_cnt <= keep_alive_timeout_cnt + 1'b1;
    end
end


assign ssw_field = {ssw_rxss_length, ssw_dmg_antenna_id, ssw_sector_id, ssw_cdown, ssw_dir};
assign ssw_fd_field = {7'h0, poll_req, 5'h0, number_of_rx_antennas, tot_sector};
assign ssw_fd_field_rsp = {7'h0, poll_req, snr_report, dmg_antenna_sel, sector_sel};

// IPC access
always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        ipc_ren_ff <= 1'b0;
        ipc_rdata_valid <= 'h0;
    end
    else begin
        ipc_ren_ff <= ipc_ren;
        ipc_rdata_valid <= ipc_ren_ff;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        ipc_cnt <= 'h0;
    end
    else if (ipc_ren | ipc_wen) begin
        ipc_cnt <= ipc_cnt + 1'b1;
    end
    else ipc_cnt <= 'h0;
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        ipc_rcnt <= 'h0;
    end
    else if (ipc_rdata_valid) begin
        ipc_rcnt <= ipc_rcnt + 1'b1;
    end
    else ipc_rcnt <= 'h0;
end

assign ipc_wen = (state == IPC_RX_WRITE) | (state == SSW);
assign ipc_ren = (state == IPC_TX_READ);
assign ipc_addr = (state == IPC_TX_READ) ? 10'h104 + (ipc_cnt << 2) : 
                  (state == SSW) ? 10'h100 : 
                  (state == IPC_RX_WRITE) & (ipc_cnt == 2'h0) ? 10'h10c :
                  (state == IPC_RX_WRITE) & (ipc_cnt == 2'h1) ? 10'h110 : 10'h100;

assign ipc_wdata = (state == SSW) ? 32'h1 : // SSW packet_request
                   (ipc_cnt == 2'h0) ? {8'h0, rx_ssw_field} :
                   (ipc_cnt == 2'h1) ? {8'h0, rx_ssw_fd_field} : 32'h2;


endmodule
