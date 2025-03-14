//##################################################################################
//
// Simple AHB Master for TMC IP register setting
//
//##################################################################################
`timescale 1ns / 1ps // Modified on 2023/12/18 by jihan
module Simple_AHB_Master_enc #(
	parameter TGT_SIZE 	= 2475000,
	parameter PIC_WIDTH 	= 1920,
	parameter PIC_HEIGHT 	= 2160,
	parameter PIC_FMT 	= 4,
	parameter BIT_DEPTH 	= 12,
	parameter NL_Y	 	= 2,
	parameter Q_SEL	 	= 1,
	parameter ENC_PROF 	= 0,
	parameter ENC_LEVEL 	= 0,
	parameter ENC_SUBLEVEL 	= 0)
	(
         CLK                    //
        ,HCLK                    //
        ,RSTN                    //
        ,TMC_INIT                //

         // AHB-BUS
	,HREADY_OUT		// i
	,INTR_IN		// i

	,DSIZE
	,TGT_SEL
	,TGT_SIZE_TBL0
	,TGT_SIZE_TBL1
	,TGT_SIZE_TBL2
	,TGT_SIZE_TBL3
	,TGT_SIZE_TBL4
	,TGT_SIZE_TBL5
	,TGT_SIZE_TBL6
	,TGT_SIZE_TBL7
	,NL_SEL
	,DEPTH_SEL
	,GTY_INIT
        ,HSEL                   // o select
        ,HREADYIN               // o ready
        ,HADDR                  // o address
        ,HSIZE                  // o data size
        ,HBURST                 // o burst type
        ,HPROT                  // o protect type
        ,HMASTLOCK              // o lock type
        ,HWDATA                 // o write data
        ,HWRITE                 // o write
        ,HTRANS                 // o transfer type


);

    //----------------------------------------------------------------------
    // parameter declaration
    //----------------------------------------------------------------------

    //---------------------------------------------------------------------
    // Defination of Port Signals
    //---------------------------------------------------------------------
    input                CLK                   ;
    input                HCLK                  ;
    input                RSTN                  ;
    input                TMC_INIT              ;

    // AHB-BUS
    input		  HREADY_OUT	       ;
    input		  INTR_IN	       ;
    input   [      2 :0]  TGT_SEL              ; // only [12:2] referred
    input   [      31 :0] TGT_SIZE_TBL0      ; // only [12:2] referred
    input   [      31 :0] TGT_SIZE_TBL1      ; // only [12:2] referred
    input   [      31 :0] TGT_SIZE_TBL2      ; // only [12:2] referred
    input   [      31 :0] TGT_SIZE_TBL3      ; // only [12:2] referred
    input   [      31 :0] TGT_SIZE_TBL4      ; // only [12:2] referred
    input   [      31 :0] TGT_SIZE_TBL5      ; // only [12:2] referred
    input   [      31 :0] TGT_SIZE_TBL6      ; // only [12:2] referred
    input   [      31 :0] TGT_SIZE_TBL7      ; // only [12:2] referred
    input   [      1 :0]  NL_SEL              ; // only [12:2] referred
    input   		  DEPTH_SEL           ; // only [12:2] referred
    output  [      31:0]  DSIZE                ; // only [12:2] referred
    output                GTY_INIT             ;

    output                HSEL                 ;
    output                HREADYIN             ;
    output  [      31:0]  HADDR                ; // only [12:2] referred
    output  [       2:0]  HSIZE                ; // 32bits only
    output  [       2:0]  HBURST               ;
    output  [       3:0]  HPROT                ; // no support
    output                HMASTLOCK            ; // no support
    output  [      31:0]  HWDATA               ;
    output                HWRITE               ;
    output  [       1:0]  HTRANS               ;
//------------------------------------------------------------------------------
// state machine
//------------------------------------------------------------------------------
parameter	ST_IDLE		= 0;	// IDLE state
parameter	ST_INIT_INTR_W	= 1;	// Added on 2023/12/25 by jihan
parameter	ST_INT_EN	= 2;	// 
parameter	ST_TGT_SIZE	= 3;	// 
parameter	ST_PIC_SIZE	= 4;	// 
parameter	ST_PIC_FMT	= 5;	// 
parameter	ST_PROF		= 6;	// 
parameter	ST_NL		= 7;	// 
parameter	ST_MODE		= 8;	// 
parameter	ST_START	= 9;	// 
parameter	ST_WAIT		= 10;	// 
parameter	ST_INTR		= 11;	// 

`define CPU_ADR_ENC_CMD          32'h00000000
`define CPU_ADR_ENC_SRST         32'h00000004
`define CPU_ADR_INT_STAT         32'h00000010
`define CPU_ADR_INT_RAW          32'h00000014
`define CPU_ADR_INT_EN           32'h00000018

`define CPU_ADR_ENC_TGT_SIZE     32'h00000020
`define CPU_ADR_ENC_PIC_SIZE     32'h00000024
`define CPU_ADR_ENC_PIC_FMT      32'h00000028
`define CPU_ADR_ENC_PROF         32'h0000002C
`define CPU_ADR_ENC_NL           32'h00000034
`define CPU_ADR_ENC_MODE         32'h00000038
`define CPU_ADR_ENC_WGT_SET      32'h0000003C

`define CPU_ADR_ENC_ERR_INFO0    32'h00000040
`define CPU_ADR_ENC_ERR_MASK0    32'h00000044

//`define TGT_SIZE      8333333
//`define TGT_SIZE      4950000
//`define PIC_WIDTH     3840
//`define TGT_SIZE      2475000
//`define PIC_WIDTH     1920
//`define PIC_HEIGHT    2160
//`define TGT_SIZE      618750
//`define PIC_WIDTH     1920
//`define PIC_HEIGHT    540
//`define PIC_FMT       0

//`define BIT_DEPTH     12
//`define NL_Y          2
//`define Q_SEL         1
//`define ENC_PROF      0
//`define ENC_LEVEL     0
//`define ENC_SUBLEVEL  0


reg		[ 11:0]	csm;		// current state machine
reg		[ 11:0]	nsm;		// next    state machine

wire			csm_idle	= csm[ST_IDLE];
wire			csm_init_intr_w = csm[ST_INIT_INTR_W]; // Added on 2023/12/25 by jihan
wire			csm_int_en	= csm[ST_INT_EN];
wire			csm_tgt_size	= csm[ST_TGT_SIZE];
wire			csm_pic_size	= csm[ST_PIC_SIZE];
wire			csm_pic_fmt	= csm[ST_PIC_FMT];
wire			csm_prof	= csm[ST_PROF];
wire			csm_nl		= csm[ST_NL];
wire			csm_mode	= csm[ST_MODE];
wire			csm_start	= csm[ST_START];
wire			csm_wait	= csm[ST_WAIT];
wire			csm_intr	= csm[ST_INTR];

reg			en_p;
reg			HREADY_OUT_d;
wire			hr_p = HREADY_OUT &  ~HREADY_OUT_d;
reg [1:0]		tmc_init_reg;

always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN) 
	    tmc_init_reg <= 0;
    	else begin
	    tmc_init_reg[0] <= TMC_INIT;
	    tmc_init_reg[1] <= tmc_init_reg[0];
	end
end

always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN) 
	    HREADY_OUT_d <= 0;
    	else
	    HREADY_OUT_d <= HREADY_OUT;
end

wire  [     13:0] pic_width    ;
wire  [     13:0] pic_height   ;
wire  [      3:0] bit_depth    ;
wire  [      2:0] pic_fmt      ;
wire  [     31:0] enc_tgt_size ;
wire  [      1:0] nl_y         ;
wire              q_sel        ;
wire  [      7:0] enc_level    ;
wire  [      7:0] enc_sublevel ;
wire  [     15:0] enc_prof     ;


reg   [     31:0] enc_tgt_size_reg ;
reg   [     1:0]  enc_nl_reg ;
reg   [     3:0]  enc_bit_depth_reg ;

assign       pic_width    = PIC_WIDTH   ;
assign       pic_height   = PIC_HEIGHT  ;
assign       bit_depth    = BIT_DEPTH   ;
assign       pic_fmt      = PIC_FMT     ;
assign       enc_tgt_size = TGT_SIZE    ;
assign       nl_y         = NL_Y        ;
assign       q_sel        = Q_SEL       ;
assign       enc_level    = ENC_LEVEL   ;
assign       enc_sublevel = ENC_SUBLEVEL;
assign       enc_prof     = ENC_PROF    ;

reg	csm_init_intr_w_d	; // Added on 2023/12/22 by jiha
reg	csm_int_en_d		;	
reg	csm_tgt_size_d		;
reg	csm_pic_size_d		;
reg	csm_pic_fmt_d		;
reg	csm_prof_d		;
reg	csm_nl_d		;
reg	csm_mode_d		;
reg	csm_start_d		;
reg	csm_intr_d		;


always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN) begin
	    csm_init_intr_w_d <= 0; // Added on 2023/12/22 by jihan
	    csm_int_en_d <= 0;
	    csm_tgt_size_d <= 0;
	    csm_pic_size_d <= 0;
	    csm_pic_fmt_d <= 0;
	    csm_prof_d <= 0;
	    csm_nl_d <= 0;
	    csm_mode_d <= 0;
	    csm_start_d <= 0;
	    csm_intr_d <= 0;
	end
	else if (~csm_wait) begin 
	    csm_init_intr_w_d <= csm_init_intr_w;
	    csm_int_en_d <= csm_int_en;
	    csm_tgt_size_d <= csm_tgt_size;
	    csm_pic_size_d <= csm_pic_size;
	    csm_pic_fmt_d <= csm_pic_fmt;
	    csm_prof_d <= csm_prof;
	    csm_nl_d <= csm_nl;
	    csm_mode_d <= csm_mode;
	    csm_start_d <= csm_start;
	    csm_intr_d <= csm_intr;
	end
end

always @(*)
begin
	nsm          = 0;
case (1'b1)
	csm[ST_IDLE] :
		if (en_p)
			//nsm[ST_INT_EN] = 1'b1;
			nsm[ST_INIT_INTR_W] = 1'b1;
		else if (INTR_IN)
			nsm[ST_INTR] = 1'b1;
		else
			nsm[ST_IDLE] = 1'b1;
	csm[ST_INIT_INTR_W] : // Added on 2023/12/22 by jihan
			nsm[ST_WAIT] = 1'b1;
	csm[ST_INT_EN] :
//		if (hr_p)
			nsm[ST_WAIT] = 1'b1;
//		else
//			nsm[ST_INT_EN] = 1'b1;
	csm[ST_TGT_SIZE] :
//		if (hr_p)
			nsm[ST_WAIT] = 1'b1;
//		else
//			nsm[ST_TGT_SIZE] = 1'b1;
	csm[ST_PIC_SIZE] :
//		if (hr_p)
			nsm[ST_WAIT] = 1'b1;
//		else
//			nsm[ST_PIC_SIZE] = 1'b1;
	csm[ST_PIC_FMT] :
//		if (hr_p)
			nsm[ST_WAIT] = 1'b1;
//		else
//			nsm[ST_PIC_FMT] = 1'b1;
	csm[ST_PROF] :
//		if (hr_p)
			nsm[ST_WAIT] = 1'b1;
//		else
//			nsm[ST_PROF] = 1'b1;
	csm[ST_NL] :
//		if (hr_p)
			nsm[ST_WAIT] = 1'b1;
//		else
//			nsm[ST_NL] = 1'b1;
	csm[ST_MODE] :
//		if (hr_p)
			nsm[ST_WAIT] = 1'b1;
//		else
//			nsm[ST_MODE] = 1'b1;
	csm[ST_START] :
//		if (hr_p)
			nsm[ST_WAIT] = 1'b1;
//		else
//			nsm[ST_START] = 1'b1;
	csm[ST_INTR] :
//		if (hr_p)
			nsm[ST_WAIT] = 1'b1;
//		else
//			nsm[ST_START] = 1'b1;
	csm[ST_WAIT] :
		if (hr_p) begin
			if (csm_init_intr_w_d) // Added on 2023/12/22 by jihan
				nsm[ST_INT_EN] = 1'b1;			
			else if (csm_int_en_d)
				nsm[ST_TGT_SIZE] = 1'b1;
			else if (csm_tgt_size_d)
				nsm[ST_PIC_SIZE] = 1'b1;
			else if (csm_pic_size_d)
				nsm[ST_PIC_FMT] = 1'b1;
			else if (csm_pic_fmt_d)
				nsm[ST_PROF] = 1'b1;
			else if (csm_prof_d)
				nsm[ST_NL] = 1'b1;
			else if (csm_nl_d)
				nsm[ST_MODE] = 1'b1;
			else if (csm_mode_d)
				nsm[ST_START] = 1'b1;
			else if (csm_start_d)
				nsm[ST_IDLE] = 1'b1;
			else if (csm_intr_d)
				nsm[ST_IDLE] = 1'b1;
		end 
		else
			nsm[ST_WAIT] = 1'b1;

	default   :	nsm[ST_IDLE] = 1'b1;
	endcase
end

always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
		csm <= 1;
	else
		csm <= nsm;
end

reg [9:0] init_cnt;
//always @(posedge CLK or negedge RSTN)
always @(posedge HCLK or negedge RSTN) // Modified on 2024/01/06 by jihan
begin
	if (~RSTN)
		init_cnt <= 0;
	else if (tmc_init_reg == 2) 
		init_cnt <= 0;
	else if (init_cnt < 1000)
		init_cnt <= init_cnt + 1;
end

reg en_tmp, en_tmp_d;
always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
		en_tmp <= 0;
	else if (init_cnt == 1000)
		en_tmp <= 1;
	else
		en_tmp <= 0;
end

always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
		en_tmp_d <= 0;
	else
		en_tmp_d <= en_tmp;
end

always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
		en_p <= 0;
	else if (init_cnt == 1000) begin
	    if (en_tmp == 1 && en_tmp_d == 0)
		en_p <= 1;
	    else
		en_p <= 0;
	end
end

reg [31:0] addr;
always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
	    addr <= 0;
 	else if (csm_init_intr_w) // Added on 2023/12/22 by jihan
	    addr <= `CPU_ADR_INT_STAT ;
	else if (csm_int_en)
	    addr <= `CPU_ADR_INT_EN ;
	else if (csm_tgt_size)
    	    addr <= `CPU_ADR_ENC_TGT_SIZE ;
	else if (csm_pic_size)
    	    addr <= `CPU_ADR_ENC_PIC_SIZE;
	else if (csm_pic_fmt)
    	    addr <= `CPU_ADR_ENC_PIC_FMT;
	else if (csm_prof)
    	    addr <= `CPU_ADR_ENC_PROF;
	else if (csm_nl)
    	    addr <= `CPU_ADR_ENC_NL ;
	else if (csm_mode)
    	    addr <= `CPU_ADR_ENC_MODE;
	else if (csm_start)
    	    addr <= `CPU_ADR_ENC_CMD;
	else if (csm_intr)
    	    addr <= `CPU_ADR_INT_STAT;
end
reg [31:0] wdata;
always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
	    wdata <= 0;
	else if (csm_init_intr_w) // Added on 2023/12/22 by jihan
	    wdata <= {16'd0,7'd0,1'b1,7'd0,1'b1     };
	else if (csm_int_en)
	    wdata <= {16'd0,7'd0,1'b1,7'd0,1'b1     };
	else if (csm_tgt_size)
    	    wdata <= {enc_tgt_size_reg              };
	else if (csm_pic_size)
    	    wdata <= {2'd0,pic_height,2'd0,pic_width};
	else if (csm_pic_fmt)
    	    //wdata <= {24'd0,bit_depth,1'd0,pic_fmt  };
    	    wdata <= {24'd0,enc_bit_depth_reg,1'd0,pic_fmt  };
	else if (csm_prof)
    	    wdata <= {enc_level,enc_sublevel,enc_prof};
	else if (csm_nl)
    	    //wdata <= {22'd0,nl_y,5'd0,3'd5          };
    	    wdata <= {22'd0,enc_nl_reg,5'd0,3'd5          };
	else if (csm_mode)
    	    wdata <= {23'd0,1'b0,6'd0,1'b0,    q_sel};
	else if (csm_start)
	    wdata <= 32'h00000001;
	else if (csm_intr)
	    wdata <= 32'h00000001;

end

reg gty_init_int;
always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
	    gty_init_int <= 0;
	//else if (csm_start)
	else if (init_cnt == 100)
	    gty_init_int <= 1;
    	else
	    gty_init_int <= 0;
end

reg [7:0]  gty_init_int_d;
always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
	    gty_init_int_d <= 0;
   	else begin
	    gty_init_int_d[0] <= gty_init_int;
	    gty_init_int_d[7:1] <= gty_init_int_d[6:0];
	end
end

reg	we;
always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
	    we <= 0;
    	else if (csm_idle || csm_wait)
	    we <= 0;
    	else 
	    we <= 1;
end

reg [1:0]	trans;
always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
	    trans <= 0;
    	else if (csm_idle)
	    trans <= 0;
    	else 
	    trans <= 2'b10;
end
assign HADDR 	= addr;
assign HWDATA 	= wdata;
assign HSEL	= we;
assign HWRITE	= we;
assign HTRANS	= trans;

assign GTY_INIT = |gty_init_int_d;

wire [31:0] tgt_size_array [7:0];
assign tgt_size_array[0] = TGT_SIZE_TBL0;
assign tgt_size_array[1] = TGT_SIZE_TBL1;
assign tgt_size_array[2] = TGT_SIZE_TBL2;
assign tgt_size_array[3] = TGT_SIZE_TBL3;
assign tgt_size_array[4] = TGT_SIZE_TBL4;
assign tgt_size_array[5] = TGT_SIZE_TBL5;
assign tgt_size_array[6] = TGT_SIZE_TBL6;
assign tgt_size_array[7] = TGT_SIZE_TBL7;

always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
	    enc_tgt_size_reg <= 1800000;
    	//else if (csm_init_intr_w_d) begin
    	else if (init_cnt == 1) begin
	    enc_tgt_size_reg <= tgt_size_array[TGT_SEL];  // 22
	end
end

always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
	    enc_nl_reg <= 2;
    	//else if (csm_init_intr_w_d) begin
    	else if (init_cnt == 1) begin
	    if (NL_SEL == 0)
	    	enc_nl_reg <= 2;  // 10.368
	    else if (NL_SEL == 1)
	    	enc_nl_reg <= 1;  // 12
	    else if (NL_SEL == 2)
	    	enc_nl_reg <= 2;  // 14
	    else
	    	enc_nl_reg <= 2;  // 22
	end
end

always @(posedge HCLK or negedge RSTN)
begin
	if (~RSTN)
	    enc_bit_depth_reg <= 12;
    	//else if (csm_init_intr_w_d) begin
    	else if (init_cnt == 1) begin
	    if (DEPTH_SEL == 0)
	    	enc_bit_depth_reg <= 12;  // 10.368
	    else
	    	enc_bit_depth_reg <= 10;  // 10.368
	end
end

assign DSIZE = enc_tgt_size_reg;

endmodule
