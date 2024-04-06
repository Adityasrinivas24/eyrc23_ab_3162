module Bluetooth_testing(
				input clk,
				input rst,
				input detect,
				input [2:0]fault,
				input node,
				output [5:0]num_nodes,
				output tx,
				output tx_done
);
	// input [7:0]TX_BYTE removed for now may be added later 
	// Time period 20ns freq = 50MHz
	parameter clks_per_bit = 434;
	parameter IDLE = 3'b000;
	parameter TX_START_BIT = 3'B001;
	parameter TX_DATA_BITS = 3'b011;
	parameter TX_STOP_BIT = 3'b100;
	parameter CLEANUP = 3'b101;
	
	parameter HASH = 8'b00100011;
	parameter DASH = 8'b00101101;
	parameter CHARS = 8'b01010011;
	parameter CHARI = 8'b01001001;
	parameter CHARF = 8'b01000110;
	parameter CHARC = 8'b01000011;
	parameter CHART = 8'b01010100;
	parameter CHARW = 8'b01010111;
	parameter CHARN = 8'b01001110;
	parameter CHARO = 8'b01001111;
	parameter CHARD = 8'b01000100;
	parameter CHARE = 8'b01000101;
	parameter ZERO = 8'b00110000;
	
	reg [3:0]next_limit=8;
	reg [3:0]next = 9;
	reg [2:0]r_state = IDLE;
	reg [8:0]r_clock_count = 0;
	reg [2:0]r_bit_index = 0;
	reg [7:0]r_data_bits = 0;
	reg r_TX_DONE = 1;
	reg [5:0]node_num = 1;
	reg r_TX_SERIAL = 1;
	
	
	always @(posedge clk)
	begin
		if(rst == 0)
		begin
			r_state = IDLE;
		end
		case(r_state)
			IDLE :
				begin
					r_clock_count <= 0;
					r_bit_index <= 0;
					r_TX_SERIAL <= 1'b1;
					r_TX_DONE <= 1'b1;
					if(detect == 1)
					begin
						r_state <= TX_START_BIT;
						next <= 0;
						if(node == 1)
							next_limit <= 4;
						else
							next_limit <= 8;
					end
					else if(next <= next_limit)
						r_state <= TX_START_BIT;
					else
						r_state <= IDLE;
				end
				
			TX_START_BIT :begin

					r_TX_SERIAL <= 0;
					r_TX_DONE <= 0;

					if(r_clock_count < clks_per_bit-1)begin
						r_clock_count <= r_clock_count + 1'b1;
						r_state <= TX_START_BIT;

					end else begin
						r_clock_count <= 0;
						r_state <= TX_DATA_BITS;
						if (next == 0)
							r_data_bits <= (node == 1)? CHARN: CHARS;
						else if (next == 1)
							r_data_bits <= (node == 1)? CHARO: CHARI;
						else if (next == 2)
							r_data_bits <= (node == 1)? CHARD: DASH;
						else if (next == 3)
							r_data_bits <= (node == 1)? CHARE: CHARW;
						else if (next == 4)
					    begin
							if(node == 1)begin
								r_data_bits = ZERO + node_num;
								node_num = node_num + 1;
							end else
								r_data_bits <= DASH;
						end
						else if (next == 5)
						begin
							if(fault == 1)
								r_data_bits <= CHARF;
							else if (fault == 2)
								r_data_bits <= CHARC;
							else
								r_data_bits <= CHARC;
						end
						else if (next == 6)
						begin
							if(fault == 1)
								r_data_bits <= CHARI;
							else if (fault == 2)
								r_data_bits <= CHART;
							else
								r_data_bits <= CHARS;
						end
						else if (next == 7)
							r_data_bits <= DASH;
						else if (next == 8)
							r_data_bits <= HASH;
						else
							r_data_bits <= 0;
					end
				end
				
			TX_DATA_BITS :
				begin
					r_TX_SERIAL <= r_data_bits[r_bit_index];
					
					if(r_clock_count < clks_per_bit-1)begin
						r_clock_count <= r_clock_count + 1'b1;
						r_state <= TX_DATA_BITS;
					end
					else begin
						if(r_bit_index == 7)
						begin
							r_clock_count <= 0;
							r_state <= TX_STOP_BIT;
						end
						else
						begin
							r_clock_count <= 0;
							r_state <= TX_DATA_BITS;
							r_bit_index <= r_bit_index + 1'b1;
						end
					end
				end
			
			TX_STOP_BIT :
				begin
					r_TX_SERIAL <= 1;
					if(r_clock_count < clks_per_bit-1)
					begin
						r_clock_count <= r_clock_count + 1'b1;
						r_state <= TX_STOP_BIT;
					end
					else
					begin
						r_state <= IDLE;
						next <= next + 1'b1;

						if(next > next_limit)
							r_TX_DONE <= 1;
						else
							r_TX_DONE <= 0;
					end
				end

				
			default :begin
					r_state <= IDLE;
			end
		endcase
	end
	
	assign num_nodes = node_num;
	assign tx = r_TX_SERIAL;
	assign tx_done = r_TX_DONE;
	
endmodule 