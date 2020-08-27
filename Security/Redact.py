import os
import re
import csv
import sys
import argparse

# Constants
REDACTPY_VERSION = 0.1
IPADDR_REGEX = r"\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\b"

# Get the arguments that have been passed to the script
parser = argparse.ArgumentParser()
parser.add_argument("--file", "-f", help="Run against a single file", action="store", type=str)
parser.add_argument("--dir", "-d", help="Run against a whole directory", action="store", type=str)
parser.add_argument("--out", "-o", help="Output redactions to file", action="store", type=str)
parser.add_argument("--version", "-v", help="Get the current version number for Redact.py", action='store_true')

args = parser.parse_args()

# If they're asking for the version then lets deal with that now
if args.version:
    print("Redact.py is currently version %s"%REDACTPY_VERSION)
    sys.exit

# If the out file exists then ask to confirm if they want to overwrite it
if args.out:
    print(args.out)
    # The user would like an output file with all the redactions
    # Check if the file already exists.
    if os.path.isfile(args.out):
        # The file exists, ask to overwrite
        haveAnswer = False
        while not haveAnswer:
            text = input("The output file already exists. Do you wish to overwrite it? > ")
            print(text)
            if text in ("y" "n"):
                if text == "n":
                    haveAnswer = True
                    sys.exit

# If they're not asking for the version and we can write to out then let's get down to business
# Compile the regular expression. It's resource intensive so let's do it once
ipAddrRegex = re.compile(IPADDR_REGEX)

# Declare the dictionary
redactionDict = dict()

if args.file:
    # Check the file exists
    if not os.path.isfile(args.file):
        print("The specified file doesn't exist")
        sys.exit
    print("This is myprogram version 0.1" + args.file)
    redactionDict = replaceAllIPAddr(args.file, redactionDict)

if args.dir:
    # The user is looking to run Redact.py against a whole directory
    if not os.path.isdir(args.dir):
        print("The specified directory doesn't exist")
        sys.exit
    redactionDict = replaceAllIPAddrInDir(args.dir, redactionDict)

# Now we've run redact, save the output file if requested.
if args.out:
    with open(args.out, 'w') as f:
        f.write("IP Address,Replaced With")
        for key in redactionDict.keys():
            f.write("%s,%s\n"%(key,redactionDict[key]))

def replaceAllIPAddr(fileLocation, ipAddrDict):
    # Read in the content of the file
    with open(fileLocation, 'r') as file :
        inputString = file.read()

    # Find all IP addressses in the file
    matches = ipAddrRegex.findall(inputString)

    for match in matches:
        if match not in ipAddrDict:
            ipAddrDict[match] = "IP" + str(len(ipAddrDict))

        inputString = inputString.replace(match, "["+ipAddrDict[match]+"]")
    
    with open(fileLocation, 'w') as file:
        file.write(inputString)

    return ipAddrDict

def replaceAllIPAddrInDir(dirName, ipAddrDict):
    # Use os.walk to yield a collection of directories and files
    for root, dirs, files in os.walk(dirName):
    for name in files:
        ipAddrDict = replaceAllIPAddr(os.path.join(root,name), ipAddrDict)
    for name in dirs:
        # Such recursion 
        ipAddrDict = replaceAllIPAddrInDir(os.path.join(root, name), ipAddrDict)
    return ipAddrDict