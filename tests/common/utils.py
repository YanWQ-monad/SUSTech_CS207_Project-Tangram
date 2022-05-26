class ErrorCollector:
    def __init__(self, comment=None):
        self.cnt = 0
        self.max_diff = 0
        self.sum_diff = 0
        self.comment = comment
    
    def add(self, diff):
        self.cnt += 1
        self.max_diff = max(diff, self.max_diff)
        self.sum_diff += diff
    
    def report(self):
        s = 'difference: max={:.6f} avg={:.6f}'.format(self.max_diff, self.sum_diff / self.cnt)
        if self.comment:
            s += f' ({self.comment})'
        return s


DECIMAL_BITS = 16


def fixed_float(x):
    return int(x * (1 << DECIMAL_BITS) + 0.5)


def unfixed_float(x):
    return x / (1 << DECIMAL_BITS)
