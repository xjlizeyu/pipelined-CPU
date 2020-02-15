module decode_38 (
	input wire[2:0] a,
	output reg[7:0] y
);
	integer i;
	always @(*) begin 
		for (i=0;i<8;i=i+1) begin
			if (a==i)
				y[i]<=1;
			else y[i]<=0;
		end
	end
endmodule//decode_38

module exp22_td;
    wire[7:0] i;
    reg[2:0] o;
    decode_38 test(o,i);
    initial begin
        $dumpfile("exp2_td.vcd");
        $dumpvars(0,exp22_td);
		o = 3'b000;
		#5 o = 3'b001;
		#5 o = 3'b010;
		#5 o = 3'b011;
		#5 o = 3'b100;
		#5 o = 3'b101;
		#5 o = 3'b110;
		#5 o = 3'b111;
    end

endmodule // exp2-2_td