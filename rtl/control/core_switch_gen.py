MAX_SHAPE = 16

ARGUMENTS = [
    's_ty',
    's_x',
    's_y',
    's_size',
    's_angle',
    's_color',
]

for i in range(MAX_SHAPE-1):
    for arg in ARGUMENTS:
        print(f'{arg}[{i + 1}] <= {arg}[{i}];')
    print()
