module processor(rst,clk);
input rst,clk;
wire rst,clk,load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,load_ir,load_a_reg,load_reg_y,load_reg_z,write,zero,over;
wire [2:0] s_b_mux1;
wire [1:0]	s_b_mux2;
wire [7:0] instruction,out_a_reg,out_bus1,mem_word;

memory mem(out_a_reg,out_bus1,write,mem_word);
datapath dp(rst,clk,load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,s_b_mux1,load_ir,load_a_reg,load_reg_y,load_reg_z,s_b_mux2,mem_word,out_bus1,out_a_reg,instruction,zero,over);
controller cu(rst,clk,load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,s_b_mux1,load_ir,load_a_reg,load_reg_y,load_reg_z,s_b_mux2,write,instruction,zero,over);
endmodule
