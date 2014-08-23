module DataPath(
  input clk,rst,load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,load_ir,load_add_reg,load_reg_y,load_flags,write,
  input [2:0]sel_bus_1_mux,
  input [1:0]sel_bus_2_mux,
  input [7:0]mem_word,
  output reg [7:0]instruction,address,bus_1,
  output reg Zflag,Oflag);
  //wires
  reg [7:0]bus_2,out_r0,out_r1,out_r2,out_r3,out_reg_y,out_alu,out_pc;
  reg [3:0]op;
  reg alu_zero_flag,alu_over_flag;
  //memory
  reg [7:0]mem[0:255];
  //Opreation
  parameter alu_add=4'd0;
  parameter alu_sub=4'd1;
  parameter alu_and=4'd2;
  parameter alu_not=4'd3;
  parameter alu_mul=4'd4;
  parameter alu_or=4'd5;
 
  //ALU
  always@(*)
  begin
    case(op)
      alu_add:{alu_over_flag,out_alu}=out_reg_y+bus_1;
      alu_sub:{alu_over_flag,out_alu}=out_reg_y-bus_1;
      alu_and:{alu_over_flag,out_alu}=out_reg_y&bus_1;
      alu_not:{alu_over_flag,out_alu}=~out_reg_y;
      alu_mul:{alu_over_flag,out_alu}=out_reg_y*bus_1;
      alu_or:{alu_over_flag,out_alu}=out_reg_y|bus_1;
    endcase
    alu_zero_flag=(out_alu==8'b0);
  end
  //Register File
  always@(posedge clk or negedge rst)
  begin
    out_r0<=(!rst)?8'b0:(load_r0?bus_2:out_r0);
    out_r1<=(!rst)?8'b0:(load_r1?bus_2:out_r1);
    out_r2<=(!rst)?8'b0:(load_r2?bus_2:out_r2);
    out_r3<=(!rst)?8'b0:(load_r3?bus_2:out_r3);
  end
//Register Y
  always@(posedge clk or negedge rst)
  begin
    out_reg_y<=(!rst)?8'd0:(load_reg_y?bus_2:out_reg_y);
  end
  //mux 1
  always@(*)
  begin
    case(sel_bus_1_mux)
      3'd0:bus_1=out_r0;
      3'd1:bus_1=out_r1;
      3'd2:bus_1=out_r2;
      3'd3:bus_1=out_r3;
      3'd4:bus_1=out_pc;
    endcase
  end
  //mux 2
  always@(*)
  begin
    case(sel_bus_2_mux)
      2'd0:bus_2=out_alu;
      2'd1:bus_2=bus_1;
      2'd2:bus_2=mem_word;
    endcase
  end
  //PC
  always@(posedge clk or negedge rst)
  begin
    out_pc<=(!rst)?8'b0:(load_pc?bus_2:(inc_pc?(out_pc+8'd1):out_pc));
  end
  //IR
  always@(posedge clk or negedge rst)
  begin
    instruction<=(!rst)?8'b0:(load_ir?bus_2:instruction);
    op<=instruction[7:4];
  end
  //zero flag
  always@(posedge clk or negedge rst)
  begin
    Zflag<=(!rst)?1'b0:(load_flags?alu_zero_flag:Zflag);
  end
  //zero flag
  always@(posedge clk or negedge rst)
  begin
    Oflag<=(!rst)?1'b0:(load_flags?alu_over_flag:Oflag);
  end
  //address register
  always@(posedge clk or negedge rst)
  begin
    address<=(!rst)?8'b0:(load_add_reg?bus_2:address);
  end
endmodule