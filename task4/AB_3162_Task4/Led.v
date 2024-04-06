module Led(
    input rst,
    input fault_detect,
    input node_changed,
	 input wire [5:0] node_counter,
    output reg [2:0] rgb_led_1,
    output reg [2:0] rgb_led_2,
    output reg [2:0] rgb_led_3
);

parameter OFF = 3'b000;
parameter BLUE = 3'b001;
parameter RED = 3'b100;
parameter GREEN = 3'b010;

reg [31:0] delay_counter;

always @(posedge rst or posedge fault_detect or posedge node_changed) begin
        if (rst) begin
            rgb_led_1 <= OFF;
            rgb_led_2 <= OFF;
            rgb_led_3 <= OFF;
				delay_counter <= 0;
        end else begin
          
            if (fault_detect) begin         // If fault_detect is high, set all LEDs to Blue
                rgb_led_1 <= BLUE;  
                rgb_led_2 <= BLUE;
                rgb_led_3 <= BLUE;
            end
         
            else if (node_changed) begin        // If node_changed is high, turn off all LEDs
                rgb_led_1 <= OFF;
                rgb_led_2 <= OFF;
                rgb_led_3 <= OFF;
            end
				else if (node_counter == 13 )begin
				
					if (delay_counter < 100000000) begin   // Glow all three LEDs GREEN with a 1-second delay
                delay_counter <= delay_counter + 1;
					end else begin
                rgb_led_1 <= GREEN;
                rgb_led_2 <= GREEN;
                rgb_led_3 <= GREEN;
					end
				end else begin
          
			 //Reset all registers
            delay_counter <= 0;
            rgb_led_1 <= OFF;
            rgb_led_2 <= OFF;
            rgb_led_3 <= OFF;
            end
						
        end
    end
endmodule 