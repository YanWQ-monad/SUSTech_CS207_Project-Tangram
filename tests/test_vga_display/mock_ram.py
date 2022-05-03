from cocotb.triggers import RisingEdge


class MockRAM:
    def __init__(self, size):
        self.data = [0] * size

    async def bind(self, clk, address, enable, output):
        while True:
            await RisingEdge(clk)
            if enable.value:
                output.value = self.data[address.value.integer]
