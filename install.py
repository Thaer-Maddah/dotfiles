# ======================================================
# Author: Thaer Maddah
# Filename:install.py
# Copyright 2021
# Description: This script installs configuration files
# ======================================================

import os
import sys
import re
import subprocess
# from tqdm import tqdm
from time import sleep


def main():
    # Check OS and Python verion
    checkSystem()

    try:
        response = input("Do you really want to replace old files?." +
                         "[\033[091m\033[01mYes\033[0m" +
                         "/" + "\033[091m\033[01m" + "No\033[0m]> ")
        if (response.upper() in "Y" or response.upper() in "YES") \
                and response not in "":
            install()
        else:
            print("Process canceld by user!.")
            exit()
    except KeyboardInterrupt:
        print(" You pressed CTRL+C. Good Bye for now!")


def checkSystem():
    # Check OS
    if sys.platform != "linux":
        raise SystemExit("Must be using GNU/Linux OS!")

    # Check Python version
    if sys.version_info[0] < 3:
        raise SystemExit("Must be using Python 3")


# def progress(file_name):
    # for i in tqdm(range(1), ncols=75, desc="Copy " + file_name):
    #     sleep(0.2)


# Print iterations progress
def printProgressBar(iteration, total=10, prefix='', suffix='',
                     decimals=1, length=30, fill='█', printEnd="\r"):
    """
    Call in a loop to create terminal progress bar
    @params:
        iteration   - Required  : current iteration (Int)
        total       - Required  : total iterations (Int)
        prefix      - Optional  : prefix string (Str)
        suffix      - Optional  : suffix string (Str)
        decimals    - Optional  : positive number of decimals in percent complete (Int)
        length      - Optional  : character length of bar (Int)
        fill        - Optional  : bar fill character (Str)
        printEnd    - Optional  : end character (e.g. "\r", "\r\n") (Str)
    """
    percent = ("{0:." + str(decimals) + "f}") \
        .format(100 * (iteration / float(total)))

    filledLength = int(length * iteration // total)
    bar = fill * filledLength + '-' * (length - filledLength)
    print(f'\r{prefix} |{bar}| {percent}% {suffix}', end=printEnd)
    # Print New Line on Complete
    if iteration == total:
        print()


def install():
    # Search for file location
    homedir = os.environ['HOME']
    ltag = 'File Location:'

    # Open file for read
    path = os.getcwd()
    files = os.listdir(path)

    # execluded python files and it's backup
    # that created by emacs or another text editor
    x = re.compile('^.[a-z_-]*[1-9]*.py(.)?$', re.IGNORECASE)

    index = 0

    for f in files:
        if os.path.isfile(f) and not x.match(f):
            fname = path + "/" + f
            infile = open(fname, "r")
            index += 1
            for line in infile:
                line = infile.readline()
                if ltag in line:
                    print(index, f, "\t\t| File |")

                    # get path from file and remove special characters
                    try:
                        floc = line.split("~")[1].strip()
                        floc = homedir + floc
                        # check if file existes
                        file_exist = os.path.exists(floc)
                    except FileNotFoundError:
                        print(FileNotFoundError)
                        # pass

                    if file_exist:
                        try:
                            subprocess.run(['rm', floc])
                            res = subprocess.run(['ln', '-s', fname, floc])
                            if res.returncode:
                                print("File not copied!.")
                            else:
                                # Initial call to print 0% progress
                                # total = 10
                                printProgressBar(0, 10,
                                                 prefix='Progress:',
                                                 suffix='Complete',
                                                 length=30)
                                
                                for i in range(10):
                                    # Do stuff...
                                    sleep(0.03)
                                    # Update Progress Bar
                                    printProgressBar(i + 1, 10,
                                                     prefix='Progress:',
                                                     suffix='Complete',
                                                     length=30)

                                print(f"File {f} copied!")
                                # progress(f)

                        except IOError:
                            pass
                            # print('IOError encounterd')

                else:
                    pass


# Call main function
if __name__ == "__main__":
    main()
