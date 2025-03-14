`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: wise-jet
// Engineer: yj
// 
// Create Date: 2024/07/10
// Design Name: 802.11ad MAC
// Module Name: mac_fcs
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
module mac_fcs ( 

    input clk,
    input rstn,
    
    input crc_init,
    input [31:0] di,
    input di_valid,
    output logic [31:0] crc_out,
    output logic crc_out_valid
);

logic [31:0] crc_reg;
logic [31:0] data_in;

assign data_in = di;

always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        crc_reg <= 32'hffffffff;
    end
    else if (crc_init) begin
        crc_reg <= 32'hffffffff;
    end
    else if (di_valid) begin
        crc_reg[0] <= crc_reg[0] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[16] ^ crc_reg[20] ^ crc_reg[22] ^ crc_reg[23] ^ crc_reg[26] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[16] ^ data_in[20] ^ data_in[22] ^ data_in[23] ^ data_in[26];
        crc_reg[1] <= crc_reg[1] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[9] ^ crc_reg[17] ^ crc_reg[21] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[27] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[17] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[27];
        crc_reg[2] <= crc_reg[0] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[8] ^ crc_reg[9] ^ crc_reg[10] ^ crc_reg[18] ^ crc_reg[22] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[28] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[18] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[28];
        crc_reg[3] <= crc_reg[1] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[9] ^ crc_reg[10] ^ crc_reg[11] ^ crc_reg[19] ^ crc_reg[23] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[29] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[19] ^ data_in[23] ^ data_in[25] ^ data_in[26] ^ data_in[29];
        crc_reg[4] <= crc_reg[2] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[10] ^ crc_reg[11] ^ crc_reg[12] ^ crc_reg[20] ^ crc_reg[24] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[30] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[20] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[30];
        crc_reg[5] <= crc_reg[0] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[9] ^ crc_reg[11] ^ crc_reg[12] ^ crc_reg[13] ^ crc_reg[21] ^ crc_reg[25] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[31] ^ data_in[0] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[21] ^ data_in[25] ^ data_in[27] ^ data_in[28] ^ data_in[31];
        crc_reg[6] <= crc_reg[0] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[9] ^ crc_reg[10] ^ crc_reg[12] ^ crc_reg[13] ^ crc_reg[14] ^ crc_reg[16] ^ crc_reg[20] ^ crc_reg[23] ^ crc_reg[28] ^ crc_reg[29] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[9] ^ data_in[10] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[16] ^ data_in[20] ^ data_in[23] ^ data_in[28] ^ data_in[29];
        crc_reg[7] <= crc_reg[1] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[10] ^ crc_reg[11] ^ crc_reg[13] ^ crc_reg[14] ^ crc_reg[15] ^ crc_reg[17] ^ crc_reg[21] ^ crc_reg[24] ^ crc_reg[29] ^ crc_reg[30] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[10] ^ data_in[11] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[17] ^ data_in[21] ^ data_in[24] ^ data_in[29] ^ data_in[30];
        crc_reg[8] <= crc_reg[0] ^ crc_reg[2] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[11] ^ crc_reg[12] ^ crc_reg[14] ^ crc_reg[15] ^ crc_reg[16] ^ crc_reg[18] ^ crc_reg[22] ^ crc_reg[25] ^ crc_reg[30] ^ crc_reg[31] ^ data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[18] ^ data_in[22] ^ data_in[25] ^ data_in[30] ^ data_in[31];
        crc_reg[9] <= crc_reg[0] ^ crc_reg[2] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[12] ^ crc_reg[13] ^ crc_reg[15] ^ crc_reg[17] ^ crc_reg[19] ^ crc_reg[20] ^ crc_reg[22] ^ crc_reg[31] ^ data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[31];
        crc_reg[10] <= crc_reg[0] ^ crc_reg[2] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[7] ^ crc_reg[9] ^ crc_reg[13] ^ crc_reg[14] ^ crc_reg[18] ^ crc_reg[21] ^ crc_reg[22] ^ crc_reg[26] ^ data_in[0] ^ data_in[2] ^ data_in[4] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[13] ^ data_in[14] ^ data_in[18] ^ data_in[21] ^ data_in[22] ^ data_in[26];
        crc_reg[11] <= crc_reg[1] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[8] ^ crc_reg[10] ^ crc_reg[14] ^ crc_reg[15] ^ crc_reg[19] ^ crc_reg[22] ^ crc_reg[23] ^ crc_reg[27] ^ data_in[1] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[14] ^ data_in[15] ^ data_in[19] ^ data_in[22] ^ data_in[23] ^ data_in[27];
        crc_reg[12] <= crc_reg[2] ^ crc_reg[4] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[9] ^ crc_reg[11] ^ crc_reg[15] ^ crc_reg[16] ^ crc_reg[20] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[28] ^ data_in[2] ^ data_in[4] ^ data_in[6] ^ data_in[7] ^ data_in[9] ^ data_in[11] ^ data_in[15] ^ data_in[16] ^ data_in[20] ^ data_in[23] ^ data_in[24] ^ data_in[28];
        crc_reg[13] <= crc_reg[0] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[10] ^ crc_reg[12] ^ crc_reg[16] ^ crc_reg[17] ^ crc_reg[21] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[29] ^ data_in[0] ^ data_in[3] ^ data_in[5] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[16] ^ data_in[17] ^ data_in[21] ^ data_in[24] ^ data_in[25] ^ data_in[29];
        crc_reg[14] <= crc_reg[0] ^ crc_reg[1] ^ crc_reg[4] ^ crc_reg[6] ^ crc_reg[8] ^ crc_reg[9] ^ crc_reg[11] ^ crc_reg[13] ^ crc_reg[17] ^ crc_reg[18] ^ crc_reg[22] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[30] ^ data_in[0] ^ data_in[1] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[11] ^ data_in[13] ^ data_in[17] ^ data_in[18] ^ data_in[22] ^ data_in[25] ^ data_in[26] ^ data_in[30];
        crc_reg[15] <= crc_reg[1] ^ crc_reg[2] ^ crc_reg[5] ^ crc_reg[7] ^ crc_reg[9] ^ crc_reg[10] ^ crc_reg[12] ^ crc_reg[14] ^ crc_reg[18] ^ crc_reg[19] ^ crc_reg[23] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[31] ^ data_in[1] ^ data_in[2] ^ data_in[5] ^ data_in[7] ^ data_in[9] ^ data_in[10] ^ data_in[12] ^ data_in[14] ^ data_in[18] ^ data_in[19] ^ data_in[23] ^ data_in[26] ^ data_in[27] ^ data_in[31];
        crc_reg[16] <= crc_reg[1] ^ crc_reg[4] ^ crc_reg[7] ^ crc_reg[10] ^ crc_reg[11] ^ crc_reg[13] ^ crc_reg[15] ^ crc_reg[16] ^ crc_reg[19] ^ crc_reg[22] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[28] ^ data_in[1] ^ data_in[4] ^ data_in[7] ^ data_in[10] ^ data_in[11] ^ data_in[13] ^ data_in[15] ^ data_in[16] ^ data_in[19] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[27] ^ data_in[28];
        crc_reg[17] <= crc_reg[2] ^ crc_reg[5] ^ crc_reg[8] ^ crc_reg[11] ^ crc_reg[12] ^ crc_reg[14] ^ crc_reg[16] ^ crc_reg[17] ^ crc_reg[20] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[29] ^ data_in[2] ^ data_in[5] ^ data_in[8] ^ data_in[11] ^ data_in[12] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[20] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[27] ^ data_in[28] ^ data_in[29];
        crc_reg[18] <= crc_reg[0] ^ crc_reg[3] ^ crc_reg[6] ^ crc_reg[9] ^ crc_reg[12] ^ crc_reg[13] ^ crc_reg[15] ^ crc_reg[17] ^ crc_reg[18] ^ crc_reg[21] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[30] ^ data_in[0] ^ data_in[3] ^ data_in[6] ^ data_in[9] ^ data_in[12] ^ data_in[13] ^ data_in[15] ^ data_in[17] ^ data_in[18] ^ data_in[21] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[30];
        crc_reg[19] <= crc_reg[0] ^ crc_reg[1] ^ crc_reg[4] ^ crc_reg[7] ^ crc_reg[10] ^ crc_reg[13] ^ crc_reg[14] ^ crc_reg[16] ^ crc_reg[18] ^ crc_reg[19] ^ crc_reg[22] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[29] ^ crc_reg[30] ^ crc_reg[31] ^ data_in[0] ^ data_in[1] ^ data_in[4] ^ data_in[7] ^ data_in[10] ^ data_in[13] ^ data_in[14] ^ data_in[16] ^ data_in[18] ^ data_in[19] ^ data_in[22] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[29] ^ data_in[30] ^ data_in[31];
        crc_reg[20] <= crc_reg[0] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[11] ^ crc_reg[14] ^ crc_reg[15] ^ crc_reg[16] ^ crc_reg[17] ^ crc_reg[19] ^ crc_reg[22] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[30] ^ crc_reg[31] ^ data_in[0] ^ data_in[3] ^ data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[11] ^ data_in[14] ^ data_in[15] ^ data_in[16] ^ data_in[17] ^ data_in[19] ^ data_in[22] ^ data_in[27] ^ data_in[28] ^ data_in[30] ^ data_in[31];
        crc_reg[21] <= crc_reg[0] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[12] ^ crc_reg[15] ^ crc_reg[17] ^ crc_reg[18] ^ crc_reg[22] ^ crc_reg[26] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[31] ^ data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[12] ^ data_in[15] ^ data_in[17] ^ data_in[18] ^ data_in[22] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[31];
        crc_reg[22] <= crc_reg[2] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[13] ^ crc_reg[18] ^ crc_reg[19] ^ crc_reg[20] ^ crc_reg[22] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[29] ^ crc_reg[30] ^ data_in[2] ^ data_in[7] ^ data_in[8] ^ data_in[13] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[26] ^ data_in[27] ^ data_in[29] ^ data_in[30];
        crc_reg[23] <= crc_reg[0] ^ crc_reg[3] ^ crc_reg[8] ^ crc_reg[9] ^ crc_reg[14] ^ crc_reg[19] ^ crc_reg[20] ^ crc_reg[21] ^ crc_reg[23] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[30] ^ crc_reg[31] ^ data_in[0] ^ data_in[3] ^ data_in[8] ^ data_in[9] ^ data_in[14] ^ data_in[19] ^ data_in[20] ^ data_in[21] ^ data_in[23] ^ data_in[27] ^ data_in[28] ^ data_in[30] ^ data_in[31];
        crc_reg[24] <= crc_reg[2] ^ crc_reg[3] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[9] ^ crc_reg[10] ^ crc_reg[15] ^ crc_reg[16] ^ crc_reg[21] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[26] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[31] ^ data_in[2] ^ data_in[3] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[15] ^ data_in[16] ^ data_in[21] ^ data_in[23] ^ data_in[24] ^ data_in[26] ^ data_in[28] ^ data_in[29] ^ data_in[31];
        crc_reg[25] <= crc_reg[1] ^ crc_reg[2] ^ crc_reg[6] ^ crc_reg[9] ^ crc_reg[10] ^ crc_reg[11] ^ crc_reg[17] ^ crc_reg[20] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[29] ^ crc_reg[30] ^ data_in[1] ^ data_in[2] ^ data_in[6] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[17] ^ data_in[20] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[29] ^ data_in[30];
        crc_reg[26] <= crc_reg[2] ^ crc_reg[3] ^ crc_reg[7] ^ crc_reg[10] ^ crc_reg[11] ^ crc_reg[12] ^ crc_reg[18] ^ crc_reg[21] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[30] ^ crc_reg[31] ^ data_in[2] ^ data_in[3] ^ data_in[7] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[18] ^ data_in[21] ^ data_in[24] ^ data_in[25] ^ data_in[26] ^ data_in[27] ^ data_in[28] ^ data_in[30] ^ data_in[31];
        crc_reg[27] <= crc_reg[0] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[11] ^ crc_reg[12] ^ crc_reg[13] ^ crc_reg[16] ^ crc_reg[19] ^ crc_reg[20] ^ crc_reg[23] ^ crc_reg[25] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[31] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[6] ^ data_in[7] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[16] ^ data_in[19] ^ data_in[20] ^ data_in[23] ^ data_in[25] ^ data_in[27] ^ data_in[28] ^ data_in[29] ^ data_in[31];
        crc_reg[28] <= crc_reg[0] ^ crc_reg[4] ^ crc_reg[6] ^ crc_reg[12] ^ crc_reg[13] ^ crc_reg[14] ^ crc_reg[16] ^ crc_reg[17] ^ crc_reg[21] ^ crc_reg[22] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[30] ^ data_in[0] ^ data_in[4] ^ data_in[6] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[16] ^ data_in[17] ^ data_in[21] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[28] ^ data_in[29] ^ data_in[30];
        crc_reg[29] <= crc_reg[0] ^ crc_reg[1] ^ crc_reg[5] ^ crc_reg[7] ^ crc_reg[13] ^ crc_reg[14] ^ crc_reg[15] ^ crc_reg[17] ^ crc_reg[18] ^ crc_reg[22] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[29] ^ crc_reg[30] ^ crc_reg[31] ^ data_in[0] ^ data_in[1] ^ data_in[5] ^ data_in[7] ^ data_in[13] ^ data_in[14] ^ data_in[15] ^ data_in[17] ^ data_in[18] ^ data_in[22] ^ data_in[23] ^ data_in[24] ^ data_in[25] ^ data_in[29] ^ data_in[30] ^ data_in[31];
        crc_reg[30] <= crc_reg[3] ^ crc_reg[4] ^ crc_reg[7] ^ crc_reg[14] ^ crc_reg[15] ^ crc_reg[18] ^ crc_reg[19] ^ crc_reg[20] ^ crc_reg[22] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[30] ^ crc_reg[31] ^ data_in[3] ^ data_in[4] ^ data_in[7] ^ data_in[14] ^ data_in[15] ^ data_in[18] ^ data_in[19] ^ data_in[20] ^ data_in[22] ^ data_in[24] ^ data_in[25] ^ data_in[30] ^ data_in[31];
        crc_reg[31] <= crc_reg[0] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[15] ^ crc_reg[19] ^ crc_reg[21] ^ crc_reg[22] ^ crc_reg[25] ^ crc_reg[31] ^ data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[15] ^ data_in[19] ^ data_in[21] ^ data_in[22] ^ data_in[25] ^ data_in[31];
    end
end

assign crc_out = ~crc_reg;

always_ff @(posedge clk or negedge rstn)
    if (~rstn) crc_out_valid <= 'h0;
    else crc_out_valid <= di_valid;

endmodule