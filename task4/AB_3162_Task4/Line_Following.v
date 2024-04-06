//// This module will be used to configure the LFA and identify the path and nodes

//changes made - added clk_50M and changes always block 

module Line_Following(
			input wire clk_50M,
			input rst,
			input wire [11:0]left_value,
			input wire [11:0]center_value,
			input wire [11:0]right_value,
			output reg dir_l,
			output reg dir_r,
			output reg node,
			output reg [13:0]speed_r,
			output reg [13:0]speed_l
	);


	// around 0.18v on bright surface and 2.2v on dark surface
	// After Calibration according to lighting conditions, value selected for upper and lower limit as follows
	
	parameter max_lim = 1600; 
	parameter min_lim = 600;
		
	reg [13:0]speed_1 = 11000;  //8800 is taken as the base speed
	reg [13:0]speed_2 = 11000;
	reg dir_1 = 1;   
	reg dir_2 = 1;
	reg reg_node = 0;
	reg [11:0]prev_error = 0;      // previous error term
	reg [11:0]error = 0;           // error term for making PD controller
	
   integer Kp = 1;               //Kp and Kd selected by calibration
	integer Kd = 1;
	
	always@(posedge clk_50M)begin
	
		reg_node = 0;
		if(rst == 0)begin
			prev_error = 0;
			error = 0;
			dir_1 = 1;
			dir_2 = 1;
			speed_1 = 0;
			speed_2 = 0;
		end
		
		else begin
			if (left_value < min_lim && center_value < min_lim && right_value < min_lim)
			begin
				speed_1 = 11000;
				speed_2 = 11000;
				dir_1 = 1;
				dir_2 = 0;
			end
			
			else if (left_value > max_lim && center_value > max_lim && right_value > max_lim)
			begin
				speed_1 = 11000;
				speed_2 = 11000;
				dir_1 = 1;
				dir_2 = 1;
				reg_node = 1;
				
			end
			
		else begin
			// Implemenation of custom PD contoller with desired error
				if(left_value >= right_value)
				begin
					error = left_value - right_value;
					speed_1 = (11000 - error)/Kp - (error - prev_error)/Kd;
					speed_2 = (11000 + error)/Kp + (error - prev_error)/Kd;
				end
				else
				begin
					error = right_value - left_value;
					speed_1 = (11000 + error)/Kp + (error - prev_error)/Kd;
					speed_2 = (11000 - error)/Kp - (error - prev_error)/Kd;
				end
				
				dir_1 = 1;
				dir_2 = 1;
			end
		end
		
		speed_l <= speed_1;
		speed_r <= speed_2;
		dir_l <= dir_1;
		dir_r <= dir_2;
		node <= reg_node;
	   prev_error = error;


	end

endmodule 
