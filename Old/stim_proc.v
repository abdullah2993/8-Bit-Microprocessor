module stim_proc;
reg rst,clk;
processor ppp(rst,clk);

parameter [3:0]iadd=4'b0000;
parameter [3:0]isub=4'b0001;
parameter [3:0]iand=4'b0010;
parameter [3:0]inot=4'b0011;
parameter [3:0]ior=4'b0100;
parameter [3:0]imul=4'b0101;
parameter [3:0]inop=4'b0110;
parameter [3:0]regd=4'b0111;
parameter [3:0]regid=4'b1000;
parameter [3:0]iread=4'b1001;
parameter [3:0]ireadi=4'b1010;
parameter [3:0]iwrite=4'b1011;
parameter	[3:0]iwritei=4'b1100;
parameter	[3:0]buc=4'b1101;
parameter [3:0]biz=4'b1110;
parameter [3:0]bio=4'b1111;

parameter [1:0]R0=2'b00;
parameter [1:0]R1=2'b01;
parameter [1:0]R2=2'b10;
parameter [1:0]R3=2'b11;

always
#5 clk=~clk;
initial
begin
rst=1;clk=1;
#10 rst=0;
ppp.mem.mem[30]<=8'd8;
ppp.mem.mem[0]<={iread,R0,R0};
ppp.mem.mem[1]<=8'd30;
ppp.mem.mem[2]<={iread,R1,R0};
ppp.mem.mem[3]<=8'd30;
ppp.mem.mem[4]<={bio,R0,R0};
ppp.mem.mem[5]<=8'd9;
ppp.mem.mem[6]<={iadd,R0,R1};
ppp.mem.mem[7]<={buc,R0,R0};
ppp.mem.mem[8]<=8'd4;
ppp.mem.mem[9]<={inop,R0,R0};
end
endmodule