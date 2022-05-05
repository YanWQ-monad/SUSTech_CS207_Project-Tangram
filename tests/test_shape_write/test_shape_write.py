import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer

from mock_ram import MockRAM


@cocotb.test()
async def shape_write_test(dut):
    """Test shape reading from memory"""

    ram = MockRAM(32)

    cocotb.start_soon(ram.bind_write(dut.clk, dut.ram_address, dut.ram_enable, dut.ram_data))
    clock = cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())
    dut.id.value = 1
    dut.ram_address_offset.value = 0
    await RisingEdge(dut.clk)

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    dut.ty.value = 5
    dut.x.value = 6
    dut.y.value = 7
    dut.size.value = 8
    dut.rotate.value = 9

    dut.trigger.value = 1
    await RisingEdge(dut.clk)
    dut.trigger.value = 0

    await ClockCycles(dut.clk, 10)
    assert ram.data[8:13] == [5, 6, 7, 8, 9]
