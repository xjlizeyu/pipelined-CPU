`timescale 1 ns/1 ps
module rom(
    input clk,
    input wrt,
    input rst,
    input rd,
    input cs,
    input [3:0]data_write,
    input [3:0]address,
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

module exp5_td;
reg clk,rst,wrt,rd,cs;
reg [3:0] address,data_in;
wire[3:0] data_out;

rom test(clk,wrt,rst,rd,cs,data_in,address,data_out);
initial begin
    repeat(100)  begin
        #10 clk = ~clk;
    end
end
initial begin
    clk = 0;rd = 0;address = 4'h0;
    rst = 1;cs = 0;wrt = 0;data_in = 4'h0;
    $dumpfile("exp5_td.vcd");
    $dumpvars(0,exp5_td);
    #50 cs = 1;wrt = 1;rst = 0;
    data_in = 4'b1011; address = 4'h9;
    #50 data_in <= 4'b0011; address <= 4'hB;
    #50 data_in <= 4'b1111; address <= 4'h5;
    #50 wrt = 0;rd = 1; address = 4'h9;
    #50 address = 4'hA;
    #50 rst = 1;
end
endmodule 