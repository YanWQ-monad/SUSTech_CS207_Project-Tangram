`ifndef __REGFILE_HEADER__
`define __REGFILE_HEADER__

`define FLOAT_BITS 32
`define FLOAT_INT_BITS 16
`define FLOAT_DCM_BITS 16
`define FLOAT_DOUBLE_BITS 64

`define ONE 32'sb00000000_00000001_00000000_00000000

`define PI 32'sb00000000_00000011_00100100_00111111
`define HALF_PI 32'sb00000000_00000001_10010010_00011111
`define THIRD_TWO_PI 32'sb00000000_00000100_10110110_01011111

// `define INV_2 32'sb00000000_00000000_10000000_00000000
`define INV_6 32'sb00000000_00000000_00101010_10101011
`define INV_20 32'sb00000000_00000000_00000010_00000100
`define INV_24 32'sb00000000_00000000_00001010_10101011
`define INV_720 32'sb00000000_00000000_00000000_01011011

`endif
