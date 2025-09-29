`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// NAME: ARYAN SINGH
// Design Name: APB MASTER MODULE
// Project Name: APB-PROTOCOL
// Description:  
//////////////////////////////////////////////////////////////////////////////////


module apb_master(
        input PCLK, PRST, transfer, RD_WR, PREADY,
        input [8:0] apb_wr_padd, apb_rd_padd,
        input [7:0] apb_wr_data,
        input [7:0] prdata,
        output reg [7:0] apb_rd_data_out,
        output reg PWRITE, PENABLE,
        output PSEL1, PSEL2,
        output reg [8:0] padd,
        output reg [7:0] pwdata,
        output PSLVERR
    );
    
    
    reg [2:0] state, nstate;

    reg setup_error,
        invalid_setup_error,
        invalid_read_paddr,
        invalid_write_paddr,
        invalid_write_data;
    
    localparam idle = 2'b00, setup = 2'b01, access = 2'b10, enable = 2'b11;
    

    
    always @(posedge PCLK or negedge PRST) begin
        if(!PRST) begin     // ACTIVE LOW SIGNAL
            state <= idle;
        end
        else state <= nstate;
    end
    
    always @(state, transfer, PREADY) begin
        if(!PRST) begin
            nstate <= idle;
        end
        else begin
            PWRITE = ~RD_WR;
            case(state)
                idle: begin
                    PENABLE = 0;
                    if(!transfer) nstate <=  idle;
                    else nstate <= setup;
                end
                
                setup: begin
                    PENABLE = 0;
                    if(RD_WR)begin
                        padd <= apb_rd_padd;
                    end
                    else begin
                        padd <= apb_wr_padd; 
                        pwdata = apb_wr_data;
                    end
                    
                    if(transfer && !PSLVERR) begin
                        nstate <= enable;
                    end
                    else begin
                    nstate <= idle;
                    end
                end
                
                enable: begin
                    if(PSEL1 || PSEL2) begin
                        PENABLE = 1;
                        if(transfer && !PSLVERR) begin
                            if(PREADY) begin
                                if(RD_WR) begin
                                    apb_rd_data_out <= prdata; nstate <= setup;
                                end
                                else nstate <= setup;
                            end
                            else nstate <= enable;
                        end
                        else nstate <= idle;
                    end
                end
            endcase
        end
    end


    
    assign {PSEL1,PSEL2} = ((state != idle) ? (padd[8] ? {1'b0,1'b1} : {1'b1,1'b0}) : 2'd0);
    
    always @(*) begin
        if(!PRST) begin
            setup_error = 0;
            invalid_setup_error = 0;
            invalid_read_paddr = 0;
            invalid_write_paddr = 0;
            invalid_write_data = 0;
        end
        else begin
                begin
                    if(state == idle && nstate == enable) setup_error = 1;
                    else setup_error = 0;
                end
                begin
                    if((apb_wr_data == 8'dx) && (!RD_WR) && (state == setup || state == enable)) begin
                        invalid_write_data = 1;
                    end
                    else invalid_write_data = 0;
                end
                begin
                    if((apb_rd_padd == 9'dx) && (RD_WR) && (setup == setup || setup ==  enable)) begin
                        invalid_read_paddr = 1;
                    end
                    else invalid_read_paddr = 0;
                end
                begin 
                    if((apb_wr_padd == 9'dx)&& (!RD_WR) && (state == setup || state == enable)) begin
                        invalid_write_paddr = 1;
                    end
                    else invalid_write_paddr = 0;
                end
                // NOW CHECKING FOR THE DATA AND ADDR IN WR & RD OPERATION
                if(state == setup) begin
                    if(RD_WR) begin
                        if(padd == apb_rd_padd) begin setup_error = 0; end
                        else begin setup_error = 1; end
                    end
                    else begin
                        if(padd == apb_wr_padd && pwdata == apb_wr_data) setup_error = 0;
                        else setup_error = 1;
                    end
                end
                else setup_error = 0;
        end
        invalid_setup_error = setup_error ||  invalid_read_paddr || invalid_write_data || invalid_write_paddr  ;
    end
   
assign PSLVERR = invalid_setup_error;
   
    
endmodule

