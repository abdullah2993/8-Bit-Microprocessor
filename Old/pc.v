module pc(rst,clk,bus2,load_pc,inc_pc,out_pc);
input [7:0] bus2;
input rst,load_pc,inc_pc,clk;
output reg [7:0] out_pc;
always@(posedge clk or posedge rst)
begin
if(rst)
out_pc<=8'd0;
else if(load_pc)
out_pc<=bus2;
else if(inc_pc)
out_pc<=out_pc+1;
else
out_pc<=out_pc;
end
endmodule