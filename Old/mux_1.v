module mux1(out_r0,out_r1,out_r2,out_r3,out_pc,s_b_mux1,bus1);
input [7:0] out_r0,out_r1,out_r2,out_r3,out_pc;
input [2:0] s_b_mux1;
output reg [7:0]bus1;
always@(*)
begin
case(s_b_mux1)
3'b000:bus1=out_r0;
3'b001:bus1=out_r1;
3'b010:bus1=out_r2;
3'b011:bus1=out_r3;
3'b100:bus1=out_pc;
endcase
end
endmodule