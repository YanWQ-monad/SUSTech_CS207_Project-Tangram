import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

from mock_ram import MockRAM


X_RANGE = 640
Y_RANGE = 480
BUFFER_SIZE = X_RANGE * Y_RANGE


def check_buffer(buffer, xy, size):
    for x in range(X_RANGE):
        for y in range(Y_RANGE):
            index = y * X_RANGE + x
            should_has_pixel = (xy[0] <= x <= xy[0] + size) and (xy[1] <= y <= xy[1] + size)
            has_pixel = buffer[index] > 0
            assert should_has_pixel == has_pixel, f'{(x, y)} should be {should_has_pixel} but is {has_pixel}'


async def init_test(dut, xy, size):
    ram = MockRAM(BUFFER_SIZE * 2 + 32)
    ram.data[BUFFER_SIZE * 2 : BUFFER_SIZE * 2 + 5] = [0, xy[0], xy[1], size, 0]

    cocotb.start_soon(ram.bind(dut.clk, dut.ram_address, dut.ram_enable, dut.ram_dout, dut.ram_we, dut.ram_din))
    clock = cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())

    dut.l_btn.value = 0
    dut.r_btn.value = 0
    dut.u_btn.value = 0
    dut.d_btn.value = 0
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    return ram


async def trigger_and_test(dut, ram, xy, size):
    dut.trigger.value = 1
    await RisingEdge(dut.clk)
    dut.trigger.value = 0
    await RisingEdge(dut.clk)

    while dut.busy.value:
        await ClockCycles(dut.clk, 16)

    check_buffer(ram.data[BUFFER_SIZE:], xy, size)
    assert ram.data[BUFFER_SIZE * 2 : BUFFER_SIZE * 2 + 5] == [0, xy[0], xy[1], size, 0]


@cocotb.test()
async def basic_render_square_test(dut):
    """Test square rendering"""

    xy = (10, 17)
    size = 23

    ram = await init_test(dut, xy, size)
    await trigger_and_test(dut, ram, xy, size)


@cocotb.test()
async def change_graph_test(dut):
    """Test change graph"""

    xy = (10, 17)
    size = 23

    ram = await init_test(dut, xy, size)
    await trigger_and_test(dut, ram, xy, size)

    xy = (117, 352)
    size = 79
    ram.data[BUFFER_SIZE * 2 : BUFFER_SIZE * 2 + 5] = [0, xy[0], xy[1], size, 0]

    await trigger_and_test(dut, ram, xy, size)


@cocotb.test()
async def button_test(dut):
    """Test button"""

    xy = (10, 17)
    size = 23

    ram = await init_test(dut, xy, size)
    await trigger_and_test(dut, ram, xy, size)

    # Press right button
    xy = (11, 17)
    dut.r_btn.value = 1

    await trigger_and_test(dut, ram, xy, size)

    dut.r_btn.value = 0

    # Press up button
    xy = (11, 16)
    dut.u_btn.value = 1

    await trigger_and_test(dut, ram, xy, size)
