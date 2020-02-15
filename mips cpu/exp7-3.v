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
assign data_read = word;
endmodule // 




module combination(
    input clk,
    input state1,
    input [1:0]state2,
    input [3:0]a,
    input [3:0]addr1,
    input [3:0]addr2,
    output reg[3:0]out
);
reg write,read;
always @(*) begin
    r1 = 0;
    r2 = 0;
    write <= state2[1];
    s<=state1;
    read <= state2[0];
    case({state1,state2})
        3'b000:begin//读寄存器
            out = data3;
        end
        3'b010:begin//写ram
            data2 <= a;
            out <= a;
        end
        3'b001:begin//读ram
            out = data1;
        end
        3'b100:begin//写寄存器
            out <= a;
            data<=a;
        end
        3'b101:begin//ram->寄存器
            out<=data1;
            data<=data1;
        end
        3'b110:begin//寄存器->ram
            s<=0;
            out<=data3;
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
reg[3:0]data;
reg s;
wire[3:0]data1;
reg [3:0]data2;
wire [3:0]data3;
reg r1;
reg r2;
register u0(.clk(clk),.address(addr1),.rst(r1),.en(s),.data(data),.rout(data3));
ram u1(.clk(clk),.rst(r2),.cs(1'b1),.wrt(write),.rd(read),.address(addr2),.data_read(data1),.data_write(data2));
endmodule

module exp7_td;
    reg clk;
    reg s1;
    reg [1:0]s2;
    reg [3:0]a1;
    reg[3:0]a2;
    reg[3:0] in;
    wire [3:0]out;
    reg sys_reset;
    combination test(clk,s1,s2,in,a1,a2,sys_reset,out);
    initial begin
        clk = 0;
        repeat(5000)begin
            #1 clk =~clk;
        end
    end
    initial begin
        $dumpfile("exp7_td.vcd");
        $dumpvars(0,exp7_td);
        #10 sys_reset = 1;
        #10 sys_reset = 0;
        #10 in <= 4'b1111; s1<=1;s2<=2'b00;a1 = 4'h5;
        #10 in<= 4'b1010; s1<=0; s2<= 2'b10;a2 = 4'ha;
        #10 in<=4'b0000; s1<=0;s2 <=2'b00;
        #10 s1 <=0;s2<=2'b01; 
        #10  s1<=1;s2 <=2'b01; a1 <=4'h1;a2 <= 4'ha;
        #10 s1<=1;s2<=2'b10;a1<=4'h5;;a2<=4'h1;
        #10 in<=4'b0000; s1<=0;s2 <=2'b00;a1 <=4'h1;
        #10 s1 <=0;s2<=2'b01;a1<=4'h1;
    end 
endmodule // 