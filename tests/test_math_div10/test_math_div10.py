import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def div10_test(dut):
    """Test div10"""

    dut_in = getattr(dut, 'in')

    for i in range(0, 10000):
        dut_in.value = i

        await Timer(2, units="ns")

        quotient = dut.quotient.value.integer
        remainder = dut.remainder.value.integer

        assert quotient == i // 10, f'quotient is wrong: {quotient}'
        assert remainder == i % 10, f'remainder is wrong: {remainder}'
