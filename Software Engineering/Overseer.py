
#### FA-2 ###################################################################

#Add your code where you see fit

from time import sleep
from random import random
from multiprocessing import *


def report(identifier):
    sleep(1)
    print("Process {} reported".format(identifier))


def task(lock, identifier, value):
    with lock:
        print("Process {} running... ".format(identifier))
        sleep(value)
        report(identifier)



def main():
    lock = Lock()

    processes = [Process(target=task,
                        args=(lock, i, random())) for i in range(10)]

    for process in processes:
        process.start()

    for process in processes:
        process.join()

main()

#############################################################################
