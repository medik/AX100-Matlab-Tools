import sys
import subprocess
import argparse

LINE_LENGTH = 0
SCRIPT_ARR = []
DESTINATION = "20"

# Config parsing

def readConfig(f):
    config = configparser.ConfigParser()
    config.read(f)

    delay = 1000
    if 'TABLE_1' in config.sections():
        for key, val in config['TABLE_1'].items():
            set(1, key, val, delay)
    if 'TABLE_3' in config.sections():
        for key, val in config['TABLE_3'].items():
            set(3, key, val, delay)


# Script generation

def empty_script():
    SCRIPT_ARR[:] = []

def send_to_cspterm(cmd):
    bash_cmd = ["screen","-S","cspterm","-X","stuff", cmd +'\n']
    print(bash_cmd)
    process = subprocess.Popen(bash_cmd, stdout=subprocess.PIPE)
    output, error = process.communicate()

def execute_script():
    for cmd in SCRIPT_ARR:
        send_to_cspterm(cmd)
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

def gen_custom_msg(int_arr):
    # int_arr is an array of integers from 0 to 256

    toSend = ""

    for i in int_arr:
        toSend += str(i) + " "

    return "obckth tc " + DESTINATION + " " + toSend

def gen_ping(destination, timeout, size):
    return "ping " + str(destination) + " " + str(timeout) + " " + str(size)

def ping_multi(n, dest, size, timeout=3):
    for i in range(n):
        add_to_script(gen_ping(dest, timeout, size))

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

def custom_multi(n, msg):
    msg_int_arr = hex_to_int_arr(msg)
    for i in range(n):
        add_to_script(gen_custom_msg(msg_int_arr))

def set(table, mem, param):
    add_to_script("rparam download " + DESTINATION + " " + str(table))
    add_to_script("rparam set " + str(mem) + " " + str(param))

def reboot(delay):
    add_to_script("reboot " + DESTINATION)

def enter_raw_mode():
    set(0, "mode", 1)

def enter_normal_mode():
    set(0, "mode", 2)

def enable_rs():
    set(0, "fcs", 1)

def main():
    ping_multi(5, 1, 10)
    print_script()
    execute_script()


if __name__ == "__main__":
    main()
