`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "apb_if.sv"
`include "apb_reg.sv"
`include "apb_transaction.sv"
`include "apb_adapter.sv"
`include "apb_driver.sv"
`include "apb_sequencer.sv"
`include "apb_monitor.sv"
`include "apb_scoreboard.sv"
`include "apb_agent.sv"
`include "apb_env.sv"
`include "apb_config.sv"
`include "apb_sequence.sv"
`include "apb_test.sv"
`include "dut.sv"

module test;

    logic pclk;
    logic [31:0]    paddr;
    logic           psel;
    logic           penable;
    logic           pwrite;
    logic [31:0]    prdata;
    logic [31:0]    pwdata;

    initial begin 
        pclk = 0;
    end

    always begin
        #10 pclk = ~pclk;
    end

    apb_if apb_if(.pclk(pclk));
    dut dut(.dif(apb_if));

    initial begin 
        uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top", "vif", apb_if);
        run_test("apb_base_test");
    end
endmodule
