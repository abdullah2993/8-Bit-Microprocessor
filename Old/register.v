module register(rst,clk,in1,load,out1);
input [7:0]in1;
input load,rst,clk;
output reg [7:0]out1;
always@(posedge clk or posedge rst)
begin
if(rst)
out1<=8'd0;
else if(load)
out1<=in1;
else
out1<=out1;
end
endmodule