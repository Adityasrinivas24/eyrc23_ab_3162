`timescale 1ps/1ps
module tb;

reg clk_50M = 0, rx;

wire [7:0] rx_msg;
reg  [7:0] rx_exp;

wire rx_complete;
reg  exp_rx_complete;

integer err = 0;
reg [99:0] data = 0;
reg [7:0] msg = 0;

integer i = 0, j = 0, k = 0, fd = 0, fw = 0, s = 0, f=0;
parameter cpb = 434;
integer counter = 0;
reg [(8*10) - 1:0] str; //10 chars can be stored
reg flag = 0;
uart_rx uut(.clk_50M, .rx, .rx_msg, .rx_complete);

initial begin
	fd = $fopen("dump_txt.txt", "r");
	while(! $feof(fd)) begin
		$fgets(str, fd);
		if(str != 0) begin
			data[i] = str[15:8] - 48;
		end
		i = i + 1;
	end
	$fclose(fd);
end

initial begin
	rx_exp <= 0; #86800000;
	for(k = 0; k < 10; k = k+1) begin
		msg = data[(10*k+1) + : 8];
		rx_exp <= {<<{msg}}; #86800000;
		s = s + 1;
	end
end

initial begin
	fd = $fopen("dump_txt.txt","r");
	while(! $feof(fd)) begin
        $fgets(str, fd);
        if(str != 0) begin
            rx = str[15:8] - 48; #8680000;
        end
        rx = 1'b0;
	end
	$fclose(fd);
end

always begin
	clk_50M = ~clk_50M; #10000;
end

always @(posedge clk_50M) begin
	exp_rx_complete <= 1'b0;
	if(s >= (i-1)/10) begin
		exp_rx_complete = 1'b0;
	end
	else begin
		if(counter == 4340) begin
			exp_rx_complete <= 1'b1;
			counter = 0;
		end
		counter = counter + 1;
	end

end

always begin
    #10;
	if (rx_msg !== rx_exp) err = err + 1'b1;
    if (rx_complete !== exp_rx_complete) err = err + 1'b1;
end

always @(posedge clk_50M) begin
    if (k == ((i-1)/10) && !flag) begin
        if (err !== 0) begin
            fw = $fopen("results.txt","w");
            $fdisplay(fw, "%02h","Errors");
            $display("Error(s) encountered, please check your design!");
            $fclose(fw);
        end
        else begin
            fw = $fopen("results.txt","w");
            $fdisplay(fw, "%02h","No Errors");
            $display("No errors encountered, congratulations!");
            $fclose(fw);
        end
        flag = 1;
    end
end

endmodule