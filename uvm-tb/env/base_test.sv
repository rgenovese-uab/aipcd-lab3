`ifndef BASE_TEST_SV
`define BASE_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

// Class: base_test
class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    // Group: Variables

    // Variable: m_env
    // Handler to the UVM top environment.
    env m_env;

    // Variable: m_env_cfg
    // Handler to the configuration of the UVM top environment.
    env_cfg m_env_cfg;

    // Group: Functions

    // Function: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Function: build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        set_type_override_by_type(iss_wrapper::get_type(), spike::get_type());
        `uvm_info(get_type_name(),"Overriding ISS to Spike", UVM_LOW)

        if (!uvm_config_db #(env_cfg)::get(this, "", "top_cfg.m_env_cfg", m_env_cfg)) begin
            `uvm_fatal(get_type_name(), "Environment configuration is not set")
        end

        m_env = env::type_id:: create("m_env", this);
        m_env.m_cfg = m_env_cfg;

    endfunction : build_phase

    // Function: end_of_elaboration_phase
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

    // Function: run_phase
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        phase.drop_objection(this);
    endtask : run_phase

endclass : base_test

`endif
