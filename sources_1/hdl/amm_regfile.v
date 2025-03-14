`timescale 1 ns /100 ps

module amm_regfile #(
    parameter   BUILD_DATE              = 32'h20231010,
    parameter   SI5386_1ST_BASE_ADDR    = 4,
    parameter   SI5386_1ST_CON_ADDR     = 5,
    parameter   SI5386_1ST_BAUD_ADDR    = 6,
    parameter   SI5386_2ND_BASE_ADDR    = 8,
    parameter   SI5386_2ND_CON_ADDR     = 9,
    parameter   SI5386_2ST_BAUD_ADDR    = 10)(
    nreset,   
    aclk,
    M_AVALON_address,
    M_AVALON_read,
    M_AVALON_readdata,
    M_AVALON_readdatavalid,
    M_AVALON_waitrequest,
    M_AVALON_write,
    M_AVALON_writedata,
    RX_RSVD,
    PCLK_FREQ,
    SI5386_1ST_cs ,  
    SI5386_1ST_sck ,  
    SI5386_1ST_sdo ,  
    SI5386_1ST_sdi ,
    SI5386_1ST_rstn ,
    SI5386_1ST_pdn ,
    SI5386_1ST_LOCK ,
    SI5386_1ST_oen, 
    SI5386_1ST_sync,
    
    SI5386_2ND_cs ,  
    SI5386_2ND_sck ,  
    SI5386_2ND_sdo ,  
    SI5386_2ND_sdi ,
    SI5386_2ND_rstn ,
    SI5386_2ND_pdn ,
    SI5386_2ND_LOCK ,
    SI5386_2ND_oen, 
    SI5386_2ND_sync);
    
input   nreset ;
input   aclk ; 

input   [13:0]	M_AVALON_address;
input           M_AVALON_read;
output  [31:0]  M_AVALON_readdata;
output 			M_AVALON_readdatavalid;
output 			M_AVALON_waitrequest;
input 			M_AVALON_write;
input   [31:0]  M_AVALON_writedata;

input  [1:2]  RX_RSVD;
input  [31:0] PCLK_FREQ;
output SI5386_1ST_cs ;  
output SI5386_1ST_sck ;  
input  SI5386_1ST_sdo ;  
output SI5386_1ST_sdi ;
output SI5386_1ST_rstn ;
output SI5386_1ST_pdn ;
input  SI5386_1ST_LOCK ;
output SI5386_1ST_oen ; 
output SI5386_1ST_sync ; 

output SI5386_2ND_cs ;  
output SI5386_2ND_sck ;  
input  SI5386_2ND_sdo ;  
output SI5386_2ND_sdi ;
output SI5386_2ND_rstn ;
output SI5386_2ND_pdn ;
input  SI5386_2ND_LOCK ;
output SI5386_2ND_oen ; 
output SI5386_2ND_sync ; 

reg [31:0]	M_AVALON_readdata_i[0:0];
reg 		M_AVALON_readdatavalid;

reg [31:0] 	mem_hw [0:63] ;

wire [31:0] SI5386_1ST_reg ;
wire [7:0] 	baud_reg ;
reg 		SI5386_1ST_wr ;
wire [7:0] 	SI5386_1ST_rd_data ;
wire [3:0] 	SI5386_1ST_w_fifo_data_cnt ;
wire [3:0] 	SI5386_1ST_r_fifo_data_cnt ;
wire 		SI5386_1ST_w_fifo_empty ;
wire 		SI5386_1ST_r_fifo_empty ;

wire [31:0] SI5386_2ND_reg ;
reg 		SI5386_2ND_wr ;
wire [7:0] 	SI5386_2ND_rd_data ;
wire [3:0] 	SI5386_2ND_w_fifo_data_cnt ;
wire [3:0] 	SI5386_2ND_r_fifo_data_cnt ;
wire 		SI5386_2ND_w_fifo_empty ;
wire 		SI5386_2ND_r_fifo_empty ;

reg 		rd_enable ;
reg [13:0] 	r_addr ;

assign SI5386_1ST_reg 	= mem_hw[SI5386_1ST_BASE_ADDR] ;
assign baud_reg 		= mem_hw[SI5386_1ST_BAUD_ADDR] ;

assign SI5386_1ST_rstn 	= mem_hw[SI5386_1ST_CON_ADDR][0];
assign SI5386_1ST_pdn 	= mem_hw[SI5386_1ST_CON_ADDR][1];
assign SI5386_1ST_oen 	= mem_hw[SI5386_1ST_CON_ADDR][2]; 
assign SI5386_1ST_sync 	= mem_hw[SI5386_1ST_CON_ADDR][3]; 	

assign SI5386_2ND_reg 	= mem_hw[SI5386_2ND_BASE_ADDR] ;

assign SI5386_2ND_rstn 	= mem_hw[SI5386_2ND_CON_ADDR][0];
assign SI5386_2ND_pdn 	= mem_hw[SI5386_2ND_CON_ADDR][1];
assign SI5386_2ND_oen 	= mem_hw[SI5386_2ND_CON_ADDR][2]; 
assign SI5386_2ND_sync 	= mem_hw[SI5386_2ND_CON_ADDR][3]; 	


wire [2:0] SI5386_1ST_st ;
assign SI5386_1ST_st = {SI5386_1ST_LOCK, ~SI5386_1ST_w_fifo_empty, ~SI5386_1ST_r_fifo_empty} ; 

wire [2:0] SI5386_2ND_st ;
assign SI5386_2ND_st = {SI5386_2ND_LOCK, ~SI5386_2ND_w_fifo_empty, ~SI5386_2ND_r_fifo_empty} ; 


assign  M_AVALON_waitrequest = 0 ; 
	
integer i ;    
always @ (posedge aclk or negedge nreset)                   
  if (!nreset) 
    begin
	    for(i=0; i<64; i=i+1)begin
			if      (i == SI5386_1ST_BAUD_ADDR ) mem_hw[i] <= 9 ;
			else if (i == SI5386_2ST_BAUD_ADDR ) mem_hw[i] <= 9 ;
			else		 					     mem_hw[i] <= 0 ;
		end			
    end
  else
    begin                                
		if(M_AVALON_write == 1 && M_AVALON_address[13:8] == 0) mem_hw[M_AVALON_address[7:0]] <= M_AVALON_writedata ;
    end  
    
reg [2:0] rd_en_delay ;

always @ (posedge aclk or negedge nreset)                             
  if (!nreset) 
    begin 
       	rd_enable <= 0 ;
       	r_addr <= 0 ; 
       	M_AVALON_readdatavalid <= 0 ;
       	M_AVALON_readdata_i[0] <= 0 ;
       	rd_en_delay <= 0 ;
    end
  else
    begin 
		rd_enable 				<= M_AVALON_read & ~rd_enable ;	   
		r_addr 					<= M_AVALON_address[13:0] ;  
		rd_en_delay 			<= {rd_en_delay[1:0],rd_enable} ; 
		M_AVALON_readdatavalid 	<= rd_en_delay[2] ;
		if(rd_en_delay[1]) 
			begin
                case(r_addr[5:0])
                    0                    : M_AVALON_readdata_i[0] <= BUILD_DATE ;
                    1					 : M_AVALON_readdata_i[0] <= {30'b0, RX_RSVD[1:2]};
                    2					 : M_AVALON_readdata_i[0] <= PCLK_FREQ;
                    SI5386_1ST_BASE_ADDR : M_AVALON_readdata_i[0] <= {21'b0, SI5386_1ST_st,SI5386_1ST_rd_data[7:0]} ;	
                    SI5386_2ND_BASE_ADDR : M_AVALON_readdata_i[0] <= {21'b0, SI5386_2ND_st,SI5386_2ND_rd_data[7:0]} ;					 
                    default 		     : M_AVALON_readdata_i[0] <=  mem_hw[r_addr[7:0]];
                endcase
			end   
    end
    
assign CAP_RDADDR        = (M_AVALON_address[13]) ? M_AVALON_address[12:0] : 0;
assign M_AVALON_readdata = M_AVALON_readdata_i[0]; // | M_AVALON_readdata_i[1];

// SI5386, 1ST
reg 		SI5386_1ST_wr_pre ;
wire 		SI5386_1ST_rd_enable ;
reg [1:0] 	SI5386_1ST_rd_enable_delay ;

assign SI5386_1ST_rd_enable = (M_AVALON_read == 1 && M_AVALON_address[13:0] == SI5386_1ST_BASE_ADDR) ? 1 : 0 ;

always @ (posedge aclk or negedge nreset)                             
  if (!nreset) 
    begin 
       	SI5386_1ST_wr_pre <= 0 ;     
       	SI5386_1ST_wr <= 0 ; 	    	        	         	    	       	       	      	   
    end
  else
    begin 
        SI5386_1ST_wr <= SI5386_1ST_wr_pre ;
        if(M_AVALON_write == 1 && M_AVALON_address[13:0] == SI5386_1ST_BASE_ADDR) SI5386_1ST_wr_pre <= 1 ;
        else SI5386_1ST_wr_pre <= 0 ;
                           
    end  

reg SI5386_1ST_rd_en ;
always @ (posedge aclk or negedge nreset)                             
  if (!nreset) 
    begin 
       	SI5386_1ST_rd_enable_delay <= 0 ;    
       	SI5386_1ST_rd_en <= 0 ;        	        	         	    	       	       	      	   
    end
  else
    begin 
        SI5386_1ST_rd_enable_delay <= {SI5386_1ST_rd_enable_delay[0], SI5386_1ST_rd_enable};
        SI5386_1ST_rd_en <= (SI5386_1ST_rd_enable_delay == 2'b01) ? 1 : 0 ;         
    end 

// SI5386, 2ND
reg SI5386_2ND_wr_pre ;
wire SI5386_2ND_rd_enable ;
reg [1:0] SI5386_2ND_rd_enable_delay ;

assign SI5386_2ND_rd_enable = (M_AVALON_read == 1 && M_AVALON_address[13:0] == SI5386_2ND_BASE_ADDR) ? 1 : 0 ;

always @ (posedge aclk or negedge nreset)                             
  if (!nreset) 
    begin 
       	SI5386_2ND_wr_pre <= 0 ;     
       	SI5386_2ND_wr <= 0 ; 	    	        	         	    	       	       	      	   
    end
  else
    begin 
        SI5386_2ND_wr <= SI5386_2ND_wr_pre ;
        if(M_AVALON_write == 1 && M_AVALON_address[13:0] == SI5386_2ND_BASE_ADDR) SI5386_2ND_wr_pre <= 1 ;
        else SI5386_2ND_wr_pre <= 0 ;
                           
    end  

reg SI5386_2ND_rd_en ;
always @ (posedge aclk or negedge nreset)                             
  if (!nreset) 
    begin 
       	SI5386_2ND_rd_enable_delay <= 0 ;    
       	SI5386_2ND_rd_en <= 0 ;        	        	         	    	       	       	      	   
    end
  else
    begin 
        SI5386_2ND_rd_enable_delay <= {SI5386_2ND_rd_enable_delay[0], SI5386_2ND_rd_enable};
        SI5386_2ND_rd_en <= (SI5386_2ND_rd_enable_delay == 2'b01) ? 1 : 0 ;         
    end 
	
si5386_spi si5386_1st
(
		.nreset(nreset),     
		.aclk(aclk),   
		.addr(SI5386_1ST_reg[20:8]),
		.data(SI5386_1ST_reg[7:0]),
		.control(SI5386_1ST_reg[23:21]),
		.wr(SI5386_1ST_wr),
		.clock_period(baud_reg[7:0]),
		.w_fifo_empty(SI5386_1ST_w_fifo_empty),
        .r_fifo_empty(SI5386_1ST_r_fifo_empty),		
		.w_fifo_data_cnt(SI5386_1ST_w_fifo_data_cnt),
		.r_fifo_rd_data(SI5386_1ST_rd_data[7:0]),
		.r_fifo_rd_en(SI5386_1ST_rd_en),
		.lmk_cs(SI5386_1ST_cs),
		.lmk_sck(SI5386_1ST_sck),
		.lmk_sdio(SI5386_1ST_sdi),
		.lmk_sdo(SI5386_1ST_sdo),
		.lmk_sdio_data(),
		.rd_lmk_sdio(),
		.lmk_sdio_en()		                                                                                                                                          
 );

si5386_spi si5386_2nd
(
		.nreset(nreset),     
		.aclk(aclk),   
		.addr(SI5386_2ND_reg[20:8]),
		.data(SI5386_2ND_reg[7:0]),
		.control(SI5386_2ND_reg[23:21]),
		.wr(SI5386_2ND_wr),
		.clock_period(baud_reg[7:0]),
		.w_fifo_empty(SI5386_2ND_w_fifo_empty),
        .r_fifo_empty(SI5386_2ND_r_fifo_empty),		
		.w_fifo_data_cnt(SI5386_2ND_w_fifo_data_cnt),
		.r_fifo_rd_data(SI5386_2ND_rd_data[7:0]),
		.r_fifo_rd_en(SI5386_2ND_rd_en),
		.lmk_cs(SI5386_2ND_cs),
		.lmk_sck(SI5386_2ND_sck),
		.lmk_sdio(SI5386_2ND_sdi),
		.lmk_sdo(SI5386_2ND_sdo),
		.lmk_sdio_data(),
		.rd_lmk_sdio(),
		.lmk_sdio_en()		                                                                                                                                          
 );
 
endmodule



