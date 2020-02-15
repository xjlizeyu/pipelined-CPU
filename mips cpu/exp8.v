module ALU(
    input clk,
    input signed[15:0] alu_in1,
    input signed[15:0] alu_in2,
    input [3:0]operations,
    output reg[15:0] alu_out_16,
    output reg[31:0] alu_out
);
parameter NOP = 4'b0000;
parameter ADD = 4'b0001;
parameter SUB = 4'b0010;
parameter MUL = 4'b0011;
parameter DIV = 4'b0100;
parameter AND = 4'b0101;
parameter OR = 4'b0110;
parameter NOR = 4'b0111;
parameter XOR = 4'b1000;
parameter ROR = 4'b1001;
parameter ROL = 4'b1010;

always @(posedge clk) begin
    case(operations)
        NOP:alu_out_16<=32'h0;
        ADD:alu_out_16<=alu_in1+alu_in2;
        SUB:alu_out_16<=alu_in1-alu_in2;
        MUL:alu_out<=alu_in1*alu_in2;
        DIV:alu_out_16<=alu_in1/alu_in2;
        AND:alu_out_16<=alu_in1&alu_in2;
        OR:alu_out_16<=alu_in1|alu_in2;
        NOR:alu_out_16<=alu_in1~^alu_in2;
        XOR:alu_out_16<=alu_in1^alu_in2;
        ROR:alu_out_16<={alu_in1[0],alu_in1[15:1]};
        ROL:alu_out_16<={alu_in1[14:0],alu_in1[15]};

    endcase
end
endmodule

module exp8_td;
    reg clk;
    reg[15:0]a;
    reg[15:0]b;
    wire[15:0]result1;
    wire[31:0]result2;
    reg[3:0]o;
    ALU test(clk,a,b,o,result1,result2);
    initial begin
        clk = 0;
        repeat(5000)begin
            #1 clk =~clk;
        end
    end
    initial begin
        $dumpfile("exp8_td.vcd");
        $dumpvars(0,exp8_td);
        a = 16'h1234;
        b = 16'h356a;
        o = 4'b0000;
        repeat(10)begin
            #10 o<=o+4'b0001;
        end
    end 
endmodule // 