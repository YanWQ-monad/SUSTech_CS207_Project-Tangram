import random
import math

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer

from utils import ErrorCollector, fixed_float, unfixed_float


MAX_ALLOW_ERROR = 1


@cocotb.test()
async def rotate_randomized_test(dut):
    """Test rotate"""

    e = ErrorCollector()

    for i in range(1000):
        x = random.randint(-800, 800)
        y = random.randint(-800, 800)
        angle = random.randint(-180, 180)

        dut.x.value = fixed_float(x)
        dut.y.value = fixed_float(y)
        dut.sin.value = fixed_float(math.sin(math.radians(angle)))
        dut.cos.value = fixed_float(math.cos(math.radians(angle)))

        await Timer(2, units='ns')

        d = math.hypot(x, y)
        phi = math.atan2(y, x)
        theta = phi + math.radians(angle)
        x2 = d * math.cos(theta)
        y2 = d * math.sin(theta)

        x1 = unfixed_float(dut.x1.value.signed_integer)
        y1 = unfixed_float(dut.y1.value.signed_integer)

        diff = max(abs(x1 - x2), abs(y1 - y2))
        e.add(diff)

        assert diff < MAX_ALLOW_ERROR, f'Error is too large: {diff}, x={x}, y={y}, angle={angle}'

    dut._log.info(e.report())
