module sequence_detector_test_bench;
  reg clock;
  reg [3:0] number;
  wire pattern;

  sequence_detector uut( .clock(clock), .number(number), .pattern(pattern));
  

  
  always begin
    #5;
    clock = ~clock;
  end

  initial begin
  clock=1'b0; #10;
    number = 4'b0001; #10;
    number = 4'b0000; #10;
    number = 4'b1001; #10;
    number = 4'b0100; #10;
    $finish;
  end
endmodule
