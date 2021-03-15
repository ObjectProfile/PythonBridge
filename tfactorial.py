import argparse
import threading
import time


# Calculate the factorial
def factorial(n, t):
    time.sleep(n*t/4)
    print("Start: " + str(t) + ": " + str(n))
    if n == 1:
        res = 1
        if t == 1:
            print("Feel free to break here")
    else:
        res = n * factorial(n-1, t)
    return res


# Calculate the factorial and print the result
def factorial_thread(n, t):
    time.sleep(2)
    result = factorial(n, t)
    print("Thread " + str(t) + " = "+str(result))


def launch_factorials(n):
    threads = []
    print("Calculate: "+str(n))
    breakpoint()
    for i in range(n):
        threads.append(threading.Thread(target=factorial_thread, args=(n+i, i+1)))
        threads[-1].start()
    print("Wait for the results")
    for thread in threads:
        thread.join()
    print("Done")
