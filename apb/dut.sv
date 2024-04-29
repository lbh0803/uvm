`include "uvm_macros.svh"


module dut(apb_if.slave dif);
    import uvm_pkg::*;
    logic [31:0] r0;
    logic [31:0] r1;
    logic [31:0] r2;
    logic [31:0] r3;
    logic [31:0] pre_rdata;
    logic        enable;

    assign enable = dif.penable && dif.psel;

    always @(*) begin
        case(dif.paddr) 
            32'h0: pre_rdata = r0;
            32'h4: pre_rdata = r1;
            32'h8: pre_rdata = r2;
            32'hC: pre_rdata = r3;
            default: pre_rdata = 32'hx;
        endcase
    end

    always @(posedge dif.pclk or dif.presetn) begin
        if (!dif.presetn) begin
            r0 <= 32'h0;
            r1 <= 32'h0;
            r2 <= 32'h0;
            r3 <= 32'h0;
        end
        if (enable) begin
            if (dif.pwrite == 1) begin
                if (dif.paddr == 32'h0) begin
                    r0 <= dif.pwdata;
                end
                else if(dif.paddr == 32'h4) begin
                    r1 <= dif.pwdata;
                end
                else if(dif.paddr == 32'h8) begin
                    r2 <= dif.pwdata;
                end
                else if(dif.paddr == 32'hC) begin
                    r3 <= dif.pwdata;
                end
                `uvm_info("", $sformatf("DUT received cmd=%b, paddr=%d, wdata=%d", dif.pwrite, dif.paddr, dif.pwdata), UVM_MEDIUM)
            end
            else if (dif.pwrite == 0) begin
                dif.prdata <= pre_rdata;
                `uvm_info("", $sformatf("DUT received cmd=%b, paddr=%d, rdata=%d", dif.pwrite, dif.paddr, pre_rdata), UVM_MEDIUM)
            end
        end
    end
endmodule

                