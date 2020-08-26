import re
import argparse

# Constant
# We could use a much better regex that wouldn't match 999.999.999.999
# but let's go with this one for the moment.
IPADDR_REGEX = r"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"

# Get the arguments that have been passed to the script
#https://stackabuse.com/command-line-arguments-in-python/
parser = argparse.ArgumentParser()
parser.add_argument("--version", "-v", help="Show program version", action="store_true")
parser.add_argument("--file", "-f", help="Run against a single file", action="store")
parser.add_argument("--dir", "-d", help="Run against a whole directory", action="store")
parser.add_argument("--out", "-o", help="Output redactions to file", action="store")

args = parser.parse_args()

if args.version:
    print("This is myprogram version 0.1")
if args.help:
    print("This is where the help would go")


def replaceAllIPAddr(fileLocation, ipAddrDict):
    # Create Regex
    ipAddrRegex = re.compile(IPADDR_REGEX)

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


ipAddrDict = dict()
fileLocation = r"C:\Users\satal\Downloads\test.txt"

#ipAddrDict = replaceAllIPAddr(fileLocation, ipAddrDict)

#for keys,values in ipAddrDict.items():
#    print(keys)
#    print(values)