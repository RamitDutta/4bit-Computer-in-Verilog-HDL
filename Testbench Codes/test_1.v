// Code your testbench here
// or browse Examples
module computer_4bit_tb();
  
  reg clk=0;
  reg rst=1;
  reg [3:0] d_in;
  reg [7:0] ins;
  reg [3:0] ins_address;
  
  wire[3:0] d_out;
  wire ZF,CF;
  
  reg[3:0] Data_memory[15:0];
  reg[7:0] Ins_memory[15:0];
  reg[3:0] Stack_memory[15:0];
  integer i;
  
  computer_4bit test(clk,rst,d_in,ins_address,ins,d_out,ZF,CF);
  

	initial 
      	begin
          //Ins_memory[]={Address,Instruction OPcode};
          
          
          Ins_memory[0]  = 8'h16;// MOV_B_ADDRESS 
          Ins_memory[1]  = 8'h02;// XCHG_B_A
          Ins_memory[2]  = 8'h77;// MOV_B_BYTE
          Ins_memory[3]  = 8'h00;// ADD_A_B
          Ins_memory[4]  = 8'h04;// OUT_A
          Ins_memory[5]  = 8'h0F;// HLT	
		
		       
          Data_memory[0]  = 4'd0;
          Data_memory[1]  = 4'd5;
          
		
        end
	
  	initial
		begin
          $dumpfile("testbench.vcd");
		$dumpvars;
		
          for(i=0;i<6;i=i+1)
			begin
			#1 clk=0;
			d_in = Data_memory[i];
			ins = Ins_memory[i];
            ins_address= i;
            #1 clk=1;
			end
		
		#1 rst=0;
		
		#50 $finish;
		end
	always #1 clk=!clk;
endmodule	
			

