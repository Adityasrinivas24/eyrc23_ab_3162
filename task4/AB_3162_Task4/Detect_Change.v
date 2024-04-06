module Detect_Change(
    input clk,
    input fault,
    input rst,
    input node,
    input data_set_done,
    output reg fault_detect,
    output reg node_changed,
    output s_fault,
    output s_node,
    output wire [5:0] node_counter
);
    parameter IDLE = 3'b000;
    parameter FAULT_DETECT = 3'b001;
    parameter NODE_CHANGED = 3'b010;
    
    reg reg_fault = 0;
    reg [2:0] state = IDLE;
    reg reg_node = 0;
    reg [5:0] reg_node_counter = 6'd1;

    always @(posedge clk) begin
        if (rst == 0) begin
            state <= IDLE;
            reg_node = 0;
            reg_fault = 0;
            fault_detect = 0;
            node_changed = 0;
            reg_node_counter = 0;
        end
        else begin
            case (state)
                IDLE :
                    begin
                        fault_detect <= 0;
                        node_changed <= 0;
                        if (fault != reg_fault && data_set_done == 1)
                            state <= FAULT_DETECT;
                        else if (node != reg_node && data_set_done == 1) begin
                            state <= NODE_CHANGED;
                            reg_node_counter <= reg_node_counter + 1;
                        end else
                            state <= IDLE;
                    end
                FAULT_DETECT :
                    begin
                        reg_fault <= fault;
                        fault_detect <= (fault) ? 1 : 0; // Simplified assignment
                        state <= IDLE;
                    end
                NODE_CHANGED :
                    begin
                        reg_node <= node;
                        node_changed <= (node) ? 1 : 0; // Simplified assignment
                        state <= IDLE;
                    end
            endcase
        end
    end

    assign s_fault = fault;
    assign s_node = node;
    assign node_counter = reg_node_counter;

endmodule
