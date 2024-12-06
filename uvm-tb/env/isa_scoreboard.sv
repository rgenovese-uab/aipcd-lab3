
`ifndef ISA_SCOREBOARD
`define ISA_SCOREBOARD

`include "uvm_macros.svh"
import uvm_pkg::*;
import utils_pkg::*;

class isa_scoreboard extends uvm_scoreboard;
`uvm_component_utils(isa_scoreboard)

    uvm_blocking_get_port #(dut_tx) dut_results_port;

    uvm_nonblocking_get_port #(ins_tx) iss_results_port;

    int executed_ins;

    uvm_event_pool pool = uvm_event_pool::get_global_pool();
    uvm_event iss_finished = pool.get("iss_finished");

    function new(string name = "isa_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        executed_ins = 0;

        iss_results_port = new("iss_results_port", this);
        dut_results_port = new("dut_results_port", this);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
        ins_tx iss_state;
        dut_tx dut_state;

        phase.raise_objection(this);

        forever begin
            dut_results_port.get(dut_state);
            if (!iss_results_port.try_get(iss_state))
                `uvm_fatal(get_type_name(), "No pending ISS state transactions!");
            compare(dut_state.dut_state, iss_state.iss_state);
            if (!iss_results_port.can_get() && iss_finished.is_on()) begin
                break;
            end
        end
        uvm_config_db #(exit_status_code_t)::set(null, "*", "exit_status_code", EXIT_SUCCESS);

        phase.drop_objection(this);

    endtask : run_phase

    
    function compare(dut_state_t dut, core_state_t iss);
        int errors = 0;
        int dest_valid;
        

        //[TODO] Compare ISS vs DUT results

        if (errors) begin
            uvm_config_db #(core_state_t)::set(null, "*", "fail_instr", iss);
            uvm_config_db #(exit_status_code_t)::set(null, "*", "exit_status_code", EXIT_EXECUTION_ERROR);
            `uvm_info("uvm_scoreboard", $sformatf("Wrong: PC 0x%0h, INSTR 0x%0h DISASM: %s ", iss.pc[31:0], iss.instr[31:0], iss.disasm), UVM_LOW)
            `uvm_fatal("uvm_scoreboard", $sformatf(" Execution abort due to %d scoreboard mismatches", errors))
        end
        else begin
            uvm_config_db #(int)::set(null, "*", "executed_ins", executed_ins);
            uvm_config_db #(core_state_t)::set(null, "*", "last_instr", iss);
            `uvm_info("uvm_scoreboard", $sformatf("Correct: PC 0x%0h, INSTR 0x%0h DISASM: %s ", iss.pc[31:0], iss.instr[31:0], iss.disasm), UVM_LOW)
            ++executed_ins;
        end

    endfunction : compare

    function void report_phase(uvm_phase phase);
        string cause_str;
        string report_msg;
        string dasm;
        core_state_t last_instr;
        exit_status_code_t exit_code;
        ins_tx iss_tx;
        uvm_coreservice_t cs;
        uvm_report_server svr;
        int fd = $fopen({getenv("VERIF"), "/sim/build/report.yaml"}, "w");
        cs = uvm_coreservice_t::get();
        svr = cs.get_report_server();
        cause_str = "SUCCESS";

        if(!uvm_config_db#(exit_status_code_t)::get(null,"*", "exit_status_code", exit_code)) begin
            `uvm_error(get_type_name(), "No exit code found")
        end
        else begin
            case (exit_code)
            EXIT_EXECUTION_ERROR: begin
                if(!uvm_config_db#(core_state_t)::get(null,"*", "fail_instr", last_instr)) begin
                    `uvm_error(get_type_name(), "No fail_instr in the db")
                end
                cause_str = "SB_MISMATCH";
            end
            EXIT_TIMEOUT: begin
                if (!iss_results_port.try_get(iss_tx))
                    `uvm_fatal(get_type_name(), "No pending ISS state transactions after timeout!")
                last_instr = iss_tx.iss_state;
                cause_str = "TIMEOUT";
            end
            default: begin
                if(!uvm_config_db#(core_state_t)::get(null,"*", "last_instr", last_instr)) begin
                    `uvm_error(get_type_name(), "No fail_instr in the db")
                end
            end
            endcase
        end
        report_msg = $sformatf(
"cause: %0d
instr:
    pc: 0x%0h
    ins: 0x%0h
    disasm: \"%s\"
    executed_ins: %d", cause_str, last_instr.pc, last_instr.instr, last_instr.disasm, executed_ins);

        $fdisplay(fd, report_msg);
        $fclose(fd);

    endfunction : report_phase


endclass : isa_scoreboard

`endif
