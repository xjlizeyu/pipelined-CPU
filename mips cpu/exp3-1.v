`timescale 1 ns/1 ps
module Dtrigger(
    input  wire din,
    input  wire clk,
    input  wire reset,
    output reg dout,
    input wire enabler
);
always @(posedge clk) begin
    if (enabler==1'b1) begin
        
    end else begin
        if(reset==1'b1)begin
            dout<=1'b0;
        end else begin
            dout<=din;
        end
    end

end

endmodule // Dtriggerinput  wire din,
module exp3_td;
    reg clk;
    reg d;
    wire out;
    reg r;
    reg g;
    Dtrigger test(d,clk,r,out,g);
    
    initial begin
        $dumpfile("exp3_td.vcd");
        $dumpvars(0,exp3_td);
    end
    initial begin
        clk = 0;
        repeat(20)begin
            #1 clk=0;
            #1 clk=1;
        end
    end
    initial begin
        repeat(10)begin
            #3 d=0;
            #3 d=1;
        end
    end
    initial begin
        g=1; r=1; d=0;
        #10 g=0; r =1;
        #5 r =0;
    end

endmodule  