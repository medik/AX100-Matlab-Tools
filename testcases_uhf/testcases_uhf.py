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
        print(gen_ping(dest, interval, size))

def main():
    #print("Generating testcases")
    ping_multi(10, 1, 1000, 100)

if __name__ == "__main__":
    main()
