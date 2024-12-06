`ifndef DUT_TX_SV
`define DUT_TX_SV

class dut_tx extends uvm_sequence_item;
    `uvm_object_utils(dut_tx)

    function new(string name = "dut_tx");
        super.new(name);
    endfunction : new

    dut_state_t dut_state;

    virtual function void do_print(uvm_printer printer);
        super.do_print(printer);
            //printer.print_int("iss_state", iss_state, $bits(iss_state.instr));
    endfunction : do_print

endclass : dut_tx

`endif
