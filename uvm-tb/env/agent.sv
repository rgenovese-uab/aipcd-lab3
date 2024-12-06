`ifndef AGENT_SV
`define AGENT_SV

// Class: agent
class agent extends uvm_agent;
    `uvm_component_utils(agent)

    // Variable: m_cfg
    agent_cfg m_cfg;

    // Variable: m_monitor
    monitor m_monitor;

    // Variable: m_driver
    driver m_driver;

    // Variable: m_seqr
    seqr m_seqr;

    protocol_base_class m_protocol_class;

    function new(string name = "agent", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_monitor = monitor::type_id::create("m_monitor", this);

        if (m_cfg.active == UVM_ACTIVE) begin
            m_driver = driver::type_id::create("m_driver", this);
        end

        m_seqr = seqr::type_id::create("seqr", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        m_protocol_class = m_cfg.m_dut_if.m_protocol_class;

        m_monitor.m_cfg = m_cfg;
        m_monitor.m_protocol_class = m_protocol_class;

        if (m_cfg.active == UVM_ACTIVE) begin
            m_driver.m_cfg = m_cfg;
            m_driver.seq_item_port.connect(m_seqr.seq_item_export);
            m_driver.m_protocol_class = m_protocol_class;
        end

    endfunction : connect_phase

endclass : agent

`endif
