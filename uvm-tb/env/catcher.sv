
import uvm_pkg::*;

`include "uvm_macros.svh"

class catcher extends uvm_report_catcher;

    virtual function action_e catch();
        if(get_severity() == UVM_FATAL) begin
            int fd;
            int next_pc;
            string report_msg;
            string cause_str;
            string dasm;
            core_state_t last_instr;
            int executed_ins;

            fd = $fopen({getenv("VERIF"), "/sim/build/report.yaml"}, "w");

            if(!uvm_config_db#(int)::get(null,"*", "executed_ins", executed_ins)) begin
                `uvm_error(get_type_name(), "No instruction committed")
            end

            if (get_id() == "PC MISMATCH") begin
                cause_str = "PC MISMATCH";
                if(!uvm_config_db#(core_state_t)::get(null,"*", "fail_instr", last_instr)) begin
                    `uvm_error(get_type_name(), "No fail_instr to report")
                    last_instr.pc = 'hDEAD;
                    last_instr.instr = 'hDEAD;
                end
            end
            else if (get_id() == "uvm_scoreboard") begin
                cause_str = "MISMATCH";
                if(!uvm_config_db#(core_state_t)::get(null,"*", "fail_instr", last_instr)) begin
                    `uvm_error(get_type_name(), "No fail_instr to report")
                    last_instr.pc = 'hDEAD;
                    last_instr.instr = 'hDEAD;
                end
            end
            else if (get_id() == "top_tb") begin
                cause_str = "TIMEOUT";
                if(!uvm_config_db#(core_state_t)::get(null,"*", "next_instr", last_instr)) begin
                    `uvm_error(get_type_name(), $sformatf("%s:No next_instr to report", cause_str))
                    last_instr.pc = 'hDEAD;
                    last_instr.instr = 'hDEAD;
                end
            end
            else if (get_id() == "ka_im") begin
                cause_str = "ROB_FAULT";
                if(!uvm_config_db#(int)::get(null,"*", "next_pc", next_pc)) begin
                    `uvm_error(get_type_name(), $sformatf("%s:No next_instr to report", cause_str))
                end
                last_instr.pc = 'hDEAD;
                last_instr.instr = 'hDEAD;
            end
            else begin
                if(!uvm_config_db#(core_state_t)::get(null,"*", "next_instr", last_instr)) begin
                    `uvm_error(get_type_name(), "No next_instr to report")
                    last_instr.pc = 'hDEAD;
                    last_instr.instr = 'hDEAD;
                end
            end
            report_msg = $sformatf("cause: %0d
instr:
    pc: 0x%0h
    ins: 0x%0h
    disasm: \"%s\"
    executed_ins: %d", cause_str, last_instr.pc, last_instr.instr, dasm, executed_ins );

            $fdisplay(fd, report_msg);
            $fclose(fd);

        end

        return THROW;
    endfunction : catch

endclass
