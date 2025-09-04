`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// NAME: ARYAN SINGH
// Design Name: SLAVE2
// Project Name: APB-PROTOCOL
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module slave2(
                input PCLK, PRST, PSEL, PENABLE, PWRITE,
                input [7:0] padd, pwdata,
                output [7:0] prdata2,
                output reg PREADY);
                
    reg [7:0] reg_add;
    reg [7:0] mem2 [63:0];
    
    assign prdata = mem2[reg_add];
    
    always @(*) begin
        if(!PRST) PREADY = 0;
        else if(PSEL && !PENABLE && !PWRITE) PREADY = 0;
        else if(PSEL && !PENABLE && PWRITE) PREADY = 0;
        else if(PSEL && PENABLE && !PWRITE) PREADY = 1;
        else if(PSEL && PENABLE && PWRITE) PREADY = 1;
        else PREADY = 0;
    end
    
endmodule
