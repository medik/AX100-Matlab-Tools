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

def main():
    #print("Generating testcases")
    ping_multi(10, 1, 1000, 100)
    custom_multi(10, "FFFFFFFFFF", 1000)

if __name__ == "__main__":
    main()
