`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// NAME: ARYAN SINGH
// Design Name: SLAVE1
// Project Name: APB-PROTOCOL
// Description:  
//////////////////////////////////////////////////////////////////////////////////

module slave1 (
    input        PCLK,
    input        PRST,
    input        PSEL1,
    input        PENABLE,
    input        PWRITE,
    input  [7:0] padd1,
    input  [7:0] PWDATA,
    output [7:0] prdata1,
    output reg       PREADY
);
    reg [7:0] reg_add;
    reg [7:0] mem1 [63:0];
    
    assign prdata1 = mem1[reg_add];
    
    always @(*) begin
        if(!PRST) PREADY = 0;
        else if(PSEL1 && !PENABLE && !PWRITE) PREADY = 0;
        else if(PSEL1 && !PENABLE && PWRITE) PREADY = 0;
        else if(PSEL1 && PENABLE && !PWRITE)begin PREADY = 1; reg_add = padd1; end
        else if(PSEL1 && PENABLE && PWRITE) begin PREADY = 1; mem1[padd1] = PWDATA; end
        else PREADY = 0;
    end
    
endmodule
