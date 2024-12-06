import utils_pkg::*;
`include "uvm_macros.svh"
import uvm_pkg::*;

class protocol extends utils_pkg::protocol_base_class;
    //This class should implement all virtual functions from protocol_base_class

    // Queue that contains the instructions that have been issued, waiting to be retrieved by the monitor_pre
    iss_state_t iss_instr[$];

    // Queue that contains the instructions that have been completed, waiting to be retrieved by the monitor_post
    dut_state_t completed_instr[$];

    // Task: wait_for_clk
    // Waits for as many num_cycles cycles in the interface clock
    virtual task wait_for_clk(int unsigned num_cycles = 1);
        repeat (num_cycles)
            @(posedge rgb2yuv_if.clk);
    endtask

    // Function: new_dut_tx
    // Returns whether or not there are new completed instructions
    virtual function bit new_dut_tx();
        return (completed_instr.size() > 0);
    endfunction : new_dut_tx
    
    // Function: monitor_post
    // Returns the first pending completed instruction
    virtual function dut_state_t monitor_post();
        dut_state_t m_dut_state = completed_instr.pop_front();
        return m_dut_state;
    endfunction

    // Task: do_protocol
    // Runs the specific protocol of the interface to stimulate the DUT
    // Called by driver
    // [TOCHECK] is it necessary 
    virtual task do_protocol();
    endtask


    // Function: drive
    // Pushes the operation to the DUT
    // Called by driver
    virtual function drive (ins_tx req);
    endfunction
    

endclass