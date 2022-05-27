import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer


def set_dut(dut, ty, x0, y0, size, angle):
    dut.ty.value = ty
    dut.x0.value = x0
    dut.y0.value = y0
    dut.size.value = size
    dut.angle.value = angle


async def get_coordinate(dut, x, y):
    dut.x.value = x
    dut.y.value = y
    await Timer(2, units='ns')
    return dut.out.value.integer


@cocotb.test()
async def render_shape_test(dut):
    """Test render shape"""

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
