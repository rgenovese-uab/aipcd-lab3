PREFIX = questa 2019.10

SIM = questasim

UCDB_PATH ?= ${WORKDIR}/cov.ucdb


# Executables
VLIB                    = vlib
VMAP                    = vmap
VLOG                    = $(CV_SIM_PREFIX) vlog
VOPT                    = $(CV_SIM_PREFIX) vopt
VSIM                    = $(CV_SIM_PREFIX) vsim
VISUALIZER              = $(CV_TOOL_PREFIX) visualizer
VCOVER                  = vcover

# Paths
VWORK                   = $(WORKDIR)
VSIM_RESULTS           ?= $(if $(CV_RESULTS),$(CV_RESULTS)/vsim_results,$(MAKE_PATH)/vsim_results)
VSIM_COREVDV_RESULTS   ?= $(VSIM_RESULTS)/corev-dv
VSIM_COV_MERGE_DIR     ?= $(VSIM_RESULTS)/$(CFG)/merged
UVM_HOME               ?= $(abspath $(shell which $(VLIB))/../../verilog_src/uvm-1.2/src)
DPI_INCLUDE            ?= $(abspath $(shell which $(VLIB))/../../include)
USES_DPI = 1

#
# # Default flags
VSIM_USER_FLAGS         ?=
VOPT_COV                ?= +cover=bcestf
VOPT_WAVES_ADV_DEBUG    ?= -designfile design.bin
VSIM_WAVES_ADV_DEBUG    ?= -qwavedb=+signal+assertion+ignoretxntime+msgmode=both
VSIM_WAVES_DO           ?= $(VSIM_SCRIPT_DIR)/waves.tcl
VSIM_COV                ?= -coverage +cover=bcestxf




# VLOG (compile)

VLOG_FLAGS        += -modelsimini $(VERIF)/mk/uvmt/vsim/modelsim.ini
VLOG_FLAGS        += -suppress vlog-2583
VLOG_FLAGS        += +acc
VLOG_FLAGS        += -svinputport=compat
VLOG_FLAGS        += -work $(VWORK)
VLOG_FLAGS        += -timescale "1ns/1ps"
VLOG_FLAGS        += $(QUIET)
#VLOG_FLAGS        += +incdir+${DPI_DASM_PKG}
#VLOG_FLAGS        += +cover=bcestxf

# VSIM (simulation)
VSIM_FLAGS        += -modelsimini $(VERIF)/mk/uvmt/vsim/modelsim.ini
VSIM_FLAGS        += -work $(VWORK)
VSIM_FLAGS        += $(VSIM_USER_FLAGS)
VSIM_FLAGS        += $(USER_RUN_FLAGS)
VSIM_FLAGS        += -sv_seed $(RNDSEED)
VSIM_FLAGS        += -suppress 7031
VSIM_FLAGS        += -l $(SIM_TRANSCRIPT_FILE) -dpicpppath /usr/bin/gcc
VSIM_FLAGS        += -syncio
VSIM_FLAGS        += -nostdout
VSIM_FLAGS        += +UVM_VERBOSITY=${UVM_VERBOSITY}

ifdef TEST
VSIM_FLAGS        += +TEST_BIN=$(TEST)
endif


################################################################################
# Coverage database generation
ifeq ($(call IS_YES,$(COVERAGE)),YES)
VOPT_FLAGS  += $(VOPT_COV)
VSIM_FLAGS  += $(VSIM_COV)
endif

################################################################################
# Waveform generation
ifeq ($(call IS_YES,$(WAVES)),YES)
ifeq ($(call IS_YES,$(ADV_DEBUG)),YES)
VSIM_FLAGS += $(VSIM_WAVES_ADV_DEBUG)
else
VSIM_FLAGS += -do $(VSIM_WAVES_DO)
endif
endif

ifeq ($(call IS_YES,$(ADV_DEBUG)),YES)
VOPT_FLAGS += $(VOPT_WAVES_ADV_DEBUG)
endif



VSIM_DEBUG_FLAGS  ?= -debugdb
VSIM_GUI_FLAGS    ?= -gui -debugdb
VSIM_SCRIPT_DIR	   = $(abspath $(MAKE_PATH)/../tools/vsim)

VSIM_UVM_ARGS      = +incdir+$(UVM_HOME)/src $(UVM_HOME)/src/uvm_pkg.sv

ifeq ($(call IS_YES,$(USE_ISS)),YES)
VSIM_FLAGS += +USE_ISS
endif

#VSIM_FLAGS += -sv_lib $(basename $(DPI_DASM_LIB))
VSIM_FLAGS += -sv_lib $(VENDIR)/elfloader/elfloader -sv_lib $(VENDIR)/spike/spike

# Skip compile if requested (COMP=NO)
ifneq ($(call IS_NO,$(COMP)),NO)
VSIM_SIM_PREREQ = comp
endif

VSIM_FLAGS += -do "set NoQuitOnFinish 1"
# Interactive simulation
ifeq ($(call IS_YES,$(GUI)),YES)
ifeq ($(call IS_YES,$(ADV_DEBUG)),YES)
VSIM_FLAGS += -visualizer=+designfile=../design.bin
else
VSIM_FLAGS += -gui
endif
else
VSIM_FLAGS += -batch
VSIM_FLAGS += -do "run -all;"
ifeq ($(call IS_YES,$(COVERAGE)),YES)
VSIM_FLAGS += -do "coverage save -assert -directive -cvg -codeAll ${UCDB_PATH};"
endif
VSIM_FLAGS += -do "exit;"
endif

