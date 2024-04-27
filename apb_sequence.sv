`ifndef APB_SEQUENCE
`define APB_SEQUENCE

class apb_base_seq extends uvm_sequence#(apb_tr);
    `uvm_object_utils(apb_base_seq)
    `uvm_declare_p_sequencer(apb_sequencer)

    function new(string name = "");
        super.new(name);
    endfunction

    virtual apb_if vif;
    apb_tr rw_trans;

    virtual task body;
        if(!uvm_config_db#(virtual apb_if)::get(p_sequencer, "", "vif", vif))
            `uvm_fatal("APB_SEQ", "failed to get vif interface!")
        release_reset(vif);
        repeat(10) begin
            rw_trans = apb_tr::type_id::create("rw_trans");
            start_item(rw_trans);
            assert(rw_trans.my_randomize());
            finish_item(rw_trans);
        end
    endtask

    virtual task release_reset(virtual apb_if vif);
        vif.master_cb.presetn <= 0;
        repeat(10) begin
            @(posedge vif.master_cb);
        end
        vif.master_cb.presetn <= 1;
        @(posedge vif.master_cb);
    endtask
endclass     

`endif