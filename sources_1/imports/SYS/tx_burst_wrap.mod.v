module tx_burst_wrap_mod(enc_sw_rst, frst, init_l0, init_l1, dmax, wclk, rclk, din_valid_l0, din_l0, din_valid_l1, din_l1, 
	din_ready_l0, din_ready_l1, dout, dout_valid,
	// debug ports
	// line 0
	wr_en_b0_l0_ila, rd_en_b0_l0_ila, wr_en_b1_l0_ila, rd_en_b1_l0_ila, wr_cnt_l0_ila, rd_cnt_l0_ila, dout_b0_l0_ila, full_b0_l0_ila, alm_full_b0_l0_ila, alm_full_b1_l0_ila, empty_b0_l0_ila, empty_b1_l0_ila, wr_data_count_b0_l0_ila, rd_data_count_b0_l0_ila,
	wr_data_count_b1_l0_ila, rd_data_count_b1_l0_ila,
	wr_en_b0_l1_ila, rd_en_b0_l1_ila, wr_en_b1_l1_ila, rd_en_b1_l1_ila, wr_cnt_l1_ila, rd_cnt_l1_ila, dout_b0_l1_ila, full_b0_l1_ila, alm_full_b0_l1_ila, alm_full_b1_l1_ila, empty_b0_l1_ila, empty_b1_l1_ila, wr_data_count_b0_l1_ila, rd_data_count_b0_l1_ila,
	wr_data_count_b1_l1_ila, rd_data_count_b1_l1_ila,
	rbank_sel_d_l0_ila, full_b0_cdc_l0_ila, full_b1_cdc_l0_ila, ext_full_b0_ila, comma_cnt_l0_ila,
	rbank_sel_d_l1_ila, full_b0_cdc_l1_ila, full_b1_cdc_l1_ila, lane_ren_ila, comma_cnt_l1_ila
	);
  input enc_sw_rst;
  input frst;
  input init_l0;
  input init_l1;
  input [31:0] dmax;
  input wclk;
  input rclk;
  input din_valid_l0;
  input [127:0] din_l0;
  output din_ready_l0;
  input din_valid_l1;
  input [127:0] din_l1;
  output din_ready_l1;
  output reg [31:0] dout;
  output reg dout_valid;

  // debug ports
   output wr_en_b0_l0_ila;
   output rd_en_b0_l0_ila;
   output wr_en_b1_l0_ila;
   output rd_en_b1_l0_ila;
   output [8:0] wr_cnt_l0_ila;
   output [10:0] rd_cnt_l0_ila;
   output [31:0] dout_b0_l0_ila;
   output full_b0_l0_ila;
   output alm_full_b0_l0_ila;
   output alm_full_b1_l0_ila;
   output empty_b0_l0_ila;
   output empty_b1_l0_ila;
   output [7:0] wr_data_count_b0_l0_ila;
   output [9:0] rd_data_count_b0_l0_ila;
   output [7:0] wr_data_count_b1_l0_ila;
   output [9:0] rd_data_count_b1_l0_ila;

   output wr_en_b0_l1_ila;
   output rd_en_b0_l1_ila;
   output wr_en_b1_l1_ila;
   output rd_en_b1_l1_ila;
   output [8:0] wr_cnt_l1_ila;
   output [10:0] rd_cnt_l1_ila;
   output [31:0] dout_b0_l1_ila;
   output full_b0_l1_ila;
   output alm_full_b0_l1_ila;
   output alm_full_b1_l1_ila;
   output empty_b0_l1_ila;
   output empty_b1_l1_ila;
   output [8:0] wr_data_count_b0_l1_ila;
   output [10:0] rd_data_count_b0_l1_ila;
   output [8:0] wr_data_count_b1_l1_ila;
   output [10:0] rd_data_count_b1_l1_ila;

   output rbank_sel_d_l0_ila;
   output full_b0_cdc_l0_ila;
   output full_b1_cdc_l0_ila;
   output rbank_sel_d_l1_ila;
   output full_b0_cdc_l1_ila;
   output full_b1_cdc_l1_ila;
   output ext_full_b0_ila;
   output lane_ren_ila;
   output [1:0] comma_cnt_l0_ila;
   output [1:0] comma_cnt_l1_ila;

  reg l_sel;
  reg [2:0] l_sel_d;
  reg [10:0] rd_cnt;
  reg rd_en;
  wire rd_en_b0_l0;
  wire rd_en_b1_l0;
  wire rd_en_b0_l1;
  wire rd_en_b1_l1;

  reg rbank_sel;
  reg [1:0] rbank_sel_d;
  reg [1:0] comma_cnt;
  wire op_en_l0;
  wire op_en_l1;
  wire op_en_all = (op_en_l0 | op_en_l1);
  

  reg init_l0_d;
  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	init_l0_d <= 0;
		else 
	         	init_l0_d <= init_l0;
   end
  reg init_l1_d;
  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	init_l1_d <= 0;
		else 
	         	init_l1_d <= init_l1;
   end
  reg init_and;
  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	init_and <= 0;
		else 
	         	init_and <= ((init_l0 & ~init_l0_d) & (init_l1 & ~init_l1_d)); 
   end

  reg init_tmp;
  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	init_tmp <= 0;
		else if (~init_tmp) begin
			if ((init_l0 & ~init_l0_d) | (init_l1 & ~init_l1_d))
	         		init_tmp <= 1;
		end
		else begin
			if ((init_l0 & ~init_l0_d) | (init_l1 & ~init_l1_d) | init_and)
	         		init_tmp <= 0;
		end
   end
  reg init_tmp_d;
  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	init_tmp_d <= 0;
		else 
	         	init_tmp_d <= init_tmp;
   end
  reg init_rclk;
  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	init_rclk <= 0;
		else 
	         	init_rclk <= (!init_tmp & init_tmp_d);
   end
  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	l_sel <= 0;
		else if (enc_sw_rst)
	         	l_sel <= 0;
		else if (init_rclk)
	         	l_sel <= 0;
		else if(rd_cnt[2:0] == 3) 
	         	l_sel <= 1;
		else if(rd_cnt[2:0] == 7) 
	         	l_sel <= 0;
   end

  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	l_sel_d <= 0;
		else begin
	         	l_sel_d[0] <= l_sel;
	         	l_sel_d[2:1] <= l_sel_d[1:0];
		end
   end

   wire [31:0] userdata_tx_fifo_l0;
   wire [31:0] userdata_tx_fifo_l1;

   wire dout_valid_d0;
   wire dout_valid_d1;
   
  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	dout <= 0;
		else if (enc_sw_rst)
	         	dout <= 0;
		else if (init_rclk)
	         	dout <= 0;
		else if (~l_sel_d[1])
	         	dout <= userdata_tx_fifo_l0;
		else
	         	dout <= userdata_tx_fifo_l1;
   end

  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	dout_valid <= 0;
		else if (enc_sw_rst)
	         	dout_valid <= 0;
		else if (init_rclk)
	         	dout_valid <= 0;
		else if (~l_sel_d[1])
	         	dout_valid <= dout_valid_l0;
		else
	         	dout_valid <= dout_valid_l1;
   end

   wire full_b0_l0;
   wire full_b1_l0;

   wire full_b0_l1;
   wire full_b1_l1;

   assign lane_ren_ila = l_sel;

  always @(posedge rclk or posedge frst) begin
		if (frst)
			rd_cnt <= 0;
		else if (enc_sw_rst)
			rd_cnt <= 0;
		else if(init_rclk)
			rd_cnt <= 0;
		else if (op_en_all) begin
			if(rd_en) 
				rd_cnt <= rd_cnt + 1;
			else if(rd_cnt == 2040)
				rd_cnt <= 0;
		end
   end

  always @(posedge rclk or posedge frst) begin
		if (frst)
			rbank_sel <= 0;
		else if (enc_sw_rst)
			rbank_sel <= 0;
		else if(init_rclk)
			rbank_sel <= 0;
		else if (op_en_all) begin
			if(rd_cnt == 2039)
				rbank_sel <= ~rbank_sel;
		end
  end

  always @(posedge rclk or posedge frst) begin
		if (frst)
			rbank_sel_d <= 0;
		else if (enc_sw_rst)
			rbank_sel_d <= 0;
		else begin
			rbank_sel_d[0] <= rbank_sel;
			rbank_sel_d[1] <= rbank_sel_d[0];
		end
  end


  always @(posedge rclk or posedge frst) begin
		if (frst)
			rd_en <= 0;
		else if (enc_sw_rst)
			rd_en <= 0;
		else if(init_rclk)
			rd_en <= 0;
		else if (op_en_all) begin
			if(~rbank_sel_d[1]) begin
				if (full_b0_l0 && (rd_cnt == 0) && full_b0_l1) begin
					if (comma_cnt == 3)
						rd_en <= 1;
				end
				else if(rd_cnt > 0 && rd_cnt < 2039) 
					rd_en <= 1;
				else if(rd_cnt == 2039) // 1023 - 4
					rd_en <= 0;
			end
			else if(rbank_sel_d[1]) begin
				if (full_b1_l0 && (rd_cnt == 0) && full_b1_l1) begin
					if (comma_cnt == 3)
						rd_en <= 1;
				end
				else if(rd_cnt > 0 && rd_cnt < 2039) 
					rd_en <= 1;
				else if(rd_cnt == 2039) // 1023 - 4
					rd_en <= 0;
			end
		end
   end

  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	comma_cnt <= 0;
		else if (enc_sw_rst)
	         	comma_cnt <= 0;
		else if (init_rclk)
	         	comma_cnt <= 0;
		else if (op_en_all) begin
			if (~rd_en && ((rd_cnt == 2040) || (rd_cnt == 0)))
	         		comma_cnt <= comma_cnt + 1;
			else if(rd_en)
	         		comma_cnt <= 0;
		end
   end

  assign rd_en_b0_l0 = rd_en & ~rbank_sel_d[1] & ~l_sel;
  assign rd_en_b1_l0 = rd_en & rbank_sel_d[1] & ~l_sel;
  assign rd_en_b0_l1 = rd_en & ~rbank_sel_d[1] & l_sel;
  assign rd_en_b1_l1 = rd_en & rbank_sel_d[1] & l_sel;

  tx_burst_mod U_TX_BURST_MOD_L0 (
  .enc_sw_rst(enc_sw_rst),
  .frst(frst),
  .init(init_l0),
  .dmax(dmax),
  .wclk(wclk),    // input wire clka
  .rclk(rclk),    // input wire clkb
  .out_full_b0(full_b0_l0),
  .out_full_b1(full_b1_l0),
  .rd_en_b0(rd_en_b0_l0),
  .rd_en_b1(rd_en_b1_l0),
  .rbank_sel(rbank_sel_d[1]),
  .din_valid(din_valid_l0),      // input wire [0 : 0] wea
  .din(din_l0),    // input wire [127 : 0] dina
  .din_ready(din_ready_l0),
  .dout(userdata_tx_fifo_l0),  // output wire [31 : 0] doutb
  .dout_valid(dout_valid_l0),

  // debug ports
  .wr_en_b0_ila(wr_en_b0_l0_ila),
  .rd_en_b0_ila(rd_en_b0_l0_ila),
  .wr_en_b1_ila(wr_en_b1_l0_ila),
  .rd_en_b1_ila(rd_en_b1_l0_ila),
  .wr_cnt_ila(wr_cnt_l0_ila),
  .dout_b0_ila(dout_b0_l0_ila),
  .alm_full_b0_ila(alm_full_b0_l0_ila),
  .alm_full_b1_ila(alm_full_b1_l0_ila),
  .empty_b0_cdc_ila(empty_b0_l0_ila),
  .empty_b1_cdc_ila(empty_b1_l0_ila),
  .wr_data_count_b0_ila(wr_data_count_b0_l0_ila),
  .rd_data_count_b0_ila(rd_data_count_b0_l0_ila),
  .wr_data_count_b1_ila(wr_data_count_b1_l0_ila),
  .rd_data_count_b1_ila(rd_data_count_b1_l0_ila),
  .full_b0_cdc_ila(full_b0_cdc_l0_ila),
  .full_b1_cdc_ila(full_b1_cdc_l0_ila),
  .out_op_en(op_en_l0)
);

  tx_burst_mod U_TX_BURST_MOD_L1 (
  .enc_sw_rst(enc_sw_rst),
  .frst(frst),
  .init(init_l1),
  .dmax(dmax),
  .wclk(wclk),    // input wire clka
  .rclk(rclk),    // input wire clkb
  .out_full_b0(full_b0_l1),
  .out_full_b1(full_b1_l1),
  .rd_en_b0(rd_en_b0_l1),
  .rd_en_b1(rd_en_b1_l1),
  .rbank_sel(rbank_sel_d[1]),
  .din_valid(din_valid_l1),      // input wire [0 : 0] wea
  .din(din_l1),    // input wire [127 : 0] dina
  .din_ready(din_ready_l1),
  .dout(userdata_tx_fifo_l1),  // output wire [31 : 0] doutb
  .dout_valid(dout_valid_l1),

  // debug ports
  .wr_en_b0_ila(wr_en_b0_l1_ila),
  .rd_en_b0_ila(rd_en_b0_l1_ila),
  .wr_en_b1_ila(wr_en_b1_l1_ila),
  .rd_en_b1_ila(rd_en_b1_l1_ila),
  .wr_cnt_ila(wr_cnt_l1_ila),
  .dout_b0_ila(dout_b0_l1_ila),
  .alm_full_b0_ila(alm_full_b0_l1_ila),
  .alm_full_b1_ila(alm_full_b1_l1_ila),
  .empty_b0_cdc_ila(empty_b0_l1_ila),
  .empty_b1_cdc_ila(empty_b1_l1_ila),
  .wr_data_count_b0_ila(wr_data_count_b0_l1_ila),
  .rd_data_count_b0_ila(rd_data_count_b0_l1_ila),
  .wr_data_count_b1_ila(wr_data_count_b1_l1_ila),
  .rd_data_count_b1_ila(rd_data_count_b1_l1_ila),
  .full_b0_cdc_ila(full_b0_cdc_l1_ila),
  .full_b1_cdc_ila(full_b1_cdc_l1_ila),
  .out_op_en(op_en_l1)
);

endmodule
