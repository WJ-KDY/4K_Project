// -----------------------------------------------------------------
// -- 1152word x 128bit Single port SRAM (1RW)
// -----------------------------------------------------------------
module TMC_RAM1RW1152WX128B #(
    // Configuration parameters
    parameter   DWIDTH = 32'd128,  // data bit width
    parameter   WDEPTH = 32'd1152, // word depth
    parameter   AWIDTH = 32'd11    // address bit width
)
(
    input                   clk,
    input   [AWIDTH-1:0]    adr,
    input                   we_b,
    input   [DWIDTH-1:0]    din,
    input                   oe_b,
    //
    output  [DWIDTH-1:0]    dout
);
//
wire                    w_cs_b;
wire    [DWIDTH-1:0]    w_dout;

//
assign w_cs_b = we_b & oe_b;

`ifdef  ASIC_LIB
//
// ASIC library
//

// TBD

`else
//
// Behavioral description library
//
ram1rw #( .DS(DWIDTH), .MS(WDEPTH), .AS(AWIDTH) ) u_ram1rw (
    .CLK    (clk    ),
    .ADR    (adr    ),
    .CSN    (w_cs_b ),
    .WEN    (we_b   ),
    .OEN    (oe_b   ),
    .SDI    (din    ),
    .SDO    (w_dout )
);
`endif

//
// Output read data
//
assign dout = w_dout;

endmodule

