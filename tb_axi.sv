`timescale 1ns/1ps
`include "defines.sv"
`include "typedefs.sv"

module tb_axi;
    logic clk;
    logic rst_n;
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Reset generation
    initial begin
        rst_n = 0;
        #20 rst_n = 1;
    end
    
    // Instantiate interface
    axi_if axi_intf(clk, rst_n);
    
    // Instantiate DUT
    axi_master master(
        .axi(axi_intf.master),
        .clk(clk),
        .rst_n(rst_n)
    );
    
    axi_slave slave(
        .axi(axi_intf.slave),
        .clk(clk),
        .rst_n(rst_n)
    );
    
    // Test sequence
    initial begin
        // Initialize
        #30;
        
        // Perform test transactions
        // Write transaction
        // Read transaction
        
        #100;
        $finish;
    end
endmodule