`ifndef ENV_PKG_SV
`define ENV_PKG_SV

package env_pkg;

    import uvm_pkg::*;
    import utils_pkg::*;
    `include "uvm_macros.svh"

    typedef uvm_sequencer #(ins_tx) seqr;

    import "DPI-C" function string getenv(input string env_name);

    `include "catcher.sv"

    `include "iss_wrapper.sv"
    `include "spike.sv"
    `include "seq.sv"
    `include "agent_cfg.sv"
    `include "monitor.sv"
    `include "driver.sv"
    `include "agent.sv"
    `include "isa_scoreboard.sv"
    `include "env_cfg.sv"
    `include "env.sv"
    `include "base_test.sv"
    `include "bin_test.sv"

endpackage : env_pkg

`endif
