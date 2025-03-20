
`ifndef SPIKE_SV
`define SPIKE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

import "DPI-C" function void spike_setup(input longint argc, input string argv);
import "DPI-C" function int run_and_inject(input int instr, output core_state_t iss_state);
import "DPI-C" function int exit_code();
import "DPI-C" function void set_tohost_addr(input longint tohost_addr, input longint fromhost_addr);
import "DPI-C" function void get_memory_data(output longint mem_element, input longint mem_addr);
import "DPI-C" function void start_execution();
import "DPI-C" function int set_memory_data(input int unsigned data, input longint unsigned address, input int size);
import "DPI-C" function void do_step(input int unsigned n);
import "DPI-C" function void spike_set_external_interrupt(int mip_val);
import "DPI-C" function int  spike_run_until_vector_ins(inout core_state_t iss_state);

class spike extends iss_wrapper;
    `uvm_object_utils(spike)

    function new(string name = "spike");
        super.new(name);
    endfunction : new

    virtual function void setup();
        longint tohost_addr;
        longint fromhost_addr;
        string exec_bin;

        super.setup();

        if (!$value$plusargs("TEST_BIN=%s", exec_bin)) begin
            `uvm_fatal(get_type_name(), "To use spike_seq.sv you need to pass +SPIKE_BIN plusarg")
        end
        spike_setup(1, {exec_bin});
        start_execution();

        if(!uvm_config_db#(longint)::get(null, "bin_test", "tohost_addr", tohost_addr)) begin
            `uvm_info(get_type_name(), "Spike: No tohost_addr", UVM_HIGH)
        end
        if(!uvm_config_db#(longint)::get(null, "bin_test", "fromhost_addr", fromhost_addr)) begin
            `uvm_info(get_type_name(), "Spike: No fromhost_addr", UVM_HIGH)
        end
        else
        begin
            set_tohost_addr(tohost_addr, fromhost_addr);
        end

    endfunction : setup

    virtual function void run_and_retrieve_results(input int unsigned instr, ref core_state_t results);
        int exitcode;

        if (!active)
            `uvm_fatal(get_type_name(), $sformatf("Spike has finished but UVM tried to inject instr %h", instr))

        active = run_and_inject(instr, results);

        if (!active) begin
            exitcode = exit_code();
            `uvm_info(get_type_name(), $sformatf("Core has finished with exit code %h", exitcode), UVM_LOW)
        end
    endfunction : run_and_retrieve_results

    virtual function void read_n_words_at_address(input int unsigned n, input logic [63:0] address, output logic [7:0] read_memory[]);
        for (int i = 0; i < n; i++) begin
            get_memory_data(read_memory[i], address + i*8);
        end
    endfunction : read_n_words_at_address

    virtual function void write_n_bytes_at_address(input int unsigned n, input logic [63:0] address, input logic [7:0] data[]);

    endfunction : write_n_bytes_at_address

    virtual function void write_if_not_initialized(input logic[63:0] addr, input logic [127:0] data, input int size);
        set_memory_data(addr,data,size);
    endfunction : write_if_not_initialized

    virtual function void step(input int unsigned n);
        do_step(n);
    endfunction : step

    virtual function void set_interrupt(input int unsigned value);
        core_state_t tmp;
        `uvm_info(get_type_name(), $sformatf("Spike set_interrupt with value: %h", value), UVM_DEBUG)
        spike_set_external_interrupt((1 << value));
        run_and_retrieve_results(32'h13, tmp);
        spike_set_external_interrupt(0);
    endfunction : set_interrupt

    virtual function int run_until_vector_ins(ref core_state_t iss_state);
        int exitcode;

        if (!active)
            `uvm_fatal(get_type_name(), $sformatf("Spike has finished but UVM tried to get a vector instruction"))

        active = spike_run_until_vector_ins(iss_state);

        `uvm_info(get_type_name(), $sformatf("Retrieved instruction %h", iss_state.instr), UVM_DEBUG)

        if (!active) begin
            exitcode = exit_code();
            `uvm_info(get_type_name(), $sformatf("Core has finished with exit code %h", exitcode), UVM_LOW)
        end

        return active;

    endfunction : run_until_vector_ins


endclass : spike

`endif
