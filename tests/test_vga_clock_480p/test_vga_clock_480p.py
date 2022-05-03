import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer


def assert_signals(dut, clk, locked):
    current  = f' Signals: clk={dut.clk_pix.value.integer} locked={dut.clk_pix_locked.value.integer}'
    expected = f'Expected: clk={clk} locked={locked}'
    msg = f'\n\t{current}\n\t{expected}'

    assert clk is None or dut.clk_pix.value == clk, msg
    assert locked is None or dut.clk_pix_locked.value == locked, msg


@cocotb.test()
async def vga_clock_480p_basic_test(dut):
    """Test the clock of VGA 480P"""

    clock = cocotb.start_soon(Clock(dut.clk_100m, 10, 'ns').start())
    dut.rst.value = 0
    await RisingEdge(dut.clk_100m)

    for i in range(100):
        await RisingEdge(dut.clk_100m)
        assert_signals(dut, i % 4 == 3, True)


@cocotb.test()
async def vga_clock_480p_reset_test(dut):
    """Test reset function of the clock of VGA 480P"""

    clock = cocotb.start_soon(Clock(dut.clk_100m, 10, 'ns').start())
    dut.rst.value = 0
    await RisingEdge(dut.clk_100m)

    wait = random.randint(1, 100)
    dut._log.info(f'Wait {wait} cycles')
    await ClockCycles(dut.clk_pix, wait)

    dut.rst.value = 1
    await RisingEdge(dut.clk_100m)
    dut.rst.value = 0
    await RisingEdge(dut.clk_100m)

    for i in range(100):
        await RisingEdge(dut.clk_100m)
        assert_signals(dut, i % 4 == 3, True)
