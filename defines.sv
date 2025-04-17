`ifndef AXI_DEFINES
`define AXI_DEFINES

// Core parameters
`define AXI_ADDR_WIDTH   32
`define AXI_DATA_WIDTH   64
`define AXI_ID_WIDTH     8
`define AXI_USER_WIDTH   4
`define AXI_REGION_MAP   4

// Derived parameters
`define AXI_STRB_WIDTH   (`AXI_DATA_WIDTH/8)
`define AXI_MAX_BURST_LEN 256

// Protocol options
`define AXI_CACHE_WIDTH  4
`define AXI_PROT_WIDTH   3
`define AXI_QOS_WIDTH    4

// Burst types
`define AXI_BURST_FIXED  2'b00
`define AXI_BURST_INCR   2'b01
`define AXI_BURST_WRAP   2'b10

// Response types
`define AXI_RESP_OKAY    2'b00
`define AXI_RESP_EXOKAY  2'b01
`define AXI_RESP_SLVERR  2'b10
`define AXI_RESP_DECERR  2'b11

`endif