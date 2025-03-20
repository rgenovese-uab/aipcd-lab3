import utils_pkg::*;
`include "uvm_macros.svh"
import uvm_pkg::*;

class protocol extends utils_pkg::protocol_base_class;
    //This class should implement all virtual functions from protocol_base_class

    // Queue that contains the instructions that have been sent by driver.
    core_state_t iss_instr[$];

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
    virtual task do_protocol();
    //Should:
    //- Send pending instrutions from iss_instr to DUT
    //- Monitor results and save them in completed_instr
    endtask


    // Function: drive
    // Pushes the operation to the DUT
    // Called by driver
    virtual function drive (ins_tx req);
        $display("RECEIVED ISS TRANSACTION TO DRIVE - PC %h INSTRUCTION %h %s",req.iss_state.pc, req.iss_state.instr, req.iss_state.disasm);
        $display("INSTRUCTION SRC %h RES %h",req.iss_state.src1_value, req.iss_state.dst_value);
        iss_instr.push_back(req.iss_state);
    endfunction
    

endclass