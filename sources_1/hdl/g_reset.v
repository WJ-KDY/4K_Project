`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/01/18 11:48:44
// Design Name: 
// Module Name: g_reset
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


module g_reset(
		input					freerun,
		input					reset,
		input					c0_ddr_init_done,
		input					c1_ddr_init_done,
		input		[127:0]		gterr,
		input		[127:0]		gtnit,
		input					tx_lockn,
		
		output					o_ddrrst,
		output					o_frcrst,
		output					o_sysrst, // Added on 2023/12/27 by jihan
		output					o_vx1rst,
		output					o_vx1rsttx
    );
	
	localparam RSTM=50000000 * 10;
	localparam RSTM1=1024*32-1;
	
	
	wire	err;
	wire	nit;
	reg		[127:0]		s_gterr ;
	reg		[127:0]		s_gtnit ;
	assign err = |s_gterr;
	assign nit = |s_gtnit;
	
	// reg		[27:0]		init_cnt = 0;
	// reg					init_done = 0;
	
	reg		[2:0]		state = 3'b000;
	reg		[31:0]		t_cnt;
	reg					vx1rst;
	reg		[3:0]		vx1rst_cnt;
	reg					ddrrst		= 1'b0;
	reg					frcrst		= 1'b1;
	reg					vx1rsttx	= 1'b0;
	
	wire	ddr_init_done;
	assign ddr_init_done = c0_ddr_init_done & c1_ddr_init_done;
	/* 
	always @ (posedge freerun) begin 
		if (&init_cnt) init_cnt <= 0;
		else if (ddr_init_done) init_cnt <= init_cnt + 1'b1;
		else init_cnt <= init_cnt;
		if (&init_cnt) init_done <= 1'b1;
		else init_done <= init_done;
	end 
	 */
	 
		// Added on 2023/12/27 by jihan
	reg 	[5:0] 	syscnt;
	always @ (posedge freerun or posedge reset) begin 
		if (reset) begin 
			syscnt <= 0; 
		end 
		else begin 
		 if (syscnt == 6'd15)
			 syscnt <= 6'd15;
		 else 
			 syscnt <= syscnt + 1;
		end
	end

	reg 	 	sysrst; 
	always @ (posedge freerun or posedge reset) begin 
		if (reset) begin 
			sysrst <= 0; 
		end 
		else begin 
		 if ((syscnt >= 6'd8) && (syscnt < 6'd15))
			sysrst <= 1;
		 else 
			sysrst <= 0;
		end
	end
	assign o_sysrst = sysrst;

	 
	always @ (posedge freerun or posedge reset) begin 
		if (reset) begin 
			state <= 0;
			t_cnt <= 0;
			vx1rst_cnt <= 0;
			vx1rst <= 0 ;
			ddrrst <= 1'b0;
			frcrst <= 1'b1;
			vx1rsttx<=1'b0;
		    s_gterr <= 0 ;
		    s_gtnit <= 0 ;			
		// end else if (init_done) begin 
		end else begin 
		    s_gterr <= gterr ;
		    s_gtnit <= gtnit ;
			case (state)
				3'b000 : begin // phy reset
					ddrrst <= 1'b0;
					frcrst <= 1'b1;
					vx1rsttx<=1'b0;
					if (&vx1rst_cnt) begin 
						vx1rst_cnt <= 0;
						vx1rst <= 1'b0;
						state <= 3'b001;
					end else if (vx1rst_cnt[3]) begin 
						vx1rst_cnt <= vx1rst_cnt + 1'b1;
						vx1rst <= 1'b1;
						state <= state;
					end else begin 
						vx1rst_cnt <= vx1rst_cnt + 1'b1;
						vx1rst <= 1'b0;
						state <= state;
					end 
				end 
				3'b001 : begin // wait
					ddrrst <= 1'b0;
					frcrst <= 1'b1;
					vx1rsttx<=1'b0;
					if (t_cnt >= RSTM) begin
						t_cnt <= 0;
						state <= 3'b010;
					end else begin 
						t_cnt <= t_cnt + 1'b1;
						state <= state;
					end 
				end 
				3'b010 : begin // err check
					ddrrst <= 1'b0;
					frcrst <= 1'b1;
					vx1rsttx<=1'b0;
					if (err | nit) begin 
						t_cnt <= 0;
						state <= 3'b000;
					end else if (t_cnt>=RSTM1) begin 
						t_cnt <= 0;
						if (ddr_init_done) begin 
							state <= 3'b011;
						end 
					end else begin 
						t_cnt <= t_cnt + 1'b1;
						state <= state;
					end 
				end 
				3'b011 : begin // ddr , frc block reset
					frcrst <= 1'b1;
					vx1rsttx<=1'b0;
					if (~ddr_init_done) begin 
						ddrrst <= 1'b0;
						state <= 3'b100;
					end else begin 
						ddrrst <= 1'b1;
						state <= state;
					end 
				end 
				3'b100 : begin // frc block reset clear
					ddrrst <= 1'b0;
					frcrst <= 1'b1;
					vx1rsttx<=1'b0;
					if (ddr_init_done) begin 
						state <= 3'b101;
					end else begin 
						state <= state;
					end 
				end 
				3'b101 : begin // done , err wait.
					ddrrst <= 1'b0;
					frcrst <= 1'b0;
					if (err | nit) state <= 3'b000;
					else state <= state;

					if(t_cnt==0 && tx_lockn)
						t_cnt <= 0;
					if(t_cnt < 500*1000*1000)
						t_cnt <= t_cnt+1;
					else
						t_cnt <= 0;
					
					if(t_cnt < 32)
						vx1rsttx <= 1;
					else
						vx1rsttx <= 0;

				end 
				default : begin 
					state <= 0;
					t_cnt <= 0;
					vx1rst_cnt <= 0;
					vx1rst <= 0;
					ddrrst <= 1'b0;
					frcrst <= 1'b1;
				end 
			endcase
		end 
	end 
	assign o_vx1rst 	= vx1rst;
	assign o_ddrrst 	= ddrrst;
	assign o_frcrst 	= frcrst;
	assign o_vx1rsttx	= vx1rsttx;
	
//vio_0 vio_top (
//  .clk(freerun),
//  .probe_in0(reset),
//  .probe_in1(c0_ddr_init_done),
//  .probe_in2(c1_ddr_init_done),
//  .probe_in3(err),
//  .probe_in4(nit),
//  .probe_in5(vx1rst),
//  .probe_in6(ddrrst),
//  .probe_in7(frcrst),
//  .probe_in8(state), // 3
//  .probe_in9(t_cnt), //28
//  .probe_in10(vx1rst_cnt),//4
//  .probe_in11(ddr_init_done)
//);

endmodule
