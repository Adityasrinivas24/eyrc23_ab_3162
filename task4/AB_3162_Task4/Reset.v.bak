module reset(
					input key,
					input [3:0]num_nodes,
					output rst
);
	parameter HIGH = 1'b0;
	parameter LOW = 1'b1;
	reg r_state = HIGH;
	reg r_rst = 0;
	
	always@(negedge key)
	begin
		case(r_state)
			HIGH :
				begin
					r_rst = 1;
					r_state = LOW;
				end
			LOW :
				begin
					r_rst = 0;
					r_state = HIGH;
				end
		endcase
	end 
	
	assign rst = r_rst;
	
endmodule 