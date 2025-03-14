//--------------------------------------------------------------------------
// Module name  : ram1rw
// Description  : SRAM (single port:1RW)
//--------------------------------------------------------------------------

module ram1rw (
    CLK,
    CSN,
    ADR,
    OEN,
    WEN,
    SDI,
    SDO
);
//
parameter   DS = 128;
parameter   MS = 256;
parameter   AS = 8;
//
input               CLK;
input               CSN;
input   [AS-1:0]    ADR;
input               OEN;
input               WEN;
input   [DS-1:0]    SDI;
//
output  [DS-1:0]    SDO;

//
reg     [DS-1:0]    array[0:MS-1];
reg     [DS-1:0]    SDO;

//
// interpretation of commands
//
wire    wra = !CSN & !WEN;          /* write port A */
wire    rda = !CSN & !OEN;          /* read         */

//
// the functionality
//
always @ (posedge CLK) begin
    if (wra) begin
        array[ADR] <= SDI;
    end
end

always @ (posedge CLK) begin
    if (rda) begin
        SDO <= array[ADR];
    end
end

endmodule

