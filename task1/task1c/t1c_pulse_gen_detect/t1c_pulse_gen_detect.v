// AstroTinker Bot : Task 1C : Pulse Generator and Detector
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to design a module which will generate a 10us pulse and detect incoming pulse signal.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

// t1c_pulse_gen_detect
//Inputs : clk_50M, reset, echo_rx
//Output : trigger, distance, pulses, state

// module declaration
module t1c_pulse_gen_detect (
    input clk_50M, reset, echo_rx,
    output reg trigger, out,
    output reg [21:0] pulses,
    output reg [1:0] state
);

initial begin
    trigger = 0; out = 0; pulses = 0; state = 0;
end


//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

/*
Add your logic here
*/

 reg [6:0] delay_1us;
 reg [9:0] trigger_10us;
 reg [16:0] read_1ms;
 reg [15:0] pulse_width;
 reg rec;
 
 parameter WARMUP = 3'b000;
 parameter TRIGGER = 3'b001;
 parameter DETECT = 3'b010;

 always @(posedge clk_50M) begin
    case (state)
				//state 1: 1us delay
            WARMUP: begin
						rec = 0;
						//reset is low
						if (!reset) begin   
							if (delay_1us < 7'd49) begin  //1us delay
								delay_1us = delay_1us + 1'd1;
							end
							else begin  //after 1us delay
								state = TRIGGER;
								delay_1us = 0;
							end	
						end 
						//when reset is high
						else begin 
							state = WARMUP;
							pulses = 0;
							out = 0;
							delay_1us = 0;
							trigger_10us = 0;
							read_1ms = 0;
							pulse_width = 0;
						end
					end
					
					
					//state 2: 10us trigger
            TRIGGER: begin
						//reset is low
						if (!reset) begin
							if (trigger_10us < 10'd499) begin //trigger signal
								trigger_10us = trigger_10us + 1'd1;
								trigger = 1;
							end
							else begin  //end of trigger signal
								state = DETECT;
							end
						end
						//reset is high
						else begin
							state = WARMUP;
							pulses = 0;
							out = 0;
							delay_1us = 0;
							trigger_10us = 0;
							read_1ms = 0;
							pulse_width = 0;
						end
					end
					
					
				// state 3: read echo and set output
            DETECT: begin
						trigger = 0;
						//reset is low
						if (!reset) begin
							//reading 1ms pulse
							if (read_1ms < 17'd50000) begin
								if (echo_rx && rec == 0) begin
									pulses = pulses + 1'd1;
									pulse_width = pulse_width + 1'd1;
									rec = 1;
								end
								else if (rec == 1 && echo_rx) begin
									pulse_width = pulse_width + 1;
								end
								else if(!echo_rx && rec ==1) begin
									rec = 0;
								end
								read_1ms = read_1ms + 1;
							end
							//generating output
							else begin
								if (!out) begin
									if (pulse_width == 16'd29410) begin
										out = 1;
									end
									else begin
										out = 0;
									end
								end
								else begin
									out = 1;
								end
								rec = 0;
								state = WARMUP;
								pulse_width = 0;
								delay_1us = 0;
								trigger_10us = 0;
								read_1ms = 0;
							end 
						end
						//reset is high
						else begin
							state = WARMUP;
							pulse_width = 0;
							pulses = 0;
							out = 0;
							delay_1us = 0;
							trigger_10us = 0;
							read_1ms = 0;
						end
					end
    endcase
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule
