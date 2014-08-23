module ControlUnit(
  input [7:0] instruction,
  input Zflag,Oflag,clk,rst,
  output reg load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,load_ir,load_add_reg,load_reg_y,load_flags,write,
  output reg [2:0]sel_bus_1_mux,
  output reg [1:0]sel_bus_2_mux);
  //registers
  reg [2:0]p_state,n_state;
  reg [15:0]temp_signals;
  //wires
  wire [3:0]opcode;
  wire [1:0]source,destin;
  //Instruction(disection)
  assign opcode=instruction[7:4];
  assign destin=instruction[3:2];
  assign source=instruction[1:0];
  //States
  parameter fetch1=3'd0,fetch2=3'd1,decode=3'd2,execute1=3'd3,execute2=3'd4,executei=3'd5;
  //Opcodes
  parameter ADD=4'd0,SUB=4'd1,AND=4'd2,NOT=4'd3,MUL=4'd4,OR=4'd5,NOP=4'd6,REGD=4'd7,REGI=4'd8,READ=4'd9,READI=4'd10,WRITE=4'd11,WRITEI=4'd12,JMP=4'd13,JIZ=4'd14,JIO=4'd15;
  //Source/destin Registers
  parameter R0=2'd0,R1=2'd1,R2=2'd2,R3=2'd3;
  always@(*)
  begin
    case(p_state)
      fetch1:
      begin
        temp_signals=16'b0000000100010010;
        n_state=fetch2;
      end
      fetch2:
      begin
        temp_signals=16'b0000101100100000;
        n_state=decode;
      end
      decode:
      begin
        case(opcode)
          NOP:
          begin
            temp_signals=16'b0000000100100000;
            n_state=fetch1;
          end
          REGD:
          begin
            temp_signals={(destin==R0),(destin==R1),(destin==R2),(destin==R3),4'b0000,source,6'b010000};
            n_state=fetch1;
          end
          REGI:
          begin
            temp_signals={8'b00000000,source,6'b010010};
            n_state=execute1;
          end
          default:
          begin
            if(opcode<NOP)
              begin
                temp_signals={8'b00000000,destin,6'b011000};
                n_state=execute1;
              end
            else if (opcode>REGI)
              begin
                temp_signals=16'b0000000100010010;
                n_state=execute1;
              end
          end
        endcase
      end 
      execute1:
      begin
        case(opcode)
          JMP:
          begin
            temp_signals=16'b0000010100100000;
            n_state=fetch1;
          end
          JIZ:
          begin
            temp_signals={5'b00000,(Zflag==1),4'b0100,2'b10,4'b0000};
            n_state=fetch1;
          end
          JIO:
          begin
            temp_signals={5'b00000,(Oflag==1),4'b0100,2'b10,4'b0000};
            n_state=fetch1;
          end
          REGI:
          begin
            temp_signals={(destin==R0),(destin==R1),(destin==R2),(destin==R3),4'b0000,source,6'b100000};
            n_state=fetch1;
          end
          default:
          begin
            if(opcode<NOP)
              begin
                temp_signals={(destin==R0),(destin==R1),(destin==R2),(destin==R3),4'b0000,((opcode==NOT)?destin:source),6'b000100};
                n_state=fetch1;
              end
            else if(opcode>REGI)
              begin
                 temp_signals={7'b0000001,((opcode==write)?1'b0:1'b1),((opcode==WRITE)?source:2'b00),6'b100010};
                 n_state=execute2;
              end
          end
        endcase
      end
      execute2:
      begin
        case(opcode)
          READ:
          begin
            temp_signals={(destin==R0),(destin==R1),(destin==R2),(destin==R3),12'b000100100000};
            n_state=fetch1;
          end
          WRITE:
          begin
            temp_signals={8'b00000000,source,6'b100001};
            n_state=fetch1;
          end
          default:
          begin
            if(opcode==WRITEI || opcode==READI)
              begin
                temp_signals=16'b0000000100100010;
                n_state=executei;
              end  
          end                    
        endcase
      end
      executei:
      begin
        case(opcode)
          READI:temp_signals={(destin==R0),(destin==R1),(destin==R2),(destin==R3),12'b000100100000};
          WRITEI:temp_signals=16'b0000000100100001;
        endcase
        n_state=fetch1;
      end
      
    endcase
  end
  //Signals
  always@(temp_signals)
  begin
    load_r0=temp_signals[15];
    load_r1=temp_signals[14];
    load_r2=temp_signals[13];
    load_r3=temp_signals[12];
    load_ir=temp_signals[11];
    load_pc=temp_signals[10];
    inc_pc=temp_signals[9];
    sel_bus_1_mux=temp_signals[8:6];
    sel_bus_2_mux=temp_signals[5:4];
    load_reg_y=temp_signals[3];
    load_flags=temp_signals[2];
    load_add_reg=temp_signals[1];
    write=temp_signals[0];
  end
  //T State
  always@(posedge clk or negedge rst)
  begin
    if(!rst)
      p_state<=fetch1;
    else
      p_state<=n_state;
  end
endmodule