`ifndef APB_IF
`define APB_IF

interface apb_if(input bit pclk);
    logic        presetn;
    logic [31:0] paddr;
    logic        psel;
    logic        penable;
    logic        pwrite;
    logic [31:0] prdata;
    logic [31:0] pwdata;

    clocking master_cb @(posedge pclk);
        output presetn, paddr, psel, penable, pwrite, pwdata;
        input prdata;
    endclocking: master_cb

    clocking slave_cb @(posedge pclk);
        input presetn, paddr, psel, penable, pwrite, pwdata;
        output prdata;
    endclocking: slave_cb

    clocking monitor_cb @(posedge pclk);
        input presetn, paddr, psel, penable, pwrite, prdata, pwdata;
    endclocking: monitor_cb

    modport master(clocking master_cb);
    // modport slave(clocking slave_cb); // This is used without dut
    modport passive(clocking monitor_cb);
    modport slave(
        input pclk, presetn, paddr, psel, penable, pwrite, pwdata, // 읽기 가능한 신호
        output prdata                                     // 쓰기 가능한 신호
    );
endinterface: apb_if

`endif