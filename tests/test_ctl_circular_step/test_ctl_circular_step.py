import random
import math

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer


@cocotb.test()
async def circular_next_test(dut):
    """Test circular 'next'"""

    dut_in = getattr(dut, 'in')

    for i in range(-180, 179):
        dut_in.value = i

        await Timer(2, units='ns')

        expected = (i + 180 + 1) % 360 - 180
        output = dut.next.value.signed_integer

        assert output == expected, f'{output} != {expected} at in={i}'


@cocotb.test()
async def circular_prev_test(dut):
    """Test circular 'prev'"""

    dut_in = getattr(dut, 'in')

    for i in range(-180, 179):
        dut_in.value = i

        await Timer(2, units='ns')

        expected = (i + 180 - 1) % 360 - 180
        output = dut.prev.value.signed_integer

        assert output == expected, f'{output} != {expected} at in={i}'
