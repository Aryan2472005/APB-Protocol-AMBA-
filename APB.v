`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// NAME: ARYAN SINGH
// Design Name: APB2 PROTOCOL TOP MODULE
// Project Name: APB-PROTOCOL
// Description:  
//////////////////////////////////////////////////////////////////////////////////

module APB(
            input PCLK,
            input PRST,
            input transfer,
            input RD_WR,
            input [8:0] apb_wr_padd, apb_rd_padd,
            input [7:0] apb_wr_data, 
            output [7:0] apb_rd_data_out
    );
    
    wire [7:0] PRDATA, PRDATA1, PRDATA2, PWDATA;
    wire [8:0] PADDR;
    wire PREADY, PREADY1, PREADY2, PSEL1, PSEL2, PWRITE, PENABLE, PSLVERR;
    
    assign PREADY = PADDR[8] ? PREADY2 : PREADY1 ;
    assign PRDATA = (RD_WR) ? (PADDR[8] ? PRDATA2 : PRDATA1) : 8'dx ;
    
    apb_master master_inst(PCLK, PRST, transfer, RD_WR, PREADY, apb_wr_padd, apb_rd_padd, apb_wr_data,
                     PRDATA, apb_rd_data_out, PWRITE, PENABLE, PSEL1, PSEL2, PADDR, PWDATA, PSLVERR);
    slave1 s1(PCLK, PRST, PSEL1,PENABLE, PWRITE, PADDR[7:0], PWDATA, PRDATA1, PREADY1);
    slave2 s2(PCLK, PRST, PSEL2,PENABLE, PWRITE, PADDR[7:0], PWDATA, PRDATA2, PREADY2);

endmodule
