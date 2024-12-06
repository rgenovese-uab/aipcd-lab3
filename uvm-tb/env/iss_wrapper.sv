
`ifndef ISS_WRAPPER_SV
`define ISS_WRAPPER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;


class iss_wrapper extends uvm_object;
    `uvm_object_utils(iss_wrapper)

    int active;

    function new(string name = "iss_wrapper");
        super.new(name);
    endfunction : new

    virtual function void setup();

        active = 1;

    endfunction : setup

    virtual function void run_and_retrieve_results(int unsigned instr, ref iss_state_t results);

    endfunction : run_and_retrieve_results

    virtual function void read_n_words_at_address(input int unsigned n, input logic [63:0] address, output logic [7:0] read_memory[]);

    endfunction : read_n_words_at_address

    virtual function void write_n_bytes_at_address(input int unsigned n, input logic [63:0] address, input logic [7:0] data[]);

    endfunction : write_n_bytes_at_address

    virtual function void write_if_not_initialized(input logic[63:0] addr, input logic [127:0] data, input int size);

    endfunction : write_if_not_initialized

    virtual function void step(input int unsigned n);

    endfunction : step

    virtual function void set_interrupt(input int unsigned value);

    endfunction : set_interrupt

    virtual function int run_until_vector_ins(ref iss_state_t iss_state);

    endfunction : run_until_vector_ins

    virtual function int run_until_rgb2yuv_instruction(ref iss_state_t iss_state);

    endfunction : run_until_rgb2yuv_instruction


endclass : iss_wrapper

`endif
