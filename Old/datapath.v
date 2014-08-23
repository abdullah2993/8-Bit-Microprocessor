module datapath(rst,clk,load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,s_b_mux1,load_ir,load_a_reg,load_reg_y,load_reg_z,s_b_mux2,mem_word,out_bus1,out_a_reg,instruction,zero,over);
input rst,clk,load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,load_ir,load_a_reg,load_reg_y,load_reg_z;
input [7:0]mem_word;
input [2:0]s_b_mux1;
input [1:0]s_b_mux2;
output reg [7:0]instruction,out_bus1,out_a_reg;
output reg zero,over;
wire [7:0] out_r0,out_r1,out_r2,out_r3,out_pc,out_ir,out_alu,adrs,bus1,bus2,out_reg_y;
wire alu_0_flag,out_reg_z,alu_o_flag,out_reg_o;

register r0(rst,clk,bus2,load_r0,out_r0);
register r1(rst,clk,bus2,load_r1,out_r1);
register r2(rst,clk,bus2,load_r2,out_r2);
register r3(rst,clk,bus2,load_r3,out_r3);

register y(rst,clk,bus2,load_reg_y,out_reg_y);

register ar(rst,clk,bus2,load_a_reg,adrs);

mux1 m1(out_r0,out_r1,out_r2,out_r3,out_pc,s_b_mux1,bus1);

alu a1(instruction[7:4],out_reg_y,bus1,alu_0_flag,alu_o_flag,out_alu);

pc pcc(rst,clk,bus2,load_pc,inc_pc,out_pc);

ir irr(rst,clk,bus2,load_ir,out_ir);

flag f(rst,clk,alu_0_flag,load_reg_z,out_reg_z);

mux2 m2(out_alu,bus1,mem_word,s_b_mux2,bus2);

flag o(rst,clk,alu_o_flag,load_reg_z,out_reg_o);

always@(*)
begin
instruction=out_ir;
zero=out_reg_z;
out_bus1=bus1;
out_a_reg=adrs;
over=out_reg_o;
end
endmodule