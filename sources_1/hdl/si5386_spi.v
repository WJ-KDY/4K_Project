
module si5386_spi
(
		nreset,     
		aclk,   
		addr,
		data,
		control,
		wr,
		clock_period,
		w_fifo_empty,
		r_fifo_empty,
		w_fifo_data_cnt,
		r_fifo_rd_data,
		r_fifo_rd_en,
		lmk_cs,
		lmk_sck,
		lmk_sdio,
		lmk_sdo,
		lmk_sdio_data,
		rd_lmk_sdio,
		lmk_sdio_en		                                                                                                                                          
 );

input nreset ;     
input aclk ;   

input [12:0] addr ;
input [7:0]  data ;
input [2:0]  control ;
input        wr ;
input [7:0]  clock_period ;
output 		 w_fifo_empty ;
output 		 r_fifo_empty ;
output [3:0] w_fifo_data_cnt ;
output [7:0] r_fifo_rd_data;
input 		 r_fifo_rd_en ;
output 		 lmk_cs ;  
output 		 lmk_sck ;  
output       lmk_sdio;
input        lmk_sdo ;  
output       lmk_sdio_data ;
output       rd_lmk_sdio ;
output       lmk_sdio_en ;

reg  lmk_cs 		= 1;  
reg  lmk_sck_i 		= 1;  
reg  lmk_sdio_en	= 0;
reg  lmk_sdio_data	= 1;

reg [3:0] w_st ;
reg wr_fifo ;
reg [23:0] wr_fifo_data ;
wire w_fifo_empty ;
wire r_fifo_empty ;
reg wr_fifo_rd_en ;
wire [23:0] w_fifo_rd_data ;    	 	   	       
reg [7:0] idle_cnt ;  
reg [23:0] tx_shift ;
reg [4:0] tx_length	;
reg wr_flag ;
reg [7:0] rx_data ;
reg [7:0] r_fifo_data ;	
reg rd_lmk_sdio ;
reg [1:0] wr_delay ;
		
//assign lmk_sdio = (lmk_sdio_en == 0) ? lmk_sdio_data : 1'bz ;
assign lmk_sdio = lmk_sdio_data | lmk_cs;
assign lmk_sck	= lmk_sck_i;
always @ (posedge aclk or negedge nreset)                             
  if (!nreset) 
    begin 

		wr_fifo_data <= 0 ;
		wr_fifo <= 0 ;
		rd_lmk_sdio <= 0 ;
		wr_delay <= 0 ;
    end
  else
    begin 
		//wr_fifo <= wr ;
        wr_delay <= {wr_delay[0], wr} ;
		wr_fifo <= (wr_delay == 2'b01)  ? 1 : 0 ;//wr ;
		rd_lmk_sdio <= lmk_sdo ;		
		if(wr == 1) wr_fifo_data <= {control,addr,data} ;
    end  

always @ (posedge aclk or negedge nreset)                             
  if (!nreset) 
    begin 
       	w_st <= 0 ;   
		wr_fifo_rd_en <= 0 ;
		lmk_cs <= 1;
		lmk_sck_i <= 1 ;
		lmk_sdio_en <= 1 ;	
		idle_cnt <= 0 ;	
		tx_shift <= 0 ;
		tx_length <= 0 ;
		lmk_sdio_data <= 0 ;
		wr_flag <= 0 ;
		rx_data <= 0 ;	
		r_fifo_data <= 0 ;		
    end
  else
    begin 
	    if(idle_cnt < clock_period) idle_cnt <= idle_cnt + 1 ;
		else 
		    begin
			    idle_cnt <= 0 ;
				lmk_sck_i <= ~lmk_sck_i ;
			end
		
		
		case(w_st)
			0 : begin
					if(w_fifo_empty == 0) 
						begin
							w_st <= w_st + 1 ;
							wr_fifo_rd_en <= 1 ;	
						
						end
				end
			1 : begin
					w_st <= w_st + 1 ;
					wr_fifo_rd_en <= 0 ;
				end	
			2 : begin
					// w_st <= w_st + 1 ;
					// lmk_cs <= 0 ;
					
					if(idle_cnt == clock_period && lmk_sck_i == 1)
					    begin
							w_st <= w_st + 1 ;
					        lmk_cs <= 0 ;
							tx_shift <= w_fifo_rd_data ;
							lmk_sdio_data <= w_fifo_rd_data[15] ;
							wr_flag <= w_fifo_rd_data[15] ; 
					        tx_length <= 0 ;	
					        rx_data <= 0 ;							
						end
				end	
			3 : begin
					if(idle_cnt == clock_period && lmk_sck_i == 0)	// 	lmk_sck_i = 1
                       begin
					       tx_length <= tx_length + 1 ;
						   tx_shift <= {tx_shift[22:0],1'b0} ;
						   if(tx_length >= 15) w_st <= 5 ;
						   else w_st <= w_st + 1 ;
						   if(tx_length >= 8) rx_data <= {rx_data[6:0],rd_lmk_sdio} ;							   
                       end					   
				end	
			4 : begin
					if(idle_cnt == clock_period && lmk_sck_i == 1)	// 	lmk_sck_i = 0
                       begin
					       w_st <= 3 ;
					       lmk_sdio_data <= tx_shift[15] ;	
						   if(wr_flag == 1)
							   begin
								   if(tx_length == 8) lmk_sdio_en <= 1 ;
							   end
                       end	
				end					
			5 : begin
                    if(idle_cnt == clock_period && lmk_sck_i == 1)	// 	lmk_sck_i = 0
                        begin
                            w_st <= w_st + 1 ;
						    if(wr_flag == 1)
                                begin
                                    r_fifo_data <= rx_data ;
                                end                                
                        end                    
                    end				
			6 : begin
			        if(idle_cnt > (clock_period >> 2)) 
					    begin
						    lmk_cs <= 1 ;
							w_st <= w_st + 1 ;
						end				
				end	
			7,8,9 : begin
                    if(idle_cnt == clock_period && lmk_sck_i == 0)	// 	lmk_sck_i = 1
                         begin
                              w_st <= w_st + 1 ;
                         end                    
                end                                                                            								
			default : begin
							w_st <= 0 ;	
                            wr_flag <= 0 ;							
						end
			
		endcase		
    end  

spi_fifo_wrapper spi_fifo
   (
	.FIFO_READ_empty(w_fifo_empty),
    .FIFO_READ_rd_data(w_fifo_rd_data),
    .FIFO_READ_rd_en(wr_fifo_rd_en),
    .FIFO_WRITE_full(),
    .FIFO_WRITE_wr_data(wr_fifo_data),
    .FIFO_WRITE_wr_en(wr_fifo),
	.rd_data_count(),
	.wr_data_count(w_fifo_data_cnt),	
    .rd_clk(aclk),
    .rst(~nreset),
    .wr_clk(aclk)
	);

assign r_fifo_rd_data = r_fifo_data ;
assign r_fifo_empty = 0 ;
	
endmodule

