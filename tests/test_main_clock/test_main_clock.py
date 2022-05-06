import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer
from cocotb.utils import get_sim_time


@cocotb.test()
async def clock_test(dut):
    """Test main clock"""

    await RisingEdge(dut.clk)

    for _ in range(16):
        start_time = get_sim_time('ns')
        await RisingEdge(dut.clk)
        end_time = get_sim_time('ns')
        assert end_time - start_time == 10
