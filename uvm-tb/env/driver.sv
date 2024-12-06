`ifndef DRIVER_SV
`define DRIVER_SV

class driver extends uvm_driver #(ins_tx);
    `uvm_component_utils(driver)

    // Variable: m_cfg
    agent_cfg m_cfg;

    // Variable: iss_results_port
    uvm_blocking_put_port #(ins_tx) iss_results_port;

    protocol_base_class m_protocol_class;

    // Variable: tx
    ins_tx tx;

    function new(string name = "driver", uvm_component parent);
        super.new(name, parent);
        iss_results_port = new("iss_results", this);
    endfunction : new

    function void build_phase(uvm_phase phase);
        if (m_cfg == null) begin
            //`uvm_fatal("DRIVER", "Configuration of dut agent for driver was not correctly set")
        end
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            m_protocol_class.do_protocol();
            begin
                forever begin
                    seq_item_port.get_next_item(tx);
                    m_protocol_class.wait_for_clk();
                    m_protocol_class.drive(tx);
                    iss_results_port.put(tx);
                    seq_item_port.item_done();
                end
            end

        join_none
    endtask : run_phase

endclass : driver

`endif
