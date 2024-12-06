`ifndef BIN_TEST_SV
`define BIN_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

// Class bin_test
class bin_test extends base_test;
    `uvm_component_utils(bin_test)

    // Group: Variables
    seq m_seq;

    // Variable: filename
    string filename;
    uvm_event_pool pool = uvm_event_pool::get_global_pool();
    uvm_event iss_finished = pool.get("iss_finished");

    // Group: Functions

    // Function: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Function: build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_seq = seq::type_id::create("m_seq");

        // Override the sequence type by the binary one

        if ($test$plusargs("TEST_BIN") && $value$plusargs ("TEST_BIN=%s", filename)) begin
            int filename_fd;
            int found;

            `uvm_info(get_type_name(), $sformatf("Test binary to be loaded and executed is %s", filename), UVM_LOW)

            filename_fd = $fopen(filename, "r");

            if(!filename_fd)
                `uvm_fatal(get_type_name(), $sformatf("Filename %s does not exist", filename))

            $fclose(filename_fd);

        end
        else begin
            `uvm_fatal(get_type_name(), "Provide a path to a binary with the argument +TEST_BIN")
        end
    endfunction : build_phase

    // Function: run_phase
    virtual task run_phase(uvm_phase phase);

        phase.raise_objection(this);
        super.run_phase(phase);

        fork
            m_seq.m_iss_wrapper = m_env.m_iss_wrapper;
            m_seq.start(m_env.m_agent.m_seqr);
        join

        `uvm_info(get_type_name(), "UVM exiting, End of test reached", UVM_LOW)
        phase.drop_objection(this);
    endtask : run_phase

endclass : bin_test

`endif
