from cocotb.triggers import RisingEdge, Timer
from cocotb.handle import Deposit

class MockRAM:
    def __init__(self, size):
        self.data = [0] * size
    
    async def bind(self, clk, address, enable, out, write_enable, inp):
        while True:
            await RisingEdge(clk)
            await Timer(1, 'ns')
            if enable.value:
                if out is not None:
                    out.value = self.data[address.value.integer]
                if write_enable.value and inp is not None:
                    self.data[address.value.integer] = inp.value.integer

    async def bind_read(self, clk, address, enable, output):
        await self.bind(clk, address, enable, output, Deposit(0), None)
    
    async def bind_write(self, clk, address, enable, inp):
        await self.bind(clk, address, enable, None, enable, inp)
