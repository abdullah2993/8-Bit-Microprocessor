module flag(rst,clk,alu_0_flag,load_reg,zero);
input alu_0_flag,load_reg,rst,clk;
output reg zero;
always@(posedge clk or posedge rst)
begin
if(rst)
zero=1'd0;
else if(load_reg)
zero=alu_0_flag;
else
zero=zero;
end
endmodule
