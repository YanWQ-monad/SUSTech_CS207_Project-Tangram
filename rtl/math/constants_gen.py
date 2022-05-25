import math


FLOAT_BYTES = 4
FLOAT_BITS = FLOAT_BYTES * 8
FLOAT_INT_BITS = 16
FLOAT_DCM_BITS = 16
FLOAT_DOUBLE_BITS = FLOAT_BITS * 2

assert FLOAT_BITS == FLOAT_INT_BITS + FLOAT_DCM_BITS

def _(x):
    x = x * (2 ** FLOAT_DCM_BITS)
    x = int(x + 0.5)
    b = x.to_bytes(FLOAT_BYTES, 'big', signed=True)
    return '_'.join([ f'{v:08b}' for v in b ])


FILE = f'''
`ifndef __MATH_CONSTANTS_HEADER__
`define __MATH_CONSTANTS_HEADER__

`define FLOAT_BITS {FLOAT_BITS}
`define FLOAT_INT_BITS {FLOAT_INT_BITS}
`define FLOAT_DCM_BITS {FLOAT_DCM_BITS}
`define FLOAT_TEMP_BITS {FLOAT_BITS + (FLOAT_BITS - 1) // 2 + 1}
`define FLOAT_DOUBLE_BITS {FLOAT_DOUBLE_BITS}

`define ONE {FLOAT_BITS}'sb{_(1)}

`define PI {FLOAT_BITS}'sb{_(math.pi)}
`define HALF_PI {FLOAT_BITS}'sb{_(math.pi / 2)}
`define THIRD_TWO_PI {FLOAT_BITS}'sb{_(math.pi * 3 / 2)}

`define INV_6 {FLOAT_BITS}'sb{_(1 / 6)}
`define INV_24 {FLOAT_BITS}'sb{_(1 / 24)}
// `define INV_120 {FLOAT_BITS}'sb{_(1 / 120)}
`define INV_120 {FLOAT_BITS}'sb00000000_00000000_00000010_00000100  // modified
`define INV_180 {FLOAT_BITS}'sb{_(1 / 180)}
`define INV_720 {FLOAT_BITS}'sb{_(1 / 720)}
`define DEGREE_TO_RADIAN {FLOAT_BITS}'sb{_(math.pi / 180)}

`define INT_BITS {FLOAT_INT_BITS}
`define INT_DOUBLE_BITS {FLOAT_INT_BITS * 2}

`endif
'''

print(FILE.strip('\n'))
