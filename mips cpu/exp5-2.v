`timescale 1 ns/1 ps
module ram(
    input clk,
    input rst,
    input cs,
    input wrt,
    input rd,
    input [3:0]address,
    input [3:0]data_write,
    output [3:0]data_read
);
reg[3:0] content[15:0];
reg[3:0] word;  
integer i;
always @(posedge clk or posedge rst) begin
    if (cs) begin
        if(rst) begin
            for(i=0;i<16;i=i+1) begin
                content[i]=4'b0000;
            end
        end else if(wrt) begin
            content[address]=data_write;
        end else if(rd) begin
            word = content[address];
        end else begin
            word = 4'bzzzz;
        end
    end 
end
assign data_read = word;
endmodule // 


module BIG_RAM(
    input clk,
    input reset,
    input cs,
    input wrt,
    input rd,
    input [4:0]addr,
    input[7:0] data_write,
    output[7:0]data_read
    );
    wire [7:0] data1;
    wire [7:0] data2;
    ram r0low(clk,reset,~addr[4]&cs,wrt,rd,addr[3:0],data_write[3:0],data1[3:0]);
    ram r0high(clk,reset,~addr[4]&cs,wrt,rd,addr[3:0],data_write[7:4],data1[7:4]);
    ram r1low(clk,reset,addr[4]&cs,wrt,rd,addr[3:0],data_write[3:0],data2[3:0]);
    ram r1high(clk,reset,addr[4]&cs,wrt,rd,addr[3:0],data_write[7:4],data2[7:4]);
    assign data_read= addr[4]?data2:data1;
endmodule

module exp5_td;
    
    reg clk,cs,wrt,rd,rst;
    reg[4:0] addr;
    reg[7:0]data_in;
    wire[7:0] data_out;
    BIG_RAM test(clk,rst,cs,wrt,rd,addr,data_in,data_out);
    initial begin
        repeat(200) begin
            #1 clk = ~clk;
        end
    end
    initial begin
        $dumpfile("exp5_td.vcd");
        $dumpvars(0,exp5_td);
        clk = 0;cs = 0;rst = 0;
        wrt = 0;rd = 0;
        #20 cs = 1;rst = 1;
        #20 rst =0;wrt <= 1;addr <= 5'h1b;
        data_in <= 8'h24;
        #20 addr<= 5'h0a; data_in <=8'h36;
        #20 addr<= 5'h1B; data_in <=8'h68;
        #20 wrt=0; rd = 1;
        addr<= 5'h0a;
        #20 cs = 0; addr = 5'h1b;
        #20 rst = 1;
    end   
endmodule // 