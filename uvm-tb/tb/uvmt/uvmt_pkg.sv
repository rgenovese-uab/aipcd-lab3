`ifndef UVMT_PKG
`define UVMT_PKG

package uvmt_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "custom_report_server.sv"

    `include "top_tb_cfg.sv"

endpackage : uvmt_pkg

`endif
