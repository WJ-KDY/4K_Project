`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2023 08:01:46 PM
// Design Name: 
// Module Name: vid_tpg
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

module vid_tpg # (
    parameter CN = 16,
    parameter HN = 2,
    parameter HT = 275,
    parameter HA = 1920*HN/CN,
    parameter HF = 4,
    parameter HS = 4,
    parameter HB = 1,
    parameter VN = 2,
    parameter VT = 1125*VN,
    parameter VA = 1080*VN,
    parameter VF = 4,
    parameter VS = 5,
    parameter VB = 1,
    parameter DW = 32,
    parameter PN = 32,
    parameter CW = 16,
    parameter VX1 = 0)(
    VIO_HT,VIO_HF,VIO_HB,
    VIO_VT,VIO_VF,VIO_VS,
    DE,
    HSYNC,
    VSYNC,
    DATA,
    clk,
    rstn
);
input  [31:0]     	VIO_HT,VIO_HF,VIO_HB;
input  [31:0]     	VIO_VT,VIO_VF,VIO_VS;
output [PN-1:0]     DE;
output [PN-1:0]     HSYNC;
output [PN-1:0]     VSYNC;
output [DW*PN-1:0]  DATA;
input               clk;
input               rstn;

wire [15:0] HDR; assign HDR = 	  (VIO_HB[15:0] > 0 ? VIO_HB[15:0] :HB);
wire [15:0] HDF; assign HDF = HDR+HA;
wire [15:0] HSR; assign HSR = HDF+(VIO_HF[15:0] > 0 ? VIO_HF[15:0] :HF);
wire [15:0] HSF; assign HSF = HSR+HS;

wire [15:0] VDR; assign VDR = VB;
wire [15:0] VDF; assign VDF = VDR+VA;
wire [15:0] VSR; assign VSR = VDF+(VIO_VF[15:0] > 0 ? VIO_VF[15:0] :VF);
wire [15:0] VSF; assign VSF = VSR+(VIO_VS[15:0] > 0 ? VIO_VS[15:0] :VS);

assign rst = ~rstn;
wire [PN-1:0]     HSYNC;
wire [PN-1:0]     VSYNC;
wire [PN-1:0]     DE;
reg  [CW-1:0] hcnt  = 0;
reg  [CW-1:0] vcnt  = 0;
reg  [9:0] fcnt  = 0;
always @(posedge clk ) begin
    if(!rst)
        if (hcnt >= (VIO_HT[15:0] == 0 ? HT : VIO_HT[15:0])) begin
            hcnt <= 1;
            if (vcnt >= (VIO_VT[15:0] == 0 ? VT : VIO_VT[15:0])) begin
                vcnt <= 1;
               if (fcnt >= 480-1) begin
                   fcnt <= 0;
               end else begin
                   fcnt <= fcnt + 1;
               end
            end else begin
                vcnt <= vcnt + 1;
               fcnt <= fcnt;
            end
        end else begin
            hcnt <= hcnt + 1;
            vcnt <= vcnt;
           fcnt <= fcnt;
        end
    else begin
        hcnt <= 0;
        vcnt <= 0;
       fcnt <= 0;
    end
end
wire   hde;
wire   hse;
assign hde  = rst ? 0 :(hcnt >= HDR && hcnt   < HDF) ? 1 : 0;
assign hse  = rst ? 0 :(hcnt >= HSR && hcnt   < HSF) ? 1 : 0;

wire   vde;
wire   vse;
assign vde  = rst ? 0 :(vcnt >= VDR && vcnt   < VDF) ? 1 : 0;
assign vse  = rst ? 0 :(vcnt >= VSR && vcnt   < VSF) ? 1 : 0;

assign HSYNC    = !VX1 ? {PN{hse}} : (&DE) ? 0 : !{PN{hse}};
assign VSYNC    = !VX1 ? {PN{vse}} : (&DE) ? 0 : !{PN{vse}};
assign DE       = {PN{hde}} & {PN{vde}};


// wire vsync,de;
// // vid_sync_gen vid_sync_gen (VIO_HT,VIO_HF,VIO_HB,VIO_VT,VIO_VF,VIO_VS,clk,vsync,de,dcnt[0]);
// assign VSYNC 	= {32{vsync}};
// assign DE 		= {32{de}};

reg  [8:0] xcnt = 0;
always @(posedge clk ) begin
    if (rst)   		xcnt <= 0;else
    if (VSYNC[0])	xcnt <= 0;else
    if (DE[0])		xcnt <= (xcnt < HA-1 ) ? xcnt + 1 : 0 ;else xcnt = 0;
end

wire [7:0] dcnt[0:3];
assign dcnt[0]=255-xcnt[7:0];
assign dcnt[1]=255-xcnt[7:0];
assign dcnt[2]=255-xcnt[7:0];
assign dcnt[3]=255-xcnt[7:0];

// assign dcnt[0]=fcnt/2+xcnt/4+60*0>240?fcnt/2+xcnt/4+60*0-240:fcnt/2+xcnt/4+60*0;
// assign dcnt[1]=fcnt/2+xcnt/4+60*1>240?fcnt/2+xcnt/4+60*1-240:fcnt/2+xcnt/4+60*1;
// assign dcnt[2]=fcnt/2+xcnt/4+60*2>240?fcnt/2+xcnt/4+60*2-240:fcnt/2+xcnt/4+60*2;
// assign dcnt[3]=fcnt/2+xcnt/4+60*3>240?fcnt/2+xcnt/4+60*3-240:fcnt/2+xcnt/4+60*3;

genvar i,j;
generate
    if (VN == 2) begin : VID_4K
        if(1)begin
            for(i= 0;i< 4;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[0]}}} : 0;end
            for(i= 4;i< 8;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[1]}}} : 0;end
            for(i= 8;i<12;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[2]}}} : 0;end
            for(i=12;i<16;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[3]}}} : 0;end
            for(i=16;i<20;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[0]}}} : 0;end
            for(i=20;i<24;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[1]}}} : 0;end
            for(i=24;i<28;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[2]}}} : 0;end
            for(i=28;i<32;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[3]}}} : 0;end
        end else begin
            for(i= 0;i< 4;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {2'd0,{3{10'd1023}}} : 0;end
            for(i= 4;i< 8;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {2'd0,{3{10'd1023}}} : 0;end
            for(i= 8;i<12;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {2'd0,{3{10'd1023}}} : 0;end
            for(i=12;i<16;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {2'd0,{3{10'd1023}}} : 0;end
            for(i=16;i<20;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {2'd0,{3{10'd1023}}} : 0;end
            for(i=20;i<24;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {2'd0,{3{10'd1023}}} : 0;end
            for(i=24;i<28;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {2'd0,{3{10'd1023}}} : 0;end
            for(i=28;i<32;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {2'd0,{3{10'd1023}}} : 0;end
        end
    end else begin : VID_8K
        for(i= 0;i< 8;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[0]}}} : 0;end
        for(i= 8;i<16;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[1]}}} : 0;end
        for(i=16;i<24;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[2]}}} : 0;end
        for(i=24;i<32;i=i+1)begin assign DATA[32*(i+1)-1:32*(i)]  = rst ? 0:(DE[i]) ? {8'd0,{3{dcnt[3]}}} : 0;end
    end
endgenerate 

endmodule
