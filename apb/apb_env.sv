`ifndef APB_ENV
`define APB_ENV

class apb_env extends uvm_env;
    `uvm_component_utils(apb_env)

    apb_agent agt;
    apb_scoreboard sb;
    apb_reg_blk reg_blk;
    apb_adapter adapter;
    virtual apb_if vif;

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = apb_agent::type_id::create("agt", this);
        sb = apb_scoreboard::type_id::create("sb", this);
        reg_blk = apb_reg_blk::type_id::create("reg_blk", this);
        reg_blk.build();
        adapter = apb_adapter::type_id::create("adapter",, get_full_name());
        if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("APB_ENV", "No virtual interface specified!")
        end
        uvm_config_db#(virtual apb_if)::set(this, "agt", "vif", vif);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        reg_blk.default_map.set_sequencer(.sequencer(agt.sqr), .adapter(adapter));
        reg_blk.default_map.set_base_addr(0);
        reg_blk.add_hdl_path("test.dut");
        agt.agent2sb.connect(sb.agent2sb_imp);
    endfunction
endclass: apb_env

`endif