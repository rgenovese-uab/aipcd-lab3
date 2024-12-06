
`ifndef TOP_TB_CFG_SV
`define TOP_TB_CFG_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
import env_pkg::*;

class top_tb_cfg extends uvm_object;
    `uvm_object_utils(top_tb_cfg)

    env_cfg m_env_cfg;

    function new(string name = "top_tb_cfg");
        super.new(name);
        m_env_cfg = env_cfg::type_id::create("m_env_cfg");
    endfunction : new

    function void set_vifs(virtual interface dut_if dut_if);
        m_env_cfg.set_vifs(dut_if);
    endfunction : set_vifs

endclass : top_tb_cfg

`endif
