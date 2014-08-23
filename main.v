module Processor(input rst,clk);

wire Zflag,Oflag,load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,load_ir,load_add_reg,load_reg_y,load_flags,write;
wire [2:0]sel_bus_1_mux;
wire [1:0]sel_bus_2_mux;
wire [7:0]instruction,mem_word,bus_1,address;

Memory memory(address,bus_1,write,mem_word);
DataPath datapath(clk,rst,load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,load_ir,load_add_reg,load_reg_y,load_flags,write,sel_bus_1_mux,sel_bus_2_mux,mem_word,instruction,address,bus_1,Zflag,Oflag);
ControlUnit controlunit(instruction,Zflag,Oflag,clk,rst,load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,load_ir,load_add_reg,load_reg_y,load_flags,write,sel_bus_1_mux,sel_bus_2_mux);

endmodule