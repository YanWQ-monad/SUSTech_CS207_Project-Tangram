import math

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer

from utils import fixed_float, unfixed_float


def set_dut(dut, ty, x0, y0, size, angle):
    dut.ty.value = ty
    dut.size.value = size

    sin = math.sin(math.radians(angle))
    cos = math.cos(math.radians(angle))
    x0 = (-x0) * cos - (-y0) * sin
    y0 = (-x0) * sin + (-y0) * cos

    dut.sin.value = fixed_float(sin)
    dut.cos.value = fixed_float(cos)
    dut.ix.value = fixed_float(x0)
    dut.iy.value = fixed_float(y0)


async def get_coordinate(dut, x, y):
    # reset position
    dut.newframe.value = 1
    await RisingEdge(dut.clk)
    dut.newframe.value = 0

    # set Y
    dut.newline.value = 1
    await ClockCycles(dut.clk, y)
    dut.newline.value = 0

    # set X
    await ClockCycles(dut.clk, x + 1)

    return dut.out.value.integer


@cocotb.test()
async def render_shape_test(dut):
    """Test render shape"""

    clock = cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())

    set_dut(dut, 0, 5, 5, 5, 0)
    assert await get_coordinate(dut, 4, 4) == 0
    assert await get_coordinate(dut, 4, 5) == 0
    assert await get_coordinate(dut, 5, 5) == 1
    assert await get_coordinate(dut, 7, 7) == 1
    assert await get_coordinate(dut, 7, 9) == 0
    assert await get_coordinate(dut, 8, 8) == 0

    set_dut(dut, 0, 5, 5, 5, -180)
    assert await get_coordinate(dut, 6, 6) == 0
    assert await get_coordinate(dut, 3, 3) == 1
    assert await get_coordinate(dut, 2, 2) == 0

    set_dut(dut, 0, 5, 5, 5, 90)
    assert await get_coordinate(dut, 6, 4) == 1
    assert await get_coordinate(dut, 4, 6) == 0
