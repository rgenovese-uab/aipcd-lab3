//typedef longint unsigned vec_els_t [MAX_64BIT_BLOCKS-1:0];
//typedef longint unsigned mem_addrs_t [MAX_VLEN/MIN_SEW-1:0];
//typedef longint unsigned mem_elements_t [MAX_VLEN/MIN_SEW-1:0];

//typedef struct
//{
//    vec_els_t old_vd;
//    vec_els_t vd;
//    vec_els_t vs1;
//    vec_els_t vs2;
//    vec_els_t vs3;
//    vec_els_t vmask;
//} rvv_ops_t;

typedef struct {
    byte unsigned       frm;
    byte unsigned       fflags;
    byte unsigned       trap_illegal;
    int unsigned        vstart;
    int unsigned        vl;
    int unsigned        vxrm;
    int unsigned        vlmul;
    int unsigned        vsew;
    int unsigned        vill;
    int unsigned        vxsat;
} csr_t;

//[TOCHECK] which fields are present in spike structure
typedef struct {
    longint unsigned    core_id;
    longint unsigned    pc;
    longint unsigned    instr;
    longint unsigned    dst_value;
    longint unsigned    dst_num;
    longint unsigned    src1_value;
    longint unsigned    src1_num;
    longint unsigned    src2_value;
    longint unsigned    src2_num;
    string              disasm;
    csr_t               csr;
    byte unsigned       exc_bit;
    longint unsigned    mem_addr;
    longint unsigned    stored_value;
    longint unsigned    destination_reg;
    //rvv_ops_t           rvv_operands;
    //mem_elements_t      mem_elements;
    //mem_addrs_t         mem_addrs;
} iss_state_t;

typedef struct {
    int                 rgb;
    int                 yuv;
} dut_state_t;
