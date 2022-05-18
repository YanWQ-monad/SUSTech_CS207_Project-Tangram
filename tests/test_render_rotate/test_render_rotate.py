import random
import math

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer


MAX_ALLOW_ERROR = 1


def fixed_float(x):
    return int(x * (2 ** 16) + 0.5)

def unfixed_float(x):
    return x / (2 ** 16)


@cocotb.test()
async def rotate_randomized_test(dut):
    """Test rotate"""

    max_diff = 0

    for i in range(100):
        x = random.randint(-800, 800)
        y = random.randint(-800, 800)
        angle = random.randint(-180, 180)

        dut.x.value = fixed_float(x)
        dut.y.value = fixed_float(y)
        dut.angle.value = angle

        await Timer(2, units="ns")

        d = math.hypot(x, y)
        phi = math.atan2(y, x)
        theta = phi + math.radians(angle)
        x2 = d * math.cos(theta)
        y2 = d * math.sin(theta)

        x1 = unfixed_float(dut.x1.value.signed_integer)
        y1 = unfixed_float(dut.y1.value.signed_integer)

        diff = max(abs(x1 - x2), abs(y1 - y2))
        max_diff = max(diff, max_diff)

        assert max_diff < MAX_ALLOW_ERROR, f'Error is too large: {max_diff}, x={x}, y={y}, angle={angle}'
        # print('{:3d} {:3d} {:3d} -> {:3f} {:3f}, {:3f} {:3f}'.format(x, y, angle, x1, y1, x2, y2))

    dut._log.info('difference: max={:.5f}'.format(max_diff))
