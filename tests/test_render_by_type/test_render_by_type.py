import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer


@cocotb.test()
async def render_square_test(dut):
    """Test square rendering"""

    xy = (10, 17)
    size = 16

    clock = cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())
    dut.rst.value = 0
    dut.ty.value = 0
    dut.x0.value = xy[0]
    dut.y0.value = xy[1]
    dut.size.value = size
    await RisingEdge(dut.clk)

    dut.start.value = 1
    await RisingEdge(dut.clk)
    dut.start.value = 0

    for y in range(xy[1], xy[1] + size + 1):
        for x in range(xy[0], xy[0] + size + 1):
            while not dut.drawing.value:
                await RisingEdge(dut.clk)

            assert dut.x.value.integer == x
            assert dut.y.value.integer == y

            await RisingEdge(dut.clk)

    for _ in range(480 * 2):
        assert not dut.drawing.value
        if dut.done.value == 1:
            break
        await RisingEdge(dut.clk)
    else:
        raise AssertionError("Square rendering not finished")
