// AstroTinker Bot : Task 2A : UART Transmitter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to generate UART Tx data packet to transmit the messages based on the input data.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Transmitter

Input:  clk_50M - 50 MHz clock
        data    - 8-bit data line to transmit
Output: tx      - UART Transmission Line
*/

// module declaration
module uart_tx(
    input  clk_50M,
    input  [7:0] data,
    output reg tx
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////

parameter CLKS_PER_BIT = 434;
parameter IDLE = 2'b00;
parameter START = 2'b01;        
parameter DATA = 2'b10;         
parameter STOP = 2'b11;        


reg [1:0] state;
reg [9:0] clk_count = 0;
reg [2:0] bitIdx;
reg [7:0] data_store;


initial begin
	 tx <= 0;
end


////////// Add your code here ///////////////////

always@(posedge clk_50M)begin

	case(state)
		
		
		IDLE:begin
			if(clk_count < 8*CLKS_PER_BIT)begin
				if(data == 8'b00000000)begin
					tx <= 1'b1;
				end else begin
					tx <= 0;
					clk_count <= 0;
					state <= START;
				end 
				clk_count <= clk_count + 1;
			end else begin
				tx <= 1;
				state <= IDLE;
		 end
		end
		
		
		 START:begin
			if(clk_count < CLKS_PER_BIT - 4)begin
				tx <= 1'b0;
				clk_count <= clk_count + 1;
				state <= START;
			end
			
			else begin
				clk_count <= 0;
				bitIdx <= 0;
				state <= DATA;
			end
		end
		
		
		
		 DATA:begin
			 if(clk_count <= CLKS_PER_BIT)begin
					tx <= data_store[bitIdx];
					clk_count <= clk_count + 1;
               state <= DATA;
			 end
				
			else begin
				clk_count <= 0;
				
				if(bitIdx == 7)begin
					bitIdx <= 0;
					state <= STOP;
				end
				
				else begin
					bitIdx <= bitIdx + 1;
					state <= DATA;
				end
			end				
		end
		

		
		 STOP:begin 
			if(clk_count < CLKS_PER_BIT)begin
					tx = 1'b1;
					clk_count <= clk_count + 1;
               state <= STOP;
			end
			
			else begin
					clk_count = 0;
					state <= IDLE;
			end
		end
			
			
		default:state <= IDLE;
		
	endcase
	
	data_store <= data;
end


//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule