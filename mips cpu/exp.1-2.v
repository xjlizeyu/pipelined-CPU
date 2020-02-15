`timescale 1 ns/1 ps
module andgates(
    input wire a,
    input wire b,
    output wire out
);
  assign out = a&b;
endmodule // 

module orgates(
    input wire a,
    input wire b,
    output wire out
);
  assign out = a|b;
endmodule //


module notandgates(
    input wire a,
    input wire b,
    output wire out
);
  assign out = ~(a&b);
endmodule //

module notorgates(
    input wire a,
    input wire b,
    output wire out
);
  assign out = ~(a|b);
endmodule //

module notgates(
    input wire a,
    output wire out
);
  assign out = ~a;
endmodule // notgatesinput wire a,

module gate(a,b,c,d,out);
  input a,b,c,d;
  output out;
  wire a,b,c,d,out;
  wire a_,b_,c_,d_;
  orgates g1(a,b,a_);
  notgates g2(b,b_);
  notorgates g3(c,d,c_);
  notandgates g4(b_,c_,d_);
  andgates g5(a_,d_,out);
endmodule // testfiture

module exp1_td;
  reg a,b,c,d;
  wire out;

  gate damo(a,b,c,d,out);

  always @(posedge a) begin
    c = ~c;
    d = ~d;
  end
  initial begin

    $dumpfile("exp1.vcd");
    $dumpvars(0,exp1_td);
    a = 1;
    b = 1;
    c = 0;
    d = 1;
    repeat(100)begin
      #5 a = ~a;
      #5 b = ~b;
    end
  end
endmodule
