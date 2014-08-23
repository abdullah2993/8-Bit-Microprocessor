module mux2(alu_out,bus1,mem_word,s_b_mux2,bus2);
input [7:0] bus1,mem_word,alu_out;
input [1:0] s_b_mux2;
output reg [7:0] bus2;
always@(*)
begin
case(s_b_mux2)
2'b00:bus2=alu_out;
2'b01:bus2=bus1;
2'b10:bus2=mem_word;
endcase
end
endmodule
