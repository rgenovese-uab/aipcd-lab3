`include "uvm_macros.svh"
import uvm_pkg::*;

module test_harness;

    // Clock  interface
    clock_if clock_if();

    // Reset  interface
    reset_if reset_if();

    //DUT RGB2yuv interface
    rgb2yuv_if rgb2yuv_if();

    //Send it to dut_if that implements it
    dut_if dut_if(rgb2yuv_if);

    assign dut_if.rgb2yuv_if.clk = clock_if.clk;
    assign dut_if.rgb2yuv_if.reset_n = reset_if.rsn;
    assign reset_if.clk = clock_if.clk;

    
    //Instantiate DUT
    /*
    rgb2yuv dut(
        .clk            (rgb2yuv_if.clk),
        .reset_n        (rgb2yuv_if.reset_n),
        .rgb_input      (rgb2yuv_if.rgb_input),
        .valid_input    (rgb2yuv_if.valid_input),
        .instruction    (rgb2yuv_if.instruction),
        .yuv_output     (rgb2yuv_if.yuv_output),
        .valid_output   (rgb2yuv_if.valid_output)
    )
    */

    //Set interfaces in the DB
    initial begin
        uvm_config_db #(virtual clock_if)::set(null, "*", "clock_if", clock_if);
        uvm_config_db #(virtual reset_if)::set(null, "*", "reset_if", reset_if);
        uvm_config_db #(virtual rgb2yuv_if)::set(null, "*", "rgb2yuv_if", rgb2yuv_if);
        uvm_config_db #(virtual dut_if)::set(null, "*", "dut_if", dut_if);
    end

endmodule : test_harness
