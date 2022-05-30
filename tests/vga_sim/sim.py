import pygame

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles


@cocotb.test()
async def vga_sim(dut):
    dut.reset.value = 1

    clock = cocotb.start_soon(Clock(dut.clk, 2, 'ns').start())

    await ClockCycles(dut.clk, 100)  # let it initialize
    dut.reset.value = 0              # reset VGA
    await RisingEdge(dut.clk)
    dut.reset.value = 1
    await RisingEdge(dut.clk)

    pygame.init()
    pygame.display.set_caption('Tangram - VGA Simulator')
    surface = pygame.display.set_mode((800, 600))
    surface.fill(pygame.Color(128, 128, 128))

    vga_x = getattr(dut, 'core.sx')
    vga_y = getattr(dut, 'core.sy')
    vga_de = getattr(dut, 'core.de')

    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                return

        await RisingEdge(dut.clk)
        if not vga_de.value:
            continue

        r = dut.vga_r.value.integer
        g = dut.vga_g.value.integer
        b = dut.vga_b.value.integer

        xy = (vga_x.value.integer, vga_y.value.integer)
        color = pygame.Color((r << 4) | r, (g << 4) | g, (b << 4) | b)
        surface.set_at(xy, color) 

        if xy[0] == 0:
            pygame.display.flip()
