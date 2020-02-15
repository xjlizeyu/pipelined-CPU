`timescale 1 ns/1 ps
module Dtrigger(
    input  wire din,
    input  wire clk,
    input  wire reset,
    input  wire enabler,
    output reg dout
);
always @(posedge clk) begin
    if (enabler==1'b0) begin
        
    end else begin
        if(reset==1'b1)begin
            dout<=1'b0;
        end else begin
            dout<=din;
        end
    end

end

endmodule // 

module Dtriggerline(
    input clk,
    input [3:0]data,
    input en,
    input cr,
    output [3:0]q
);
    Dtrigger d0(data[0],clk,cr,en,q[0]);
    Dtrigger d1(data[1],clk,cr,en,q[1]);
    Dtrigger d2(data[2],clk,cr,en,q[2]);
    Dtrigger d3(data[3],clk,cr,en,q[3]);

endmodule // Dtriggerline

module register(
    input clk,
    input[3:0] address,
    input [3:0]data,
    input rst,
    input en,
    output reg[3:0]rout
);
    wire [3:0] rout0,rout1,rout2,rout3,rout4,rout5,rout6,rout7,rout8,rout9,rout10,rout11,rout12,rout13,rout14,rout15;
    Dtriggerline l0(clk,data,~address[3]&&~address[2]&&~address[1]&&~address[0]&&en,rst,rout0);
    Dtriggerline l1(clk,data,~address[3]&&~address[2]&&~address[1]&&address[0]&&en,rst,rout1);
    Dtriggerline l2(clk,data,~address[3]&&~address[2]&&address[1]&&~address[0]&&en,rst,rout2);
    Dtriggerline l3(clk,data,~address[3]&&~address[2]&&address[1]&&address[0]&&en,rst,rout3);
    Dtriggerline l4(clk,data,~address[3]&&address[2]&&~address[1]&&~address[0]&&en,rst,rout4);
    Dtriggerline l5(clk,data,~address[3]&&address[2]&&~address[1]&&address[0]&&en,rst,rout5);
    Dtriggerline l6(clk,data,~address[3]&&address[2]&&address[1]&&~address[0]&&en,rst,rout6);
    Dtriggerline l7(clk,data,~address[3]&&address[2]&&address[1]&&address[0]&&en,rst,rout7);
    Dtriggerline l8(clk,data,address[3]&&~address[2]&&~address[1]&&~address[0]&&en,rst,rout8);
    Dtriggerline l9(clk,data,address[3]&&~address[2]&&~address[1]&&address[0]&&en,rst,rout9);
    Dtriggerline l10(clk,data,address[3]&&~address[2]&&address[1]&&~address[0]&&en,rst,rout10);
    Dtriggerline l11(clk,data,address[3]&&~address[2]&&address[1]&&address[0]&&en,rst,rout11);
    Dtriggerline l12(clk,data,address[3]&&address[2]&&~address[1]&&~address[0]&&en,rst,rout12);
    Dtriggerline l13(clk,data,address[3]&&address[2]&&~address[1]&&address[0]&&en,rst,rout13);
    Dtriggerline l14(clk,data,address[3]&&address[2]&&address[1]&&~address[0]&&en,rst,rout14);
    Dtriggerline l15(clk,data,address[3]&&address[2]&&address[1]&&address[0]&&en,rst,rout15);
    always @(posedge clk) begin
        case (address)
            4'h0:rout = rout0; 
            4'h1:rout = rout1; 
            4'h2:rout = rout2; 
            4'h3:rout = rout3; 
            4'h4:rout = rout4; 
            4'h5:rout = rout5; 
            4'h6:rout = rout6; 
            4'h7:rout = rout7; 
            4'h8:rout = rout8; 
            4'h9:rout = rout9;
            4'ha:rout = rout10; 
            4'hb:rout = rout11; 
            4'hc:rout = rout12; 
            4'hd:rout = rout13; 
            4'he:rout = rout14; 
            4'hf:rout = rout15;  
        endcase
    end
    
endmodule // 

module ram(
    input clk,
    input rst,
    input cs,
    input wrt,
    input rd,
    input [3:0]address,
    input [3:0]data_write,
    output [3:0]data_read
);
reg[3:0] content[15:0];
reg[3:0] word;  
integer i;
always @(posedge clk or posedge rst) begin
    if (cs) begin
        if(rst) begin
            for(i=0;i<16;i=i+1) begin
                content[i]=4'b0000;
            end
        end else if(wrt) begin
            content[address]=data_write;
        end else if(rd) begin
            word = content[address];
        end else begin
            word = 4'bzzzz;
        end
    end 
end
initial begin
    $readmemh("ram.txt", content);
end
assign data_read = word;
endmodule // 




module combination(
    input clk,
    input state1,
    input [1:0]state2,
    input [3:0]a,
    input [3:0]addr1,
    input [3:0]addr2,
    output reg[3:0]out1,
    output reg[3:0]out2
);
reg write,read;
reg[3:0]data;
reg s;
wire[3:0]data1;
reg [3:0]data2;
wire [3:0]data3;
reg r1;
reg r2;
register u0(.clk(clk),.address(addr1),.rst(r1),.en(s),.data(data),.rout(data3));
ram u1(.clk(clk),.rst(r2),.cs(1'b1),.wrt(write),.rd(read),.address(addr2),.data_read(data1),.data_write(data2));
always @(*) begin
    r1 = 0;
    r2 = 0;
    write <= state2[1];
    s<=state1;
    read <= state2[0];
    case({state1,state2})
        3'b000:begin//读寄存器
            out1 = data3;
            out2 = data1;
        end
        3'b010:begin//写ram
            data2 <= a;        end
        3'b100:begin//写寄存器
            data<=a;
        end
        3'b101:begin//ram->寄存器
            data<=data1;
        end
        3'b110:begin//寄存器->ram
            s<=0;
            data2<=data3;
        end
        3'b011:begin
            r1 = 1;
            #1 r1 = 0;
        end
        3'b111:begin
            r2 = 1;
            r2 = 0;
        end
    endcase
end


endmodule

module ALU(
    input signed[3:0] alu_in1,
    input signed[3:0] alu_in2,
    input [3:0]operations,
    output reg[3:0] alu_out
);
parameter NOP = 4'b0000;//置0
parameter ADD = 4'b0001;//
parameter SUB = 4'b0010;
parameter MUL = 4'b0011;
parameter DIV = 4'b0100;
parameter AND = 4'b0101;
parameter OR = 4'b0110;
parameter NOR = 4'b0111;
parameter XOR = 4'b1000;
parameter ROR = 4'b1001;
parameter ROL = 4'b1010;

always @(*) begin
    case(operations)
        NOP:alu_out<=8'h0;
        ADD:alu_out<=alu_in1+alu_in2;
        SUB:alu_out<=alu_in1-alu_in2;
        MUL:alu_out<=alu_in1*alu_in2;
        DIV:alu_out<=alu_in1/alu_in2;
        AND:alu_out<=alu_in1&alu_in2;
        OR:alu_out<=alu_in1|alu_in2;
        NOR:alu_out<=alu_in1~^alu_in2;
        XOR:alu_out<=alu_in1^alu_in2;
        ROR:alu_out<={alu_in1[0],alu_in1[3:1]};
        ROL:alu_out<={alu_in1[2:0],alu_in1[3]};

    endcase
end
endmodule

module instrucion_coder(
    input clk,
    input [11:0]code,
    input [3:0]data_in,
    output reg [3:0]out
);
reg [2:0]c;
wire [3:0]out1,out3;
wire [3:0]out2;
reg [3:0]op;
reg [3:0]data1;
reg [3:0]data2;
combination u0(.clk(clk),.state1(c[2]),.state2(c[1:0]),.a(data_in),.out1(out1),.addr1(code[7:4]),.addr2(code[3:0]),.out2(out2));
ALU u1(.operations(op),.alu_in1(data1),.alu_in2(data2),.alu_out(out3));
always @(negedge clk) begin
    op=code[11:8];
    if(code[11:8]== 4'b1001||code[11:8]==4'b1010)begin
        c = 3'b000;
        #10 data1 =out1;
        out = out2;
    end else begin
        c =3'b000;
        data1 = out1;
        data2 = out2;
        #6
        out = out3;
    end

end

endmodule

module exp9_td;
    reg[11:0]code;
    reg[3:0] data;
    wire [3:0] out;
    reg clk;
    instrucion_coder i(clk,code,data,out);
    initial begin
        $dumpfile("exp9_td.vcd");
        $dumpvars(0,exp9_td);
        code <=12'b0;
        #5 code = 12'b000100100001;
        #20 code =12'b100100010010;
    end 
    initial begin
        clk = 1;
        repeat(100)begin
            #5 clk = ~clk;
        end
    end
endmodule // 