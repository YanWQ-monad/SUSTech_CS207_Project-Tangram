import random
import math

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer


MAX_ALLOW_ERROR = 0.001


def fixed_float(x):
    return int(x * (2 ** 16) + 0.5)

def unfixed_float(x):
    return x / (2 ** 16)


@cocotb.test()
async def sin_test(dut):
    """Test sin"""

    dut_in = getattr(dut, 'in')

    max_diff = 0
    sum_diff = 0

    for i in range(-180, 181):
        theta = fixed_float(i * math.pi / 180)
        dut_in.value = theta

        await Timer(2, units="ns")

        output = unfixed_float(dut.out.value.signed_integer)
        expected = math.sin(i * math.pi / 180)
        diff = output if i % 180 == 0 else abs((output - expected) / expected)

        max_diff = max(diff, max_diff)
        sum_diff += diff

        assert diff < MAX_ALLOW_ERROR, f'Error is too large: {diff} at {i} degree'
        # print('{:3d} {:10d} {:.5f} {:.5f} -> {:.5f}%'.format(i, theta, output, expected, diff * 100))

    dut._log.info('difference: max={:.5f}% avg={:.5f}%'.format(max_diff * 100, sum_diff / 360 * 100))
