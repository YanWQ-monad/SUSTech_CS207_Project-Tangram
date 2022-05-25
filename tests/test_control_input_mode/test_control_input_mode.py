import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer


def init(dut, mode):
    getattr(dut, 'in').value = 0
    dut.rst.value = 0
    dut.down.value = 0
    dut.mode.value = mode
    dut.clr.value = 0


@cocotb.test()
async def direct_test(dut):
    """Test direct mode"""

    clock = cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())
    dut_in = getattr(dut, 'in')

    init(dut, 0)
    await RisingEdge(dut.clk)

    for _ in range(50):
        v = random.randint(0, 1)
        dut_in.value = v
        await RisingEdge(dut.clk)
        assert dut.out.value == v
        assert dut.mag.value == 0


@cocotb.test()
async def direct_increase_test(dut):
    """Test direct increase"""

    clock = cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())
    dut_in = getattr(dut, 'in')

    init(dut, 0)
    await RisingEdge(dut.clk)

    dut_in.value = 1
    dut.clr.value = 1
    await RisingEdge(dut.clk)

    for i in range(4):
        assert dut.mag.value == i
        await ClockCycles(dut.clk, 64)

    await ClockCycles(dut.clk, 128)
    assert dut.mag.value == 3

    dut.clr.value = 0
    await ClockCycles(dut.clk, 128)
    assert dut.out.value == 1
    assert dut.mag.value == 3

    dut_in.value = 0
    await ClockCycles(dut.clk, 2)
    assert dut.out.value == 0
    assert dut.mag.value == 0


@cocotb.test()
async def once_mode_test(dut):
    """Test once mode"""

    clock = cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())
    dut_in = getattr(dut, 'in')

    init(dut, 1)
    await RisingEdge(dut.clk)
    dut_in.value = 1

    await ClockCycles(dut.clk, 64)
    dut.down.value = 1
    await ClockCycles(dut.clk, 2)
    dut.down.value = 0

    assert dut.out.value == 1
    assert dut.mag.value == 0

    await ClockCycles(dut.clk, 128)
    assert dut.out.value == 1
    assert dut.mag.value == 0

    dut.clr.value = 1
    await ClockCycles(dut.clk, 2)
    assert dut.out.value == 0

    await ClockCycles(dut.clk, 128)
    assert dut.out.value == 0
