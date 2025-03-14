module tx_burst(nrst, frst, init, dmax, wclk, rclk, din_valid, din, lane_ren, ext_full_b0,
	ext_full_b1, ext_rd_en, out_full_b0, out_full_b1, out_rd_cnt, out_rd_en,
	din_ready, dout, dout_valid);
  input nrst;
  input frst;
  (*mark_debug = "true"*)input init;
  (*mark_debug = "true"*)input [31:0] dmax;
  input wclk;
  input rclk;
  (*mark_debug = "true"*)input din_valid;
  (*mark_debug = "true"*)input [127:0] din;
  (*mark_debug = "true"*)output reg din_ready;
  output [31:0] dout;
  output dout_valid;
  output [9:0] out_rd_cnt;
  input lane_ren;
  (*mark_debug = "true"*)input ext_full_b0;
  (*mark_debug = "true"*)input ext_full_b1;
  (*mark_debug = "true"*)input ext_rd_en;
  (*mark_debug = "true"*)output out_full_b0;
  (*mark_debug = "true"*)output out_full_b1;
  (*mark_debug = "true"*)output out_rd_en;

  (*mark_debug = "true"*)wire wr_en_b0;
  (*mark_debug = "true"*)wire wr_en_b1;
  (*mark_debug = "true"*)wire rd_en_b0;
  (*mark_debug = "true"*)wire rd_en_b1;
  (*mark_debug = "true"*)wire full_b0;
  (*mark_debug = "true"*)wire full_b1;
  (*mark_debug = "true"*)wire alm_full_b0;
  (*mark_debug = "true"*)wire alm_full_b1;
  (*mark_debug = "true"*)wire empty_b0;
  (*mark_debug = "true"*)wire empty_b1;
  wire [31:0] dout_b0;
  wire [31:0] dout_b1;

  (*mark_debug = "true"*)reg [31:0] din_cnt;
  (*mark_debug = "true"*)reg wbank_sel;
  (*mark_debug = "true"*)reg rbank_sel;
  (*mark_debug = "true"*)reg [1:0] rbank_sel_d;
  (*mark_debug = "true"*)reg rd_en;
  (*mark_debug = "true"*)reg flush_b0;
  (*mark_debug = "true"*)reg flush_b1;
  (*mark_debug = "true"*)reg op_en;
  (*mark_debug = "true"*)reg alm_full_b0_d;
  (*mark_debug = "true"*)reg alm_full_b1_d;
  reg [1:0] dout_valid_d;
  (*mark_debug = "true"*)reg [7:0] wr_cnt;
  (*mark_debug = "true"*)reg [9:0] rd_cnt;
  (*mark_debug = "true"*)reg empty_b0_cdc;
  (*mark_debug = "true"*)reg empty_b1_cdc;
  (*mark_debug = "true"*)reg full_b0_cdc;
  reg full_b1_cdc;
  reg flush_b0_cdc;
  reg flush_b1_cdc;
  reg op_en_cdc;

  assign out_full_b0 = full_b0_cdc | flush_b0_cdc;
  assign out_full_b1 = full_b1_cdc | flush_b1_cdc;
  assign out_rd_cnt = rd_cnt;
  assign out_rd_en = rd_en;
  wire [31:0] dmax_128b;
  assign dmax_128b = {4'd0, dmax[31:4]};

  (*mark_debug = "true"*)reg init_d;
  (*mark_debug = "true"*)reg init_valid;
  wire [127:0] init_din = 128'hAAAAAAAA_AAAAAAAA_AAAAAAAA_AAAAAAAA;
  wire [127:0] din_int;

  reg [1:0] comma_cnt;

  always @(posedge wclk or posedge frst) begin
		if (frst)
			op_en <= 0;
		else if(init)
			op_en <= 1;
		else if((flush_b0 | flush_b1) & empty_b0_cdc & empty_b1_cdc)
			op_en <= 0;
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			init_d <= 0;
		else 
			init_d <= init;
  end
  always @(posedge wclk or posedge frst) begin
		if (frst)
			init_valid <= 0;
		else if(init & ~init_d & empty_b0_cdc)
			init_valid <= 1;    // for init_din
		else
			init_valid <= 0;
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			din_cnt <= 0;
		else if(init)
			din_cnt <= 1;    // for init_din
		else if(din_valid)
			din_cnt <= din_cnt + 1;
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			flush_b0 <= 0;
		else if(init | ~op_en)
			flush_b0 <= 0;
		else if(~wbank_sel & (din_cnt >= dmax_128b))
			flush_b0 <= 1;
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			flush_b1 <= 0;
		else if(init | ~op_en)
			flush_b1 <= 0;
		else if(wbank_sel & (din_cnt >= dmax_128b))
			flush_b1 <= 1;
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			wr_cnt <= 0;
		else if(init)
			wr_cnt <= 1;    // for init_din
		else if(din_valid) begin
			if (wr_cnt != 254)
				wr_cnt <= wr_cnt + 1;
			else
				wr_cnt <= 0;
		end
  end

  always @(posedge wclk or posedge frst) begin
		if (frst)
			wbank_sel <= 0;
		else if(init)
			wbank_sel <= 0;
		else if(op_en) begin
			if(din_valid && (wr_cnt[7:0] == 'd254)) // actual write depth 255
				wbank_sel <= ~wbank_sel;
		end
  end

  always @(posedge wclk or posedge frst) begin
	  if (frst) begin
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
	  end
	  else begin
		  full_b0_cdc <= full_b0;
		  full_b1_cdc <= full_b1;
		  flush_b0_cdc <= flush_b0;
		  flush_b1_cdc <= flush_b1;
		  op_en_cdc <= op_en;
	  end
  end

  always @(posedge rclk or posedge frst) begin
		if (frst)
			rbank_sel <= 0;
		else if(init)
			rbank_sel <= 0;
		else if(op_en_cdc) begin
			if(rd_cnt[9:0] == 'd1019)
				rbank_sel <= ~rbank_sel;
		end
  end

  always @(posedge rclk or posedge frst) begin
		if (frst)
			rbank_sel_d <= 0;
		else begin
			rbank_sel_d[0] <= rbank_sel;
			rbank_sel_d[1] <= rbank_sel_d[0];
		end
  end

  always @(posedge rclk or posedge frst) begin
		if (frst)
			rd_cnt <= 0;
		else if(init)
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
		else if(init)
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
			dout_valid_d <= 0;
		else begin
			dout_valid_d[0] <= rd_en;
			dout_valid_d[1] <= dout_valid_d[0];
		end
   end

  always @(posedge rclk or posedge frst) begin
		if (frst)
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
  assign dout_valid = dout_valid_d[1];

  assign wr_en_b0 = (~wbank_sel) ? (din_valid | init_valid) : 0;
  assign wr_en_b1 = (wbank_sel) ? din_valid : 0;

  assign rd_en_b0 = (~rbank_sel_d[1]) ? rd_en : 0;
  assign rd_en_b1 = (rbank_sel_d[1]) ? rd_en : 0;

  assign dout = (~rbank_sel_d[1]) ? dout_b0 : dout_b1;

  assign din_int = (init_valid) ? init_din : din;

(*mark_debug = "true"*)wire [7:0] fifo0_wr_data_count;
(*mark_debug = "true"*)wire [7:0] fifo1_wr_data_count;
wire [9:0] fifo0_rd_data_count;
wire [9:0] fifo1_rd_data_count;

fifo_generator_0 enc_bank0 (
  //.rst(~nrst),
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
  .almost_empty(),
  .rd_data_count(fifo0_rd_data_count),
  .wr_data_count(fifo0_wr_data_count),
  .wr_rst_busy(),
  .rd_rst_busy()
);

fifo_generator_0 enc_bank1 (
  //.rst(~nrst),
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
  .rd_data_count(fifo1_rd_data_count),
  .wr_data_count(fifo1_wr_data_count),
  .wr_rst_busy(),
  .rd_rst_busy()
);

endmodule
