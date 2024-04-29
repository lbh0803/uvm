class apb_adapter extends uvm_reg_adapter;
    `uvm_object_utils(apb_adapter)

    function new (string name = "");
        super.new(name);
    endfunction

    function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        apb_tr tx;
        tx = apb_tr::type_id::create("tx");
        tx.apb_cmd = (rw.kind == UVM_WRITE ? apb_tr::WRITE : apb_tr::READ);
        tx.addr = rw.addr;
        if (tx.apb_cmd) begin
            tx.wdata = rw.data;
        end
        return tx;
    endfunction

    function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        apb_tr tx;
        if (!$cast(tx, bus_item)) begin
            `uvm_fatal("APB_ADAPTER", "Failed to cast bus_item -> tx")
        end

        if (tx.addr < 32'h10) begin
            rw.kind = tx.apb_cmd ? UVM_WRITE : UVM_READ;
            rw.addr = tx.addr;
            rw.data = tx.apb_cmd ? tx.wdata : tx.rdata;
            rw.status = UVM_IS_OK;
        end
        else begin
            rw.status = UVM_NOT_OK;
        end
    endfunction
endclass
