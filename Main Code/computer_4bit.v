// Code your design here
module computer_4bit(
  input clk,rst,
  input [3:0] d_in,
  input [3:0] ins_address,
  input [7:0] ins, 
  output reg [3:0] d_out,
  output reg ZF,CF
);
  
  reg[3:0] A=0,B=0,temp;
  reg[3:0] IP=0,SP=0;
  reg[3:0] Instruction,Address;
  reg[3:0] Data_memory[15:0];
  reg[7:0] Ins_memory[15:0];
  reg[3:0] Stack_memory[15:0];
  
  reg Halt=0;
  
  parameter[3:0] ADD_A_B			= 4'b0000;//4'h0
  parameter[3:0] SUB_A_B			= 4'b0001;//4'h1
  parameter[3:0] XCHG_B_A			= 4'b0010;//4'h2
  parameter[3:0] RCL_A				= 4'b0011;//4'h3
  parameter[3:0] OUT_A				= 4'b0100;//4'h4
  parameter[3:0] INC_A			 	= 4'b0101;//4'h5
  parameter[3:0] MOV_B_ADDRESS		= 4'b0110;//4'h6
  parameter[3:0] MOV_B_BYTE			= 4'b0111;//4'h7
  parameter[3:0] JMP_ADDRESS		= 4'b1000;//4'h8
  parameter[3:0] PUSH_B				= 4'b1001;//4'h9
  parameter[3:0] POP_B				= 4'b1010;//4'hA
  parameter[3:0] NOT_A				= 4'b1011;//4'hB
  parameter[3:0] CALL_ADDRESS		= 4'b1100;//4'hC
  parameter[3:0] RET				= 4'b1101;//4'hD
  parameter[3:0] TEST_A_B			= 4'b1110;//4'hE
  parameter[3:0] HLT				= 4'b1111;//4'hF
  
  
  always @(negedge clk)
	begin
      Ins_memory[ins_address] <= ins;// feeding instructions
      Data_memory[ins_address] <= d_in;// feeding data
 
      Address <= Ins_memory[IP][7:4];// load memory address to fetch data
      Instruction <= Ins_memory[IP][3:0];//load instructions opcode
	end
  
  
  always @(posedge clk, posedge rst)
	begin
	  
	  if(rst)
		begin
		d_out=4'bzzzz;
		ZF=0;
		CF=0;
		end
	  
	  else if(!rst && !Halt)
		begin
		  IP=IP+1;
		  case(Instruction)
			
		  ADD_A_B:
			begin
			  {CF,A}=A+B;
			  if(!A) ZF=1;
			  end
			  
		  SUB_A_B:	
			begin
			  {CF,A}=A-B;
			  if(!A) ZF=1;
			end
			
		  XCHG_B_A:
			begin
				temp=A;
				A=B;
				B=temp;
			end
			
		  RCL_A:
			begin
				A<={A[2:0],CF};
				CF<=A[3];
			end
			
		  OUT_A:
			begin
				d_out=A;
				if(!A) ZF=1;
			end
			
		  INC_A:
			begin
				A=A+1;
			end
			
		  MOV_B_ADDRESS:
			begin
				B=Data_memory[Address];
			end
			
		  MOV_B_BYTE:
			begin
				B=Address;
			end
			
		  JMP_ADDRESS:
			begin
				IP=Address;
			end			
		  PUSH_B:
			begin
				Stack_memory[SP]=B;
				SP=SP+1;			
			end		
								
		  POP_B:
			begin
				SP=SP-1;
				B=Stack_memory[SP];			
			end	
											
		  NOT_A:
			begin
				A= ~ A;
				
			end
			
		  CALL_ADDRESS:
			begin
				Stack_memory[SP]=IP;
				IP=Address;
				SP=SP+1;		
			end			
													  
		  RET:
			begin
				SP=SP-1;
				IP=Stack_memory[SP];		
			end					   
  
		  TEST_A_B:
			begin
				temp=A&B;
				if(!temp) ZF=1;		
			end					   
		  
		  HLT:
			begin
				Halt=1;		
			end
		  
		  default:
			begin
				d_out=4'bzzzz;
			end					        
	  
		endcase
		end
		  
	end
endmodule