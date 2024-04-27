`ifndef APB_DRV
`define APB_DRV

typedef apb_config;
typedef apb_agent;

class apb_master_drv extends uvm_driver#(apb_tr);
    `uvm_component_utils(apb_master_drv)

    virtual apb_if vif;
    apb_config cfg;

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        apb_agent agent;
        super.build_phase(phase);
        if ($cast(agent, get_parent()) && agent != null) begin
            vif = agent.vif;
        end
        else begin
            if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
                `uvm_fatal("APB_DRV", "No virtual interface specified!")
            end
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        this.vif.master_cb.psel <= 0;
        this.vif.master_cb.penable <= 0;

        forever begin
            apb_tr tr;
            @(this.vif.master_cb);
            seq_item_port.get_next_item(tr);
            @(this.vif.master_cb);
            `uvm_info("APB_DRV", $sformatf("Got transaction %s", tr.convert2string()), UVM_LOW);
            case (tr.apb_cmd)
                apb_tr::READ: drive_read(tr.addr, tr.rdata);
                apb_tr::WRITE: drive_write(tr.addr, tr.wdata);
            endcase
            seq_item_port.item_done();
        end
    endtask: run_phase

    virtual protected task drive_read(input bit [31:0] addr,
                                        output logic [31:0] rdata);
        this.vif.master_cb.paddr <= addr;
        this.vif.master_cb.pwrite <= 0;
        this.vif.master_cb.psel <= 1;
        @(this.vif.master_cb);
        this.vif.master_cb.penable <= 1;
        @(this.vif.master_cb);
        rdata = this.vif.master_cb.prdata;
        this.vif.master_cb.psel <= 0;
        this.vif.master_cb.penable <= 0;
    endtask: drive_read

    virtual protected task drive_write(input bit [31:0] addr,
                                    input bit [31:0] wdata);
        this.vif.master_cb.paddr <= addr;
        this.vif.master_cb.pwdata <= wdata;
        this.vif.master_cb.pwrite <= 1;
        this.vif.master_cb.psel <= 1;
        @(this.vif.master_cb);
        this.vif.master_cb.penable <= 1;
        @(this.vif.master_cb);
        this.vif.master_cb.psel <= 0;
        this.vif.master_cb.penable <= 0;
    endtask: drive_write
endclass: apb_master_drv

`endif