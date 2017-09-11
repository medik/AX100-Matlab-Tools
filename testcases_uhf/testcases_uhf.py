import sys

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
        print(gen_ping(dest, interval, 3, size))

def hex_to_int_arr(hex):
    ret = []
    for s in hex:
        ret.append(int(s, 16))
    return ret

def custom_multi(n, msg, delay):
    msg_int_arr = hex_to_int_arr(msg)
    for i in range(n):
        print(gen_custom_msg(msg_int_arr, delay))

def set(table, mem, param, delay):
    print("0 0 0 rparam download 20 " + str(table))
    print(str(delay) + " 0 0 rparam set " + str(mem) + " " + str(param))

def reboot(delay):
    print(str(delay) + " 0 0 reboot 20")

def enter_raw_mode():
    set(0, "mode", 1, 100)

def enter_normal_mode():
    set(0, "mode", 2, 100)

def enable_rs():
    set(0, "fcs", 1, 100)

def main():
    #print("Generating testcases")
    enable_rs()

    enter_raw_mode()
    for i in range(5):
        ping_multi(10, i, 1000, 100)
        ping_multi(10, i, 1000, 10)

    custom_multi(10, "FFFFFFFFFF", 1000)

    enter_normal_mode()

    for i in range(1,5):
        ping_multi(10, i, 1000, 100)
        ping_multi(10, i, 1000, 10)

    custom_multi(10, "FFFFFFFFFF", 1000)


if __name__ == "__main__":
    main()
