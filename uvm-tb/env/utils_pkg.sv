`ifndef UTILS_PKG_SV
`define UTILS_PKG_SV

package utils_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "types/uvm.sv"
    `include "types/isa.sv"
    `include "ins_tx.sv"
    `include "dut_tx.sv"
    `include "protocol_class.sv"

endpackage : utils_pkg

`endif
