module Memory(
  input [7:0]address,bus_1,
  input write,
  output reg [7:0]mem_word);
  reg [7:0]mem[0:255];
  always@(*)
  begin
    if(write)
      mem[address]=bus_1;
    else
      mem_word=mem[address];
  end
endmodule