`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2024 04:45:37 PM
// Design Name: 
// Module Name: jesd
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


module jesd(
	//user interface signal 	
	m_axis_rx_tdata_i,m_axis_rx_tdata_q,
	s_axis_tx_tdata_i,s_axis_tx_tdata_q,
	usr_gain_dw_i,usr_gain_dw_q,
	usr_gain_up_i,usr_gain_up_q,
	clk_110m,
	jesd_link_up,
	//jesd interface signal 	
	clk_220m,
	rxoutclk,
	pll_lock,axi_resetn,
	mgtrefclk0_130_p,	mgtrefclk0_130_n,
	rxn_in	,rxp_in,
	txn_out	,txp_out,
	rx_sync_n	,rx_sync_p,
	tx_sync_n	,tx_sync_p,
	sysref_n	,sysref_p,
	rfsoc_jesd_loopback,
	vx1_jesd_loopback,
	gain_dw_i,gain_dw_q,
	gain_up_i,gain_up_q
    );
output [223:0] m_axis_rx_tdata_i,m_axis_rx_tdata_q;
input  [223:0] s_axis_tx_tdata_i,s_axis_tx_tdata_q;
input  clk_110m,clk_220m;
output rxoutclk;
input  usr_gain_dw_i,usr_gain_dw_q;
input  usr_gain_up_i,usr_gain_up_q;
output jesd_link_up;

input   pll_lock,axi_resetn;
input	mgtrefclk0_130_p,	mgtrefclk0_130_n	;
output	rx_sync_n,			rx_sync_p	;
input	tx_sync_n,			tx_sync_p	;
input	sysref_n,			sysref_p	;
input	[7:0]rxn_in,		rxp_in;
output	[7:0]txn_out,		txp_out;
output	rfsoc_jesd_loopback;	
input 	vx1_jesd_loopback;
output  gain_dw_i,gain_dw_q;
output  gain_up_i,gain_up_q;

localparam JDW = 7*32; //224
localparam JDWI = JDW;
localparam JDWQ = JDW+256;
localparam [31:0] ZERO = 0; 

reg [JDW-1:0] m_axis_rx_tdata_i;
reg [JDW-1:0] m_axis_rx_tdata_q;
wire [JDW-1:0] s_axis_tx_tdata_i;
wire [JDW-1:0] s_axis_tx_tdata_q;

wire [JDW-1:0] s_axis_tx_tdata_i0;
wire [JDW-1:0] s_axis_tx_tdata_q0;
reg [JDW-1:0] s_axis_tx_tdata_i1;
reg [JDW-1:0] s_axis_tx_tdata_q1;
reg [JDW-1:0] s_axis_tx_tdata_i2;
reg [JDW-1:0] s_axis_tx_tdata_q2;

wire	jesd_done;
wire [511:0] m_axis_rx_tdata;
reg  [511:0] m_axis_rx_tdata1;
reg  [511:0] m_axis_lb_tdata;
reg          m_axis_rx_tready;
wire         m_axis_rx_tvalid;
reg  [511:0] s_axis_tx_tdata;
wire 		 s_axis_tx_tready;
reg          s_axis_tx_tvalid;

reg	signed [6:0]	cnt_j = -63;
wire        	vio_jesd_tpg;
reg signed [6:0]   jesd_tpg_tx_i[31:0];
reg signed [6:0]   jesd_tpg_tx_q[31:0];
wire 	[6:0]   jesd_tpg_rx_i[31:0];
wire 	[6:0]   jesd_tpg_rx_q[31:0];
integer j;
always @(posedge clk_110m) begin
	if(vio_jesd_tpg) cnt_j <= cnt_j+31;
	else		     cnt_j <= 0;
	
	for(j=0;j<32;j=j+1)begin
		jesd_tpg_tx_i[j] <= cnt_j+j+128/4;
		jesd_tpg_tx_q[j] <= cnt_j+j;
	end
end

genvar g;
generate begin
	for(g=0;g<32;g=g+1)begin
		assign s_axis_tx_tdata_i0[7*(g+1)-1:7*g]	= jesd_tpg_tx_i[g];
		assign s_axis_tx_tdata_q0[7*(g+1)-1:7*g]	= jesd_tpg_tx_q[g];
	end
end
endgenerate

localparam RSTM = 110*1000*1000*5;
reg [31:0] rst_cnt = 0;
reg jesd_ng_rstn = 1;
reg jesd_ng = 0;

always @(posedge clk_110m) begin
	s_axis_tx_tdata_i1	<= s_axis_tx_tdata_i;
	s_axis_tx_tdata_q1	<= s_axis_tx_tdata_q;
	s_axis_tx_tdata_i2	<= vio_jesd_tpg ? s_axis_tx_tdata_i0 : s_axis_tx_tdata_i1;
	s_axis_tx_tdata_q2	<= vio_jesd_tpg ? s_axis_tx_tdata_q0 : s_axis_tx_tdata_q1;
	s_axis_tx_tdata   <= vx1_jesd_loopback ? m_axis_lb_tdata	: {{ZERO,s_axis_tx_tdata_q2[223:128]},{ZERO,s_axis_tx_tdata_i2[223:128]},{s_axis_tx_tdata_q2[127:0],s_axis_tx_tdata_i2[127:0]}};
	s_axis_tx_tvalid  <= vx1_jesd_loopback ? m_axis_rx_tvalid	: 1;
	m_axis_rx_tready  <= vx1_jesd_loopback ? s_axis_tx_tready	: 1;
	m_axis_rx_tdata1  <= m_axis_rx_tdata;
	jesd_ng			  <=  m_axis_rx_tdata[383:352] == 0 && m_axis_rx_tdata[511:480] == 0 ? 0 : 1;
	m_axis_rx_tdata_i <= !jesd_ng ? {m_axis_rx_tdata[351:256],m_axis_rx_tdata[127:000]}:{m_axis_rx_tdata[095:000],m_axis_rx_tdata1[383:256]};
	m_axis_rx_tdata_q <= !jesd_ng ? {m_axis_rx_tdata[479:384],m_axis_rx_tdata[255:128]}:{m_axis_rx_tdata[223:128],m_axis_rx_tdata1[511:384]};
	m_axis_lb_tdata	  <=  {{ZERO,m_axis_rx_tdata_q[223:128]},{ZERO,m_axis_rx_tdata_i[223:128]},{m_axis_rx_tdata_q[127:0],m_axis_rx_tdata_i[127:0]}};
	rst_cnt			<= rst_cnt < RSTM ? rst_cnt + 1 : jesd_ng ? 0 : RSTM;
	jesd_ng_rstn	<= rst_cnt < 128 ? 0 : 1;
end

generate begin
	for(g=0;g<32;g=g+1)begin
		assign jesd_tpg_rx_i[g] = m_axis_rx_tdata_i[7*(g+1)-1:7*g];
		assign jesd_tpg_rx_q[g] = m_axis_rx_tdata_q[7*(g+1)-1:7*g];
	end
end
endgenerate

wire s_axis_aclk;
wire s_axis_aclk_2x;
wire  pll_locked;
wire  qpllref_clk_n,qpllref_clk_p;

assign qpllref_clk_n 	= mgtrefclk0_130_n;
assign qpllref_clk_p 	= mgtrefclk0_130_p;
assign s_axis_aclk		= clk_110m;
assign s_axis_aclk_2x	= clk_220m;
assign pll_locked		= pll_lock;
assign s_axis_aresetn 	= axi_resetn & jesd_ng_rstn;
assign jesd_link_up		= jesd_done & ~jesd_ng;

jesd204b_sub_0 jesd204b_sub_0 (
  .jesd_done(jesd_done),                // output wire [0 : 0] jesd_done
  .m_axis_rx_tdata(m_axis_rx_tdata),    // output wire [511 : 0] m_axis_rx_tdata
  .m_axis_rx_tready(m_axis_rx_tready),  // input wire m_axis_rx_tready
  .m_axis_rx_tvalid(m_axis_rx_tvalid),  // output wire m_axis_rx_tvalid
  .pll_locked(pll_locked),              // input wire pll_locked
  .qpllref_clk_n(qpllref_clk_n),        // input wire [0 : 0] qpllref_clk_n
  .qpllref_clk_p(qpllref_clk_p),        // input wire [0 : 0] qpllref_clk_p
  .rx_sync_n(rx_sync_n),                // output wire [0 : 0] rx_sync_n
  .rx_sync_p(rx_sync_p),                // output wire [0 : 0] rx_sync_p
  .rxn_in(rxn_in),                      // input wire [7 : 0] rxn_in
  .rxoutclk(rxoutclk),                  // output wire [0 : 0] rxoutclk
  .rxp_in(rxp_in),                      // input wire [7 : 0] rxp_in
  .s_axis_aclk(s_axis_aclk),            // input wire s_axis_aclk
  .s_axis_aclk_2x(s_axis_aclk_2x),      // input wire s_axis_aclk_2x
  .s_axis_aresetn(s_axis_aresetn),      // input wire s_axis_aresetn
  .s_axis_tx_tdata(s_axis_tx_tdata),    // input wire [511 : 0] s_axis_tx_tdata
  .s_axis_tx_tready(s_axis_tx_tready),  // output wire s_axis_tx_tready
  .s_axis_tx_tvalid(s_axis_tx_tvalid),  // input wire s_axis_tx_tvalid
  .sysref_n(sysref_n),                  // input wire sysref_n
  .sysref_p(sysref_p),                  // input wire sysref_p
  .tx_sync_n(tx_sync_n),                // input wire tx_sync_n
  .tx_sync_p(tx_sync_p),                // input wire tx_sync_p
  .txn_out(txn_out),                    // output wire [7 : 0] txn_out
  .txp_out(txp_out)                    // output wire [7 : 0] txp_out
);

reg gain_dw_i,gain_dw_q;
reg gain_up_i,gain_up_q;
wire vio_gain_dw_i,vio_gain_dw_q;
wire vio_gain_up_i,vio_gain_up_q;
always @(posedge clk_110m) begin
	gain_dw_i <= vio_gain_dw_i | usr_gain_dw_i;
	gain_dw_q <= vio_gain_dw_q | usr_gain_dw_q;
	gain_up_i <= vio_gain_up_i | usr_gain_up_i;
	gain_up_q <= vio_gain_up_q | usr_gain_up_q;
end

jesd_ila_0 jesd_ila_0 (
	.clk(clk_110m), // input wire clk
	.probe0(s_axis_tx_tdata_i2), // input wire [223:0]  probe0  
	.probe1(s_axis_tx_tdata_q2), // input wire [223:0]  probe1 
	.probe2(s_axis_tx_tready), // input wire [0:0]  probe2 
	.probe3(s_axis_tx_tvalid), // input wire [0:0]  probe3 
	.probe4(m_axis_rx_tdata_i), // input wire [223:0]  probe4 
	.probe5(m_axis_rx_tdata_q), // input wire [223:0]  probe5 
	.probe6(m_axis_rx_tready), // input wire [0:0]  probe6 
	.probe7(m_axis_rx_tvalid),  // input wire [0:0]  probe7
	.probe8(jesd_tpg_tx_i[0]), // input wire [6:0]  probe8 
	.probe9(jesd_tpg_tx_q[0]),  // input wire [6:0]  probe9
	.probe10(jesd_tpg_rx_i[0]), // input wire [6:0]  probe10 
	.probe11(jesd_tpg_rx_q[0])  // input wire [6:0]  probe11
);

jesd_vio_0 jesd_vio_0 (
  .clk(clk_110m),                // input wire clk
  .probe_in0(jesd_done),    // input wire [0 : 0] probe_in0
  .probe_in1(vx1_jesd_loopback),    // input wire [0 : 0] probe_in1
  .probe_in2(rfsoc_jesd_loopback),    // input wire [0 : 0] probe_in2
  .probe_in3(vio_jesd_tpg),    // input wire [0 : 0] probe_in2
  .probe_out0(rfsoc_jesd_loopback),  // output wire [0 : 0] probe_out0
  .probe_out1(vio_gain_dw_i),  // output wire [0 : 0] probe_out0
  .probe_out2(vio_gain_dw_q),  // output wire [0 : 0] probe_out1
  .probe_out3(vio_gain_up_i),  // output wire [0 : 0] probe_out2
  .probe_out4(vio_gain_up_q), // output wire [0 : 0] probe_out3
  .probe_out5(vio_jesd_tpg)       // output wire [0 : 0] probe_out3
);

endmodule

//module jesd204b_sub_0
//   (jesd_done,
//    m_axis_rx_tdata,
//    m_axis_rx_tready,
//    m_axis_rx_tvalid,
//    pll_locked,
//    qpllref_clk_n,
//    qpllref_clk_p,
//    rx_sync_n,
//    rx_sync_p,
//    rxn_in,
//    rxoutclk,
//    rxp_in,
//    s_axis_aclk,
//    s_axis_aclk_2x,
//    s_axis_aresetn,
//    s_axis_tx_tdata,
//    s_axis_tx_tready,
//    s_axis_tx_tvalid,
//    sysref_n,
//    sysref_p,
//    tx_sync_n,
//    tx_sync_p,
//    txn_out,
//    txp_out);
//  output jesd_done;
//  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_rx TDATA" *) output [511:0]m_axis_rx_tdata;
//  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_rx TREADY" *) input m_axis_rx_tready;
//  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis_rx TVALID" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis_rx, TDATA_NUM_BYTES 64, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 110000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *) output m_axis_rx_tvalid;
//  input pll_locked;
//  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 qpllref CLK_N" *) input [0:0]qpllref_clk_n;
//  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 qpllref CLK_P" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME qpllref, CAN_DEBUG false, FREQ_HZ 220000000, BUSIF.BOARD_INTERFACE Custom" *) input [0:0]qpllref_clk_p;
//  output [0:0]rx_sync_n;
//  output [0:0]rx_sync_p;
//  input [7:0]rxn_in;
//  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.RXOUTCLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.RXOUTCLK, FREQ_HZ 220000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) output [0:0]rxoutclk;
//  input [7:0]rxp_in;
//  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.S_AXIS_ACLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.S_AXIS_ACLK, FREQ_HZ 110000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, ASSOCIATED_BUSIF m_axis_rx:s_axis_tx, ASSOCIATED_RESET s_axis_aresetn, INSERT_VIP 0" *) input s_axis_aclk;
//  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.S_AXIS_ACLK_2X CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.S_AXIS_ACLK_2X, FREQ_HZ 220000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input s_axis_aclk_2x;
//  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.S_AXIS_ARESETN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.S_AXIS_ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s_axis_aresetn;
//  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_tx TDATA" *) input [511:0]s_axis_tx_tdata;
//  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_tx TREADY" *) output s_axis_tx_tready;
//  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis_tx TVALID" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axis_tx, TDATA_NUM_BYTES 64, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 110000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *) input s_axis_tx_tvalid;
//  input sysref_n;
//  input sysref_p;
//  input tx_sync_n;
//  input tx_sync_p;
//  output [7:0]txn_out;
//  output [7:0]txp_out;
  
//  endmodule
  
