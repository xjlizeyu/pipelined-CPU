`timescale 1 ns/1 ps
module andnot4(
    input in1,
    input in2,
    input in3,
    input in4,
    output wire out
);

assign out= ~(in1&in2)|~(in3&in4);
endmodule // 

module exp4_td;
    reg a,b,c,d;
    wire out;
    andnot4 test (a,b,c,d,out);
    initial begin
        $dumpfile("exp4_td.vcd");
        $dumpvars(0,exp4_td);
        a= 0;b=0;c=0;d=0;
        #10 a= 0;b=0;c=0;d=0;
        #10 a= 1;b=0;c=0;d=0;
        #10 a= 0;b=1;c=0;d=0;
        #10 a= 0;b=0;c=1;d=0;
        #10 a= 0;b=0;c=0;d=1;
        #10 a= 1;b=1;c=0;d=0;
        #10 a= 0;b=0;c=1;d=1;
        #10 a= 1;b=1;c=1;d=0;
        #10 a= 0;b=1;c=1;d=1;
    end
endmodule 