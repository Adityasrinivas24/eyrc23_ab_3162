`timescale 1ps/1ps
module tb;

reg  clk_50M = 0;
wire tx;
reg  tx_exp = 0;
wire time_error;

integer err = 0, prev_err = 0;
reg [99:0] data = 0;
reg [7:0]  msg = 99;
integer i = 0, j = 0, k = 0, s = 0;
assign #(1,1) time_error = tx_exp ^ tx;

integer fd = 0, fw = 0;

reg [(8*10) - 1:0] str; //10 chars can be stored

uart_tx uut(.clk_50M, .tx, .data(msg));

always begin
	clk_50M = ~clk_50M; #10000;
end

initial begin
	fd = $fopen("dump_txt.txt","r");
	while(! $feof(fd)) begin
		$fgets(str, fd);
		if(str != 0) begin
			data[i] = str[15:8] - 48;
		end
		i = i + 1;
		msg <= data[(10*k +1) + : 8];
	end
	$fclose(fd);
	k = k + 1;
end

initial begin
	fd = $fopen("dump_txt.txt", "r");
	while(! $feof(fd)) begin
		if(j < 10) begin
			$fgets(str, fd);
			if(str != 0) begin
				tx_exp <= str[15:8] - 48; #8680000;
			end
		j = j + 1;
		end
		else begin
			j = 0;
			msg <= data[(10*k + 1) +: 8];
			k = k + 1;
		end
	end
	$fclose(fd);
end

always begin
    #10;
	if(tx !== tx_exp) err = err + 1;
end

always @(clk_50M) begin
    if (k == ((i-1)/10)+1) begin
        if (err !== 0) begin
            fw = $fopen("result.txt","w");
            $fdisplay(fw, "%02h","Errors");
            $display("Error(s) encountered, please check your design!");
            $fclose(fw);
        end
        else begin
            fw = $fopen("result.txt","w");
            $fdisplay(fw, "%02h","No Errors");
            $display("No errors encountered, congratulations!");
            $fclose(fw);
        end
        k = 0;
    end
end

endmodule