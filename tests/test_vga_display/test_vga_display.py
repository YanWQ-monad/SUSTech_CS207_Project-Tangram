import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer

from mock_ram import MockRAM


def assert_color(dut, data):
    r = data & 0xF
    g = (data >> 4) & 0xF
    b = (data >> 8) & 0xF

    current  = f' Signals: r={dut.vga_r.value.integer}, g={dut.vga_g.value.integer}, b={dut.vga_b.value.integer}'
    expected = f'Expected: r={r}, g={g}, b={b}'
    msg = f'\n\t{current}\n\t{expected}'

    assert dut.vga_r.value.integer == r, msg
    assert dut.vga_g.value.integer == g, msg
    assert dut.vga_b.value.integer == b, msg


@cocotb.test()
async def vga_display_test(dut):
    """Test VGA display from buffer"""

    ram = MockRAM(640 * 480)
    for i in range(len(ram.data)):
        ram.data[i] = random.randint(0, 0xFFF)

    cocotb.start_soon(ram.bind(dut.clk, dut.ram_address, dut.ram_enable, dut.ram_data))
    clock = cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())
    dut.rst.value = 0
    dut.ram_address_offset.value = 0
    await RisingEdge(dut.clk_pix)

    while not dut.vga_de.value:
        await RisingEdge(dut.clk_pix)

    for r in range(2):
        y_range = 480 if r == 0 else 10
        for y in range(y_range):
            if y % 100 == 0:
                dut._log.info(f'progress: round={r}, y={y}')

            for x in range(640):
                pixel_id = y * 640 + x
                assert_color(dut, ram.data[pixel_id])
                await RisingEdge(dut.clk_pix)

            while not dut.vga_de.value:
                await RisingEdge(dut.clk_pix)
