# ======================================================
# Author: Thaer Maddah
# Filename:install.py
# Copyright 2021
# Description: This script installs configuration files
# ======================================================


import os
import re
import subprocess
# import string


def main():
    # Search for file location
    homedir = os.environ['HOME']
    ltag = 'File Location:'

    # Open file for read
    path = os.getcwd()
    files = os.listdir(path)

    # execluded python files and it's backup
    # that created by emacs or another text editor
    x = re.compile('^.[a-z]*.py(.)?$', re.IGNORECASE)

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
                    floc = line.split("~")[1].strip()
                    floc = homedir + floc

                    # check if file existes
                    file_exist = os.path.exists(floc)

                    if file_exist:
                        print(floc + "\n")
                        try:
                            # cmd = os.system("ln -s {fname} {floc}")
                            res = subprocess.run(['ln', '-s', fname, floc])
                            print('file copied!', res.returncode)
                        except IOError:
                            print('IOError encounterd')

                else:
                    pass
        # if os.path.isdir(f):
            # print(f, "\t\t| Directory |")


# Call main function
main()
