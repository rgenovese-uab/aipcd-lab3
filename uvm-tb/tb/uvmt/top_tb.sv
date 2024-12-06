`ifndef TOP_TB_SV
`define TOP_TB_SV

import uvm_pkg::*;
import env_pkg::*;
import uvmt_pkg::*;
import utils_pkg::*;
`include "uvm_macros.svh"

// Module: top_tb
module top_tb;

    test_harness th();
    top_tb_cfg top_config;


    initial begin
        custom_report_server my_report_server;
        my_report_server = new("my_report_server");
        uvm_coreservice_t::get().set_report_server(my_report_server);

        top_config = top_tb_cfg::type_id::create("top_config");
        
        uvm_config_db #(env_cfg)::set(null, "*", "top_cfg.m_env_cfg", top_config.m_env_cfg);

        top_config.set_vifs(th.dut_if);

        run_test();

    end

endmodule : top_tb

`endif
