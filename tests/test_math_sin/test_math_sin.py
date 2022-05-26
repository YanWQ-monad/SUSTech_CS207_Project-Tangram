import random
import math

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer

from utils import ErrorCollector, fixed_float, unfixed_float


MAX_ALLOW_ERROR = 0.001


@cocotb.test()
async def sin_test(dut):
    """Test sin"""

    dut_in = getattr(dut, 'in')

    e = ErrorCollector('relative error')

    for i in range(-90, 91):
        theta = i * math.pi / 180
        dut_in.value = fixed_float(theta)

        await Timer(2, units='ns')

        output = unfixed_float(dut.out.value.signed_integer)
        expected = math.sin(theta)
        diff = output if i == 0 else abs((output - expected) / expected)

        e.add(diff)
        assert diff < MAX_ALLOW_ERROR, f'Error is too large: {diff} at {i} degree'

    dut._log.info(e.report())
