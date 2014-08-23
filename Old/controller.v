module controller(rst,clk,load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,s_b_mux1,load_ir,load_a_reg,load_reg_y,load_reg_z,s_b_mux2,write,instruction,zero,over);
	input rst,clk,zero,over;
	input [7:0] instruction;
	output reg load_r0,load_r1,load_r2,load_r3,load_pc,inc_pc,load_ir,load_a_reg,load_reg_y,load_reg_z,write;
	output reg [2:0] s_b_mux1;
	output reg [1:0] s_b_mux2;

	wire [3:0] opcode;
	wire [1:0] source,destination;
	reg [2:0] p_state,n_state;

	assign opcode=instruction[7:4];
	assign destination=instruction[3:2];
	assign source=instruction[1:0];

	parameter[2:0]fetch1=3'b000;
	parameter[2:0]fetch2=3'b001;
	parameter[2:0]decode=3'b010;
	parameter[2:0]execute_sb=3'b011;
	parameter[2:0]con1=3'b100;
	parameter[2:0]con2=3'b101;
	parameter[2:0]con3=3'b110;

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

	always@(posedge clk or posedge rst)
	begin
		if(rst)
			p_state<=fetch1;
		else
			p_state<=n_state;
	end 

	always@(*)
	begin
		case(p_state)
			fetch1:
			begin
				load_r0=0;
				load_r1=0;
				load_r2=0;
				load_r3=0;
				load_pc=0;
				inc_pc=0;
				load_ir=0;
				load_a_reg=1;
				load_reg_y=0;
				load_reg_z=0;
				write=0;
				s_b_mux1=3'b100;
				s_b_mux2=2'b01;
				n_state=fetch2;
			end

			fetch2:
			begin
				load_r0=0;
				load_r1=0;
				load_r2=0;
				load_r3=0;
				load_pc=0;
				inc_pc=1;
				load_ir=1;
				load_a_reg=0;
				load_reg_y=0;
				load_reg_z=0;
				write=0;
				s_b_mux1=3'b100;
				s_b_mux2=2'b10;
				n_state=decode;
			end

			decode:
			begin
				if(opcode==inop)
				begin
					load_r0=0;
					load_r1=0;
					load_r2=0;
					load_r3=0;
					load_pc=0;
					inc_pc=0;
					load_ir=0;
					load_a_reg=0;
					load_reg_y=0;
					load_reg_z=0;
					write=0;
					n_state=fetch1;
				end
				else if (opcode<inop)
				begin
					s_b_mux1={1'b0,destination};
					load_r0=0;
					load_r1=0;
					load_r2=0;
					load_r3=0;
					load_pc=0;
					inc_pc=0;
					load_ir=0;
					load_a_reg=0;
					load_reg_y=1;
					load_reg_z=0;
					write=0;
					s_b_mux2=2'b01;
					n_state=execute_sb;
				end
				else if(opcode>4'b1000)
				begin
					load_r0=0;
					load_r1=0;
					load_r2=0;
					load_r3=0;
					load_pc=0;
					inc_pc=0;
					load_ir=0;
					load_a_reg=1;
					load_reg_y=0;
					load_reg_z=0;
					write=0;
					s_b_mux1=3'b100;
					s_b_mux2=2'b01;
					n_state=execute_sb;

				end
				else if(opcode==regd)
				begin
					case(destination)
						2'b00:load_r0=1;
						2'b01:load_r1=1;
						2'b10:load_r2=1;
						2'b11:load_r3=1;
					endcase
					load_pc=0;
					inc_pc=0;
					load_ir=0;
					load_a_reg=0;
					load_reg_y=0;
					load_reg_z=0;
					write=0;
					s_b_mux1={1'b0,source};
					s_b_mux2=2'b01;
					n_state=fetch1;
				end
				else if(opcode==regid)
				begin
					load_r0=0;
					load_r1=0;
					load_r2=0;
					load_r3=0;
					load_pc=0;
					inc_pc=0;
					load_ir=0;
					load_a_reg=1;
					load_reg_y=0;
					load_reg_z=0;
					write=0;
					s_b_mux1={1'b0,source};
					s_b_mux2=2'b01;
					n_state=execute_sb;
				end

			end

			execute_sb:
			begin
				if(opcode<inop)
				begin
					case(destination)
						2'b00:load_r0=1;
						2'b01:load_r1=1;
						2'b10:load_r2=1;
						2'b11:load_r3=1;
					endcase
					load_pc=0;
					inc_pc=0;
					load_ir=0;
					load_a_reg=0;
					load_reg_y=0;
					load_reg_z=1;
					write=0;
					if(opcode!=inot)
					begin
						s_b_mux1={1'b0,source};
					end
					s_b_mux2=2'b00;
					n_state=fetch1;
				end

				else if(opcode==buc)
				begin
					load_r0=0;
					load_r1=0;
					load_r2=0;
					load_r3=0;
					load_pc=1;
					inc_pc=0;
					load_ir=0;
					load_a_reg=0;
					load_reg_y=0;
					load_reg_z=0;
					write=0;
					s_b_mux2=2'b10;
					n_state=fetch1;
				end

				else if(opcode==biz)
				begin

					if(zero==1)
					begin
						load_r0=0;
						load_r1=0;
						load_r2=0;
						load_r3=0;
						load_pc=1;
						inc_pc=0;
						load_ir=0;
						load_a_reg=0;
						load_reg_y=0;
						load_reg_z=0;
						write=0;
						s_b_mux2=2'b10;
					end
					n_state=fetch1;
				end
				
				else if(opcode==bio)
				begin

					if(over==1)
					begin
						load_r0=0;
						load_r1=0;
						load_r2=0;
						load_r3=0;
						load_pc=1;
						inc_pc=0;
						load_ir=0;
						load_a_reg=0;
						load_reg_y=0;
						load_reg_z=0;
						write=0;
						s_b_mux2=2'b10;
					end
					n_state=fetch1;
				end
				
				else if(opcode==regid)
				begin
					if(destination==2'b00)
						load_r0=1;
					else
						load_r0=0;
					if(destination==2'b01)
						load_r1=1;
					else
						load_r1=0;
					if(destination==2'b10)
						load_r2=1;
					else
						load_r2=0;
					if(destination==2'b11)
						load_r3=1;
					else
						load_r3=0;
					inc_pc=0;
					load_ir=0;
					load_a_reg=0;
					load_reg_y=0;
					load_reg_z=0;
					write=0;
					s_b_mux2=2'b10;
					n_state=fetch1;			
				end
				else if(opcode>4'b1000)
				begin
					load_r0=0;
					load_r1=0;
					load_r2=0;
					load_r3=0;				
					load_pc=0;
					inc_pc=1;
					load_ir=0;
					load_a_reg=1;
					load_reg_y=0;
					load_reg_z=0;
					write=0;
					if(opcode==iwrite)
					  s_b_mux1={1'b0,source};
					s_b_mux2=2'b10;
					n_state=con1;
				end
			end
			con1:
			begin
				if(opcode==iread)
				begin
					if(destination==2'b00)
						load_r0=1;
					else
						load_r0=0;
					if(destination==2'b01)
						load_r1=1;
					else
						load_r1=0;
					if(destination==2'b10)
						load_r2=1;
					else
						load_r2=0;
					if(destination==2'b11)
						load_r3=1;
					else
						load_r3=0;
				end
				else
				begin
					load_r0=0;
					load_r1=0;
					load_r2=0;
					load_r3=0;
				end	
				load_pc=0;
				inc_pc=0;
				load_ir=0;
				if(opcode==iwritei || opcode==ireadi)
				begin
					load_a_reg=1;
					n_state=con2;
				end	
				else
				begin
					load_a_reg=0;
					n_state=fetch1;
				end
				load_reg_y=0;
				load_reg_z=0;
				if(opcode==iwrite)
				  write=1;
				else
				  write=0;
				s_b_mux2=2'b10;
				
			end
			
			con2:
			begin
				if(opcode==ireadi)
				begin
					if(destination==2'b00)
						load_r0=1;
					else
						load_r0=0;
					if(destination==2'b01)
						load_r1=1;
					else
						load_r1=0;
					if(destination==2'b10)
						load_r2=1;
					else
						load_r2=0;
					if(destination==2'b11)
						load_r3=1;
					else
						load_r3=0;
				end
				else
				begin
					load_r0=0;
					load_r1=0;
					load_r2=0;
					load_r3=0;
				end	
				load_pc=0;
				inc_pc=0;
				load_ir=0;
				load_a_reg=0;
				n_state=fetch1;
				load_reg_y=0;
				load_reg_z=0;
				if(opcode==iwritei)
				  write=1;
				else
				  write=0;
				s_b_mux2=2'b10;
				
			end
		endcase
	end
endmodule
