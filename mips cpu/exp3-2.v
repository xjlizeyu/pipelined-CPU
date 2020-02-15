`timescale 1 ns/1 ps
module register(
    input [7:0]in,
    input clk,
    input reset,
    output reg [7:0]out
);
always @(posedge clk) begin
    if (reset) begin
        out<=8'b00000000;
    end else begin
        out<={in[6:0],in[7]};
    end
end
endmodule // 

module exp3_td;
    reg[7:0] in;
    reg clk;
    reg re;
    wire[7:0] ou;
    register test(in,clk,re,ou);
    

    initial begin
        $dumpfile("exp3_td.vcd");
        $dumpvars(0,exp3_td);
        clk = 0;
        re = 0;
        in = 8'b10110011;
        #500 re = 1;
    end
    initial begin
        repeat(20)begin
            #50 clk=~clk;
        end
    end
    

endmodule 