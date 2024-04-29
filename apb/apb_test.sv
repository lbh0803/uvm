`ifndef APB_BASE_TEST
`define APB_BASE_TEST

class apb_base_test extends uvm_test;
    `uvm_component_utils(apb_base_test)

    apb_env env;
    apb_config cfg;
    virtual apb_if vif;

    function new(string name = "apb_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg = apb_config::type_id::create("cfg", this);
        env = apb_env::type_id::create("env", this);

        if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("APB_TEST", "No virtual interface specified")
        end
        uvm_config_db#(virtual apb_if)::set(this, "env", "vif", vif);
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        uvm_top.print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
        apb_base_seq apb_seq;
        apb_seq = apb_base_seq::type_id::create("apb_seq");
        phase.raise_objection(this, "Starting apb_base seq main phase");
        apb_seq.reg_blk = env.reg_blk;
        apb_seq.start(env.agt.sqr);
        #100ns;
        phase.drop_objection(this, "Finised apb_base seq in main_phase");
    endtask: run_phase
endclass: apb_base_test

`endif