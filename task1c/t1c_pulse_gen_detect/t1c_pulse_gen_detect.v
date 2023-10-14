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


	 parameter WARMUP = 2'b00;
    parameter TRIGGER_PULSE = 2'b01;
    parameter DETECT_PULSE = 2'b10;
	 parameter OUTPUT = 2'b11;
	 

    // Internal signals
    reg [1:0] next_state;
    reg [31:0] delay_counter; // 10 us delay counter
    reg [22:0] pulse_width_counter;
    reg [31:0] trigger_counter;// For measuring pulse width
	
	 initial begin
			next_state <= WARMUP;
	 end
	 
	 
	 always @(posedge clk_50M or posedge reset) begin
		if(reset)begin
		      state <= 0;
            pulses <= 0;
            trigger <= 0;
            out <= 0;
            delay_counter <= 0;
            pulse_width_counter <= 0;
        end
		
		
		else begin
		
			state <= next_state;
			
			case(state)
			
			         WARMUP: begin
                    trigger <= 0;
                    out <= 0;
                    if (delay_counter < 50) begin
                        delay_counter <= delay_counter + 1;
                        next_state <= WARMUP;
                    end
                    else begin
                        next_state <= TRIGGER_PULSE;
                    end
                end

						
						TRIGGER_PULSE:begin
						
						if (trigger_counter < 500) begin
							 trigger_counter <= trigger_counter + 1;
							trigger <= 1;
							 next_state <= TRIGGER_PULSE;
						 end
						
							out <= 0;
							pulse_width_counter <= 0;
							next_state <= DETECT_PULSE;
					 end
						
						
						 DETECT_PULSE:begin
						 
							trigger <= 0;
							out <= 0;
							
							pulse_width_counter <= pulse_width_counter + 1 ;
							
							if (echo_rx) begin
                        pulses <= pulse_width_counter;
                        if (pulse_width_counter == 588200) begin
                            out <= 1;
                        end
                        pulse_width_counter <= 0;
                        next_state <= OUTPUT;
                    end
                    else begin
                        next_state <= DETECT_PULSE;
                    end
                end
							
						
						 OUTPUT: begin
						 
                    trigger <= 0;
                    out <= 1;
                    next_state <= WARMUP;
                end
				endcase
			end
		end
		
		
			
			
			
		
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule
