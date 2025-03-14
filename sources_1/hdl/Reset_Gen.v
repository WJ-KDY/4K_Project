`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:  
// Design Name:   
// Module Name:   
// Project Name: 
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dmd_4lane_exdes
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Reset_Gen # (
	parameter SIMULATION = 0
) (
	input  MMCM_LOCK,
	input  PCLK,
	input  PHYCLK,
	input  LCLK,

	output SYSRESET,
	output PCLK_RESET,
	output PHYCLK_RESET
);

localparam		rst_cnt_max = SIMULATION ? 32'h0000_000f : 32'h003f_ffff;


/* local clock domain */
wire					local_reset;
reg[3:0]				lreset_shift = 4'hf;

/* pixel clock domain */
wire					preset_i;
reg [3:0]  				preset_shift = 4'hf;

/* phy clock domain */
wire					phyreset_i;
reg [3:0]				phyreset_shift = 4'hf;

wire					mmcm_locked;


//assign SYSRESET			= local_reset;
//assign PCLK_RESET		= preset_i;
//assign PHYCLK_RESET		= phyreset_i;
BUFG BUFG_inst0 (.O(SYSRESET),.I(local_reset));
BUFG BUFG_inst1 (.O(PCLK_RESET),.I(preset_i));
BUFG BUFG_inst2 (.O(PHYCLK_RESET),.I(phyreset_i));
assign mmcm_locked		= ~MMCM_LOCK;

reg 	[31:0]				stable_cnt = 0;
reg 						stable_reg = 1'b1;
always @ (posedge LCLK or posedge mmcm_locked) begin 
	if (mmcm_locked) begin 
		stable_cnt <= 0;
		stable_reg <= 1'b1;
	end else begin 
		if (stable_cnt >= rst_cnt_max) stable_cnt <= stable_cnt;
		else stable_cnt <= stable_cnt + 1'b1;
		if (stable_cnt >= rst_cnt_max) stable_reg <= 1'b0;
		else stable_reg <= 1'b1;
	end 
end 

/*pixel clock domain reset generation*/
always @ (posedge LCLK or posedge mmcm_locked) begin
	if (mmcm_locked) lreset_shift <= 4'hf;
	else lreset_shift <= {lreset_shift[2:0],stable_reg};
end

assign local_reset	= lreset_shift[3];

/*pixel clock domain reset generation*/
always @ (posedge PCLK or posedge mmcm_locked) begin
	if (mmcm_locked) preset_shift <= 4'hf;
	else preset_shift <= {preset_shift[2:0],stable_reg};
end

assign preset_i	= preset_shift[3];


/* pclk reset generation */
always @ (posedge PHYCLK or posedge mmcm_locked) begin
	if (mmcm_locked)
		phyreset_shift <= 4'hF; else 
		phyreset_shift <= {phyreset_shift[2:0],stable_reg};
end 

assign     phyreset_i  = phyreset_shift[3];



endmodule

