module tx_burst_mod(enc_sw_rst, frst, init, dmax, wclk, rclk, din_valid, din, 
	out_full_b0, out_full_b1, 
	din_ready, dout, dout_valid,
	rd_en_b0, rd_en_b1, rbank_sel,
	// Debug ports
	wr_en_b0_ila, rd_en_b0_ila, wr_en_b1_ila, rd_en_b1_ila, wr_cnt_ila, dout_b0_ila, alm_full_b0_ila, alm_full_b1_ila, empty_b0_cdc_ila, empty_b1_cdc_ila, wr_data_count_b0_ila, rd_data_count_b0_ila,
	wr_data_count_b1_ila, rd_data_count_b1_ila,
	full_b0_cdc_ila, full_b1_cdc_ila, out_op_en);

  input enc_sw_rst;
  input frst;
  input init;
  input [31:0] dmax;
  input wclk;
  input rclk;
  input din_valid;
  input [127:0] din;
  output reg din_ready;
  output [31:0] dout;
  output dout_valid;
  output out_full_b0;
  output out_full_b1;
  output out_op_en;

  input rd_en_b0;
  input rd_en_b1;
  input rbank_sel;
  // debug ports
  output wr_en_b0_ila;
  output rd_en_b0_ila;
  output wr_en_b1_ila;
  output rd_en_b1_ila;
  output [8:0] wr_cnt_ila;
  output [31:0] dout_b0_ila;
  output alm_full_b0_ila;
  output alm_full_b1_ila;
  output empty_b0_cdc_ila;
  output empty_b1_cdc_ila;
  output [8:0] wr_data_count_b0_ila;
  output [10:0] rd_data_count_b0_ila;
  output [8:0] wr_data_count_b1_ila;
  output [10:0] rd_data_count_b1_ila;

  output full_b0_cdc_ila;
  output full_b1_cdc_ila;

  wire wr_en_b0;
  wire wr_en_b1;
  wire full_b0;
  wire full_b1;
  wire alm_full_b0;
  wire alm_full_b1;
  wire empty_b0;
  wire empty_b1;
  wire [31:0] dout_b0;
  wire [31:0] dout_b1;

  reg [31:0] din_cnt;
  reg wbank_sel;
  reg flush_b0;
  reg flush_b1;
  reg op_en;
  reg alm_full_b0_d;
  reg alm_full_b1_d;
  reg [1:0] dout_valid_d;
  reg [8:0] wr_cnt;
  reg empty_b0_cdc;
  reg empty_b1_cdc;
  reg full_b0_cdc;
  reg full_b1_cdc;
  reg flush_b0_cdc;
  reg flush_b1_cdc;
  reg op_en_cdc;
  reg init_cdc;

  assign out_full_b0 = op_en_cdc & (full_b0_cdc | flush_b0_cdc);
  assign out_full_b1 = op_en_cdc & (full_b1_cdc | flush_b1_cdc);
  reg [31:0] dmax_128b;
  //assign dmax_128b = {4'd0, dmax[31:4]};

  assign out_op_en = op_en_cdc;

  reg init_d;
  reg init_valid;
  wire [127:0] init_din = 128'hAAAAAAAA_AAAAAAAA_AAAAAAAA_AAAAAAAA;
  wire [127:0] din_int;

  always @(posedge wclk or posedge frst) begin
		if (frst)
			dmax_128b <= 0;
		else if (enc_sw_rst)
			dmax_128b <= 0;
		else if(init)
			dmax_128b <= {4'd0, dmax[31:4]};
  end
  always @(posedge wclk or posedge frst) begin
		if (frst)
			op_en <= 0;
		else if (enc_sw_rst)
			op_en <= 0;
		else if(init)
			op_en <= 1;
		else if((flush_b0 | flush_b1) & empty_b0_cdc & empty_b1_cdc)
			op_en <= 0;
  end

  reg op_en_d;
  always @(posedge wclk or posedge frst) begin
		if (frst)
			op_en_d <= 0;
		else if (enc_sw_rst)
			op_en_d <= 0;
		else
			op_en_d <= op_en;
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			init_d <= 0;
		else if (enc_sw_rst)
			init_d <= 0;
		else 
			init_d <= init;
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			init_valid <= 0;
		else if (enc_sw_rst)
			init_valid <= 0;
		else if(init & ~init_d & empty_b0_cdc)
			init_valid <= 1;    // for init_din
		else
			init_valid <= 0;
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			din_cnt <= 0;
		else if (enc_sw_rst)
			din_cnt <= 0;
		else if(init)
			din_cnt <= 1;    // for init_din
		else if(din_valid & din_ready)
			din_cnt <= din_cnt + 1;
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			flush_b0 <= 0;
		else if (enc_sw_rst)
			flush_b0 <= 0;
		else if(init | ~op_en)
			flush_b0 <= 0;
		else if(~wbank_sel & (din_cnt >= dmax_128b))
			flush_b0 <= 1;
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			flush_b1 <= 0;
		else if (enc_sw_rst)
			flush_b1 <= 0;
		else if(init | ~op_en)
			flush_b1 <= 0;
		else if(wbank_sel & (din_cnt >= dmax_128b))
			flush_b1 <= 1;
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			wr_cnt <= 0;
		else if (enc_sw_rst)
			wr_cnt <= 0;
		else if(init)
			wr_cnt <= 1;    // for init_din
		else if(din_valid & din_ready) begin
			if (wr_cnt != 254)
				wr_cnt <= wr_cnt + 1;
			else
				wr_cnt <= 0;
		end
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			wbank_sel <= 0;
		else if (enc_sw_rst)
			wbank_sel <= 0;
		else if(init)
			wbank_sel <= 0;
		else if(op_en) begin
			if(din_valid & din_ready && (wr_cnt[7:0] == 'd254)) // actual write depth 255
				wbank_sel <= ~wbank_sel;
		end
  end

  always @(posedge wclk or posedge frst) begin
	  if (frst) begin
		  empty_b0_cdc <= 0;
		  empty_b1_cdc <= 0;
	  end
	  else if (enc_sw_rst) begin
		  empty_b0_cdc <= 0;
		  empty_b1_cdc <= 0;
	  end
	  else begin
		  empty_b0_cdc <= empty_b0;
		  empty_b1_cdc <= empty_b1;
	  end
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			din_ready <= 1;
		else if (enc_sw_rst)
			din_ready <= 1;
		else if(alm_full_b0 & ~alm_full_b0_d) begin
			if (~empty_b1_cdc)
				din_ready <= 0;
		end
		else if(alm_full_b1 & ~alm_full_b1_d) begin
			if (~empty_b0_cdc)
				din_ready <= 0;
		end
		else if(~din_ready) begin
			if (empty_b0_cdc | empty_b1_cdc)
				din_ready <= 1;
		end
  end

  always @(posedge wclk or posedge frst) begin
	  if (frst) begin
			alm_full_b0_d <= 0;
			alm_full_b1_d <= 0;
	  end
	  else if (enc_sw_rst) begin
			alm_full_b0_d <= 0;
			alm_full_b1_d <= 0;
	  end
	  else begin
			alm_full_b0_d <= alm_full_b0;
			alm_full_b1_d <= alm_full_b1;
	  end
  end

  always @(posedge rclk or posedge frst) begin
	  if (frst) begin
		  full_b0_cdc <= 0;
		  full_b1_cdc <= 0;
		  flush_b0_cdc   <= 0;
		  flush_b1_cdc   <= 0;
		  op_en_cdc   <= 0;
		  init_cdc   <= 0;
	  end
	  else if (enc_sw_rst) begin
		  full_b0_cdc <= 0;
		  full_b1_cdc <= 0;
		  flush_b0_cdc   <= 0;
		  flush_b1_cdc   <= 0;
		  op_en_cdc   <= 0;
		  init_cdc   <= 0;
	  end
	  else begin
		  full_b0_cdc <= full_b0;
		  full_b1_cdc <= full_b1;
		  flush_b0_cdc <= flush_b0;
		  flush_b1_cdc <= flush_b1;
		  op_en_cdc <= op_en;
		  init_cdc <= init;
	  end
  end

/*
  always @(posedge rclk or posedge frst) begin
		if (frst)
			rbank_sel <= 0;
		else if (enc_sw_rst)
			rbank_sel <= 0;
		else if(init_cdc)
			rbank_sel <= 0;
		else if(op_en_cdc) begin
			if(rd_cnt[9:0] == 'd1019)
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
			rd_cnt <= 0;
		else if (enc_sw_rst)
			rd_cnt <= 0;
		else if(init_cdc)
			rd_cnt <= 0;
		else if(op_en_cdc) begin
			if(rd_en) 
				rd_cnt <= rd_cnt + 1;
			else if(rd_cnt == 1020)
				rd_cnt <= 0;
		end
   end

  always @(posedge rclk or posedge frst) begin
		if (frst)
			rd_en <= 0;
		else if (enc_sw_rst)
			rd_en <= 0;
		else if(init_cdc)
			rd_en <= 0;
		else if(op_en_cdc) begin
			if(~rbank_sel_d[1]) begin
				if (lane_ren) begin
					if (ext_full_b0 && (rd_cnt == 0) && (full_b0_cdc | flush_b0_cdc)) begin
						if (comma_cnt == 3)
							rd_en <= 1;
					end
					else if(rd_cnt > 0 && rd_cnt < 1019) 
						rd_en <= 1;
					else if(rd_cnt == 1019) // 1023 - 4
						rd_en <= 0;
				end 
				else
						rd_en <= 0;
			end
			else if(rbank_sel_d[1]) begin
				if (lane_ren) begin
					if (ext_full_b1 && (rd_cnt == 0) && (full_b1_cdc | flush_b1_cdc)) begin
						if (comma_cnt == 3)
							rd_en <= 1;
					end
					else if(rd_cnt > 0 && rd_cnt < 1019) 
						rd_en <= 1;
					else if(rd_cnt == 1019)
						rd_en <= 0;
				end 
				else
						rd_en <= 0;
			end
		end
		else
			rd_en <= 0;
   end

  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	comma_cnt <= 0;
		else if (enc_sw_rst)
	         	comma_cnt <= 0;
		else if (init_cdc)
	         	comma_cnt <= 0;
		else if(op_en_cdc) begin
			if (~rd_en && ~ext_rd_en  && ((rd_cnt == 1020) || (rd_cnt == 0)))
	         		comma_cnt <= comma_cnt + 1;
			else if(rd_en)
	         		comma_cnt <= 0;
		end
		else
	         		comma_cnt <= 0;
   end
*/
  always @(posedge rclk or posedge frst) begin
		if (frst)
			dout_valid_d <= 0;
		else if (enc_sw_rst)
			dout_valid_d <= 0;
		else begin
			dout_valid_d[0] <= (rd_en_b0 | rd_en_b1);
			dout_valid_d[1] <= dout_valid_d[0];
		end
   end
  assign dout_valid = dout_valid_d[1];

  assign wr_en_b0 = (~wbank_sel) ? ((din_valid & din_ready) | init_valid) : 0;
  assign wr_en_b1 = (wbank_sel) ? (din_valid & din_ready) : 0;

  assign dout = (~rbank_sel) ? dout_b0 : dout_b1;

  assign din_int = (init_valid) ? init_din : din;

   wire alm_empty_b0;
   wire [8:0] wr_data_count_b0;
   wire [10:0] rd_data_count_b0;
   wire [8:0] wr_data_count_b1;
   wire [10:0] rd_data_count_b1;

fifo_generator_0 enc_bank0 (
  .rst(frst),
  .wr_clk(wclk),    // input wire clka
  .rd_clk(rclk),    // input wire clkb
  .din(din_int),    // input wire [127 : 0] dina
  .wr_en(wr_en_b0),      // input wire [0 : 0] wea
  .rd_en(rd_en_b0),    // input wire clkb
  .dout(dout_b0),  // output wire [31 : 0] doutb
  .full(full_b0),
  .almost_full(alm_full_b0),
  .empty(empty_b0),
  .almost_empty(alm_empty_b0),
  .rd_data_count(rd_data_count_b0),
  .wr_data_count(wr_data_count_b0),
  .wr_rst_busy(),
  .rd_rst_busy()
);

fifo_generator_0 enc_bank1 (
  .rst(frst),
  .wr_clk(wclk),    // input wire clka
  .rd_clk(rclk),    // input wire clkb
  .din(din),    // input wire [127 : 0] dina
  .wr_en(wr_en_b1),      // input wire [0 : 0] wea
  .rd_en(rd_en_b1),    // input wire clkb
  .dout(dout_b1),  // output wire [31 : 0] doutb
  .full(full_b1),
  .almost_full(alm_full_b1),
  .empty(empty_b1),
  .almost_empty(),
  .rd_data_count(rd_data_count_b1),
  .wr_data_count(wr_data_count_b1),
  .wr_rst_busy(),
  .rd_rst_busy()
);

   assign wr_en_b0_ila = wr_en_b0;
   assign rd_en_b0_ila = rd_en_b0;
   assign wr_en_b1_ila = wr_en_b1;
   assign rd_en_b1_ila = rd_en_b1;
   assign wr_cnt_ila = wr_cnt;
   assign dout_b0_ila = dout_b0;
   assign alm_full_b0_ila = alm_full_b0;
   assign alm_full_b1_ila = alm_full_b1;
   assign empty_b0_cdc_ila = empty_b0_cdc;
   assign empty_b1_cdc_ila = empty_b1_cdc;
   assign wr_data_count_b0_ila = wr_data_count_b0;
   assign rd_data_count_b0_ila = rd_data_count_b0;
   assign wr_data_count_b1_ila = wr_data_count_b1;
   assign rd_data_count_b1_ila = rd_data_count_b1;

   assign full_b0_cdc_ila = full_b0_cdc;
   assign full_b1_cdc_ila = full_b1_cdc;

  (*mark_debug ="true"*) wire [31:0] dout_dbg;
  assign dout_dbg = dout;
  (*mark_debug ="true"*) wire dout_valid_dbg;
  assign dout_valid_dbg = dout_valid;
  (*mark_debug ="true"*) wire flush_b0_cdc_dbg;
  assign flush_b0_cdc_dbg = flush_b0_cdc;
  (*mark_debug ="true"*) wire flush_b1_cdc_dbg;
  assign flush_b1_cdc_dbg = flush_b1_cdc;
  (*mark_debug ="true"*) wire op_en_cdc_dbg;
  assign op_en_cdc_dbg = op_en_cdc;
  (*mark_debug ="true"*) wire frst_dbg;
  assign frst_dbg = frst;
  (*mark_debug ="true"*) wire enc_sw_rst_dbg;
  assign enc_sw_rst_dbg = enc_sw_rst;
  (*mark_debug ="true"*) wire init_cdc_dbg;
  assign init_cdc_dbg = init_cdc;
  (*mark_debug ="true"*) wire empty_b0_dbg;
  assign empty_b0_dbg = empty_b0;
  (*mark_debug ="true"*) wire empty_b1_dbg;
  assign empty_b1_dbg = empty_b1;
  (*mark_debug ="true"*) wire [31:0] din_cnt_dbg;
  assign din_cnt_dbg = din_cnt;
endmodule
