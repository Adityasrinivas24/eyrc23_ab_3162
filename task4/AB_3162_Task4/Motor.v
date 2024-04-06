module Motor(
				input clk,
				input rst,
				input dir_l,
				input dir_r,
				input wire [13:0]speed_l,
				input wire [13:0]speed_r,
				output A1A,
				output A1B,
				output B1A,
				output B1B
);
	reg [13:0] counter;
	reg pwm_l;
	reg pwm_r;
	parameter NUM_C = 11000; // counter max value motor speed varies within (0- NUM_C)
	
	always@(posedge clk)
	begin
		if(rst == 1)
		begin
			if (counter < speed_l)
				pwm_l = 1'b1;
			
			else
				pwm_l = 1'b0;
			
			if (counter < speed_r)
				pwm_r = 1'b1;
				
			else
				pwm_r = 1'b0;
				
			
			counter = counter + 1;
			if (counter == NUM_C)
				counter = 0;
		end
		else
		begin
			counter = 0;
			pwm_l = 0;
			pwm_r = 0;
		end
	end
	
	assign A1A = (dir_l == 1)? pwm_l: 0;
	assign A1B = (dir_l == 0)? pwm_l: 0;
	assign B1A = (dir_r == 1)? pwm_r: 0;
	assign B1B = (dir_r == 0)? pwm_r: 0;
	
endmodule
