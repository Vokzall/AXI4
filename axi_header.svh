// axi_header.svh
`ifndef AXI_HEADER
`define AXI_HEADER

`include "defines.sv"
`include "typedefs.sv"
`include "axi_interface.sv"

package axi_pkg;
    import axi_typedefs::*;

    // Burst Types
    typedef enum logic [1:0] {
        FIXED = 2'b00,
        INCR  = 2'b01,
        WRAP  = 2'b10
    } axi_burst_t;

    // Transaction Structure
    typedef struct packed {
        axi_id_t    id;
        axi_addr_t  addr;
        axi_data_t  data;
        axi_strb_t  strb;
        logic [3:0] len;
        axi_burst_t burst;
        logic [2:0] size;
    } axi_transaction_t;

    // Function to calculate address increment
    function automatic axi_addr_t calculate_next_addr(
        input axi_addr_t  current_addr,
        input logic [2:0] size,
        input axi_burst_t burst
    );
        logic [7:0] increment = 1 << size;
        case(burst)
            INCR: return current_addr + increment;
            WRAP: begin
                // Wrap boundary calculation
                logic [31:0] boundary = increment * (2 ** $clog2(increment));
                return (current_addr & ~(boundary-1)) | 
                       ((current_addr + increment) & (boundary-1));
            end
            default: return current_addr; // FIXED
        endcase
    endfunction

    // Response checker task
    task automatic check_response(
        input axi_resp_t resp,
        input string     operation
    );
        if(resp != OKAY) begin
            $display("[ERROR] %s operation failed with response: %s", 
                     operation, resp.name());
        end
    endtask

endpackage

`endif // AXI_HEADER