import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer


def assert_signals(dut, out, ondn, onup):
    current  = f' Signals: out={dut.out.value.integer} ondn={dut.ondn.value.integer} onup={dut.onup.value.integer}'
    expected = f'Expected: out={out} ondn={ondn} onup={onup}'
    msg = f'\n\t{current}\n\t{expected}'

    assert dut.out.value.integer == out, msg
    assert dut.ondn.value.integer == ondn, msg
    assert dut.onup.value.integer == onup, msg


@cocotb.test()
async def fake_debounce_test(dut):
    """Test input debounce"""

    clock = cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())

    hdl_in = getattr(dut, 'in')
    hdl_in.value = 0
    await RisingEdge(dut.clk)

    hdl_in.value = 1
    await ClockCycles(dut.clk, 10)
    hdl_in.value = 0

    for _ in range(2 ** 18 + 100):
        await RisingEdge(dut.clk)
        assert_signals(dut, 0, 0, 0)


@cocotb.test()
async def debounce_test(dut):
    """Test input debounce"""

    clock = cocotb.start_soon(Clock(dut.clk, 10, 'ns').start())

    hdl_in = getattr(dut, 'in')
    hdl_in.value = 0
    await RisingEdge(dut.clk)

    hdl_in.value = 1
    await ClockCycles(dut.clk, 2 ** 18 + 2)

    assert_signals(dut, 0, 1, 0)

    for _ in range(10):
        await RisingEdge(dut.clk)
        assert_signals(dut, 1, 0, 0)

    hdl_in.value = 0
    await ClockCycles(dut.clk, 2 ** 18 + 2)

    assert_signals(dut, 1, 0, 1)

    for _ in range(10):
        await RisingEdge(dut.clk)
        assert_signals(dut, 0, 0, 0)
