module memory(adrs,bus1,write,mem_word);
input [7:0] bus1,adrs;
input write;
output reg [7:0] mem_word;
reg [7:0]mem[0:255];

always@(*)
begin
if(write)
mem[adrs]<=bus1;
else
mem_word<=mem[adrs];
end
endmodule