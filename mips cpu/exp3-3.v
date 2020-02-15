`timescale 1 ns/1 ps
module counter(
    input clk,
    input reset,
    output reg[5:0] cnt，
    output reg z
);
initial cnt = 6'b000000;
always @(posedge clk) begin
    if (reset) begin
        cnt = 6'b000000;
        z = 0;
    end else begin
        if(cnt ==6'b110100)begin
          cnt = 6'b000000;
          z= 1;
        end else begin
          cnt = cnt+6'b000001;
          z=0;
        end
    end
end
endmodule // 

module exp3_td;
    reg clk;
    reg re;
    wire[5:0] out;
    counter test(clk,re,out);
    initial begin
        $dumpfile("exp3_td.vcd");
        $dumpvars(0,exp3_td);
        clk = 0;
        re = 0;
        #600 re = 1;
    end
    initial begin
        repeat(200)begin
            #5 clk=~clk;
        end
    end
    

endmodule 