// -----------------------------------------------------------------
// -- 1024word x 80bit 2 port 1 clock SRAM (1R+1W)
// -----------------------------------------------------------------
module TMC_RAM1R1W1C1024WX80B #(
    // Configuration parameters
    parameter   DWIDTH = 32'd80,   // data bit width
    parameter   WDEPTH = 32'd1024, // word depth
    parameter   AWIDTH = 32'd10    // address bit width
)
(
    input                   clk  ,
    // port A (write)
    input   [AWIDTH-1:0]    adra ,
    input                   wea_b,
    input   [DWIDTH-1:0]    dina ,
    // port B (read)
    input   [AWIDTH-1:0]    adrb ,
    input                   oeb_b,
    output  [DWIDTH-1:0]    doutb
);
    //
    wire    [DWIDTH-1:0]    w_doutb;

`ifdef  ASIC_LIB
    //
    // ASIC library
    //

    // TBD

`else
    //
    // Behavioral description library
    //
    ram1r1w #( .DS(DWIDTH), .MS(WDEPTH), .AS(AWIDTH) ) u_ram1r1w (
         .CLKA   (clk    )
        ,.CLKB   (clk    )
        ,.ADRA   (adra   )
        ,.ADRB   (adrb   )
        ,.CSAN   (wea_b  )
        ,.CSBN   (oeb_b  )
        ,.WEAN   (wea_b  )
        ,.OEBN   (oeb_b  )
        ,.SDIA   (dina   )
        ,.SDOB   (w_doutb)
    );
`endif

    //
    // Output read data
    //
    assign doutb = w_doutb;

endmodule

