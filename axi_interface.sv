

interface axi_if(input logic ACLK, ARESETn);
    import axi_typedefs::*;
    
    // Write Address Channel
    axi_id_t     AWID;
    axi_addr_t   AWADDR;
    logic [3:0]  AWLEN;
    logic [2:0]  AWSIZE;
    logic [1:0]  AWBURST;
    logic        AWVALID;
    logic        AWREADY;
    
    // Write Data Channel
    axi_data_t   WDATA;
    axi_strb_t   WSTRB;
    logic        WLAST;
    logic        WVALID;
    logic        WREADY;
    
    // Write Response Channel
    axi_id_t     BID;
    axi_resp_t   BRESP;
    logic        BVALID;
    logic        BREADY;
    
    // Read Address Channel
    axi_id_t     ARID;
    axi_addr_t   ARADDR;
    logic [3:0]  ARLEN;
    logic [2:0]  ARSIZE;
    logic [1:0]  ARBURST;
    logic        ARVALID;
    logic        ARREADY;
    
    // Read Data Channel
    axi_id_t     RID;
    axi_data_t   RDATA;
    axi_resp_t   RRESP;
    logic        RLAST;
    logic        RVALID;
    logic        RREADY;

    modport master(
        output AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID,
        input  AWREADY,
        output WDATA, WSTRB, WLAST, WVALID,
        input  WREADY,
        input  BID, BRESP, BVALID,
        output BREADY,
        output ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID,
        input  ARREADY,
        input  RID, RDATA, RRESP, RLAST, RVALID,
        output RREADY
    );

    modport slave(
        input  AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWVALID,
        output AWREADY,
        input  WDATA, WSTRB, WLAST, WVALID,
        output WREADY,
        output BID, BRESP, BVALID,
        input  BREADY,
        input  ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARVALID,
        output ARREADY,
        output RID, RDATA, RRESP, RLAST, RVALID,
        input  RREADY
    );
endinterface