//##################################################################################
//
// (C) COPYRIGHT 2023 Techno Mathematical Co.,Ltd
//
// This software and the associated documentation are confidential and
// proprietry to Techno Mathematical Co., Ltd
//
// TMC JPEG XS HW Encoder : TM22355(4K444 for FPGA)
//
// Release version 1.03 (2023.12.05)
//
//##################################################################################
`timescale 1ns / 1ps // Modified on 2023/12/18 by jihan
module TMC_JXSE_TOP(
         CCLK                    //
        ,VCLK                    //
        ,HCLK                    //
        ,RSTN                    //
        ,JXSE_INT                //

         // AHB-BUS
        ,SHSEL                   // i select
        ,SHREADYIN               // i ready
        ,SHADDR                  // i address
        ,SHSIZE                  // i data size
        ,SHBURST                 // i burst type
        ,SHPROT                  // i protect type
        ,SHMASTLOCK              // i lock type
        ,SHWDATA                 // i write data
        ,SHWRITE                 // i write
        ,SHTRANS                 // i transfer type
        ,SHREADYOUT              // o ready
        ,SHRESP                  // o responce
        ,SHRDATA                 // o read data

        ,S_AXIS_VIDEO_DATA       //
        ,S_AXIS_VIDEO_VALID      //
        ,S_AXIS_VIDEO_STRB       //
        ,S_AXIS_VIDEO_EOL        //
        ,S_AXIS_VIDEO_KEEP       //
        ,S_AXIS_VIDEO_ID         //
        ,S_AXIS_VIDEO_DEST       //
        ,S_AXIS_VIDEO_READY      //
        ,S_AXIS_VIDEO_SOF        //

        ,M_AXIS_STRM_DATA        //
        ,M_AXIS_STRM_VALID       //
        ,M_AXIS_STRM_STRB        //
        ,M_AXIS_STRM_EOL         //
        ,M_AXIS_STRM_KEEP        //
        ,M_AXIS_STRM_ID          //
        ,M_AXIS_STRM_DEST        //
        ,M_AXIS_STRM_READY       //
        ,M_AXIS_STRM_SOF         //

);

    //----------------------------------------------------------------------
    // parameter declaration
    //----------------------------------------------------------------------

    //---------------------------------------------------------------------
    // Defination of Port Signals
    //---------------------------------------------------------------------
    input                CCLK                  ;
    input                VCLK                  ;
    input                HCLK                  ;
    input                RSTN                  ;
    output               JXSE_INT              ;

    // AHB-BUS
    input                SHSEL                 ;
    input                SHREADYIN             ;
    input  [      31:0]  SHADDR                ; // only [12:2] referred
    input  [       2:0]  SHSIZE                ; // 32bits only
    input  [       2:0]  SHBURST               ;
    input  [       3:0]  SHPROT                ; // no support
    input                SHMASTLOCK            ; // no support
    input  [      31:0]  SHWDATA               ;
    input                SHWRITE               ;
    input  [       1:0]  SHTRANS               ;
    output               SHREADYOUT            ;
    output               SHRESP                ; // always OK
    output [      31:0]  SHRDATA               ;

    input  [     143:0]  S_AXIS_VIDEO_DATA     ;
    input                S_AXIS_VIDEO_VALID    ;
    input  [      17:0]  S_AXIS_VIDEO_STRB     ;  // no use
    input                S_AXIS_VIDEO_EOL      ;  // no use
    input  [      17:0]  S_AXIS_VIDEO_KEEP     ;  // no use
    input                S_AXIS_VIDEO_ID       ;  // no use
    input                S_AXIS_VIDEO_DEST     ;  // no use
    output               S_AXIS_VIDEO_READY    ;  //
    input                S_AXIS_VIDEO_SOF      ;  // no use

    output [     127:0]  M_AXIS_STRM_DATA      ;
    output               M_AXIS_STRM_VALID     ;
    output [      15:0]  M_AXIS_STRM_STRB      ;  //
    output               M_AXIS_STRM_EOL       ;  //
    output [      15:0]  M_AXIS_STRM_KEEP      ;  //
    output               M_AXIS_STRM_ID        ;  //
    output               M_AXIS_STRM_DEST      ;  //
    input                M_AXIS_STRM_READY     ;  //
    output               M_AXIS_STRM_SOF       ;  //


    //---------------------------------------------------------------------
    // Clip & Un-Connect TOP ports
    //---------------------------------------------------------------------

    //CPU
    wire [23:0] NC_SHADDR     = SHADDR[31:8];
    wire [ 2:0] NC_SHSIZE     = SHSIZE     ;
    wire [ 2:0] NC_SHBURST    = SHBURST    ;
    wire [ 3:0] NC_SHPROT     = SHPROT     ;
    wire        NC_SHMASTLOCK = SHMASTLOCK ;
    assign  SHRESP            = 1'b0       ; // means OKAY
    
    //VIDEO (Slave) 
    wire        NC_AXIS_VIDEO_SOF  = S_AXIS_VIDEO_SOF  ;
    wire        NC_AXIS_VIDEO_EOL  = S_AXIS_VIDEO_EOL  ;
    wire [17:0] NC_AXIS_VIDEO_STRB = S_AXIS_VIDEO_STRB ;
    wire [17:0] NC_AXIS_VIDEO_KEEP = S_AXIS_VIDEO_KEEP ;
    wire        NC_AXIS_VIDEO_ID   = S_AXIS_VIDEO_ID   ;
    wire        NC_AXIS_VIDEO_DEST = S_AXIS_VIDEO_DEST ;
    
    //Stream(Master) 
    assign M_AXIS_STRM_STRB = 16'hffff ;
    assign M_AXIS_STRM_KEEP = 16'hffff ;
    assign M_AXIS_STRM_ID   =  1'b0    ;
    assign M_AXIS_STRM_DEST =  1'b0    ;
    assign M_AXIS_STRM_EOL  =  1'b0    ;
    assign M_AXIS_STRM_SOF  =  1'b0    ;

    //SRAM IF
    wire   [9    :0] ram000_radr           ;
    wire             ram000_ren            ;
    wire   [79   :0] ram000_rd             ;
    wire   [9    :0] ram000_wadr           ;
    wire             ram000_wen            ;
    wire   [79   :0] ram000_wd             ;
    wire   [9    :0] ram001_radr           ;
    wire             ram001_ren            ;
    wire   [79   :0] ram001_rd             ;
    wire   [9    :0] ram001_wadr           ;
    wire             ram001_wen            ;
    wire   [79   :0] ram001_wd             ;
    wire   [9    :0] ram002_radr           ;
    wire             ram002_ren            ;
    wire   [79   :0] ram002_rd             ;
    wire   [9    :0] ram002_wadr           ;
    wire             ram002_wen            ;
    wire   [79   :0] ram002_wd             ;
    wire   [9    :0] ram003_radr           ;
    wire             ram003_ren            ;
    wire   [79   :0] ram003_rd             ;
    wire   [9    :0] ram003_wadr           ;
    wire             ram003_wen            ;
    wire   [79   :0] ram003_wd             ;
    wire   [9    :0] ram004_radr           ;
    wire             ram004_ren            ;
    wire   [79   :0] ram004_rd             ;
    wire   [9    :0] ram004_wadr           ;
    wire             ram004_wen            ;
    wire   [79   :0] ram004_wd             ;
    wire   [9    :0] ram005_radr           ;
    wire             ram005_ren            ;
    wire   [79   :0] ram005_rd             ;
    wire   [9    :0] ram005_wadr           ;
    wire             ram005_wen            ;
    wire   [79   :0] ram005_wd             ;
    wire   [9    :0] ram006_radr           ;
    wire             ram006_ren            ;
    wire   [79   :0] ram006_rd             ;
    wire   [9    :0] ram006_wadr           ;
    wire             ram006_wen            ;
    wire   [79   :0] ram006_wd             ;
    wire   [9    :0] ram007_radr           ;
    wire             ram007_ren            ;
    wire   [79   :0] ram007_rd             ;
    wire   [9    :0] ram007_wadr           ;
    wire             ram007_wen            ;
    wire   [79   :0] ram007_wd             ;
    wire   [9    :0] ram010_radr           ;
    wire             ram010_ren            ;
    wire   [79   :0] ram010_rd             ;
    wire   [9    :0] ram010_wadr           ;
    wire             ram010_wen            ;
    wire   [79   :0] ram010_wd             ;
    wire   [9    :0] ram011_radr           ;
    wire             ram011_ren            ;
    wire   [79   :0] ram011_rd             ;
    wire   [9    :0] ram011_wadr           ;
    wire             ram011_wen            ;
    wire   [79   :0] ram011_wd             ;
    wire   [9    :0] ram012_radr           ;
    wire             ram012_ren            ;
    wire   [79   :0] ram012_rd             ;
    wire   [9    :0] ram012_wadr           ;
    wire             ram012_wen            ;
    wire   [79   :0] ram012_wd             ;
    wire   [9    :0] ram013_radr           ;
    wire             ram013_ren            ;
    wire   [79   :0] ram013_rd             ;
    wire   [9    :0] ram013_wadr           ;
    wire             ram013_wen            ;
    wire   [79   :0] ram013_wd             ;
    wire   [9    :0] ram014_radr           ;
    wire             ram014_ren            ;
    wire   [79   :0] ram014_rd             ;
    wire   [9    :0] ram014_wadr           ;
    wire             ram014_wen            ;
    wire   [79   :0] ram014_wd             ;
    wire   [9    :0] ram015_radr           ;
    wire             ram015_ren            ;
    wire   [79   :0] ram015_rd             ;
    wire   [9    :0] ram015_wadr           ;
    wire             ram015_wen            ;
    wire   [79   :0] ram015_wd             ;
    wire   [9    :0] ram016_radr           ;
    wire             ram016_ren            ;
    wire   [79   :0] ram016_rd             ;
    wire   [9    :0] ram016_wadr           ;
    wire             ram016_wen            ;
    wire   [79   :0] ram016_wd             ;
    wire   [9    :0] ram017_radr           ;
    wire             ram017_ren            ;
    wire   [79   :0] ram017_rd             ;
    wire   [9    :0] ram017_wadr           ;
    wire             ram017_wen            ;
    wire   [79   :0] ram017_wd             ;
    wire   [9    :0] ram020_radr           ;
    wire             ram020_ren            ;
    wire   [79   :0] ram020_rd             ;
    wire   [9    :0] ram020_wadr           ;
    wire             ram020_wen            ;
    wire   [79   :0] ram020_wd             ;
    wire   [9    :0] ram021_radr           ;
    wire             ram021_ren            ;
    wire   [79   :0] ram021_rd             ;
    wire   [9    :0] ram021_wadr           ;
    wire             ram021_wen            ;
    wire   [79   :0] ram021_wd             ;
    wire   [9    :0] ram022_radr           ;
    wire             ram022_ren            ;
    wire   [79   :0] ram022_rd             ;
    wire   [9    :0] ram022_wadr           ;
    wire             ram022_wen            ;
    wire   [79   :0] ram022_wd             ;
    wire   [9    :0] ram023_radr           ;
    wire             ram023_ren            ;
    wire   [79   :0] ram023_rd             ;
    wire   [9    :0] ram023_wadr           ;
    wire             ram023_wen            ;
    wire   [79   :0] ram023_wd             ;
    wire   [9    :0] ram024_radr           ;
    wire             ram024_ren            ;
    wire   [79   :0] ram024_rd             ;
    wire   [9    :0] ram024_wadr           ;
    wire             ram024_wen            ;
    wire   [79   :0] ram024_wd             ;
    wire   [9    :0] ram025_radr           ;
    wire             ram025_ren            ;
    wire   [79   :0] ram025_rd             ;
    wire   [9    :0] ram025_wadr           ;
    wire             ram025_wen            ;
    wire   [79   :0] ram025_wd             ;
    wire   [9    :0] ram026_radr           ;
    wire             ram026_ren            ;
    wire   [79   :0] ram026_rd             ;
    wire   [9    :0] ram026_wadr           ;
    wire             ram026_wen            ;
    wire   [79   :0] ram026_wd             ;
    wire   [9    :0] ram027_radr           ;
    wire             ram027_ren            ;
    wire   [79   :0] ram027_rd             ;
    wire   [9    :0] ram027_wadr           ;
    wire             ram027_wen            ;
    wire   [79   :0] ram027_wd             ;
    
    wire   [10   :0] ram100_radr           ;
    wire             ram100_ren            ;
    wire   [127  :0] ram100_rd             ;
    wire   [10   :0] ram100_wadr           ;
    wire             ram100_wen            ;
    wire   [127  :0] ram100_wd             ;
    wire   [10   :0] ram104_radr           ;
    wire             ram104_ren            ;
    wire   [127  :0] ram104_rd             ;
    wire   [10   :0] ram104_wadr           ;
    wire             ram104_wen            ;
    wire   [127  :0] ram104_wd             ;
    wire   [10   :0] ram108_radr           ;
    wire             ram108_ren            ;
    wire   [127  :0] ram108_rd             ;
    wire   [10   :0] ram108_wadr           ;
    wire             ram108_wen            ;
    wire   [127  :0] ram108_wd             ;
    wire   [8    :0] ram112_radr           ;
    wire             ram112_ren            ;
    wire   [127  :0] ram112_rd             ;
    wire   [8    :0] ram112_wadr           ;
    wire             ram112_wen            ;
    wire   [127  :0] ram112_wd             ;
    wire   [8    :0] ram116_radr           ;
    wire             ram116_ren            ;
    wire   [127  :0] ram116_rd             ;
    wire   [8    :0] ram116_wadr           ;
    wire             ram116_wen            ;
    wire   [127  :0] ram116_wd             ;
    wire   [8    :0] ram120_radr           ;
    wire             ram120_ren            ;
    wire   [127  :0] ram120_rd             ;
    wire   [8    :0] ram120_wadr           ;
    wire             ram120_wen            ;
    wire   [127  :0] ram120_wd             ;
    wire   [7    :0] ram124_radr           ;
    wire             ram124_ren            ;
    wire   [127  :0] ram124_rd             ;
    wire   [7    :0] ram124_wadr           ;
    wire             ram124_wen            ;
    wire   [127  :0] ram124_wd             ;
    wire   [6    :0] ram128_radr           ;
    wire             ram128_ren            ;
    wire   [127  :0] ram128_rd             ;
    wire   [6    :0] ram128_wadr           ;
    wire             ram128_wen            ;
    wire   [127  :0] ram128_wd             ;
    wire   [5    :0] ram132_radr           ;
    wire             ram132_ren            ;
    wire   [127  :0] ram132_rd             ;
    wire   [5    :0] ram132_wadr           ;
    wire             ram132_wen            ;
    wire   [127  :0] ram132_wd             ;
    wire   [5    :0] ram136_radr           ;
    wire             ram136_ren            ;
    wire   [127  :0] ram136_rd             ;
    wire   [5    :0] ram136_wadr           ;
    wire             ram136_wen            ;
    wire   [127  :0] ram136_wd             ;
    wire   [10   :0] ram140_radr           ;
    wire             ram140_ren            ;
    wire   [127  :0] ram140_rd             ;
    wire   [10   :0] ram140_wadr           ;
    wire             ram140_wen            ;
    wire   [127  :0] ram140_wd             ;
    wire   [10   :0] ram144_radr           ;
    wire             ram144_ren            ;
    wire   [127  :0] ram144_rd             ;
    wire   [10   :0] ram144_wadr           ;
    wire             ram144_wen            ;
    wire   [127  :0] ram144_wd             ;
    wire   [10   :0] ram148_radr           ;
    wire             ram148_ren            ;
    wire   [127  :0] ram148_rd             ;
    wire   [10   :0] ram148_wadr           ;
    wire             ram148_wen            ;
    wire   [127  :0] ram148_wd             ;
    wire   [8    :0] ram152_radr           ;
    wire             ram152_ren            ;
    wire   [127  :0] ram152_rd             ;
    wire   [8    :0] ram152_wadr           ;
    wire             ram152_wen            ;
    wire   [127  :0] ram152_wd             ;
    wire   [8    :0] ram156_radr           ;
    wire             ram156_ren            ;
    wire   [127  :0] ram156_rd             ;
    wire   [8    :0] ram156_wadr           ;
    wire             ram156_wen            ;
    wire   [127  :0] ram156_wd             ;
    wire   [8    :0] ram160_radr           ;
    wire             ram160_ren            ;
    wire   [127  :0] ram160_rd             ;
    wire   [8    :0] ram160_wadr           ;
    wire             ram160_wen            ;
    wire   [127  :0] ram160_wd             ;
    wire   [7    :0] ram164_radr           ;
    wire             ram164_ren            ;
    wire   [127  :0] ram164_rd             ;
    wire   [7    :0] ram164_wadr           ;
    wire             ram164_wen            ;
    wire   [127  :0] ram164_wd             ;
    wire   [6    :0] ram168_radr           ;
    wire             ram168_ren            ;
    wire   [127  :0] ram168_rd             ;
    wire   [6    :0] ram168_wadr           ;
    wire             ram168_wen            ;
    wire   [127  :0] ram168_wd             ;
    wire   [5    :0] ram172_radr           ;
    wire             ram172_ren            ;
    wire   [127  :0] ram172_rd             ;
    wire   [5    :0] ram172_wadr           ;
    wire             ram172_wen            ;
    wire   [127  :0] ram172_wd             ;
    wire   [5    :0] ram176_radr           ;
    wire             ram176_ren            ;
    wire   [127  :0] ram176_rd             ;
    wire   [5    :0] ram176_wadr           ;
    wire             ram176_wen            ;
    wire   [127  :0] ram176_wd             ;
    wire   [10   :0] ram180_radr           ;
    wire             ram180_ren            ;
    wire   [127  :0] ram180_rd             ;
    wire   [10   :0] ram180_wadr           ;
    wire             ram180_wen            ;
    wire   [127  :0] ram180_wd             ;
    wire   [10   :0] ram184_radr           ;
    wire             ram184_ren            ;
    wire   [127  :0] ram184_rd             ;
    wire   [10   :0] ram184_wadr           ;
    wire             ram184_wen            ;
    wire   [127  :0] ram184_wd             ;
    wire   [10   :0] ram188_radr           ;
    wire             ram188_ren            ;
    wire   [127  :0] ram188_rd             ;
    wire   [10   :0] ram188_wadr           ;
    wire             ram188_wen            ;
    wire   [127  :0] ram188_wd             ;
    wire   [8    :0] ram192_radr           ;
    wire             ram192_ren            ;
    wire   [127  :0] ram192_rd             ;
    wire   [8    :0] ram192_wadr           ;
    wire             ram192_wen            ;
    wire   [127  :0] ram192_wd             ;
    wire   [8    :0] ram196_radr           ;
    wire             ram196_ren            ;
    wire   [127  :0] ram196_rd             ;
    wire   [8    :0] ram196_wadr           ;
    wire             ram196_wen            ;
    wire   [127  :0] ram196_wd             ;
    wire   [8    :0] ram200_radr           ;
    wire             ram200_ren            ;
    wire   [127  :0] ram200_rd             ;
    wire   [8    :0] ram200_wadr           ;
    wire             ram200_wen            ;
    wire   [127  :0] ram200_wd             ;
    wire   [7    :0] ram204_radr           ;
    wire             ram204_ren            ;
    wire   [127  :0] ram204_rd             ;
    wire   [7    :0] ram204_wadr           ;
    wire             ram204_wen            ;
    wire   [127  :0] ram204_wd             ;
    wire   [6    :0] ram208_radr           ;
    wire             ram208_ren            ;
    wire   [127  :0] ram208_rd             ;
    wire   [6    :0] ram208_wadr           ;
    wire             ram208_wen            ;
    wire   [127  :0] ram208_wd             ;
    wire   [5    :0] ram212_radr           ;
    wire             ram212_ren            ;
    wire   [127  :0] ram212_rd             ;
    wire   [5    :0] ram212_wadr           ;
    wire             ram212_wen            ;
    wire   [127  :0] ram212_wd             ;
    wire   [5    :0] ram216_radr           ;
    wire             ram216_ren            ;
    wire   [127  :0] ram216_rd             ;
    wire   [5    :0] ram216_wadr           ;
    wire             ram216_wen            ;
    wire   [127  :0] ram216_wd             ;

    wire   [9    :0] ram500_radr           ;
    wire             ram500_ren            ;
    wire   [83   :0] ram500_rd             ;
    wire   [9    :0] ram500_wadr           ;
    wire             ram500_wen            ;
    wire   [83   :0] ram500_wd             ;
    wire   [8    :0] ram501_radr           ;
    wire             ram501_ren            ;
    wire   [95   :0] ram501_rd             ;
    wire   [8    :0] ram501_wadr           ;
    wire             ram501_wen            ;
    wire   [95   :0] ram501_wd             ;
    wire   [8    :0] ram502_radr           ;
    wire             ram502_ren            ;
    wire   [95   :0] ram502_rd             ;
    wire   [8    :0] ram502_wadr           ;
    wire             ram502_wen            ;
    wire   [95   :0] ram502_wd             ;
    wire   [8    :0] ram503_radr           ;
    wire             ram503_ren            ;
    wire   [95   :0] ram503_rd             ;
    wire   [8    :0] ram503_wadr           ;
    wire             ram503_wen            ;
    wire   [95   :0] ram503_wd             ;
    wire   [8    :0] ram504_radr           ;
    wire             ram504_ren            ;
    wire   [99   :0] ram504_rd             ;
    wire   [8    :0] ram504_wadr           ;
    wire             ram504_wen            ;
    wire   [99   :0] ram504_wd             ;
    wire   [9    :0] ram510_radr           ;
    wire             ram510_ren            ;
    wire   [87   :0] ram510_rd             ;
    wire   [9    :0] ram510_wadr           ;
    wire             ram510_wen            ;
    wire   [87   :0] ram510_wd             ;
    wire   [8    :0] ram511_radr           ;
    wire             ram511_ren            ;
    wire   [99   :0] ram511_rd             ;
    wire   [8    :0] ram511_wadr           ;
    wire             ram511_wen            ;
    wire   [99   :0] ram511_wd             ;
    wire   [8    :0] ram512_radr           ;
    wire             ram512_ren            ;
    wire   [99   :0] ram512_rd             ;
    wire   [8    :0] ram512_wadr           ;
    wire             ram512_wen            ;
    wire   [99   :0] ram512_wd             ;
    wire   [8    :0] ram513_radr           ;
    wire             ram513_ren            ;
    wire   [99   :0] ram513_rd             ;
    wire   [8    :0] ram513_wadr           ;
    wire             ram513_wen            ;
    wire   [99   :0] ram513_wd             ;
    wire   [8    :0] ram514_radr           ;
    wire             ram514_ren            ;
    wire   [103  :0] ram514_rd             ;
    wire   [8    :0] ram514_wadr           ;
    wire             ram514_wen            ;
    wire   [103  :0] ram514_wd             ;
    wire   [9    :0] ram520_radr           ;
    wire             ram520_ren            ;
    wire   [87   :0] ram520_rd             ;
    wire   [9    :0] ram520_wadr           ;
    wire             ram520_wen            ;
    wire   [87   :0] ram520_wd             ;
    wire   [8    :0] ram521_radr           ;
    wire             ram521_ren            ;
    wire   [99   :0] ram521_rd             ;
    wire   [8    :0] ram521_wadr           ;
    wire             ram521_wen            ;
    wire   [99   :0] ram521_wd             ;
    wire   [8    :0] ram522_radr           ;
    wire             ram522_ren            ;
    wire   [99   :0] ram522_rd             ;
    wire   [8    :0] ram522_wadr           ;
    wire             ram522_wen            ;
    wire   [99   :0] ram522_wd             ;
    wire   [8    :0] ram523_radr           ;
    wire             ram523_ren            ;
    wire   [99   :0] ram523_rd             ;
    wire   [8    :0] ram523_wadr           ;
    wire             ram523_wen            ;
    wire   [99   :0] ram523_wd             ;
    wire   [8    :0] ram524_radr           ;
    wire             ram524_ren            ;
    wire   [103  :0] ram524_rd             ;
    wire   [8    :0] ram524_wadr           ;
    wire             ram524_wen            ;
    wire   [103  :0] ram524_wd             ;

    wire   [6    :0] ram600_adr            ;
    wire             ram600_ren            ;
    wire             ram600_wen            ;
    wire   [127  :0] ram600_wdata          ;
    wire   [127  :0] ram600_rdata          ;
    wire   [6    :0] ram601_adr            ;
    wire             ram601_ren            ;
    wire             ram601_wen            ;
    wire   [127  :0] ram601_wdata          ;
    wire   [127  :0] ram601_rdata          ;
    wire   [6    :0] ram602_adr            ;
    wire             ram602_ren            ;
    wire             ram602_wen            ;
    wire   [127  :0] ram602_wdata          ;
    wire   [127  :0] ram602_rdata          ;
    wire   [6    :0] ram603_adr            ;
    wire             ram603_ren            ;
    wire             ram603_wen            ;
    wire   [127  :0] ram603_wdata          ;
    wire   [127  :0] ram603_rdata          ;

    wire   [8    :0] ram610_adr            ;
    wire             ram610_ren            ;
    wire             ram610_wen            ;
    wire   [127  :0] ram610_wdata          ;
    wire   [127  :0] ram610_rdata          ;
    wire   [8    :0] ram611_adr            ;
    wire             ram611_ren            ;
    wire             ram611_wen            ;
    wire   [127  :0] ram611_wdata          ;
    wire   [127  :0] ram611_rdata          ;
    wire   [8    :0] ram612_adr            ;
    wire             ram612_ren            ;
    wire             ram612_wen            ;
    wire   [127  :0] ram612_wdata          ;
    wire   [127  :0] ram612_rdata          ;
    wire   [8    :0] ram613_adr            ;
    wire             ram613_ren            ;
    wire             ram613_wen            ;
    wire   [127  :0] ram613_wdata          ;
    wire   [127  :0] ram613_rdata          ;

    //---------------------------------------------------------------------
    // JPEG XS Encoder Core
    //---------------------------------------------------------------------
TMC_JXSE_CORE TMC_JXSE_CORE(
        .CCLK                    (CCLK                    ),
        .VCLK                    (VCLK                    ),
        .HCLK                    (HCLK                    ),
        .RSTN                    (RSTN                    ),
        .JXSE_INT                (JXSE_INT                ),
                                  
        .SHSEL                   (SHSEL                   ),
        .SHREADYIN               (SHREADYIN               ),
        .SHADDR                  (SHADDR                  ),
        .SHWDATA                 (SHWDATA                 ),
        .SHWRITE                 (SHWRITE                 ),
        .SHTRANS                 (SHTRANS                 ),
        .SHREADYOUT              (SHREADYOUT              ),
        .SHRDATA                 (SHRDATA                 ),
                                  
        .S_AXIS_VIDEO_DATA       (S_AXIS_VIDEO_DATA       ),
        .S_AXIS_VIDEO_VALID      (S_AXIS_VIDEO_VALID      ),
        .S_AXIS_VIDEO_READY      (S_AXIS_VIDEO_READY      ),
                                  
        .M_AXIS_STRM_DATA        (M_AXIS_STRM_DATA        ),
        .M_AXIS_STRM_VALID       (M_AXIS_STRM_VALID       ),
        .M_AXIS_STRM_READY       (M_AXIS_STRM_READY       ),

        .ram000_radr             (ram000_radr             ),
        .ram000_ren              (ram000_ren              ),
        .ram000_rd               (ram000_rd               ),
        .ram000_wadr             (ram000_wadr             ),
        .ram000_wen              (ram000_wen              ),
        .ram000_wd               (ram000_wd               ),
        .ram001_radr             (ram001_radr             ),
        .ram001_ren              (ram001_ren              ),
        .ram001_rd               (ram001_rd               ),
        .ram001_wadr             (ram001_wadr             ),
        .ram001_wen              (ram001_wen              ),
        .ram001_wd               (ram001_wd               ),
        .ram002_radr             (ram002_radr             ),
        .ram002_ren              (ram002_ren              ),
        .ram002_rd               (ram002_rd               ),
        .ram002_wadr             (ram002_wadr             ),
        .ram002_wen              (ram002_wen              ),
        .ram002_wd               (ram002_wd               ),
        .ram003_radr             (ram003_radr             ),
        .ram003_ren              (ram003_ren              ),
        .ram003_rd               (ram003_rd               ),
        .ram003_wadr             (ram003_wadr             ),
        .ram003_wen              (ram003_wen              ),
        .ram003_wd               (ram003_wd               ),
        .ram004_radr             (ram004_radr             ),
        .ram004_ren              (ram004_ren              ),
        .ram004_rd               (ram004_rd               ),
        .ram004_wadr             (ram004_wadr             ),
        .ram004_wen              (ram004_wen              ),
        .ram004_wd               (ram004_wd               ),
        .ram005_radr             (ram005_radr             ),
        .ram005_ren              (ram005_ren              ),
        .ram005_rd               (ram005_rd               ),
        .ram005_wadr             (ram005_wadr             ),
        .ram005_wen              (ram005_wen              ),
        .ram005_wd               (ram005_wd               ),
        .ram006_radr             (ram006_radr             ),
        .ram006_ren              (ram006_ren              ),
        .ram006_rd               (ram006_rd               ),
        .ram006_wadr             (ram006_wadr             ),
        .ram006_wen              (ram006_wen              ),
        .ram006_wd               (ram006_wd               ),
        .ram007_radr             (ram007_radr             ),
        .ram007_ren              (ram007_ren              ),
        .ram007_rd               (ram007_rd               ),
        .ram007_wadr             (ram007_wadr             ),
        .ram007_wen              (ram007_wen              ),
        .ram007_wd               (ram007_wd               ),
        .ram010_radr             (ram010_radr             ),
        .ram010_ren              (ram010_ren              ),
        .ram010_rd               (ram010_rd               ),
        .ram010_wadr             (ram010_wadr             ),
        .ram010_wen              (ram010_wen              ),
        .ram010_wd               (ram010_wd               ),
        .ram011_radr             (ram011_radr             ),
        .ram011_ren              (ram011_ren              ),
        .ram011_rd               (ram011_rd               ),
        .ram011_wadr             (ram011_wadr             ),
        .ram011_wen              (ram011_wen              ),
        .ram011_wd               (ram011_wd               ),
        .ram012_radr             (ram012_radr             ),
        .ram012_ren              (ram012_ren              ),
        .ram012_rd               (ram012_rd               ),
        .ram012_wadr             (ram012_wadr             ),
        .ram012_wen              (ram012_wen              ),
        .ram012_wd               (ram012_wd               ),
        .ram013_radr             (ram013_radr             ),
        .ram013_ren              (ram013_ren              ),
        .ram013_rd               (ram013_rd               ),
        .ram013_wadr             (ram013_wadr             ),
        .ram013_wen              (ram013_wen              ),
        .ram013_wd               (ram013_wd               ),
        .ram014_radr             (ram014_radr             ),
        .ram014_ren              (ram014_ren              ),
        .ram014_rd               (ram014_rd               ),
        .ram014_wadr             (ram014_wadr             ),
        .ram014_wen              (ram014_wen              ),
        .ram014_wd               (ram014_wd               ),
        .ram015_radr             (ram015_radr             ),
        .ram015_ren              (ram015_ren              ),
        .ram015_rd               (ram015_rd               ),
        .ram015_wadr             (ram015_wadr             ),
        .ram015_wen              (ram015_wen              ),
        .ram015_wd               (ram015_wd               ),
        .ram016_radr             (ram016_radr             ),
        .ram016_ren              (ram016_ren              ),
        .ram016_rd               (ram016_rd               ),
        .ram016_wadr             (ram016_wadr             ),
        .ram016_wen              (ram016_wen              ),
        .ram016_wd               (ram016_wd               ),
        .ram017_radr             (ram017_radr             ),
        .ram017_ren              (ram017_ren              ),
        .ram017_rd               (ram017_rd               ),
        .ram017_wadr             (ram017_wadr             ),
        .ram017_wen              (ram017_wen              ),
        .ram017_wd               (ram017_wd               ),
        .ram020_radr             (ram020_radr             ),
        .ram020_ren              (ram020_ren              ),
        .ram020_rd               (ram020_rd               ),
        .ram020_wadr             (ram020_wadr             ),
        .ram020_wen              (ram020_wen              ),
        .ram020_wd               (ram020_wd               ),
        .ram021_radr             (ram021_radr             ),
        .ram021_ren              (ram021_ren              ),
        .ram021_rd               (ram021_rd               ),
        .ram021_wadr             (ram021_wadr             ),
        .ram021_wen              (ram021_wen              ),
        .ram021_wd               (ram021_wd               ),
        .ram022_radr             (ram022_radr             ),
        .ram022_ren              (ram022_ren              ),
        .ram022_rd               (ram022_rd               ),
        .ram022_wadr             (ram022_wadr             ),
        .ram022_wen              (ram022_wen              ),
        .ram022_wd               (ram022_wd               ),
        .ram023_radr             (ram023_radr             ),
        .ram023_ren              (ram023_ren              ),
        .ram023_rd               (ram023_rd               ),
        .ram023_wadr             (ram023_wadr             ),
        .ram023_wen              (ram023_wen              ),
        .ram023_wd               (ram023_wd               ),
        .ram024_radr             (ram024_radr             ),
        .ram024_ren              (ram024_ren              ),
        .ram024_rd               (ram024_rd               ),
        .ram024_wadr             (ram024_wadr             ),
        .ram024_wen              (ram024_wen              ),
        .ram024_wd               (ram024_wd               ),
        .ram025_radr             (ram025_radr             ),
        .ram025_ren              (ram025_ren              ),
        .ram025_rd               (ram025_rd               ),
        .ram025_wadr             (ram025_wadr             ),
        .ram025_wen              (ram025_wen              ),
        .ram025_wd               (ram025_wd               ),
        .ram026_radr             (ram026_radr             ),
        .ram026_ren              (ram026_ren              ),
        .ram026_rd               (ram026_rd               ),
        .ram026_wadr             (ram026_wadr             ),
        .ram026_wen              (ram026_wen              ),
        .ram026_wd               (ram026_wd               ),
        .ram027_radr             (ram027_radr             ),
        .ram027_ren              (ram027_ren              ),
        .ram027_rd               (ram027_rd               ),
        .ram027_wadr             (ram027_wadr             ),
        .ram027_wen              (ram027_wen              ),
        .ram027_wd               (ram027_wd               ),
        .ram100_radr             (ram100_radr             ),
        .ram100_ren              (ram100_ren              ),
        .ram100_rd               (ram100_rd               ),
        .ram100_wadr             (ram100_wadr             ),
        .ram100_wen              (ram100_wen              ),
        .ram100_wd               (ram100_wd               ),
        .ram104_radr             (ram104_radr             ),
        .ram104_ren              (ram104_ren              ),
        .ram104_rd               (ram104_rd               ),
        .ram104_wadr             (ram104_wadr             ),
        .ram104_wen              (ram104_wen              ),
        .ram104_wd               (ram104_wd               ),
        .ram108_radr             (ram108_radr             ),
        .ram108_ren              (ram108_ren              ),
        .ram108_rd               (ram108_rd               ),
        .ram108_wadr             (ram108_wadr             ),
        .ram108_wen              (ram108_wen              ),
        .ram108_wd               (ram108_wd               ),
        .ram112_radr             (ram112_radr             ),
        .ram112_ren              (ram112_ren              ),
        .ram112_rd               (ram112_rd               ),
        .ram112_wadr             (ram112_wadr             ),
        .ram112_wen              (ram112_wen              ),
        .ram112_wd               (ram112_wd               ),
        .ram116_radr             (ram116_radr             ),
        .ram116_ren              (ram116_ren              ),
        .ram116_rd               (ram116_rd               ),
        .ram116_wadr             (ram116_wadr             ),
        .ram116_wen              (ram116_wen              ),
        .ram116_wd               (ram116_wd               ),
        .ram120_radr             (ram120_radr             ),
        .ram120_ren              (ram120_ren              ),
        .ram120_rd               (ram120_rd               ),
        .ram120_wadr             (ram120_wadr             ),
        .ram120_wen              (ram120_wen              ),
        .ram120_wd               (ram120_wd               ),
        .ram124_radr             (ram124_radr             ),
        .ram124_ren              (ram124_ren              ),
        .ram124_rd               (ram124_rd               ),
        .ram124_wadr             (ram124_wadr             ),
        .ram124_wen              (ram124_wen              ),
        .ram124_wd               (ram124_wd               ),
        .ram128_radr             (ram128_radr             ),
        .ram128_ren              (ram128_ren              ),
        .ram128_rd               (ram128_rd               ),
        .ram128_wadr             (ram128_wadr             ),
        .ram128_wen              (ram128_wen              ),
        .ram128_wd               (ram128_wd               ),
        .ram132_radr             (ram132_radr             ),
        .ram132_ren              (ram132_ren              ),
        .ram132_rd               (ram132_rd               ),
        .ram132_wadr             (ram132_wadr             ),
        .ram132_wen              (ram132_wen              ),
        .ram132_wd               (ram132_wd               ),
        .ram136_radr             (ram136_radr             ),
        .ram136_ren              (ram136_ren              ),
        .ram136_rd               (ram136_rd               ),
        .ram136_wadr             (ram136_wadr             ),
        .ram136_wen              (ram136_wen              ),
        .ram136_wd               (ram136_wd               ),
        .ram140_radr             (ram140_radr             ),
        .ram140_ren              (ram140_ren              ),
        .ram140_rd               (ram140_rd               ),
        .ram140_wadr             (ram140_wadr             ),
        .ram140_wen              (ram140_wen              ),
        .ram140_wd               (ram140_wd               ),
        .ram144_radr             (ram144_radr             ),
        .ram144_ren              (ram144_ren              ),
        .ram144_rd               (ram144_rd               ),
        .ram144_wadr             (ram144_wadr             ),
        .ram144_wen              (ram144_wen              ),
        .ram144_wd               (ram144_wd               ),
        .ram148_radr             (ram148_radr             ),
        .ram148_ren              (ram148_ren              ),
        .ram148_rd               (ram148_rd               ),
        .ram148_wadr             (ram148_wadr             ),
        .ram148_wen              (ram148_wen              ),
        .ram148_wd               (ram148_wd               ),
        .ram152_radr             (ram152_radr             ),
        .ram152_ren              (ram152_ren              ),
        .ram152_rd               (ram152_rd               ),
        .ram152_wadr             (ram152_wadr             ),
        .ram152_wen              (ram152_wen              ),
        .ram152_wd               (ram152_wd               ),
        .ram156_radr             (ram156_radr             ),
        .ram156_ren              (ram156_ren              ),
        .ram156_rd               (ram156_rd               ),
        .ram156_wadr             (ram156_wadr             ),
        .ram156_wen              (ram156_wen              ),
        .ram156_wd               (ram156_wd               ),
        .ram160_radr             (ram160_radr             ),
        .ram160_ren              (ram160_ren              ),
        .ram160_rd               (ram160_rd               ),
        .ram160_wadr             (ram160_wadr             ),
        .ram160_wen              (ram160_wen              ),
        .ram160_wd               (ram160_wd               ),
        .ram164_radr             (ram164_radr             ),
        .ram164_ren              (ram164_ren              ),
        .ram164_rd               (ram164_rd               ),
        .ram164_wadr             (ram164_wadr             ),
        .ram164_wen              (ram164_wen              ),
        .ram164_wd               (ram164_wd               ),
        .ram168_radr             (ram168_radr             ),
        .ram168_ren              (ram168_ren              ),
        .ram168_rd               (ram168_rd               ),
        .ram168_wadr             (ram168_wadr             ),
        .ram168_wen              (ram168_wen              ),
        .ram168_wd               (ram168_wd               ),
        .ram172_radr             (ram172_radr             ),
        .ram172_ren              (ram172_ren              ),
        .ram172_rd               (ram172_rd               ),
        .ram172_wadr             (ram172_wadr             ),
        .ram172_wen              (ram172_wen              ),
        .ram172_wd               (ram172_wd               ),
        .ram176_radr             (ram176_radr             ),
        .ram176_ren              (ram176_ren              ),
        .ram176_rd               (ram176_rd               ),
        .ram176_wadr             (ram176_wadr             ),
        .ram176_wen              (ram176_wen              ),
        .ram176_wd               (ram176_wd               ),
        .ram180_radr             (ram180_radr             ),
        .ram180_ren              (ram180_ren              ),
        .ram180_rd               (ram180_rd               ),
        .ram180_wadr             (ram180_wadr             ),
        .ram180_wen              (ram180_wen              ),
        .ram180_wd               (ram180_wd               ),
        .ram184_radr             (ram184_radr             ),
        .ram184_ren              (ram184_ren              ),
        .ram184_rd               (ram184_rd               ),
        .ram184_wadr             (ram184_wadr             ),
        .ram184_wen              (ram184_wen              ),
        .ram184_wd               (ram184_wd               ),
        .ram188_radr             (ram188_radr             ),
        .ram188_ren              (ram188_ren              ),
        .ram188_rd               (ram188_rd               ),
        .ram188_wadr             (ram188_wadr             ),
        .ram188_wen              (ram188_wen              ),
        .ram188_wd               (ram188_wd               ),
        .ram192_radr             (ram192_radr             ),
        .ram192_ren              (ram192_ren              ),
        .ram192_rd               (ram192_rd               ),
        .ram192_wadr             (ram192_wadr             ),
        .ram192_wen              (ram192_wen              ),
        .ram192_wd               (ram192_wd               ),
        .ram196_radr             (ram196_radr             ),
        .ram196_ren              (ram196_ren              ),
        .ram196_rd               (ram196_rd               ),
        .ram196_wadr             (ram196_wadr             ),
        .ram196_wen              (ram196_wen              ),
        .ram196_wd               (ram196_wd               ),
        .ram200_radr             (ram200_radr             ),
        .ram200_ren              (ram200_ren              ),
        .ram200_rd               (ram200_rd               ),
        .ram200_wadr             (ram200_wadr             ),
        .ram200_wen              (ram200_wen              ),
        .ram200_wd               (ram200_wd               ),
        .ram204_radr             (ram204_radr             ),
        .ram204_ren              (ram204_ren              ),
        .ram204_rd               (ram204_rd               ),
        .ram204_wadr             (ram204_wadr             ),
        .ram204_wen              (ram204_wen              ),
        .ram204_wd               (ram204_wd               ),
        .ram208_radr             (ram208_radr             ),
        .ram208_ren              (ram208_ren              ),
        .ram208_rd               (ram208_rd               ),
        .ram208_wadr             (ram208_wadr             ),
        .ram208_wen              (ram208_wen              ),
        .ram208_wd               (ram208_wd               ),
        .ram212_radr             (ram212_radr             ),
        .ram212_ren              (ram212_ren              ),
        .ram212_rd               (ram212_rd               ),
        .ram212_wadr             (ram212_wadr             ),
        .ram212_wen              (ram212_wen              ),
        .ram212_wd               (ram212_wd               ),
        .ram216_radr             (ram216_radr             ),
        .ram216_ren              (ram216_ren              ),
        .ram216_rd               (ram216_rd               ),
        .ram216_wadr             (ram216_wadr             ),
        .ram216_wen              (ram216_wen              ),
        .ram216_wd               (ram216_wd               ),
        .ram500_radr             (ram500_radr             ),
        .ram500_ren              (ram500_ren              ),
        .ram500_rd               (ram500_rd               ),
        .ram500_wadr             (ram500_wadr             ),
        .ram500_wen              (ram500_wen              ),
        .ram500_wd               (ram500_wd               ),
        .ram501_radr             (ram501_radr             ),
        .ram501_ren              (ram501_ren              ),
        .ram501_rd               (ram501_rd               ),
        .ram501_wadr             (ram501_wadr             ),
        .ram501_wen              (ram501_wen              ),
        .ram501_wd               (ram501_wd               ),
        .ram502_radr             (ram502_radr             ),
        .ram502_ren              (ram502_ren              ),
        .ram502_rd               (ram502_rd               ),
        .ram502_wadr             (ram502_wadr             ),
        .ram502_wen              (ram502_wen              ),
        .ram502_wd               (ram502_wd               ),
        .ram503_radr             (ram503_radr             ),
        .ram503_ren              (ram503_ren              ),
        .ram503_rd               (ram503_rd               ),
        .ram503_wadr             (ram503_wadr             ),
        .ram503_wen              (ram503_wen              ),
        .ram503_wd               (ram503_wd               ),
        .ram504_radr             (ram504_radr             ),
        .ram504_ren              (ram504_ren              ),
        .ram504_rd               (ram504_rd               ),
        .ram504_wadr             (ram504_wadr             ),
        .ram504_wen              (ram504_wen              ),
        .ram504_wd               (ram504_wd               ),
        .ram510_radr             (ram510_radr             ),
        .ram510_ren              (ram510_ren              ),
        .ram510_rd               (ram510_rd               ),
        .ram510_wadr             (ram510_wadr             ),
        .ram510_wen              (ram510_wen              ),
        .ram510_wd               (ram510_wd               ),
        .ram511_radr             (ram511_radr             ),
        .ram511_ren              (ram511_ren              ),
        .ram511_rd               (ram511_rd               ),
        .ram511_wadr             (ram511_wadr             ),
        .ram511_wen              (ram511_wen              ),
        .ram511_wd               (ram511_wd               ),
        .ram512_radr             (ram512_radr             ),
        .ram512_ren              (ram512_ren              ),
        .ram512_rd               (ram512_rd               ),
        .ram512_wadr             (ram512_wadr             ),
        .ram512_wen              (ram512_wen              ),
        .ram512_wd               (ram512_wd               ),
        .ram513_radr             (ram513_radr             ),
        .ram513_ren              (ram513_ren              ),
        .ram513_rd               (ram513_rd               ),
        .ram513_wadr             (ram513_wadr             ),
        .ram513_wen              (ram513_wen              ),
        .ram513_wd               (ram513_wd               ),
        .ram514_radr             (ram514_radr             ),
        .ram514_ren              (ram514_ren              ),
        .ram514_rd               (ram514_rd               ),
        .ram514_wadr             (ram514_wadr             ),
        .ram514_wen              (ram514_wen              ),
        .ram514_wd               (ram514_wd               ),
        .ram520_radr             (ram520_radr             ),
        .ram520_ren              (ram520_ren              ),
        .ram520_rd               (ram520_rd               ),
        .ram520_wadr             (ram520_wadr             ),
        .ram520_wen              (ram520_wen              ),
        .ram520_wd               (ram520_wd               ),
        .ram521_radr             (ram521_radr             ),
        .ram521_ren              (ram521_ren              ),
        .ram521_rd               (ram521_rd               ),
        .ram521_wadr             (ram521_wadr             ),
        .ram521_wen              (ram521_wen              ),
        .ram521_wd               (ram521_wd               ),
        .ram522_radr             (ram522_radr             ),
        .ram522_ren              (ram522_ren              ),
        .ram522_rd               (ram522_rd               ),
        .ram522_wadr             (ram522_wadr             ),
        .ram522_wen              (ram522_wen              ),
        .ram522_wd               (ram522_wd               ),
        .ram523_radr             (ram523_radr             ),
        .ram523_ren              (ram523_ren              ),
        .ram523_rd               (ram523_rd               ),
        .ram523_wadr             (ram523_wadr             ),
        .ram523_wen              (ram523_wen              ),
        .ram523_wd               (ram523_wd               ),
        .ram524_radr             (ram524_radr             ),
        .ram524_ren              (ram524_ren              ),
        .ram524_rd               (ram524_rd               ),
        .ram524_wadr             (ram524_wadr             ),
        .ram524_wen              (ram524_wen              ),
        .ram524_wd               (ram524_wd               ),

        .ram600_adr              (ram600_adr              ),
        .ram600_ren              (ram600_ren              ),
        .ram600_wen              (ram600_wen              ),
        .ram600_wdata            (ram600_wdata            ),
        .ram600_rdata            (ram600_rdata            ),
        .ram601_adr              (ram601_adr              ),
        .ram601_ren              (ram601_ren              ),
        .ram601_wen              (ram601_wen              ),
        .ram601_wdata            (ram601_wdata            ),
        .ram601_rdata            (ram601_rdata            ),
        .ram602_adr              (ram602_adr              ),
        .ram602_ren              (ram602_ren              ),
        .ram602_wen              (ram602_wen              ),
        .ram602_wdata            (ram602_wdata            ),
        .ram602_rdata            (ram602_rdata            ),
        .ram603_adr              (ram603_adr              ),
        .ram603_ren              (ram603_ren              ),
        .ram603_wen              (ram603_wen              ),
        .ram603_wdata            (ram603_wdata            ),
        .ram603_rdata            (ram603_rdata            ),
                                  
        .ram610_adr              (ram610_adr              ),
        .ram610_ren              (ram610_ren              ),
        .ram610_wen              (ram610_wen              ),
        .ram610_wdata            (ram610_wdata            ),
        .ram610_rdata            (ram610_rdata            ),
        .ram611_adr              (ram611_adr              ),
        .ram611_ren              (ram611_ren              ),
        .ram611_wen              (ram611_wen              ),
        .ram611_wdata            (ram611_wdata            ),
        .ram611_rdata            (ram611_rdata            ),
        .ram612_adr              (ram612_adr              ),
        .ram612_ren              (ram612_ren              ),
        .ram612_wen              (ram612_wen              ),
        .ram612_wdata            (ram612_wdata            ),
        .ram612_rdata            (ram612_rdata            ),
        .ram613_adr              (ram613_adr              ),
        .ram613_ren              (ram613_ren              ),
        .ram613_wen              (ram613_wen              ),
        .ram613_wdata            (ram613_wdata            ),
        .ram613_rdata            (ram613_rdata            )

);
    
    //---------------------------------------------------------------------
    // SRAM
    //---------------------------------------------------------------------


    TMC_RAM1R1W1C1024WX80B RAM000(
         .clk                 (  CCLK                )
        ,.adra                (  ram000_wadr         )
        ,.wea_b               (  ram000_wen          )
        ,.dina                (  ram000_wd           )
        ,.adrb                (  ram000_radr         )
        ,.oeb_b               (  ram000_ren          )
        ,.doutb               (  ram000_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM001(
         .clk                 (  CCLK                )
        ,.adra                (  ram001_wadr         )
        ,.wea_b               (  ram001_wen          )
        ,.dina                (  ram001_wd           )
        ,.adrb                (  ram001_radr         )
        ,.oeb_b               (  ram001_ren          )
        ,.doutb               (  ram001_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM002(
         .clk                 (  CCLK                )
        ,.adra                (  ram002_wadr         )
        ,.wea_b               (  ram002_wen          )
        ,.dina                (  ram002_wd           )
        ,.adrb                (  ram002_radr         )
        ,.oeb_b               (  ram002_ren          )
        ,.doutb               (  ram002_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM003(
         .clk                 (  CCLK                )
        ,.adra                (  ram003_wadr         )
        ,.wea_b               (  ram003_wen          )
        ,.dina                (  ram003_wd           )
        ,.adrb                (  ram003_radr         )
        ,.oeb_b               (  ram003_ren          )
        ,.doutb               (  ram003_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM004(
         .clk                 (  CCLK                )
        ,.adra                (  ram004_wadr         )
        ,.wea_b               (  ram004_wen          )
        ,.dina                (  ram004_wd           )
        ,.adrb                (  ram004_radr         )
        ,.oeb_b               (  ram004_ren          )
        ,.doutb               (  ram004_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM005(
         .clk                 (  CCLK                )
        ,.adra                (  ram005_wadr         )
        ,.wea_b               (  ram005_wen          )
        ,.dina                (  ram005_wd           )
        ,.adrb                (  ram005_radr         )
        ,.oeb_b               (  ram005_ren          )
        ,.doutb               (  ram005_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM006(
         .clk                 (  CCLK                )
        ,.adra                (  ram006_wadr         )
        ,.wea_b               (  ram006_wen          )
        ,.dina                (  ram006_wd           )
        ,.adrb                (  ram006_radr         )
        ,.oeb_b               (  ram006_ren          )
        ,.doutb               (  ram006_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM007(
         .clk                 (  CCLK                )
        ,.adra                (  ram007_wadr         )
        ,.wea_b               (  ram007_wen          )
        ,.dina                (  ram007_wd           )
        ,.adrb                (  ram007_radr         )
        ,.oeb_b               (  ram007_ren          )
        ,.doutb               (  ram007_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM010(
         .clk                 (  CCLK                )
        ,.adra                (  ram010_wadr         )
        ,.wea_b               (  ram010_wen          )
        ,.dina                (  ram010_wd           )
        ,.adrb                (  ram010_radr         )
        ,.oeb_b               (  ram010_ren          )
        ,.doutb               (  ram010_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM011(
         .clk                 (  CCLK                )
        ,.adra                (  ram011_wadr         )
        ,.wea_b               (  ram011_wen          )
        ,.dina                (  ram011_wd           )
        ,.adrb                (  ram011_radr         )
        ,.oeb_b               (  ram011_ren          )
        ,.doutb               (  ram011_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM012(
         .clk                 (  CCLK                )
        ,.adra                (  ram012_wadr         )
        ,.wea_b               (  ram012_wen          )
        ,.dina                (  ram012_wd           )
        ,.adrb                (  ram012_radr         )
        ,.oeb_b               (  ram012_ren          )
        ,.doutb               (  ram012_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM013(
         .clk                 (  CCLK                )
        ,.adra                (  ram013_wadr         )
        ,.wea_b               (  ram013_wen          )
        ,.dina                (  ram013_wd           )
        ,.adrb                (  ram013_radr         )
        ,.oeb_b               (  ram013_ren          )
        ,.doutb               (  ram013_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM014(
         .clk                 (  CCLK                )
        ,.adra                (  ram014_wadr         )
        ,.wea_b               (  ram014_wen          )
        ,.dina                (  ram014_wd           )
        ,.adrb                (  ram014_radr         )
        ,.oeb_b               (  ram014_ren          )
        ,.doutb               (  ram014_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM015(
         .clk                 (  CCLK                )
        ,.adra                (  ram015_wadr         )
        ,.wea_b               (  ram015_wen          )
        ,.dina                (  ram015_wd           )
        ,.adrb                (  ram015_radr         )
        ,.oeb_b               (  ram015_ren          )
        ,.doutb               (  ram015_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM016(
         .clk                 (  CCLK                )
        ,.adra                (  ram016_wadr         )
        ,.wea_b               (  ram016_wen          )
        ,.dina                (  ram016_wd           )
        ,.adrb                (  ram016_radr         )
        ,.oeb_b               (  ram016_ren          )
        ,.doutb               (  ram016_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM017(
         .clk                 (  CCLK                )
        ,.adra                (  ram017_wadr         )
        ,.wea_b               (  ram017_wen          )
        ,.dina                (  ram017_wd           )
        ,.adrb                (  ram017_radr         )
        ,.oeb_b               (  ram017_ren          )
        ,.doutb               (  ram017_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM020(
         .clk                 (  CCLK                )
        ,.adra                (  ram020_wadr         )
        ,.wea_b               (  ram020_wen          )
        ,.dina                (  ram020_wd           )
        ,.adrb                (  ram020_radr         )
        ,.oeb_b               (  ram020_ren          )
        ,.doutb               (  ram020_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM021(
         .clk                 (  CCLK                )
        ,.adra                (  ram021_wadr         )
        ,.wea_b               (  ram021_wen          )
        ,.dina                (  ram021_wd           )
        ,.adrb                (  ram021_radr         )
        ,.oeb_b               (  ram021_ren          )
        ,.doutb               (  ram021_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM022(
         .clk                 (  CCLK                )
        ,.adra                (  ram022_wadr         )
        ,.wea_b               (  ram022_wen          )
        ,.dina                (  ram022_wd           )
        ,.adrb                (  ram022_radr         )
        ,.oeb_b               (  ram022_ren          )
        ,.doutb               (  ram022_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM023(
         .clk                 (  CCLK                )
        ,.adra                (  ram023_wadr         )
        ,.wea_b               (  ram023_wen          )
        ,.dina                (  ram023_wd           )
        ,.adrb                (  ram023_radr         )
        ,.oeb_b               (  ram023_ren          )
        ,.doutb               (  ram023_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM024(
         .clk                 (  CCLK                )
        ,.adra                (  ram024_wadr         )
        ,.wea_b               (  ram024_wen          )
        ,.dina                (  ram024_wd           )
        ,.adrb                (  ram024_radr         )
        ,.oeb_b               (  ram024_ren          )
        ,.doutb               (  ram024_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM025(
         .clk                 (  CCLK                )
        ,.adra                (  ram025_wadr         )
        ,.wea_b               (  ram025_wen          )
        ,.dina                (  ram025_wd           )
        ,.adrb                (  ram025_radr         )
        ,.oeb_b               (  ram025_ren          )
        ,.doutb               (  ram025_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM026(
         .clk                 (  CCLK                )
        ,.adra                (  ram026_wadr         )
        ,.wea_b               (  ram026_wen          )
        ,.dina                (  ram026_wd           )
        ,.adrb                (  ram026_radr         )
        ,.oeb_b               (  ram026_ren          )
        ,.doutb               (  ram026_rd           )
    );

    TMC_RAM1R1W1C1024WX80B RAM027(
         .clk                 (  CCLK                )
        ,.adra                (  ram027_wadr         )
        ,.wea_b               (  ram027_wen          )
        ,.dina                (  ram027_wd           )
        ,.adrb                (  ram027_radr         )
        ,.oeb_b               (  ram027_ren          )
        ,.doutb               (  ram027_rd           )
    );

    TMC_RAM1R1W1536WX128B RAM100(
         .clka                (  CCLK                )
        ,.adra                (  ram100_wadr         )
        ,.wea_b               (  ram100_wen          )
        ,.dina                (  ram100_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram100_radr         )
        ,.oeb_b               (  ram100_ren          )
        ,.doutb               (  ram100_rd           )
    );

    TMC_RAM1R1W1536WX128B RAM104(
         .clka                (  CCLK                )
        ,.adra                (  ram104_wadr         )
        ,.wea_b               (  ram104_wen          )
        ,.dina                (  ram104_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram104_radr         )
        ,.oeb_b               (  ram104_ren          )
        ,.doutb               (  ram104_rd           )
    );

    TMC_RAM1R1W1536WX128B RAM108(
         .clka                (  CCLK                )
        ,.adra                (  ram108_wadr         )
        ,.wea_b               (  ram108_wen          )
        ,.dina                (  ram108_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram108_radr         )
        ,.oeb_b               (  ram108_ren          )
        ,.doutb               (  ram108_rd           )
    );
    TMC_RAM1R1W384WX128B RAM112(
         .clka                (  CCLK                )
        ,.adra                (  ram112_wadr         )
        ,.wea_b               (  ram112_wen          )
        ,.dina                (  ram112_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram112_radr         )
        ,.oeb_b               (  ram112_ren          )
        ,.doutb               (  ram112_rd           )
    );

    TMC_RAM1R1W384WX128B RAM116(
         .clka                (  CCLK                )
        ,.adra                (  ram116_wadr         )
        ,.wea_b               (  ram116_wen          )
        ,.dina                (  ram116_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram116_radr         )
        ,.oeb_b               (  ram116_ren          )
        ,.doutb               (  ram116_rd           )
    );

    TMC_RAM1R1W384WX128B RAM120(
         .clka                (  CCLK                )
        ,.adra                (  ram120_wadr         )
        ,.wea_b               (  ram120_wen          )
        ,.dina                (  ram120_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram120_radr         )
        ,.oeb_b               (  ram120_ren          )
        ,.doutb               (  ram120_rd           )
    );

    TMC_RAM1R1W192WX128B RAM124(
         .clka                (  CCLK                )
        ,.adra                (  ram124_wadr         )
        ,.wea_b               (  ram124_wen          )
        ,.dina                (  ram124_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram124_radr         )
        ,.oeb_b               (  ram124_ren          )
        ,.doutb               (  ram124_rd           )
    );

    TMC_RAM1R1W96WX128B RAM128(
         .clka                (  CCLK                )
        ,.adra                (  ram128_wadr         )
        ,.wea_b               (  ram128_wen          )
        ,.dina                (  ram128_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram128_radr         )
        ,.oeb_b               (  ram128_ren          )
        ,.doutb               (  ram128_rd           )
    );

    TMC_RAM1R1W48WX128B RAM132(
         .clka                (  CCLK                )
        ,.adra                (  ram132_wadr         )
        ,.wea_b               (  ram132_wen          )
        ,.dina                (  ram132_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram132_radr         )
        ,.oeb_b               (  ram132_ren          )
        ,.doutb               (  ram132_rd           )
    );

    TMC_RAM1R1W48WX128B RAM136(
         .clka                (  CCLK                )
        ,.adra                (  ram136_wadr         )
        ,.wea_b               (  ram136_wen          )
        ,.dina                (  ram136_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram136_radr         )
        ,.oeb_b               (  ram136_ren          )
        ,.doutb               (  ram136_rd           )
    );

    TMC_RAM1R1W1536WX128B RAM140(
         .clka                (  CCLK                )
        ,.adra                (  ram140_wadr         )
        ,.wea_b               (  ram140_wen          )
        ,.dina                (  ram140_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram140_radr         )
        ,.oeb_b               (  ram140_ren          )
        ,.doutb               (  ram140_rd           )
    );

    TMC_RAM1R1W1536WX128B RAM144(
         .clka                (  CCLK                )
        ,.adra                (  ram144_wadr         )
        ,.wea_b               (  ram144_wen          )
        ,.dina                (  ram144_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram144_radr         )
        ,.oeb_b               (  ram144_ren          )
        ,.doutb               (  ram144_rd           )
    );

    TMC_RAM1R1W1536WX128B RAM148(
         .clka                (  CCLK                )
        ,.adra                (  ram148_wadr         )
        ,.wea_b               (  ram148_wen          )
        ,.dina                (  ram148_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram148_radr         )
        ,.oeb_b               (  ram148_ren          )
        ,.doutb               (  ram148_rd           )
    );

    TMC_RAM1R1W384WX128B RAM152(
         .clka                (  CCLK                )
        ,.adra                (  ram152_wadr         )
        ,.wea_b               (  ram152_wen          )
        ,.dina                (  ram152_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram152_radr         )
        ,.oeb_b               (  ram152_ren          )
        ,.doutb               (  ram152_rd           )
    );

    TMC_RAM1R1W384WX128B RAM156(
         .clka                (  CCLK                )
        ,.adra                (  ram156_wadr         )
        ,.wea_b               (  ram156_wen          )
        ,.dina                (  ram156_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram156_radr         )
        ,.oeb_b               (  ram156_ren          )
        ,.doutb               (  ram156_rd           )
    );

    TMC_RAM1R1W384WX128B RAM160(
         .clka                (  CCLK                )
        ,.adra                (  ram160_wadr         )
        ,.wea_b               (  ram160_wen          )
        ,.dina                (  ram160_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram160_radr         )
        ,.oeb_b               (  ram160_ren          )
        ,.doutb               (  ram160_rd           )
    );

    TMC_RAM1R1W192WX128B RAM164(
         .clka                (  CCLK                )
        ,.adra                (  ram164_wadr         )
        ,.wea_b               (  ram164_wen          )
        ,.dina                (  ram164_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram164_radr         )
        ,.oeb_b               (  ram164_ren          )
        ,.doutb               (  ram164_rd           )
    );

    TMC_RAM1R1W96WX128B RAM168(
         .clka                (  CCLK                )
        ,.adra                (  ram168_wadr         )
        ,.wea_b               (  ram168_wen          )
        ,.dina                (  ram168_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram168_radr         )
        ,.oeb_b               (  ram168_ren          )
        ,.doutb               (  ram168_rd           )
    );

    TMC_RAM1R1W48WX128B RAM172(
         .clka                (  CCLK                )
        ,.adra                (  ram172_wadr         )
        ,.wea_b               (  ram172_wen          )
        ,.dina                (  ram172_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram172_radr         )
        ,.oeb_b               (  ram172_ren          )
        ,.doutb               (  ram172_rd           )
    );

    TMC_RAM1R1W48WX128B RAM176(
         .clka                (  CCLK                )
        ,.adra                (  ram176_wadr         )
        ,.wea_b               (  ram176_wen          )
        ,.dina                (  ram176_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram176_radr         )
        ,.oeb_b               (  ram176_ren          )
        ,.doutb               (  ram176_rd           )
    );

    TMC_RAM1R1W1536WX128B RAM180(
         .clka                (  CCLK                )
        ,.adra                (  ram180_wadr         )
        ,.wea_b               (  ram180_wen          )
        ,.dina                (  ram180_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram180_radr         )
        ,.oeb_b               (  ram180_ren          )
        ,.doutb               (  ram180_rd           )
    );

    TMC_RAM1R1W1536WX128B RAM184(
         .clka                (  CCLK                )
        ,.adra                (  ram184_wadr         )
        ,.wea_b               (  ram184_wen          )
        ,.dina                (  ram184_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram184_radr         )
        ,.oeb_b               (  ram184_ren          )
        ,.doutb               (  ram184_rd           )
    );

    TMC_RAM1R1W1536WX128B RAM188(
         .clka                (  CCLK                )
        ,.adra                (  ram188_wadr         )
        ,.wea_b               (  ram188_wen          )
        ,.dina                (  ram188_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram188_radr         )
        ,.oeb_b               (  ram188_ren          )
        ,.doutb               (  ram188_rd           )
    );

    TMC_RAM1R1W384WX128B RAM192(
         .clka                (  CCLK                )
        ,.adra                (  ram192_wadr         )
        ,.wea_b               (  ram192_wen          )
        ,.dina                (  ram192_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram192_radr         )
        ,.oeb_b               (  ram192_ren          )
        ,.doutb               (  ram192_rd           )
    );

    TMC_RAM1R1W384WX128B RAM196(
         .clka                (  CCLK                )
        ,.adra                (  ram196_wadr         )
        ,.wea_b               (  ram196_wen          )
        ,.dina                (  ram196_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram196_radr         )
        ,.oeb_b               (  ram196_ren          )
        ,.doutb               (  ram196_rd           )
    );

    TMC_RAM1R1W384WX128B RAM200(
         .clka                (  CCLK                )
        ,.adra                (  ram200_wadr         )
        ,.wea_b               (  ram200_wen          )
        ,.dina                (  ram200_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram200_radr         )
        ,.oeb_b               (  ram200_ren          )
        ,.doutb               (  ram200_rd           )
    );

    TMC_RAM1R1W192WX128B RAM204(
         .clka                (  CCLK                )
        ,.adra                (  ram204_wadr         )
        ,.wea_b               (  ram204_wen          )
        ,.dina                (  ram204_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram204_radr         )
        ,.oeb_b               (  ram204_ren          )
        ,.doutb               (  ram204_rd           )
    );

    TMC_RAM1R1W96WX128B RAM208(
         .clka                (  CCLK                )
        ,.adra                (  ram208_wadr         )
        ,.wea_b               (  ram208_wen          )
        ,.dina                (  ram208_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram208_radr         )
        ,.oeb_b               (  ram208_ren          )
        ,.doutb               (  ram208_rd           )
    );

    TMC_RAM1R1W48WX128B RAM212(
         .clka                (  CCLK                )
        ,.adra                (  ram212_wadr         )
        ,.wea_b               (  ram212_wen          )
        ,.dina                (  ram212_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram212_radr         )
        ,.oeb_b               (  ram212_ren          )
        ,.doutb               (  ram212_rd           )
    );

    TMC_RAM1R1W48WX128B RAM216(
         .clka                (  CCLK                )
        ,.adra                (  ram216_wadr         )
        ,.wea_b               (  ram216_wen          )
        ,.dina                (  ram216_wd           )
        ,.clkb                (  VCLK                )
        ,.adrb                (  ram216_radr         )
        ,.oeb_b               (  ram216_ren          )
        ,.doutb               (  ram216_rd           )
    );

    TMC_RAM1R1W1C1024WX84B RAM500(
         .clk                 ( CCLK                 )
        ,.adra                ( ram500_wadr          )
        ,.wea_b               ( ram500_wen           )
        ,.dina                ( ram500_wd            )
        ,.adrb                ( ram500_radr          )
        ,.oeb_b               ( ram500_ren           )
        ,.doutb               ( ram500_rd            )
    );

    TMC_RAM1R1W1C512WX96B RAM501(
         .clk                 ( CCLK                 )
        ,.adra                ( ram501_wadr          )
        ,.wea_b               ( ram501_wen           )
        ,.dina                ( ram501_wd            )
        ,.adrb                ( ram501_radr          )
        ,.oeb_b               ( ram501_ren           )
        ,.doutb               ( ram501_rd            )
    );

    TMC_RAM1R1W1C512WX96B RAM502(
         .clk                 ( CCLK                 )
        ,.adra                ( ram502_wadr          )
        ,.wea_b               ( ram502_wen           )
        ,.dina                ( ram502_wd            )
        ,.adrb                ( ram502_radr          )
        ,.oeb_b               ( ram502_ren           )
        ,.doutb               ( ram502_rd            )
    );

    TMC_RAM1R1W1C512WX96B RAM503(
         .clk                 ( CCLK                 )
        ,.adra                ( ram503_wadr          )
        ,.wea_b               ( ram503_wen           )
        ,.dina                ( ram503_wd            )
        ,.adrb                ( ram503_radr          )
        ,.oeb_b               ( ram503_ren           )
        ,.doutb               ( ram503_rd            )
    );

    TMC_RAM1R1W1C512WX100B RAM504(
         .clk                 ( CCLK                 )
        ,.adra                ( ram504_wadr          )
        ,.wea_b               ( ram504_wen           )
        ,.dina                ( ram504_wd            )
        ,.adrb                ( ram504_radr          )
        ,.oeb_b               ( ram504_ren           )
        ,.doutb               ( ram504_rd            )
    );

    TMC_RAM1R1W1C1024WX88B RAM510(
         .clk                 ( CCLK                 )
        ,.adra                ( ram510_wadr          )
        ,.wea_b               ( ram510_wen           )
        ,.dina                ( ram510_wd            )
        ,.adrb                ( ram510_radr          )
        ,.oeb_b               ( ram510_ren           )
        ,.doutb               ( ram510_rd            )
    );

    TMC_RAM1R1W1C512WX100B RAM511(
         .clk                 ( CCLK                 )
        ,.adra                ( ram511_wadr          )
        ,.wea_b               ( ram511_wen           )
        ,.dina                ( ram511_wd            )
        ,.adrb                ( ram511_radr          )
        ,.oeb_b               ( ram511_ren           )
        ,.doutb               ( ram511_rd            )
    );

    TMC_RAM1R1W1C512WX100B RAM512(
         .clk                 ( CCLK                 )
        ,.adra                ( ram512_wadr          )
        ,.wea_b               ( ram512_wen           )
        ,.dina                ( ram512_wd            )
        ,.adrb                ( ram512_radr          )
        ,.oeb_b               ( ram512_ren           )
        ,.doutb               ( ram512_rd            )
    );

    TMC_RAM1R1W1C512WX100B RAM513(
         .clk                 ( CCLK                 )
        ,.adra                ( ram513_wadr          )
        ,.wea_b               ( ram513_wen           )
        ,.dina                ( ram513_wd            )
        ,.adrb                ( ram513_radr          )
        ,.oeb_b               ( ram513_ren           )
        ,.doutb               ( ram513_rd            )
    );

    TMC_RAM1R1W1C512WX104B RAM514(
         .clk                 ( CCLK                 )
        ,.adra                ( ram514_wadr          )
        ,.wea_b               ( ram514_wen           )
        ,.dina                ( ram514_wd            )
        ,.adrb                ( ram514_radr          )
        ,.oeb_b               ( ram514_ren           )
        ,.doutb               ( ram514_rd            )
    );

    TMC_RAM1R1W1C1024WX88B RAM520(
         .clk                 ( CCLK                 )
        ,.adra                ( ram520_wadr          )
        ,.wea_b               ( ram520_wen           )
        ,.dina                ( ram520_wd            )
        ,.adrb                ( ram520_radr          )
        ,.oeb_b               ( ram520_ren           )
        ,.doutb               ( ram520_rd            )
    );

    TMC_RAM1R1W1C512WX100B RAM521(
         .clk                 ( CCLK                 )
        ,.adra                ( ram521_wadr          )
        ,.wea_b               ( ram521_wen           )
        ,.dina                ( ram521_wd            )
        ,.adrb                ( ram521_radr          )
        ,.oeb_b               ( ram521_ren           )
        ,.doutb               ( ram521_rd            )
    );

    TMC_RAM1R1W1C512WX100B RAM522(
         .clk                 ( CCLK                 )
        ,.adra                ( ram522_wadr          )
        ,.wea_b               ( ram522_wen           )
        ,.dina                ( ram522_wd            )
        ,.adrb                ( ram522_radr          )
        ,.oeb_b               ( ram522_ren           )
        ,.doutb               ( ram522_rd            )
    );

    TMC_RAM1R1W1C512WX100B RAM523(
         .clk                 ( CCLK                 )
        ,.adra                ( ram523_wadr          )
        ,.wea_b               ( ram523_wen           )
        ,.dina                ( ram523_wd            )
        ,.adrb                ( ram523_radr          )
        ,.oeb_b               ( ram523_ren           )
        ,.doutb               ( ram523_rd            )
    );

    TMC_RAM1R1W1C512WX104B RAM524(
         .clk                 ( CCLK                 )
        ,.adra                ( ram524_wadr          )
        ,.wea_b               ( ram524_wen           )
        ,.dina                ( ram524_wd            )
        ,.adrb                ( ram524_radr          )
        ,.oeb_b               ( ram524_ren           )
        ,.doutb               ( ram524_rd            )
    );

    TMC_RAM1RW96WX128B RAM600 (
         .clk                 ( VCLK                 )
        ,.adr                 ( ram600_adr           )
        ,.oe_b                ( ram600_ren           )
        ,.we_b                ( ram600_wen           )
        ,.din                 ( ram600_wdata         )
        ,.dout                ( ram600_rdata         )
    );

    TMC_RAM1RW96WX128B RAM601 (
         .clk                 ( VCLK                 )
        ,.adr                 ( ram601_adr           )
        ,.oe_b                ( ram601_ren           )
        ,.we_b                ( ram601_wen           )
        ,.din                 ( ram601_wdata         )
        ,.dout                ( ram601_rdata         )
    );

    TMC_RAM1RW96WX128B RAM602 (
         .clk                 ( VCLK                 )
        ,.adr                 ( ram602_adr           )
        ,.oe_b                ( ram602_ren           )
        ,.we_b                ( ram602_wen           )
        ,.din                 ( ram602_wdata         )
        ,.dout                ( ram602_rdata         )
    );

    TMC_RAM1RW96WX128B RAM603 (
         .clk                 ( VCLK                 )
        ,.adr                 ( ram603_adr           )
        ,.oe_b                ( ram603_ren           )
        ,.we_b                ( ram603_wen           )
        ,.din                 ( ram603_wdata         )
        ,.dout                ( ram603_rdata         )
    );

    TMC_RAM1RW512WX128B RAM610 (
         .clk                 ( VCLK                 )
        ,.adr                 ( ram610_adr           )
        ,.oe_b                ( ram610_ren           )
        ,.we_b                ( ram610_wen           )
        ,.din                 ( ram610_wdata         )
        ,.dout                ( ram610_rdata         )
    );

    TMC_RAM1RW512WX128B RAM611 (
         .clk                 ( VCLK                 )
        ,.adr                 ( ram611_adr           )
        ,.oe_b                ( ram611_ren           )
        ,.we_b                ( ram611_wen           )
        ,.din                 ( ram611_wdata         )
        ,.dout                ( ram611_rdata         )
    );

    TMC_RAM1RW512WX128B RAM612 (
         .clk                 ( VCLK                 )
        ,.adr                 ( ram612_adr           )
        ,.oe_b                ( ram612_ren           )
        ,.we_b                ( ram612_wen           )
        ,.din                 ( ram612_wdata         )
        ,.dout                ( ram612_rdata         )
    );

    TMC_RAM1RW512WX128B RAM613 (
         .clk                 ( VCLK                 )
        ,.adr                 ( ram613_adr           )
        ,.oe_b                ( ram613_ren           )
        ,.we_b                ( ram613_wen           )
        ,.din                 ( ram613_wdata         )
        ,.dout                ( ram613_rdata         )
    );


endmodule
