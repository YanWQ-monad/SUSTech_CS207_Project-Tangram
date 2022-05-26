import random
import math

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer

from utils import ErrorCollector, fixed_float, unfixed_float


MAX_ALLOW_ERROR = 0.01


def matrix_multiply(a, b):
    b = list(zip(*b))
    return [ [ sum(x * y for x, y in zip(row_a, col_b)) for col_b in b ] for row_a in a]


@cocotb.test()
async def matrix_multiply_randomized_test(dut):
    """Test matrix multiplication"""

    e = ErrorCollector()

    for i in range(100):
        u = [ random.randint(-100, 100) for _ in range(2) ]
        a = [ [ random.uniform(-2, 2) for _ in range(2)] for _ in range(2)]

        dut.u1.value = fixed_float(u[0])
        dut.u2.value = fixed_float(u[1])
        dut.a11.value = fixed_float(a[0][0])
        dut.a12.value = fixed_float(a[0][1])
        dut.a21.value = fixed_float(a[1][0])
        dut.a22.value = fixed_float(a[1][1])

        await Timer(2, units='ns')

        expected = matrix_multiply([u], a)
        v1 = unfixed_float(dut.v1.value.signed_integer)
        v2 = unfixed_float(dut.v2.value.signed_integer)
        diff = max(abs(v1 - expected[0][0]), abs(v2 - expected[0][1]))

        e.add(diff)
        assert diff < MAX_ALLOW_ERROR, f'Error is too large: {diff}, u={u}, a={a}'

    dut._log.info(e.report())
