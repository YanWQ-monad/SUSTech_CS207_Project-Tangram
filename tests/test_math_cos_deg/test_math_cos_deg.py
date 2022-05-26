import random
import math

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer

from utils import ErrorCollector, fixed_float, unfixed_float


MAX_ALLOW_ERROR = 0.001


@cocotb.test()
async def cos_deg_test(dut):
    """Test cos (degree)"""

    dut_in = getattr(dut, 'in')

    e = ErrorCollector('relative error')

    for i in range(-180, 181):
        dut_in.value = i

        await Timer(2, units='ns')

        output = unfixed_float(dut.out.value.signed_integer)
        expected = math.cos(i * math.pi / 180)
        diff = (output - expected) if (i + 90) % 180 == 0 else abs((output - expected) / expected)

        e.add(diff)
        assert diff < MAX_ALLOW_ERROR, f'Error is too large: {diff} at {i} degree'

    dut._log.info(e.report())
