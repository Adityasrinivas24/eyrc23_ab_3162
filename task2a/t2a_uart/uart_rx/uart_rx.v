// AstroTinker Bot : Task 2A : UART Receiver
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to receive UART Rx data packet from receiver line and then update the rx_msg and rx_complete data lines.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Receiver

Input:  clk_50M - 50 MHz clock
        rx      - UART Receiver

Output: rx_msg      - read incoming message
        rx_complete - message received flag
*/

// module declaration
module uart_rx (
  input clk_50M, rx,
  output reg [7:0] rx_msg,
  output reg rx_complete
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

////////////////////////// Add your code here ////////////////////////////



parameter CLKS_PER_BIT = 50000000/115200;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA =  2'b10;
parameter STOP  = 2'b11;


reg [9:0] clk_count;
reg [1:0] state;
reg [2:0] bitIdx;
reg [7:0] data_store;

initial begin

rx_msg = 0; rx_complete = 0; clk_count = 0; 

end

always @(posedge clk_50M or negedge rx) begin
	
	case(state)
		
		IDLE:begin
			rx_complete <= 1'b0;  
         bitIdx <= 3'b0;
	
			if (rx == 1'b0) begin
			  clk_count <= 0;
           state = START;
			 end
        end
	
		
		START:begin
		
          if (clk_count == CLKS_PER_BIT-1 && rx == 1'b0)begin
              clk_count = 0;
              state = DATA;   
				end 
      
          else begin
            clk_count <= clk_count + 1;
          end
        end		
	
	
	
		DATA:begin
			 
          if (clk_count < CLKS_PER_BIT- 1)begin
            clk_count <= clk_count + 1;
                
          end else  begin
            clk_count = 0;
            data_store[bitIdx] <= rx;
           
            if (bitIdx == 3'd7)begin
					bitIdx <= 3'd0;
              state = STOP;
            end
				
            else begin
				  bitIdx <= bitIdx + 1;
            end
        end 
		  
      end 
	
	
		 STOP:begin
     
          if (clk_count < CLKS_PER_BIT -2)begin
           clk_count <= clk_count + 1;
          end
			 
          else begin
            clk_count = 10'd0;
				rx_msg = {data_store[0], data_store[1], data_store[2], data_store[3], data_store[4], data_store[5], data_store[6], data_store[7]}>>1;
        
            state = IDLE;
            rx_complete = (rx_msg != 8'd0) ? 1'b1 : 1'b0;
				
        end
      end 
		  
		default: state = IDLE;
	
     endcase
	end

		
//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule


