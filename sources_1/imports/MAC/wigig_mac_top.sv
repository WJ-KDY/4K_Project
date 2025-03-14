`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: wise-jet
// Engineer: yj
// 
// Create Date: 2024/07/03
// Design Name: 802.11ad MAC
// Module Name: wigig_mac_top
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
module wigig_mac_top #(
    parameter DATA_WIDTH = 32
)
(
    input clk, // 330MHz 
    input rstn,

    output mac_trans_ready,  
    ////input [19:0] payload_fifo_rcnt,
    output logic [19:0] mac_payload_size, // 4-byte unit
    input [19:0] mac_frame_size,

    // AXI stream input from Codec
    input [DATA_WIDTH-1:0] tx_s_axis_tdata,
    input [DATA_WIDTH/8-1:0] tx_s_axis_tkeep,
    input tx_s_axis_tvalid,
    input tx_s_axis_tlast,
    output tx_s_axis_tready,
  
    // AXI stream output to Codec
    output [DATA_WIDTH-1:0] rx_m_axis_tdata,
    output [DATA_WIDTH/8-1:0] rx_m_axis_tkeep,
    output rx_m_axis_tvalid,
    output rx_m_axis_tlast,
    input rx_m_axis_tready,

    // PHY Interface
    // AXI stream output to PHY
    (*mark_debug = "true"*)output [DATA_WIDTH-1:0] tx_m_axis_tdata,
    output [DATA_WIDTH/8-1:0] tx_m_axis_tkeep,
    (*mark_debug = "true"*)output tx_m_axis_tvalid,
    (*mark_debug = "true"*)output tx_m_axis_tlast,
    (*mark_debug = "true"*)input tx_m_axis_tready,
    output tx_m_axis_sof,

    // AXI stream input from PHY
    input [DATA_WIDTH-1:0] rx_s_axis_tdata,
    input [DATA_WIDTH/8-1:0] rx_s_axis_tkeep,
    input rx_s_axis_tvalid,
    input rx_s_axis_tlast,
    output rx_s_axis_tready,


    //output tx_statistics_vector,
    //output tx_statistics_valid,

    //output rx_statistics_vector,
    //output rx_statistics_valid,    

    // RF Interface (SPI Interface)


    //Management Interface (AXI-Lite Interface)
    input s_axi_clk,
    input s_axi_resetn,

    input [31:0] s_axi_awaddr,
    input [2:0] s_axi_awprot,
    input s_axi_awvalid,
    output s_axi_awready,

    input [31:0] s_axi_wdata,
    input [3:0] s_axi_wstrb,
    input s_axi_wvalid,
    output s_axi_wready,

    output [1:0] s_axi_bresp,
    output s_axi_bvalid,
    input s_axi_bready,

    input [31:0] s_axi_araddr,
    input [2:0] s_axi_arprot,
    input s_axi_arvalid,
    output s_axi_arready,

    output [31:0] s_axi_rdata,
    output [1:0] s_axi_rresp,
    output s_axi_rvalid,
    input s_axi_rready,

    output logic rf_beam_set_req_sync // to MCU interrupt    

);

logic [15:0] rx_frame_ctrl;
logic [11:0] rx_frag_num;
logic [3:0] rx_seq_num;
logic [23:0] rx_ssw_field;
logic [23:0] rx_ssw_fd_field;

logic tx_scan_req;
logic tx_assoc_req;
logic tx_data_req;
logic tx_scan_resp_req;
logic tx_assoc_resp_req;

logic keep_alive_req;
logic keep_alive_resp_req;

logic tx_ssw_req;
logic tx_ssw_fd_req;
logic tx_ssw_ack_req;
logic [23:0] tx_ssw_field;
logic [23:0] tx_ssw_fd_field;
logic [23:0] tx_ssw_fd_field_rsp;
logic [8:0] tx_ssw_cdown;

logic [19:0] tx_length;

logic data_trans_complete;

logic [1:0] phy_rx_sel;
logic [63:0] phy_rx_header;

logic mac_op_mode; // 0: initiator, 1: responder
//logic [19:0] mac_payload_size; // 4-byte unit
logic [31:0] probe_delay; // delay to be used prior to transmitting a probe frame during active scanning
logic [31:0] min_channel_time; // The minimum time (in TU)to spend on each channel when scanning
logic [31:0] max_channel_time; // The maximum time (in TU)to spend on each channel when scanning
logic [31:0] time_out_thv; // connection timeout threshold
logic [31:0] sbifs; // short beamforming interface spacing (if same DMG antenna)
logic [31:0] lbifs; // long beamforming interface spacing (if switcing DMG antenna)  
logic [31:0] keep_alive_int;  
logic [31:0] keep_alive_timeout_thv;

logic [7:0] packet_gap;
logic [7:0] scan_failed_cnt;
logic [7:0] assoc_failed_cnt;  
logic [7:0] ssw_failed_cnt;

// configuration interface
logic [31:0] sys_addr;
logic [31:0] sys_wdata;
logic [3:0] sys_sel;
logic sys_wen;
logic sys_ren;
logic [31:0] sys_rdata;
logic sys_err;
logic sys_ack;

logic ipc_wen;
logic ipc_ren;
logic [9:0] ipc_addr;
logic [31:0] ipc_wdata;
logic [31:0] ipc_rdata;

logic rf_beam_set_done;
logic rf_beam_set_done_sync;
logic rf_beam_set_req;

logic fcs_match;
logic [31:0] fcs_error_cnt;
logic rx_last;

logic mac_op_mode_sync;

bit_sync #(.INITIALIZE(5'b00000)) i_bit_sync_sync_lock (
    .clk_in (clk),
    .i_in (mac_op_mode),
    .o_out (mac_op_mode_sync)
);


mlme_ctrl i_mlme_ctrl (
    .clk (clk),
    .rstn (rstn),

    .op_mode (mac_op_mode_sync), 
    
    //.payload_fifo_rcnt (payload_fifo_rcnt),
    .s_axis_tvalid (tx_s_axis_tvalid),
    .payload_size (mac_frame_size),

    .probe_delay (probe_delay),
    .min_channel_time (min_channel_time),
    .max_channel_time (max_channel_time),
    .time_out_thv (time_out_thv), // connection timeout threshold
    .sbifs (sbifs),
    .lbifs (lbifs),
    .keep_alive_int (keep_alive_int),
    .keep_alive_timeout_thv (keep_alive_timeout_thv),
    .packet_gap (packet_gap),    

    .scan_req (tx_scan_req),
    .assoc_req (tx_assoc_req),
    .data_req (tx_data_req),

    .scan_resp_req (tx_scan_resp_req),
    .assoc_resp_req (tx_assoc_resp_req),

    .keep_alive_req (keep_alive_req),    
    .keep_alive_resp_req (keep_alive_resp_req),

    .scan_failed_cnt (scan_failed_cnt),
    .assoc_failed_cnt (assoc_failed_cnt),
    .ssw_failed_cnt (ssw_failed_cnt),    

    // beamforming
    .ssw_req (tx_ssw_req),
    .ssw_fd_req (tx_ssw_fd_req),
    .ssw_ack_req (tx_ssw_ack_req),
    .ssw_field (tx_ssw_field),
    .ssw_fd_field (tx_ssw_fd_field),
    .ssw_fd_field_rsp (tx_ssw_fd_field_rsp),
 
    .mac_frame_length (tx_length),

    .rx_frame_ctrl (rx_frame_ctrl),
    .rx_frag_num (rx_frag_num),
    .rx_seq_num (rx_seq_num),
    .rx_ssw_field (rx_ssw_field),
    .rx_ssw_fd_field (rx_ssw_fd_field),

    .rf_beam_set_done (rf_beam_set_done),
    .rf_beam_set_req (rf_beam_set_req),

    .ipc_wen (ipc_wen),
    .ipc_ren (ipc_ren),    
    .ipc_addr (ipc_addr),
    .ipc_wdata (ipc_wdata),
    .ipc_rdata (ipc_rdata),   

    .rx_last (rx_last),
    .fcs_match (fcs_match),

    .mac_trans_ready (mac_trans_ready),
    .tx_last (tx_m_axis_tlast)

);

mac_ctrl_tx #(.DATA_WIDTH (32)) i_mac_ctrl_tx (

    .clk (clk),
    .rstn (rstn),
    .op_mode (mac_op_mode_sync),
    
    // from codec
    .s_axis_tdata(tx_s_axis_tdata),
    .s_axis_tkeep(tx_s_axis_tkeep),
    .s_axis_tvalid(tx_s_axis_tvalid),
    .s_axis_tready(tx_s_axis_tready),
    .s_axis_tlast(tx_s_axis_tlast),

    // to PHY
    .m_axis_tdata(tx_m_axis_tdata),
    .m_axis_tkeep(tx_m_axis_tkeep),
    .m_axis_tvalid(tx_m_axis_tvalid),
    .m_axis_tready(tx_m_axis_tready),
    .m_axis_tlast(tx_m_axis_tlast),
    .m_axis_sof (tx_m_axis_sof),

    .scan_req (tx_scan_req),
    .assoc_req (tx_assoc_req),
    .data_req (tx_data_req),
    .scan_resp_req (tx_scan_resp_req),
    .assoc_resp_req (tx_assoc_resp_req),    

    .keep_alive_req (keep_alive_req),    
    .keep_alive_resp_req (keep_alive_resp_req),    

    .ssw_req (tx_ssw_req),
    .ssw_fd_req (tx_ssw_fd_req),
    .ssw_ack_req (tx_ssw_ack_req),
    .ssw_field (tx_ssw_field),
    .ssw_fd_field (tx_ssw_fd_field),
    .ssw_fd_field_rsp (tx_ssw_fd_field_rsp),

    .tx_length (tx_length)

);

mac_ctrl_rx #(.DATA_WIDTH (32)) i_mac_ctrl_rx (
    
    .clk (clk),
    .rstn (rstn),
    
    .s_axis_tdata (rx_s_axis_tdata),
    .s_axis_tkeep (rx_s_axis_tkeep),
    .s_axis_tvalid (rx_s_axis_tvalid),
    .s_axis_tlast (rx_s_axis_tlast),
    .s_axis_tready (rx_s_axis_tready),  

    .rx_frame_ctrl (rx_frame_ctrl),
    .rx_frag_num (rx_frag_num),
    .rx_seq_num (rx_seq_num),
    .rx_ssw_field (rx_ssw_field),
    .rx_ssw_fd_field (rx_ssw_fd_field),

    // to Codec
    .m_axis_tdata (rx_m_axis_tdata),
    .m_axis_tkeep (rx_m_axis_tkeep),
    .m_axis_tvalid (rx_m_axis_tvalid),
    .m_axis_tlast (rx_m_axis_tlast),
    .m_axis_tready (rx_m_axis_tready),

    .rx_last (rx_last),
    .fcs_match (fcs_match),
    .fcs_error_cnt (fcs_error_cnt)

);


axi_lite_slave #(
    .AXI_DW (32), // data width
    .AXI_AW (32), // address width
    .AXI_IW (8), // ID width
    .AXI_SW (4) // strobe width
) i_axi_lite_controller (
    .axi_clk_i (s_axi_clk),
    .axi_rstn_i (s_axi_resetn),

    .axi_awid_i (8'h0),
    .axi_awaddr_i (s_axi_awaddr),
    .axi_awlen_i (4'h0),
    .axi_awsize_i (3'h2),
    .axi_awburst_i (2'h0),
    .axi_awlock_i (2'h0),
    .axi_awcache_i (4'h0),
    .axi_awprot_i (s_axi_awprot),
    .axi_awvalid_i (s_axi_awvalid),
    .axi_awready_o (s_axi_awready),

    .axi_wid_i (8'h0),
    .axi_wdata_i (s_axi_wdata),
    .axi_wstrb_i (s_axi_wstrb),
    .axi_wlast_i (1'b0),
    .axi_wvalid_i (s_axi_wvalid),
    .axi_wready_o (s_axi_wready),

    .axi_bid_o (),
    .axi_bresp_o (s_axi_bresp),
    .axi_bvalid_o (s_axi_bvalid),
    .axi_bready_i (s_axi_bready),

    .axi_arid_i (8'h0),
    .axi_araddr_i (s_axi_araddr),
    .axi_arlen_i (4'h0),
    .axi_arsize_i (3'h2),
    .axi_arburst_i (2'h0),
    .axi_arlock_i (2'h0),
    .axi_arcache_i (4'h0),
    .axi_arprot_i (s_axi_arprot),
    .axi_arvalid_i (s_axi_arvalid),
    .axi_arready_o (s_axi_arready),

    .axi_rid_o (),
    .axi_rdata_o (s_axi_rdata),
    .axi_rresp_o (s_axi_rresp),
    .axi_rlast_o (),    
    .axi_rvalid_o (s_axi_rvalid),
    .axi_rready_i (s_axi_rready),
    
    .sys_addr_o (sys_addr),
    .sys_wdata_o (sys_wdata),
    .sys_sel_o (sys_sel),
    .sys_wen_o (sys_wen),
    .sys_ren_o (sys_ren),
    .sys_rdata_i (sys_rdata),
    .sys_err_i (sys_err),
    .sys_ack_i (sys_ack)
);


mac_config i_mac_config (

    .clk (s_axi_clk),
    .rstn (rstn),

    .sys_addr (sys_addr),
    .sys_wdata (sys_wdata),
    .sys_sel (sys_sel),
    .sys_wen (sys_wen),
    .sys_ren (sys_ren),
    .sys_rdata (sys_rdata),
    .sys_err (sys_err),
    .sys_ack (sys_ack),

    .mac_op_mode (mac_op_mode), 
    .mac_payload_size (mac_payload_size),
    .probe_delay (probe_delay),
    .min_channel_time (min_channel_time),
    .max_channel_time (max_channel_time),
    .time_out_thv (time_out_thv), // connection timeout threshold
    .sbifs (sbifs),
    .lbifs (lbifs),
    .keep_alive_int (keep_alive_int),
    .keep_alive_timeout_thv (keep_alive_timeout_thv),

    .scan_failed_cnt (scan_failed_cnt),
    .assoc_failed_cnt (assoc_failed_cnt),
    .ssw_failed_cnt (ssw_failed_cnt),    
    .fcs_error_cnt (fcs_error_cnt),
    .packet_gap (packet_gap),

    .rf_beam_set_req_sync (rf_beam_set_req_sync), // to MCU
    .rf_beam_set_req (rf_beam_set_req), // from mlme_ctrl
    .rf_beam_set_done_sync (rf_beam_set_done),

    .clk_mac (clk),
    .ipc_wen (ipc_wen),
    .ipc_ren (ipc_ren),    
    .ipc_addr (ipc_addr),
    .ipc_wdata (ipc_wdata),
    .ipc_rdata (ipc_rdata)

);



// //-------------------------------------------------------------------
// // PHY Interface
// //-------------------------------------------------------------------
// phy_tx #(.DATA_WIDTH (32)) i_phy_tx (
//     .clk    (clk),
//     .rstn   (rstn),

//     .phy_txstart_req (dcnt[0]),
//     // header
//     .mcs    (mcs),
//     .scram_ini (scram_ini),
//     .mpdu_length (mpdu_length),
//     .tx_mode (tx_mode),
//     .beam_tracking_req (beam_tracking_req),
//     .back_ch_req (back_ch_req),
//     .packet_type (packet_type),
//     .tr_length (tr_length),
//     .turn_around (turn_around),

//     // AXI stream from MAC
//     .s_axis_tdata (tx_m_axis_tdata),
//     .s_axis_tkeep (tx_m_axis_tkeep),
//     .s_axis_tvalid (tx_m_axis_tvalid),
//     .s_axis_tlast (tx_m_axis_tlast),
//     .s_axis_tready (tx_m_axis_tready),

//     .data_out (dout),
//     .data_out_valid (dout_valid)
// );

// phy_rx #(.DATA_WIDTH (32)) i_phy_rx (
//     .clk (clk),
//     .rstn (rstn),

//     .adc_data_re (adc_data_re  ),
//     .adc_data_im (adc_data_im  ),
//     .adc_en (din_en),

//     .phy_sel (phy_rx_sel),
//     .header_descrambled (phy_rx_header),

//     // AXI stream to MAC
//     .m_axis_tdata (rx_s_axis_tdata),
//     .m_axis_tvalid (rx_s_axis_tvalid),
//     .m_axis_tkeep (rx_s_axis_tkeep),
//     .m_axis_tlast (rx_s_axis_tlast),
//     .m_axis_tready (rx_s_axis_tready)

// );

endmodule