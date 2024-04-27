`ifndef APB_AGENT
`define APB_AGENT

class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent)
    
    apb_sequencer sqr;
    apb_master_drv drv;
    apb_monitor mon;
    uvm_analysis_port #(apb_tr) agent2sb;

    virtual apb_if vif;

    function new (string name = "", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        sqr = apb_sequencer::type_id::create("sqr", this);
        drv = apb_master_drv::type_id::create("drv", this);
        mon = apb_monitor::type_id::create("mon", this);
        agent2sb = new("agent2sb", this);

        if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("APB_AGT", "No virtual interface speicified!")
        end

        uvm_config_db#(virtual apb_if)::set(this, "sqr", "vif", vif);
        uvm_config_db#(virtual apb_if)::set(this, "drv", "vif", vif);
        uvm_config_db#(virtual apb_if)::set(this, "mon", "vif", vif);
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.mon2agent.connect(this.agent2sb);
        `uvm_info("APB_AGT", "connect_phase, Connected drv to sqr!", UVM_LOW);
    endfunction: connect_phase
endclass: apb_agent

`endif