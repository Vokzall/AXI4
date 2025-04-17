`include "axi_header.svh"

module axi_slave #(
    parameter int MEM_SIZE = 1024
)(
    axi_if.slave      bus,
    input logic       clk,
    input logic       rst_n
);
    import axi_typedefs::*;

    // Memory model
    logic [`AXI_DATA_WIDTH-1:0] memory[0:MEM_SIZE-1];
    
    // Transaction tracking
    struct packed {
        axi_id_t    id;
        axi_addr_t  addr;
        logic [7:0] len;
        logic [2:0] size;
        logic [1:0] burst;
        int         count;
    } active_write, active_read;

    // Write handling
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            bus.AWREADY <= 0;
            bus.WREADY  <= 0;
            bus.BVALID  <= 0;
            bus.ARREADY <= 0;
            bus.RVALID  <= 0;
        end else begin
            // Write address channel
            if (bus.AWVALID && !bus.AWREADY) begin
                active_write.id    = bus.AWID;
                active_write.addr  = bus.AWADDR;
                active_write.len   = bus.AWLEN;
                active_write.size  = bus.AWSIZE;
                active_write.burst = bus.AWBURST;
                active_write.count = 0;
                bus.AWREADY <= 1;
            end else begin
                bus.AWREADY <= 0;
            end

            // Write data channel
            if (bus.WVALID && bus.WREADY) begin
                // Store data to memory
                memory[active_write.addr >> ($clog2(`AXI_STRB_WIDTH))] = bus.WDATA;
                
                // Update address
                case (active_write.burst)
                    `AXI_BURST_INCR: active_write.addr += (1 << active_write.size);
                    `AXI_BURST_WRAP: begin
                        int wrap_boundary = (1 << active_write.size) * (active_write.len + 1);
                        active_write.addr = (active_write.addr & ~(wrap_boundary-1)) | 
                                          ((active_write.addr + (1 << active_write.size)) & (wrap_boundary-1));
                    end
                endcase

                active_write.count++;
                if (bus.WLAST) begin
                    bus.BVALID <= 1;
                    bus.BID    <= active_write.id;
                    bus.BRESP  <= `AXI_RESP_OKAY;
                end
            end

            // Write response
            if (bus.BVALID && bus.BREADY) begin
                bus.BVALID <= 0;
            end

            // Read address channel
            if (bus.ARVALID && !bus.ARREADY) begin
                active_read.id    = bus.ARID;
                active_read.addr  = bus.ARADDR;
                active_read.len   = bus.ARLEN;
                active_read.size  = bus.ARSIZE;
                active_read.burst = bus.ARBURST;
                active_read.count = 0;
                bus.ARREADY <= 1;
                bus.RVALID  <= 1;
            end else begin
                bus.ARREADY <= 0;
            end

            // Read data channel
            if (bus.RVALID && bus.RREADY) begin
                bus.RDATA <= memory[active_read.addr >> ($clog2(`AXI_STRB_WIDTH))];
                bus.RID   <= active_read.id;
                bus.RRESP <= `AXI_RESP_OKAY;
                bus.RLAST <= (active_read.count == active_read.len);
                bus.RUSER <= 0;

                // Update address
                case (active_read.burst)
                    `AXI_BURST_INCR: active_read.addr += (1 << active_read.size);
                    `AXI_BURST_WRAP: begin
                        int wrap_boundary = (1 << active_read.size) * (active_read.len + 1);
                        active_read.addr = (active_read.addr & ~(wrap_boundary-1)) | 
                                         ((active_read.addr + (1 << active_read.size)) & (wrap_boundary-1));
                    end
                endcase

                active_read.count++;
                if (bus.RLAST) begin
                    bus.RVALID <= 0;
                end
            end
        end
    end

endmodule