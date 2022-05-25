MAX_SHAPE = 16

for i in range(MAX_SHAPE):
    print(f'{MAX_SHAPE}\'b' + ('0' * (MAX_SHAPE - i - 1)) + '1' + ('x' * i) + f': id = `INT_BITS\'d{i};')
print('default: id = `INT_BITS\'bx;')
