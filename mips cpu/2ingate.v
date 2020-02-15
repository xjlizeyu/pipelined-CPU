module gates(
    input wire a,
    input wire b,
    output wire[5:0]out
);
assign out[5] = a&b;
assign out[4] = a|b;
assign out[3] = ~(a&b);
assign out[2] = ~(a|b);

endmodule // 