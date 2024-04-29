`ifndef APB_TR
`define APB_TR

import uvm_pkg::*;

class apb_tr extends uvm_sequence_item;
    `uvm_object_utils(apb_tr)

    typedef enum {READ, WRITE} kind_e;
    rand bit [31:0] addr;
    rand logic [31:0] wdata;
    rand logic [31:0] rdata;
    rand kind_e apb_cmd;

    constraint c_addr {addr >= 0; addr < 16; addr%4 == 0;}

    function new (string name = "apb_tr");
        super.new(name);
    endfunction

    function string convert2string();
        return $psprintf("kind=%s addr=0x%h wdata=0x%h rdata=0x%h", apb_cmd, addr, wdata, rdata);
    endfunction

    function my_randomize();
        addr = $urandom_range(0, 3) * 4;
        wdata = $urandom;
        rdata = 32'h0;
        apb_cmd = $urandom_range(1, 0) ? apb_tr::WRITE : apb_tr::READ;
        `uvm_info("APB_TRANSACTION", "randomize tx!", UVM_LOW)
        `uvm_info("APB_TRANSACTION", $sformatf("randomized : %s", convert2string()), UVM_LOW);
        return 1;
    endfunction
endclass: apb_tr

`endif