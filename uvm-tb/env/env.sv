`ifndef ENV_SV
`define ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

// Class: env
class env extends uvm_env;
    `uvm_component_utils(env)

    env_cfg m_cfg;
    agent m_agent;
    agent_cfg m_agent_cfg;

    uvm_tlm_fifo #(dut_tx) m_dut_fifo;
    uvm_tlm_fifo #(ins_tx) m_iss_fifo;

    isa_scoreboard m_isa_scoreboard;
    iss_wrapper m_iss_wrapper;

    catcher m_catcher;

    // Group: Functions
    // Function: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // Function: build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_agent = agent::type_id::create("m_agent", this);
        m_agent.m_cfg = m_cfg.m_agent_cfg;

        m_isa_scoreboard = isa_scoreboard::type_id::create("m_isa_scoreboard", this);

        m_dut_fifo = new("m_dut_fifo", this);
        m_iss_fifo = new("m_iss_fifo", this);

        m_iss_wrapper = iss_wrapper::type_id::create("m_iss_wrapper");
        m_iss_wrapper.setup();

        m_catcher = new();
        uvm_report_cb::add(null, m_catcher);

    endfunction : build_phase

    // Function: connect_phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        m_agent.m_monitor.dut_results_port.connect(m_dut_fifo.put_export);
        m_isa_scoreboard.dut_results_port.connect(m_dut_fifo.get_export);

        m_agent.m_driver.iss_results_port.connect(m_iss_fifo.put_export);
        m_isa_scoreboard.iss_results_port.connect(m_iss_fifo.get_export);

    endfunction : connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
    endfunction : start_of_simulation_phase

endclass : env

`endif
