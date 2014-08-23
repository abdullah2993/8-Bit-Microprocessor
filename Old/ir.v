module ir(rst,clk,bus2,load_ir,instruction);
input [7:0] bus2;
input load_ir,rst,clk;
output reg [7:0] instruction;
always@(posedge clk or posedge rst)
if(rst)
instruction=8'd0;
else if(load_ir)
instruction=bus2;
else
instruction=instruction;
endmodule
