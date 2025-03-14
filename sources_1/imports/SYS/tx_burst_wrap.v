module tx_burst_wrap(nrst, frst, init, dmax, wclk, rclk, din_valid_l0, din_l0, din_valid_l1, din_l1, 
	din_ready_l0, din_ready_l1, dout, dout_valid);
  input nrst;
  input frst;
  input init;
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



  reg l_sel;
  reg [2:0] l_sel_d;
  wire [9:0] rd_cnt_l0;
  wire [9:0] rd_cnt_l1;

  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	l_sel <= 0;
		else if (init)
	         	l_sel <= 0;
		else if(rd_cnt_l0[1:0] == 2) 
	         	l_sel <= 1;
		else if(rd_cnt_l1[1:0] == 2) 
	         	l_sel <= 0;
   end

  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	l_sel_d <= 0;
		else if (init)
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
		else if (init)
	         	dout <= 0;
		else if (~l_sel_d[2])
	         	dout <= userdata_tx_fifo_l0;
		else
	         	dout <= userdata_tx_fifo_l1;
   end

  always @(posedge rclk or posedge frst) begin
		if (frst)
	         	dout_valid <= 0;
		else if (init)
	         	dout_valid <= 0;
		else if (~l_sel_d[2])
	         	dout_valid <= dout_valid_l0;
		else
	         	dout_valid <= dout_valid_l1;
   end

   wire ext_full_b0_l0;
   wire ext_full_b1_l0;

   wire ext_full_b0_l1;
   wire ext_full_b1_l1;

   wire ext_rd_en_l0;
   wire ext_rd_en_l1;
  tx_burst U_TX_BURST_L0 (
  .nrst(nrst),
  .frst(frst),
  .init(init),
  .dmax(dmax),
  .wclk(wclk),    // input wire clka
  .rclk(rclk),    // input wire clkb
  .lane_ren(~l_sel),
  .ext_full_b0(ext_full_b0_l1),
  .ext_full_b1(ext_full_b1_l1),
  .ext_rd_en(ext_rd_en_l1),
  .out_full_b0(ext_full_b0_l0),
  .out_full_b1(ext_full_b1_l0),
  .out_rd_en(ext_rd_en_l0),
  .din_valid(din_valid_l0),      // input wire [0 : 0] wea
  .din(din_l0),    // input wire [127 : 0] dina
  .din_ready(din_ready_l0),
  .out_rd_cnt(rd_cnt_l0),
  .dout(userdata_tx_fifo_l0),  // output wire [31 : 0] doutb
  .dout_valid(dout_valid_l0)
);

  tx_burst U_TX_BURST_L1 (
  .nrst(nrst),
  .frst(frst),
  .init(init),
  .dmax(dmax),
  .wclk(wclk),    // input wire clka
  .rclk(rclk),    // input wire clkb
  .lane_ren(l_sel),
  .ext_full_b0(ext_full_b0_l0),
  .ext_full_b1(ext_full_b1_l0),
  .ext_rd_en(1'b0),
  .out_full_b0(ext_full_b0_l1),
  .out_full_b1(ext_full_b1_l1),
  .out_rd_en(ext_rd_en_l1),
  .din_valid(din_valid_l1),      // input wire [0 : 0] wea
  .din(din_l1),    // input wire [127 : 0] dina
  .din_ready(din_ready_l1),
  .out_rd_cnt(rd_cnt_l1),
  .dout(userdata_tx_fifo_l1),  // output wire [31 : 0] doutb
  .dout_valid(dout_valid_l1)
);
endmodule
