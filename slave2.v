`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// NAME: ARYAN SINGH
// Design Name: SLAVE2
// Project Name: APB-PROTOCOL
// Description: 
//////////////////////////////////////////////////////////////////////////////////


module slave2(
                input PCLK, PRST, PSEL2, PENABLE, PWRITE,
                input [7:0] padd, pwdata,
                output [7:0] prdata2,
                output reg PREADY);
                
    reg [7:0] reg_add;
    reg [7:0] mem2 [63:0];
    
    assign prdata2 = mem2[reg_add];
    
    always @(*) begin
        if(!PRST) PREADY = 0;
        else if(PSEL2 && !PENABLE && !PWRITE) PREADY = 0;
        else if(PSEL2 && !PENABLE && PWRITE) PREADY = 0;
        else if(PSEL2 && PENABLE && !PWRITE) begin PREADY = 1; reg_add = padd; end
        else if(PSEL2 && PENABLE && PWRITE) begin PREADY = 1; mem2[padd] = pwdata; end
        else PREADY = 0;
    end
    
endmodule
