`timescale 1 ns/1 ps
module encode_83(
    input [7:0]in,
    output reg [2:0]out
);
wire [7:0] in;

always @*
    begin
        case (in)
            8'b00000001:out=3'b111;
            8'b00000010:out=3'b110;
            8'b00000100:out=3'b101;
            8'b00001000:out=3'b100;
            8'b00010000:out=3'b011;
            8'b00100000:out=3'b010;
            8'b01000000:out=3'b001;
            8'b10000000:out=3'b000;
            default: out=3'b0;
        endcase
    end



endmodule // 

module exp2_td;
    reg[7:0] i;
    wire[2:0] o;
    encode_83 test(i,o);
    initial begin
        $dumpfile("exp2_td.vcd");
        $dumpvars(0,exp2_td);
        i = 8'b00000010;
        #5 i = 8'b00000001;
        #5 i = 8'b00000100;
        #5 i = 8'b00001000;
        #5 i = 8'b00010000;
        #5 i = 8'b00100000;
        #5 i = 8'b01000000;
        #5 i = 8'b10000000;
        #500;
        
    end
    
    
endmodule // 