`ifndef ENV_CFG_SV
`define ENV_CFG_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

// Class: env_cfg
class env_cfg extends uvm_object;
    `uvm_object_utils(env_cfg)

    // Variable: int_cfg
    agent_cfg m_agent_cfg;

    virtual interface dut_if m_dut_if;

    // Function : new
    function new(string name = "");
        super.new(name);
        m_agent_cfg = agent_cfg::type_id::create("m_agent_cfg");
    endfunction : new

    function void set_vifs(virtual interface dut_if dut_if);
        m_agent_cfg.m_dut_if = dut_if;
    endfunction : set_vifs

endclass : env_cfg

`endif
