`ifndef APB_SQR 
`define APB_SQR

class apb_sequencer extends uvm_sequencer #(apb_tr);
    `uvm_component_utils(apb_sequencer)

    function new(string name = "", uvm_component parent=null);
        super.new(name, parent);
    endfunction
endclass: apb_sequencer

`endif