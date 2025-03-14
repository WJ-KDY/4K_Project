`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/21 14:02:32
// Design Name: 
// Module Name: clk_handler
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


module clk_handler(refclk,resetn, 
		   de_in, // Added on 2023/12/06 by jihan
       		   	pos_74_25, sel_phase, // Added on 2023/12/06 by jihan	
			clk148_5, nclk148_5, clk74_25, clk37_125, clk_37_125, clk18_5625);

    input refclk;
    input resetn;
    input de_in; // Added on 2023/12/06 by jihan
    output pos_74_25; // Added on 2023/12/06 by jihan
    output reg sel_phase; // Added on 2023/12/06 by jihan
    output clk148_5;
    output nclk148_5; // Added on 2023/12/15 by jihan
    output reg clk74_25;
    output reg clk37_125;
    output reg clk_37_125; //Added on 2024/02/19 by KDY
    output reg clk18_5625;
    
    reg rst_1d = 0;
    reg rst_2d = 0;
    reg rst_3d = 0;
    reg [2:0] count = 3'b0;
    
    assign clk148_5 = refclk;
    assign nclk148_5 = ~refclk;
    
    always @ (negedge rst_1d or negedge clk148_5) begin
        if (~rst_1d) begin
            clk74_25 <= 0;
        end
        else begin
            clk74_25 <= ~clk74_25;
        end   
    end
    assign pos_74_25 = clk74_25; // Added on 2023/12/06 by jihan
  
    // Added on 2023/12/06 by jihan 
    reg de_in_1d;
    always @ (posedge clk148_5 or negedge resetn) begin
	if (~resetn) begin 
            de_in_1d <= 0;
        end
	else begin
            de_in_1d <= de_in;
	end
    end
    wire de_st_tr;
    assign de_st_tr = de_in & (~de_in_1d);
    wire tmp_sel_phase;
    assign tmp_sel_phase = de_st_tr & clk74_25;
    always @ (posedge clk148_5 or negedge resetn) begin
	if (~resetn) begin 
            sel_phase <= 1;
        end
	else if (de_st_tr) begin
            sel_phase <= tmp_sel_phase;
	end
    end


    always @ (negedge rst_2d or negedge clk74_25)  begin
        if (~rst_2d) begin
            clk37_125 <= 0;
        end
        else begin
            clk37_125 <= ~clk37_125;
        end   
    end
    
    //Added on 2024/02/19 by KDY to make 37.125MHz 
    always @ (negedge rst_2d or posedge clk74_25)  begin
        if (~rst_2d) begin
            clk_37_125 <= 0;
        end
        else begin
            clk_37_125 <= ~clk_37_125;
        end   
    end
    
    always @ (negedge rst_3d or negedge clk37_125)  begin
        if (~rst_3d) begin
            clk18_5625 <= 0;
        end
        else begin
            clk18_5625 <= ~clk18_5625;
        end   
    end
    
    always @ (posedge refclk or negedge resetn) begin
        
        count <= count + 1'b1;
          
        if (~resetn) begin
        count <= 0;
        rst_1d <= 0;
        rst_2d <= 0;
        rst_3d <= 0;
        end
        
        else if ( count == 3'b001 ) begin
           rst_1d <= 1;
        end
        
        else if ( count ==3'b010 ) begin
           rst_2d <= 1;
        end 
        
        else if ( count ==3'b011 ) begin
           rst_3d <= 1;
        end
        
     end       
      
endmodule
