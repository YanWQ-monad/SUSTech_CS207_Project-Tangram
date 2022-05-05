import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer

from mock_ram import MockRAM


@cocotb.test()
async def shape_read_test(dut):
    """Test shape reading from memory"""

    ram = MockRAM(32)
    for i in range(len(ram.data)):
        ram.data[i] = random.randint(0, 0xFF)

    cocotb.start_soon(ram.bind_read(dut.clk, dut.ram_address, dut.ram_enable, dut.ram_data))
    clock = cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())
    dut.id.value = 1
    dut.ram_address_offset.value = 0
    await RisingEdge(dut.clk)

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    dut.trigger.value = 1
    await RisingEdge(dut.clk)
    dut.trigger.value = 0

    await ClockCycles(dut.clk, 10)

    assert dut.ty.value == ram.data[8]
    assert dut.x.value == ram.data[9]
    assert dut.y.value == ram.data[10]
    assert dut.size.value == ram.data[11]
    assert dut.rotate.value == ram.data[12]
