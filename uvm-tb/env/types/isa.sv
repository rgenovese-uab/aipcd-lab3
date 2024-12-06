typedef longint unsigned    uint64_t;
typedef int unsigned        uint32_t;
typedef byte unsigned       uint8_t;

typedef struct {
    uint8_t  trap_illegal;
    uint64_t mcause;
    uint64_t scause;
    uint32_t vstart;
    uint32_t vl;
    uint8_t  vxrm;
    uint8_t  vlmul;
    uint8_t  vsew;
    uint8_t  vill;
    uint8_t  vxsat;
    uint8_t  vta;
    uint8_t  vma;
    uint8_t  frm;
    uint8_t  fflags;
    uint64_t mstatus;
    uint64_t misa;
} csr_t;

typedef struct {
    uint64_t core_id;
    uint64_t pc;
    uint32_t instr;
    string   disasm;
    uint8_t  dst_valid;
    uint8_t  dst_num;
    uint64_t dst_value;
    uint8_t  src1_valid;
    uint8_t  src1_num;
    uint64_t src1_value;
    uint8_t  src2_valid;
    uint8_t  src2_num;
    uint64_t src2_value;
    uint64_t vaddr;
    uint64_t paddr;
    uint64_t store_data;
    uint64_t store_mask;
    csr_t    csr;
    uint8_t  exc_bit;
} core_state_t;

typedef struct {
    int                 rgb;
    int                 yuv;
} dut_state_t;
