import sys

LINE_LENGTH = 0
SCRIPT_ARR = []

def empty_script():
    SCRIPT_ARR[:] = []

def write_script_to_file(filename):
    fh = open(filename, 'w', encoding='utf-8')

    s = ""
    for st in SCRIPT_ARR:
        s += st + '\n'

    fh.write(s)
    empty_script()
    
def add_to_script(str):
    if len(SCRIPT_ARR) < 100:
        SCRIPT_ARR.append(str)
    else:
        print("""
              WARNING! Your script is more than 99 lines! You should be aware of that csp-term ignores any lines longer.
              """)

def print_script():
    for s in SCRIPT_ARR:
        print(s)

def gen_custom_msg(int_arr, delay):
    # int_arr is an array of integers from 0 to 256

    toSend = ""

    for i in int_arr:
        toSend += str(i) + " "

    return str(delay) + " 0 0 obckth tc 20 " + toSend

def gen_ping(destination, delay, timeout, size):
    return str(delay) + " 0 0 ping " + str(destination) + " " + str(timeout) + " " + str(size)

def ping_multi(n, dest, interval, size):
    for i in range(n):
        add_to_script(gen_ping(dest, interval, 3, size))

def hex_to_int_arr(hex):
    ret = []

    tmp_arr = []
    tmp_str = ""

    for s in hex:
        tmp_str += s

        # do check
        if len(tmp_str) == 2:
            tmp_arr.append(tmp_str)
            tmp_str = ""

    for s in tmp_arr:
        ret.append(int(s, 16))
    return ret

def custom_multi(n, msg, delay):
    msg_int_arr = hex_to_int_arr(msg)
    for i in range(n):
        add_to_script(gen_custom_msg(msg_int_arr, delay))

def set(table, mem, param, delay):
    add_to_script("0 0 0 rparam download 20 " + str(table))
    add_to_script(str(delay) + " 0 0 rparam set " + str(mem) + " " + str(param))

def reboot(delay):
    add_to_script(str(delay) + " 0 0 reboot 20")

def enter_raw_mode():
    set(0, "mode", 1, 100)

def enter_normal_mode():
    set(0, "mode", 2, 100)

def enable_rs():
    set(0, "fcs", 1, 100)

def generate_testcases():
    # Should be default
    enable_rs()

    ## Generate 5x10 ping messages with different lengths in RAW
    enter_raw_mode()
    for i in range(5):
        ping_multi(10, 1, 1000, 15 + i*5)

    write_script_to_file("ping-length-raw.g")

    ## Generate 5x10 ping msg with different lengths in Sync
    enter_normal_mode()
    for i in range(5):
        ping_multi(10, 1, 1000, 15 + i*5)

    write_script_to_file("ping-length-sync.g")

    ## Generate 5x10 ping msg with different destination in raw
    enter_raw_mode()
    for i in range(1,6):
        ping_multi(10, i, 1000, 10)

    write_script_to_file("ping-dst-raw.g")

    ## Generate 5x10 ping msg in sync
    enter_normal_mode()
    for i in range(1,6):
        ping_multi(10, i, 1000, 10)

    write_script_to_file("ping-dst-sync.g")

    ## Standard
    enter_raw_mode()
    ping_multi(10, 1, 1000, 10)

    write_script_to_file("ping-std-raw.g")
    
    enter_normal_mode()
    ping_multi(10, 1, 1000, 10)

    write_script_to_file("ping-std-sync.g")


def main():
    # Max length is 100
    #print("Generating testcases")

    generate_testcases()

if __name__ == "__main__":
    main()
