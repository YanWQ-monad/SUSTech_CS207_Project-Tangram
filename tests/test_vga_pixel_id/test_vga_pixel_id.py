import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer


@cocotb.test()
async def vga_pixel_id_uniqueness_test(dut):
    """Test the uniqueness of VGA pixel id"""

    H_PIXEL = 640  # Horizontal Pixel
    V_PIXEL = 480  # Vertical Pixel

    # id => (x, y)
    pixel_map = {}

    for x in range(H_PIXEL):
        dut.x.value = x

        for y in range(V_PIXEL):
            dut.y.value = y

            await Timer(1, 'ns')
            pixel_id = dut.id.value.integer

            another = pixel_map.get(pixel_id)
            assert pixel_id not in pixel_map, \
                f'({x}, {y})\'s id "{pixel_id}" is not unique, coincides with {another}'
            pixel_map[pixel_id] = (x, y)
