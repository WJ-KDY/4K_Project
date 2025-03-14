`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/1/3 11:00:0
// Design Name: 
// Module Name: line_selector
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


module line_selector #(
    parameter HEIGHT=2160
) 
(clk, clk_div2, resetn, DE, DE_2line_d, VSYNC, HSYNC, data_in, data_out_f, data_out_s, data_out_h, cnt1920_2d_out, DE_cnt_2d_out, op_en_out, address_12_out, address_34_out, we1_out, data_out1_out, data_in1_out, DE_1d_out );

    input clk; //148.5/168.24 Mhz
    input clk_div2; //74.25/84.24 Mhz
    input resetn;
    (*mark_debug = "true"*)input DE; 
    (*mark_debug = "true"*)input DE_2line_d;
    //input DE_all;
    (*mark_debug = "true"*)input VSYNC; 
    (*mark_debug = "true"*)input HSYNC;
    (*mark_debug = "true"*)input [578:0] data_in;
    (*mark_debug = "true"*)output reg [143:0] data_out_f; // first line
    (*mark_debug = "true"*)output reg [143:0] data_out_s; // second line
    output reg [2:0] data_out_h; // first line 
    output [11:0] DE_cnt_2d_out;  
    output [10:0] cnt1920_2d_out;  
    output [9:0] address_12_out;  
    output [9:0] address_34_out;  
    (*mark_debug = "true"*)output op_en_out;
    (*mark_debug = "true"*)output we1_out;
    output [290:0] data_out1_out;
    output [290:0] data_in1_out;
    (*mark_debug = "true"*)output DE_1d_out;
    
    reg [290:0] data_in1; //spram #1
    reg [290:0] data_in2; //spram #2
    reg [290:0] data_in3; //spram #3
    reg [290:0] data_in4; //spram #4
    
    wire [290:0] data_out1;
    wire [290:0] data_out2;
    wire [290:0] data_out3;
    wire [290:0] data_out4;
    
    reg [290:0] data_out1_d;
    reg [290:0] data_out2_d;
    reg [290:0] data_out3_d;
    reg [290:0] data_out4_d;
    (*mark_debug = "true"*)reg [9:0] address_W ; //480 clk
    (*mark_debug = "true"*)reg [9:0] address_R ; //960 clk
    (*mark_debug = "true"*)reg [9:0] address_12; // address for spram(#1, #2)
    (*mark_debug = "true"*)reg [9:0] address_34; // address for spram(#3, #4)
    (*mark_debug = "true"*)reg       toggle ;
    reg [9:0] address_12_1d;
    reg [9:0] address_34_1d;
    
    (*mark_debug = "true"*)reg WE_1;
    (*mark_debug = "true"*)reg WE_2;
    (*mark_debug = "true"*)reg WE_3;
    (*mark_debug = "true"*)reg WE_4;
 
    (*mark_debug = "true"*)reg DE_1d, VSYNC_1d; 
    (*mark_debug = "true"*)reg DE_2d; 
    (*mark_debug = "true"*)reg DE_3d; 
    
    reg DE_2line_d_1d;
    reg DE_2line_d_2d;
    reg DE_2line_d_3d;
    
   
    (*mark_debug = "true"*)reg op_en;
    
    (*mark_debug = "true"*)reg [11:0] DE_cnt;
    reg [11:0] DE_cnt_1d;
    reg [11:0] DE_cnt_2d;
    reg [11:0] DE_cnt_3d;

    assign DE_cnt_2d_out = DE_cnt_2d;
    assign op_en_out = op_en;
    assign address_12_out = address_12_1d;
    assign address_34_out = address_34_1d;
    assign DE_1d_out = DE_1d;

    wire [578:0]  data_in_buf;
    reg [7:0] in_dpram_wcnt;
    reg [8:0] in_dpram_rcnt;
    reg	      in_dpram_ren;
    reg	      in_dpram_ren_d;
    reg	      in_dpram_rstart;
    wire      DE_buf;

    blk_mem_gen_0 u_in_dpram(
    .clka (clk_div2),
    .addra (in_dpram_wcnt), 
    .dina (data_in), 
    .ena (1'b1),
    .wea (DE),
    //.i_ce (CE),
    //.qspo_ce(1'b1),
    .clkb (clk),
    .enb (in_dpram_ren),
    .addrb (in_dpram_rcnt[8:1]), 
    .doutb (data_in_buf) 
    );
    assign DE_buf = data_in_buf[578];

   // initial condition
   // ----------------------------------------------------------------------------------------------------------------------------
    always @(posedge clk or negedge resetn) begin
     if (~resetn) begin
      op_en <= 0;
     end
     else if (VSYNC) begin
      op_en <= 1;
     end
    end

    (*mark_debug = "true"*)reg [9:0] DE_int_cnt;
    (*mark_debug = "true"*)wire de_err;

    reg de_ff0, de_ff1;
    wire de_f;
    always @(posedge clk or negedge resetn) begin
     if (~resetn) begin
	    de_ff0 <= 'h0;
        de_ff1 <= 'h0;
     end
     else begin
        de_ff0 <= DE;
        de_ff1 <= de_ff0;
     end
    end

    assign de_f = de_ff0 & ~DE;
    assign de_err = de_f & (DE_int_cnt != 10'd480);

    always @(posedge clk or negedge resetn) begin
     if (~resetn) begin
	    DE_int_cnt <= 0;
     end
     else if (op_en) begin
	 //if (DE)
	 if ((DE_buf) | ((DE_int_cnt > 0) && (DE_int_cnt < 479)))
	   DE_int_cnt <= DE_int_cnt + 1;
     else
       DE_int_cnt <= 0;
     end
    end

    reg [9:0] DE_2line_d_int_cnt;

    always @(posedge clk or negedge resetn) begin
     if (~resetn) begin
	 DE_2line_d_int_cnt <= 0;
     end
     else if (op_en) begin
	 if ((DE_2line_d) | ((DE_2line_d_int_cnt > 0) && (DE_2line_d_int_cnt < 479)))
	   DE_2line_d_int_cnt <= DE_2line_d_int_cnt + 1;
         else
           DE_2line_d_int_cnt <= 0;
     end
    end

    always @(posedge clk_div2 or negedge resetn) begin
     if (~resetn) 
	in_dpram_wcnt <= 0;
     else if (DE)
        in_dpram_wcnt <= in_dpram_wcnt + 1;
     else
	in_dpram_wcnt <= 0;
    end

    always @(posedge clk or negedge resetn) begin
     if (~resetn) 
	in_dpram_rstart <= 0;
     else if (de_ff0 & ~de_ff1)
        in_dpram_rstart <=  1;
     else
	in_dpram_rstart <= 0;
    end

    always @(posedge clk or negedge resetn) begin
     if (~resetn) 
	in_dpram_ren <= 0;
     else if (in_dpram_rstart)
        in_dpram_ren <=  1;
     else if (in_dpram_rcnt == 479)
	in_dpram_ren <= 0;
    end

    always @(posedge clk or negedge resetn) begin
     if (~resetn) 
	in_dpram_rcnt <= 0;
     else if (in_dpram_ren)
        in_dpram_rcnt <=  in_dpram_rcnt + 1;
     else 
	in_dpram_rcnt <= 0;
    end

    always @(posedge clk or negedge resetn) begin
     if (~resetn) 
	in_dpram_ren_d <= 0;
     else 
	in_dpram_ren_d <= in_dpram_ren;
    end

    (*mark_debug = "true"*)wire DE_int;
    assign	DE_int = in_dpram_ren_d;

    //wire DE_2line_d_int;
    //assign DE_2line_d_int = (DE_2line_d_int_cnt < 480) ? DE_2line_d : 0;

    reg [1038:0] DE_d;
    reg DE_2line_d_int;
 
    always @(posedge clk) begin
        DE_d[0] <= DE_int;
	DE_d[1038:1] <= DE_d[1037:0];
	DE_2line_d_int <= DE_d[1038];
    end

    always @(posedge clk or negedge resetn) begin
     if (~resetn) begin
      DE_1d <= 0;
      DE_2d <= 0;
      DE_3d <= 0;
      DE_2line_d_1d <= 0;
      DE_2line_d_2d <= 0;
      DE_2line_d_3d <= 0;
      VSYNC_1d <= 0;
     end
     else if (op_en) begin
      //DE_1d <= DE;
      DE_1d <= DE_int;
      DE_2d <= DE_1d;
      DE_3d <= DE_2d;
      //DE_2line_d_1d <= DE_2line_d;
      DE_2line_d_1d <= DE_2line_d_int;
      DE_2line_d_2d <= DE_2line_d_1d;
      DE_2line_d_3d <= DE_2line_d_2d;
      VSYNC_1d <= VSYNC;
     end
    end

    always @(posedge clk or negedge resetn) begin
     if (~resetn) begin
      DE_cnt <= 0;
     end
     else if (VSYNC) begin
      DE_cnt <= 0;
     end
     //else if(op_en & (DE_1d & ~DE))
     else if(op_en & (DE_1d & ~DE_int))
      DE_cnt <= DE_cnt + 1;
    end

    always @(posedge clk or negedge resetn) begin
     if (~resetn) begin
      DE_cnt_1d <= 0;
      DE_cnt_2d <= 0;
      DE_cnt_3d <= 0;
     end
     else if (VSYNC) begin
      DE_cnt_1d <= 0;
      DE_cnt_2d <= 0;
      DE_cnt_3d <= 0;
     end
     else begin
      DE_cnt_1d <= DE_cnt ;
      DE_cnt_2d <= DE_cnt_1d ;
      DE_cnt_3d <= DE_cnt_2d ;
     end
    end

    reg [10:0] count_1920 ;
    reg [10:0] count_1920_1d ;
    reg [10:0] count_1920_2d ;
    reg [10:0] count_1920_3d ;

    assign cnt1920_2d_out = count_1920_2d;

    always @ (posedge clk or negedge resetn) begin 
        if (~resetn) begin
              count_1920 <= 0;
        end
        else if (VSYNC) begin
              count_1920 <= 0;
        end
	else if (op_en) begin
	       	if (DE_int) begin 
	       		count_1920 <= (count_1920 == 4 * 480 - 1) ? 0 : count_1920 + 1;
		end
        end
      end

    reg [10:0] rcount_1920 ;
    reg [10:0] rcount_1920_1d ;
    reg [10:0] rcount_1920_2d ;
    reg [10:0] rcount_1920_3d ;

    always @ (posedge clk or negedge resetn) begin 
        if (~resetn) begin
              rcount_1920 <= 0;
        end
        else if (VSYNC) begin
              rcount_1920 <= 0;
        end
	else if (op_en) begin
        	if (DE_2line_d_int) begin 
        		rcount_1920 <= (rcount_1920 == 4 * 480 - 1) ? 0 : rcount_1920 + 1;
		end
        end
      end
    always @ (posedge clk or negedge resetn) begin 
        if (~resetn) begin
              count_1920_1d <= 0;
              count_1920_2d <= 0;
              count_1920_3d <= 0;
        end
        else if (VSYNC) begin
              count_1920_1d <= 0;
              count_1920_2d <= 0;
              count_1920_3d <= 0;
        end
	else  begin
	      count_1920_1d <= count_1920;
	      count_1920_2d <= count_1920_1d;
	      count_1920_3d <= count_1920_2d;
        end
      end

    always @ (posedge clk or negedge resetn) begin 
        if (~resetn) begin
              rcount_1920_1d <= 0;
              rcount_1920_2d <= 0;
              rcount_1920_3d <= 0;
        end
        else if (VSYNC) begin
              rcount_1920_1d <= 0;
              rcount_1920_2d <= 0;
              rcount_1920_3d <= 0;
        end
	else  begin
	      rcount_1920_1d <= rcount_1920;
	      rcount_1920_2d <= rcount_1920_1d;
	      rcount_1920_3d <= rcount_1920_2d;
        end
      end
     // Data_splitter--------------------------------------------------------------------------------------------------------------
     reg toggle_d = 0;
     reg [287:0] data_splitted;
     reg [287:0] data_splitted_1d;
     
     always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            toggle_d <= 0;
        end
        else if (VSYNC) begin
            toggle_d <= 0;
        end
	else if (op_en) begin
	    if (DE_cnt < HEIGHT) begin
        	//if (DE) 
        	if (DE_int) 
			toggle_d <= ~toggle_d;
		else
            		toggle_d <= 0;
	    end
	    else  begin
        	//if (DE_2line_d) 
        	if (DE_2line_d_int) 
			toggle_d <= ~toggle_d;
		else
            		toggle_d <= 0;
	    end
	end
      end    

     always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            data_splitted <= 0;
        end
        else if (VSYNC) begin
            data_splitted <= 0;
        end
	else if (op_en) begin
       	    if (~toggle_d) begin
                data_splitted <= data_in_buf[575:288];
            end
            else begin
                data_splitted <= data_in_buf[287:0];
            end
        end
      end    
      
      reg [2:0] data_in_h;
     always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            data_in_h <= 0;
        end
        else if (VSYNC) begin
            data_in_h <= 0;
        end
	else if (op_en) begin
                data_in_h <= data_in_buf[578:576];
        end
      end    
     // address_W
     // -------------------------------------------------------------------------------------------------------------------------
       reg address_W_increment_enabled;
     	
       always @(posedge clk or negedge resetn) begin     // address_W for "Write" (0 1 2 3 ... 479 0 1 2 3 ...) : 480 clk cycle
        if (~resetn) begin
            address_W <= 0;
            address_W_increment_enabled <= 0;
        end
        else if (VSYNC) begin
            address_W <= 0;
            address_W_increment_enabled <= 0;
        end
    
        //else if (op_en & DE) begin // origin : address_W_increment_enabled && DE 
        //else if (op_en & DE_int) begin // origin : address_W_increment_enabled && DE 
        else if (op_en & DE_1d) begin // 20241115 
            if (address_W == 479) begin  
                address_W <= 0;
            end
            else begin
                address_W <= address_W + 1;
            end
        end
    end
    //address_R
    //--------------------------------------------------------------------------------------------------------------------------
   
    always @(posedge clk or negedge resetn) begin // address 2 for "Read" (0 0 1 1 2 2 ... 479 479 0 0 ...) : 960 clk cycle
        if (~resetn) begin
            address_R <= 0;
            toggle <= 0;
        end
        else if (VSYNC) begin
            address_R <= 0;
            toggle <= 0;
        end
        //else if (op_en & DE_2line_d) begin  // origin : address_R_increment_enabled && DE
        else if (op_en & DE_2line_d_int) begin  // origin : address_R_increment_enabled && DE
                if (toggle == 1) begin 
                     if (address_R == 479 ) begin
                        address_R <= 0;
                       // WE_12 <= ~WE_12; // WE_A toggle when trigger start (960clk)
                        //WE_34 <= ~WE_34;
                     end 
                     else begin
                       address_R <= address_R + 1;
                     end
                     toggle <= 0;
                end 
                else begin
                    toggle <= toggle + 1;
                end
               end       
           end
    
        //address_R_1f // added on 2024.02.04 by KDY
    //--------------------------------------------------------------------------------------------------------------------------
       
       always @ (posedge clk or negedge resetn) begin 
        if (~resetn) begin
            data_in1 <= 0;
            data_in2 <= 0;
            data_in3 <= 0;
            data_in4 <= 0;
        end
        else if (VSYNC) begin
            data_in1 <= 0;
            data_in2 <= 0;
            data_in3 <= 0;
            data_in4 <= 0;
        end
            
        //else if(op_en & DE_1d) begin //write
        else if(op_en & DE_2d) begin //write 20241115
             
            //if(count_1920_1d < 480) begin 
            if(count_1920_2d < 480) begin 
                    data_in1 <= {1'b1, data_in_h[1:0], data_splitted}; // line_selector 1 Write
            end
            //else if (count_1920_1d >= 480 && count_1920_1d < 960) begin 
            else if (count_1920_2d >= 480 && count_1920_2d < 960) begin 
                    data_in2 <= {1'b1, data_in_h[1:0],data_splitted}; // line_selector 2 Write
            end
            //else if (count_1920_1d >= 960 && count_1920_1d < 1440) begin 
            else if (count_1920_2d >= 960 && count_1920_2d < 1440) begin 
                    data_in3 <= {1'b1, data_in_h[1:0],data_splitted}; // line_selector 3 Write
            end
            //else if (count_1920_1d >= 1440) begin
            else if (count_1920_2d >= 1440) begin
                    data_in4 <= {1'b1, data_in_h[1:0], data_splitted}; //line_selector 4 write
            end
       end
     end    

     always @ (posedge clk or negedge resetn) begin //read
        if (~resetn) begin
            data_out_h <= 0;
            data_out_f <= 0;
            data_out_s <= 0;
        end
        else if (VSYNC) begin
            data_out_h <= 0;
            data_out_f <= 0;
            data_out_s <= 0;
        end
        //else if(op_en & (((DE_cnt_3d > 1) & (DE_cnt_3d < HEIGHT) & DE_3d) || ((DE_cnt_3d >= HEIGHT) & DE_2line_d_3d))) begin //Read
        //else if(op_en & (((DE_cnt_3d > 1) & (DE_cnt_3d < HEIGHT) & DE_int) || ((DE_cnt_3d >= HEIGHT) & DE_2line_d_3d))) begin //Read
        else if(op_en & DE_2line_d_3d) begin //Read
            if(rcount_1920_3d < 960) begin
                    data_out_h <= data_out1[290:288]; // line_selector 3  Read
                    data_out_f <= (rcount_1920_3d[0]  == 0) ? data_out1[143:0] : data_out1[287:144] ;
                    data_out_s <= (rcount_1920_3d[0]  == 0) ? data_out2[143:0] : data_out2[287:144] ;
                    //end
            end
            else begin                    
                    data_out_h <= data_out3[290:288] ;// line_selector 1  Read
                    data_out_f <= (rcount_1920_3d[0] == 0) ? data_out3[143:0] : data_out3[287:144] ;
                    data_out_s <= (rcount_1920_3d[0] == 0) ? data_out4[143:0] : data_out4[287:144] ;
                    //end
            end
        end
        else begin
            data_out_h <= 0;
        end
      
    end
        
   //address_12 (spram #1, #2)
   //----------------------------------------------------------------------------------------------------------------------------
     always @ (posedge clk or negedge resetn) begin
        if (~resetn) begin
              address_12 <= 0;
        end
        else if (VSYNC) begin
              address_12 <= 0;
        end
	else if (op_en) begin
        	if (count_1920_1d < 960) begin // first 960 clk for write
             		address_12 <= address_W; // origin : address_12 <= address_W
        	end
        	else if (count_1920_1d < 1920 && count_1920_1d >= 960) begin // after 960 clk for read
             		address_12 <= address_R; // origin : address_12 <= address_R
        	end	
	end
        
     end
     
     always @ (posedge clk or negedge resetn) begin 
        if (~resetn) begin
            address_12_1d <= 0;
        end
        else begin
            address_12_1d <= address_12;
        end
       end

    //address_34 (spram #3, #4)
    //--------------------------------------------------------------------------------------------------------------------------
     always @ (posedge clk or negedge resetn) begin 
        if (~resetn) begin
              address_34 <= 0;
        end
        else if (VSYNC) begin
              address_34 <= 0;
        end
	else if (op_en) begin
       		if (count_1920_1d < 960) begin
             		address_34 <= address_R;  // origin : address_34 <= address_R
       		end
        	else if (count_1920_1d < 1920 && count_1920_1d >= 960) begin
             		address_34 <= address_W;  // origin : address_34 <= address_W
        	end
	 end
      end   
       
       always @ (posedge clk or negedge resetn) begin 
        if (~resetn) begin
            address_34_1d <= 0;
        end
        else begin
            address_34_1d <= address_34;
        end
       end


   // WE_1
   //-------------------------------------------------------------------------------------------------------------------------------   
      
    always @(posedge clk or negedge resetn) begin
    	if (~resetn) begin
        	WE_1 <= 1'b0;
        	//count_1920 <= 0;
    	end 
    	else if (VSYNC) begin
        	WE_1 <= 1'b0;
        	//count_1920 <= 0;
    	end 
        //else if (op_en & DE) begin // origin : address_R_increment_enabled && DE
        //else if (op_en & DE_int) begin // origin : address_R_increment_enabled && DE
        else if (op_en & DE_1d) begin // 20241115
            	   //if (count_1920 >= 0 && count_1920 <= 479 )  begin // origin : count_1920_14 >= 1 && count_1920_14 <= 480
            	   if (count_1920_1d >= 0 && count_1920_1d <= 479 )  begin // origin : count_1920_1d_14 >= 1 && count_1920_1d_14 <= 480
            	       WE_1 <= 1;
            	   end
                   else begin
                       WE_1 <= 0;
                   end
        end
       //else if (~DE) begin // Added on 2024/02/20 by KDY
       else if (~DE_int) begin // Added on 2024/02/20 by KDY
            WE_1 <= 0;
       end
      end
      
   // WE_2
   //-------------------------------------------------------------------------------------------------------------------------------   
      
     always @(posedge clk or negedge resetn) begin
    	if (~resetn) begin
        	WE_2 <= 1'b0;
    	end 
    	else if (VSYNC) begin
        	WE_2 <= 1'b0;
    	end 
        //else if (op_en & DE) begin // origin : address_R_increment_enabled && DE
        //else if (op_en & DE_int) begin // origin : address_R_increment_enabled && DE
        else if (op_en & DE_1d) begin // 20241115
            	   //if (count_1920 >= 480 & count_1920 <= 959) begin // origin : count_1920_12 >= 481 & count_1920_12 <= 960 bug(1.3)
            	   if (count_1920_1d >= 480 & count_1920_1d <= 959) begin // origin : count_1920_1d_12 >= 481 & count_1920_1d_12 <= 960 bug(1.3)
            	       WE_2 <= 1;
            	   end
                   else begin 
                       WE_2 <= 0;
                   end
        end
       //else if (~DE) begin // Added on 2024/02/20 by KDY
       else if (~DE_int) begin // Added on 2024/02/20 by KDY
            WE_2 <= 0;
       end
      end
      
   // WE_3
   //-------------------------------------------------------------------------------------------------------------------------------   
      
     always @(posedge clk or negedge resetn) begin
    	if (~resetn) begin
        	WE_3 <= 1'b0;
    	end 
    	else if (VSYNC) begin
        	WE_3 <= 1'b0;
    	end 
        //else if (op_en & DE) begin
        //else if (op_en & DE_int) begin
        else if (op_en & DE_1d) begin // 20241115
            	   //if (count_1920 >= 960 & count_1920 <= 1439) begin
            	   if (count_1920_1d >= 960 & count_1920_1d <= 1439) begin
            	       WE_3 <= 1;
            	   end
                   else begin
                       WE_3 <= 0;
                   end
        end
       //else if (~DE) begin // Added on 2024/02/20 by KDY
       else if (~DE_int) begin // Added on 2024/02/20 by KDY
            WE_3 <= 0;
       end
      end
      
   // WE_4
   //-------------------------------------------------------------------------------------------------------------------------------   
      
     always @(posedge clk or negedge resetn) begin
    	if (~resetn) begin
        	WE_4 <= 1'b0;
    	end 
    	else if (VSYNC) begin
        	WE_4 <= 1'b0;
    	end 
        //else if (op_en & DE) begin
        //else if (op_en & DE_int) begin
        else if (op_en & DE_1d) begin // 20241115
            	   //if ((count_1920 >= 1440 && count_1920 <= 1919)) begin // original : count_1920 >= 1440 && count_1920 <= 1919
            	   if ((count_1920_1d >= 1440 && count_1920_1d <= 1919)) begin // original : count_1920_1d >= 1440 && count_1920_1d <= 1919
            	       WE_4 <= 1;
            	   end
                   else begin
                       WE_4 <= 0;
                   end
        end
       //else if (~DE) begin // Added on 2024/02/20 by KDY
       else if (~DE_int) begin // Added on 2024/02/20 by KDY
            WE_4 <= 0;
       end
      end  
      
      reg WE_1d;
      reg WE_2d;
      reg WE_3d;
      reg WE_4d;
      
      always @(posedge clk or negedge resetn) begin
    	if (~resetn) begin 
    	   WE_1d <= 0;
    	   WE_2d <= 0;
    	   WE_3d <= 0; 
           WE_4d <= 0;
        end
        else begin
           WE_1d <=WE_1; 
           WE_2d <=WE_2; 
           WE_3d <=WE_3; 
           WE_4d <=WE_4;
        end
      end
      
    // data_out_f,s 
    
    /*assign data_out_f = data_out_h[143:0];
    assign data_out_s = data_out_s_all[143:0];*/
    
            	   
    //SPRAM
    //---------------------------------------------------------------------------------------------------------------------------
    dist_mem_gen_0 dist_mem_gen_0_1(
    .a (address_12_1d), 
    .d (data_in1), 
    .clk (clk),
    .we (WE_1d),
    //.i_ce (CE),
    //.qspo_ce(1'b1),
    .qspo (data_out1) 
    );
    
    dist_mem_gen_0 dist_mem_gen_0_2(
    .a (address_12_1d), 
    .d (data_in2), 
    .clk (clk),
    .we (WE_2d),
    //.i_ce (CE),
    //.qspo_ce(1'b1),
    .qspo (data_out2) 
    );
    
    dist_mem_gen_0 dist_mem_gen_0_3(
    .a (address_34_1d), 
    .d (data_in3), 
    .clk (clk),
    .we (WE_3d),
    //.i_ce (CE),
    //.qspo_ce(1'b1),
    .qspo (data_out3) 
    );
    
     dist_mem_gen_0 dist_mem_gen_0_4(
    .a (address_34_1d), 
    .d (data_in4), 
    .clk (clk),
    .we (WE_4d),
    //.i_ce (CE),
    //.qspo_ce(1'b1),
    .qspo (data_out4) 
    );

    assign we1_out = WE_1d;
    assign data_in1_out = data_in1;
    assign data_out1_out = data_out1;
  endmodule
