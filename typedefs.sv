`include "defines.sv"

package axi_typedefs;

typedef enum logic [1:0] {
    OKAY   = 2'b00,
    EXOKAY = 2'b01,
    SLVERR = 2'b10,
    DECERR = 2'b11
} axi_resp_t;

typedef logic [`AXI_ID_WIDTH-1:0]   axi_id_t;
typedef logic [`AXI_ADDR_WIDTH-1:0] axi_addr_t;
typedef logic [`AXI_DATA_WIDTH-1:0] axi_data_t;
typedef logic [`AXI_STRB_WIDTH-1:0] axi_strb_t;

endpackage