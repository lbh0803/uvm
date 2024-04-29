class apb_reg extends uvm_reg;
    `uvm_object_utils(apb_reg);

    rand uvm_reg_field f1;
    rand uvm_reg_field f2;
    rand uvm_reg_field f3;
    rand uvm_reg_field f4;
    uvm_status_e status;

    function new(string name = "");
        super.new(name, 32, UVM_NO_COVERAGE);
    endfunction

    function void build();
        f1 = uvm_reg_field::type_id::create("f1");
        f2 = uvm_reg_field::type_id::create("f2");
        f3 = uvm_reg_field::type_id::create("f3");
        f4 = uvm_reg_field::type_id::create("f4");
        f1.configure(this, 8, 0, "RW", 0, 0, 1, 1, 0);
        f2.configure(this, 8, 8, "RW", 0, 0, 1, 1, 0);
        f3.configure(this, 8, 16, "RW", 0, 0, 1, 1, 0);
        f4.configure(this, 8, 24, "RW", 0, 0, 1, 1, 0);
    endfunction
endclass


class apb_reg_blk extends uvm_reg_block;
    `uvm_object_utils(apb_reg_blk)

    rand apb_reg r0;
    rand apb_reg r1;
    rand apb_reg r2;
    rand apb_reg r3;

    function new(string name = "");
        super.new(name, build_coverage(UVM_NO_COVERAGE));
    endfunction

    function void build();
        r0 = apb_reg::type_id::create("r0");
        r0.build();
        r0.configure(this);
        r0.add_hdl_path_slice("r0", 0, 32);

        r1 = apb_reg::type_id::create("r1");
        r1.build();
        r1.configure(this);
        r1.add_hdl_path_slice("r1", 0, 32);

        r2 = apb_reg::type_id::create("r2");
        r2.build();
        r2.configure(this);
        r2.add_hdl_path_slice("r2", 0, 32);

        r3 = apb_reg::type_id::create("r3");
        r3.build();
        r3.configure(this);
        r3.add_hdl_path_slice("r3", 0, 32);

        default_map = create_map("my_map", 0, 4, UVM_LITTLE_ENDIAN);
        default_map.add_reg(r0, 0, "RW");
        default_map.add_reg(r1, 4, "RW");
        default_map.add_reg(r2, 8, "RW");
        default_map.add_reg(r3, 12, "RW");

        lock_model();
    endfunction
endclass

