MAX_SHAPE = 16

ARGUMENTS = [
    's_ty',
    's_x',
    's_y',
    's_size',
    's_angle',
    's_color',
]

class Shape:
    def __init__(self, ty, x, y, size, angle, color):
        self.ty = ty
        self.x = x
        self.y = y
        self.size = size
        if angle >= 180:
            angle -= 360
        self.angle = angle
        self.color = color
    
    def hdl(self, i):
        return f'''
s_ty[{i}] <= {self.ty};
s_x[{i}] <= {self.x};
s_y[{i}] <= {self.y};
s_size[{i}] <= {self.size};
s_angle[{i}] <= {self.angle};
s_color[{i}] <= 12'h{self.color:03X};
'''.strip()

cx = 400
cy = 300
size = 200

SHAPES = [
    Shape(0, cx            , cy            , int(size * 1.414)    , 225, 0x6cd), # Left (Large Triangle)
    Shape(0, cx            , cy            , int(size * 1.414)    , 135, 0xde9), # Top (Large Triangle)
    Shape(0, cx            , cy            , int(size / 2 * 1.414),  45, 0xff2), # Right (Small Triangle)
    Shape(2, cx            , cy            , int(size / 2 * 1.414), -45, 0xa9c), # Bottom (Medium Square)
    Shape(0, cx - size // 2, cy + size // 2, int(size / 2 * 1.414), -45, 0xf9c), # Left Bottom (Small Triangle)
    Shape(0, cx + size     , cy + size     , size                 , 180, 0xfc2), # Right Bottom (Medium Triangle)
    Shape(5, cx + size     , cy - size     , size // 2            , -90, 0xf46), # Right Top (Medium Parallelogram)
]

print(f'number <= {len(SHAPES)};')
print()

for i, s in enumerate(SHAPES):
    print(s.hdl(i))
    print()

for i in range(len(SHAPES), MAX_SHAPE):
    for arg in ARGUMENTS:
        print(f'{arg}[{i}] <= 0;')
    print()
