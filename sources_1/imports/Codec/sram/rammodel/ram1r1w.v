//--------------------------------------------------------------------------
// Module name  : ram1r1w
// Description  : SRAM (2port:1R/1W)
//--------------------------------------------------------------------------

module ram1r1w (
    CLKA,
    CSAN,
    ADRA,
    WEAN,
    SDIA,
    CLKB,
    CSBN,
    ADRB,
    OEBN,
    SDOB
);
//
parameter   DS = 128;
parameter   MS = 256;
parameter   AS = 8;
// input (port A)
input               CLKA;
input               CSAN;
input   [AS-1:0]    ADRA;
input               WEAN;
input   [DS-1:0]    SDIA;
// input (port B)
input               CLKB;
input               CSBN;
input   [AS-1:0]    ADRB;
input               OEBN;
// output (port B)
output  [DS-1:0]    SDOB;

//
reg     [DS-1:0]    array[0:MS-1];
reg     [DS-1:0]    SDOB;

//
// interpretation of commands
//
wire    wra = !CSAN & !WEAN;    /* write port A */
wire    rdb = !CSBN & !OEBN;    /* read         */


//
// the functionality
//
always @ (posedge CLKA) begin
    if (wra) begin
        array[ADRA] <= SDIA;
    end
end

always @ (posedge CLKB) begin
    if (rdb) begin
        SDOB <= array[ADRB];
    end
end

endmodule
