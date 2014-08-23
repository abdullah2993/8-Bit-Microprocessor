module alu(op,reg_y,bus1,alu_0_flag,alu_o_flag,alu_out);
input [7:0] reg_y,bus1;
input [3:0] op;
output reg [7:0] alu_out;
output reg alu_0_flag,alu_o_flag;

parameter [3:0]iadd=4'b0000;
parameter [3:0]isub=4'b0001;
parameter [3:0]iand=4'b0010;
parameter [3:0]inot=4'b0011;
parameter [3:0]ior=4'b0100;
parameter [3:0]imul=4'b0101;

always@(*)
begin
case(op)
iadd:{alu_o_flag,alu_out}=reg_y+bus1;
isub:{alu_o_flag,alu_out}=reg_y-bus1;
iand:{alu_o_flag,alu_out}=reg_y&bus1;
inot:{alu_o_flag,alu_out}=~reg_y;
ior:{alu_o_flag,alu_out}=reg_y|bus1;
imul:{alu_o_flag,alu_out}=reg_y*bus1;
endcase
if(alu_out==8'd0)
alu_0_flag=1;
else
alu_0_flag=0;
end
endmodule
