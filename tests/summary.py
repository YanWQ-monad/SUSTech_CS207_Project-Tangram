import os
import sys
from cocotb import ANSI
from xml.etree import ElementTree

HEADER = ' {:<60} {:^6}   {:>13}  {:>14}  {:>13} '.format('TEST', 'STATUS', 'SIM TIME (ns)', 'REAL TIME (s)', 'RATIO (ns/s)')

def fmt(classname, name, status, sim_time_ns, time, ratio_time):
    return ' {:<60}  {}   {:>13.2f}  {:>14.2f}  {:>13.2f} '.format(classname + '.' + name, status, sim_time_ns, time, ratio_time)


def get_test_results(testcase, summary):
    summary['tests'] += 1
    if testcase.find('failure') is not None:
        summary['fail'] += 1
        return ANSI.COLOR_FAILED + 'FAIL' + ANSI.COLOR_DEFAULT
    elif testcase.find('skipped') is not None:
        summary['skip'] += 1
        return ANSI.COLOR_SKIPPED + 'SKIP' + ANSI.COLOR_DEFAULT
    summary['pass'] += 1
    return ANSI.COLOR_PASSED + 'PASS' + ANSI.COLOR_DEFAULT


def fmt_summary_item(name, count, color):
    if count == 0:
        return f'{name}={count}'
    else:
        return color + f'{name}={count}' + ANSI.COLOR_DEFAULT


def main():
    paths = sys.argv[1:]

    print('-' * len(HEADER))
    print(HEADER)
    print('-' * len(HEADER))

    summary = {'tests': 0, 'pass': 0, 'fail': 0, 'skip': 0}
    for path in paths:
        root = ElementTree.parse(os.path.join(path, 'results.xml')).getroot()
        testsuite = root[0]
        for testcase in testsuite:
            if testcase.tag != 'testcase':
                continue

            name = testcase.attrib['name']
            classname = testcase.attrib['classname']
            time = float(testcase.attrib['time'])
            sim_time_ns = float(testcase.attrib['sim_time_ns'])
            ratio_time = float(testcase.attrib['ratio_time'])

            status = get_test_results(testcase, summary)

            print(fmt(classname, name, status, sim_time_ns, time, ratio_time))
    
    print('-' * len(HEADER))
    print(' ' + ' '.join([
        fmt_summary_item('TESTS', summary['tests'], ANSI.COLOR_DEFAULT),
        fmt_summary_item('PASS', summary['pass'], ANSI.COLOR_PASSED),
        fmt_summary_item('FAIL', summary['fail'], ANSI.COLOR_FAILED),
        fmt_summary_item('SKIP', summary['skip'], ANSI.COLOR_SKIPPED),
    ]))

    if summary['fail'] > 0:
        sys.exit(1)


if __name__ == '__main__':
    main()
