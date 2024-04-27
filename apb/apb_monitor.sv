`ifndef APB_MON
`define APB_MON

class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor)

    virtual apb_if.passive vif;
    uvm_analysis_port#(apb_tr) mon2agent;
    apb_config cfg;

    function new(string name="", uvm_component parent=null);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        apb_agent agent;
        mon2agent = new("mon2agent", this);
        if ($cast(agent, get_parent()) && agent != null) begin
            vif = agent.vif;
        end
        else begin
            virtual apb_if tmp;
            if (!uvm_config_db#(virtual apb_if)::get(this, "", "apb_if", tmp)) begin
                `uvm_fatal("APB_MON", "No virtual interface specified!")
            end
            vif = tmp;
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            apb_tr tr;
            do begin 
                @(this.vif.monitor_cb);
            end
            while(this.vif.monitor_cb.psel !== 1 || this.vif.monitor_cb.penable !== 0);

            tr = apb_tr::type_id::create("tr", this);

            tr.apb_cmd = (this.vif.monitor_cb.pwrite) ? apb_tr::WRITE : apb_tr::READ;
            tr.addr = this.vif.monitor_cb.paddr;

            @(this.vif.monitor_cb);
            if (this.vif.monitor_cb.penable !== 1) begin
                `uvm_error("APB_MON", "APB protocol violation: PENABLE is not set!")
            end

            if (tr.apb_cmd == apb_tr::WRITE) begin
                tr.wdata = (tr.apb_cmd == apb_tr::WRITE) ? this.vif.monitor_cb.pwdata : 0;
            end
            else begin
                @(this.vif.monitor_cb);
                tr.rdata = (tr.apb_cmd == apb_tr::READ) ? this.vif.monitor_cb.prdata : 0;
            end

            `uvm_info("APB_MON", $sformatf("Got Transaction %s", tr.convert2string()), UVM_LOW);
            mon2agent.write(tr);
        end
    endtask: run_phase
endclass: apb_monitor

`endif







