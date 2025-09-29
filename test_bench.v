`timescale 1ns / 1ps

module test_bench;
reg PCLK;
reg PRST;
reg transfer;
reg RD_WR;
reg [8:0] apb_wr_padd, apb_rd_padd;
reg [7:0] apb_wr_data;
wire [7:0] apb_rd_data_out;
reg [7:0]data,expected;

APB master_module(
                            .PCLK(PCLK),
                            .PRST(PRST),
                            .transfer(transfer),
                            .RD_WR(RD_WR),
                            .apb_wr_padd(apb_wr_padd),
                            .apb_rd_padd(apb_rd_padd),
                            .apb_wr_data(apb_wr_data),
                            .apb_rd_data_out(apb_rd_data_out)
);

integer i,j;

////////// clk ///////////////
initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
end

///////// rst ///////////////
initial begin
    PRST = 0;
    # 10 PRST = 1;
end

///////// read amd write slave 1 ////////////
initial begin
transfer = 0;
#10 transfer = 1;
RD_WR = 0;
apb_wr_padd = 9'd63;
apb_wr_data = 9'd24;
#50
@(posedge PCLK) RD_WR = 1; PRST = 0; transfer = 0;
 #100
 @(posedge PCLK) PRST = 1;
 
repeat(3) @(posedge PCLK) begin transfer = 1;apb_rd_padd = 9'd63; end
end

///////////// read and write slave 2/////////////////////
initial begin
transfer = 0;
#10 transfer = 1;
RD_WR = 0;
apb_wr_padd = 9'b100111101;
apb_wr_data = 9'd24;
//write_slave2;
#50
@(posedge PCLK) RD_WR = 1; PRST = 0; transfer = 0;
 #100
 @(posedge PCLK) PRST = 1;
 
repeat(3) @(posedge PCLK) begin transfer = 1;apb_rd_padd = 9'b100111101; end
//repeat(2) @(posedge PCLK) ;;

 //@(negedge PCLK)      write_slave1;  
end



////////read//////////
//initial begin
// @(posedge PCLK) RD_WR = 1; PRST = 0; transfer = 0;
// @(posedge PCLK) PRST = 1;
//repeat(3) @(posedge PCLK) transfer = 1;
////repeat(2) @(posedge PCLK) RD_slave1;
//end


task write_slave1;

for (i = 0; i < 8; i=i+1) begin
	
        begin    
        RD_WR = 0;
             	data = i;
		apb_wr_data = 2*i;
		apb_wr_padd =  {1'b0,data};
end
end
endtask

task RD_slave1;
    for(j=0; j<8; j=j+1) begin
        data = j;
        apb_rd_padd = {1'b1, data};
        end
endtask

task write_slave2;

for (i = 0; i < 8; i=i+1) begin
	
        begin    
        RD_WR = 0;
             	data = i;
		apb_wr_data = 2*i;
		apb_wr_padd =  {1'b1,data};
end
end
endtask

endmodule

