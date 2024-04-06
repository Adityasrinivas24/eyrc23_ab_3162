module Bluetooth(
    input clk,
    input rst,
    input fault_detect,
    input node_changed,
    input node,
    input fault,
    output [5:0] num_nodes,
    output tx,           // to be connected to rxd of HC-05
    output tx_done
);

parameter CHAR_F = 8'b01000110;
parameter CHAR_I = 8'b01001001;
parameter CHAR_M = 8'b01001101;

parameter CHAR_C = 8'b01000011;
parameter CHAR_S = 8'b01010011;
parameter CHAR_U = 8'b01010101;

parameter CHAR_E = 8'b01000101;
parameter CHAR_R = 8'b01010010;

parameter DASH = 8'b00101101;
parameter HASH = 8'b00100011;

parameter ZERO = 8'b00110000;
parameter ONE = 8'b00110001;
parameter TWO = 8'b00110010;
parameter THREE = 8'b00110011;

// Instantiate uart_tx module
uart_tx uart_inst(
    .clk_50M(clk),
    .data({CHAR_F, CHAR_I, CHAR_M, DASH, CHAR_C, CHAR_S, CHAR_U, ONE, DASH, HASH}),
    .tx(tx)
);

// Declare internal signals
reg tx_done_internal;
reg [5:0] node_num;
reg [3:0] message_idx;
reg [9:0] message_string;

// Count number of node changes
always @(posedge node_changed) begin
    if (node_changed) begin
        node_num <= node_num + 1;
    end
end


// State machine for sending a single message
always @(posedge clk or posedge rst) begin
    if (rst) begin
        message_idx <= 0;
    end else if (fault_detect) begin
        // Load message string into memory
        message_string <= {CHAR_F, CHAR_I, CHAR_M, DASH, CHAR_C, CHAR_S, CHAR_U, ONE, DASH, HASH};
        
        // Start sending the message
        if (tx_done_internal == 0) begin
            uart_inst.data <= message_string;
            tx_done_internal <= 1;
        end else if (message_idx[3:0] == 9'd0) begin
            // Reset for the next message
            message_idx <= message_idx + 1;
            tx_done_internal <= 0;
        end
    end
end

assign num_nodes = node_num;
assign tx_done = tx_done_internal;

endmodule
