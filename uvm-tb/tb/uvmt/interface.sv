/*
*
* Title:    VPU interfaces
*
* Project: EPI Vector Lane
*
* Language: SystemVerilog
*
*
*/

`ifndef VPU_IF
`define VPU_IF

import utils_pkg::*;

timeunit 100ps;
timeprecision 1ps;


// Interface: clock_if
// Clock Interface
interface clock_if;
    logic clk;
    logic rsn;

    int clk_period_pos = 5;
    int clk_period_neg = 5;
    // Cycle counter for performance counters
    longint unsigned cycles = 0;

    initial begin
        clk = 1'b0;
        cycles = 0;
        $value$plusargs("CLOCK_PERIOD_POS=%d", clk_period_pos);
        $value$plusargs("CLOCK_PERIOD_NEG=%d", clk_period_neg);
        forever begin
            #clk_period_neg clk = ~clk;
            #clk_period_pos clk = ~clk;
        end
    end

    always @cb cycles++;

    clocking cb @(posedge clk);
    endclocking

    clocking cbn @(negedge clk);
    endclocking

    task automatic wait_cycles(int num);
        repeat (num) @cb;
    endtask : wait_cycles

    task automatic wait_n_cycles(int num);
        repeat (num) @cbn;
    endtask : wait_n_cycles

endinterface : clock_if

// Interface: reset_if
// Reset Interface
interface reset_if;

    // Variable: clk
    logic clk;

    // Variable: rsn
    logic rsn;

    // Task : wait_for_reset_start
    task automatic wait_for_reset_start();
        @(negedge rsn);
    endtask : wait_for_reset_start

    // Task : wait_for_reset_end
    task automatic wait_for_reset_end();
        @(posedge rsn);
        endtask : wait_for_reset_end

    initial begin
        rsn = 1'b0;
        repeat (5) @(posedge clk);
        rsn = 1'b1;
    end

endinterface : reset_if


interface rgb2yuv_if;
    logic           clk;
    logic           reset_n;
    logic [31:0]    rgb_input;
    logic           valid_input;
    logic [31:0]    instruction; //is it necessary?
    logic [31:0]    yuv_output;
    logic           valid_output;

endinterface : rgb2yuv_if

interface dut_if (rgb2yuv_if rgb2yuv_if);
`include "rgb2yuv_protocol.sv"
protocol m_protocol_class = new();

endinterface : dut_if

`endif
