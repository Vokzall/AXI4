`include "axi_header.svh"

module axi_master(
    axi_if.master axi,
    input logic   clk,
    input logic   rst_n
);
    import axi_typedefs::*;

    // FSM states
    enum logic [2:0] {
        IDLE,
        WRITE_ADDR,
        WRITE_DATA,
        WRITE_RESP,
        READ_ADDR,
        READ_DATA
    } state;

    // Transaction storage
    axi_id_t    trans_id;
    axi_addr_t  trans_addr;
    axi_data_t  trans_data;
    axi_strb_t  trans_strb;
    logic [3:0] trans_len;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
            // Reset all outputs
            {axi.AWVALID, axi.WVALID, axi.BREADY, axi.ARVALID, axi.RREADY} <= '0;
        end
        else begin
            case(state)
                IDLE: begin
                    // Start new transaction here
                end
                
                WRITE_ADDR: begin
                    if(axi.AWREADY) begin
                        axi.AWVALID <= 0;
                        state <= WRITE_DATA;
                    end
                end
                
                // Other states handling...
                
            endcase
        end
    end
    
    // Implement write and read transactions handling
endmodule