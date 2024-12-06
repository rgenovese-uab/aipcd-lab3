virtual class protocol_base_class;

    // Task: do_protocol
    // Runs the specific protocol of the interface to stimulate the DUT
    pure virtual task do_protocol();

    // Task: wait_for_clk
    // Waits for as many num_cycles cycles in the interface clock
    pure virtual task wait_for_clk(int unsigned num_cycles = 1);

    // Function: drive
    // Pushes the instruction inside the transaction into the pending instructions queue
    pure virtual function drive (ins_tx req);

    // Function: new_dut_tx
    // Returns whether or not there are new completed instructions
    pure virtual function bit new_dut_tx();

    // Function: monitor_post
    // Returns the first pending completed instruction
    pure virtual function dut_state_t monitor_post();

endclass : protocol_base_class
