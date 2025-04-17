`include "defines.sv"
`include "typedefs.sv"

module axi_slave(
    axi_if.slave axi,
    input logic  clk,
    input logic  rst_n
);
    import axi_typedefs::*;

    // Memory array
    axi_data_t memory [bit [`AXI_ADDR_WIDTH-1:0]];
    
    // Write handling
    always_ff @(posedge clk) begin
        if(axi.AWVALID && axi.AWREADY) begin
            // Store write address
        end
        if(axi.WVALID && axi.WREADY) begin
            // Store write data
        end
    end
    
    // Read handling
    always_ff @(posedge clk) begin
        if(axi.ARVALID && axi.ARREADY) begin
            // Process read address
        end
    end
    
    // Implement full AXI protocol handling
endmodule