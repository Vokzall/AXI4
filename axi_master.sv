`include "defines.sv"
`include "typedefs.sv"

module axi_master(
    axi_if.master      axi,
    // Wrapper control signals
    input  logic [2:0] next_state,
    input  axi_id_t    otrans_id,
    input  axi_addr_t  otrans_addr,
    input  logic [2:0] otrans_size,
    input  logic [3:0] otrans_len,
    input  logic [1:0] otrans_burst
    output axi_id_t    itrans_id,
    output axi_data_t  itrans_data,
    output axi_resp_t  itrans_resp,
    output             itrans_data_valid // 1 - responce data is valid
);
    import axi_typedefs::*;

    // FSM states
    enum logic [2:0] {
        IDLE,
        READ_REQ,
        READ_RESP,
        READ_BEAT_PAUSE // To wait for the next data to arrive
    } state;
    
    always_ff @(posedge axi.ACLK, negedge axi.ARESETn) begin
        if(!axi.ARESETn) begin
            state <= IDLE;
            itrans_id   <= 'x;
            itrans_data <= 'x;
            itrans_resp <= 'x;
            itrans_data_valid <= '0;
            // Read request signals reset
            axi.ARID    <= 'x;
            axi.ARADDR  <= 'x;
            axi.ARSIZE  <= 'x;
            axi.ARLEN   <= 'x;
            axi.ARBURST <= 'x;
            axi.ARVALID <= '0;
            // Read responce signals reset
            axi.RREADY  <= '0
        end else begin
            case(state)
                IDLE: begin
                    state <= next_state;
                    
                    axi.ARVALID <= 1'b0;
                    axi.RREADY  <= 1'b0;

                    itrans_id   <= 'x;
                    itrans_data <= 'x;
                    itrans_resp <= 'x;
                    itrans_data_valid <= 1'b0;
                end
                
                READ_REQ: begin
                    if (!axi.ARREADY) begin
                        axi.ARID    <= otrans_id;
                        axi.ARADDR  <= otrans_addr;
                        axi.ARSIZE  <= otrans_size;
                        axi.ARLEN   <= otrans_len;
                        axi.ARBURST <= otrans_burst;
                        axi.ARVALID <= 1'b1;
                    end else begin
                        axi.ARID    <= 'x;
                        axi.ARADDR  <= 'x;
                        axi.ARSIZE  <= 'x;
                        axi.ARLEN   <= 'x;
                        axi.ARBURST <= 'x;
                        axi.ARVALID <= '0;

                        state <= READ_RESP;
                    end
                end

                READ_RESP: begin
                    axi.ARVALID <= 1'b0;
                    if (axi.RVALID) begin
                        axi.RREADY  <= 1'b1;

                        itrans_id   <= axi.RID;
                        itrans_data <= axi.RDATA;
                        itrans_resp <= axi.RRESP;
                        itrans_data_valid <= 1'b1;

                        if (axi.RLAST) begin
                            state <= IDLE;
                        end else begin
                            state <= READ_BEAT_PAUSE;
                        end
                    end
                end

                READ_BEAT_PAUSE: begin
                    axi.RREADY <= 1'b0;

                    itrans_id   <= 'x;
                    itrans_data <= 'x;
                    itrans_resp <= 'x;
                    itrans_data_valid <= 1'b0;

                    state <= READ_RESP;
                end
                
            endcase
        end
    end
    
endmodule
