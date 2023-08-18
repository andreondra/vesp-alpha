`ifndef __FILE_CONSTANTS_V
`define __FILE_CONSTANTS_V

/* RISC-V ISA constants */
`define XLEN 32       // width of an integer register (in bits)
`define IALIGN 32     // instruction-address alignment constraint (in bits)
`define ILEN 1*`IALIGN // length of an instruction (in bits) - it's always a multiple of IALIGN

/* other constants */
`define REG_CNT 32 // number of registers in a register file

/* assertion values */
`define ASSERT_FAIL "ASSERT_FAIL"
`define ASSERT_SUCCESS "ASSERT_SUCCESS"

`endif // __FILE_CONSTANTS_V