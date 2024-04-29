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
    apb_reg_blk reg_blk;
    int q[$];
    uvm_status_e status;
    uvm_reg_data_t data_in;
    uvm_reg_data_t data_out;

    virtual task body;
        if(!uvm_config_db#(virtual apb_if)::get(p_sequencer, "", "vif", vif))
            `uvm_fatal("APB_SEQ", "failed to get vif interface!")
        release_reset(vif);
        // This is test without register blk
        `ifdef NO_REG_MODEL
        repeat(10) begin
            rw_trans = apb_tr::type_id::create("rw_trans");
            start_item(rw_trans);
            assert(rw_trans.my_randomize());
            finish_item(rw_trans);
        end
        // With register blk
        `else
        make_data(40);
        repeat(10) begin
            data_out = q.pop_front();
            reg_blk.r0.write(status, .value(data_out), .parent(this));
            if (status != UVM_IS_OK) begin
                `uvm_error("SEQ", $sformatf("Write 0x%s to r0, failed!", data_out))
            end
            reg_blk.r0.read(status, .value(data_in), .parent(this));
            if (status != UVM_IS_OK) begin
                `uvm_error("SEQ", $sformatf("Read from r0, failed!"))
            end
            
            data_out = q.pop_front();
            reg_blk.r1.write(status, .value(data_out), .parent(this));
            if (status != UVM_IS_OK) begin
                `uvm_error("SEQ", $sformatf("Write 0x%s to r1, failed!", data_out))
            end
            reg_blk.r1.read(status, .value(data_in), .parent(this));
            if (status != UVM_IS_OK) begin
                `uvm_error("SEQ", $sformatf("Read from r1, failed!"))
            end

            data_out = q.pop_front();
            reg_blk.r2.write(status, .value(data_out), .parent(this));
            if (status != UVM_IS_OK) begin
                `uvm_error("SEQ", $sformatf("Write 0x%s to r2, failed!", data_out))
            end
            reg_blk.r2.read(status, .value(data_in), .parent(this));
            if (status != UVM_IS_OK) begin
                `uvm_error("SEQ", $sformatf("Read from r2, failed!"))
            end

            data_out = q.pop_front();
            reg_blk.r3.write(status, .value(data_out), .parent(this));
            if (status != UVM_IS_OK) begin
                `uvm_error("SEQ", $sformatf("Write 0x%s to r3, failed!", data_out))
            end
            reg_blk.r3.read(status, .value(data_in), .parent(this));
            if (status != UVM_IS_OK) begin
                `uvm_error("SEQ", $sformatf("Read from r3, failed!"))
            end
        `endif
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

    virtual function void make_data(int cnt);
        for (int i=0; i<cnt; i++) begin
            q.push_back($urandom);
        end
    endfunction
endclass     

`endif