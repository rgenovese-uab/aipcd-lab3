SHELL = /bin/bash
WAVE_FILE = wave_test_test.do

PREFIX = questa 2019.10
SIMDIR = $(VERIF)/sim
export RTLDIR = $(VERIF)/rtl/
UVMTDIR = $(VERIF)/tb/uvmt
ENVDIR = $(VERIF)/env/
WORKDIR = $(SIMDIR)/build/work
COMP_TRANSCRIPT_FILE ?= $(SIMDIR)/build/comp_transcript
SIM_TRANSCRIPT_FILE ?= $(SIMDIR)/build/sim_transcript
VENDIR = $(VERIF)/vendor/
export DTB_PATH = $(VERIF)/vendor/spike/lib/dtb.dat

ASSERT ?=disable
COVERAGE ?=disable

all: compile_all run

SIM = questasim

UVM_VERBOSITY ?= UVM_HIGH
FILE ?= none
LINT ?= disable

export rtlfilelist = $(RTLDIR)/filelist.f
export uvmfilelist = $(VERIF)/tb/uvmt/uvmt.flist
export envfilelist = $(VERIF)/env/uvme.flist

ifeq ($(ASSERT),enable)
	VLOG_FLAGS := $(VLOG_FLAGS) -define "ASSERT"
	VSIM_FLAGS := $(VSIM_FLAGS) -assertcounts -assertdebug
endif

ifeq ($(COVERAGE),enable)
	VLOG_FLAGS := $(VLOG_FLAGS) -define "COVERAGE"
endif

include ${VERIF}/mk/tools/custom.mk
include ${VERIF}/mk/tools/utils.mk
include ${VERIF}/mk/tools/disasm.mk
include ${VERIF}/mk/uvmt/uvmt.mk

.PHONY: all rtl tb empty_tb run

compile_all:
	@mkdir -p ${VERIF}/sim/build
	@${VLOG} -vv ${VLOG_FLAGS} -f ${VERIF}/mk/targets/comp_all.flist &> ${COMP_TRANSCRIPT_FILE}

run:
	@${VSIM} ${VSIM_FLAGS} +UVM_TESTNAME=bin_test top_tb &> ${SIM_TRANSCRIPT_FILE}


clean:
	rm -rf $(VWORK)
	rm -rf vsim.wlf
	rm -f $(TRANSCRIPT_FILE) $(SIM_TRANSCRIPT_FILE)

