MAX_SHAPE = 16

ARGUMENTS = [
    's_ty',
    's_x',
    's_y',
    's_size',
    's_angle',
    's_color',
]

print('''
s_ty[0] <= 0;
s_x[0] <= 400;
s_y[0] <= 300;
s_size[0] <= 10;
s_angle[0] <= 0;
s_color[0] <= 12'hFFF;
'''.strip())
print()

for i in range(1, MAX_SHAPE):
    for arg in ARGUMENTS:
        print(f'{arg}[{i}] <= 0;')
    print()
