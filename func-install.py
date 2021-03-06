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
from time import sleep, time


def main():
    # Open file for read
    dir_path = os.getcwd()
    files = os.listdir(dir_path)

    # Check OS and Python verion
    checkSystem()

    try:
        response = input("Do you really want to replace old files?." +
                         "[\033[091m\033[01mYes\033[0m" +
                         "/" + "\033[091m\033[01m" + "No\033[0m]> ")
        if (response.upper() in "Y" or response.upper() in "YES") \
                and response not in "":
            # Start timer
            start_time = time()

            getfiles = readFiles(files, dir_path)
            data = readContent(getfiles)
            installFiles(data, getfiles)

            # End timer
            end_time = time()
            timer = end_time - start_time
            print(timer)
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


def checkApp(app_name, file_name):
    # Check whether name is on PATH and marked as executable.
    # from whichcraft import which
    from shutil import which
    # for app, fname in zip(app_name[3], file_name[0]):
    if not which(app_name):
        print(file_name, "not found!.")  # line to check
        check_app = False
    else:
        print(app_name)
        check_app = True

    return check_app


def readFiles(files, dir_path):

    # execluded python, README.md files and their backups which created by emacs
    x = re.compile('^.*\.(py)?(md)?(~)?$', re.IGNORECASE)
    file_name, full_path_name, file_content = [], [], []
    index = 0
    # print(dict(enumerate(files)))
    for idx, value in enumerate(files):
        # print("for loop:", idx)
        if os.path.isfile(value) and not x.match(value):
            # print("after if", idx)
            file_name.append(value)
            full_path_name.append(dir_path + "/" + value)
            file_content.append(open(full_path_name[index], "r"))
            index += 1
    return file_name, full_path_name, file_content


def readContent(files):
    index = 0
    file_location = []
    file_dest = []
    file_exists = []
    app_name = []

    # Tags for file location and app name
    homedir = os.environ['HOME']
    location_tag = 'File Location:'
    app_tag = 'Binary App:'

    # print(files)
    for lines in files[2]:
        lines = lines.readlines()
        
        for line in lines:
            if location_tag in line:
                # print("Line{}: {}".format(index, line.strip()))
                # print(index, rf[0], "\t\t| File |")
                # get path from file and remove special characters
                try:
                    file_location.append(line.split("~")[1].strip())
                    file_dest.append(homedir + file_location[index])
                    # check if file existes
                    file_exists.append(os.path.exists(file_dest[index]))
                    index += 1
                except FileNotFoundError:
                    print(FileNotFoundError)
                # print(line)
            else:
                pass

            if app_tag in line:
                app_name.append(line.split(' ')[3].strip())

    # print(file_dest)
            # yield line

    return file_location, file_dest, file_exists, app_name


def installFiles(data, files):
    for file_exists, file_name, file_location, file_dest, app_name \
            in zip(data[2], files[0], files[1], data[1], data[3]):
        # print(file_name + '\t\t| ', file_location + '\t|',
        #       file_dest + '\t| ', file_exists, '| ', app_name)
        # if checkApp(app_name, file_name):
        #     break
        if file_exists:
            try:
                subprocess.run(['rm', file_dest])
                # create links to the config files
                res = subprocess.run(['ln', '-s',
                                      file_location,
                                      file_dest])
                if res.returncode:
                    print("File not copied!.")
                else:
                    # Initial call to print 0% progress
                    # total = 10
                    # printProgressBar(0, 10,
                    #                  prefix='Progress:',
                    #                  suffix='Complete',
                    #                  length=30)

                    # for i in range(10):
                    #     # Do stuff...
                    #     sleep(0.01)
                    #     # Update Progress Bar
                    #     printProgressBar(i + 1, 10,
                    #                      prefix='Progress:',
                    #                      suffix='Complete',
                    #                      length=30)

                    print(f"File {file_name} copied!")

            except IOError:
                pass
                # print('IOError encounterd')
        # else:

    else:
        pass


# Print iterations progress
def printProgressBar(iteration, total=10, prefix='', suffix='',
                     decimals=1, length=30, fill='???', printEnd="\r"):
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
