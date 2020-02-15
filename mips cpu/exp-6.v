`timescale 1 ns/1 ps
module counter(
    input clk,
    input a,
    output reg sign
);
reg count = 0;
reg [2:0]s;
always @(posedge clk)begin
  s={s[1:0],a};
  if(s == 3'b101)begin
    count = count +1;
    sign = 1;
  end else begin
    sign =0;
  end
end
endmodule //

module exp6_td;
    reg a,clk;
    wire sidn;
    counter t(clk,a,sign);
    initial begin
      clk <= 0;
      repeat(100)begin
        #5 clk = ~clk; 
      end
    end
    initial begin
      $dumpfile("exp6_td.vcd");
      $dumpvars(0,exp6_td);
      a = 0;
      #20 a = 1;
      #10 a = 0;
      #10 a = 1;
      #30 a = 0;
      #10 a = 1;
    end

endmodule // 