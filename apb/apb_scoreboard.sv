`ifndef APB_SB 
`define APB_SB

class apb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(apb_scoreboard)

    function new(string name = "apb_sb", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_analysis_imp #(apb_tr, apb_scoreboard) agent2sb_imp;
    int transaction[int];

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent2sb_imp = new("agent2sb_imp", this);
    endfunction

    virtual function void write(apb_tr tr);
        bit addr_idx = tr.addr[31];
        if (tr.apb_cmd == apb_tr::WRITE) begin
            transaction[addr_idx] = tr.wdata;
            `uvm_info("APB_SB", $sformatf("PADDR : 0x%h, PWDATA : 0x%h", tr.addr, tr.wdata), UVM_LOW)
        end
        else if(tr.apb_cmd == apb_tr::READ) begin
            if (transaction[addr_idx] == tr.rdata) begin
                `uvm_info("APB_SB", $sformatf("PADDR : 0x%h, PRDATA is same as the expected data! : 0x%h", tr.addr, tr.rdata), UVM_LOW)
            end
            else begin
                `uvm_error("APB_SB", $sformatf("PADDR : 0x%h, PRDATA is wrong!, expected : 0x%h, read : 0x%h", tr.addr, transaction[addr_idx], tr.rdata))
            end
        end
    endfunction
endclass
`endif