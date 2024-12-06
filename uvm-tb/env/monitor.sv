`ifndef MONITOR_SV
`define MONITOR_SV

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    // Variable: m_cfg
    agent_cfg m_cfg;

    protocol_base_class m_protocol_class;

    // Variable: ap
    uvm_blocking_put_port #(dut_tx) dut_results_port;

    // Variable : timeout_cycles
    // Local parameter with the number of cycles to timeout the simulation
    localparam TIMEOUT_CYCLES = 100000;

    // Variable : cycles_wo_completed
    // Cycles without completed, used for detecting a simulation timeout
    int unsigned cycles_wo_completed;

    function new(string name = "monitor", uvm_component parent);
        super.new(name, parent);
        dut_results_port = new("dut_results", this);
    endfunction : new

    function void build_phase(uvm_phase phase);
        if (m_cfg == null) begin
            //`uvm_fatal("monitor", "Configuration of DUT agent for monitor was not correctly set")
        end

        //m_dut_if.mon_proxy = this;
    endfunction : build_phase

    function void notify_transaction(dut_tx item);
        dut_results_port.try_put(item);
    endfunction : notify_transaction

    task run_phase(uvm_phase phase);
        dut_tx m_dut_tx;
        dut_state_t dut_state;
        super.run_phase(phase);
        fork
        begin
            forever begin
                m_protocol_class.wait_for_clk();
                if (m_protocol_class.new_dut_tx()) begin
                    dut_state = m_protocol_class.monitor_post();
                    m_dut_tx = dut_tx::type_id::create("m_dut_tx");
                    m_dut_tx.dut_state = dut_state;
                    dut_results_port.put(m_dut_tx);
                    cycles_wo_completed = 0;
                end
                else if (cycles_wo_completed == TIMEOUT_CYCLES) begin
                    // TODO Timeout change. Exceptions dont complete and can chain and create extreme cases. Just do "change at the interface?"
                    uvm_config_db #(exit_status_code_t)::set(null, "*", "exit_status_code", EXIT_TIMEOUT);
                    `uvm_fatal(get_type_name(), "Simulation timeout")
                end
                else cycles_wo_completed++;
            end
        end
        join
    endtask : run_phase

endclass : monitor

`endif
