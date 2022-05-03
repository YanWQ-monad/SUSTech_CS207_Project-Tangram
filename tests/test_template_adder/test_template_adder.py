import random
import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def adder_basic_test(dut):
    """Test for 5 + 10"""

    a = 5
    b = 10

    dut.a.value = a
    dut.b.value = b

    await Timer(2, units="ns")

    assert dut.out.value == a + b, f"Adder result is incorrect: {dut.out.value} != 15"


@cocotb.test()
async def adder_randomized_test(dut):
    """Test for adding 2 random numbers multiple times"""

    for i in range(10):
        a = random.randint(0, 15)
        b = random.randint(0, 15)

        dut.a.value = a
        dut.b.value = b

        await Timer(2, units="ns")

        assert dut.out.value == a + b, "Randomised test failed with: {a} + {b} = {X}".format(
            a=dut.a.value, b=dut.b.value, X=dut.out.value
        )
