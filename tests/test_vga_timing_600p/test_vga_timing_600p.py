import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer


def assert_signals(dut, sx, sy, de, hsync, vsync):
    current  = f' Signals: sx={dut.sx.value.integer} sy={dut.sy.value.integer} de={dut.de.value} hsync={dut.hsync.value} vsync={dut.vsync.value}'
    expected = f'Expected: sx={sx} sy={sy} de={de} hsync={hsync} vsync={vsync}'
    msg = f'\n\t{current}\n\t{expected}'

    assert sx is None or dut.sx.value == sx, msg
    assert sy is None or dut.sy.value == sy, msg
    assert dut.de.value == de, msg
    assert hsync is None or dut.hsync.value == hsync, msg
    assert vsync is None or dut.vsync.value == vsync, msg


@cocotb.test()
async def vga_timing_600p_full_test(dut):
    """Test the timing of VGA 600P"""

    H_ACTIVE = 800  # Horizontal Active
    H_FRONT = 40    # Horizontal Front Porch
    H_SYNC = 128    # Horizontal Sync
    H_BACK = 88     # Horizontal Back Porch
    H_LINE = H_ACTIVE + H_FRONT + H_SYNC + H_BACK

    V_ACTIVE = 600  # Vertical Active
    V_FRONT = 1     # Vertical Front Porch
    V_SYNC = 4      # Vertical Sync
    V_BACK = 23     # Vertical Back Porch

    clock = cocotb.start_soon(Clock(dut.clk_pix, 10, 'ns').start())

    async def iterator_clock(times):
        for i in range(times):
            await RisingEdge(dut.clk_pix)
            yield i

    for r in range(2):
        for y in range(V_ACTIVE):
            if y % 100 == 0:
                dut._log.info(f'progress: round={r}, y={y}')

            async for x in iterator_clock(H_ACTIVE):
                assert_signals(dut, x, y, 1, 1, 1)

            async for _ in iterator_clock(H_FRONT):
                assert_signals(dut, None, None, 0, 1, 1)

            async for _ in iterator_clock(H_SYNC):
                assert_signals(dut, None, None, 0, 0, 1)

            async for _ in iterator_clock(H_BACK):
                assert_signals(dut, None, None, 0, 1, 1)

        async for _ in iterator_clock(V_FRONT * H_LINE):
            assert_signals(dut, None, None, 0, None, 1)

        async for _ in iterator_clock(V_SYNC * H_LINE):
            assert_signals(dut, None, None, 0, None, 0)

        async for _ in iterator_clock(V_BACK * H_LINE):
            assert_signals(dut, None, None, 0, None, 1)


@cocotb.test()
async def vga_timing_600p_reset_test(dut):
    """Test the reset function of VGA timing 600P"""

    clock = cocotb.start_soon(Clock(dut.clk_pix, 10, 'ns').start())

    wait = random.randint(1, 800 * 525)
    dut._log.info(f'Wait {wait} cycles')
    await ClockCycles(dut.clk_pix, wait)

    dut.rst_pix.value = 1
    await ClockCycles(dut.clk_pix, 2)  # 1 cycle for input, 1 for output

    assert_signals(dut, 0, 0, 1, 1, 1)
