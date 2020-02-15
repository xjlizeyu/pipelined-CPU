`timescale 1 ns/1 ps
module HA(
    input a,
    input b,
    output result,
    output c
);
assign result =(~a&b)|(~b&a);
assign c =a&b;

endmodule // ha;

module FA(
    input a,
    input b,
    input _c,
    output reg result,
    output reg c_
);
always @(*) begin
    if(a==1&&b==1)begin
      c_=1;
      result = _c;
    end 
    else if (a==1||b==1) begin
        c_=_c;
        result =~_c;
    end
    else begin
        result = _c;
        c_=0;
    end
    
end
endmodule

module HAtest;
    reg in1,in2;
    wire c,out;
    HA test(in1,in2,out,c);
    initial begin
        $dumpfile("exp4_td.vcd");
        $dumpvars(0,HAtest);
        in1=0;in2=0;
        #5 in1=1;in2=0;
        #5 in1=0;in2=1;
        #5 in1=1;in2=1;
    end
endmodule

module FAtest;
    reg [3:0] d1,d2;
    wire c0,c1,c2,c3;
    wire [3:0]result;
    FA plus0(d1[0],d2[0],1'b0,result[0],c0);
    FA plus1(d1[1],d2[1],c0,result[1],c1);
    FA plus2(d1[2],d2[2],c1,result[2],c2);
    FA plus3(d1[3],d1[3],c2,result[3],c3);
    initial begin
        $dumpfile("exp4_td.vcd");
        $dumpvars(0,FAtest);
        d1 =4'b1000;d2=4'b1111;
        #5 d1 =4'b0100;d2=4'b0111;
        #5 d1 =4'b1011;d2=4'b0101;
        #5 d1 =4'b1100;d2=4'b1110;
        #5 d1 =4'b0000;d2=4'b0000;
    end
endmodule