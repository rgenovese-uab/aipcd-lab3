`ifndef AGENT_CFG_SV
`define AGENT_CFG_SV

class agent_cfg extends uvm_object;
    `uvm_object_utils(agent_cfg)

    function new(string name = "");
        super.new(name);
    endfunction : new

    // Variable: active
    uvm_active_passive_enum active = UVM_ACTIVE;

    virtual interface dut_if m_dut_if;
endclass : agent_cfg

`endif
