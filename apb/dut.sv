`include "uvm_macros.svh"


module dut(apb_if.slave dif);
    import uvm_pkg::*;

    logic [31:0] r0;
    logic [31:0] r1;
    logic [31:0] value;

    assign reg_sel = dif.paddr[31];
    assign value = reg_sel ? r1 : r0;
    assign enable = dif.penable && dif.psel;

    always @(posedge dif.pclk or dif.presetn) begin
        if (!dif.presetn) begin
            r0 <= 32'h0;
            r1 <= 32'h0;
        end
        if (enable) begin
            if (dif.pwrite == 1) begin
                if (reg_sel) begin
                    r1 <= dif.pwdata;
                end
                else begin
                    r0 <= dif.pwdata;
                end
                `uvm_info("", $sformatf("DUT received cmd=%b, paddr=%d, wdata=%d", dif.pwrite, dif.paddr, dif.pwdata), UVM_MEDIUM)
            end
            else if (dif.pwrite == 0) begin
                dif.prdata <= value;
                `uvm_info("", $sformatf("DUT received cmd=%b, paddr=%d, rdata=%d", dif.pwrite, dif.paddr, value), UVM_MEDIUM)
            end
        end
    end
endmodule

                