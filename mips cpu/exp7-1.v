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

module exp7_td;
    reg clk,res,en;
    reg [3:0]add;
    reg[3:0] data;
    wire [3:0]out;
    register test(clk,add,data,res,en,out);
    initial begin
        clk = 0;
        repeat(50)begin
            #1 clk =~clk;
        end
    end
    initial begin
        $dumpfile("exp7_td.vcd");
        $dumpvars(0,exp7_td);
        add <= 4'h1;data <= 4'b1111;res <= 0;en <= 1;
        #10 add=4'ha;data = 4'b0110;
        #10 add=4'ha;en = 0;data = 4'b0000;
        #10 add = 4'ha;en =1; res = 1;
        #10 add = 4'h5;res = 0;data = 4'b1010;
    end 
endmodule // 