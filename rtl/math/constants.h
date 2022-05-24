`ifndef __MATH_CONSTANTS_HEADER__
`define __MATH_CONSTANTS_HEADER__

`define FLOAT_BITS 32
`define FLOAT_INT_BITS 16
`define FLOAT_DCM_BITS 16
`define FLOAT_TEMP_BITS 48
`define FLOAT_DOUBLE_BITS 64

`define ONE 32'sb00000000_00000001_00000000_00000000

`define PI 32'sb00000000_00000011_00100100_00111111
`define HALF_PI 32'sb00000000_00000001_10010010_00100000
`define THIRD_TWO_PI 32'sb00000000_00000100_10110110_01011111

`define INV_6 32'sb00000000_00000000_00101010_10101011
`define INV_24 32'sb00000000_00000000_00001010_10101011
// `define INV_120 32'sb00000000_00000000_00000010_00100010
`define INV_120 32'sb00000000_00000000_00000010_00000100  // modified
`define INV_180 32'sb00000000_00000000_00000001_01101100
`define INV_720 32'sb00000000_00000000_00000000_01011011
`define DEGREE_TO_RADIAN 32'sb00000000_00000000_00000100_01111000

`define INT_BITS `FLOAT_INT_BITS

`endif
