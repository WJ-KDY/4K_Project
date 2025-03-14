`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: wise-jet
// Engineer: yj
// 
// Create Date: 2024/07/18
// Design Name: 802.11ad MAC
// Module Name: mac_managiment_cofig
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
`include "define.vh"

module mac_config (
    input clk,
    input rstn,

    input [31:0] sys_addr, // system bus read/write address.
    input [31:0] sys_wdata, // system bus write data.
    input [3:0] sys_sel, // system bus write byte select.
    input sys_wen, // system bus write enable.
    input sys_ren, // system bus read enable.
    output logic [31:0] sys_rdata,  // system bus read data.
    output logic sys_err, // system bus error indicator.
    output logic sys_ack, // system bus acknowledge signal.

    output logic mac_op_mode,
    output logic [19:0] mac_payload_size,
    output logic [31:0] probe_delay,
    output logic [31:0] min_channel_time,
    output logic [31:0] max_channel_time,
    output logic [31:0] time_out_thv,
    output logic [31:0] sbifs,
    output logic [31:0] lbifs,
    output logic [7:0] packet_gap,
    output logic [31:0] keep_alive_int,
    output logic [31:0] keep_alive_timeout_thv,

    input [7:0] scan_failed_cnt,
    input [7:0] assoc_failed_cnt,
    input [7:0] ssw_failed_cnt,
    input [31:0] fcs_error_cnt,

    // to MCU
    output logic rf_beam_set_req_sync,
    input rf_beam_set_req, // from mlme_ctrl   
    output logic rf_beam_set_done_sync,     

    // clk_mac domain
    input clk_mac, // 330mhz
    input ipc_wen,
    input ipc_ren,
    input [9:0] ipc_addr,
    input [31:0] ipc_wdata,
    output [31:0] ipc_rdata

);

logic rf_beam_set_done;
logic [31:0] ipc_douta;
logic ipc_wea;
logic ipc_rea;
logic ipc_ena;
logic ipc_enb;
logic [1:0] ipc_rea_ff;
logic [1:0] ipc_ren_ff;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        `ifdef DECODER
        mac_op_mode <= 'h1;
        `else
        mac_op_mode <= 'h0;
        `endif
        mac_payload_size <= 20'd4096;
        probe_delay <= 32'd5000;
        min_channel_time <= 'h0;
        max_channel_time <= 32'd5000;
        time_out_thv <= 32'd5000;
        sbifs <= 32'd5000;
        lbifs <= 32'd5000;
        packet_gap <= 'h10;
        `ifdef SIM
        keep_alive_int <= 32'd5000; 
        keep_alive_timeout_thv <= 32'd5000;         
        `else
        keep_alive_int <= 32'd356400000; // 3 sec
        keep_alive_timeout_thv <= 32'd356400000; // 3 sec        
        `endif


    end
    else if (sys_wen) begin
        if (sys_addr[10:0] == 11'h0) mac_op_mode <= sys_wdata[0];
        else if (sys_addr[10:0] == 11'h4) mac_payload_size <= sys_wdata[19:0];
        else if (sys_addr[10:0] == 11'h8) probe_delay <= sys_wdata;
        else if (sys_addr[10:0] == 11'hc) min_channel_time <= sys_wdata;
        else if (sys_addr[10:0] == 11'h10) max_channel_time <= sys_wdata;
        else if (sys_addr[10:0] == 11'h14) time_out_thv <= sys_wdata;
        else if (sys_addr[10:0] == 11'h18) sbifs <= sys_wdata;
        else if (sys_addr[10:0] == 11'h1c) lbifs <= sys_wdata;
        // 20~2f
        else if (sys_addr[10:0] == 11'h30) packet_gap <= sys_wdata[7:0];
        else if (sys_addr[10:0] == 11'h34) keep_alive_int <= sys_wdata;
        else if (sys_addr[10:0] == 11'h38) keep_alive_timeout_thv <= sys_wdata;


    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        rf_beam_set_done <= 'h0;

    end
    else if (rf_beam_set_done) begin
        rf_beam_set_done <= 1'b0; // clear
    end
    else if (sys_wen) begin
        if (sys_addr[7:0] == 8'h50) begin
            rf_beam_set_done <= sys_wdata[0];
        end
    end
end

bit_sync #(.INITIALIZE(5'b00000)) i_bit_sync_rf_req (
    .clk_in (clk),
    .i_in (rf_beam_set_req), // from beam_ctrl
    .o_out (rf_beam_set_req_sync) // to MCU 
);

bit_sync #(.INITIALIZE(5'b00000)) i_bit_sync_rf_done (
    .clk_in (clk_mac),
    .i_in (rf_beam_set_done), // MCU
    .o_out (rf_beam_set_done_sync) // to mlme_ctrl
);


logic [31:0] reg_rdata;
logic sys_ren_ff;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        reg_rdata <= 'h0;
    end
    else begin
        case (sys_addr[10:0])
        11'h00: reg_rdata <= {31'h0, mac_op_mode};
        11'h04: reg_rdata <= {12'h0, mac_payload_size};
        11'h08: reg_rdata <= probe_delay;
        11'h0c: reg_rdata <= min_channel_time;
        11'h10: reg_rdata <= max_channel_time;
        11'h14: reg_rdata <= time_out_thv;
        11'h18: reg_rdata <= sbifs;
        11'h1c: reg_rdata <= lbifs;
        11'h20: reg_rdata <= {24'h0, scan_failed_cnt};
        11'h24: reg_rdata <= {24'h0, assoc_failed_cnt};
        11'h28: reg_rdata <= {24'h0, ssw_failed_cnt};
        11'h2c: reg_rdata <= fcs_error_cnt;
        11'h30: reg_rdata <= {24'h0, packet_gap};
        11'h34: reg_rdata <= keep_alive_int;
        11'h38: reg_rdata <= keep_alive_timeout_thv;

        default: reg_rdata <= 'h0;
        endcase
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        sys_err <= 'h0;
        sys_ack <= 'h0;
        sys_ren_ff <= 'h0;
    end
    else begin
        sys_ren_ff <= sys_ren | sys_wen;
        sys_ack <= sys_ren_ff;
        sys_err <= 1'b0;
    end
end

assign sys_rdata = ((sys_addr[10:0] >= 11'h100) & (sys_addr[10:0] < 11'h500)) ? ipc_douta : reg_rdata;


assign ipc_wea = (sys_addr[10:0] >= 11'h100) & (sys_addr[10:0] < 11'h500) & sys_wen;
assign ipc_rea = (sys_addr[10:0] >= 11'h100) & (sys_addr[10:0] < 11'h500) & sys_ren;

assign ipc_ena = ipc_wea | ipc_rea | ipc_rea_ff;
assign ipc_enb = ipc_wen | ipc_ren | ipc_ren_ff;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        ipc_rea_ff <= 'h0;
    end
    else begin
        ipc_rea_ff <= {ipc_rea_ff[0], ipc_rea};
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        ipc_ren_ff <= 'h0;
    end
    else begin
        ipc_ren_ff <= {ipc_ren_ff[0], ipc_ren};
    end
end

//-------------------------------------------------------------------
//  IPC (address 0x100 ~ 0x500)
//-------------------------------------------------------------------


blk_mem_gen_32x1024 i_ipc_mem (
    .clka (clk),
    .ena (ipc_ena),
    .wea (ipc_wea),
    .addra (sys_addr[9:0]),
    .dina (sys_wdata),
    .douta (ipc_douta),
    .clkb (clk_mac),
    .enb (ipc_enb),
    .web (ipc_wen),
    .addrb (ipc_addr),
    .dinb (ipc_wdata),
    .doutb (ipc_rdata)
);



endmodule