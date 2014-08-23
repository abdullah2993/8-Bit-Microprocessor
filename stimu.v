module stim_processor;
  reg rst,clk;
  parameter ADD=4'd0,SUB=4'd1,AND=4'd2,NOT=4'd3,MUL=4'd4,OR=4'd5,NOP=4'd6,REGD=4'd7,REGI=4'd8,READ=4'd9,READI=4'd10,WRITE=4'd11,WRITEI=4'd12,JMP=4'd13,JIZ=4'd14,JIO=4'd15;
  parameter R0=2'd0,R1=2'd1,R2=2'd2,R3=2'd3;
  Processor processor(rst,clk);
  always  
  #2 clk=~clk;
  initial
  begin
    clk=1;rst=0;
    #5 rst=1;
    processor.memory.mem[30]<=8'd8;
    processor.memory.mem[0]<={READI,R0,R0};
    processor.memory.mem[1]<=8'd30;
    processor.memory.mem[2]<={WRITE,R0,R0};
    processor.memory.mem[3]<=8'd30;
    processor.memory.mem[4]<={READ,R1,R0};
    processor.memory.mem[5]<=8'd30;
    processor.memory.mem[6]<={REGD,R3,R1};
    processor.memory.mem[8]<=8'd5;
  end
endmodule