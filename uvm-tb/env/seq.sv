`ifndef SEQ_SV
`define SEQ_SV

class seq extends uvm_sequence;
    `uvm_object_utils(seq)

    iss_wrapper m_iss_wrapper;

    uvm_event_pool pool = uvm_event_pool::get_global_pool();
    uvm_event iss_finished = pool.get("iss_finished");

    function new(string name = "seq");
        super.new(name);
    endfunction : new

    virtual task body();
        ins_tx m_ins_tx;
        int state;
        core_state_t spike_state;

        forever begin
            m_ins_tx = ins_tx::type_id::create("m_ins_tx");
            start_item(m_ins_tx);
            //state = m_iss_wrapper.run_until_vector_ins(spike_state);
            state = m_iss_wrapper.run_until_rgb2yuv_instruction(spike_state);
            if (!state) begin
                iss_finished.trigger();
                /*case(state)
                    EXIT_BINARY_ERROR:
                        begin
                            `uvm_fatal(get_type_name(), "Test incorrectness detected while Spike execution")
                        end
                    EXIT_SPIKE_ERROR:
                        begin
                            `uvm_fatal(get_type_name(), "Something went wrong with Spike execution, contact Verification Team or open an issue in UVM repository")
                        end
                endcase*/
                return;
            end
            m_ins_tx.iss_state = spike_state;
            finish_item(m_ins_tx);
        end
    endtask : body

endclass : seq

`endif
