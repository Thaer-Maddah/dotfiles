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
from time import sleep

# Search for file location
homedir = os.environ['HOME']
location_tag = 'File Location:'
type_tag = 'File Type:'

# Open file for read
dir_path = os.getcwd()
files = os.listdir(dir_path)


def main():
    # Check OS and Python verion
    checkSystem()

    try:
        response = input("Do you really want to replace old files?." +
                         "[\033[091m\033[01mYes\033[0m" +
                         "/" + "\033[091m\033[01m" + "No\033[0m]> ")
        if (response.upper() in "Y" or response.upper() in "YES") \
                and response not in "":
            # install()
            # list1 = readContent()
            # print(list1[2])
            installFiles()
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


def readFiles():
    # execluded python files and it's backup which  created by emacs
    x = re.compile('^.[a-z_-]*[1-9]*.py(.)?$', re.IGNORECASE)
    file_name, full_path_name, file_content = [], [], []
    index = 0
    for i in files:
        if os.path.isfile(i) and not x.match(i):
            file_name.append(i)
            full_path_name.append(dir_path + "/" + i)
            file_content.append(open(full_path_name[index], "r"))
            index += 1
    return file_name, full_path_name, file_content


def readContent():
    index = 0
    counter = 0
    file_location = []
    file_dest = []
    file_exists = []
    rf = readFiles()
    line = []
    for lines in rf[2]:
        lines = lines.readlines()
        for line in lines:
            counter += 1
            if location_tag in line:
                # print("Line{}: {}".format(counter, line.strip()))
                # print(index, rf[0], "\t\t| File |")
                index += 1
                # get path from file and remove special characters
                try:
                    file_location = line.split("~")[1].strip()
                    file_dest = homedir + file_location
                    # check if file existes
                    file_exists = os.path.exists(file_dest)

                    # print(file_dest)
                except FileNotFoundError:
                    print(FileNotFoundError)
                    # pass

    return file_location, file_dest, file_exists


def installFiles():
    # files = readFiles()
    data = readContent()
    counter = 0

    for i in data[0]:
        print(data[0])
        # file_exists = data[2]
        # if file_exists:
        #     try:
        #         pass
        #         # subprocess.run(['rm', data[1]])
        #         # create links to the config files
        #         res = subprocess.run(['ln', '-s',
        #                               data[0],
        #                               data[1]])
        #         if res.returncode:
        #             print("File not copied!.")
        #         else:
        #             # Initial call to print 0% progress
        #             # total = 10
        #             printProgressBar(0, 10,
        #                              prefix='Progress:',
        #                              suffix='Complete',
        #                              length=30)

        #             for i in range(10):
        #                 # Do stuff...
        #                 sleep(0.02)
        #                 # Update Progress Bar
        #                 printProgressBar(i + 1, 10,
        #                                  prefix='Progress:',
        #                                  suffix='Complete',
        #                                  length=30)

        #             print(f"File {f[0]} copied!")
        #             # progress(f)

        #     except IOError:
        #         pass
        #         # print('IOError encounterd')
        # else:
        #     # Check whether name is on PATH and marked as executable.
        #     # from whichcraft import which
        #     from shutil import which

        #     if not which('emacs'):
        #         print("Error")

    else:
        pass


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


# Call main function
if __name__ == "__main__":
    main()
