`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:57:18 03/28/2017 
// Design Name: 
// Module Name:    SW_KeyBoard 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module SW_KeyBoard(data, clock, led, clock2
);
	 input clock2;	
	 input data;	
    input clock;
	 output reg[3:0] led;
	 
	 reg reset;
	 reg start;
	 reg pause;
	 
	 initial begin
	 led = 4'b0000;
	 end
	 
	 reg[25:0] counter;
    reg dummy;	 
	 
	 always @ (posedge clock2)
	 begin
	 
		 if(pause==1'b1)
		  begin
				dummy <= 1'b1; 
		  end
		  
		 if(start==1'b1)
		  begin
				dummy <= 1'b0;
		  end
		  
		 if(reset==1'b1)
		  begin
			  led = 4'b0000;
			  dummy <= 1'b1;
		  end 
		 
		 if(dummy==1'b0)
		  begin
				counter = counter+1;
				if(counter==50000000)
				begin
					counter = 0;
					if(led==4'b1111)
					begin
						led = 0;
					end
					else
						begin
							led = led + 1;
						end
				end
		  end 
	end
	 
reg [7:0] data_curr;
//reg [7:0] data_pre;
reg [3:0] b;
reg flag;
initial
begin
	b<=4'h1;
	flag<=1'b0;
	data_curr<=8'hf0;
	//data_pre<=8'hf0;
	//led<=8'hf0;
end
always @(negedge clock) //Activating at negative edge of clock from keyboard
begin
	case(b)
	1:; //first bit
	2:data_curr[0]<=data;
	3:data_curr[1]<=data;
	4:data_curr[2]<=data;
	5:data_curr[3]<=data;
	6:data_curr[4]<=data;
	7:data_curr[5]<=data;
	8:data_curr[6]<=data;
	9:data_curr[7]<=data;
	10:flag<=1'b1; //Parity bit
	11:flag<=1'b0; //Ending bit
endcase
 if(b<=10)
		b<=b+1;
 else if(b==11)
		b<=1;
end

always@(posedge flag) // Printing data obtained to led
	begin
		if(data_curr==8'h4D)
		begin
			pause <= 1'b1;
			reset <= 1'b0;
			start <= 1'b0;
		end
		 else if (data_curr == 8'h1B)
			begin 
			start <= 1'b1;
			pause <= 1'b0;
			reset <= 1'b0; 
		end
		else if (data_curr == 8'h2D)
			begin 
			reset <= 1'b1;	
			start <= 1'b0;
			pause <= 1'b0;
		 //data_pre<=data_curr;
			end 
	end


endmodule